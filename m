From: akpm@linux-foundation.org
Subject: + mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix.patch added to -mm tree
Date: Tue, 10 Jun 2008 11:27:39 -0700
Message-ID: <200806101827.m5AIRdt3023177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbYFJS2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 14:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, galak@kernel.crashing.org, wim@iguana.be


The patch titled
     watchdog: mpc8xxx_wdt: fix build
has been added to the -mm tree.  Its filename is
     mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix.patch

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
Subject: watchdog: mpc8xxx_wdt: fix build
From: Anton Vorontsov <avorontsov@ru.mvista.com>

  CC      drivers/watchdog/mpc8xxx_wdt.o
drivers/watchdog/mpc8xxx_wdt.c: In function 'mpc8xxx_wdt_ioctl':
drivers/watchdog/mpc8xxx_wdt.c:156: error: 'cmd' undeclared (first use in this function)
drivers/watchdog/mpc8xxx_wdt.c:156: error: (Each undeclared identifier is reported only once
drivers/watchdog/mpc8xxx_wdt.c:156: error: for each function it appears in.)
drivers/watchdog/mpc8xxx_wdt.c: At top level:
drivers/watchdog/mpc8xxx_wdt.c:176: warning: initialization from incompatible pointer type

This patch ought to be folded into
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mpc8xxx_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/mpc8xxx_wdt.c~mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix drivers/watchdog/mpc8xxx_wdt.c
--- a/drivers/watchdog/mpc8xxx_wdt.c~mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix
+++ a/drivers/watchdog/mpc8xxx_wdt.c
@@ -142,7 +142,7 @@ static int mpc8xxx_wdt_release(struct in
 	return 0;
 }
 
-static long mpc8xxx_wdt_ioctl(struct inode *inode, struct file *file,
+static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
git-leds.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch

