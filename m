Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A7478E52
	for <mm-commits@vger.kernel.org>; Sun, 20 Sep 2026 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789944439; cv=none; b=QgjOZ9QYaiGZF5nCfgdoFe/cv95Ef34nSe99uyodZ3Tn2GZaoewAPFckLk6R1kk69unTNlOhTTKpZFl28PRZo+h5MQz5TO6G5vnupEn1ttKdcUxCujxTKJAivDmo/RepH3erKnkqq+nhPcDmyFObwiWD8rYmbaA8bSiKYonOE9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789944439; c=relaxed/simple;
	bh=fcnik5hpQuiabI4N9R2eOSwLEThrKppQaqvrbnXHbLk=;
	h=Date:To:From:Subject:Message-Id; b=enxEgkC6W+x/GSZt2w0bbveJhHLI+QX9EyZuO0eWT1DZzGWgX2i2Hh6ILWsWOq8KFIXe0iOj5VCfz0bCdj4oRlgc/PSNRWgh9VzhmZ+0YG+QcqS15kSgNSqBJplgwKic0BH9KrezhU9RuCK+BDsijjmyMeKutu23K6so7zxzv1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JdXnt0Eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JdXnt0Eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267291F000FF;
	Sun, 20 Sep 2026 22:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789944437;
	bh=6GlrcIYD07Ua1juWqdepsHvASZSt86YjTCzj0k/tlpo=;
	h=Date:To:From:Subject;
	b=JdXnt0EhthuXDo7OzsnnwBM2rbMgrVVxW9gjuoHTS/hzDzsr3qPeYbmLRFQRjzCW4
	 NBqD1O52OoAHTNry0LSSH2O9Zs34WO3OQWgAhS5VCk1oRI/My+MvNbxBAjQxg3Q88v
	 /IsOrzkk6PSxCUBmFbp1iFd3uooYhvNS7p38988c=
Date: Sun, 20 Sep 2026 15:47:16 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-config_sparsemem_classic.patch added to mm-new branch
Message-Id: <20260920224717.267291F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add CONFIG_SPARSEMEM_CLASSIC
has been added to the -mm mm-new branch.  Its filename is
     mm-add-config_sparsemem_classic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-config_sparsemem_classic.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm: add CONFIG_SPARSEMEM_CLASSIC
Date: Sun, 20 Sep 2026 15:04:06 +0800

Several MM paths identify classic sparse memory by testing
CONFIG_SPARSEMEM while also testing that CONFIG_SPARSEMEM_VMEMMAP is
disabled.  Repeating the compound condition obscures the memory model
being selected and requires the local SECTION_IN_PAGE_FLAGS alias for the
same state.

Add CONFIG_SPARSEMEM_CLASSIC as a hidden derived option and use it at the
conditional sites.  Remove SECTION_IN_PAGE_FLAGS and test the new option
directly.

The x86 32-bit vDSO build starts with the x86_64 configuration and then
undefines CONFIG_SPARSEMEM_VMEMMAP to emulate a 32-bit configuration. 
Kconfig-derived symbols are not recomputed by the C preprocessor, so
define CONFIG_SPARSEMEM_CLASSIC there when CONFIG_SPARSEMEM is enabled. 
This preserves the existing behavior.

Link: https://lore.kernel.org/20260920070406.95354-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---

 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |    3 +++
 include/linux/mm.h                            |   12 ++++--------
 include/linux/mmzone.h                        |    2 +-
 include/linux/page-flags-layout.h             |    2 +-
 mm/Kconfig                                    |    3 +++
 mm/util.c                                     |    2 +-
 6 files changed, 13 insertions(+), 11 deletions(-)

--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h~mm-add-config_sparsemem_classic
+++ a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -20,6 +20,9 @@
 #define CONFIG_PAGE_OFFSET 0
 #define CONFIG_ILLEGAL_POINTER_VALUE 0
 #define CONFIG_NR_CPUS 1
+#ifdef CONFIG_SPARSEMEM
+#define CONFIG_SPARSEMEM_CLASSIC 1
+#endif
 
 #define BUILD_VDSO32_64
 
--- a/include/linux/mm.h~mm-add-config_sparsemem_classic
+++ a/include/linux/mm.h
@@ -201,7 +201,7 @@ static inline void __mm_zero_struct_page
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
 #else
 static inline bool page_range_contiguous(const struct page *page,
@@ -2531,10 +2531,6 @@ static inline bool is_nommu_shared_vma_f
 }
 #endif
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-#define SECTION_IN_PAGE_FLAGS
-#endif
-
 /*
  * The identification function is mainly used by the buddy allocator for
  * determining if two pages could be buddies. We are not really identifying
@@ -2805,7 +2801,7 @@ static inline struct zone *folio_zone(co
 	return &folio_pgdat(folio)->node_zones[folio_zonenum(folio)];
 }
 
-#ifdef SECTION_IN_PAGE_FLAGS
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 static inline void set_page_section(struct page *page, unsigned long section)
 {
 	page->flags.f &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
@@ -2823,7 +2819,7 @@ static inline unsigned long memdesc_sect
 	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
-#else /* !SECTION_IN_PAGE_FLAGS */
+#else /* !CONFIG_SPARSEMEM_CLASSIC */
 static inline void set_page_section_from_pfn(struct page *page,
 		unsigned long pfn)
 {
@@ -2833,7 +2829,7 @@ static inline unsigned long memdesc_sect
 {
 	return 0;
 }
-#endif /* SECTION_IN_PAGE_FLAGS */
+#endif /* CONFIG_SPARSEMEM_CLASSIC */
 
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
--- a/include/linux/mmzone.h~mm-add-config_sparsemem_classic
+++ a/include/linux/mmzone.h
@@ -68,7 +68,7 @@
  * memory sections).
  */
 #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
-#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#elif defined(CONFIG_SPARSEMEM_CLASSIC)
 /*
  * Only pages within a single memory section are guaranteed to be
  * contiguous. By limiting folios to a single memory section, all folio
--- a/include/linux/page-flags-layout.h~mm-add-config_sparsemem_classic
+++ a/include/linux/page-flags-layout.h
@@ -49,7 +49,7 @@
  *      " plus space for last_cpupid: | SECTION | NODE | ZONE | LAST_CPUPID ... | FLAGS |
  * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
  */
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 #define SECTIONS_WIDTH		SECTIONS_SHIFT
 #else
 #define SECTIONS_WIDTH		0
--- a/mm/Kconfig~mm-add-config_sparsemem_classic
+++ a/mm/Kconfig
@@ -461,6 +461,9 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config SPARSEMEM_CLASSIC
+	def_bool SPARSEMEM && !SPARSEMEM_VMEMMAP
+
 config VMEMMAP_OPTIMIZATION
 	bool
 	depends on SPARSEMEM_VMEMMAP
--- a/mm/util.c~mm-add-config_sparsemem_classic
+++ a/mm/util.c
@@ -1590,7 +1590,7 @@ unsigned int folio_pte_batch(struct foli
 }
 #endif /* CONFIG_MMU */
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 /**
  * page_range_contiguous - test whether the page range is contiguous
  * @page: the start of the page range.
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch
mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch
nvdimm-pmem-remove-test_and_clear_pmem_poison.patch
mm-add-config_sparsemem_classic.patch

