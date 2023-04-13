Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F88C77B6E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Apr 2023 21:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjDMVYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDMVY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 17:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B7D49D1
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 14:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB21614F5
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 21:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD85C4339B;
        Thu, 13 Apr 2023 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681421066;
        bh=gpEU+vbV67JMqc1SCIrS5Ahab2T+9hmgG8MF6AX2u9w=;
        h=Date:To:From:Subject:From;
        b=mbKRlEjDIMPJYDj9sESJEPCLtdMqXnp+9BiGEeiaNmKE1SXLtn5ri9c/XrnZ24cz0
         jmdUkntmoc2lWeEFloPkE7T8oLixW9aUYU4cwQgFEmefTqHKyVW3DM26g/fyVDXnTw
         QVfKrvQbmgfO2207VRlyiXo9gmNJwAs41JZvGnfI=
Date:   Thu, 13 Apr 2023 14:24:25 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch added to mm-unstable branch
Message-Id: <20230413212426.6AD85C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: support recovery from HugePage copy-on-write faults
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++--
 mm/hugetlb.c       |   17 ++++++++++--
 mm/memory.c        |   59 +++++++++++++++++++++++++++----------------
 3 files changed, 55 insertions(+), 27 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults
+++ a/include/linux/mm.h
@@ -3694,9 +3694,9 @@ extern const struct attribute_group memo
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
@@ -5607,7 +5611,10 @@ retry_avoidcopy:
 		goto out_release_all;
 	}
 
-	copy_user_large_folio(new_folio, page_folio(old_page), address, vma);
+	if (copy_user_large_folio(new_folio, page_folio(old_page), address, vma)) {
+		ret = VM_FAULT_HWPOISON_LARGE;
+		goto out_release_all;
+	}
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, haddr,
@@ -6250,9 +6257,13 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
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
@@ -5722,12 +5722,12 @@ EXPORT_SYMBOL(__might_fault);
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
 
@@ -5741,7 +5741,9 @@ static inline void process_huge_page(
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
@@ -5750,7 +5752,9 @@ static inline void process_huge_page(
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
@@ -5762,10 +5766,15 @@ static inline void process_huge_page(
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
@@ -5783,11 +5792,12 @@ static void clear_gigantic_page(struct p
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
@@ -5804,7 +5814,7 @@ void clear_huge_page(struct page *page,
 	process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
 }
 
-static void copy_user_gigantic_page(struct folio *dst, struct folio *src,
+static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
 				     unsigned long addr,
 				     struct vm_area_struct *vma,
 				     unsigned int pages_per_huge_page)
@@ -5818,8 +5828,13 @@ static void copy_user_gigantic_page(stru
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
@@ -5828,16 +5843,20 @@ struct copy_subpage_arg {
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
@@ -5848,13 +5867,11 @@ void copy_user_large_folio(struct folio
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

mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initialization-of-zswap.patch
mm-zswap-delay-the-initialization-of-zswap-v9.patch
mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

