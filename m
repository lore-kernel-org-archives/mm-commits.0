Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E902F4A
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477827; cv=none; b=r2n1XyDUn5qnEhuk/wOwpW3TByzpJ4uIjEADwCkwZC7t/7ia7wXh5UU3WOKM0c9cHrhIc9QfgoVN9AG8TTS5CNX52VSTziFOUoS+Wbq1872GX+OmXplnqaBYbvAud/sHsZDLpFm4WrXudjW6Ot2a7kRIl0xrc5E5LfPQwsMtX9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477827; c=relaxed/simple;
	bh=iiHA/BPeCuccnJIuQhlp4li/btjAfTOmFgUW1CgsV8I=;
	h=Date:To:From:Subject:Message-Id; b=oU1NaWnJGH/8JODlayXOJeu0Ykwd7o72aCDWNcN+oxI99klG5vb35yDG9F0bmz8pfdtjTL0mu+SgJNimbgs07+vEtOkqXQCXhCIE0gFj/jhJzPLggLHSjMtIdatAfeXju0K3Qy5yi4pG0Y83oWc5+zhFSffJ+tuLAXhHS7h+He0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fi+5S62+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fi+5S62+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7524AC433F1;
	Tue, 26 Mar 2024 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477826;
	bh=iiHA/BPeCuccnJIuQhlp4li/btjAfTOmFgUW1CgsV8I=;
	h=Date:To:From:Subject:From;
	b=fi+5S62+cKufEQV7U1EpdZWaEXlo7vK7QwA6Mv/nJBUdfT3NETinsdmOgcHkXtfEw
	 FKXf5xxCQ4NJWWR4E7OMAZCfjD0pyfOLIkQUQsMC2PBizlZPGgWF1FDYZPTdfdyXwZ
	 v9XFPUerVWScQW6AuJj9rSKF+DV3EDy9dRc1+d48=
Date: Tue, 26 Mar 2024 11:30:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slub-remove-use-of-page-flags.patch added to mm-unstable branch
Message-Id: <20240326183026.7524AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slub: remove use of page->flags
has been added to the -mm mm-unstable branch.  Its filename is
     slub-remove-use-of-page-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slub-remove-use-of-page-flags.patch

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
Subject: slub: remove use of page->flags
Date: Tue, 26 Mar 2024 17:10:30 +0000

Use slub->__page_flags instead.  We can also remove the assertion that
it's not a tail page as struct slab never points to a tail page.

Link: https://lkml.kernel.org/r/20240326171045.410737-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/slub.c~slub-remove-use-of-page-flags
+++ a/mm/slub.c
@@ -616,18 +616,12 @@ slub_set_cpu_partial(struct kmem_cache *
  */
 static __always_inline void slab_lock(struct slab *slab)
 {
-	struct page *page = slab_page(slab);
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	bit_spin_lock(PG_locked, &page->flags);
+	bit_spin_lock(PG_locked, &slab->__page_flags);
 }
 
 static __always_inline void slab_unlock(struct slab *slab)
 {
-	struct page *page = slab_page(slab);
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	bit_spin_unlock(PG_locked, &page->flags);
+	bit_spin_unlock(PG_locked, &slab->__page_flags);
 }
 
 static inline bool
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

