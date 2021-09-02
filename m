Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07E8C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D201610A2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347864AbhIBVzp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347861AbhIBVzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9974F610A1;
        Thu,  2 Sep 2021 21:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619675;
        bh=XdpcVya8Qe3mVGdiddk3uj0CXD7tuajOFXE/u3OvImc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pSGavSf1wNeTZ/sDtTt6qV46Q37xwfJ2L5P5o6TLPJqpHpMe36e/HvHz2v1KS3X5B
         fm0XUBI1PQsIn4RD3nt55v9yQR1s52v471VJo1AlhCK0aaJKKdVmtaB4lC2UMIw+0v
         84tBvzLvzyp2Z6G76NrDNhFFr/wKD+V29fbmJA6g=
Date:   Thu, 02 Sep 2021 14:54:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 088/212] huge tmpfs: SGP_NOALLOC to stop
 collapse_file() on race
Message-ID: <20210902215434.P83upGgT1%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: SGP_NOALLOC to stop collapse_file() on race

khugepaged's collapse_file() currently uses SGP_NOHUGE to tell
shmem_getpage() not to try allocating a huge page, in the very unlikely
event that a racing hole-punch removes the swapped or fallocated page as
soon as i_pages lock is dropped.

We want to consolidate shmem's huge decisions, removing SGP_HUGE and
SGP_NOHUGE; but cannot quite persuade ourselves that it's okay to regress
the protection in this case - Yang Shi points out that the huge page would
remain indefinitely, charged to root instead of the intended memcg.

collapse_file() should not even allocate a small page in this case: why
proceed if someone is punching a hole?  SGP_READ is almost the right flag
here, except that it optimizes away from a fallocated page, with NULL to
tell caller to fill with zeroes (like a hole); whereas collapse_file()'s
sequence relies on using a cache page.  Add SGP_NOALLOC just for this.

There are too many consecutive "if (page"s there in shmem_getpage_gfp():
group it better; and fix the outdated "bring it back from swap" comment.

Link: https://lkml.kernel.org/r/1355343b-acf-4653-ef79-6aee40214ac5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 +
 mm/khugepaged.c          |    2 +-
 mm/shmem.c               |   29 +++++++++++++++++------------
 3 files changed, 19 insertions(+), 13 deletions(-)

--- a/include/linux/shmem_fs.h~huge-tmpfs-sgp_noalloc-to-stop-collapse_file-on-race
+++ a/include/linux/shmem_fs.h
@@ -94,6 +94,7 @@ extern unsigned long shmem_partial_swap_
 /* Flag allocation requirements to shmem_getpage */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
+	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_NOHUGE,	/* like SGP_CACHE, but no huge pages */
 	SGP_HUGE,	/* like SGP_CACHE, huge pages preferred */
--- a/mm/khugepaged.c~huge-tmpfs-sgp_noalloc-to-stop-collapse_file-on-race
+++ a/mm/khugepaged.c
@@ -1721,7 +1721,7 @@ static void collapse_file(struct mm_stru
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_getpage(mapping->host, index, &page,
-						  SGP_NOHUGE)) {
+						  SGP_NOALLOC)) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
--- a/mm/shmem.c~huge-tmpfs-sgp_noalloc-to-stop-collapse_file-on-race
+++ a/mm/shmem.c
@@ -1854,26 +1854,31 @@ repeat:
 		return error;
 	}
 
-	if (page)
+	if (page) {
 		hindex = page->index;
-	if (page && sgp == SGP_WRITE)
-		mark_page_accessed(page);
-
-	/* fallocated page? */
-	if (page && !PageUptodate(page)) {
+		if (sgp == SGP_WRITE)
+			mark_page_accessed(page);
+		if (PageUptodate(page))
+			goto out;
+		/* fallocated page */
 		if (sgp != SGP_READ)
 			goto clear;
 		unlock_page(page);
 		put_page(page);
-		page = NULL;
-		hindex = index;
 	}
-	if (page || sgp == SGP_READ)
-		goto out;
 
 	/*
-	 * Fast cache lookup did not find it:
-	 * bring it back from swap or allocate.
+	 * SGP_READ: succeed on hole, with NULL page, letting caller zero.
+	 * SGP_NOALLOC: fail on hole, with NULL page, letting caller fail.
+	 */
+	*pagep = NULL;
+	if (sgp == SGP_READ)
+		return 0;
+	if (sgp == SGP_NOALLOC)
+		return -ENOENT;
+
+	/*
+	 * Fast cache lookup and swap lookup did not find it: allocate.
 	 */
 
 	if (vma && userfaultfd_missing(vma)) {
_
