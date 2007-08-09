From: akpm@linux-foundation.org
Subject: + rfc-add-bcm947xx-to-kconfig.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:40:36 -0700
Message-ID: <200708092040.l79KeaFC018432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759863AbXHIUvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, jolt@tuxbox.org, mb@bu3sch.de, nbd@openwrt.org, ralf@linux-mips.org


The patch titled
     Add BCM947XX to Kconfig
has been added to the -mm tree.  Its filename is
     rfc-add-bcm947xx-to-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add BCM947XX to Kconfig
From: Aurelien Jarno <aurelien@aurel32.net>

Add a BCM947XX option to Kconfig.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Florian Schirmer <jolt@tuxbox.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN arch/mips/Kconfig~rfc-add-bcm947xx-to-kconfig arch/mips/Kconfig
--- a/arch/mips/Kconfig~rfc-add-bcm947xx-to-kconfig
+++ a/arch/mips/Kconfig
@@ -45,6 +45,20 @@ config BASLER_EXCITE_PROTOTYPE
 	  note that a kernel built with this option selected will not be
 	  able to run on normal units.
 
+config BCM947XX
+	bool "BCM947xx based boards"
+	select DMA_NONCOHERENT
+	select HW_HAS_PCI
+	select IRQ_CPU
+	select SYS_HAS_CPU_MIPS32_R1
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select SSB
+	select SSB_DRIVER_MIPS
+	select GENERIC_GPIO
+	help
+	 Support for BCM947xx based boards
+
 config MIPS_COBALT
 	bool "Cobalt Server"
 	select DMA_NONCOHERENT
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
git-wireless.patch
