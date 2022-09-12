Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7C7C6FA8B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiILDgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiILDdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3822A274
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D42B80C74
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA95C433C1;
        Mon, 12 Sep 2022 03:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953445;
        bh=EMlXhClcSoXJ4ullv8O+j9MvYkMLhCJdb6L+tuki/UA=;
        h=Date:To:From:Subject:From;
        b=qBgOHbnZ/Yf1McpA4f7lFhFu4xm0CjZUFd+vuRhq5a0z0sxyGpBOMGnLTJe3AJlm5
         WJVXILTnrNMch5ImyAjlcmoS5lkJ23MM3YHUo2O7iqv7AP1vMyawzspBNe99SHne6H
         kW6v12L0Izr61iU4VQOL6rsalQv6S9iAjHozhUdQ=
Date:   Sun, 11 Sep 2022 20:30:44 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-use-helper-huge_ptepmd_lock.patch removed from -mm tree
Message-Id: <20220912033045.9BA95C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: use helper {huge_pte|pmd}_lock()
has been removed from the -mm tree.  Its filename was
     hugetlb-use-helper-huge_ptepmd_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: use helper {huge_pte|pmd}_lock()
Date: Thu, 1 Sep 2022 20:00:25 +0800

Use helper huge_pte_lock and pmd_lock to simplify the code. No functional
change intended.

Link: https://lkml.kernel.org/r/20220901120030.63318-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-helper-huge_ptepmd_lock
+++ a/mm/hugetlb.c
@@ -6049,8 +6049,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		page_in_pagecache = true;
 	}
 
-	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
-	spin_lock(ptl);
+	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
 	/*
 	 * Recheck the i_size after holding PT lock to make sure not
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

