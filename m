Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AF3C10DC3
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjLDTVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjLDTVg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA584E6
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAD5C433C7;
        Mon,  4 Dec 2023 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717700;
        bh=YvNKum/9IJqtyggy/DQHVucZrDIOH3WHAjdCSXGx1cM=;
        h=Date:To:From:Subject:From;
        b=jPKuYMeFzArrL8IkoM38F+JsZsQdi0pHIWyj5/fm1WlMSMI+bGA0ACfYXv/IEt4V2
         SUFLDL9sm+e1248GODM2pVU3ohmXUXxjDC0tFoEhx03ID9QBCervDDqGvgSqAal6Vv
         RcpGzMgxsVyFT4qGgsKhq7R1f4dcS4cT2/6MRJBI=
Date:   Mon, 04 Dec 2023 11:21:39 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-move-jump_label_apply_nops-declaration-to-header.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192140.4AAD5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: move jump_label_apply_nops() declaration to header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-move-jump_label_apply_nops-declaration-to-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-move-jump_label_apply_nops-declaration-to-header.patch

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
Subject: mips: move jump_label_apply_nops() declaration to header
Date: Mon, 4 Dec 2023 12:56:58 +0100

Instead of an extern declaration in the C file with the caller, move it to
an appropriate header, avoiding

arch/mips/kernel/jump_label.c:93:6: error: no previous prototype for 'jump_label_apply_nops' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-9-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/jump_label.h |    3 +++
 arch/mips/kernel/module.c          |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/jump_label.h~mips-move-jump_label_apply_nops-declaration-to-header
+++ a/arch/mips/include/asm/jump_label.h
@@ -15,6 +15,9 @@
 #include <linux/types.h>
 #include <asm/isa-rev.h>
 
+struct module;
+extern void jump_label_apply_nops(struct module *mod);
+
 #define JUMP_LABEL_NOP_SIZE 4
 
 #ifdef CONFIG_64BIT
--- a/arch/mips/kernel/module.c~mips-move-jump_label_apply_nops-declaration-to-header
+++ a/arch/mips/kernel/module.c
@@ -20,8 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/jump_label.h>
-
-extern void jump_label_apply_nops(struct module *mod);
+#include <asm/jump_label.h>
 
 struct mips_hi16 {
 	struct mips_hi16 *next;
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

