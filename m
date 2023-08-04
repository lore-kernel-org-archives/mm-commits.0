Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3D2C001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjHDSA5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjHDSA5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8C946A0
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A40E8620B2
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F0CC433C8;
        Fri,  4 Aug 2023 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172055;
        bh=VUvhOVXG5PsEJzDrVPgIOo+PoRAie+7ilygL3wUbaoA=;
        h=Date:To:From:Subject:From;
        b=ZdEyURcVGmhsWK/bRHuTsKtFalBZ7Zm1+77VIVrkOf7BDisBX/54gf0ry0Q0ScPSt
         tH/57Txob/r26TG8bAkK859hy1FqLjHkHryM17hNrUHlKRlLKC8UX7hPU6O+rGepM3
         xjeXlPSzTxLXaJdXI3lC5fUujnMd7lT5dnAMMP9s=
Date:   Fri, 04 Aug 2023 11:00:54 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        william.kucharski@oracle.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, kirill@shutemov.name,
        kaleshsingh@google.com, joel@joelfernandes.org,
        catalin.marinas@arm.com, almasrymina@google.com, 21cnbao@gmail.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch added to mm-unstable branch
Message-Id: <20230804180055.03F0CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: use flush_hugetlb_tlb_range() in move_hugetlb_page_tables()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: use flush_hugetlb_tlb_range() in move_hugetlb_page_tables()
Date: Tue, 1 Aug 2023 10:31:44 +0800

Archs may need to do special things when flushing hugepage tlb, so use the
more applicable flush_hugetlb_tlb_range() instead of flush_tlb_range().

Link: https://lkml.kernel.org/r/20230801023145.17026-2-wangkefeng.wang@huawei.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables
+++ a/mm/hugetlb.c
@@ -5306,9 +5306,9 @@ int move_hugetlb_page_tables(struct vm_a
 	}
 
 	if (shared_pmd)
-		flush_tlb_range(vma, range.start, range.end);
+		flush_hugetlb_tlb_range(vma, range.start, range.end);
 	else
-		flush_tlb_range(vma, old_end - len, old_end);
+		flush_hugetlb_tlb_range(vma, old_end - len, old_end);
 	mmu_notifier_invalidate_range_end(&range);
 	i_mmap_unlock_write(mapping);
 	hugetlb_vma_unlock_write(vma);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch
arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch

