From: akpm@linux-foundation.org
Subject: - pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:06 -0800
Message-ID: <200803042010.m24KA6EW026880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759151AbYCDUT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, gregkh@suse.de, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, xhejtman@ics.muni.cz, zdenek.kabelac@gmail.com, mm-commits@vger.kernel.org


The patch titled
     PM: fix new mutex-locking bug in the PM core
has been removed from the -mm tree.  Its filename was
     pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: fix new mutex-locking bug in the PM core
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1041) fixes a bug introduced by the
acquire-all-device-semaphores reversion.  The error pathway of dpm_suspend()
fails to reacquire a mutex it should be holding.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/power/main.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix
+++ a/drivers/base/power/main.c
@@ -423,6 +423,7 @@ static int dpm_suspend(pm_message_t stat
 
 		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
+		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			printk(KERN_ERR "Could not suspend device %s: "
 					"error %d%s\n",
@@ -433,7 +434,6 @@ static int dpm_suspend(pm_message_t stat
 					""));
 			break;
 		}
-		mutex_lock(&dpm_list_mtx);
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_off);
 	}
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are


