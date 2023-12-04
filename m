Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3723CC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjLDTVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjLDTVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951EACA
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3412CC433C7;
        Mon,  4 Dec 2023 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717696;
        bh=O21DXAV9IYwgGuBrS7f5OKZZ3U+ZOTkCNMzTteegHJo=;
        h=Date:To:From:Subject:From;
        b=xOfeH6ss39JuTFboMClnyf/X+9b69Z0pIreT3HXXFyJSRNkD8ORvmTRaCUec2g2KS
         PVOCr3QS0s/KjqAzU1bR5NccAd/q2/BsqhUQ2t77pQb9MfmaYwSFs68alUXalUMErv
         8CL3XDZckgH7MLzqTSdATNvnL5qUFwSyFM3dWYeg=
Date:   Mon, 04 Dec 2023 11:21:35 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-mark-local-function-static-if-possible.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192136.3412CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: mark local function static if possible
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-mark-local-function-static-if-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-mark-local-function-static-if-possible.patch

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
Subject: mips: mark local function static if possible
Date: Mon, 4 Dec 2023 12:56:56 +0100

These two functions are global but have no extern prototypes or other
callers, so it's best to mark them as static, avoiding these warnings:

arch/mips/kernel/mips-cm.c:204:13: error: no previous prototype for '__mips_cm_l2sync_phys_base' [-Werror=missing-prototypes]
arch/mips/mm/c-r4k.c:1827:12: error: no previous prototype for 'r4k_cache_init_pm' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-7-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-cm.c |    2 +-
 arch/mips/mm/c-r4k.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/mips-cm.c~mips-mark-local-function-static-if-possible
+++ a/arch/mips/kernel/mips-cm.c
@@ -201,7 +201,7 @@ phys_addr_t __mips_cm_phys_base(void)
 phys_addr_t mips_cm_phys_base(void)
 	__attribute__((weak, alias("__mips_cm_phys_base")));
 
-phys_addr_t __mips_cm_l2sync_phys_base(void)
+static phys_addr_t __mips_cm_l2sync_phys_base(void)
 {
 	u32 base_reg;
 
--- a/arch/mips/mm/c-r4k.c~mips-mark-local-function-static-if-possible
+++ a/arch/mips/mm/c-r4k.c
@@ -1828,7 +1828,7 @@ static struct notifier_block r4k_cache_p
 	.notifier_call = r4k_cache_pm_notifier,
 };
 
-int __init r4k_cache_init_pm(void)
+static int __init r4k_cache_init_pm(void)
 {
 	return cpu_pm_register_notifier(&r4k_cache_pm_notifier_block);
 }
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

