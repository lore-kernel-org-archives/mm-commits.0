From: akpm@linux-foundation.org
Subject: + tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch added to -mm tree
Date: Thu, 13 Aug 2009 16:43:01 -0700
Message-ID: <200908132343.n7DNh14l016736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbZHMXnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 19:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, rjw@sisk.pl


The patch titled
     tty: fix regression caused by "tty: make the kref destructor occur asynchronously"
has been added to the -mm tree.  Its filename is
     tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch

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

origin.patch
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

