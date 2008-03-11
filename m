From: akpm@linux-foundation.org
Subject: - modules-fix-module-waiting-for-dependent-modules-init.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:24 -0700
Message-ID: <200803110322.m2B3MOB9019813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126AbYCKD1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     modules: fix module waiting for dependent modules' init
has been removed from the -mm tree.  Its filename was
     modules-fix-module-waiting-for-dependent-modules-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: fix module waiting for dependent modules' init
From: Rusty Russell <rusty@rustcorp.com.au>

Commit c9a3ba55 (module: wait for dependent modules doing init.) didn't quite
work because the waiter holds the module lock, meaning that the state of the
module it's waiting for cannot change.

Fortunately, it's fairly simple to update the state outside the lock and do
the wakeup.

Thanks to Jan Glauber for tracking this down and testing (qdio and qeth).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/module.c~modules-fix-module-waiting-for-dependent-modules-init kernel/module.c
--- a/kernel/module.c~modules-fix-module-waiting-for-dependent-modules-init
+++ a/kernel/module.c
@@ -2179,9 +2179,11 @@ sys_init_module(void __user *umod,
 		return ret;
 	}
 
-	/* Now it's a first class citizen! */
-	mutex_lock(&module_mutex);
+	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
 	mod->state = MODULE_STATE_LIVE;
+	wake_up(&module_wq);
+
+	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
 	unwind_remove_table(mod->unwind_info, 1);
@@ -2190,7 +2192,6 @@ sys_init_module(void __user *umod,
 	mod->init_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
-	wake_up(&module_wq);
 
 	return 0;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
reiser4.patch

