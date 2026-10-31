Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405976;
	b=xdVMMZ7URTqEsSgV6oRN3feWzHDI4dybGbOkkHkEBXWXO7R/K0uQFiaJwQgW1RCbxRHC
	 7GPvrTe+janVFhzTWSqY1TweLb6NehtoPUG3oJuy2XcuiemYqdQE0t1kD57i+BrSFqXQS
	 rsmszQfWHlAbcm8UISLg4Zrf+tnrAWcBo/8GAQB2q4NazPLVdNlleAyZ3GWehLgKKNYIB
	 D2R2UhX2AHxVt+5ciKPZwgJR73gkMeoZ1cBBiN0mK9z/QMX+rCYyitfYDZwY6IBZPSaP0
	 slmjE8PaZTmJh9jlvtmnW871Murpx3BIL784Cl2iM2RY4+N750hGQi17sL8BQrQ7QcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405976;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ptRoudGId+qTg/NGxtXAKGjQ+1l9ruwlQh9kAjAxoA8=;
	b=V2alDN2nd1VJeHbsBeEzWkoZH4v7YZObOokwbxz/V5/1fCrOptBkiKysPaKo1YXVHoex
	 RDeG5CGFpYFi5SnZ5ndxeQbCoMGaxwk9gwXKQW9Juakfbgbdc5SVjzU9KW4g8kAGP4X29
	 AjjEvvncabT8/XiWemcEQGVong2DoDBPdQX3eL8wISvkFXKu55bf5atzHE9R/k2QxuKwC
	 5H+axFRQOcsjR+o15sU1bhw9kW1kZ1rrx/YwPBFnYEVcFL16NWHuMNjhUBHDAMOcHfFxF
	 abbJyfYuEfSgu4iedTXYScWw7pAxXTOLp9N26attv0yaG9Ga0tkyR9su0uIt/1ylYdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pWtG7seC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57099606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pWtG7seC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90E11F000C1;
	Sat, 31 Oct 2026 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405975;
	bh=ptRoudGId+qTg/NGxtXAKGjQ+1l9ruwlQh9kAjAxoA8=;
	h=Date:To:From:Subject;
	b=pWtG7seCa+TNVXlUVyDxvOkkhAxL2cYH4sPTD7zESw6nygo1KMRLWWlcJxzn7ugMo
	 sd9rZSunPcPyNlIvF8IsUXI5zvtBZwfyznVYbhwkVAgwK5hlPKRmMFuz6sCSZQxUpu
	 pv/0EG6F03ocugJYOKQG2Sr904JoqKHYEMVkTO+o=
Date: Fri, 30 Oct 2026 17:19:35 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@kernel.org,
	lenb@kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,
	david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hibernation-kfence-explicitly-map-unmap-kfence-pages.patch added to mm-nonmm-unstable branch
Message-Id: <20261031001935.C90E11F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hibernation, KFENCE: explicitly map/unmap KFENCE pages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hibernation-kfence-explicitly-map-unmap-kfence-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hibernation-kfence-explicitly-map-unmap-kfence-pages.patch

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
Subject: hibernation, KFENCE: explicitly map/unmap KFENCE pages
Date: Sat, 26 Sep 2026 12:26:33 +0300

The pages protected by KFENCE are removed from the direct map.

safe_copy_page() temporarily maps and unmaps them using set_direct_map
APIs, or, when the stars align, even using debug_pagealloc_map_pages().

Neither of these APIs cares whether it is a KFENCE page and both blindly
perform the update of the kernel page table for any non-present page.

Ability to use debug_pagealloc_map_pages() to remap KFENCE pages when both
KFENCE and debug_pagealloc are enabled is an amusing coincidence.

But with increasing appetite for using set_direct_map for hardening
purposes, it becomes too big of a hammer to enable saving any non-present
page in the hibernation image.

Another gotcha is that loongarch that does not have a direct map at all
advertises ARCH_HAS_SET_DIRECT_MAP to allow coexistence of KFENCE and
hibernation.

Extend KFENCE with a bitmap that tracks which pages are protected and
provide kfence_force_mapping() and kfence_reset_mapping() APIs that allow
forced mapping and unmapping of KFENCE pages.

Use these APIs in hibernate_{map,unmap}_pages() for KFENCE pages.

Link: https://lore.kernel.org/20260926-hibernation-v2-4-235f69f3ab2a@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
---

 include/linux/kfence.h  |   29 +++++++++++++++++++++
 kernel/power/snapshot.c |    7 +++++
 mm/kfence/core.c        |   52 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 86 insertions(+), 2 deletions(-)

--- a/include/linux/kfence.h~hibernation-kfence-explicitly-map-unmap-kfence-pages
+++ a/include/linux/kfence.h
@@ -222,6 +222,32 @@ struct kmem_obj_info;
 bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
 #endif
 
+/**
+ * kfence_force_mapping() - make sure a KFENCE page is mapped
+ * @page: page to map
+ *
+ * Check whether @page is protected and map it if needed.
+ *
+ * Requires: is_kfence_address(page_address(page))
+ *
+ * Return:
+ * * false - failed to map @page
+ * * true - @page is mapped
+ */
+bool kfence_force_mapping(struct page *page);
+
+/**
+ * kfence_reset_mapping() - reset a forced mapping of a KFENCE page
+ * @page: page to restore mapping
+ *
+ * Requires: is_kfence_address(page_address(page))
+ *
+ * Return:
+ * * false - failed to reset mapping of the @page
+ * * true - succeeded to reset mapping of the @page
+ */
+bool kfence_reset_mapping(struct page *page);
+
 #else /* CONFIG_KFENCE */
 
 #define kfence_sample_interval	(0)
@@ -241,6 +267,9 @@ static inline bool __must_check kfence_h
 	return false;
 }
 
+static inline bool kfence_force_mapping(struct page *page) { return true; }
+static inline bool kfence_reset_mapping(struct page *page) { return true; }
+
 #ifdef CONFIG_PRINTK
 struct kmem_obj_info;
 static inline bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
--- a/kernel/power/snapshot.c~hibernation-kfence-explicitly-map-unmap-kfence-pages
+++ a/kernel/power/snapshot.c
@@ -31,6 +31,7 @@
 #include <linux/compiler.h>
 #include <linux/ktime.h>
 #include <linux/set_memory.h>
+#include <linux/kfence.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -81,6 +82,9 @@ static inline int hibernate_restore_unpr
 
 static inline int hibernate_map_page(struct page *page)
 {
+	if (is_kfence_address(page_address(page)))
+		return kfence_force_mapping(page) ? 0 : -EFAULT;
+
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		return set_direct_map_default_noflush(page, 1);
 	} else {
@@ -91,6 +95,9 @@ static inline int hibernate_map_page(str
 
 static inline int hibernate_unmap_page(struct page *page)
 {
+	if (is_kfence_address(page_address(page)))
+		return kfence_reset_mapping(page) ? 0 : -EFAULT;
+
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
 		int ret  = set_direct_map_invalid_noflush(page, 1);
--- a/mm/kfence/core.c~hibernation-kfence-explicitly-map-unmap-kfence-pages
+++ a/mm/kfence/core.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) "kfence: " fmt
 
 #include <linux/atomic.h>
+#include <linux/bitmap.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
@@ -123,6 +124,9 @@ module_param_named(check_on_panic, kfenc
 char *__kfence_pool __read_mostly;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
 
+/* keep track of protected pages */
+static DECLARE_BITMAP(kfence_protected_pages, KFENCE_POOL_SIZE / PAGE_SIZE);
+
 /*
  * Per-object metadata, with one-to-one mapping of object metadata to
  * backing pages (in __kfence_pool).
@@ -249,14 +253,36 @@ static bool alloc_covered_contains(u32 a
 	return true;
 }
 
+static bool __kfence_protect(unsigned long addr, bool protect)
+{
+	unsigned long page_addr = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long pool_addr = (unsigned long)__kfence_pool;
+	unsigned long index = (page_addr - pool_addr) >> PAGE_SHIFT;
+	bool state;
+
+	assign_bit(index, kfence_protected_pages, protect);
+
+	/*
+	 * Reapply protection if the desired state changed while updating
+	 * the page table.
+	 */
+	do {
+		state = test_bit(index, kfence_protected_pages);
+		if (!kfence_protect_page(page_addr, state))
+			return false;
+	} while (state != test_bit(index, kfence_protected_pages));
+
+	return true;
+}
+
 static bool kfence_protect(unsigned long addr)
 {
-	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), true));
+	return !KFENCE_WARN_ON(!__kfence_protect(addr, true));
 }
 
 static bool kfence_unprotect(unsigned long addr)
 {
-	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), false));
+	return !KFENCE_WARN_ON(!__kfence_protect(addr, false));
 }
 
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
@@ -1337,3 +1363,25 @@ out:
 
 	return kfence_unprotect(addr); /* Unprotect and let access proceed. */
 }
+
+bool kfence_force_mapping(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long index = (addr - (unsigned long)__kfence_pool) >> PAGE_SHIFT;
+
+	if (!test_bit(index, kfence_protected_pages))
+		return true;
+
+	return kfence_protect_page(addr, false);
+}
+
+bool kfence_reset_mapping(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long index = (addr - (unsigned long)__kfence_pool) >> PAGE_SHIFT;
+
+	if (!test_bit(index, kfence_protected_pages))
+		return true;
+
+	return kfence_protect_page(addr, true);
+}
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

