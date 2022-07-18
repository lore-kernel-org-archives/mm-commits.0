Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063E1C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiGRAVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiGRAUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBA214D15
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747AE60F54
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E5EC341C0;
        Mon, 18 Jul 2022 00:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103518;
        bh=YRcG8ENr30lrMZP2sVYQw5aELhpusuNpGvRa4rEFshI=;
        h=Date:To:From:Subject:From;
        b=qFNkrJwKA78mDTFYPetlleWRltBo+aqzE1wY3FNnxo01beR1NVeUkA2d+5+mIu4P0
         NCu+RM1dG24ZvFoilsXUj/hTOJYJHDUw14RSMF5B3yF17X0c8Y7BUsDAQXnbhGXWkq
         TerqrZ6dyQFWdooMbWCVDTtHbT2IO7nAPDU02y8c=
Date:   Sun, 17 Jul 2022 17:18:38 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-correct-comment-of-prep_transhuge_page.patch removed from -mm tree
Message-Id: <20220718001838.C6E5EC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: correct comment of prep_transhuge_page
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-correct-comment-of-prep_transhuge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: correct comment of prep_transhuge_page
Date: Mon, 4 Jul 2022 21:21:59 +0800

We use page->mapping and page->index, instead of page->indexlru in second
tail page as list_head. Correct it.

Link: https://lkml.kernel.org/r/20220704132201.14611-15-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-correct-comment-of-prep_transhuge_page
+++ a/mm/huge_memory.c
@@ -581,7 +581,7 @@ static inline struct deferred_split *get
 void prep_transhuge_page(struct page *page)
 {
 	/*
-	 * we use page->mapping and page->indexlru in second tail page
+	 * we use page->mapping and page->index in second tail page
 	 * as list_head: assuming THP order >= 2
 	 */
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

