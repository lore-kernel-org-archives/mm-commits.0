Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE42E94131
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbjJFVsH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjJFVsC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFCFBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AD5C433C9;
        Fri,  6 Oct 2023 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628880;
        bh=rmUDyfBAunzMUqZzDHzF82UJzVEqmP2Ejwt9rLVF7CQ=;
        h=Date:To:From:Subject:From;
        b=ouw+jfHAh9QOUMbZn4oK4DV9gdK8c1NY0A2iMJQL9tKDz+i6QARwNsJgEqfnHl9pf
         SsPe2i9nXChvuWj2jtc1FsVQv2bBEfQ0EmMMZ6FDYfzFoOg6tvCp5drWpx7VNdetPt
         DaDkQXvbtvST0g/CLmHvW+3Taba8jKL5pUU7bT3I=
Date:   Fri, 06 Oct 2023 14:47:58 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-add-vm_normal_folio_pmd.patch removed from -mm tree
Message-Id: <20231006214800.99AD5C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: add vm_normal_folio_pmd()
has been removed from the -mm tree.  Its filename was
     mm-memory-add-vm_normal_folio_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: add vm_normal_folio_pmd()
Date: Thu, 21 Sep 2023 15:44:12 +0800

Patch series "mm: convert numa balancing functions to use a folio", v2.

do_numa_pages() only handles non-compound pages, and only PMD-mapped THPs
are handled in do_huge_pmd_numa_page().  But a large, PTE-mapped folio
will be supported so let's convert more numa balancing functions to
use/take a folio in preparation for that, no functional change intended
for now.


This patch (of 6):

The new vm_normal_folio_pmd() wrapper is similar to vm_normal_folio(),
which allow them to completely replace the struct page variables with
struct folio variables.

Link: https://lkml.kernel.org/r/20230921074417.24004-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230921074417.24004-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   10 ++++++++++
 2 files changed, 12 insertions(+)

--- a/include/linux/mm.h~mm-memory-add-vm_normal_folio_pmd
+++ a/include/linux/mm.h
@@ -2327,6 +2327,8 @@ struct folio *vm_normal_folio(struct vm_
 			     pte_t pte);
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
+struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
+				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
 
--- a/mm/memory.c~mm-memory-add-vm_normal_folio_pmd
+++ a/mm/memory.c
@@ -689,6 +689,16 @@ struct page *vm_normal_page_pmd(struct v
 out:
 	return pfn_to_page(pfn);
 }
+
+struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
+				  unsigned long addr, pmd_t pmd)
+{
+	struct page *page = vm_normal_page_pmd(vma, addr, pmd);
+
+	if (page)
+		return page_folio(page);
+	return NULL;
+}
 #endif
 
 static void restore_exclusive_pte(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


