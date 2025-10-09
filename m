Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A40719EED3
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 23:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760054245; cv=none; b=EobwPvy42Ri8rGxKoqN5gUecKbVuiDoa8KECZjR7PmvTcDxRWgQKfTqYnYHh4TVBG5rse7tL5d6HwXTb+BOzp3Gp4isXjB1/wD8DauCXDA1QUVjdMMftpQWCapwPWKcbCrOtrYXZm9GcOEtNXAx/IHlOHCGG02DyD3QgKAUIf8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760054245; c=relaxed/simple;
	bh=HmCOc5S4pPWhVJkgeV8xKlg0srD9ZzitYtrJ4I3lGxc=;
	h=Date:To:From:Subject:Message-Id; b=l7Vtw9Fi5P66jSxFz2v1R6+VPvndjH3vldkH+Dct3ZhejYkdxtIeUYm6sBMqgi68yqmt3KCI46pgwAC+ldv9gm0cOKh8uXqUIEmquKysX00CKhVNHdZvUKUaCDLD+wDqx1UCns6kqmMwSRqn/Pan1o6VeT3qynn7a3HNAsBWV8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhImU6YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhImU6YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53DFC4CEE7;
	Thu,  9 Oct 2025 23:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760054244;
	bh=HmCOc5S4pPWhVJkgeV8xKlg0srD9ZzitYtrJ4I3lGxc=;
	h=Date:To:From:Subject:From;
	b=XhImU6YVputYytHr+Dp+Eiir1/HBcRSD0zopLx473j6AYGPsASnUHcA9Zh+/IR7rp
	 WuDOymUpjUvkGFeaqowIy9w22AueUtmPfNHGwTtzjxRgvIWdJqJJQqM4+bnldQKz0v
	 orXZVfQZ+9jOWbuAgH/QnY74rBDUhfkZttStEB00=
Date: Thu, 09 Oct 2025 16:57:23 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,ritesh.list@gmail.com,glider@google.com,dvyukov@google.com,christophe.leroy@csgroup.eu,bhe@redhat.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-cleanup-of-kasan_enabled-checks.patch added to mm-new branch
Message-Id: <20251009235724.B53DFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: cleanup of kasan_enabled() checks
has been added to the -mm mm-new branch.  Its filename is
     kasan-cleanup-of-kasan_enabled-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-cleanup-of-kasan_enabled-checks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

kasan-remove-__kasan_save_free_info-wrapper.patch
kasan-cleanup-of-kasan_enabled-checks.patch

