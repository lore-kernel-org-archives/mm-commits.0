From: akpm@linux-foundation.org
Subject: [merged] kprobes-move-export_symbol_gpl-just-after-function-definitions.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:18 -0700
Message-ID: <200904071907.n37J7I64011260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbZDGTs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     kprobes: move EXPORT_SYMBOL_GPL just after function definitions
has been removed from the -mm tree.  Its filename was
     kprobes-move-export_symbol_gpl-just-after-function-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -722,6 +722,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kprobe);
 
 /*
  * Unregister a kprobe without a scheduler synchronization.
@@ -803,11 +804,13 @@ int __kprobes register_kprobes(struct kp
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
@@ -826,6 +829,7 @@ void __kprobes unregister_kprobes(struct
 		if (kps[i]->addr)
 			__unregister_kprobe_bottom(kps[i]);
 }
+EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
@@ -865,16 +869,19 @@ int __kprobes register_jprobes(struct jp
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
@@ -894,6 +901,7 @@ void __kprobes unregister_jprobes(struct
 			__unregister_kprobe_bottom(&jps[i]->kp);
 	}
 }
+EXPORT_SYMBOL_GPL(unregister_jprobes);
 
 #ifdef CONFIG_KRETPROBES
 /*
@@ -987,6 +995,7 @@ int __kprobes register_kretprobe(struct 
 		free_rp_inst(rp);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_kretprobe);
 
 int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
@@ -1004,11 +1013,13 @@ int __kprobes register_kretprobes(struct
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
@@ -1030,24 +1041,30 @@ void __kprobes unregister_kretprobes(str
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
@@ -1418,16 +1435,5 @@ late_initcall(debugfs_kprobe_init);
 
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

origin.patch

