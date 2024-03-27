Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A63C14F11F
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567154; cv=none; b=UueVd+UTn3MFm7AUblBsq05AW+BtNRbTRGsZzperVB0BXV4/I4EEHU8ZbQC0cc6UqreSIwY+eizd6wr4lH4/Up9aV5VOs92ECAejWr2Pl3fHAmUA+MDE2phEqQF4reJmBK2w5a5Fd9/arOk5mN+OQYs6iE3dRiJKXcIhnovACS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567154; c=relaxed/simple;
	bh=hmzEGk0WOjZKlOcEsnw6UhNc6bmEFiNwb8ItjFwzYQY=;
	h=Date:To:From:Subject:Message-Id; b=rPMHaXqPUcPte+hAbmhM5iNKvSkitkjmZRY/8g8L2gKdnHHsrJYlV01a1XEOVyGqLh90vKKIS4QgPC6zOvcjc2iqrEoQ+FuWQnKP+tD2n1gXrZV7L/DI0sHlgRNMWqTwS0p3RNIEOQAyTuFyzobI7hjVk6vwUOEeOdBFza4vnuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VHTtCaYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VHTtCaYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F2DC433C7;
	Wed, 27 Mar 2024 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567154;
	bh=hmzEGk0WOjZKlOcEsnw6UhNc6bmEFiNwb8ItjFwzYQY=;
	h=Date:To:From:Subject:From;
	b=VHTtCaYwvCEXio+uu+ATC6xe6Zx50pbwwQbo5u/kIQiCD5KcD+s2KUcF6ji75zXXR
	 Rzvf2FGB9pP9/0USOsgzsCeZLugn8xgn+G4gxIY4K5W9MRyfMjRGrWUc1zGig1N9ri
	 or+5TIAVa5z7iOwbte6NKWKA5SXUonJ2MiKIDy28=
Date: Wed, 27 Mar 2024 12:19:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-rwsem-assertion-macros-for-mmap_lock.patch added to mm-unstable branch
Message-Id: <20240327191913.E9F2DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use rwsem assertion macros for mmap_lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-rwsem-assertion-macros-for-mmap_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-rwsem-assertion-macros-for-mmap_lock.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use rwsem assertion macros for mmap_lock
Date: Wed, 27 Mar 2024 19:06:59 +0000

This slightly strengthens our write assertion when lockdep is disabled. 
It also downgrades us from BUG_ON to WARN_ON, but I think that's an
improvement.  I don't think dumping the mm_struct was all that valuable;
the call chain is what's important.

Link: https://lkml.kernel.org/r/20240327190701.1082560-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mm-use-rwsem-assertion-macros-for-mmap_lock
+++ a/include/linux/mmap_lock.h
@@ -60,16 +60,14 @@ static inline void __mmap_lock_trace_rel
 
 #endif /* CONFIG_TRACING */
 
-static inline void mmap_assert_locked(struct mm_struct *mm)
+static inline void mmap_assert_locked(const struct mm_struct *mm)
 {
-	lockdep_assert_held(&mm->mmap_lock);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+	rwsem_assert_held(&mm->mmap_lock);
 }
 
-static inline void mmap_assert_write_locked(struct mm_struct *mm)
+static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 {
-	lockdep_assert_held_write(&mm->mmap_lock);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+	rwsem_assert_held_write(&mm->mmap_lock);
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch

