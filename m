From: akpm@linux-foundation.org
Subject: + rtc-twl4030-rename-ioctl-function-when-rtc_intf_dev=n.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:20:13 -0800
Message-ID: <200812070720.mB77KDK1021552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbYLGHUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net, sameo@openedhand.com, tony@atomide.com


The patch titled
     rtc twl4030: rename ioctl function when RTC_INTF_DEV=n
has been added to the -mm tree.  Its filename is
     rtc-twl4030-rename-ioctl-function-when-rtc_intf_dev=n.patch

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
Subject: rtc twl4030: rename ioctl function when RTC_INTF_DEV=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when RTC_INTF_DEV=n:

drivers/rtc/rtc-twl4030.c:402: error: 'twl4030_rtc_ioctl' undeclared here (not in a function)
make[3]: *** [drivers/rtc/rtc-twl4030.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl4030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl4030.c~rtc-twl4030-rename-ioctl-function-when-rtc_intf_dev=n drivers/rtc/rtc-twl4030.c
--- a/drivers/rtc/rtc-twl4030.c~rtc-twl4030-rename-ioctl-function-when-rtc_intf_dev=n
+++ a/drivers/rtc/rtc-twl4030.c
@@ -337,7 +337,7 @@ static int twl4030_rtc_ioctl(struct devi
 }
 
 #else
-#define	omap_rtc_ioctl	NULL
+#define	twl4030_rtc_ioctl	NULL
 #endif
 
 static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rtc-twl4030-rename-ioctl-function-when-rtc_intf_dev=n.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
fix-similar-typos-to-successfull-v2.patch

