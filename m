Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57988C6FA8A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiILDbU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiILD3a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE75D28707
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5A68B80C7B
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBB7C433B5;
        Mon, 12 Sep 2022 03:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953350;
        bh=LRBe8YQZKBSmvVHubE/hypk0YXFaj3+drytfaGUgebw=;
        h=Date:To:From:Subject:From;
        b=Jz/n6JhrPANN8RgcNS/OQ3i7fHymidPHexFiwaxk2Ov2+IDzmUiqsBLRB+T6Ay/cN
         iRndoZj9bzH2nCcoAPrMNk3HP1V8wILEaQFpMT27EYucADsoQDyX6tS3TAXn90NHlj
         BmqnwuWfO1FYzT/08kidQZ+CbYMAWcjxJEymb9/8=
Date:   Sun, 11 Sep 2022 20:29:09 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch removed from -mm tree
Message-Id: <20220912032910.5BBB7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix missing call to restore_reserve_on_error()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix missing call to restore_reserve_on_error()
Date: Tue, 16 Aug 2022 21:05:50 +0800

When huge_add_to_page_cache() fails, the page is freed directly without
calling restore_reserve_on_error() to restore reserve for newly allocated
pages not in page cache.  Fix this by calling restore_reserve_on_error()
when huge_add_to_page_cache fails.

[linmiaohe@huawei.com: remove err == -EEXIST check and retry logic]
  Link: https://lkml.kernel.org/r/20220823030209.57434-4-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220816130553.31406-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-call-to-restore_reserve_on_error
+++ a/mm/hugetlb.c
@@ -5563,7 +5563,6 @@ static vm_fault_t hugetlb_no_page(struct
 	if (idx >= size)
 		goto out;
 
-retry:
 	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
@@ -5603,9 +5602,15 @@ retry:
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = huge_add_to_page_cache(page, mapping, idx);
 			if (err) {
+				/*
+				 * err can't be -EEXIST which implies someone
+				 * else consumed the reservation since hugetlb
+				 * fault mutex is held when add a hugetlb page
+				 * to the page cache. So it's safe to call
+				 * restore_reserve_on_error() here.
+				 */
+				restore_reserve_on_error(h, vma, haddr, page);
 				put_page(page);
-				if (err == -EEXIST)
-					goto retry;
 				goto out;
 			}
 			new_pagecache_page = true;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

