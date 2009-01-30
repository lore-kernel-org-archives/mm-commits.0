From: akpm@linux-foundation.org
Subject: [merged] kprobes-fix-module-compilation-error-with-config_kprobes=n.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:40 -0800
Message-ID: <200901301913.n0UJDeob026359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbZA3TO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: fix module compilation error with CONFIG_KPROBES=n
has been removed from the -mm tree.  Its filename was
     kprobes-fix-module-compilation-error-with-config_kprobes=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: fix module compilation error with CONFIG_KPROBES=n
From: Masami Hiramatsu <mhiramat@redhat.com>

Define kprobes related data structures even if CONFIG_KPROBES is not set. 
This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
kprobe using modules.

[akpm@linux-foundation.org: fix build for non-kprobes-supporting architectures]
Reviewed-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |   47 +++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-fix-module-compilation-error-with-config_kprobes=n include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-fix-module-compilation-error-with-config_kprobes=n
+++ a/include/linux/kprobes.h
@@ -49,6 +49,13 @@
 
 /* Attach to insert probes on any functions which should be ignored*/
 #define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
+#else /* CONFIG_KPROBES */
+typedef int kprobe_opcode_t;
+struct arch_specific_insn {
+	int dummy;
+};
+#define __kprobes	notrace
+#endif /* CONFIG_KPROBES */
 
 struct kprobe;
 struct pt_regs;
@@ -131,23 +138,6 @@ struct jprobe {
 /* For backward compatibility with old code using JPROBE_ENTRY() */
 #define JPROBE_ENTRY(handler)	(handler)
 
-DECLARE_PER_CPU(struct kprobe *, current_kprobe);
-DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-#ifdef CONFIG_KRETPROBES
-extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				   struct pt_regs *regs);
-extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* CONFIG_KRETPROBES */
-static inline void arch_prepare_kretprobe(struct kretprobe *rp,
-					struct pt_regs *regs)
-{
-}
-static inline int arch_trampoline_kprobe(struct kprobe *p)
-{
-	return 0;
-}
-#endif /* CONFIG_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
@@ -188,6 +178,25 @@ struct kprobe_blackpoint {
 	unsigned long range;
 };
 
+#ifdef CONFIG_KPROBES
+DECLARE_PER_CPU(struct kprobe *, current_kprobe);
+DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+#ifdef CONFIG_KRETPROBES
+extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				   struct pt_regs *regs);
+extern int arch_trampoline_kprobe(struct kprobe *p);
+#else /* CONFIG_KRETPROBES */
+static inline void arch_prepare_kretprobe(struct kretprobe *rp,
+					struct pt_regs *regs)
+{
+}
+static inline int arch_trampoline_kprobe(struct kprobe *p)
+{
+	return 0;
+}
+#endif /* CONFIG_KRETPROBES */
+
 extern struct kretprobe_blackpoint kretprobe_blacklist[];
 
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
@@ -264,10 +273,6 @@ void recycle_rp_inst(struct kretprobe_in
 
 #else /* CONFIG_KPROBES */
 
-#define __kprobes	notrace
-struct jprobe;
-struct kretprobe;
