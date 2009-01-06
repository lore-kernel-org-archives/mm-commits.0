From: akpm@linux-foundation.org
Subject: - kprobes-support-probing-module-__exit-function-fix-3.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:35:08 -0800
Message-ID: <200901062035.n06KZ8rp028828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbZAFUf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     bugfix: release old_p's insn_slot before error return
has been removed from the -mm tree.  Its filename was
     kprobes-support-probing-module-__exit-function-fix-3.patch

This patch was dropped because it was folded into kprobes-support-probing-module-__exit-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix: release old_p's insn_slot before error return
From: Masami Hiramatsu <mhiramat@redhat.com>

Release old_p->ainsn.insn_slot before error return, if the memory
allocation of new aggr_kprobe is failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-support-probing-module-__exit-function-fix-3 kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-support-probing-module-__exit-function-fix-3
+++ a/kernel/kprobes.c
@@ -584,8 +584,11 @@ static int __kprobes register_aggr_kprob
 		ap = old_p;
 	} else {
 		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
-		if (!ap)
+		if (!ap) {
+			if (kprobe_gone(old_p))
+				arch_remove_kprobe(old_p);
 			return -ENOMEM;
+		}
 		add_aggr_kprobe(ap, old_p);
 		copy_kprobe(ap, p);
 		ret = add_new_kprobe(ap, p);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-support-probing-module-__exit-function-fix-3.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

