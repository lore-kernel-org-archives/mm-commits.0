Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B47BC46CA0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjLDTVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjLDTVn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A796116
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:21:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC996C433C7;
        Mon,  4 Dec 2023 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717708;
        bh=f0Uii3UsAa4WbouebBfeosWF0vl2muu2mAgEnu9sYVs=;
        h=Date:To:From:Subject:From;
        b=GCSTedWlabXUh5atZ3xevNeMUW8ohWfI3y7sWup33C2/rQ2EGFwEpHWEiA+ykl/PS
         UTqMy37cvGN/UlYIgDYxSAIJA96CqzClwR2NBFwSBCEgXvGMNdwVw9EVUIOkQ8NAgq
         h1oJdHWIATXVGAm2vHVkwCT403uAz1+4be9M2ywg=
Date:   Mon, 04 Dec 2023 11:21:48 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-move-cache-declarations-into-header.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192148.CC996C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: move cache declarations into header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-move-cache-declarations-into-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-move-cache-declarations-into-header.patch

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
Subject: mips: move cache declarations into header
Date: Mon, 4 Dec 2023 12:57:02 +0100

Some of the cache functions are declared only for their callers, e.g.

arch/mips/mm/c-r3k.c:28:15: error: no previous prototype for 'r3k_cache_size' [-Werror=missing-prototypes]
arch/mips/mm/c-r3k.c:63:15: error: no previous prototype for 'r3k_cache_lsize' [-Werror=missing-prototypes]
arch/mips/mm/c-r4k.c:1703:6: error: no previous prototype for 'r4k_cache_init' [-Werror=missing-prototypes]
arch/mips/mm/sc-mips.c:255:5: error: no previous prototype for 'mips_sc_init' [-Werror=missing-prototypes]

Move all the declarations to asm/cache.h and asm/r4kcache.h where they
can be seen by the function definitions.

Link: https://lkml.kernel.org/r/20231204115710.2247097-13-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cache.h    |    6 ++++++
 arch/mips/include/asm/r4kcache.h |    4 ++++
 arch/mips/kernel/cpu-probe.c     |    1 -
 arch/mips/kernel/cpu-r3k-probe.c |    1 -
 arch/mips/mm/c-r4k.c             |    4 ----
 arch/mips/mm/cache.c             |    6 ------
 6 files changed, 10 insertions(+), 12 deletions(-)

--- a/arch/mips/include/asm/cache.h~mips-move-cache-declarations-into-header
+++ a/arch/mips/include/asm/cache.h
@@ -17,5 +17,11 @@
 #define __read_mostly __section(".data..read_mostly")
 
 extern void cache_noop(void);
+extern void r3k_cache_init(void);
+extern unsigned long r3k_cache_size(unsigned long);
+extern unsigned long r3k_cache_lsize(unsigned long);
+extern void r4k_cache_init(void);
+extern void octeon_cache_init(void);
+extern void au1x00_fixup_config_od(void);
 
 #endif /* _ASM_CACHE_H */
--- a/arch/mips/include/asm/r4kcache.h~mips-move-cache-declarations-into-header
+++ a/arch/mips/include/asm/r4kcache.h
@@ -24,6 +24,10 @@
 #include <asm/mmzone.h>
 #include <asm/unroll.h>
 
+extern void r5k_sc_init(void);
+extern void rm7k_sc_init(void);
+extern int mips_sc_init(void);
+
 extern void (*r4k_blast_dcache)(void);
 extern void (*r4k_blast_icache)(void);
 
--- a/arch/mips/kernel/cpu-probe.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/kernel/cpu-probe.c
@@ -179,7 +179,6 @@ void __init check_bugs32(void)
 static inline int cpu_has_confreg(void)
 {
 #ifdef CONFIG_CPU_R3000
-	extern unsigned long r3k_cache_size(unsigned long);
 	unsigned long size1, size2;
 	unsigned long cfg = read_c0_conf();
 
--- a/arch/mips/kernel/cpu-r3k-probe.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/kernel/cpu-r3k-probe.c
@@ -42,7 +42,6 @@ void __init check_bugs32(void)
 static inline int cpu_has_confreg(void)
 {
 #ifdef CONFIG_CPU_R3000
-	extern unsigned long r3k_cache_size(unsigned long);
 	unsigned long size1, size2;
 	unsigned long cfg = read_c0_conf();
 
--- a/arch/mips/mm/cache.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/mm/cache.c
@@ -206,19 +206,13 @@ static inline void setup_protection_map(
 void cpu_cache_init(void)
 {
 	if (cpu_has_3k_cache) {
-		extern void __weak r3k_cache_init(void);
-
 		r3k_cache_init();
 	}
 	if (cpu_has_4k_cache) {
-		extern void __weak r4k_cache_init(void);
-
 		r4k_cache_init();
 	}
 
 	if (cpu_has_octeon_cache) {
-		extern void __weak octeon_cache_init(void);
-
 		octeon_cache_init();
 	}
 
--- a/arch/mips/mm/c-r4k.c~mips-move-cache-declarations-into-header
+++ a/arch/mips/mm/c-r4k.c
@@ -1485,10 +1485,6 @@ static void loongson3_sc_init(void)
 	return;
 }
 
-extern int r5k_sc_init(void);
-extern int rm7k_sc_init(void);
-extern int mips_sc_init(void);
-
 static void setup_scache(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
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

