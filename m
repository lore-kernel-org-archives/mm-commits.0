From: akpm@linux-foundation.org
Subject: + char-applicom-use-pci_resource_start.patch added to -mm tree
Date: Wed, 30 Jan 2008 15:02:03 -0800
Message-ID: <200801302302.m0UN23A8029211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762049AbYA3XCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:02:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, dwmw2@infradead.org, xiyou.wangcong@gmail.com


The patch titled
     Char: applicom, use pci_resource_start
has been added to the -mm tree.  Its filename is
     char-applicom-use-pci_resource_start.patch

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
Subject: Char: applicom, use pci_resource_start
From: Jiri Slaby <jirislaby@gmail.com>

Use pci_resource_start instead of accessing pci_dev struct internals.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/applicom.c~char-applicom-use-pci_resource_start drivers/char/applicom.c
--- a/drivers/char/applicom.c~char-applicom-use-pci_resource_start
+++ a/drivers/char/applicom.c
@@ -206,22 +206,23 @@ static int __init applicom_init(void)
 		if (pci_enable_device(dev))
 			return -EIO;
 
-		RamIO = ioremap(dev->resource[0].start, LEN_RAM_IO);
+		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap PCI memory "
 				"space at 0x%llx\n",
-				(unsigned long long)dev->resource[0].start);
+				(unsigned long long)pci_resource_start(dev, 0));
 			pci_disable_device(dev);
 			return -EIO;
 		}
 
 		printk(KERN_INFO "Applicom %s found at mem 0x%llx, irq %d\n",
 		       applicom_pci_devnames[dev->device-1],
-			   (unsigned long long)dev->resource[0].start,
+			   (unsigned long long)pci_resource_start(dev, 0),
 		       dev->irq);
 
-		boardno = ac_register_board(dev->resource[0].start, RamIO,0);
+		boardno = ac_register_board(pci_resource_start(dev, 0),
+				RamIO, 0);
 		if (!boardno) {
 			printk(KERN_INFO "ac.o: PCI Applicom device doesn't have correct signature.\n");
 			iounmap(RamIO);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-net.patch
git-watchdog.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
phantom-dont-grab-other-devices.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-remove-special-baudrate-processing.patch
char-mxser-0-to-null-in-pointer.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
char-mxser-ioctl-cleanup.patch
char-mxser-remove-it.patch
char-mxser-add-support-for-cp-114ul.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
