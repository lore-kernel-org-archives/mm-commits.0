Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BA7C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjLDTVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjLDTVg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2362FA
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50594C433C9;
        Mon,  4 Dec 2023 19:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717702;
        bh=dQVeMIKNu2413xwsfWsLI1/kU8KMhwr+6T1XLXx8mqM=;
        h=Date:To:From:Subject:From;
        b=L6Fp98xL4ffmgM4JpMyNIU6ScIa9J+fO/AYFSnmAJz5pXk/cGEzrtdTpKGD1PDbpb
         5BIrfAi7HlhJJqeaciHKx7n+Y1Mb6eoqVNO9UnbD/1GSYnhPrlWSxFcgb/yzA4HHoQ
         vQYW4qtQ7znZaxjXROFVguQaETE+GhDo8z6eLonQ=
Date:   Mon, 04 Dec 2023 11:21:41 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-unhide-uasm_in_compat_space_p-declaration.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192142.50594C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: unhide uasm_in_compat_space_p() declaration
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-unhide-uasm_in_compat_space_p-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-unhide-uasm_in_compat_space_p-declaration.patch

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
Subject: mips: unhide uasm_in_compat_space_p() declaration
Date: Mon, 4 Dec 2023 12:56:59 +0100

uasm_in_compat_space_p() has a conditional declaration but is defined
unconditionally because of another local user, which causes a warning:

arch/mips/mm/uasm.c:421:5: error: no previous prototype for 'uasm_in_compat_space_p' [-Werror=missing-prototypes]

Make the declaration unconditional to avoid this.

Link: https://lkml.kernel.org/r/20231204115710.2247097-10-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/uasm.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/mips/include/asm/uasm.h~mips-unhide-uasm_in_compat_space_p-declaration
+++ a/arch/mips/include/asm/uasm.h
@@ -193,9 +193,7 @@ struct uasm_label {
 
 void uasm_build_label(struct uasm_label **lab, u32 *addr,
 			int lid);
-#ifdef CONFIG_64BIT
 int uasm_in_compat_space_p(long addr);
-#endif
 int uasm_rel_hi(long val);
 int uasm_rel_lo(long val);
 void UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr);
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

