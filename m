Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F968811F9
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711486012; cv=none; b=h/oRcu7cPBJdvXs/kcfJMnnPW0OnH2N3B9a/6fkmuxew+TaWUZtZ4p35TwkgopyO2iSW0WyOFeBNqcFmYJ82I/dv/JSqKFfpsChMNQ+3Iwk1b3ek/W/pf15wyjyRzNEFxnKwPJxTmqIEnnHSl791xsrtk3Haq+dIuo4OtO7lq8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711486012; c=relaxed/simple;
	bh=XS7gpwFqNBL2gAR5ayXl/5fVP5qkspLiWbi7nHj9mwI=;
	h=Date:To:From:Subject:Message-Id; b=iBLCahZnt+KqMGeCLbHCrGF46pxB6e+glqfveTH+yMzVBEe+QjEkw7pL+2dQZX0c5rIcQel3p0brDHAq1nnjbSbshq8BaluN+apOh0mjcPkNqAdNf0WX/AvuWAoIAc+ZYLJ70lpmsXJ/GjFg4jygQ3SVFuqv3ni8shj/VoyDBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eLXOA85h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eLXOA85h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21557C433C7;
	Tue, 26 Mar 2024 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711486012;
	bh=XS7gpwFqNBL2gAR5ayXl/5fVP5qkspLiWbi7nHj9mwI=;
	h=Date:To:From:Subject:From;
	b=eLXOA85hBrAfCC5waZaWQ7njtYORKHvt6F5m52dASxK2eYxi6UppdNmR8LW4sImMG
	 5Q0XMEnjuMaDffgb/SjoRc1jkfSw0Cd6ce5qTIMoBtpX6E/ZoXingZ3SpNqLraH8BR
	 fTYVICVY6itpAphIlmBSeitiEFnKP0oRUazXypvU=
Date: Tue, 26 Mar 2024 13:46:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch added to mm-unstable branch
Message-Id: <20240326204652.21557C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename mm_put_huge_zero_page to mm_put_huge_zero_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

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
Subject: mm: rename mm_put_huge_zero_page to mm_put_huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:28 +0000

Also remove mm_get_huge_zero_page() now it has no users.

Link: https://lkml.kernel.org/r/20240326202833.523759-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 ++-------
 kernel/fork.c           |    2 +-
 mm/huge_memory.c        |    2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio
+++ a/include/linux/huge_mm.h
@@ -367,12 +367,7 @@ static inline bool is_huge_zero_pud(pud_
 }
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
-void mm_put_huge_zero_page(struct mm_struct *mm);
-
-static inline struct page *mm_get_huge_zero_page(struct mm_struct *mm)
-{
-	return &mm_get_huge_zero_folio(mm)->page;
-}
+void mm_put_huge_zero_folio(struct mm_struct *mm);
 
 #define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
 
@@ -500,7 +495,7 @@ static inline bool is_huge_zero_pud(pud_
 	return false;
 }
 
-static inline void mm_put_huge_zero_page(struct mm_struct *mm)
+static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	return;
 }
--- a/kernel/fork.c~mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio
+++ a/kernel/fork.c
@@ -1343,7 +1343,7 @@ static inline void __mmput(struct mm_str
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
-	mm_put_huge_zero_page(mm);
+	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
 		spin_lock(&mmlist_lock);
--- a/mm/huge_memory.c~mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio
+++ a/mm/huge_memory.c
@@ -241,7 +241,7 @@ struct folio *mm_get_huge_zero_folio(str
 	return READ_ONCE(huge_zero_folio);
 }
 
-void mm_put_huge_zero_page(struct mm_struct *mm)
+void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		put_huge_zero_page();
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

