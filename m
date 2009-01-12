From: akpm@linux-foundation.org
Subject: + kprobes-fix-module-compilation-error-with-config_kprobes=n.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:50:48 -0800
Message-ID: <200901122250.n0CMomYO014524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbZALXAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 18:00:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com


The patch titled
     kprobes: fix module compilation error with CONFIG_KPROBES=n
has been added to the -mm tree.  Its filename is
     kprobes-fix-module-compilation-error-with-config_kprobes=n.patch

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
Subject: kprobes: fix module compilation error with CONFIG_KPROBES=n
From: Masami Hiramatsu <mhiramat@redhat.com>

Define kprobes related data structures even if CONFIG_KPROBES is not set. 
This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
kprobe using modules.

Reviewed-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |   45 +++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-fix-module-compilation-error-with-config_kprobes=n include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-fix-module-compilation-error-with-config_kprobes=n
+++ a/include/linux/kprobes.h
@@ -37,9 +37,9 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <asm/kprobes.h>
 
 #ifdef CONFIG_KPROBES
-#include <asm/kprobes.h>
 
 /* kprobe_status settings */
 #define KPROBE_HIT_ACTIVE	0x00000001
@@ -49,6 +49,9 @@
 
 /* Attach to insert probes on any functions which should be ignored*/
 #define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
+#else /* CONFIG_KPROBES */
+#define __kprobes	notrace
+#endif /* CONFIG_KPROBES */
 
 struct kprobe;
 struct pt_regs;
@@ -131,23 +134,6 @@ struct jprobe {
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
@@ -188,6 +174,25 @@ struct kprobe_blackpoint {
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
@@ -264,10 +269,6 @@ void recycle_rp_inst(struct kretprobe_in
 
 #else /* CONFIG_KPROBES */
 
-#define __kprobes	notrace
-struct jprobe;
-struct kretprobe;
