From: akpm@linux-foundation.org
Subject: + hpwdt-remove-cflags.patch added to -mm tree
Date: Tue, 24 Jun 2008 14:19:42 -0700
Message-ID: <200806242119.m5OLJgth006634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbYFXVTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 17:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wim@iguana.be, Thomas.Mingarelli@hp.com


The patch titled
     hpwdt: remove CFLAGS
has been added to the -mm tree.  Its filename is
     hpwdt-remove-cflags.patch

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
Subject: hpwdt: remove CFLAGS
From: Wim Van Sebroeck <wim@iguana.be>

Revert "[WATCHDOG] hpwdt: Add CFLAGS to get driver working"

After Linus fixed the inline assembly, the CFLAGS option is not needed
anymore.

Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/watchdog/Makefile~hpwdt-remove-cflags drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~hpwdt-remove-cflags
+++ a/drivers/watchdog/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
-CFLAGS_hpwdt.o += -O
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
_

Patches currently in -mm which might be from wim@iguana.be are

pcwd-a-couple-of-watchdogs-escaped-conversion.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hpwdt-remove-cflags.patch

