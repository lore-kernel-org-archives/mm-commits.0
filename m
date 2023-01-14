Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9B0C67871
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjANETv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjANETi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:19:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC5FA7
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:19:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A33F608C3
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFE8C433F0;
        Sat, 14 Jan 2023 04:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669976;
        bh=RlM6jzwYUbOaj9eq4JAxhGahWOw3ZP4gPlEQ6zW8YYQ=;
        h=Date:To:From:Subject:From;
        b=llJKRr9faSWpIjCM4ht5GYHoEa8fewddvptqWpmAB2V5s86sKthEQ0RBGzElcj42D
         Jn+B6pfpX7F9txbCTdS5yUHqr+vKFRI3tolflmlmlYZwrm/1rdcyyw74wiHdI90otA
         J4rwsXLbYEQryKB+29EprnMXhg+HxqgjGgkUqja0=
Date:   Fri, 13 Jan 2023 20:19:35 -0800
To:     mm-commits@vger.kernel.org, dinguyen@kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nios2-mm-refactor-swap-pte-layout.patch added to mm-unstable branch
Message-Id: <20230114041936.6FFE8C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2/mm: refactor swap PTE layout
has been added to the -mm mm-unstable branch.  Its filename is
     nios2-mm-refactor-swap-pte-layout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nios2-mm-refactor-swap-pte-layout.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: nios2/mm: refactor swap PTE layout
Date: Fri, 13 Jan 2023 18:10:13 +0100

nios2 disables swap for a good reason: it doesn't even provide sufficient
type bits as required by core MM.  However, swap entries are nowadays also
used for other purposes (migration entries, PTE markers, HWPoison, ...),
and accidential use could be problematic.

Let's properly use 5 bits for the swap type and document the layout.  Bits
26--31 should get ignored by hardware completely, so they can be used.

Link: https://lkml.kernel.org/r/20230113171026.582290-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/nios2/include/asm/pgtable.h~nios2-mm-refactor-swap-pte-layout
+++ a/arch/nios2/include/asm/pgtable.h
@@ -232,19 +232,21 @@ static inline unsigned long pmd_page_vad
 		__FILE__, __LINE__, pgd_val(e))
 
 /*
- * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte):
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
  *
- * 31 30 29 28 27 26 25 24 23 22 21 20 19 18 ...  1  0
- *  0  0  0  0 type.  0  0  0  0  0  0 offset.........
+ * Format of swap PTEs:
  *
- * This gives us up to 2**2 = 4 swap files and 2**20 * 4K = 4G per swap file.
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   0 < type -> 0 0 0 0 0 0 <-------------- offset --------------->
  *
- * Note that the offset field is always non-zero, thus !pte_none(pte) is always
- * true.
+ * Note that the offset field is always non-zero if the swap type is 0, thus
+ * !pte_none() is always true.
  */
-#define __swp_type(swp)		(((swp).val >> 26) & 0x3)
+#define __swp_type(swp)		(((swp).val >> 26) & 0x1f)
 #define __swp_offset(swp)	((swp).val & 0xfffff)
-#define __swp_entry(type, off)	((swp_entry_t) { (((type) & 0x3) << 26) \
+#define __swp_entry(type, off)	((swp_entry_t) { (((type) & 0x1f) << 26) \
 						 | ((off) & 0xfffff) })
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch
selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

