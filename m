Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841C9C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6505E61131
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhIOW7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 18:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhIOW7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 18:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08242610A6;
        Wed, 15 Sep 2021 22:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631746706;
        bh=Q+S8GPWVmKE7F2PAKW0A/+Bh6r8BIO0whzEVlQHUeYU=;
        h=Date:From:To:Subject:From;
        b=RyhfF4luRR6EEKq2yOBdpPUpEILybgvtQ3pHbtdMxm03ymZGwr3+0GMvtI8I8pkCU
         IU7xYIdZZofkOkDVIYzPRmIfGDv51IREWwFY7U7IKtKr53gZlVmAfKEq7v2ZSTGGqI
         p8j6x1VubogDEkS+xpkqRGR6Xnm8YFeW6hWoYXto=
Date:   Wed, 15 Sep 2021 15:58:25 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apopple@nvidia.com, axelrasmussen@google.com,
        david@redhat.com, hughd@google.com, jglisse@redhat.com,
        kirill@shutemov.name, liam.howlett@oracle.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  + mm-add-zap_skip_check_mapping-helper.patch added to -mm
 tree
Message-ID: <20210915225825.JdfumOPuY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add zap_skip_check_mapping() helper
has been added to the -mm tree.  Its filename is
     mm-add-zap_skip_check_mapping-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-zap_skip_check_mapping-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-zap_skip_check_mapping-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: add zap_skip_check_mapping() helper

Use the helper for the checks.  Rename "check_mapping" into "zap_mapping"
because "check_mapping" looks like a bool but in fact it stores the
mapping itself.  When it's set, we check the mapping (it must be
non-NULL).  When it's cleared we skip the check, which works like the old
way.

Move the duplicated comments to the helper too.

Link: https://lkml.kernel.org/r/20210915181538.11288-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 +++++++++++++++-
 mm/memory.c        |   29 ++++++-----------------------
 2 files changed, 21 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-add-zap_skip_check_mapping-helper
+++ a/include/linux/mm.h
@@ -1687,10 +1687,24 @@ extern void user_shm_unlock(size_t, stru
  * Parameter block passed down to zap_pte_range in exceptional cases.
  */
 struct zap_details {
-	struct address_space *check_mapping;	/* Check page->mapping if set */
+	struct address_space *zap_mapping;	/* Check page->mapping if set */
 	struct page *single_page;		/* Locked page to be unmapped */
 };
 
+/*
+ * We set details->zap_mappings when we want to unmap shared but keep private
+ * pages. Return true if skip zapping this page, false otherwise.
+ */
+static inline bool
+zap_skip_check_mapping(struct zap_details *details, struct page *page)
+{
+	if (!details || !page)
+		return false;
+
+	return details->zap_mapping &&
+	    (details->zap_mapping != page_rmapping(page));
+}
+
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
--- a/mm/memory.c~mm-add-zap_skip_check_mapping-helper
+++ a/mm/memory.c
@@ -1333,16 +1333,8 @@ again:
 			struct page *page;
 
 			page = vm_normal_page(vma, addr, ptent);
-			if (unlikely(details) && page) {
-				/*
-				 * unmap_shared_mapping_pages() wants to
-				 * invalidate cache without truncating:
-				 * unmap shared but keep private pages.
-				 */
-				if (details->check_mapping &&
-				    details->check_mapping != page_rmapping(page))
-					continue;
-			}
+			if (unlikely(zap_skip_check_mapping(details, page)))
+				continue;
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
 			tlb_remove_tlb_entry(tlb, pte, addr);
@@ -1375,17 +1367,8 @@ again:
 		    is_device_exclusive_entry(entry)) {
 			struct page *page = pfn_swap_entry_to_page(entry);
 
-			if (unlikely(details && details->check_mapping)) {
-				/*
-				 * unmap_shared_mapping_pages() wants to
-				 * invalidate cache without truncating:
-				 * unmap shared but keep private pages.
-				 */
-				if (details->check_mapping !=
-				    page_rmapping(page))
-					continue;
-			}
-
+			if (unlikely(zap_skip_check_mapping(details, page)))
+				continue;
 			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
 
@@ -3369,7 +3352,7 @@ void unmap_mapping_page(struct page *pag
 	first_index = page->index;
 	last_index = page->index + thp_nr_pages(page) - 1;
 
-	details.check_mapping = mapping;
+	details.zap_mapping = mapping;
 	details.single_page = page;
 
 	i_mmap_lock_write(mapping);
@@ -3398,7 +3381,7 @@ void unmap_mapping_pages(struct address_
 	pgoff_t	first_index = start;
 	pgoff_t	last_index = start + nr - 1;
 
-	details.check_mapping = even_cows ? NULL : mapping;
+	details.zap_mapping = even_cows ? NULL : mapping;
 	if (last_index < first_index)
 		last_index = ULONG_MAX;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch

