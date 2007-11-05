From: akpm@linux-foundation.org
Subject: + cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:14:16 -0800
Message-ID: <200711052114.lA5LEGqX020029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXKEVOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:14:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     CRIS: remove MTD_AMSTD and MTD_OBSOLETE_CHIPS take two
has been added to the -mm tree.  Its filename is
     cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS: remove MTD_AMSTD and MTD_OBSOLETE_CHIPS take two
From: Jesper Nilsson <jesper.nilsson@axis.com>

Remove MTD_AMDSTD and MTD_OBSOLETE_CHIPS from defconfig, Kconfig and code,
instead we'll use MTD_CFI or MTD_JEDECPROBE.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/defconfig              |    2 --
 arch/cris/arch-v10/drivers/Kconfig        |    2 --
 arch/cris/arch-v10/drivers/axisflashmap.c |    8 ++++----
 arch/cris/arch-v32/drivers/Kconfig        |    2 --
 arch/cris/arch-v32/drivers/axisflashmap.c |    8 ++++----
 arch/cris/defconfig                       |    2 --
 6 files changed, 8 insertions(+), 16 deletions(-)

diff -puN arch/cris/arch-v10/defconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two arch/cris/arch-v10/defconfig
--- a/arch/cris/arch-v10/defconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two
+++ a/arch/cris/arch-v10/defconfig
@@ -99,7 +99,6 @@ CONFIG_MTD=y
 CONFIG_MTD_CFI=y
 # CONFIG_MTD_CFI_INTELEXT is not set
 CONFIG_MTD_CFI_AMDSTD=y
-CONFIG_MTD_AMDSTD=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_ETRAX_I2C=y
@@ -145,7 +144,6 @@ CONFIG_MTD_CFI=y
 # CONFIG_MTD_CFI_GEOMETRY is not set
 # CONFIG_MTD_CFI_INTELEXT is not set
 CONFIG_MTD_CFI_AMDSTD=y
-CONFIG_MTD_AMDSTD=y
 # CONFIG_MTD_SHARP is not set
 # CONFIG_MTD_PHYSMAP is not set
 # CONFIG_MTD_NORA is not set
diff -puN arch/cris/arch-v10/drivers/Kconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two arch/cris/arch-v10/drivers/Kconfig
--- a/arch/cris/arch-v10/drivers/Kconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two
+++ a/arch/cris/arch-v10/drivers/Kconfig
@@ -606,8 +606,6 @@ config ETRAX_AXISFLASHMAP
 	select MTD
 	select MTD_CFI
 	select MTD_CFI_AMDSTD
-	select MTD_OBSOLETE_CHIPS
-	select MTD_AMDSTD
 	select MTD_CHAR
 	select MTD_BLOCK
 	select MTD_PARTITIONS
diff -puN arch/cris/arch-v10/drivers/axisflashmap.c~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two arch/cris/arch-v10/drivers/axisflashmap.c
--- a/arch/cris/arch-v10/drivers/axisflashmap.c~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two
+++ a/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -312,12 +312,12 @@ static struct mtd_info *probe_cs(struct 
                "%s: Probing a 0x%08lx bytes large window at 0x%08lx.\n",
 	       map_cs->name, map_cs->size, map_cs->map_priv_1);
 
-#ifdef CONFIG_MTD_AMDSTD
-	mtd_cs = do_map_probe("amd_flash", map_cs);
-#endif
 #ifdef CONFIG_MTD_CFI
+	mtd_cs = do_map_probe("cfi_probe", map_cs);
+#endif
+#ifdef CONFIG_MTD_JEDECPROBE
 	if (!mtd_cs) {
-		mtd_cs = do_map_probe("cfi_probe", map_cs);
+		mtd_cs = do_map_probe("jedec_probe", map_cs);
 	}
 #endif
 
diff -puN arch/cris/arch-v32/drivers/Kconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two arch/cris/arch-v32/drivers/Kconfig
--- a/arch/cris/arch-v32/drivers/Kconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two
+++ a/arch/cris/arch-v32/drivers/Kconfig
@@ -362,8 +362,6 @@ config ETRAX_AXISFLASHMAP
 	select MTD
 	select MTD_CFI
 	select MTD_CFI_AMDSTD
-	select MTD_OBSOLETE_CHIPS
-	select MTD_AMDSTD
 	select MTD_CHAR
 	select MTD_BLOCK
 	select MTD_PARTITIONS
diff -puN arch/cris/arch-v32/drivers/axisflashmap.c~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two arch/cris/arch-v32/drivers/axisflashmap.c
--- a/arch/cris/arch-v32/drivers/axisflashmap.c~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two
+++ a/arch/cris/arch-v32/drivers/axisflashmap.c
@@ -190,12 +190,12 @@ static struct mtd_info *probe_cs(struct 
 	       "%s: Probing a 0x%08lx bytes large window at 0x%08lx.\n",
 	       map_cs->name, map_cs->size, map_cs->map_priv_1);
 
-#ifdef CONFIG_MTD_AMDSTD
-	mtd_cs = do_map_probe("amd_flash", map_cs);
-#endif
 #ifdef CONFIG_MTD_CFI
-	if (!mtd_cs) {
 		mtd_cs = do_map_probe("cfi_probe", map_cs);
+#endif
+#ifdef CONFIG_MTD_JEDECPROBE
+	if (!mtd_cs) {
+		mtd_cs = do_map_probe("jedec_probe", map_cs);
 	}
 #endif
 
diff -puN arch/cris/defconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two arch/cris/defconfig
--- a/arch/cris/defconfig~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two
+++ a/arch/cris/defconfig
@@ -226,8 +226,6 @@ CONFIG_MTD_CFI_UTIL=y
 CONFIG_MTD_RAM=y
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-CONFIG_MTD_OBSOLETE_CHIPS=y
-CONFIG_MTD_AMDSTD=y
 # CONFIG_MTD_SHARP is not set
 # CONFIG_MTD_JEDEC is not set
 
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
