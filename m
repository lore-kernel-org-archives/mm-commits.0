Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847071272C6
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477812; cv=none; b=iqrEIKY1/zdLSnp4pWRBQV+9JRoyo4hAG0VksZ70w0Is7FjpV0m9BJBr09S+9MZJ4rV9Z4owh4LEPSYBOEbKWUKMd5UcSQi7bY8TvkLryAkwAHnEq/eTE/NZbrTzpWTxbj7C04z7p3HyzgHDdWnO/UyipBJsfqzfyS+g5OINeUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477812; c=relaxed/simple;
	bh=7YUMAfGGXdGcesbw7U2izYtG1zBMyDM7JUp8sp0Nqq0=;
	h=Date:To:From:Subject:Message-Id; b=QL0Q7nliALYFKh97OeD/DAHVi8Vxh5xDYKYV2lHbvLGFa+bK14JTFLeXanF3zMZlY9XQRJQrGr1yPcGmJuHzNjy1QA24L4Jc/jBd1p4euWUGYiuzj3eyGq7wcRMPnwlThIAdTyvEzltEQacrbS6Auq+1A7KBfgceuga9x+2QN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wx3LLEsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wx3LLEsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8D8C433F1;
	Tue, 26 Mar 2024 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477812;
	bh=7YUMAfGGXdGcesbw7U2izYtG1zBMyDM7JUp8sp0Nqq0=;
	h=Date:To:From:Subject:From;
	b=Wx3LLEsbYTCSyzNkO8wr4uv2UIp6dJwPH2HDNitQDOxTZX/ShytGPyp2jlZ2F1QRW
	 zgv8C9KsUGxKTo61zLZ8dZoPO4MCtjzIHaNTiGMESkrRW8gTKlhyH4AZUn7gJqMKoI
	 2issMutn6wJ4IB4t91XSuMOknB+sW2wfLW2G2HGg=
Date: Tue, 26 Mar 2024 11:30:11 -0700
To: mm-commits@vger.kernel.org,svetly.todorov@memverge.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch added to mm-unstable branch
Message-Id: <20240326183011.EC8D8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xtensa: remove uses of PG_arch_1 on individual pages
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch

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
Subject: xtensa: remove uses of PG_arch_1 on individual pages
Date: Tue, 26 Mar 2024 17:10:24 +0000

Since switching to the new page table range API, we disregard the
PG_arch_1 (aka dcache dirty) flag on tail pages, and only pay attention to
it on the folio.  Fix these two missed spots where we were setting it on
arbitrary pages.

Link: https://lkml.kernel.org/r/20240326171045.410737-3-willy@infradead.org
Reported-by: Svetly Todorov <svetly.todorov@memverge.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/cache.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/xtensa/mm/cache.c~xtensa-remove-uses-of-pg_arch_1-on-individual-pages
+++ a/arch/xtensa/mm/cache.c
@@ -87,12 +87,13 @@ static inline void *coherent_kvaddr(stru
 
 void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
+	struct folio *folio = page_folio(page);
 	unsigned long paddr;
 	void *kvaddr = coherent_kvaddr(page, TLBTEMP_BASE_1, vaddr, &paddr);
 
 	preempt_disable();
 	kmap_invalidate_coherent(page, vaddr);
-	set_bit(PG_arch_1, &page->flags);
+	set_bit(PG_arch_1, folio_flags(folio, 0));
 	clear_page_alias(kvaddr, paddr);
 	preempt_enable();
 }
@@ -101,6 +102,7 @@ EXPORT_SYMBOL(clear_user_highpage);
 void copy_user_highpage(struct page *dst, struct page *src,
 			unsigned long vaddr, struct vm_area_struct *vma)
 {
+	struct folio *folio = page_folio(dst);
 	unsigned long dst_paddr, src_paddr;
 	void *dst_vaddr = coherent_kvaddr(dst, TLBTEMP_BASE_1, vaddr,
 					  &dst_paddr);
@@ -109,7 +111,7 @@ void copy_user_highpage(struct page *dst
 
 	preempt_disable();
 	kmap_invalidate_coherent(dst, vaddr);
-	set_bit(PG_arch_1, &dst->flags);
+	set_bit(PG_arch_1, folio_flags(folio, 0));
 	copy_page_alias(dst_vaddr, src_vaddr, dst_paddr, src_paddr);
 	preempt_enable();
 }
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

