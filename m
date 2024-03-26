Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C861FBB
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477810; cv=none; b=H4qnfGx2wXh9eBLMpxclrci5k0QDJWiBlaD5Wru3/U8AMmCBOsYKjsY3/T7/PrRI/6cqiMZIXCzT7m7p59TdHQDoidWnupZFTS1HcDd2zkrGj63XsL00auVP7j3zC8YTXidRonAE2rc1IlBWFMFzBqtMaEPsM/BvZIcqSNYDHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477810; c=relaxed/simple;
	bh=pRYx1d+Gen/VyYUESoMEnB7VEJ3JeohXzBvNHRWhUg4=;
	h=Date:To:From:Subject:Message-Id; b=RFYJiiiuOA1mvDd5yFE9DibftZYXhPMQcQ7HQYw1eRp//O/ZkJZC/TDC11rwXqwV8JnZNZ6KmLD8tbVCj88VCZlXHgQpbdUsOC+Zy5cbC62cSdUKIHXEFbyRcaIpKVgu5LzXZFdDZgvuI1hIJjsixAj8gKL/5EfqiJV7Vzkl5j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sEqasor1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sEqasor1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE3FC433C7;
	Tue, 26 Mar 2024 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477810;
	bh=pRYx1d+Gen/VyYUESoMEnB7VEJ3JeohXzBvNHRWhUg4=;
	h=Date:To:From:Subject:From;
	b=sEqasor1fJBMK5icOvaIlWrPapVQhjeoWHjLYMgKFWY7POTG5+z4maEauMa6+lLwL
	 8Wlof7nG1uMr/58yE+YYckUqoN6xjS0Nw1LZdU0SDXe/EZ2TYoHFz73DZYSwuivpso
	 vM89tRBCD4yk6ffYqX0H19tt2V7g7N6i1lEecGik=
Date: Tue, 26 Mar 2024 11:30:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-remove-use-of-pg_arch_1-on-individual-pages.patch added to mm-unstable branch
Message-Id: <20240326183010.2FE3FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: remove use of PG_arch_1 on individual pages
has been added to the -mm mm-unstable branch.  Its filename is
     sh-remove-use-of-pg_arch_1-on-individual-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-remove-use-of-pg_arch_1-on-individual-pages.patch

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
Subject: sh: remove use of PG_arch_1 on individual pages
Date: Tue, 26 Mar 2024 17:10:23 +0000

Patch series "Various page->flags cleanups".

The first two patches are bug fixes, although I'm not sure that either
architecture will have noticed.  There aren't a lot of uses of page->flags
left!  The big build-up here is to reworking stable_page_flags(), which
will definitely be a user-visible change.  I think a welcome one, given
the special case we had to spread the Slab flag into all tail pages.


This patch (of 10):

Since switching to the new page table range API, we do not set the
PG_arch_1 (aka dcache clean) flag on tail pages, only on the folio.  Test
it on the folio.  Also use page_mapped() instead of page_mapcount() as it
is more efficient.

Link: https://lkml.kernel.org/r/20240326171045.410737-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240326171045.410737-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/cache-sh4.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/sh/mm/cache-sh4.c~sh-remove-use-of-pg_arch_1-on-individual-pages
+++ a/arch/sh/mm/cache-sh4.c
@@ -241,13 +241,14 @@ static void sh4_flush_cache_page(void *a
 	if ((vma->vm_mm == current->active_mm))
 		vaddr = NULL;
 	else {
+		struct folio *folio = page_folio(page);
 		/*
 		 * Use kmap_coherent or kmap_atomic to do flushes for
 		 * another ASID than the current one.
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
-			test_bit(PG_dcache_clean, &page->flags) &&
-			page_mapcount(page));
+			test_bit(PG_dcache_clean, folio_flags(folio)) &&
+			page_mapped(page));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
 		else
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

