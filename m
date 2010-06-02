From: akpm@linux-foundation.org
Subject: + s390-remove-warn_on-for-misc_deregister-failures.patch added to -mm tree
Date: Wed, 02 Jun 2010 13:11:13 -0700
Message-ID: <201006022011.o52KBDNg014397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933151Ab0FBULS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 16:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: remove WARN_ON for misc_deregister() failures
has been added to the -mm tree.  Its filename is
     s390-remove-warn_on-for-misc_deregister-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: remove WARN_ON for misc_deregister() failures
From: Akinobu Mita <akinobu.mita@gmail.com>

The previous change added WARN_ON() in misc_deregister().  So it is not
necessary to WARN_ON() misc_deregister() failure by callers.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dasd_eer.c |    2 +-
 drivers/s390/char/monreader.c |    2 +-
 drivers/s390/char/monwriter.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/s390/block/dasd_eer.c~s390-remove-warn_on-for-misc_deregister-failures drivers/s390/block/dasd_eer.c
--- a/drivers/s390/block/dasd_eer.c~s390-remove-warn_on-for-misc_deregister-failures
+++ a/drivers/s390/block/dasd_eer.c
@@ -701,7 +701,7 @@ int __init dasd_eer_init(void)
 void dasd_eer_exit(void)
 {
 	if (dasd_eer_dev) {
-		WARN_ON(misc_deregister(dasd_eer_dev) != 0);
+		misc_deregister(dasd_eer_dev);
 		kfree(dasd_eer_dev);
 		dasd_eer_dev = NULL;
 	}
diff -puN drivers/s390/char/monreader.c~s390-remove-warn_on-for-misc_deregister-failures drivers/s390/char/monreader.c
--- a/drivers/s390/char/monreader.c~s390-remove-warn_on-for-misc_deregister-failures
+++ a/drivers/s390/char/monreader.c
@@ -627,7 +627,7 @@ out_iucv:
 static void __exit mon_exit(void)
 {
 	segment_unload(mon_dcss_name);
-	WARN_ON(misc_deregister(&mon_dev) != 0);
+	misc_deregister(&mon_dev);
 	device_unregister(monreader_device);
 	driver_unregister(&monreader_driver);
 	iucv_unregister(&monreader_iucv_handler, 1);
diff -puN drivers/s390/char/monwriter.c~s390-remove-warn_on-for-misc_deregister-failures drivers/s390/char/monwriter.c
--- a/drivers/s390/char/monwriter.c~s390-remove-warn_on-for-misc_deregister-failures
+++ a/drivers/s390/char/monwriter.c
@@ -380,7 +380,7 @@ out_driver:
 
 static void __exit mon_exit(void)
 {
-	WARN_ON(misc_deregister(&mon_dev) != 0);
+	misc_deregister(&mon_dev);
 	platform_device_unregister(monwriter_pdev);
 	platform_driver_unregister(&monwriter_pdrv);
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call.patch
char-add-warn_on-in-misc_deregister.patch
s390-remove-warn_on-for-misc_deregister-failures.patch

