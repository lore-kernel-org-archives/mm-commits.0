From: akpm@linux-foundation.org
Subject: + fix-unbalanced-helper_lock-in-kernel-kmodc.patch added to -mm tree
Date: Thu, 17 Jan 2008 01:11:00 -0800
Message-ID: <200801170910.m0H9AeHj018104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbYAQJLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 04:11:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nigel@nigel.suspend2.net, nigel@tuxonice.net, stable@kernel.org


The patch titled
     Fix unbalanced helper_lock in kernel/kmod.c
has been added to the -mm tree.  Its filename is
     fix-unbalanced-helper_lock-in-kernel-kmodc.patch

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
Subject: Fix unbalanced helper_lock in kernel/kmod.c
From: Nigel Cunningham <nigel@nigel.suspend2.net>

call_usermodehelper_exec() has an exit path that can leave the
helper_lock() call at the top of the routine unbalanced.  The attached
patch fixes this issue.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/kmod.c~fix-unbalanced-helper_lock-in-kernel-kmodc kernel/kmod.c
--- a/kernel/kmod.c~fix-unbalanced-helper_lock-in-kernel-kmodc
+++ a/kernel/kmod.c
@@ -465,13 +465,16 @@ int call_usermodehelper_exec(struct subp
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
-		return 0;
+	if (wait == UMH_NO_WAIT) { /* task has freed sub_info */
+		retval = 0;
+		goto unlock;
+	}
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

fix-unbalanced-helper_lock-in-kernel-kmodc.patch
