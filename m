Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082BEC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjLDTV2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjLDTV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA56CA
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA37C433C8;
        Mon,  4 Dec 2023 19:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717692;
        bh=0lXMyglMgaiUv9GoFBhrTiuopdmnNbNRL7LIdfxNyRs=;
        h=Date:To:From:Subject:From;
        b=iP7I9s+s7ajIBbAoCLmWD+KdO+Bh4YB4RltvXE4LpgouVMrRWgjEB/KuWQQO76noH
         pcFkjpM/AouQFF1dwAFmvNqTphbscIELQjXSpFoEFhtyuu1YdJw8mSuNVs6b+PEqN/
         fL9sfSYRgxc5dQMC5xLSAsfkll6aS2sKUOpDEk94=
Date:   Mon, 04 Dec 2023 11:21:31 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-rs870e-stop-exporting-local-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192132.6BA37C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: rs870e: stop exporting local functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-rs870e-stop-exporting-local-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-rs870e-stop-exporting-local-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: rs870e: stop exporting local functions
Date: Mon, 4 Dec 2023 12:56:54 +0100

These four functions are exported, but don't have any users, and no
prototypes, which now causes warnings:

drivers/platform/mips/rs780e-acpi.c:35:6: error: no previous prototype for 'pm_iowrite' [-Werror=missing-prototypes]
drivers/platform/mips/rs780e-acpi.c:41:4: error: no previous prototype for 'pm_ioread' [-Werror=missing-prototypes]
drivers/platform/mips/rs780e-acpi.c:47:6: error: no previous prototype for 'pm2_iowrite' [-Werror=missing-prototypes]
drivers/platform/mips/rs780e-acpi.c:53:4: error: no previous prototype for 'pm2_ioread' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/mips/rs780e-acpi.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/platform/mips/rs780e-acpi.c~mips-rs870e-stop-exporting-local-functions
+++ a/drivers/platform/mips/rs780e-acpi.c
@@ -32,29 +32,25 @@ static u8 pmio_read_index(u16 index, u8
 	return inb(index + 1);
 }
 
-void pm_iowrite(u8 reg, u8 value)
+static void pm_iowrite(u8 reg, u8 value)
 {
 	pmio_write_index(PM_INDEX, reg, value);
 }
-EXPORT_SYMBOL(pm_iowrite);
 
-u8 pm_ioread(u8 reg)
+static u8 pm_ioread(u8 reg)
 {
 	return pmio_read_index(PM_INDEX, reg);
 }
-EXPORT_SYMBOL(pm_ioread);
 
-void pm2_iowrite(u8 reg, u8 value)
+static void pm2_iowrite(u8 reg, u8 value)
 {
 	pmio_write_index(PM2_INDEX, reg, value);
 }
-EXPORT_SYMBOL(pm2_iowrite);
 
-u8 pm2_ioread(u8 reg)
+static u8 pm2_ioread(u8 reg)
 {
 	return pmio_read_index(PM2_INDEX, reg);
 }
-EXPORT_SYMBOL(pm2_ioread);
 
 static void acpi_hw_clear_status(void)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
arch-turn-off-werror-for-architectures-with-known-warnings.patch
mips-decompress-fix-add-missing-prototypes.patch
mips-add-asm-syscallsh-header.patch
mips-add-missing-declarations-for-trap-handlers.patch
mips-rs870e-stop-exporting-local-functions.patch
mips-signal-move-sigcontext-declarations-to-header.patch
mips-mark-local-function-static-if-possible.patch
mips-move-build_tlb_refill_handler-prototype.patch
mips-move-jump_label_apply_nops-declaration-to-header.patch
mips-unhide-uasm_in_compat_space_p-declaration.patch
mips-fix-setup_zero_pages-prototype.patch
mips-fix-tlb_init-prototype.patch
mips-move-cache-declarations-into-header.patch
mips-add-missing-declarations.patch
mips-spram-fix-missing-prototype-warning-for-spram_config.patch
mips-mt-include-asm-mips_mth.patch
mips-remove-extraneous-asm-generic-iomaph-include.patch
mips-suspend-include-linux-suspendh-as-needed.patch
mips-hide-conditionally-unused-functions.patch
mips-smp-fix-setup_profiling_timer-prototype.patch
mips-kexec-include-linux-rebooth.patch
ida-make-ida_dump-static.patch
jffs2-mark-__jffs2_dbg_superblock_counts-static.patch
sched-fair-move-unused-stub-functions-to-header.patch
x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch
usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

