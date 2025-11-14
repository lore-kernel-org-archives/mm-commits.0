Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B8D35BDDA
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156139; cv=none; b=gT+kwR8L/AqBGSOBPTrRVV7sb7EUn73uFrnDNO297uDI8s4y+VJ/U8bMb54WzXtWR2FChT10sjWZRVJ0B4zgCAnDVf6oqZFXtIOR1bdWXUyOgw6hG7FDRTHNVrtPuaWG8qdY7FcKOvDFWcUMeXk60/oZsbnBk79wqlXy58Qyqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156139; c=relaxed/simple;
	bh=WAdjyK3eMmZaniAQy65eTpm+lap3fyooFXvcpRgIEGs=;
	h=Date:To:From:Subject:Message-Id; b=PTbjO4BEuXfxW2g1Q+mnpRZrByxp/2RXOMIIVZjz2lRxUBUhk3kjdE1KyvN7e9SooyuAr9GoYVbRK7J588AF4aXFzpu+gXm2sEhdF86dCP+S2rhJQ6HNKobTc8E0lIT4sUy2Iz4K9b/Tj8xufAJFqSPhJpQUN1Tnk7flnmklsyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdbBt13C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdbBt13C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D505EC116D0;
	Fri, 14 Nov 2025 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156138;
	bh=WAdjyK3eMmZaniAQy65eTpm+lap3fyooFXvcpRgIEGs=;
	h=Date:To:From:Subject:From;
	b=gdbBt13CkCewobwsHr9Ux+OsVze47oqfzxxCj8Es7TJwEz8Rl0dv6maiMD0D8LfoU
	 EBmJ2ekd5ITTdK2g03vAfDn6qnJY40BW9gwGxnTEWV+JAD0tL7FLpeTgzT0fBZeYKY
	 Vekspun7MC9XT4YOnXoUNUkaverDvEd/CYMe8dso=
Date: Fri, 14 Nov 2025 13:35:38 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-allow-memory-preservation-state-updates-after-finalization.patch added to mm-nonmm-unstable branch
Message-Id: <20251114213538.D505EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: allow memory preservation state updates after finalization
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-allow-memory-preservation-state-updates-after-finalization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-allow-memory-preservation-state-updates-after-finalization.patch

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
Subject: kho: allow memory preservation state updates after finalization
Date: Fri, 14 Nov 2025 14:00:01 -0500

Currently, kho_preserve_* and kho_unpreserve_* return -EBUSY if KHO is
finalized.  This enforces a rigid "freeze" on the KHO memory state.

With the introduction of re-entrant finalization, this restriction is no
longer necessary.  Users should be allowed to modify the preservation set
(e.g., adding new pages or freeing old ones) even after an initial
finalization.

The intended workflow for updates is now:
1. Modify state (preserve/unpreserve).
2. Call kho_finalize() again to refresh the serialized metadata.

Remove the kho_out.finalized checks to enable this dynamic behavior.

This also allows to convert kho_unpreserve_* functions to void, as they do
not return any error anymore.

Link: https://lkml.kernel.org/r/20251114190002.3311679-13-pasha.tatashin@soleen.com
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

 include/linux/kexec_handover.h     |   21 ++--------
 kernel/liveupdate/kexec_handover.c |   55 ++++++---------------------
 2 files changed, 19 insertions(+), 57 deletions(-)

--- a/include/linux/kexec_handover.h~kho-allow-memory-preservation-state-updates-after-finalization
+++ a/include/linux/kexec_handover.h
@@ -44,11 +44,11 @@ bool kho_is_enabled(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
-int kho_unpreserve_folio(struct folio *folio);
+void kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
-int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
+void kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
-int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
+void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
@@ -79,20 +79,14 @@ static inline int kho_preserve_folio(str
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_unpreserve_folio(struct folio *folio)
-{
-	return -EOPNOTSUPP;
-}
+static inline void kho_unpreserve_folio(struct folio *folio) { }
 
 static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
-{
-	return -EOPNOTSUPP;
-}
+static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
@@ -100,10 +94,7 @@ static inline int kho_preserve_vmalloc(v
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
-{
-	return -EOPNOTSUPP;
-}
+static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation) { }
 
 void *kho_alloc_preserve(size_t size)
 {
--- a/kernel/liveupdate/kexec_handover.c~kho-allow-memory-preservation-state-updates-after-finalization
+++ a/kernel/liveupdate/kexec_handover.c
@@ -185,10 +185,6 @@ static int __kho_preserve_order(struct k
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
-
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -807,20 +803,14 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
  * Instructs KHO to unpreserve a folio that was preserved by
  * kho_preserve_folio() before. The provided @folio (pfn and order)
  * must exactly match a previously preserved folio.
- *
- * Return: 0 on success, error code on failure
  */
-int kho_unpreserve_folio(struct folio *folio)
+void kho_unpreserve_folio(struct folio *folio)
 {
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	__kho_unpreserve_order(track, pfn, order);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -877,21 +867,14 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
  * This must be called with the same @page and @nr_pages as the corresponding
  * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
  * preserved blocks is not supported.
- *
- * Return: 0 on success, error code on failure
  */
-int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
 {
 	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	__kho_unpreserve(track, start_pfn, end_pfn);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
@@ -976,20 +959,6 @@ static void kho_vmalloc_unpreserve_chunk
 	}
 }
 
-static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
-{
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
-
-	while (chunk) {
-		struct kho_vmalloc_chunk *tmp = chunk;
-
-		kho_vmalloc_unpreserve_chunk(chunk, kho_vmalloc->order);
-
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		free_page((unsigned long)tmp);
-	}
-}
-
 /**
  * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
  * @ptr: pointer to the area in vmalloc address space
@@ -1051,7 +1020,7 @@ int kho_preserve_vmalloc(void *ptr, stru
 	return 0;
 
 err_free:
-	kho_vmalloc_free_chunks(preservation);
+	kho_unpreserve_vmalloc(preservation);
 	return err;
 }
 EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
@@ -1062,17 +1031,19 @@ EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
  *
  * Instructs KHO to unpreserve the area in vmalloc address space that was
  * previously preserved with kho_preserve_vmalloc().
- *
- * Return: 0 on success, error code on failure
  */
-int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
+void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
 {
-	if (kho_out.finalized)
-		return -EBUSY;
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
 
-	kho_vmalloc_free_chunks(preservation);
+	while (chunk) {
+		struct kho_vmalloc_chunk *tmp = chunk;
 
-	return 0;
+		kho_vmalloc_unpreserve_chunk(chunk, preservation->order);
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		free_page((unsigned long)tmp);
+	}
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
 
@@ -1221,7 +1192,7 @@ void kho_unpreserve_free(void *mem)
 		return;
 
 	folio = virt_to_folio(mem);
-	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	kho_unpreserve_folio(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_free);
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

