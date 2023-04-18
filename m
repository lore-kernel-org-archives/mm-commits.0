Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54C6C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjDRXix (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F13D10258
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E09106387C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464C0C433D2;
        Tue, 18 Apr 2023 23:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860945;
        bh=F7qC8csLRuexpnb/9u2iKOxQ3vFTvSD1EIJe5KVphWM=;
        h=Date:To:From:Subject:From;
        b=qomWGBXKjnUS7W9KsaWoZF27LB7lsQ2Ej+bUm3PcgIPuS9YmiMQeeZq814Z99xXsP
         GiJITXGCEqDHEtIwbRg77FvuilTi7cK9b07/blmcB0VZ7mErFKME4WVvEOAbs8wghP
         0oJ2nffKLJleKlZxVhQbDUj8BAAPPLnwHs0ng3IM=
Date:   Tue, 18 Apr 2023 16:35:44 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch removed from -mm tree
Message-Id: <20230418233545.464C0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hwpoison: support recovery from HugePage copy-on-write faults
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: hwpoison: support recovery from HugePage copy-on-write faults
Date: Thu, 13 Apr 2023 21:13:49 +0800

copy-on-write of hugetlb user pages with uncorrectable errors will result
in a kernel crash.  This is because the copy is performed in kernel mode
and in general we can not handle accessing memory with such errors while
in kernel mode.  Commit a873dfe1032a ("mm, hwpoison: try to recover from
copy-on write faults") introduced the routine copy_user_highpage_mc() to
gracefully handle copying of user pages with uncorrectable errors. 
However, the separate hugetlb copy-on-write code paths were not modified
as part of commit a873dfe1032a.

Modify hugetlb copy-on-write code paths to use copy_mc_user_highpage() so
that they can also gracefully handle uncorrectable errors in user pages. 
This involves changing the hugetlb specific routine
copy_user_large_folio() from type void to int so that it can return an
error.  Modify the hugetlb userfaultfd code in the same way so that it can
return -EHWPOISON if it encounters an uncorrectable error.

Link: https://lkml.kernel.org/r/20230413131349.2524210-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++--
 mm/hugetlb.c       |   17 ++++++++++--
 mm/memory.c        |   59 +++++++++++++++++++++++++++----------------
 3 files changed, 55 insertions(+), 27 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults
+++ a/include/linux/mm.h
@@ -3693,9 +3693,9 @@ extern const struct attribute_group memo
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr_hint,
 			    unsigned int pages_per_huge_page);
-void copy_user_large_folio(struct folio *dst, struct folio *src,
-			   unsigned long addr_hint,
-			   struct vm_area_struct *vma);
+int copy_user_large_folio(struct folio *dst, struct folio *src,
+			  unsigned long addr_hint,
+			  struct vm_area_struct *vma);
 long copy_folio_from_user(struct folio *dst_folio,
 			   const void __user *usr_src,
 			   bool allow_pagefault);
--- a/mm/hugetlb.c~mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults
+++ a/mm/hugetlb.c
@@ -5097,10 +5097,14 @@ again:
 					ret = PTR_ERR(new_folio);
 					break;
 				}
-				copy_user_large_folio(new_folio,
+				ret = copy_user_large_folio(new_folio,
 						      page_folio(ptepage),
 						      addr, dst_vma);
 				put_page(ptepage);
+				if (ret) {
+					folio_put(new_folio);
+					break;
+				}
 
 				/* Install the new hugetlb folio if src pte stable */
 				dst_ptl = huge_pte_lock(h, dst, dst_pte);
@@ -5617,7 +5621,10 @@ retry_avoidcopy:
 		goto out_release_all;
 	}
 
-	copy_user_large_folio(new_folio, page_folio(old_page), address, vma);
+	if (copy_user_large_folio(new_folio, page_folio(old_page), address, vma)) {
+		ret = VM_FAULT_HWPOISON_LARGE;
+		goto out_release_all;
+	}
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, haddr,
@@ -6260,9 +6267,13 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			*foliop = NULL;
 			goto out;
 		}
-		copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
+		ret = copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
+		if (ret) {
+			folio_put(folio);
+			goto out;
+		}
 	}
 
 	/*
--- a/mm/memory.c~mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults
+++ a/mm/memory.c
@@ -5733,12 +5733,12 @@ EXPORT_SYMBOL(__might_fault);
  * operation.  The target subpage will be processed last to keep its
  * cache lines hot.
  */
-static inline void process_huge_page(
+static inline int process_huge_page(
 	unsigned long addr_hint, unsigned int pages_per_huge_page,
-	void (*process_subpage)(unsigned long addr, int idx, void *arg),
+	int (*process_subpage)(unsigned long addr, int idx, void *arg),
 	void *arg)
 {
-	int i, n, base, l;
+	int i, n, base, l, ret;
 	unsigned long addr = addr_hint &
 		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
 
@@ -5752,7 +5752,9 @@ static inline void process_huge_page(
 		/* Process subpages at the end of huge page */
 		for (i = pages_per_huge_page - 1; i >= 2 * n; i--) {
 			cond_resched();
-			process_subpage(addr + i * PAGE_SIZE, i, arg);
+			ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
+			if (ret)
+				return ret;
 		}
 	} else {
 		/* If target subpage in second half of huge page */
@@ -5761,7 +5763,9 @@ static inline void process_huge_page(
 		/* Process subpages at the begin of huge page */
 		for (i = 0; i < base; i++) {
 			cond_resched();
-			process_subpage(addr + i * PAGE_SIZE, i, arg);
+			ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
+			if (ret)
+				return ret;
 		}
 	}
 	/*
@@ -5773,10 +5777,15 @@ static inline void process_huge_page(
 		int right_idx = base + 2 * l - 1 - i;
 
 		cond_resched();
-		process_subpage(addr + left_idx * PAGE_SIZE, left_idx, arg);
+		ret = process_subpage(addr + left_idx * PAGE_SIZE, left_idx, arg);
+		if (ret)
+			return ret;
 		cond_resched();
-		process_subpage(addr + right_idx * PAGE_SIZE, right_idx, arg);
+		ret = process_subpage(addr + right_idx * PAGE_SIZE, right_idx, arg);
+		if (ret)
+			return ret;
 	}
+	return 0;
 }
 
 static void clear_gigantic_page(struct page *page,
@@ -5794,11 +5803,12 @@ static void clear_gigantic_page(struct p
 	}
 }
 
-static void clear_subpage(unsigned long addr, int idx, void *arg)
+static int clear_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct page *page = arg;
 
 	clear_user_highpage(page + idx, addr);
+	return 0;
 }
 
 void clear_huge_page(struct page *page,
@@ -5815,7 +5825,7 @@ void clear_huge_page(struct page *page,
 	process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
 }
 
-static void copy_user_gigantic_page(struct folio *dst, struct folio *src,
+static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
 				     unsigned long addr,
 				     struct vm_area_struct *vma,
 				     unsigned int pages_per_huge_page)
@@ -5829,8 +5839,13 @@ static void copy_user_gigantic_page(stru
 		src_page = folio_page(src, i);
 
 		cond_resched();
-		copy_user_highpage(dst_page, src_page, addr + i*PAGE_SIZE, vma);
+		if (copy_mc_user_highpage(dst_page, src_page,
+					  addr + i*PAGE_SIZE, vma)) {
+			memory_failure_queue(page_to_pfn(src_page), 0);
+			return -EHWPOISON;
+		}
 	}
+	return 0;
 }
 
 struct copy_subpage_arg {
@@ -5839,16 +5854,20 @@ struct copy_subpage_arg {
 	struct vm_area_struct *vma;
 };
 
-static void copy_subpage(unsigned long addr, int idx, void *arg)
+static int copy_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct copy_subpage_arg *copy_arg = arg;
 
-	copy_user_highpage(copy_arg->dst + idx, copy_arg->src + idx,
-			   addr, copy_arg->vma);
+	if (copy_mc_user_highpage(copy_arg->dst + idx, copy_arg->src + idx,
+				  addr, copy_arg->vma)) {
+		memory_failure_queue(page_to_pfn(copy_arg->src + idx), 0);
+		return -EHWPOISON;
+	}
+	return 0;
 }
 
-void copy_user_large_folio(struct folio *dst, struct folio *src,
-			   unsigned long addr_hint, struct vm_area_struct *vma)
+int copy_user_large_folio(struct folio *dst, struct folio *src,
+			  unsigned long addr_hint, struct vm_area_struct *vma)
 {
 	unsigned int pages_per_huge_page = folio_nr_pages(dst);
 	unsigned long addr = addr_hint &
@@ -5859,13 +5878,11 @@ void copy_user_large_folio(struct folio
 		.vma = vma,
 	};
 
-	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
-		copy_user_gigantic_page(dst, src, addr, vma,
-					pages_per_huge_page);
-		return;
-	}
+	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES))
+		return copy_user_gigantic_page(dst, src, addr, vma,
+					       pages_per_huge_page);
 
-	process_huge_page(addr_hint, pages_per_huge_page, copy_subpage, &arg);
+	return process_huge_page(addr_hint, pages_per_huge_page, copy_subpage, &arg);
 }
 
 long copy_folio_from_user(struct folio *dst_folio,
_

Patches currently in -mm which might be from liushixin2@huawei.com are


