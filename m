From: akpm@linux-foundation.org
Subject: [merged] firmware-only-allow-edd-on-x86.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:20 -0800
Message-ID: <200912152158.nBFLwKHE015805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761310AbZLOV7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     firmware: only allow EDD on x86
has been removed from the -mm tree.  Its filename was
     firmware-only-allow-edd-on-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: only allow EDD on x86
From: Mike Frysinger <vapier@gentoo.org>

Rather than have the EDD depend on !ia64 (and assuming that only ia64,
x86, x86_64 will be including this Kconfig), have EDD depend on the only
arches which can support this code.  This should allow all other arches to
cleanly include the firmware Kconfig.

Also simplify the x86 string used by FIRMWARE_MEMMAP to match EDD.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/Kconfig~firmware-only-allow-edd-on-x86 drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~firmware-only-allow-edd-on-x86
+++ a/drivers/firmware/Kconfig
@@ -7,7 +7,7 @@ menu "Firmware Drivers"
 
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
-	depends on !IA64
+	depends on X86
 	help
 	  Say Y or M here if you want to enable BIOS Enhanced Disk Drive
 	  Services real mode BIOS calls to determine which disk
@@ -28,7 +28,7 @@ config EDD_OFF
 
 config FIRMWARE_MEMMAP
     bool "Add firmware-provided memory map to sysfs" if EMBEDDED
-    default (X86_64 || X86_32)
+    default X86
     help
       Add the firmware-provided (unmodified) memory map to /sys/firmware/memmap.
       That memory map is used for example by kexec to set up parameter area
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch
spidev-add-proper-section-markers.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

