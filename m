From: akpm@linux-foundation.org
Subject: + firmware-only-allow-edd-on-x86.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:17:57 -0700
Message-ID: <200910140217.n9E2HvYP004538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761401AbZJNCS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, Matt_Domsch@dell.com


The patch titled
     firmware: only allow EDD on x86
has been added to the -mm tree.  Its filename is
     firmware-only-allow-edd-on-x86.patch

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
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
firmware-only-allow-edd-on-x86.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

