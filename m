Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6377B31ED92
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282386; cv=none; b=bDbJROjt+Kwzpt29LjSvdvao4xqNiv1nzrODue7AWgZRwtwI2joxZYyGCA2/CjAm0suXnM+nFSIPy0YHW7unlHXTPE3OLqyY/VC2HDqFt/YmsXI8sbfdBPxHcgn9VsoGX4KtUbqmmWDpjpK9I7kxbONLXk4sdvZQBb1UAy8mLP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282386; c=relaxed/simple;
	bh=EAEsumQYAvRON307lStCnu0jx12cXWQFPPY7oE16YqQ=;
	h=Date:To:From:Subject:Message-Id; b=NDffVm1uvh6FM5t9lsi9G1ZcbT5T/yHaw4r7ayu/DcnZ9jo2T0WlH+ZvREsaAMe95PskSQWlJZHM3uM8cSA3lXjVqm40MihC1CJMIgrh4bP9Q6OTPLrCwyRf535xIVUItsUM8QOfLGHi1Wu04M9X3m35fVbnucDI6kRCqtKWvXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XI2h/7oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XI2h/7oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FC2C4CEF8;
	Thu, 27 Nov 2025 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282386;
	bh=EAEsumQYAvRON307lStCnu0jx12cXWQFPPY7oE16YqQ=;
	h=Date:To:From:Subject:From;
	b=XI2h/7oowyDU8xPf94PBuxB1kYDTnem7DFX9msT4W246o4kdUPoIQV7pxvJQhDFb7
	 dRd+fOBa0e3URqYvEqQSk1OzoNDJ17Ti0eglA6ZfcKtn+NkgfKNFIj2CrEtvqZsQaK
	 k2fpq5INuh4hsfun19bONI2x5bOBxdRIXMpBFDDQ=
Date: Thu, 27 Nov 2025 14:26:25 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-allow-memory-preservation-state-updates-after-finalization.patch removed from -mm tree
Message-Id: <20251127222626.36FC2C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: allow memory preservation state updates after finalization
has been removed from the -mm tree.  Its filename was
     kho-allow-memory-preservation-state-updates-after-finalization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 
 static inline void *kho_alloc_preserve(size_t size)
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

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

