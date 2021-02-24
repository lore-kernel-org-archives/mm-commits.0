Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73D5C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F48A64EC3
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhBXUMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235485AbhBXUKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B25B64F19;
        Wed, 24 Feb 2021 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197395;
        bh=ewtbKrz9EVTe5Ju1dtoA9cVJGYEdBfxK9cX1MhuWCtQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qlZOmZxJB85P/xbqTO3hvUIp3sxQDxLfgVQ42XF1B4Y3K4hbEnXuDsspVbIVAzcQC
         cu67cIKmZKEyEPmBAWR4//3XRkdb21JyKCPpYcH83UnjO1uY6mSeQ1eVXXauXKl+iZ
         OQ0lGM69EwqS1DywdQnXALPX6Rl+OENAgCdzsbcs=
Date:   Wed, 24 Feb 2021 12:09:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        dave@stgolabs.net, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 163/173] mm/hugetlb: change
 hugetlb_reserve_pages() to type bool
Message-ID: <20210224200954.pCGSwj02-%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: change hugetlb_reserve_pages() to type bool

While reviewing a bug in hugetlb_reserve_pages, it was noticed that all
callers ignore the return value.  Any failure is considered an ENOMEM
error by the callers.

Change the function to be of type bool.  The function will return true if
the reservation was successful, false otherwise.  Callers currently assume
a zero return code indicates success.  Change the callers to look for true
to indicate success.  No functional change, only code cleanup.

Link: https://lkml.kernel.org/r/20201221192542.15732-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    4 ++--
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |   37 ++++++++++++++-----------------------
 3 files changed, 17 insertions(+), 26 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool
+++ a/fs/hugetlbfs/inode.c
@@ -171,7 +171,7 @@ static int hugetlbfs_file_mmap(struct fi
 	file_accessed(file);
 
 	ret = -ENOMEM;
-	if (hugetlb_reserve_pages(inode,
+	if (!hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
 				len >> huge_page_shift(h), vma,
 				vma->vm_flags))
@@ -1493,7 +1493,7 @@ struct file *hugetlb_file_setup(const ch
 	inode->i_size = size;
 	clear_nlink(inode);
 
-	if (hugetlb_reserve_pages(inode, 0,
+	if (!hugetlb_reserve_pages(inode, 0,
 			size >> huge_page_shift(hstate_inode(inode)), NULL,
 			acctflag))
 		file = ERR_PTR(-ENOMEM);
--- a/include/linux/hugetlb.h~mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool
+++ a/include/linux/hugetlb.h
@@ -139,7 +139,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 				unsigned long dst_addr,
 				unsigned long src_addr,
 				struct page **pagep);
-int hugetlb_reserve_pages(struct inode *inode, long from, long to,
+bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
--- a/mm/hugetlb.c~mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool
+++ a/mm/hugetlb.c
@@ -5016,12 +5016,13 @@ unsigned long hugetlb_change_protection(
 	return pages << h->order;
 }
 
-int hugetlb_reserve_pages(struct inode *inode,
+/* Return true if reservation was successful, false otherwise.  */
+bool hugetlb_reserve_pages(struct inode *inode,
 					long from, long to,
 					struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
-	long ret, chg, add = -1;
+	long chg, add = -1;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
@@ -5031,7 +5032,7 @@ int hugetlb_reserve_pages(struct inode *
 	/* This should never happen */
 	if (from > to) {
 		VM_WARN(1, "%s called with a negative range\n", __func__);
-		return -EINVAL;
+		return false;
 	}
 
 	/*
@@ -5040,7 +5041,7 @@ int hugetlb_reserve_pages(struct inode *
 	 * without using reserves
 	 */
 	if (vm_flags & VM_NORESERVE)
-		return 0;
+		return true;
 
 	/*
 	 * Shared mappings base their reservation on the number of pages that
@@ -5062,7 +5063,7 @@ int hugetlb_reserve_pages(struct inode *
 		/* Private mapping. */
 		resv_map = resv_map_alloc();
 		if (!resv_map)
-			return -ENOMEM;
+			return false;
 
 		chg = to - from;
 
@@ -5070,18 +5071,12 @@ int hugetlb_reserve_pages(struct inode *
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0) {
-		ret = chg;
+	if (chg < 0)
 		goto out_err;
-	}
-
-	ret = hugetlb_cgroup_charge_cgroup_rsvd(
-		hstate_index(h), chg * pages_per_huge_page(h), &h_cg);
 
-	if (ret < 0) {
-		ret = -ENOMEM;
+	if (hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
+				chg * pages_per_huge_page(h), &h_cg) < 0)
 		goto out_err;
-	}
 
 	if (vma && !(vma->vm_flags & VM_MAYSHARE) && h_cg) {
 		/* For private mappings, the hugetlb_cgroup uncharge info hangs
@@ -5096,19 +5091,15 @@ int hugetlb_reserve_pages(struct inode *
 	 * reservations already in place (gbl_reserve).
 	 */
 	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_reserve < 0) {
-		ret = -ENOSPC;
+	if (gbl_reserve < 0)
 		goto out_uncharge_cgroup;
-	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	ret = hugetlb_acct_memory(h, gbl_reserve);
-	if (ret < 0) {
+	if (hugetlb_acct_memory(h, gbl_reserve) < 0)
 		goto out_put_pages;
-	}
 
 	/*
 	 * Account for the reservations made. Shared mappings record regions
@@ -5126,7 +5117,6 @@ int hugetlb_reserve_pages(struct inode *
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
-			ret = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
@@ -5147,7 +5137,8 @@ int hugetlb_reserve_pages(struct inode *
 			hugetlb_acct_memory(h, -rsv_adjust);
 		}
 	}
-	return 0;
+	return true;
+
 out_put_pages:
 	/* put back original number of pages, chg */
 	(void)hugepage_subpool_put_pages(spool, chg);
@@ -5163,7 +5154,7 @@ out_err:
 			region_abort(resv_map, from, to, regions_needed);
 	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		kref_put(&resv_map->refs, resv_map_release);
-	return ret;
+	return false;
 }
 
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
_
