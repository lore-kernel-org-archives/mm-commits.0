From: akpm@linux-foundation.org
Subject: + module-add-module_state_live-notify.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:28:58 -0800
Message-ID: <200811140028.mAE0Swg3021534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbYKNAf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:35:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, rusty@rustcorp.com.au


The patch titled
     module: add MODULE_STATE_LIVE notify
has been added to the -mm tree.  Its filename is
     module-add-module_state_live-notify.patch

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
Subject: module: add MODULE_STATE_LIVE notify
From: Masami Hiramatsu <mhiramat@redhat.com>

Add a module notifier call which notifies that the state of a module
changes from MODULE_STATE_COMING to MODULE_STATE_LIVE.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/module.c~module-add-module_state_live-notify kernel/module.c
--- a/kernel/module.c~module-add-module_state_live-notify
+++ a/kernel/module.c
@@ -2182,6 +2182,8 @@ sys_init_module(void __user *umod,
 	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
 	mod->state = MODULE_STATE_LIVE;
 	wake_up(&module_wq);
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_LIVE, mod);
 
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

