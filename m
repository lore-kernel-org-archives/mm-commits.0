Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEAAE7D0BB
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjIVBih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVBih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:38:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F48CF
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:38:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F64C433C7;
        Fri, 22 Sep 2023 01:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346710;
        bh=KySxVWaEsWt8lCfVaFdJnUKzXn64TUkRI/Vuk3LKRrY=;
        h=Date:To:From:Subject:From;
        b=syBSQ8MdR9MiufC18yxuzQHHHJohQ0WN1TeYoAb/LssCXsEI+PA91OjxBlXq/1uyf
         wYS+NLMsXphMfo6k7X56LKR1s5pQQx7laeKjtyP7n+YsNdS+Ka8HcOicFJFfLKpdpZ
         ZqkUaNp8xQsJ6ICVMMnRYFvoYLZPnXayvJ9eOQQw=
Date:   Thu, 21 Sep 2023 18:38:29 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-vm_normal_folio_pmd.patch added to mm-unstable branch
Message-Id: <20230922013830.70F64C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: add vm_normal_folio_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-add-vm_normal_folio_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-add-vm_normal_folio_pmd.patch

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

mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch
mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch
mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch
mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch
mm-migrate-use-__folio_test_movable.patch
mm-migrate-use-a-folio-in-add_page_for_migration.patch
mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch
mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch
mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

