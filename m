Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68666C4332B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0BB64F27
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhBXUIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234839AbhBXUH6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03E8364F28;
        Wed, 24 Feb 2021 20:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197257;
        bh=TODsPkWC3h62fUhX/PuCRZMw/GoI2cyuofAu66TO1Ag=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YRjX29Do/fMtGh0bvBYR18h4BMxQ3BWG3mEYwnS1Rtqn7Ctkxt3pilOImWyk75O3A
         B5AeM1NPVf1K+VGQPQYiztoYyItbISJHV4tz9py1VmHRuR57oWz/WTpTmemZ+dXmcm
         nrbCnpxOWV3+u7qOJWWxdvncE3DeNrVheHL6DUsU=
Date:   Wed, 24 Feb 2021 12:07:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 126/173] hugetlb_cgroup: use helper
 pages_per_huge_page() in hugetlb_cgroup
Message-ID: <20210224200736.Bv6MD-sBr%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
