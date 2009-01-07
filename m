From: akpm@linux-foundation.org
Subject: - module-add-module_state_live-notify.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:10 -0800
Message-ID: <200901072218.n07MIAWY017674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763404AbZAGWh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     module: add MODULE_STATE_LIVE notify
has been removed from the -mm tree.  Its filename was
     module-add-module_state_live-notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2352,6 +2352,8 @@ sys_init_module(void __user *umod,
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

