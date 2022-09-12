Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C60AC6FA8D
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiILDgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiILDdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4482A407
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7891B80C7E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEE6C433C1;
        Mon, 12 Sep 2022 03:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953449;
        bh=kg4skx688zYv8PfiOsk/PR+S7RTZKwGFcpozp8ZIWSI=;
        h=Date:To:From:Subject:From;
        b=DdqFLJJKr5DTxBwhkCQg/wR+TQUItyPvKDXCOHSHvNc2g25K2ftZZiNixxUnI5uL5
         GDs6n1TffH2lcslzsjeuoVxY7Ytz+Lf8J+u8bKLX3w5AEjLAluuL2ojzRDlvHl8+Qn
         uISOvVWjMPx6c3oYNs6KxWZBu13YeESXjO9a7X+8=
Date:   Sun, 11 Sep 2022 20:30:48 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-add-comment-for-subtle-sethpagevmemmapoptimized.patch removed from -mm tree
Message-Id: <20220912033049.5EEE6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: add comment for subtle SetHPageVmemmapOptimized()
has been removed from the -mm tree.  Its filename was
     hugetlb-add-comment-for-subtle-sethpagevmemmapoptimized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: add comment for subtle SetHPageVmemmapOptimized()
Date: Thu, 1 Sep 2022 20:00:28 +0800

The SetHPageVmemmapOptimized() called here seems unnecessary as it's
assumed to be set when calling this function. But it's indeed cleared
by above set_page_private(page, 0). Add a comment to avoid possible
future confusion.

Link: https://lkml.kernel.org/r/20220901120030.63318-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/hugetlb.c~hugetlb-add-comment-for-subtle-sethpagevmemmapoptimized
+++ a/mm/hugetlb.c
@@ -1504,6 +1504,10 @@ static void add_hugetlb_page(struct hsta
 
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	set_page_private(page, 0);
+	/*
+	 * We have to set HPageVmemmapOptimized again as above
+	 * set_page_private(page, 0) cleared it.
+	 */
 	SetHPageVmemmapOptimized(page);
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

