Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135E5A35
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006234; cv=none; b=NRXHr2QFj5NLwgjUiFey52PVRJFXJdSBIe0XqlsjxXHnx6cYf2KwJgkQsZrJE2hhRVy4WLC9ZH8+OBY/6k3R/Iq6Rofq015BcRNNhl8m2qinvLth7bqrq2zSSgCz+LZMyX+FlqQ5ereNiXxGFPzWm+w+CUR9W2cEteYbuHhz0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006234; c=relaxed/simple;
	bh=huwWPjXs1Tznw+MUNagwcDUTQ22OICIpfVbumop7/LY=;
	h=Date:To:From:Subject:Message-Id; b=Rtj/Zl+Q0BIKEDYEb95d1Dv+gtmHsYi9MEUe2MitH8OLPAuWntioieIGAh8mcYycCByPaaMSr5WINIeKP0ZoD9Un89oPMrP7SUeroYG0GJkavMxjfmZgQjLmhzJKtiWlciWdRYBtB6zMYnQ7TkJX9t5S8kXPPJCKwbNIcdm4KN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QjmPI8es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QjmPI8es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CBBC113CD;
	Thu, 25 Apr 2024 00:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006233;
	bh=huwWPjXs1Tznw+MUNagwcDUTQ22OICIpfVbumop7/LY=;
	h=Date:To:From:Subject:From;
	b=QjmPI8esyWbDFe+O4AGBufRaK6hYBoctvz+6hXMh669LTRQnB4lXX3RBXUCO7Qk+b
	 995XSxEw9Mv78Bj1Ps4LCrGLFVoeIPKmjUJSMOep3MLw7qViwIgu0U+Jil2qWPuT2f
	 /fqhzZ31YGzMQsYAQGHYv3ahrNW7RiTXddyHHS1M=
Date: Wed, 24 Apr 2024 17:50:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write.patch removed from -mm tree
Message-Id: <20240425005033.D3CBBC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert hugetlb_page_mapping_lock_write() to hugetlb_folio_mapping_lock_write
has been removed from the -mm tree.  Its filename was
     mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: convert hugetlb_page_mapping_lock_write() to hugetlb_folio_mapping_lock_write
Date: Wed Apr 24 04:20:30 PM PDT 2024

Convert this to use folios, so we can remove page_mapping()

Cc: David Hildenbrand <david@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 mm/hugetlb.c            |    6 +++---
 mm/memory-failure.c     |    4 ++--
 mm/migrate.c            |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write
+++ a/mm/hugetlb.c
@@ -2155,13 +2155,13 @@ static bool prep_compound_gigantic_folio
 /*
  * Find and lock address space (mapping) in write mode.
  *
- * Upon entry, the page is locked which means that page_mapping() is
+ * Upon entry, the folio is locked which means that folio_mapping() is
  * stable.  Due to locking order, we can only trylock_write.  If we can
  * not get the lock, simply return NULL to caller.
  */
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
+struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 {
-	struct address_space *mapping = page_mapping(hpage);
+	struct address_space *mapping = folio_mapping(folio);
 
 	if (!mapping)
 		return mapping;
--- a/mm/memory-failure.c~mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write
+++ a/mm/memory-failure.c
@@ -1595,7 +1595,7 @@ static bool hwpoison_user_mappings(struc
 	 * XXX: the dirty test could be racy: set_page_dirty() may not always
 	 * be called inside page lock (it's recommended but not enforced).
 	 */
-	mapping = page_mapping(hpage);
+	mapping = folio_mapping(folio);
 	if (!(flags & MF_MUST_KILL) && !PageDirty(hpage) && mapping &&
 	    mapping_can_writeback(mapping)) {
 		if (page_mkclean(hpage)) {
@@ -1622,7 +1622,7 @@ static bool hwpoison_user_mappings(struc
 		 * TTU_RMAP_LOCKED to indicate we have taken the lock
 		 * at this higher level.
 		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
+		mapping = hugetlb_folio_mapping_lock_write(folio);
 		if (mapping) {
 			try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
 			i_mmap_unlock_write(mapping);
--- a/include/linux/hugetlb.h~mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write
+++ a/include/linux/hugetlb.h
@@ -178,7 +178,7 @@ bool hugetlbfs_pagecache_present(struct
 				 struct vm_area_struct *vma,
 				 unsigned long address);
 
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
+struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
@@ -297,8 +297,8 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-static inline struct address_space *hugetlb_page_mapping_lock_write(
-							struct page *hpage)
+static inline struct address_space *hugetlb_folio_mapping_lock_write(
+							struct folio *folio)
 {
 	return NULL;
 }
--- a/mm/migrate.c~mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write
+++ a/mm/migrate.c
@@ -1425,7 +1425,7 @@ static int unmap_and_move_huge_page(new_
 			 * semaphore in write mode here and set TTU_RMAP_LOCKED
 			 * to let lower levels know we have taken the lock.
 			 */
-			mapping = hugetlb_page_mapping_lock_write(&src->page);
+			mapping = hugetlb_folio_mapping_lock_write(src);
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-harness-remove-use-of-line_max-fix.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

