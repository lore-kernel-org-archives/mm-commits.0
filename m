From: akpm@linux-foundation.org
Subject: + blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:10:35 -0700
Message-ID: <200703262110.l2QLAZDe030652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52059 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbXCZVKi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin arch: fix reboot kernel mounting spi flash print error bug
has been added to the -mm tree.  Its filename is
     blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin arch: fix reboot kernel mounting spi flash print error bug
From: "Wu, Bryan" <bryan.wu@analog.com>

This patch fix a printing error bug when reboot kernel mounting on SPI flash.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/blackfin/mach-bf533/boards/cm_bf533.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf533/boards/cm_bf533.c
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -57,7 +57,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf533/boards/ezkit.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf533/boards/ezkit.c
--- a/arch/blackfin/mach-bf533/boards/ezkit.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -91,7 +91,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf533/boards/stamp.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf533/boards/stamp.c
--- a/arch/blackfin/mach-bf533/boards/stamp.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf533/boards/stamp.c
@@ -114,7 +114,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf537/boards/cm_bf537.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf537/boards/cm_bf537.c
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -59,7 +59,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf537/boards/generic_board.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf537/boards/generic_board.c
--- a/arch/blackfin/mach-bf537/boards/generic_board.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -259,7 +259,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf537/boards/pnav10.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf537/boards/pnav10.c
--- a/arch/blackfin/mach-bf537/boards/pnav10.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -244,7 +244,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf537/boards/stamp.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf537/boards/stamp.c
--- a/arch/blackfin/mach-bf537/boards/stamp.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf537/boards/stamp.c
@@ -293,7 +293,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
diff -puN arch/blackfin/mach-bf561/boards/cm_bf561.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug arch/blackfin/mach-bf561/boards/cm_bf561.c
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c~blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -58,7 +58,7 @@ static struct mtd_partition bfin_spi_fla
 		.offset = 0x20000
 	},{
 		.name = "file system",
-		.size = 0x300000,
+		.size = 0x700000,
 		.offset = 0x00100000,
 	}
 };
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
