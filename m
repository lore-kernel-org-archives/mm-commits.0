Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75707C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5699D61186
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhIOW7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 18:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhIOW7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 18:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3EA8610D1;
        Wed, 15 Sep 2021 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631746703;
        bh=Yy5nAzkmzPnIb3tWIWhP0BKq5T71Tx9KSu/FSXGax+U=;
        h=Date:From:To:Subject:From;
        b=hsU0QiwI9bmlTF6Ghmiggvd07zIdHMTWtCt8LPjEw7vP7tOgwYtjLw9qDuOAdrL1z
         GgLrGG3XDeLizQtGStSAHhDnHiwpgTe42AbjQi9NYRRWCmLTRNkQhs4qxRBL0i1BkD
         j0XExyiCxeYIH8nR5ck/SHgJSQ2QPk201p36vLLI=
Date:   Wed, 15 Sep 2021 15:58:22 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apopple@nvidia.com, axelrasmussen@google.com,
        david@redhat.com, hughd@google.com, jglisse@redhat.com,
        kirill@shutemov.name, liam.howlett@oracle.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  + mm-drop-first_index-last_index-in-zap_details.patch
 added to -mm tree
Message-ID: <20210915225822.V4SAR16NP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop first_index/last_index in zap_details
has been added to the -mm tree.  Its filename is
     mm-drop-first_index-last_index-in-zap_details.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-first_index-last_index-in-zap_details.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-first_index-last_index-in-zap_details.patch

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
Subject: mm: drop first_index/last_index in zap_details

The first_index/last_index parameters in zap_details are actually only
used in unmap_mapping_range_tree().  At the meantime, this function is
only called by unmap_mapping_pages() once.  Instead of passing these two
variables through the whole stack of page zapping code, remove them from
zap_details and let them simply be parameters of
unmap_mapping_range_tree(), which is inlined.

Link: https://lkml.kernel.org/r/20210915181535.11238-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam Howlett <liam.howlett@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/memory.c        |   31 ++++++++++++++++++-------------
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-drop-first_index-last_index-in-zap_details
+++ a/include/linux/mm.h
@@ -1688,8 +1688,6 @@ extern void user_shm_unlock(size_t, stru
  */
 struct zap_details {
 	struct address_space *check_mapping;	/* Check page->mapping if set */
-	pgoff_t	first_index;			/* Lowest page->index to unmap */
-	pgoff_t last_index;			/* Highest page->index to unmap */
 	struct page *single_page;		/* Locked page to be unmapped */
 };
 
--- a/mm/memory.c~mm-drop-first_index-last_index-in-zap_details
+++ a/mm/memory.c
@@ -3321,20 +3321,20 @@ static void unmap_mapping_range_vma(stru
 }
 
 static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
+					    pgoff_t first_index,
+					    pgoff_t last_index,
 					    struct zap_details *details)
 {
 	struct vm_area_struct *vma;
 	pgoff_t vba, vea, zba, zea;
 
-	vma_interval_tree_foreach(vma, root,
-			details->first_index, details->last_index) {
-
+	vma_interval_tree_foreach(vma, root, first_index, last_index) {
 		vba = vma->vm_pgoff;
 		vea = vba + vma_pages(vma) - 1;
-		zba = details->first_index;
+		zba = first_index;
 		if (zba < vba)
 			zba = vba;
-		zea = details->last_index;
+		zea = last_index;
 		if (zea > vea)
 			zea = vea;
 
@@ -3360,18 +3360,22 @@ void unmap_mapping_page(struct page *pag
 {
 	struct address_space *mapping = page->mapping;
 	struct zap_details details = { };
+	pgoff_t	first_index;
+	pgoff_t	last_index;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageTail(page));
 
+	first_index = page->index;
+	last_index = page->index + thp_nr_pages(page) - 1;
+
 	details.check_mapping = mapping;
-	details.first_index = page->index;
-	details.last_index = page->index + thp_nr_pages(page) - 1;
 	details.single_page = page;
 
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
-		unmap_mapping_range_tree(&mapping->i_mmap, &details);
+		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+					 last_index, &details);
 	i_mmap_unlock_write(mapping);
 }
 
@@ -3391,16 +3395,17 @@ void unmap_mapping_pages(struct address_
 		pgoff_t nr, bool even_cows)
 {
 	struct zap_details details = { };
+	pgoff_t	first_index = start;
+	pgoff_t	last_index = start + nr - 1;
 
 	details.check_mapping = even_cows ? NULL : mapping;
-	details.first_index = start;
-	details.last_index = start + nr - 1;
-	if (details.last_index < details.first_index)
-		details.last_index = ULONG_MAX;
+	if (last_index < first_index)
+		last_index = ULONG_MAX;
 
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
-		unmap_mapping_range_tree(&mapping->i_mmap, &details);
+		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+					 last_index, &details);
 	i_mmap_unlock_write(mapping);
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch

