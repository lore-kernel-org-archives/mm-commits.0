From: akpm@linux-foundation.org
Subject: - pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:59 -0800
Message-ID: <200802232023.m1NKNx50013593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761554AbYBWU2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     PM: remove unbalanced mutex_unlock() from dpm_resume()
has been removed from the -mm tree.  Its filename was
     pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-xfs.patch
shrink_slab-handle-bad-shrinkers.patch
