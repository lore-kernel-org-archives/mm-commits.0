From: akpm@linux-foundation.org
Subject: + drivers-misc-phantom-note-pci.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:06:16 -0700
Message-ID: <200807130606.m6D66GFA007212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbYGMGGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     drivers/misc/phantom: note PCI
has been added to the -mm tree.  Its filename is
     drivers-misc-phantom-note-pci.patch

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
Subject: drivers/misc/phantom: note PCI
From: Jiri Slaby <jirislaby@gmail.com>

Tell users that the driver is only for PCI devices to stop asking for
support of firewire and parallel devices.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig   |    4 +++-
 drivers/misc/phantom.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/misc/Kconfig~drivers-misc-phantom-note-pci drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-phantom-note-pci
+++ a/drivers/misc/Kconfig
@@ -77,11 +77,13 @@ config IBM_ASM
 	  for your IBM server.
 
 config PHANTOM
-	tristate "Sensable PHANToM"
+	tristate "Sensable PHANToM (PCI)"
 	depends on PCI
 	help
 	  Say Y here if you want to build a driver for Sensable PHANToM device.
 
+	  This driver is only for PCI PHANToMs.
+
 	  If you choose to build module, its name will be phantom. If unsure,
 	  say N here.
 
diff -puN drivers/misc/phantom.c~drivers-misc-phantom-note-pci drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~drivers-misc-phantom-note-pci
+++ a/drivers/misc/phantom.c
@@ -563,6 +563,6 @@ module_init(phantom_init);
 module_exit(phantom_exit);
 
 MODULE_AUTHOR("Jiri Slaby <jirislaby@gmail.com>");
-MODULE_DESCRIPTION("Sensable Phantom driver");
+MODULE_DESCRIPTION("Sensable Phantom driver (PCI devices)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(PHANTOM_VERSION);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
char-isicom-enable-disable-pci-device.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

