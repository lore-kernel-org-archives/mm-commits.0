Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405974;
	b=5dOhPJKaLeaH6cmIJCDpBdY5MMuhaW/xuJv57ihWotGYjIwMWmv/IM8sL2/6wHxP04Tv
	 tUv8KKHRpb95+Z1O9j9WKJgFBhGcKMQP2sk5meUIyXvmVSmknsk7pPSOOEaEV3CA1nBnC
	 EYDxbemv6ugzDcOqLuEg68pCH1BvFXf+HWq2GQX9Wi/BDMQtGPL/AsHmms9nxNH3gBmGX
	 F9npd0h37zgBHHSNWFAFijXvBpxUyC0g5PxoQ19sOZ6G7Cnq9JmmVJQSG1j8OlUp0gNVb
	 OD0mhwjyAGUaRCbwMNARxAhZ6vYPjNBgDtrJpd7tBZTQKYpW4OxPPvsx+ZbuIM8Wmig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405974;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DY7pKGPB2rP4TM0KOOTpZQEJvvWX2rLPGBRAt+IRmqU=;
	b=IGBDz/exwCMm5VkjxK/UzoPAeFuKryW8RELW7CQuBwhLk5pVo6oDUYXgLzJRj2gandqt
	 eWCxsEsGeLLcZxTyNo3BiazpIqR7RLiAc9jlFG/sKcCAmETeXFRzqZpLrlHt+ALBxrlho
	 QCs9oozoIKN42GsQZAzy/5T1g1GBxeQvQ3R0bfacU5PPIkngROMHwkPEUwb/Tqf5SjjVr
	 bN6OiHSUB+rqcHeh/+fa2IfXunE8+LJLLbj0lY3gTIGerfuEFPTVhnCRAfOFLg0sXqz8B
	 wBXlMXyLePG5lMLsnbQyr+Xl1M/A9ArUYFv57PRqyPeCFBnckyneZVyNFnO9cUy6xEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QMU8QUOU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414D4606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 00:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QMU8QUOU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33971F000C1;
	Sat, 31 Oct 2026 00:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405973;
	bh=DY7pKGPB2rP4TM0KOOTpZQEJvvWX2rLPGBRAt+IRmqU=;
	h=Date:To:From:Subject;
	b=QMU8QUOUoYDMEsXU6Y1eu8nYNmsAx3OWpqueD64OTLbPsoYhnidRBABIgItbxIEr8
	 ZKOjwVO0fP34sMdO5Whj2JGvFfCLwS/oRjSVcMLGGXOBl3uZbOu3uiIGXakmdKCrw+
	 JY6kksUjgtFoG5q/DF3WJfkpmGLrWO25eLKFs0jc=
Date: Fri, 30 Oct 2026 17:19:33 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@kernel.org,
	lenb@kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,
	david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch added to mm-nonmm-unstable branch
Message-Id: <20261031001933.B33971F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hibernate: handle potential errors in hibernate_{map,unmap}_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: hibernate: handle potential errors in hibernate_{map,unmap}_page()
Date: Sat, 26 Sep 2026 12:26:32 +0300

When safe_copy_page() had to map/unmap pages only because of
debug_pagealloc() there could be no errors in the kernel page table
updates.

However, with the increasing desire to remove pages from the direct map
this assumption becomes a real stretch.

Properly handle errors in hibernate_map_page() and hibernate_unmap_page()
and propagate that error along the page copying path.

Link: https://lore.kernel.org/20260926-hibernation-v2-3-235f69f3ab2a@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
---

 kernel/power/snapshot.c |  102 +++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 40 deletions(-)

--- a/kernel/power/snapshot.c~hibernate-handle-potential-errors-in-hibernate_mapunmap_page
+++ a/kernel/power/snapshot.c
@@ -79,37 +79,30 @@ static inline int hibernate_restore_unpr
 #endif /* CONFIG_STRICT_KERNEL_RWX  && CONFIG_ARCH_HAS_SET_MEMORY */
 
 
-/*
- * The calls to set_direct_map_*() should not fail because remapping a page
- * here means that we only update protection bits in an existing PTE.
- * It is still worth to have a warning here if something changes and this
- * will no longer be the case.
- */
-static inline void hibernate_map_page(struct page *page)
+static inline int hibernate_map_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		int ret = set_direct_map_default_noflush(page, 1);
-
-		if (ret)
-			pr_warn_once("Failed to remap page\n");
+		return set_direct_map_default_noflush(page, 1);
 	} else {
 		debug_pagealloc_map_pages(page, 1);
+		return 0;
 	}
 }
 
-static inline void hibernate_unmap_page(struct page *page)
+static inline int hibernate_unmap_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
 		int ret  = set_direct_map_invalid_noflush(page, 1);
 
 		if (ret)
-			pr_warn_once("Failed to remap page\n");
+			return ret;
 
 		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 	} else {
 		debug_pagealloc_unmap_pages(page, 1);
 	}
+	return 0;
 }
 
 static int swsusp_page_is_free(struct page *page);
@@ -1449,21 +1442,25 @@ static inline bool do_copy_page(long *ds
  * Check if the page we are going to copy is marked as present in the kernel
  * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
  * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
- * always returns 'true'. Returns true if the page was entirely composed of
- * zeros, otherwise it will return false.
+ * always returns 'true'.
+ * Sets @zeros_only to true if the page was entirely composed of zeros.
+ *
+ * Returns 0 on success, a negative error code on failure.
  */
-static bool safe_copy_page(void *dst, struct page *s_page)
+static int safe_copy_page(void *dst, struct page *s_page, bool *zeros_only)
 {
-	bool zeros_only;
+	int err;
 
 	if (kernel_page_present(s_page)) {
-		zeros_only = do_copy_page(dst, page_address(s_page));
-	} else {
-		hibernate_map_page(s_page);
-		zeros_only = do_copy_page(dst, page_address(s_page));
-		hibernate_unmap_page(s_page);
+		*zeros_only = do_copy_page(dst, page_address(s_page));
+		return 0;
 	}
-	return zeros_only;
+
+	err = hibernate_map_page(s_page);
+	if (err)
+		return err;
+	*zeros_only = do_copy_page(dst, page_address(s_page));
+	return hibernate_unmap_page(s_page);
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1473,18 +1470,19 @@ static inline struct page *page_is_savea
 		saveable_highmem_page(zone, pfn) : saveable_page(zone, pfn);
 }
 
-static bool copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
+static int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn,
+			  bool *zeros_only)
 {
 	struct page *s_page, *d_page;
 	void *src, *dst;
-	bool zeros_only;
+	int err = 0;
 
 	s_page = pfn_to_page(src_pfn);
 	d_page = pfn_to_page(dst_pfn);
 	if (PageHighMem(s_page)) {
 		src = kmap_local_page(s_page);
 		dst = kmap_local_page(d_page);
-		zeros_only = do_copy_page(dst, src);
+		*zeros_only = do_copy_page(dst, src);
 		kunmap_local(dst);
 		kunmap_local(src);
 	} else {
@@ -1493,23 +1491,29 @@ static bool copy_data_page(unsigned long
 			 * The page pointed to by src may contain some kernel
 			 * data modified by kmap_atomic()
 			 */
-			zeros_only = safe_copy_page(buffer, s_page);
+			err = safe_copy_page(buffer, s_page, zeros_only);
+			if (err)
+				goto out;
 			dst = kmap_local_page(d_page);
 			copy_page(dst, buffer);
 			kunmap_local(dst);
 		} else {
-			zeros_only = safe_copy_page(page_address(d_page), s_page);
+			err = safe_copy_page(page_address(d_page), s_page,
+					     zeros_only);
 		}
 	}
-	return zeros_only;
+out:
+	return err;
+
 }
 #else
 #define page_is_saveable(zone, pfn)	saveable_page(zone, pfn)
 
-static inline int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
+static inline int copy_data_page(unsigned long dst_pfn, unsigned long src_pfn,
+				 bool *zeros_only)
 {
 	return safe_copy_page(page_address(pfn_to_page(dst_pfn)),
-				pfn_to_page(src_pfn));
+				pfn_to_page(src_pfn), zeros_only);
 }
 #endif /* CONFIG_HIGHMEM */
 
@@ -1517,15 +1521,20 @@ static inline int copy_data_page(unsigne
  * Copy data pages will copy all pages into pages pulled from the copy_bm.
  * If a page was entirely filled with zeros it will be marked in the zero_bm.
  *
- * Returns the number of pages copied.
+ * Sets @copied_pages to the number of pages copied.
+ *
+ * Returns 0 on success, a negative error code on failure.
  */
-static unsigned long copy_data_pages(struct memory_bitmap *copy_bm,
-			    struct memory_bitmap *orig_bm,
-			    struct memory_bitmap *zero_bm)
+static int copy_data_pages(struct memory_bitmap *copy_bm,
+			   struct memory_bitmap *orig_bm,
+			   struct memory_bitmap *zero_bm,
+			   unsigned int *copied_pages)
 {
-	unsigned long copied_pages = 0;
+	unsigned long nr_pages = 0;
 	struct zone *zone;
 	unsigned long pfn, copy_pfn;
+	bool zeros_only;
+	int err;
 
 	for_each_populated_zone(zone) {
 		unsigned long max_zone_pfn;
@@ -1543,15 +1552,21 @@ static unsigned long copy_data_pages(str
 		pfn = memory_bm_next_pfn(orig_bm);
 		if (unlikely(pfn == BM_END_OF_MAP))
 			break;
-		if (copy_data_page(copy_pfn, pfn)) {
+		err = copy_data_page(copy_pfn, pfn, &zeros_only);
+		if (err)
+			return err;
+
+		if (zeros_only) {
 			memory_bm_set_bit(zero_bm, pfn);
 			/* Use this copy_pfn for a page that is not full of zeros */
 			continue;
 		}
-		copied_pages++;
+		nr_pages++;
 		copy_pfn = memory_bm_next_pfn(copy_bm);
 	}
-	return copied_pages;
+
+	*copied_pages = nr_pages;
+	return 0;
 }
 
 /* Total number of image pages */
@@ -2112,6 +2127,7 @@ static int swsusp_alloc(struct memory_bi
 asmlinkage __visible int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
+	int err;
 
 	pm_deferred_pr_dbg("Creating image\n");
 
@@ -2133,7 +2149,9 @@ asmlinkage __visible int swsusp_save(voi
 	 * Kill them.
 	 */
 	drain_local_pages(NULL);
-	nr_copy_pages = copy_data_pages(&copy_bm, &orig_bm, &zero_bm);
+	err = copy_data_pages(&copy_bm, &orig_bm, &zero_bm, &nr_copy_pages);
+	if (err)
+		goto err_swsusp_free;
 
 	/*
 	 * End of critical section. From now on, we can write to memory,
@@ -2149,6 +2167,10 @@ asmlinkage __visible int swsusp_save(voi
 			   nr_copy_pages, nr_zero_pages);
 
 	return 0;
+
+err_swsusp_free:
+	swsusp_free();
+	return err;
 }
 
 #ifndef CONFIG_ARCH_HIBERNATION_HEADER
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

