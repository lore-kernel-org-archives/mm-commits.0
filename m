From: akpm@linux-foundation.org
Subject: + modules-fix-module-waiting-for-dependent-modules-init.patch added to -mm tree
Date: Tue, 04 Mar 2008 13:00:06 -0800
Message-ID: <200803042100.m24L06ne028920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYCDVGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 16:06:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, jang@linux.vnet.ibm.com


The patch titled
     modules: fix module waiting for dependent modules' init
has been added to the -mm tree.  Its filename is
     modules-fix-module-waiting-for-dependent-modules-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2171,9 +2171,11 @@ sys_init_module(void __user *umod,
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
@@ -2182,7 +2184,6 @@ sys_init_module(void __user *umod,
 	mod->init_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
-	wake_up(&module_wq);
 
 	return 0;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
fix-malformed-early-option-loglevel.patch
git-kvm.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
modules-fix-module-waiting-for-dependent-modules-init.patch
modules-warn-about-suspicious-return-values-from-modules-init-hook.patch
reiser4.patch

