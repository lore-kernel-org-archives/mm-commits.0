Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2007CC6379F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjBMXzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjBMXzb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E5D271B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A732661348
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A72C4339B;
        Mon, 13 Feb 2023 23:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332527;
        bh=DSLB38lRTA2KLvJWx4Pl1MA5Nh3TwKJcjRrt1ohl4tU=;
        h=Date:To:From:Subject:From;
        b=l8fSeCJVIWF0kO2bn+yh+mpYtIdWcbRNWxMaw/W6lijJUeNI7cfJ4JCpK9/c0w90A
         76G88u035JUIDEfGoiec8M8ASEbzSC38Ne4hN95gG3I51tyZt3f243JmM9c327E5ZE
         2vCOi+BSb0J3rA2h34TgcjIzBL7nUfDOLS3juMrM=
Date:   Mon, 13 Feb 2023 15:55:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch removed from -mm tree
Message-Id: <20230213235527.05A72C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/mm: update hugetlbfs documentation to mention alloc_hugetlb_folio
has been removed from the -mm tree.  Its filename was
     documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Documentation/mm: update hugetlbfs documentation to mention alloc_hugetlb_folio
Date: Wed, 25 Jan 2023 09:05:37 -0800

Link: https://lkml.kernel.org/r/20230125170537.96973-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
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


