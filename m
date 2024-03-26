Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A312F13D618
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711486004; cv=none; b=vCA2rdziSeqOv6Q76LGV5tD+aXzxFElnrFieF+25lcbtx4gmBsqEHBhD4TvXtqVx+BxBetcOWRLXdZVzUHxzZ6A9hwTx20qqCQMQBPwhqp9ojqQQuNc9TIhsigB01R6jQdfBxU72b9AO8FI3RDEGgrfy+TkVrhcZv7DJ1JO5/cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711486004; c=relaxed/simple;
	bh=oO9Gv14FXwQqj50CtJ4zJNkBqUaEaM0Z/8LjSgmYOTk=;
	h=Date:To:From:Subject:Message-Id; b=dGhLlyNgnzqbotkDE1zPfX8nYUH8gbO+EcNdSm2GMcleMvLcLSKyxC3rkZWK4FkM0nfjAqhqLo1N6Y8sIdEcNEQkr5hiI9g3gwloEdX4XoXkMBU+laEjFCK93Gl98sIaZXu8FUpxoXEbn+ha4BJgNnavKwvpNOa8QAbQPoD4Dnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sTSwbZiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sTSwbZiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D017C433F1;
	Tue, 26 Mar 2024 20:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711486004;
	bh=oO9Gv14FXwQqj50CtJ4zJNkBqUaEaM0Z/8LjSgmYOTk=;
	h=Date:To:From:Subject:From;
	b=sTSwbZiHQJcY4BJJ+lqND7rYk5oWKT4PKeruenyAAybV0V3jGfU7Q10IoHHJ2CDEX
	 VJjmpiQd/6Ztg2vbIX8nTy8M4/+6b6XAVzOaNCBCrADxmj8chP0UDN7BR/zRuJY2LR
	 NhPC5jkbb7w6/8k9rW+lRRVhxjMvpnFuwY3TVwng=
Date: Tue, 26 Mar 2024 13:46:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240326204644.2D017C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert migrate_vma_collect_pmd to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch

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
Subject: mm: convert migrate_vma_collect_pmd to use a folio
Date: Tue, 26 Mar 2024 20:28:24 +0000

Convert the pmd directly to a folio and use it.  Turns four calls to
compound_head() into one.

Link: https://lkml.kernel.org/r/20240326202833.523759-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/migrate_device.c~mm-convert-migrate_vma_collect_pmd-to-use-a-folio
+++ a/mm/migrate_device.c
@@ -71,7 +71,7 @@ again:
 		return migrate_vma_collect_hole(start, end, -1, walk);
 
 	if (pmd_trans_huge(*pmdp)) {
-		struct page *page;
+		struct folio *folio;
 
 		ptl = pmd_lock(mm, pmdp);
 		if (unlikely(!pmd_trans_huge(*pmdp))) {
@@ -79,21 +79,21 @@ again:
 			goto again;
 		}
 
-		page = pmd_page(*pmdp);
-		if (is_huge_zero_page(page)) {
+		folio = pmd_folio(*pmdp);
+		if (is_huge_zero_folio(folio)) {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmdp, addr);
 		} else {
 			int ret;
 
-			get_page(page);
+			folio_get(folio);
 			spin_unlock(ptl);
-			if (unlikely(!trylock_page(page)))
+			if (unlikely(!folio_trylock(folio)))
 				return migrate_vma_collect_skip(start, end,
 								walk);
-			ret = split_huge_page(page);
-			unlock_page(page);
-			put_page(page);
+			ret = split_folio(folio);
+			folio_unlock(folio);
+			folio_put(folio);
 			if (ret)
 				return migrate_vma_collect_skip(start, end,
 								walk);
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

