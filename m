Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F350C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E8A64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhBYTdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234875AbhBYTaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F8D64F18;
        Thu, 25 Feb 2021 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280632;
        bh=KzgAkexKi7tK6PGQrINyo/1RVyY3c+WxZyo4JjdMBc4=;
        h=Date:From:To:Subject:From;
        b=XBnXNCkpYdJgiPMWfrmvAN5oDB1LZhpsNrCI2sGtJef0B3K091PSy52YRmt40ouAb
         VgTHo5aaVXeqg9RQeafhSHgEdnlE3U9Dao9znIAvOTD1tfLTeDOPVvHW+Yb1zBL3Up
         IsZSU2bsOfqYPrnwkQ7q1K7Y7+4siJLfM1ygEr7Y=
Date:   Thu, 25 Feb 2021 11:17:12 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch
 removed from -mm tree
Message-ID: <20210225191712.og48qUAgq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: use helper pages_per_huge_page() in hugetlb_cgroup
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: use helper pages_per_huge_page() in hugetlb_cgroup

We could use helper function pages_per_huge_page() to get the number of
pages in a hstate to simplify the code slightly.

Link: https://lkml.kernel.org/r/20210205084513.29624-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup
+++ a/mm/hugetlb_cgroup.c
@@ -113,7 +113,7 @@ static void hugetlb_cgroup_init(struct h
 			rsvd_parent);
 
 		limit = round_down(PAGE_COUNTER_MAX,
-				   1 << huge_page_order(&hstates[idx]));
+				   pages_per_huge_page(&hstates[idx]));
 
 		ret = page_counter_set_max(
 			hugetlb_cgroup_counter_from_cgroup(h_cgroup, idx),
@@ -460,7 +460,7 @@ static int hugetlb_cgroup_read_u64_max(s
 	counter = &h_cg->hugepage[idx];
 
 	limit = round_down(PAGE_COUNTER_MAX,
-			   1 << huge_page_order(&hstates[idx]));
+			   pages_per_huge_page(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_RSVD_USAGE:
@@ -507,7 +507,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		return ret;
 
 	idx = MEMFILE_IDX(of_cft(of)->private);
-	nr_pages = round_down(nr_pages, 1 << huge_page_order(&hstates[idx]));
+	nr_pages = round_down(nr_pages, pages_per_huge_page(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_RSVD_LIMIT:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

