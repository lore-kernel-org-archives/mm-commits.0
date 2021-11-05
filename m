Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C5BC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0EEF611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhKEUlM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhKEUlM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D755C611C4;
        Fri,  5 Nov 2021 20:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144712;
        bh=+WQottrag5nM12JSj6ClJ577YghmMslIUJIreMa+8hE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aks1TfTdLKfd2PWRKIfA/48wndRqE/kYqMzAj084YJS1oow+SOZaBFuUJv2RhuZLa
         lwSIcMJfGPLIwG8LYtzPg3WJ0mkYQNzaQkJp4Of1LuCPHF3Axjb72Kh3BqorKPJTdC
         sxVpVHHb11niWYPT6kaq95K15Sx4cL+ssS2UpsVg=
Date:   Fri, 05 Nov 2021 13:38:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        axelrasmussen@google.com, david@redhat.com, hughd@google.com,
        jglisse@redhat.com, kirill@shutemov.name, liam.howlett@oracle.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 074/262] mm: drop first_index/last_index in
 zap_details
Message-ID: <20211105203831.QjFEazYcI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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
@@ -3325,20 +3325,20 @@ static void unmap_mapping_range_vma(stru
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
 
@@ -3364,18 +3364,22 @@ void unmap_mapping_page(struct page *pag
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
 
@@ -3395,16 +3399,17 @@ void unmap_mapping_pages(struct address_
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
 EXPORT_SYMBOL_GPL(unmap_mapping_pages);
_
