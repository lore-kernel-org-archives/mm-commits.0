Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5823EE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjHUUlF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjHUUk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652C9E6A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC67D64B11
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09158C433C8;
        Mon, 21 Aug 2023 20:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650405;
        bh=2S44AZHX9xNSKMwL1NMmjFJbpj2KeYGpH2KO6Y6ARfs=;
        h=Date:To:From:Subject:From;
        b=F04G/pvcRBwAsXKMPH9rqpxR/UwHIN/KMyJS7gr4owHUEyYBj7jN8yuokNNmXdtb2
         h79PgbVcfTPpKbd+qmG/d3qMCx2RYdzxs8sdhlNKBNBFCjPUaSoLjL+uAv/r6EU4e1
         6m6emQgcalC5WGWbNYiGXvRMCG0+tn0J5rNUc1E0=
Date:   Mon, 21 Aug 2023 13:40:04 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        william.kucharski@oracle.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, kirill@shutemov.name,
        kaleshsingh@google.com, joel@joelfernandes.org,
        catalin.marinas@arm.com, almasrymina@google.com, 21cnbao@gmail.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch removed from -mm tree
Message-Id: <20230821204005.09158C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: use flush_hugetlb_tlb_range() in move_hugetlb_page_tables()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5279,9 +5279,9 @@ int move_hugetlb_page_tables(struct vm_a
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


