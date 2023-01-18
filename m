Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E150C678D4
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjARXzH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjARXyq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:54:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12AC4DBD8
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE786B81D69
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE31C433D2;
        Wed, 18 Jan 2023 23:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086069;
        bh=bFMi8a5lT3rZB3s6AYljri3obQ1ZTa+LwGRAE2rSnes=;
        h=Date:To:From:Subject:From;
        b=rUZRTS3euBqJ77IoCOPVFt5YlFURiF7cSwAS/aiDdawRIaC5yf8wJNF4vH2yk56BW
         HaTbGdg2NF5jzGLF+OLLZq3rxBB3/Fxha+T+4R5sJqSzkxJ3YNmRRCWHQMY1+fhFhh
         chr9rYnFvS8xRKd/7RwnP9pF4/MYwTk4ECFgV8Xc=
Date:   Wed, 18 Jan 2023 15:54:28 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch removed from -mm tree
Message-Id: <20230118235429.5DE31C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup: mm/mprotect: drop pgprot_t parameter from change_protection()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch

This patch was dropped because it was folded into mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/mprotect: drop pgprot_t parameter from change_protection()
Date: Sat, 24 Dec 2022 15:01:18 +0100

PAGE_NONE might not be defined without CONFIG_NUMA_BALANCING

Link: https://lkml.kernel.org/r/5084ff1c-ebb3-f918-6a60-bacabf550a88@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mprotect.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix
+++ a/mm/mprotect.c
@@ -514,6 +514,7 @@ unsigned long change_protection(struct m
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 
+#ifdef CONFIG_NUMA_BALANCING
 	/*
 	 * Ordinary protection updates (mprotect, uffd-wp, softdirty tracking)
 	 * are expected to reflect their requirements via VMA flags such that
@@ -521,6 +522,9 @@ unsigned long change_protection(struct m
 	 */
 	if (cp_flags & MM_CP_PROT_NUMA)
 		newprot = PAGE_NONE;
+#else
+	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
+#endif
 
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
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

