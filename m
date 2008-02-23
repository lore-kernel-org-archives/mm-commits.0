From: akpm@linux-foundation.org
Subject: + pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:13 -0800
Message-ID: <200802230733.m1N7X2hd018184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbYBWHyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, stern@rowland.harvard.edu


The patch titled
     PM: remove unbalanced mutex_unlock() from dpm_resume()
has been added to the -mm tree.  Its filename is
     pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch

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
Subject: PM: remove unbalanced mutex_unlock() from dpm_resume()


Remove an unnecessary unlocking of dpm_list_mtx in the error path in
drivers/base/power/main.c:dpm_suspend() .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/power/main.c~pm-remove-unbalanced-mutex_unlock-from-dpm_resume drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-remove-unbalanced-mutex_unlock-from-dpm_resume
+++ a/drivers/base/power/main.c
@@ -479,7 +479,6 @@ static int dpm_suspend(pm_message_t stat
 			mutex_lock(&dpm_list_mtx);
 			if (list_empty(&dev->power.entry))
 				list_add(&dev->power.entry, &dpm_locked);
-			mutex_unlock(&dpm_list_mtx);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);
_

Patches currently in -mm which might be from rjw@sisk.pl are

revert-send-a-single-notification-on-device-state-changes.patch
git-acpi.patch
git-acpi-powerpc-kconfig-fix.patch
pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch
shrink_slab-handle-bad-shrinkers.patch
