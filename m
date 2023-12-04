Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4109C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjLDTWB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjLDTVz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:21:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91446109
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:22:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F76BC433CA;
        Mon,  4 Dec 2023 19:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717721;
        bh=Zr+lN9xajfCPeZY6yGCBEjLS5knrLBIPU/1EMqUswMg=;
        h=Date:To:From:Subject:From;
        b=wvT8i3HnW280iq+h74Hldix1TlIBmHsGbRapZwECkJk7whw3mNgY/TcvG4/JIPwTq
         c8lYYjDVLXvP1MbukSpOMv8tCyoqrwME25kgGAgyzA6I0Xz7+4JPZPrgIyOtSv4rVv
         Hja5RYSF6LvdzI3sHFeV/abn+1PHMlVgLRFahZgY=
Date:   Mon, 04 Dec 2023 11:22:00 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-hide-conditionally-unused-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20231204192201.2F76BC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: hide conditionally unused functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-hide-conditionally-unused-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-hide-conditionally-unused-functions.patch

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
Subject: mips: hide conditionally unused functions
Date: Mon, 4 Dec 2023 12:57:08 +0100

A couple of functions are defined unconditionally but have a conditional
declaration:

arch/mips/mm/tlb-r4k.c:461:12: error: no previous prototype for 'add_temporary_entry' [-Werror=missing-prototypes]
arch/mips/mm/pgtable-64.c:92:7: error: no previous prototype for 'mk_pmd' [-Werror=missing-prototypes]
arch/mips/mm/pgtable-64.c:101:6: error: no previous prototype for 'set_pmd_at' [-Werror=missing-prototypes]

Since there are no callers in these configurations, add the same #ifdef
checks around the definitions.

Link: https://lkml.kernel.org/r/20231204115710.2247097-19-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/pgtable-64.c |    2 ++
 arch/mips/mm/tlb-r4k.c    |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/mips/mm/pgtable-64.c~mips-hide-conditionally-unused-functions
+++ a/arch/mips/mm/pgtable-64.c
@@ -89,6 +89,7 @@ void pud_init(void *addr)
 }
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 pmd_t mk_pmd(struct page *page, pgprot_t prot)
 {
 	pmd_t pmd;
@@ -103,6 +104,7 @@ void set_pmd_at(struct mm_struct *mm, un
 {
 	*pmdp = pmd;
 }
+#endif
 
 void __init pagetable_init(void)
 {
--- a/arch/mips/mm/tlb-r4k.c~mips-hide-conditionally-unused-functions
+++ a/arch/mips/mm/tlb-r4k.c
@@ -458,6 +458,7 @@ EXPORT_SYMBOL(has_transparent_hugepage);
 
 int temp_tlb_entry;
 
+#ifndef CONFIG_64BIT
 __init int add_temporary_entry(unsigned long entrylo0, unsigned long entrylo1,
 			       unsigned long entryhi, unsigned long pagemask)
 {
@@ -496,6 +497,7 @@ out:
 	local_irq_restore(flags);
 	return ret;
 }
+#endif
 
 static int ntlb;
 static int __init set_ntlb(char *str)
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

