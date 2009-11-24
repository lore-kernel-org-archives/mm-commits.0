From: akpm@linux-foundation.org
Subject: + x86-uv-implement-a-gru_read_gpa-kernel-function.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:41:36 -0800
Message-ID: <200911241941.nAOJfbo6010444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758135AbZKXTlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:41:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, akpm@linux-foundation.org, mingo@elte.hu, steiner@sgi.com


The patch titled
     X86: uv: implement a gru_read_gpa kernel function
has been added to the -mm tree.  Its filename is
     x86-uv-implement-a-gru_read_gpa-kernel-function.patch

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
Subject: X86: uv: implement a gru_read_gpa kernel function
From: Robin Holt <holt@sgi.com>

The BIOS has decided to store a pointer to the partition reserved page in
a scratch MMR.  The GRU is only able to read an MMR using a vload
instruction.  The gru_read_gpa() function will implemented.

To: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |   13 ++++++++++++
 drivers/misc/sgi-gru/grukservices.c     |   23 ++++++++++++++++++++++
 drivers/misc/sgi-gru/grukservices.h     |   14 +++++++++++++
 drivers/misc/sgi-gru/gruprocfs.c        |    1 
 drivers/misc/sgi-gru/grutables.h        |    1 
 5 files changed, 52 insertions(+)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~x86-uv-implement-a-gru_read_gpa-kernel-function drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~x86-uv-implement-a-gru_read_gpa-kernel-function
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -340,6 +340,19 @@ static inline void gru_start_instruction
  *     	- nelem and stride are in elements
  *     	- tri0/tri1 is in bytes for the beginning of the data segment.
  */
+static inline void gru_vload_phys(void *cb, unsigned long gpa,
+		unsigned int tri0, int iaa, unsigned long hints)
+{
+	struct gru_instruction *ins = (struct gru_instruction *)cb;
+
+	ins->baddr0 = (long)gpa | ((unsigned long)iaa << 62);
+	ins->nelem = 1;
+	ins->tri0 = tri0;
+	ins->op1_stride = 1;
+	gru_start_instruction(ins, __opword(OP_VLOAD, 0, XTYPE_DW, iaa, 0,
+					CB_IMA(hints)));
+}
+
 static inline void gru_vload(void *cb, unsigned long mem_addr,
 		unsigned int tri0, unsigned char xtype, unsigned long nelem,
 		unsigned long stride, unsigned long hints)
diff -puN drivers/misc/sgi-gru/grukservices.c~x86-uv-implement-a-gru_read_gpa-kernel-function drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~x86-uv-implement-a-gru_read_gpa-kernel-function
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -858,6 +858,29 @@ EXPORT_SYMBOL_GPL(gru_get_next_message);
 /* ---------------------- GRU DATA COPY FUNCTIONS ---------------------------*/
 
 /*
+ * Load a DW from a global GPA. The GPA can be a memory or MMR address.
+ */
+int gru_read_gpa(unsigned long *value, unsigned long gpa)
+{
+	void *cb;
+	void *dsr;
+	int ret, iaa;
+
+	STAT(read_gpa);
+	if (gru_get_cpu_resources(GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr))
+		return MQE_BUG_NO_RESOURCES;
+	iaa = gpa >> 62;
+	gru_vload_phys(cb, gpa, gru_get_tri(dsr), iaa, IMA);
+	ret = gru_wait(cb);
+	if (ret == CBS_IDLE)
+		*value = *(unsigned long *)dsr;
+	gru_free_cpu_resources(cb, dsr);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gru_read_gpa);
+
+
+/*
  * Copy a block of data using the GRU resources
  */
 int gru_copy_gpa(unsigned long dest_gpa, unsigned long src_gpa,
diff -puN drivers/misc/sgi-gru/grukservices.h~x86-uv-implement-a-gru_read_gpa-kernel-function drivers/misc/sgi-gru/grukservices.h
--- a/drivers/misc/sgi-gru/grukservices.h~x86-uv-implement-a-gru_read_gpa-kernel-function
+++ a/drivers/misc/sgi-gru/grukservices.h
@@ -131,6 +131,20 @@ extern void *gru_get_next_message(struct
 
 
 /*
+ * Read a GRU global GPA. Source can be located in a remote partition.
+ *
+ *    Input:
+ *    	value		memory address where MMR value is returned
+ *    	gpa		source numalink physical address of GPA
+ *
+ *    Output:
+ *	0		OK
+ *	>0		error
+ */
+int gru_read_gpa(unsigned long *value, unsigned long gpa);
+
+
+/*
  * Copy data using the GRU. Source or destination can be located in a remote
  * partition.
  *
diff -puN drivers/misc/sgi-gru/gruprocfs.c~x86-uv-implement-a-gru_read_gpa-kernel-function drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~x86-uv-implement-a-gru_read_gpa-kernel-function
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -98,6 +98,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, flush_tlb_gru_tgh);
 	printstat(s, flush_tlb_gru_zero_asid);
 	printstat(s, copy_gpa);
+	printstat(s, read_gpa);
 	printstat(s, mesq_receive);
 	printstat(s, mesq_receive_none);
 	printstat(s, mesq_send);
diff -puN drivers/misc/sgi-gru/grutables.h~x86-uv-implement-a-gru_read_gpa-kernel-function drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~x86-uv-implement-a-gru_read_gpa-kernel-function
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -224,6 +224,7 @@ struct gru_stats_s {
 	atomic_long_t flush_tlb_gru_zero_asid;
 
 	atomic_long_t copy_gpa;
+	atomic_long_t read_gpa;
 
 	atomic_long_t mesq_receive;
 	atomic_long_t mesq_receive_none;
_

Patches currently in -mm which might be from holt@sgi.com are

x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch

