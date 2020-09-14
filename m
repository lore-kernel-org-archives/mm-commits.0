Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7598C43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E5721D1A
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600041873;
	bh=/FLRBFIJje5lrFWUEfkintGzpR0EAhJm7tWX5EF8yMw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Nciv8VayQXsNmAhIdTv9M4NW90nw91LoyKgIXoGP6wE1qdMYZoAajqb1hRYjIaQeN
	 UtuzOgH5fLM1FU619+uyM0JCO95AXYfb4R23bU3xHGGjlXckQrJ+/Fq5OAVPlnca5b
	 Ngf7+PUZQdLiNvT+yFU1f9jdsreZlr/eAkk28OhU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgINAEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgINAEc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:04:32 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268F621D1A;
        Mon, 14 Sep 2020 00:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600041871;
        bh=/FLRBFIJje5lrFWUEfkintGzpR0EAhJm7tWX5EF8yMw=;
        h=Date:From:To:Subject:From;
        b=knfEZNzALGb5z0Ow0UlecpEdnIX6Smq7qKbWvDm3E30u4sXsRUkkrUbuA1exqHtEE
         QfSp4g6z06JPyoK2NeQiZs4kpXVHUXcGCbixj8b41ZjcgDUnPrrB1IP2Qjq/GNfD9s
         XMvBdpbDZew+47ew7wIk21RO9y154sOiUW3sEcf4=
Date:   Sun, 13 Sep 2020 17:04:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped.patch
 added to -mm tree
Message-ID: <20200914000430.hKqqS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: Avoid doing memory allocation with pgtable_t mapped
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable: Avoid doing memory allocation with pgtable_t mapped

With highmem, pte_alloc_map() keep the level4 page table mapped using
kmap_atomic().  Avoid doing new memory allocation with page table mapped
like above.

[    9.409233] BUG: sleeping function called from invalid context at mm/page_alloc.c:4822
[    9.410557] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper
[    9.411932] no locks held by swapper/1.
[    9.412595] CPU: 0 PID: 1 Comm: swapper Not tainted 5.9.0-rc3-00323-gc50eb1ed654b5 #2
[    9.413824] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[    9.415207] Call Trace:
[    9.415651]  ? ___might_sleep.cold+0xa7/0xcc
[    9.416367]  ? __alloc_pages_nodemask+0x14c/0x5b0
[    9.417055]  ? swap_migration_tests+0x50/0x293
[    9.417704]  ? debug_vm_pgtable+0x4bc/0x708
[    9.418287]  ? swap_migration_tests+0x293/0x293
[    9.418911]  ? do_one_initcall+0x82/0x3cb
[    9.419465]  ? parse_args+0x1bd/0x280
[    9.419983]  ? rcu_read_lock_sched_held+0x36/0x60
[    9.420673]  ? trace_initcall_level+0x1f/0xf3
[    9.421279]  ? trace_initcall_level+0xbd/0xf3
[    9.421881]  ? do_basic_setup+0x9d/0xdd
[    9.422410]  ? do_basic_setup+0xc3/0xdd
[    9.422938]  ? kernel_init_freeable+0x72/0xa3
[    9.423539]  ? rest_init+0x134/0x134
[    9.424055]  ? kernel_init+0x5/0x12c
[    9.424574]  ? ret_from_fork+0x19/0x30

Link: https://lkml.kernel.org/r/87wo0yw0gk.fsf@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped
+++ a/mm/debug_vm_pgtable.c
@@ -994,7 +994,10 @@ static int __init debug_vm_pgtable(void)
 	p4dp = p4d_alloc(mm, pgdp, vaddr);
 	pudp = pud_alloc(mm, p4dp, vaddr);
 	pmdp = pmd_alloc(mm, pudp, vaddr);
-	ptep = pte_alloc_map(mm, pmdp, vaddr);
+	/*
+	 * Allocate pgtable_t
+	 */
+	pte_alloc(mm, pmdp);
 
 	/*
 	 * Save all the page table page addresses as the page table
@@ -1048,8 +1051,7 @@ static int __init debug_vm_pgtable(void)
 	 * proper page table lock.
 	 */
 
-	ptl = pte_lockptr(mm, pmdp);
-	spin_lock(ptl);
+	ptep = pte_offset_map_lock(mm, pmdp, vaddr, &ptl);
 	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
 	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
 	pte_unmap_unlock(ptep, ptl);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

powerpc-mm-add-debug_vm-warn-for-pmd_clear.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch
mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch
mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch
mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch
mm-debug_vm_pgtable-thp-mark-the-pte-entry-huge-before-using-set_pmd-pud_at.patch
mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch
mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together.patch
mm-debug_vm_pgtable-locks-take-correct-page-table-lock.patch
mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch
mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch
mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch
mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped.patch

