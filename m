From: akpm@linux-foundation.org
Subject: + pm-remove-references-to-struct-pm_dev-from-irda-headers.patch added to -mm tree
Date: Thu, 12 Jun 2008 01:47:42 -0700
Message-ID: <200806120847.m5C8lgWl010629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603AbYFLIrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 04:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, samuel@sortiz.org


The patch titled
     pm: remove references to struct pm_dev from IRDA headers
has been added to the -mm tree.  Its filename is
     pm-remove-references-to-struct-pm_dev-from-irda-headers.patch

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
Subject: pm: remove references to struct pm_dev from IRDA headers
From: Rafael J. Wysocki <rjw@sisk.pl>

Some IRDA headers contain references to 'struct pm_dev' that are not
necessary any more and may be removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/ali-ircc.h    |    2 --
 drivers/net/irda/au1000_ircc.h |    1 -
 drivers/net/irda/via-ircc.h    |    1 -
 3 files changed, 4 deletions(-)

diff -puN drivers/net/irda/ali-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers drivers/net/irda/ali-ircc.h
--- a/drivers/net/irda/ali-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers
+++ a/drivers/net/irda/ali-ircc.h
@@ -219,8 +219,6 @@ struct ali_ircc_cb {
 	int index;                 /* Instance index */
 	
 	unsigned char fifo_opti_buf;
-
-        struct pm_dev *dev;
 };
 
 static inline void switch_bank(int iobase, int bank)
diff -puN drivers/net/irda/au1000_ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers drivers/net/irda/au1000_ircc.h
--- a/drivers/net/irda/au1000_ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers
+++ a/drivers/net/irda/au1000_ircc.h
@@ -122,6 +122,5 @@ struct au1k_private {
 	struct timer_list timer;
 
 	spinlock_t lock;           /* For serializing operations */
-        struct pm_dev *dev;
 };
 #endif /* AU1000_IRCC_H */
diff -puN drivers/net/irda/via-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers drivers/net/irda/via-ircc.h
--- a/drivers/net/irda/via-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers
+++ a/drivers/net/irda/via-ircc.h
@@ -118,7 +118,6 @@ struct via_ircc_cb {
 	int index;		/* Instance index */
 
 	struct eventflag EventFlag;
-	struct pm_dev *dev;
 	unsigned int chip_id;	/* to remember chip id */
 	unsigned int RetryCount;
 	unsigned int RxDataReady;
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
x86-fix-lockdep-warning-during-suspend-to-ram.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
remove-include-linux-pm_legacyh.patch
shrink_slab-handle-bad-shrinkers.patch
pm-x86-remove-obsolete-pm-definitions-from-nmi-header.patch
pm-remove-references-to-struct-pm_dev-from-irda-headers.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-obsolete-piece-of-pm-documentation.patch

