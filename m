From: akpm@linux-foundation.org
Subject: - hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:18 -0800
Message-ID: <200802052233.m15MXxnN012469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762872AbYBEWpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     HWRNG: add possibility to remove hwrng devices during suspend/resume
has been removed from the -mm tree.  Its filename was
     hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: HWRNG: add possibility to remove hwrng devices during suspend/resume
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to unregister a Hardware Random Number Generator
device object in a safe way during a suspend/resume cycle.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/core.c |   10 +++++-----
 include/linux/hw_random.h     |   10 +++++++++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/char/hw_random/core.c~hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume drivers/char/hw_random/core.c
--- a/drivers/char/hw_random/core.c~hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume
+++ a/drivers/char/hw_random/core.c
@@ -234,11 +234,11 @@ static DEVICE_ATTR(rng_available, S_IRUG
 		   NULL);
 
 
-static void unregister_miscdev(void)
+static void unregister_miscdev(bool suspended)
 {
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
-	misc_deregister(&rng_miscdev);
+	__misc_deregister(&rng_miscdev, suspended);
 }
 
 static int register_miscdev(void)
@@ -313,7 +313,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(hwrng_register);
 
-void hwrng_unregister(struct hwrng *rng)
+void __hwrng_unregister(struct hwrng *rng, bool suspended)
 {
 	int err;
 
@@ -332,11 +332,11 @@ void hwrng_unregister(struct hwrng *rng)
 		}
 	}
 	if (list_empty(&rng_list))
-		unregister_miscdev();
+		unregister_miscdev(suspended);
 
 	mutex_unlock(&rng_mutex);
 }
-EXPORT_SYMBOL_GPL(hwrng_unregister);
+EXPORT_SYMBOL_GPL(__hwrng_unregister);
 
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
diff -puN include/linux/hw_random.h~hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume include/linux/hw_random.h
--- a/include/linux/hw_random.h~hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume
+++ a/include/linux/hw_random.h
@@ -44,7 +44,15 @@ struct hwrng {
 /** Register a new Hardware Random Number Generator driver. */
 extern int hwrng_register(struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
-extern void hwrng_unregister(struct hwrng *rng);
+extern void __hwrng_unregister(struct hwrng *rng, bool suspended);
+static inline void hwrng_unregister(struct hwrng *rng)
+{
+	__hwrng_unregister(rng, false);
+}
+static inline void hwrng_unregister_suspended(struct hwrng *rng)
+{
+	__hwrng_unregister(rng, true);
+}
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_HWRANDOM_H_ */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
git-x86.patch
git-xfs.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
