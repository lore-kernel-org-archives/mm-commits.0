From: akpm@linux-foundation.org
Subject: - fix-unbalanced-helper_lock-in-kernel-kmodc.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:05:04 -0800
Message-ID: <200801200704.m0K74io9007827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbYATHFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nigel@nigel.suspend2.net, nigel@tuxonice.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix unbalanced helper_lock in kernel/kmod.c
has been removed from the -mm tree.  Its filename was
     fix-unbalanced-helper_lock-in-kernel-kmodc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix unbalanced helper_lock in kernel/kmod.c
From: Nigel Cunningham <nigel@nigel.suspend2.net>

call_usermodehelper_exec() has an exit path that can leave the
helper_lock() call at the top of the routine unbalanced.  The attached
patch fixes this issue.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/kmod.c~fix-unbalanced-helper_lock-in-kernel-kmodc kernel/kmod.c
--- a/kernel/kmod.c~fix-unbalanced-helper_lock-in-kernel-kmodc
+++ a/kernel/kmod.c
@@ -451,13 +451,11 @@ int call_usermodehelper_exec(struct subp
 			     enum umh_wait wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
-	int retval;
+	int retval = 0;
 
 	helper_lock();
-	if (sub_info->path[0] == '\0') {
-		retval = 0;
+	if (sub_info->path[0] == '\0')
 		goto out;
-	}
 
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
@@ -468,13 +466,14 @@ int call_usermodehelper_exec(struct subp
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
-		return 0;
+	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
+		goto unlock;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
 
-  out:
+out:
 	call_usermodehelper_freeinfo(sub_info);
+unlock:
 	helper_unlock();
 	return retval;
 }
_

Patches currently in -mm which might be from nigel@nigel.suspend2.net are

origin.patch
