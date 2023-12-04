Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161BBC46CA3
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbjLDTVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjLDTVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855BEF0
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C2FC433C7;
        Mon,  4 Dec 2023 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717698;
        bh=tWLnaB/CYP6udHdAFmLA2t9Je5O3UgP+arV8pY9Uxpw=;
        h=Date:To:From:Subject:From;
        b=Acec9b4Hix2gCxufFPPELRuMzDtbAxSnXeSXr04tcgnBIWwqsoES//2WhZBNxBGKO
         kPMky004vBflL26TRK8/ktSPj5hKtb6iZs3tVwAcweE4HWhiG8TnC/7USiJnj6NyT7
         puYyysw9FjbU979P6u9kCvfoVx3LISLA4Lneqjss=
Date:   Mon, 04 Dec 2023 11:21:37 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-move-build_tlb_refill_handler-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192138.21C2FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: move build_tlb_refill_handler() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-move-build_tlb_refill_handler-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-move-build_tlb_refill_handler-prototype.patch

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
Subject: mips: move build_tlb_refill_handler() prototype
Date: Mon, 4 Dec 2023 12:56:57 +0100

Instead of having a declaration for each caller, have one that is shared
with the function definition, which avoids a warning:

arch/mips/mm/tlbex.c:2547:6: error: no previous prototype for 'build_tlb_refill_handler' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-8-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/tlbex.h |    1 +
 arch/mips/mm/tlb-r3k.c        |    3 +--
 arch/mips/mm/tlb-r4k.c        |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/mips/include/asm/tlbex.h~mips-move-build_tlb_refill_handler-prototype
+++ a/arch/mips/include/asm/tlbex.h
@@ -23,6 +23,7 @@ void build_update_entries(u32 **p, unsig
 void build_tlb_write_entry(u32 **p, struct uasm_label **l,
 			   struct uasm_reloc **r,
 			   enum tlb_write_entry wmode);
+void build_tlb_refill_handler(void);
 
 extern void handle_tlbl(void);
 extern char handle_tlbl_end[];
--- a/arch/mips/mm/tlb-r3k.c~mips-move-build_tlb_refill_handler-prototype
+++ a/arch/mips/mm/tlb-r3k.c
@@ -23,11 +23,10 @@
 #include <asm/io.h>
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
+#include <asm/tlbex.h>
 
 #undef DEBUG_TLB
 
-extern void build_tlb_refill_handler(void);
-
 /* CP0 hazard avoidance. */
 #define BARRIER				\
 	__asm__ __volatile__(		\
--- a/arch/mips/mm/tlb-r4k.c~mips-move-build_tlb_refill_handler-prototype
+++ a/arch/mips/mm/tlb-r4k.c
@@ -22,10 +22,9 @@
 #include <asm/hazards.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+#include <asm/tlbex.h>
 #include <asm/tlbmisc.h>
 
-extern void build_tlb_refill_handler(void);
-
 /*
  * LOONGSON-2 has a 4 entry itlb which is a subset of jtlb, LOONGSON-3 has
  * a 4 entry itlb and a 4 entry dtlb which are subsets of jtlb. Unfortunately,
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

