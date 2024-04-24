Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F244156964
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 23:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714001609; cv=none; b=V76rrgot33z0C+AC9AhKWKYiNABZGhaTVw9Z6/0S6INskbV08TVpefzkFiOV/BG7ctquWpOTkILx6ciYNrdjai40XKQqsVMdhpMAawbOAoi1BYOIvs1jVavFsTe475m+e6+oJSPbGzGKVaIHf93dYYeNmJBhVQ/Em3MdAi8ov+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714001609; c=relaxed/simple;
	bh=R/xulaqTdFbLzKjkspoBkQaPsbB/LmDVRyImzvYE+RI=;
	h=Date:To:From:Subject:Message-Id; b=XA2BdlNi7pL4oMz1qmEYuXkgA99q90YFDGZgXcKF1KKkYFbG0kij6v+MqL9uShhCONQZNSMA8tyUaHW+kCyAqGE/OHuc+qvyocvjtaz3FdINQQqDJr0A4AnVM50usckzSz55yccgzGp9JncBS7fUf6ijt5k8JMUmG9KAY8xh3Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hO0pzTUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hO0pzTUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F100AC113CD;
	Wed, 24 Apr 2024 23:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714001609;
	bh=R/xulaqTdFbLzKjkspoBkQaPsbB/LmDVRyImzvYE+RI=;
	h=Date:To:From:Subject:From;
	b=hO0pzTUkAadTHQ7H+AudUAI9v6JpbI54INsK8op/qCDq1ZSBBTn9UCS9JF5uNBDGv
	 hqnU5RUxHnWJBRmWoWyM6Z+FytMbUHVMxYbLUazxZfmnjm0/MC+HjBQC3W5+Lc/mXl
	 XgustwQyvpIBEBKUThFeBeyBfREJWrS9EmK6AUuI=
Date: Wed, 24 Apr 2024 16:33:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write.patch added to mm-unstable branch
Message-Id: <20240424233328.F100AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert hugetlb_page_mapping_lock_write() to hugetlb_folio_mapping_lock_write
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write.patch

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
mm-convert-hugetlb_page_mapping_lock_write-to-hugetlb_folio_mapping_lock_write.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

