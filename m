From: akpm@linux-foundation.org
Subject: - jprobes-remove-jprobe_entry.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:37 -0700
Message-ID: <200707192001.l6JK1bB8019554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbXGSUb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jprobes: remove JPROBE_ENTRY()
has been removed from the -mm tree.  Its filename was
     jprobes-remove-jprobe_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jprobes: remove JPROBE_ENTRY()
From: Michael Ellerman <michael@ellerman.id.au>

AFAICT now that jprobe.entry is a void *, JPROBE_ENTRY doesn't do anything
useful - so remove it ..

I've left a do-nothing version so that out-of-tree jprobes code will still
compile without modifications.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt     |    8 +-------
 include/asm-i386/kprobes.h    |    1 -
 include/asm-ia64/kprobes.h    |    2 --
 include/asm-powerpc/kprobes.h |    2 --
 include/asm-s390/kprobes.h    |    2 --
 include/asm-sparc64/kprobes.h |    1 -
 include/asm-x86_64/kprobes.h  |    1 -
 include/linux/kprobes.h       |    3 +++
 net/dccp/probe.c              |    2 +-
 net/ipv4/tcp_probe.c          |    2 +-
 10 files changed, 6 insertions(+), 18 deletions(-)

diff -puN Documentation/kprobes.txt~jprobes-remove-jprobe_entry Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~jprobes-remove-jprobe_entry
+++ a/Documentation/kprobes.txt
@@ -247,12 +247,6 @@ control to Kprobes.)  If the probed func
 fastcall, or anything else that affects how args are passed, the
 handler's declaration must match.
 
-NOTE: A macro JPROBE_ENTRY is provided to handle architecture-specific
-aliasing of jp->entry. In the interest of portability, it is advised
-to use:
-
-	jp->entry = JPROBE_ENTRY(handler);
-
 register_jprobe() returns 0 on success, or a negative errno otherwise.
 
 4.3 register_kretprobe
@@ -518,7 +512,7 @@ long jdo_fork(unsigned long clone_flags,
 }
 
 static struct jprobe my_jprobe = {
-	.entry = JPROBE_ENTRY(jdo_fork)
+	.entry = jdo_fork
 };
 
 static int __init jprobe_init(void)
diff -puN include/asm-i386/kprobes.h~jprobes-remove-jprobe_entry include/asm-i386/kprobes.h
--- a/include/asm-i386/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/asm-i386/kprobes.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)pentry
 #define ARCH_SUPPORTS_KRETPROBES
 #define  ARCH_INACTIVE_KPROBE_COUNT 0
 #define flush_insn_slot(p)	do { } while (0)
diff -puN include/asm-ia64/kprobes.h~jprobes-remove-jprobe_entry include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/asm-ia64/kprobes.h
@@ -82,8 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)pentry
-
 #define ARCH_SUPPORTS_KRETPROBES
 #define  ARCH_INACTIVE_KPROBE_COUNT 1
 
diff -puN include/asm-powerpc/kprobes.h~jprobes-remove-jprobe_entry include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/asm-powerpc/kprobes.h
@@ -73,12 +73,10 @@ typedef unsigned int kprobe_opcode_t;
 	}								\
 }
 
-#define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)((func_descr_t *)pentry)
 #define is_trap(instr)	(IS_TW(instr) || IS_TD(instr) || \
 			IS_TWI(instr) || IS_TDI(instr))
 #else
 /* Use stock kprobe_lookup_name since ppc32 doesn't use function descriptors */
-#define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)(pentry)
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
diff -puN include/asm-s390/kprobes.h~jprobes-remove-jprobe_entry include/asm-s390/kprobes.h
--- a/include/asm-s390/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/asm-s390/kprobes.h
@@ -46,8 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define JPROBE_ENTRY(pentry) (kprobe_opcode_t *)(pentry)
-
 #define ARCH_SUPPORTS_KRETPROBES
 #define ARCH_INACTIVE_KPROBE_COUNT 0
 
diff -puN include/asm-sparc64/kprobes.h~jprobes-remove-jprobe_entry include/asm-sparc64/kprobes.h
--- a/include/asm-sparc64/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/asm-sparc64/kprobes.h
@@ -10,7 +10,6 @@ typedef u32 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION_2 0x91d02071 /* ta 0x71 */
 #define MAX_INSN_SIZE 2
 
-#define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)pentry
 #define arch_remove_kprobe(p)	do {} while (0)
 #define  ARCH_INACTIVE_KPROBE_COUNT 0
 
diff -puN include/asm-x86_64/kprobes.h~jprobes-remove-jprobe_entry include/asm-x86_64/kprobes.h
--- a/include/asm-x86_64/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/asm-x86_64/kprobes.h
@@ -41,7 +41,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)pentry
 #define ARCH_SUPPORTS_KRETPROBES
 #define  ARCH_INACTIVE_KPROBE_COUNT 1
 
diff -puN include/linux/kprobes.h~jprobes-remove-jprobe_entry include/linux/kprobes.h
--- a/include/linux/kprobes.h~jprobes-remove-jprobe_entry
+++ a/include/linux/kprobes.h
@@ -119,6 +119,9 @@ struct jprobe {
 	void *entry;	/* probe handling code to jump to */
 };
 
+/* For backward compatibility with old code using JPROBE_ENTRY() */
+#define JPROBE_ENTRY(handler)	(handler)
+
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
diff -puN net/dccp/probe.c~jprobes-remove-jprobe_entry net/dccp/probe.c
--- a/net/dccp/probe.c~jprobes-remove-jprobe_entry
+++ a/net/dccp/probe.c
@@ -112,7 +112,7 @@ static struct jprobe dccp_send_probe = {
 	.kp	= {
 		.symbol_name = "dccp_sendmsg",
 	},
-	.entry	= JPROBE_ENTRY(jdccp_sendmsg),
+	.entry	= jdccp_sendmsg,
 };
 
 static int dccpprobe_open(struct inode *inode, struct file *file)
diff -puN net/ipv4/tcp_probe.c~jprobes-remove-jprobe_entry net/ipv4/tcp_probe.c
--- a/net/ipv4/tcp_probe.c~jprobes-remove-jprobe_entry
+++ a/net/ipv4/tcp_probe.c
@@ -130,7 +130,7 @@ static struct jprobe tcp_jprobe = {
 	.kp = {
 		.symbol_name	= "tcp_rcv_established",
 	},
-	.entry	= JPROBE_ENTRY(jtcp_rcv_established),
+	.entry	= jtcp_rcv_established,
 };
 
 static int tcpprobe_open(struct inode * inode, struct file * file)
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
