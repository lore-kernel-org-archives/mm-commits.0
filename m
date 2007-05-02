From: akpm@linux-foundation.org
Subject: + powerpc-minor-fault-path-optimization.patch added to -mm tree
Date: Tue, 01 May 2007 17:37:05 -0700
Message-ID: <200705020037.l420b5eu010300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992571AbXEBAma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@infradead.org, hch@lst.de


The patch titled
     powerpc: minor fault path optimization
has been added to the -mm tree.  Its filename is
     powerpc-minor-fault-path-optimization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: minor fault path optimization
From: Christoph Hellwig <hch@infradead.org>

Call the kprobes pagefault handler directly instead of going through
the complex notifier chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/kprobes.c |   10 --------
 arch/powerpc/mm/fault.c       |   40 +++++++++++---------------------
 include/asm-powerpc/kdebug.h  |   17 +++++++++++--
 include/asm-powerpc/kprobes.h |    1 
 4 files changed, 30 insertions(+), 38 deletions(-)

diff -puN arch/powerpc/kernel/kprobes.c~powerpc-minor-fault-path-optimization arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~powerpc-minor-fault-path-optimization
+++ a/arch/powerpc/kernel/kprobes.c
@@ -410,7 +410,7 @@ out:
 	return 1;
 }
 
-static int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -495,14 +495,6 @@ int __kprobes kprobe_exceptions_notify(s
 		if (post_kprobe_handler(args->regs))
 			ret = NOTIFY_STOP;
 		break;
-	case DIE_PAGE_FAULT:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		preempt_enable();
-		break;
 	default:
 		break;
 	}
diff -puN arch/powerpc/mm/fault.c~powerpc-minor-fault-path-optimization arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~powerpc-minor-fault-path-optimization
+++ a/arch/powerpc/mm/fault.c
@@ -39,37 +39,26 @@
 #include <asm/kdebug.h>
 #include <asm/siginfo.h>
 
-#ifdef CONFIG_KPROBES
-ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
 
-/* Hook to register for page fault notifications */
-int register_page_fault_notifier(struct notifier_block *nb)
+#ifdef CONFIG_KPROBES
+static inline int notify_page_fault(struct pt_regs *regs)
 {
-	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
-}
+	int ret = 0;
 
-int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
-}
+	/* kprobe_running() needs smp_processor_id() */
+	if (!user_mode(regs)) {
+		preempt_disable();
+		if (kprobe_running() && kprobe_fault_handler(regs, 11))
+			ret = 1;
+		preempt_enable();
+	}
 
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
-{
-	struct die_args args = {
-		.regs = regs,
-		.str = str,
-		.err = err,
-		.trapnr = trap,
-		.signr = sig
-	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	return ret;
 }
 #else
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs)
 {
-	return NOTIFY_DONE;
+	return 0;
 }
 #endif
 
@@ -175,8 +164,7 @@ int __kprobes do_page_fault(struct pt_re
 	is_write = error_code & ESR_DST;
 #endif /* CONFIG_4xx || CONFIG_BOOKE */
 
-	if (notify_page_fault(DIE_PAGE_FAULT, "page_fault", regs, error_code,
-				11, SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs))
 		return 0;
 
 	if (trap == 0x300) {
diff -puN include/asm-powerpc/kdebug.h~powerpc-minor-fault-path-optimization include/asm-powerpc/kdebug.h
--- a/include/asm-powerpc/kdebug.h~powerpc-minor-fault-path-optimization
+++ a/include/asm-powerpc/kdebug.h
@@ -18,8 +18,20 @@ struct die_args {
 
 extern int register_die_notifier(struct notifier_block *);
 extern int unregister_die_notifier(struct notifier_block *);
-extern int register_page_fault_notifier(struct notifier_block *);
-extern int unregister_page_fault_notifier(struct notifier_block *);
+
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation.  Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 extern struct atomic_notifier_head powerpc_die_chain;
 
 /* Grossly misnamed. */
@@ -29,7 +41,6 @@ enum die_val {
 	DIE_DABR_MATCH,
 	DIE_BPT,
 	DIE_SSTEP,
-	DIE_PAGE_FAULT,
 };
 
 static inline int notify_die(enum die_val val,char *str,struct pt_regs *regs,long err,int trap, int sig)
diff -puN include/asm-powerpc/kprobes.h~powerpc-minor-fault-path-optimization include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~powerpc-minor-fault-path-optimization
+++ a/include/asm-powerpc/kprobes.h
@@ -110,5 +110,6 @@ struct kprobe_ctlblk {
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 					unsigned long val, void *data);
+extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_KPROBES_H */
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
powerpc-minor-fault-path-optimization.patch
dvb_en_50221-convert-to-kthread-api.patch
git-nfs-server-cluster-locking-api.patch
remove-pci_dac_dma_-apis.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
consolidate-generic_writepages-and-mpage_writepages.patch
udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
