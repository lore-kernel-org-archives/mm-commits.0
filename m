From: akpm@linux-foundation.org
Subject: - kprobes-support-probing-module-__exit-function-fix-2.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:35:05 -0800
Message-ID: <200901062035.n06KZ5cq028743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZAFUf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     bugfix: pass aggr_kprobe to arch_remove_kprobe
has been removed from the -mm tree.  Its filename was
     kprobes-support-probing-module-__exit-function-fix-2.patch

This patch was dropped because it was folded into kprobes-support-probing-module-__exit-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix: pass aggr_kprobe to arch_remove_kprobe
From: Masami Hiramatsu <mhiramat@redhat.com>

akpm@linux-foundation.org wrote:
> The patch titled
>      kprobes: support probing module __exit function
> has been added to the -mm tree.  Its filename is
>      kprobes-support-probing-module-__exit-function.patch

Call arch_remove_kprobe() with aggr_kprobe instead of user specific kprobe,
because the user specific kprobe on the gone or reused aggr_kprobe may have
invalid arch_specific_insn.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/kprobes.c~kprobes-support-probing-module-__exit-function-fix-2 kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-support-probing-module-__exit-function-fix-2
+++ a/kernel/kprobes.c
@@ -762,14 +762,14 @@ static void __kprobes __unregister_kprob
 {
 	struct kprobe *old_p;
 
-	if (list_empty(&p->list) || list_is_singular(&p->list)) {
-		if (!list_empty(&p->list)) {
-			/* "p" is the last child of an aggr_kprobe */
-			old_p = list_entry(p->list.next, struct kprobe, list);
-			list_del(&p->list);
-			kfree(old_p);
-		}
+	if (list_empty(&p->list))
 		arch_remove_kprobe(p);
+	else if (list_is_singular(&p->list)) {
+		/* "p" is the last child of an aggr_kprobe */
+		old_p = list_entry(p->list.next, struct kprobe, list);
+		list_del(&p->list);
+		arch_remove_kprobe(old_p);
+		kfree(old_p);
 	}
 }
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
kprobes-support-probing-module-__exit-function-fix-3.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

