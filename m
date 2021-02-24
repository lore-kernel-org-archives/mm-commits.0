Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0916DC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4BB64F23
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhBXUIr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234644AbhBXUIV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E752364F23;
        Wed, 24 Feb 2021 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197240;
        bh=uMWlgw9tOoEw/DXcTXlWnrGApna+wy9o5SEsUZ5XyA0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xcW88dNM/p/iDUnEr08O8Wm4pXIu7/YDZCWej8vDiQbh9zt8nTa7K6kkXlxVM+ATe
         A4g+FuJx+jGQrnG9HMmV3oqKTHMPkhYM34OjK21dlOoDWUi/Jd4C7aJecf4NqIqhlg
         OshZGVkdYyvH00Tsendeb9aDvep3YLxeErPgLhPc=
Date:   Wed, 24 Feb 2021 12:07:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jrdr.linux@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 121/173] mm/hugetlb: fix some comment typos
Message-ID: <20210224200719.KYC8uNy-0%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix some comment typos

Fix typos sasitfy to satisfy, reservtion to reservation, hugegpage to
hugepage and uniprocesor to uniprocessor in comments.

Link: https://lkml.kernel.org/r/20210128112028.64831-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-some-comment-typos
+++ a/include/linux/hugetlb.h
@@ -37,7 +37,7 @@ struct hugepage_subpool {
 	struct hstate *hstate;
 	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
 	long rsv_hpages;	/* Pages reserved against global pool to */
-				/* sasitfy minimum size. */
+				/* satisfy minimum size. */
 };
 
 struct resv_map {
--- a/mm/hugetlb.c~mm-hugetlb-fix-some-comment-typos
+++ a/mm/hugetlb.c
@@ -1434,7 +1434,7 @@ static void __free_huge_page(struct page
 	 * reservation.  If the page was associated with a subpool, there
 	 * would have been a page reserved in the subpool before allocation
 	 * via hugepage_subpool_get_pages().  Since we are 'restoring' the
-	 * reservtion, do not call hugepage_subpool_put_pages() as this will
+	 * reservation, do not call hugepage_subpool_put_pages() as this will
 	 * remove the reserved page from the subpool.
 	 */
 	if (!restore_reserve) {
@@ -3707,7 +3707,7 @@ static unsigned long hugetlb_vm_op_pages
 /*
  * We cannot handle pagefaults against hugetlb pages at all.  They cause
  * handle_mm_fault() to try to instantiate regular-sized pages in the
- * hugegpage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
+ * hugepage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
  * this far.
  */
 static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
@@ -4491,7 +4491,7 @@ u32 hugetlb_fault_mutex_hash(struct addr
 }
 #else
 /*
- * For uniprocesor systems we always use a single mutex, so just
+ * For uniprocessor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
_
