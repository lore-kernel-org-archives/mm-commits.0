From: akpm@linux-foundation.org
Subject: + kprobes-move-export_symbol_gpl-just-after-function-definitions.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:55:50 -0800
Message-ID: <200901132255.n0DMtoQr022619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbZAMW4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:56:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net


The patch titled
     kprobes: move EXPORT_SYMBOL_GPL just after function definitions
has been added to the -mm tree.  Its filename is
     kprobes-move-export_symbol_gpl-just-after-function-definitions.patch

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
Subject: kprobes: move EXPORT_SYMBOL_GPL just after function definitions
From: Masami Hiramatsu <mhiramat@redhat.com>

Clean up positions of EXPORT_SYMBOL_GPL in kernel/kprobes.c according to
checkpatch.pl.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN kernel/kprobes.c~kprobes-move-export_symbol_gpl-just-after-function-definitions kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-move-export_symbol_gpl-just-after-function-definitions
+++ a/kernel/kprobes.c
@@ -718,6 +718,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobe);
 
 /*
  * Unregister a kprobe without a scheduler synchronization.
@@ -796,11 +797,13 @@ int __kprobes register_kprobes(struct kp
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobes);
 
 void __kprobes unregister_kprobe(struct kprobe *p)
 {
 	unregister_kprobes(&p, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobe);
 
 void __kprobes unregister_kprobes(struct kprobe **kps, int num)
 {
@@ -819,6 +822,7 @@ void __kprobes unregister_kprobes(struct
 		if (kps[i]->addr)
 			__unregister_kprobe_bottom(kps[i]);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
@@ -858,16 +862,19 @@ int __kprobes register_jprobes(struct jp
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_jprobes);
 
 int __kprobes register_jprobe(struct jprobe *jp)
 {
 	return register_jprobes(&jp, 1);
 }
+EXPORT_SYMBOL_GPL(register_jprobe);
 
 void __kprobes unregister_jprobe(struct jprobe *jp)
 {
 	unregister_jprobes(&jp, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_jprobe);
 
 void __kprobes unregister_jprobes(struct jprobe **jps, int num)
 {
@@ -887,6 +894,7 @@ void __kprobes unregister_jprobes(struct
 			__unregister_kprobe_bottom(&jps[i]->kp);
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_jprobes);
 
 #ifdef CONFIG_KRETPROBES
 /*
@@ -982,6 +990,7 @@ int __kprobes register_kretprobe(struct 
 		free_rp_inst(rp);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);
 
 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
@@ -999,11 +1008,13 @@ int __kprobes register_kretprobes(struct
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobes);
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 	unregister_kretprobes(&rp, 1);
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
@@ -1025,24 +1036,30 @@ void __kprobes unregister_kretprobes(str
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
 #else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);
 
 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(register_kretprobes);
+
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
 }
+EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
 static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 					   struct pt_regs *regs)
@@ -1409,16 +1426,5 @@ late_initcall(debugfs_kprobe_init);
 
 module_init(init_kprobes);
 
-EXPORT_SYMBOL_GPL(register_kprobe);
-EXPORT_SYMBOL_GPL(unregister_kprobe);
-EXPORT_SYMBOL_GPL(register_kprobes);
-EXPORT_SYMBOL_GPL(unregister_kprobes);
-EXPORT_SYMBOL_GPL(register_jprobe);
-EXPORT_SYMBOL_GPL(unregister_jprobe);
-EXPORT_SYMBOL_GPL(register_jprobes);
-EXPORT_SYMBOL_GPL(unregister_jprobes);
+/* defined in arch/.../kernel/kprobes.c */
 EXPORT_SYMBOL_GPL(jprobe_return);
-EXPORT_SYMBOL_GPL(register_kretprobe);
-EXPORT_SYMBOL_GPL(unregister_kretprobe);
-EXPORT_SYMBOL_GPL(register_kretprobes);
-EXPORT_SYMBOL_GPL(unregister_kretprobes);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
linux-next.patch
kprobes-cleanup-aggr_kprobe-related-code.patch
kprobes-move-export_symbol_gpl-just-after-function-definitions.patch
kprobes-cleanup-comment-style-in-kprobesh.patch
kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch
kprobes-support-per-kprobe-disabling.patch
kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch

