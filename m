Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EA3C38159
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjARXzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjARXye (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71813457DA
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:53:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E93E4B81F6C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984DCC433EF;
        Wed, 18 Jan 2023 23:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086034;
        bh=6uWmseHcqioqw2MaFnAxa2LBv7bZcf0w2jB6Ac+uiCg=;
        h=Date:To:From:Subject:From;
        b=j2G0h0w30FmxUyWOHLFBwD5wewcY/xTP1k5Wt0zdZh0WLYMdk7Rxg0r29xlfZdSmG
         4ZrQUqafR+OzuXDtteBrrHZJKjJoFP7Fxe4SAKmO9iy2l50oC2huX1USpT2C+tdEEH
         azCcW8LZw/oyC3rmAEJ0u1zGLRfs4TpdZMZbl5bk=
Date:   Wed, 18 Jan 2023 15:53:54 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch removed from -mm tree
Message-Id: <20230118235354.984DCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch

This patch was dropped because it was folded into mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
Date: Sat, 24 Dec 2022 15:02:36 +0100

No need for additional harmless checks if we're wr-protecting either way.

Link: https://lkml.kernel.org/r/71412742-a71f-9c74-865f-773ad83db7a5@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/userfaultfd.c~mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix
+++ a/mm/userfaultfd.c
@@ -727,7 +727,7 @@ void uffd_wp_range(struct mm_struct *dst
 	 * to be write-protected as default whenever protection changes.
 	 * Try upgrading write permissions manually.
 	 */
-	if (vma_wants_manual_pte_write_upgrade(dst_vma))
+	if (!enable_wp && vma_wants_manual_pte_write_upgrade(dst_vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	tlb_gather_mmu(&tlb, dst_mm);
 	change_protection(&tlb, dst_vma, start, start + len, vma->vm_page_prot,
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch
selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch
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

