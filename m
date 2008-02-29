From: akpm@linux-foundation.org
Subject: + pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch added to -mm tree
Date: Fri, 29 Feb 2008 13:19:18 -0800
Message-ID: <200802292119.m1TLJI3w021275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761081AbYB2VUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 16:20:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, gregkh@suse.de, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, xhejtman@ics.muni.cz, zdenek.kabelac@gmail.com


The patch titled
     PM: fix new mutex-locking bug in the PM core
has been added to the -mm tree.  Its filename is
     pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch

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

pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch
pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch

