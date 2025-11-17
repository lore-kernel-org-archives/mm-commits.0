Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27AA21FF23
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343123; cv=none; b=N1n88qS2mEp+F05Vi3xoyW2Wz9gBZ787T9vbl6p7A+ELWkX4YXBn1yT2vVOWKfUTBfoJA57wDL0Da0P7nI1KKGILwibIpDcA8WuilZVrSBgtbkI0g7kECATow+6uhl4p4Lg5+SfT0bKz32ive2UVi4oKzcKvuQiTnjoSwicWbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343123; c=relaxed/simple;
	bh=pZD/gYOQlhLpRA6QtVc/vhvheXpyrzB1QioZkf8BnKU=;
	h=Date:To:From:Subject:Message-Id; b=AsytyWlnK9coWeCzvRWnHhA6NsxrW8kNHY+4J6Ozui2J4H67BVzyRlR7X1grXqh1WKPuacWV1pyrkabysAlmXeEO7ad0hLR+jjZ7b2eVUax7bD5K3wzbSAhty48Y2KZouoXG210kLIQFOxM2WERaTeOX9I3GfBiLWwt3GY4VBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XVqx2uZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVqx2uZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EB7C2BC86;
	Mon, 17 Nov 2025 01:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343123;
	bh=pZD/gYOQlhLpRA6QtVc/vhvheXpyrzB1QioZkf8BnKU=;
	h=Date:To:From:Subject:From;
	b=XVqx2uZ1Zn6lWgSILrxyOY1973Xf4o5iuCl1E3wBdNrLWuKusKY8sBWRoPvW9/+i3
	 rU834gmcCRXYNliuKyxwyxC1Zlzkyx+kyOVBwoE4WHYDZbosZJ5F5Pcu0KY18vokNe
	 OLPa9OHRd7fa4f/1PrcRsbiOS3bxk0Ft41MObVj8=
Date: Sun, 16 Nov 2025 17:32:02 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,ritesh.list@gmail.com,glider@google.com,dvyukov@google.com,christophe.leroy@csgroup.eu,bhe@redhat.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-cleanup-of-kasan_enabled-checks.patch removed from -mm tree
Message-Id: <20251117013203.60EB7C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: cleanup of kasan_enabled() checks
has been removed from the -mm tree.  Its filename was
     kasan-cleanup-of-kasan_enabled-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: cleanup of kasan_enabled() checks
Date: Thu, 9 Oct 2025 20:54:03 +0500

Deduplication of kasan_enabled() checks which are already used by callers.

* Altered functions:

check_page_allocation
	Delete the check because callers have it already in __wrappers in
	include/linux/kasan.h:
		__kasan_kfree_large
		__kasan_mempool_poison_pages
		__kasan_mempool_poison_object

kasan_populate_vmalloc, kasan_release_vmalloc
	Add __wrappers in include/linux/kasan.h.
	They are called externally in mm/vmalloc.c.

__kasan_unpoison_vmalloc, __kasan_poison_vmalloc
	Delete checks because there're already kasan_enabled() checks
	in respective __wrappers in include/linux/kasan.h.

release_free_meta -- Delete the check because the higher caller path
	has it already. See the stack trace:

	__kasan_slab_free -- has the check already
	__kasan_mempool_poison_object -- has the check already
		poison_slab_object
			kasan_save_free_info
				release_free_meta
					kasan_enabled() -- Delete here

Link: https://lkml.kernel.org/r/20251009155403.1379150-3-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   20 ++++++++++++++++++--
 mm/kasan/common.c     |    3 ---
 mm/kasan/generic.c    |    3 ---
 mm/kasan/shadow.c     |   20 ++++----------------
 4 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/kasan.h~kasan-cleanup-of-kasan_enabled-checks
+++ a/include/linux/kasan.h
@@ -571,11 +571,27 @@ static inline void kasan_init_hw_tags(vo
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
-void kasan_release_vmalloc(unsigned long start, unsigned long end,
+int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
+static inline int kasan_populate_vmalloc(unsigned long addr,
+					 unsigned long size, gfp_t gfp_mask)
+{
+	if (kasan_enabled())
+		return __kasan_populate_vmalloc(addr, size, gfp_mask);
+	return 0;
+}
+void __kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
 			   unsigned long flags);
+static inline void kasan_release_vmalloc(unsigned long start, unsigned long end,
+			   unsigned long free_region_start,
+			   unsigned long free_region_end,
+			   unsigned long flags)
+{
+	if (kasan_enabled())
+		return __kasan_release_vmalloc(start, end, free_region_start,
+					 free_region_end, flags);
+}
 
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
--- a/mm/kasan/common.c~kasan-cleanup-of-kasan_enabled-checks
+++ a/mm/kasan/common.c
@@ -305,9 +305,6 @@ bool __kasan_slab_free(struct kmem_cache
 
 static inline bool check_page_allocation(void *ptr, unsigned long ip)
 {
-	if (!kasan_enabled())
-		return false;
-
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
--- a/mm/kasan/generic.c~kasan-cleanup-of-kasan_enabled-checks
+++ a/mm/kasan/generic.c
@@ -506,9 +506,6 @@ static void release_alloc_meta(struct ka
 
 static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
-	if (!kasan_enabled())
-		return;
-
 	/* Check if free meta is valid. */
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
 		return;
--- a/mm/kasan/shadow.c~kasan-cleanup-of-kasan_enabled-checks
+++ a/mm/kasan/shadow.c
@@ -354,7 +354,7 @@ static int ___alloc_pages_bulk(struct pa
 	return 0;
 }
 
-static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
+static int __kasan_populate_vmalloc_do(unsigned long start, unsigned long end, gfp_t gfp_mask)
 {
 	unsigned long nr_pages, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
@@ -395,14 +395,11 @@ static int __kasan_populate_vmalloc(unsi
 	return ret;
 }
 
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
+int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
-	if (!kasan_enabled())
-		return 0;
-
 	if (!is_vmalloc_or_module_addr((void *)addr))
 		return 0;
 
@@ -424,7 +421,7 @@ int kasan_populate_vmalloc(unsigned long
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
+	ret = __kasan_populate_vmalloc_do(shadow_start, shadow_end, gfp_mask);
 	if (ret)
 		return ret;
 
@@ -566,7 +563,7 @@ static int kasan_depopulate_vmalloc_pte(
  * pages entirely covered by the free region, we will not run in to any
  * trouble - any simultaneous allocations will be for disjoint regions.
  */
-void kasan_release_vmalloc(unsigned long start, unsigned long end,
+void __kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
 			   unsigned long flags)
@@ -575,9 +572,6 @@ void kasan_release_vmalloc(unsigned long
 	unsigned long region_start, region_end;
 	unsigned long size;
 
-	if (!kasan_enabled())
-		return;
-
 	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
 	region_end = ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
@@ -626,9 +620,6 @@ void *__kasan_unpoison_vmalloc(const voi
 	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
 	 */
 
-	if (!kasan_enabled())
-		return (void *)start;
-
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
@@ -651,9 +642,6 @@ void *__kasan_unpoison_vmalloc(const voi
  */
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
-	if (!kasan_enabled())
-		return;
-
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
_

Patches currently in -mm which might be from snovitoll@gmail.com are


