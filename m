From: akpm@linux-foundation.org
Subject: [to-be-updated] tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch removed from -mm tree
Date: Tue, 18 Aug 2009 16:05:07 -0700
Message-ID: <200908182305.n7IN57Zh022963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbZHRXFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 19:05:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, benisty.e@gmail.com, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     tty: fix regression caused by "tty: make the kref destructor occur asynchronously"
has been removed from the -mm tree.  Its filename was
     tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix regression caused by "tty: make the kref destructor occur asynchronously"
From: Dave Young <hidave.darkstar@gmail.com>

Repair

    commit d966976924119acd35a431adbb95292082f73f8c
    Author: Alan Cox <alan@linux.intel.com>
    Date:   Tue Aug 11 10:23:05 2009 +1000

        tty: make the kref destructor occur asynchronously

Due to tty release routines runs in workqueue now, error like following
will be reported while booting:

INIT open /dev/console input/output error

Opening a tty while closing not finished is what cause such problem.

Fix it by flush hangup_work in such case and then call tty_init_dev.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/tty_io.c~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously
+++ a/drivers/char/tty_io.c
@@ -1771,9 +1771,14 @@ got_driver:
 	}
 
 	if (tty) {
-		retval = tty_reopen(tty);
-		if (retval)
-			tty = ERR_PTR(retval);
+		if (test_bit(TTY_CLOSING, &tty->flags)) {
+			flush_work(&tty->hangup_work);
+			tty = tty_init_dev(driver, index, 0);
+		} else {
+			retval = tty_reopen(tty);
+			if (retval)
+				tty = ERR_PTR(retval);
+		}
 	} else
 		tty = tty_init_dev(driver, index, 0);
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
pc-fs-char_devc-remove-useless-loop-fix.patch

