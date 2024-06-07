Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE51552ED
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717800523; cv=none; b=RxhzB3BCWeY7WrMTJ3VZLC9q9F5pOCqFz59nxkx/ms+JaESVfVjFpQqbmMdq877QS2qMOLnQkJjExE0wxeJ+pajKwoDoUcQrvLHWZT+eksyYRLg4C8C4aR4XzCzL1SdjQXNdKP4LPEMokqwt3z5Xm6C7bZ2uqYHBF03rMuBmPTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717800523; c=relaxed/simple;
	bh=1G9nrTYyh72nZj59cNfQThJpJtJeW8kOidBys/h+mmE=;
	h=Date:To:From:Subject:Message-Id; b=Ll6l27UH7+QvyjiJzF7Tt0pfZYsB4RMsZU68cE0BFOij35kuN0fvgf36mGq3NT1dMnGcI9qZK/o2ZqN93lk8vtN86qkg04cSf8EQhuRlNHZH5ginBmWkH6NdkEBupJ9SL3q5lSJnR7HqKvAe3HdM86gzoLrh6wc4qQDi2B7s6qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjlKllk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjlKllk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D86C2BBFC;
	Fri,  7 Jun 2024 22:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717800522;
	bh=1G9nrTYyh72nZj59cNfQThJpJtJeW8kOidBys/h+mmE=;
	h=Date:To:From:Subject:From;
	b=GjlKllk/pV0vc9gQZLbSM2iFJtFdl5QZ2U2LUZrNF42XzFYq+wGNLjA/PmjA3KKvN
	 EGGG/uWJJilpPju28VdOdIRlETbizVjK1AWhwJtP5jo6LK6kLiPqX/07nBtL9ljkN8
	 0zEhNeAQwMRdJKwuCqQ3V9knh0pfo9t5/z9xNl44=
Date: Fri, 07 Jun 2024 15:48:42 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch added to mm-unstable branch
Message-Id: <20240607224842.C8D86C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/highmem: reimplement totalhigh_pages() by walking zones
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/highmem: reimplement totalhigh_pages() by walking zones
Date: Fri, 7 Jun 2024 10:37:10 +0200

Patch series "mm/highmem: don't track highmem pages manually".

Let's remove highmem special-casing from adjust_managed_page_count(), to
result in less confusion why memblock manually adjusts totalram_pages, and
__free_pages_core() only adjusts the zone's managed pages -- what about
the highmem pages that adjust_managed_page_count() updates?

Now, we only maintain totalram_pages and a zone's managed pages
independent of highmem support.  We can derive the number of highmem pages
simply by looking at the relevant zone's managed pages.  I don't think
there is any particular fast path that needs a maximum-efficient
totalhigh_pages() implementation.

Note that highmem memory is currently initialized using
free_highmem_page()->free_reserved_page(), not __free_pages_core().  In
the future we might want to also use __free_pages_core() to initialize
highmem memory, to make that less special, and consider moving
totalram_pages updates into __free_pages_core() [1], so we can just use
adjust_managed_page_count() in there as well.

Booting a simple kernel in QEMU reveals no highmem accounting change:

Before:
  Memory: 3095448K/3145208K available (14802K kernel code, 2073K rwdata,
  5000K rodata, 740K init, 556K bss, 49760K reserved, 0K cma-reserved,
  2244488K highmem)

After:
  Memory: 3095276K/3145208K available (14802K kernel code, 2073K rwdata,
  5000K rodata, 740K init, 556K bss, 49932K reserved, 0K cma-reserved,
  2244488K highmem)

[1] https://lkml.kernel.org/r/20240601133402.2675-1-richard.weiyang@gmail.com


This patch (of 2):

Can we get rid of the highmem ifdef in adjust_managed_page_count()? 
Likely yes: we don't have that many totalhigh_pages() users, and they all
don't seem to be very performance critical.

So let's implement totalhigh_pages() like nr_free_highpages(), collecting
information from all zones.  This is now similar to what we do in
si_meminfo_node() to collect the per-node highmem page count.

In the common case (single node, 3-4 zones), we really shouldn't care.  We
could optimize a bit further (only walk ZONE_HIGHMEM and ZONE_MOVABLE if
required), but there doesn't seem a real need for that.

Link: https://lkml.kernel.org/r/20240607083711.62833-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240607083711.62833-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    9 ++-------
 mm/highmem.c                     |   16 +++++++++++++---
 mm/page_alloc.c                  |    4 ----
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/highmem-internal.h~mm-highmem-reimplement-totalhigh_pages-by-walking-zones
+++ a/include/linux/highmem-internal.h
@@ -132,7 +132,7 @@ static inline void __kunmap_atomic(const
 }
 
 unsigned int __nr_free_highpages(void);
-extern atomic_long_t _totalhigh_pages;
+unsigned long __totalhigh_pages(void);
 
 static inline unsigned int nr_free_highpages(void)
 {
@@ -141,12 +141,7 @@ static inline unsigned int nr_free_highp
 
 static inline unsigned long totalhigh_pages(void)
 {
-	return (unsigned long)atomic_long_read(&_totalhigh_pages);
-}
-
-static inline void totalhigh_pages_add(long count)
-{
-	atomic_long_add(count, &_totalhigh_pages);
+	return __totalhigh_pages();
 }
 
 static inline bool is_kmap_addr(const void *x)
--- a/mm/highmem.c~mm-highmem-reimplement-totalhigh_pages-by-walking-zones
+++ a/mm/highmem.c
@@ -111,9 +111,6 @@ static inline wait_queue_head_t *get_pkm
 }
 #endif
 
-atomic_long_t _totalhigh_pages __read_mostly;
-EXPORT_SYMBOL(_totalhigh_pages);
-
 unsigned int __nr_free_highpages(void)
 {
 	struct zone *zone;
@@ -125,6 +122,19 @@ unsigned int __nr_free_highpages(void)
 	}
 
 	return pages;
+}
+
+unsigned long __totalhigh_pages(void)
+{
+	unsigned long pages = 0;
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		if (is_highmem(zone))
+			pages += zone_managed_pages(zone);
+	}
+
+	return pages;
 }
 
 static int pkmap_count[LAST_PKMAP];
--- a/mm/page_alloc.c~mm-highmem-reimplement-totalhigh_pages-by-walking-zones
+++ a/mm/page_alloc.c
@@ -5785,10 +5785,6 @@ void adjust_managed_page_count(struct pa
 {
 	atomic_long_add(count, &page_zone(page)->managed_pages);
 	totalram_pages_add(count);
-#ifdef CONFIG_HIGHMEM
-	if (PageHighMem(page))
-		totalhigh_pages_add(count);
-#endif
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

