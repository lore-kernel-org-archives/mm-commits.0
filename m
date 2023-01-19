Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D14C677F1
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjATE2x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjATE2b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:28:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17BEB1ED5
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:28:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 207D1B82762
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3387C433EF;
        Thu, 19 Jan 2023 22:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167562;
        bh=4itGpSz0ei0UgAugh+I8HzYy+JbPWodF9SRSz5XiEDE=;
        h=Date:To:From:Subject:From;
        b=GDBuRtECmcePiX2Vw7nc7W0wjEzlwLMTHAM/zAggBiThEWqB9nIhzi7lMZ/HrmYYP
         SQTx4RpACLtxCEt1fV5M6n0eqUEnDwz4EVhNlycaAa9A+hPdnGVm++Q2fOOEC6n0Dg
         Ej69qdvZsIu+cM9R9h5EI538VLcTeFMSBe02Suc4=
Date:   Thu, 19 Jan 2023 14:32:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20230119223242.B3387C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: update hugetlbfs documentation to mention alloc_hugetlb_folio
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Documentation/mm: update hugetlbfs documentation to mention alloc_hugetlb_folio
Date: Thu, 19 Jan 2023 13:14:46 -0800

alloc_huge_page() has been renamed to alloc_hugetlb_folio() so update the
documentation which mentions alloc_huge_page().  Subpool information has
been moved from page->private to having a dedicated field in struct folio,
reflect this in the documentation.

Link: https://lkml.kernel.org/r/20230119211446.54165-10-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/hugetlbfs_reserv.rst~documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio
+++ a/Documentation/mm/hugetlbfs_reserv.rst
@@ -181,14 +181,14 @@ Consuming Reservations/Allocating a Huge
 
 Reservations are consumed when huge pages associated with the reservations
 are allocated and instantiated in the corresponding mapping.  The allocation
-is performed within the routine alloc_huge_page()::
+is performed within the routine alloc_hugetlb_folio()::
 
-	struct page *alloc_huge_page(struct vm_area_struct *vma,
+	struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				     unsigned long addr, int avoid_reserve)
 
-alloc_huge_page is passed a VMA pointer and a virtual address, so it can
+alloc_hugetlb_folio is passed a VMA pointer and a virtual address, so it can
 consult the reservation map to determine if a reservation exists.  In addition,
-alloc_huge_page takes the argument avoid_reserve which indicates reserves
+alloc_hugetlb_folio takes the argument avoid_reserve which indicates reserves
 should not be used even if it appears they have been set aside for the
 specified address.  The avoid_reserve argument is most often used in the case
 of Copy on Write and Page Migration where additional copies of an existing
@@ -208,7 +208,8 @@ a reservation for the allocation.  After
 exists and can be used for the allocation, the routine dequeue_huge_page_vma()
 is called.  This routine takes two arguments related to reservations:
 
-- avoid_reserve, this is the same value/argument passed to alloc_huge_page()
+- avoid_reserve, this is the same value/argument passed to
+  alloc_hugetlb_folio().
 - chg, even though this argument is of type long only the values 0 or 1 are
   passed to dequeue_huge_page_vma.  If the value is 0, it indicates a
   reservation exists (see the section "Memory Policy and Reservations" for
@@ -233,9 +234,9 @@ the scope reservations.  Even if a surpl
 reservation based adjustments as above will be made: SetPagePrivate(page) and
 resv_huge_pages--.
 
-After obtaining a new huge page, (page)->private is set to the value of
-the subpool associated with the page if it exists.  This will be used for
-subpool accounting when the page is freed.
+After obtaining a new hugetlb folio, (folio)->_hugetlb_subpool is set to the
+value of the subpool associated with the page if it exists.  This will be used
+for subpool accounting when the folio is freed.
 
 The routine vma_commit_reservation() is then called to adjust the reserve
 map based on the consumption of the reservation.  In general, this involves
@@ -246,8 +247,8 @@ was no reservation in a shared mapping o
 entry must be created.
 
 It is possible that the reserve map could have been changed between the call
-to vma_needs_reservation() at the beginning of alloc_huge_page() and the
-call to vma_commit_reservation() after the page was allocated.  This would
+to vma_needs_reservation() at the beginning of alloc_hugetlb_folio() and the
+call to vma_commit_reservation() after the folio was allocated.  This would
 be possible if hugetlb_reserve_pages was called for the same page in a shared
 mapping.  In such cases, the reservation count and subpool free page count
 will be off by one.  This rare condition can be identified by comparing the
--- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst~documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio
+++ a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
@@ -142,14 +142,14 @@ 在'from'-'to'范围内存在预留。
 消耗预留/分配一个巨页
 ===========================
 
-当与预留相关的巨页在相应的映射中被分配和实例化时，预留就被消耗了。该分配是在函数alloc_huge_page()
+当与预留相关的巨页在相应的映射中被分配和实例化时，预留就被消耗了。该分配是在函数alloc_hugetlb_folio()
 中进行的::
 
-	struct page *alloc_huge_page(struct vm_area_struct *vma,
+	struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				     unsigned long addr, int avoid_reserve)
 
-alloc_huge_page被传递给一个VMA指针和一个虚拟地址，因此它可以查阅预留映射以确定是否存在预留。
-此外，alloc_huge_page需要一个参数avoid_reserve，该参数表示即使看起来已经为指定的地址预留了
+alloc_hugetlb_folio被传递给一个VMA指针和一个虚拟地址，因此它可以查阅预留映射以确定是否存在预留。
+此外，alloc_hugetlb_folio需要一个参数avoid_reserve，该参数表示即使看起来已经为指定的地址预留了
 预留，也不应该使用预留。avoid_reserve参数最常被用于写时拷贝和页面迁移的情况下，即现有页面的额
 外拷贝被分配。
 
@@ -162,7 +162,7 @@ 则可将其中一个用于该分配。�
 确定预留是否存在并可用于分配后，调用dequeue_huge_page_vma()函数。这个函数需要两个与预留有关
 的参数：
 
-- avoid_reserve，这是传递给alloc_huge_page()的同一个值/参数。
+- avoid_reserve，这是传递给alloc_hugetlb_folio()的同一个值/参数。
 - chg，尽管这个参数的类型是long，但只有0或1的值被传递给dequeue_huge_page_vma。如果该值为0，
   则表明存在预留（关于可能的问题，请参见 “预留和内存策略” 一节）。如果值
   为1，则表示不存在预留，如果可能的话，必须从全局空闲池中取出该页。
@@ -179,7 +179,7 @@ 注意，如果找不到满足VMA内存�
 的剩余巨页和超额分配的问题。即使分配了一个多余的页面，也会进行与上面一样的基于预留的调整:
 SetPagePrivate(page) 和 resv_huge_pages--.
 
-在获得一个新的巨页后，(page)->private被设置为与该页面相关的子池的值，如果它存在的话。当页
+在获得一个新的巨页后，(folio)->_hugetlb_subpool被设置为与该页面相关的子池的值，如果它存在的话。当页
 面被释放时，这将被用于子池的计数。
 
 然后调用函数vma_commit_reservation()，根据预留的消耗情况调整预留映射。一般来说，这涉及
@@ -199,7 +199,7 @@ 到确保页面在区域映射的file_re
 已经存在，所以不做任何改变。然而，如果共享映射中没有预留，或者这是一个私有映射，则必须创建
 一个新的条目。
 
-在alloc_huge_page()开始调用vma_needs_reservation()和页面分配后调用
+在alloc_hugetlb_folio()开始调用vma_needs_reservation()和页面分配后调用
 vma_commit_reservation()之间，预留映射有可能被改变。如果hugetlb_reserve_pages在共
 享映射中为同一页面被调用，这将是可能的。在这种情况下，预留计数和子池空闲页计数会有一个偏差。
 这种罕见的情况可以通过比较vma_needs_reservation和vma_commit_reservation的返回值来
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

