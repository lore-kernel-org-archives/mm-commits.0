Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F60431A069
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282373; cv=none; b=fdht/5dcUgvCQAWFTOZ/u5i8SmbNVqka1FFl7pdCpXvKlrlLNhWodfgWv93Hi74JnRYEynZc022UIq0A7dOTtDfBcYqCk83wpTNhHDFov+8p/yhbkj0yjYKZrr00KaygOpbZhAHw3ScJhAD5miso9tSMvPdA86EkpLoYW8GqJwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282373; c=relaxed/simple;
	bh=i+/kLe8+b32xPaHMDF6BsXNPpQ+Mw/zOOAOwQo9+6EI=;
	h=Date:To:From:Subject:Message-Id; b=F7spvyYQ6y1HkIi5645ZCw9tQGAnXnXeQ4SSxSw+gt1DoEisuLauUUhkh+jq4iAgrfAkLzRHSG3qdOKWs9isl0LrHEMSjEfR8eZ6uF+7IPVhQxvXlHCYM/4f7b0e9asK7IaHat3fDwDxjTSmdQyWr5EcZa1ria/ra19ZDJrUrDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HsS+vN7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HsS+vN7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2E1C4CEF8;
	Thu, 27 Nov 2025 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282373;
	bh=i+/kLe8+b32xPaHMDF6BsXNPpQ+Mw/zOOAOwQo9+6EI=;
	h=Date:To:From:Subject:From;
	b=HsS+vN7YUUzAYFA+n+KfQjN4wOWtRR3fKa6lBs0BqI1QigTWqcgORLXpB2wyZuOvo
	 gnABeYapIIddSN80mDscb7Ai/WXAaiu9gsVVx7MUXo9LsKxxHHcDH8vCrgFlxYKadL
	 cv54ybEplHKg7qp2mPdNWzN0WX0QgPts0RDOCIZI=
Date: Thu, 27 Nov 2025 14:26:12 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-introduce-high-level-memory-allocation-api.patch removed from -mm tree
Message-Id: <20251127222613.6B2E1C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: introduce high-level memory allocation API
has been removed from the -mm tree.  Its filename was
     kho-introduce-high-level-memory-allocation-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: introduce high-level memory allocation API
Date: Fri, 14 Nov 2025 13:59:52 -0500

Currently, clients of KHO must manually allocate memory (e.g., via
alloc_pages), calculate the page order, and explicitly call
kho_preserve_folio().  Similarly, cleanup requires separate calls to
unpreserve and free the memory.

Introduce a high-level API to streamline this common pattern:

- kho_alloc_preserve(size): Allocates physically contiguous, zeroed
  memory and immediately marks it for preservation.
- kho_unpreserve_free(ptr): Unpreserves and frees the memory
  in the current kernel.
- kho_restore_free(ptr): Restores the struct page state of
  preserved memory in the new kernel and immediately frees it to the
  page allocator.

[pasha.tatashin@soleen.com: build fixes]
  Link: https://lkml.kernel.org/r/CA+CK2bBgXDhrHwTVgxrw7YTQ-0=LgW0t66CwPCgG=C85ftz4zw@mail.gmail.com
Link: https://lkml.kernel.org/r/20251114190002.3311679-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h     |   22 ++++--
 kernel/liveupdate/kexec_handover.c |   87 +++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 7 deletions(-)

--- a/include/linux/kexec_handover.h~kho-introduce-high-level-memory-allocation-api
+++ a/include/linux/kexec_handover.h
@@ -2,8 +2,9 @@
 #ifndef LINUX_KEXEC_HANDOVER_H
 #define LINUX_KEXEC_HANDOVER_H
 
-#include <linux/types.h>
+#include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/types.h>
 
 struct kho_scratch {
 	phys_addr_t addr;
@@ -48,6 +49,9 @@ int kho_preserve_pages(struct page *page
 int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
+void *kho_alloc_preserve(size_t size);
+void kho_unpreserve_free(void *mem);
+void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
@@ -101,6 +105,14 @@ static inline int kho_unpreserve_vmalloc
 	return -EOPNOTSUPP;
 }
 
+static inline void *kho_alloc_preserve(size_t size)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void kho_unpreserve_free(void *mem) { }
+static inline void kho_restore_free(void *mem) { }
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
@@ -122,18 +134,14 @@ static inline int kho_add_subtree(const
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_remove_subtree(void *fdt)
-{
-}
+static inline void kho_remove_subtree(void *fdt) { }
 
 static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_memory_init(void)
-{
-}
+static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
--- a/kernel/liveupdate/kexec_handover.c~kho-introduce-high-level-memory-allocation-api
+++ a/kernel/liveupdate/kexec_handover.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 
 #define pr_fmt(fmt) "KHO: " fmt
@@ -1117,6 +1118,92 @@ err_free_pages_array:
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
+/**
+ * kho_alloc_preserve - Allocate, zero, and preserve memory.
+ * @size: The number of bytes to allocate.
+ *
+ * Allocates a physically contiguous block of zeroed pages that is large
+ * enough to hold @size bytes. The allocated memory is then registered with
+ * KHO for preservation across a kexec.
+ *
+ * Note: The actual allocated size will be rounded up to the nearest
+ * power-of-two page boundary.
+ *
+ * @return A virtual pointer to the allocated and preserved memory on success,
+ * or an ERR_PTR() encoded error on failure.
+ */
+void *kho_alloc_preserve(size_t size)
+{
+	struct folio *folio;
+	int order, ret;
+
+	if (!size)
+		return ERR_PTR(-EINVAL);
+
+	order = get_order(size);
+	if (order > MAX_PAGE_ORDER)
+		return ERR_PTR(-E2BIG);
+
+	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, order);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	ret = kho_preserve_folio(folio);
+	if (ret) {
+		folio_put(folio);
+		return ERR_PTR(ret);
+	}
+
+	return folio_address(folio);
+}
+EXPORT_SYMBOL_GPL(kho_alloc_preserve);
+
+/**
+ * kho_unpreserve_free - Unpreserve and free memory.
+ * @mem:  Pointer to the memory allocated by kho_alloc_preserve().
+ *
+ * Unregisters the memory from KHO preservation and frees the underlying
+ * pages back to the system. This function should be called to clean up
+ * memory allocated with kho_alloc_preserve().
+ */
+void kho_unpreserve_free(void *mem)
+{
+	struct folio *folio;
+
+	if (!mem)
+		return;
+
+	folio = virt_to_folio(mem);
+	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_free);
+
+/**
+ * kho_restore_free - Restore and free memory after kexec.
+ * @mem:  Pointer to the memory (in the new kernel's address space)
+ * that was allocated by the old kernel.
+ *
+ * This function is intended to be called in the new kernel (post-kexec)
+ * to take ownership of and free a memory region that was preserved by the
+ * old kernel using kho_alloc_preserve().
+ *
+ * It first restores the pages from KHO (using their physical address)
+ * and then frees the pages back to the new kernel's page allocator.
+ */
+void kho_restore_free(void *mem)
+{
+	struct folio *folio;
+
+	if (!mem)
+		return;
+
+	folio = kho_restore_folio(__pa(mem));
+	if (!WARN_ON(!folio))
+		folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(kho_restore_free);
+
 static void __kho_abort(void)
 {
 	if (kho_out.preserved_mem_map) {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

