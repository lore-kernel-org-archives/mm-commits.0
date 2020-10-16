Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258C0C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52A12087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817513;
	bh=59O6rwBETi3fXBQMh7mdRlcZQ0kAc5DJljSfHMwlfKA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=n+VtIreTgWHx8xHOoH2NaGM0DIi+OdgiEjIbXBDU7hvs//p1YaU6+8R4c5RJbmPP+
	 pILyAbSSviY7671qzS78TdFvS0OSQDqBFC/h2FQDGwBlcnsYrRO/ubIW1ENEXV00qO
	 Ye1YxWnhesaUl5rKVqOXxINDVD8ErQgDePduQYoQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392224AbgJPDFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C912087D;
        Fri, 16 Oct 2020 03:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817511;
        bh=59O6rwBETi3fXBQMh7mdRlcZQ0kAc5DJljSfHMwlfKA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pIwDrWTPV3YAG6SVmiLZIBrrnGrEnRbRd0KO03Uqa5cElKo1oMl/efiWAFUsS8ABA
         gzOa4ujg1Axztpah6JngkVjz0QiKirT3RPCLkRICJfyNflCbku56S+Ss0cZ+Bhvv8Q
         Jf+Jc/wxDU/RG02d8DrWyENwsMx8rWlLI2xy5KZA=
Date:   Thu, 15 Oct 2020 20:05:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        lkp@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 015/156] mm/debug_vm_pgtable: avoid doing memory
 allocation with pgtable_t mapped.
Message-ID: <20201016030510.BsCfzwvmq%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable: avoid doing memory allocation with pgtable_t mapped.

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

Link: https://lkml.kernel.org/r/20200913110327.645310-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped
+++ a/mm/debug_vm_pgtable.c
@@ -945,7 +945,13 @@ static int __init debug_vm_pgtable(void)
 	p4dp = p4d_alloc(mm, pgdp, vaddr);
 	pudp = pud_alloc(mm, p4dp, vaddr);
 	pmdp = pmd_alloc(mm, pudp, vaddr);
-	ptep = pte_alloc_map(mm, pmdp, vaddr);
+	/*
+	 * Allocate pgtable_t
+	 */
+	if (pte_alloc(mm, pmdp)) {
+		pr_err("pgtable allocation failed\n");
+		return 1;
+	}
 
 	/*
 	 * Save all the page table page addresses as the page table
@@ -999,8 +1005,7 @@ static int __init debug_vm_pgtable(void)
 	 * proper page table lock.
 	 */
 
-	ptl = pte_lockptr(mm, pmdp);
-	spin_lock(ptl);
+	ptep = pte_offset_map_lock(mm, pmdp, vaddr, &ptl);
 	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
 	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
 	pte_unmap_unlock(ptep, ptl);
_
