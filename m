Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536B32FC017
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156113; cv=none; b=F53xw2VzBTT6SMG8dZ7byfxPYHnnCghaxF4hLAzHRZ0idiDBd+RSbghNAuifPqWdqUWgKaW41fQ8XpxigXRNBzRvMYdv9SXz+d+gW673roc3D5cfeuvFaqquLggIHkewSIO+XXpm4NS4LZktMp0yT0AZVG+EKOf85c9Rtc82PKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156113; c=relaxed/simple;
	bh=wNsZcfxlbP0J1zY4zJJuADRZcqx9a32bc6izN+smDmk=;
	h=Date:To:From:Subject:Message-Id; b=iWIP213rXM/kV88SD/r08Kt+BoKO0eqhuqrizFq505MtwoSKLI1I4Y7HIVhh6Wg8WZXZhw9D1s3DWAM++dEw45+1+PiXylw+wNoWrmIH0ZUtcsousDCan7HeurGnuKdf+Zk9cHiC0vhjS8H4/SF8mheTrNZMbFTxX0z//daU7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ut9j9UpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ut9j9UpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF28C4CEF1;
	Fri, 14 Nov 2025 21:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156112;
	bh=wNsZcfxlbP0J1zY4zJJuADRZcqx9a32bc6izN+smDmk=;
	h=Date:To:From:Subject:From;
	b=Ut9j9UpSRekKZzk6f1YsxM5PEVNXuS7djLqX8x/rjfm+eoftmaMFTYR3VW6kRVQrB
	 NZsKN53VxE8NMWPoKo2BsNBGA+bSJZmWym8n2oPRSU33WG7RVeU527B0dkU0i+jpxH
	 PREtU1n7IHoyX4rImZsW9KqOH/GPmj4JYOsuwyQo=
Date: Fri, 14 Nov 2025 13:35:11 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-introduce-high-level-memory-allocation-api.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213512.CBF28C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: introduce high-level memory allocation API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-introduce-high-level-memory-allocation-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-introduce-high-level-memory-allocation-api.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
 
+void *kho_alloc_preserve(size_t size)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+void kho_unpreserve_free(void *mem) { }
+void kho_restore_free(void *mem) { }
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

lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-preserve-fdt-folio-only-once-during-initialization.patch
kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch
kho-always-expose-output-fdt-in-debugfs.patch
kho-simplify-serialization-and-remove-__kho_abort.patch
kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch
kho-remove-abort-functionality-and-support-state-refresh.patch
kho-update-fdt-dynamically-for-subtree-addition-removal.patch
kho-allow-kexec-load-before-kho-finalization.patch
kho-allow-memory-preservation-state-updates-after-finalization.patch
kho-add-kconfig-option-to-enable-kho-by-default.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

