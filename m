From: akpm@linux-foundation.org
Subject: + gru-expicitly-set-instruction-status-to-active.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:40 -0800
Message-ID: <200911241958.nAOJweVg019305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932754AbZKXT6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: expicitly set instruction status to active
has been added to the -mm tree.  Its filename is
     gru-expicitly-set-instruction-status-to-active.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: expicitly set instruction status to active
From: Jack Steiner <steiner@sgi.com>

Explicitly set GRU instructions to "ACTIVE".  This eliminates the need for
barriers that would have been necessary to prevent reading the instruction
"status" field before the GRU had actually started the instruction.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |  119 ++++++++++++----------
 drivers/misc/sgi-gru/gruhandles.c       |    4 
 2 files changed, 67 insertions(+), 56 deletions(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-expicitly-set-instruction-status-to-active drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-expicitly-set-instruction-status-to-active
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -34,17 +34,17 @@ extern void gru_wait_abort_proc(void *cb
 #include <asm/intrinsics.h>
 #define __flush_cache(p)		ia64_fc((unsigned long)p)
 /* Use volatile on IA64 to ensure ordering via st4.rel */
-#define gru_ordered_store_int(p, v)					\
+#define gru_ordered_store_ulong(p, v)					\
 		do {							\
 			barrier();					\
-			*((volatile int *)(p)) = v; /* force st.rel */	\
+			*((volatile unsigned long *)(p)) = v; /* force st.rel */	\
 		} while (0)
 #elif defined(CONFIG_X86_64)
 #define __flush_cache(p)		clflush(p)
-#define gru_ordered_store_int(p, v)					\
+#define gru_ordered_store_ulong(p, v)					\
 		do {							\
 			barrier();					\
-			*(int *)p = v;					\
+			*(unsigned long *)p = v;			\
 		} while (0)
 #else
 #error "Unsupported architecture"
@@ -129,8 +129,13 @@ struct gru_instruction_bits {
  */
 struct gru_instruction {
     /* DW 0 */
-    unsigned int		op32;    /* icmd,xtype,iaa0,ima,opc */
-    unsigned int		tri0;
+    union {
+    	unsigned long		op64;    /* icmd,xtype,iaa0,ima,opc,tri0 */
+	struct {
+		unsigned int	op32;
+		unsigned int	tri0;
+	};
+    };
     unsigned long		tri1_bufsize;		/* DW 1 */
     unsigned long		baddr0;			/* DW 2 */
     unsigned long		nelem;			/* DW 3 */
@@ -140,7 +145,7 @@ struct gru_instruction {
     unsigned long		avalue;			/* DW 7 */
 };
 
-/* Some shifts and masks for the low 32 bits of a GRU command */
+/* Some shifts and masks for the low 64 bits of a GRU command */
 #define GRU_CB_ICMD_SHFT	0
 #define GRU_CB_ICMD_MASK	0x1
 #define GRU_CB_XTYPE_SHFT	8
@@ -155,6 +160,10 @@ struct gru_instruction {
 #define GRU_CB_OPC_MASK		0xff
 #define GRU_CB_EXOPC_SHFT	24
 #define GRU_CB_EXOPC_MASK	0xff
+#define GRU_IDEF2_SHFT		32
+#define GRU_IDEF2_MASK		0x3ffff
+#define GRU_ISTATUS_SHFT	56
+#define GRU_ISTATUS_MASK	0x3
 
 /* GRU instruction opcodes (opc field) */
 #define OP_NOP		0x00
@@ -296,12 +305,14 @@ union gru_mesqhead {
 
 
 /* Generate the low word of a GRU instruction */
-static inline unsigned int
-__opword(unsigned char opcode, unsigned char exopc, unsigned char xtype,
+static inline unsigned long
+__opdword(unsigned char opcode, unsigned char exopc, unsigned char xtype,
        unsigned char iaa0, unsigned char iaa1,
-       unsigned char ima)
+       unsigned long idef2, unsigned char ima)
 {
     return (1 << GRU_CB_ICMD_SHFT) |
+	   ((unsigned long)CBS_ACTIVE << GRU_ISTATUS_SHFT) |
+	   (idef2<< GRU_IDEF2_SHFT) |
 	   (iaa0 << GRU_CB_IAA0_SHFT) |
 	   (iaa1 << GRU_CB_IAA1_SHFT) |
 	   (ima << GRU_CB_IMA_SHFT) |
@@ -319,12 +330,12 @@ static inline void gru_flush_cache(void 
 }
 
 /*
- * Store the lower 32 bits of the command including the "start" bit. Then
+ * Store the lower 64 bits of the command including the "start" bit. Then
  * start the instruction executing.
  */
-static inline void gru_start_instruction(struct gru_instruction *ins, int op32)
+static inline void gru_start_instruction(struct gru_instruction *ins, unsigned long op64)
 {
-	gru_ordered_store_int(ins, op32);
+	gru_ordered_store_ulong(ins, op64);
 	mb();
 	gru_flush_cache(ins);
 }
@@ -348,10 +359,9 @@ static inline void gru_vload_phys(void *
 
 	ins->baddr0 = (long)gpa | ((unsigned long)iaa << 62);
 	ins->nelem = 1;
-	ins->tri0 = tri0;
 	ins->op1_stride = 1;
-	gru_start_instruction(ins, __opword(OP_VLOAD, 0, XTYPE_DW, iaa, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_VLOAD, 0, XTYPE_DW, iaa, 0,
+					(unsigned long)tri0, CB_IMA(hints)));
 }
 
 static inline void gru_vload(void *cb, unsigned long mem_addr,
@@ -362,10 +372,9 @@ static inline void gru_vload(void *cb, u
 
 	ins->baddr0 = (long)mem_addr;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
 	ins->op1_stride = stride;
-	gru_start_instruction(ins, __opword(OP_VLOAD, 0, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_VLOAD, 0, xtype, IAA_RAM, 0,
+					(unsigned long)tri0, CB_IMA(hints)));
 }
 
 static inline void gru_vstore(void *cb, unsigned long mem_addr,
@@ -376,10 +385,9 @@ static inline void gru_vstore(void *cb, 
 
 	ins->baddr0 = (long)mem_addr;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
 	ins->op1_stride = stride;
-	gru_start_instruction(ins, __opword(OP_VSTORE, 0, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_VSTORE, 0, xtype, IAA_RAM, 0,
+					tri0, CB_IMA(hints)));
 }
 
 static inline void gru_ivload(void *cb, unsigned long mem_addr,
@@ -390,10 +398,9 @@ static inline void gru_ivload(void *cb, 
 
 	ins->baddr0 = (long)mem_addr;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
 	ins->tri1_bufsize = tri1;
-	gru_start_instruction(ins, __opword(OP_IVLOAD, 0, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_IVLOAD, 0, xtype, IAA_RAM, 0,
+					tri0, CB_IMA(hints)));
 }
 
 static inline void gru_ivstore(void *cb, unsigned long mem_addr,
@@ -404,10 +411,9 @@ static inline void gru_ivstore(void *cb,
 
 	ins->baddr0 = (long)mem_addr;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
 	ins->tri1_bufsize = tri1;
-	gru_start_instruction(ins, __opword(OP_IVSTORE, 0, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_IVSTORE, 0, xtype, IAA_RAM, 0,
+					tri0, CB_IMA(hints)));
 }
 
 static inline void gru_vset(void *cb, unsigned long mem_addr,
@@ -420,8 +426,8 @@ static inline void gru_vset(void *cb, un
 	ins->op2_value_baddr1 = value;
 	ins->nelem = nelem;
 	ins->op1_stride = stride;
-	gru_start_instruction(ins, __opword(OP_VSET, 0, xtype, IAA_RAM, 0,
-					 CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_VSET, 0, xtype, IAA_RAM, 0,
+					 0, CB_IMA(hints)));
 }
 
 static inline void gru_ivset(void *cb, unsigned long mem_addr,
@@ -434,8 +440,8 @@ static inline void gru_ivset(void *cb, u
 	ins->op2_value_baddr1 = value;
 	ins->nelem = nelem;
 	ins->tri1_bufsize = tri1;
-	gru_start_instruction(ins, __opword(OP_IVSET, 0, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_IVSET, 0, xtype, IAA_RAM, 0,
+					0, CB_IMA(hints)));
 }
 
 static inline void gru_vflush(void *cb, unsigned long mem_addr,
@@ -447,15 +453,15 @@ static inline void gru_vflush(void *cb, 
 	ins->baddr0 = (long)mem_addr;
 	ins->op1_stride = stride;
 	ins->nelem = nelem;
-	gru_start_instruction(ins, __opword(OP_VFLUSH, 0, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_VFLUSH, 0, xtype, IAA_RAM, 0,
+					0, CB_IMA(hints)));
 }
 
 static inline void gru_nop(void *cb, int hints)
 {
 	struct gru_instruction *ins = (void *)cb;
 
-	gru_start_instruction(ins, __opword(OP_NOP, 0, 0, 0, 0, CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_NOP, 0, 0, 0, 0, 0, CB_IMA(hints)));
 }
 
 
@@ -469,10 +475,9 @@ static inline void gru_bcopy(void *cb, c
 	ins->baddr0 = (long)src;
 	ins->op2_value_baddr1 = (long)dest;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
 	ins->tri1_bufsize = bufsize;
-	gru_start_instruction(ins, __opword(OP_BCOPY, 0, xtype, IAA_RAM,
-					IAA_RAM, CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_BCOPY, 0, xtype, IAA_RAM,
+					IAA_RAM, tri0, CB_IMA(hints)));
 }
 
 static inline void gru_bstore(void *cb, const unsigned long src,
@@ -484,9 +489,8 @@ static inline void gru_bstore(void *cb, 
 	ins->baddr0 = (long)src;
 	ins->op2_value_baddr1 = (long)dest;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
-	gru_start_instruction(ins, __opword(OP_BSTORE, 0, xtype, 0, IAA_RAM,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_BSTORE, 0, xtype, 0, IAA_RAM,
+					tri0, CB_IMA(hints)));
 }
 
 static inline void gru_gamir(void *cb, int exopc, unsigned long src,
@@ -495,8 +499,8 @@ static inline void gru_gamir(void *cb, i
 	struct gru_instruction *ins = (void *)cb;
 
 	ins->baddr0 = (long)src;
-	gru_start_instruction(ins, __opword(OP_GAMIR, exopc, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_GAMIR, exopc, xtype, IAA_RAM, 0,
+					0, CB_IMA(hints)));
 }
 
 static inline void gru_gamirr(void *cb, int exopc, unsigned long src,
@@ -505,8 +509,8 @@ static inline void gru_gamirr(void *cb, 
 	struct gru_instruction *ins = (void *)cb;
 
 	ins->baddr0 = (long)src;
-	gru_start_instruction(ins, __opword(OP_GAMIRR, exopc, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_GAMIRR, exopc, xtype, IAA_RAM, 0,
+					0, CB_IMA(hints)));
 }
 
 static inline void gru_gamer(void *cb, int exopc, unsigned long src,
@@ -519,8 +523,8 @@ static inline void gru_gamer(void *cb, i
 	ins->baddr0 = (long)src;
 	ins->op1_stride = operand1;
 	ins->op2_value_baddr1 = operand2;
-	gru_start_instruction(ins, __opword(OP_GAMER, exopc, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_GAMER, exopc, xtype, IAA_RAM, 0,
+					0, CB_IMA(hints)));
 }
 
 static inline void gru_gamerr(void *cb, int exopc, unsigned long src,
@@ -532,8 +536,8 @@ static inline void gru_gamerr(void *cb, 
 	ins->baddr0 = (long)src;
 	ins->op1_stride = operand1;
 	ins->op2_value_baddr1 = operand2;
-	gru_start_instruction(ins, __opword(OP_GAMERR, exopc, xtype, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_GAMERR, exopc, xtype, IAA_RAM, 0,
+					0, CB_IMA(hints)));
 }
 
 static inline void gru_gamxr(void *cb, unsigned long src,
@@ -543,8 +547,8 @@ static inline void gru_gamxr(void *cb, u
 
 	ins->baddr0 = (long)src;
 	ins->nelem = 4;
-	gru_start_instruction(ins, __opword(OP_GAMXR, EOP_XR_CSWAP, XTYPE_DW,
-				 IAA_RAM, 0, CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_GAMXR, EOP_XR_CSWAP, XTYPE_DW,
+				 IAA_RAM, 0, 0, CB_IMA(hints)));
 }
 
 static inline void gru_mesq(void *cb, unsigned long queue,
@@ -555,9 +559,8 @@ static inline void gru_mesq(void *cb, un
 
 	ins->baddr0 = (long)queue;
 	ins->nelem = nelem;
-	ins->tri0 = tri0;
-	gru_start_instruction(ins, __opword(OP_MESQ, 0, XTYPE_CL, IAA_RAM, 0,
-					CB_IMA(hints)));
+	gru_start_instruction(ins, __opdword(OP_MESQ, 0, XTYPE_CL, IAA_RAM, 0,
+					tri0, CB_IMA(hints)));
 }
 
 static inline unsigned long gru_get_amo_value(void *cb)
@@ -676,6 +679,14 @@ static inline void gru_wait_abort(void *
 	gru_wait_abort_proc(cb);
 }
 
+/*
+ * Get a pointer to the start of a gseg
+ * 	p	- Any valid pointer within the gseg
+ */
+static inline void *gru_get_gseg_pointer (void *p)
+{
+	return (void *)((unsigned long)p & ~(GRU_GSEG_PAGESIZE - 1));
+}
 
 /*
  * Get a pointer to a control block
diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-expicitly-set-instruction-status-to-active drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-expicitly-set-instruction-status-to-active
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -54,8 +54,8 @@ static void start_instruction(void *h)
 {
 	unsigned long *w0 = h;
 
-	wmb();		/* setting CMD bit must be last */
-	*w0 = *w0 | 1;
+	wmb();		/* setting CMD/STATUS bits must be last */
+	*w0 = *w0 | 0x20001;
 	gru_flush_cache(h);
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch
gru-initial-gru-based-on-blade-topology.patch
gru-add-comments-raised-in-previous-code-reviews.patch
gru-fix-istatus-race-in-gru-tlb-dropin.patch
gru-handle-blades-without-memory.patch
gru-allow-users-to-specify-gru-chiplet-1.patch
gru-allow-users-to-specify-gru-chiplet-2.patch
gru-allow-users-to-specify-gru-chiplet-3.patch
gru-fix-bug-in-module-unload.patch
gru-improve-messages-for-malfunctioning-grus.patch
gru-support-64-bit-gru-addresses.patch
gru-handle-failures-to-mmu_notifier_register.patch
gru-add-debug-option-for-cache-flushing.patch
gru-add-test-for-gru_copy_gpa.patch
gru-check-for-valid-vma.patch
gru-fix-prefetch-and-speculation-bugs.patch
gru-update-irq-infrastructure.patch
gru-add-additional-gru-statistics.patch
gru-expicitly-set-instruction-status-to-active.patch
gru-preload-tlb-for-bcopy-instructions.patch
gru-fix-bug-in-exception-handling.patch
gru-add-symbolic-names-for-gru-error-code.patch
gru-remove-stray-local_irq_enable.patch
gru-check-for-correct-gru-chiplet-assignment.patch
gru-update-gru-structures-to-match-latest-hardware-spec.patch
gru-fix-bug-in-allocation-of-kernel-contexts.patch
gru-add-hugepage-support.patch
gru-fix-gru-interrupt-race-at-deallocate.patch
gru-improve-gru-tlb-dropin-statistics.patch
gru-update-driver-version-number.patch

