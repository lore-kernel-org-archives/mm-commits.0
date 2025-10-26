Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34544502F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451593; cv=none; b=IO7BK3KcclLYADOI8q4sFYf//RsjRB66tBiFsa4ul+BS6MKun0r0mpZpX8Jd91pb6PnE2R6WxaSwziiz0GJFLHJICVb8nXBYhdGF3PuuqrN93l6JefuXYx9OSaADrHbJ7HE9lH5cbHonfP9mSJ2F/HHHUnEMy4HXLbfImYuLcO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451593; c=relaxed/simple;
	bh=MP3NoTmeuyySwLvEZCDVLeEVrcbpDVzTuZF7n01YSSI=;
	h=Date:To:From:Subject:Message-Id; b=KZQdTTbCzmpqs1APKGVRw3bpELVaRknDo2CaoFd/8jMiUfqmKBCPpr+pcK7JUlm5okB7CfIwprm7ko/NKuUNgiV5Y3bQGaHCFGnuxM1dkYF/FM3HXFYhD+7UYYfWoY21u8llH6ksBedR3p9Z4tw3wuI8d6vJJpLI4UrNiO/nGD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Az+pYEK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Az+pYEK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAEBC4CEE7;
	Sun, 26 Oct 2025 04:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761451592;
	bh=MP3NoTmeuyySwLvEZCDVLeEVrcbpDVzTuZF7n01YSSI=;
	h=Date:To:From:Subject:From;
	b=Az+pYEK0eHhqWGdmyv3hKaXtdSxkzlnNfn3a1eJMUZr7j471v70JXodPxefKwhwjp
	 FurU6U9mPZXzTzzfkawMbTY6WNi314XisqZutqV3g3VQxuoNe70iN77co0oHLAtgsX
	 N3EV9qESlstWtPgLByRMt0l+gQb/bNM7Gas10Zv0=
Date: Sat, 25 Oct 2025 21:06:31 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-interfaces-to-unpreserve-folios-and-page-ranges.patch added to mm-nonmm-unstable branch
Message-Id: <20251026040632.5BAEBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: add interfaces to unpreserve folios and page ranges
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-add-interfaces-to-unpreserve-folios-and-page-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-interfaces-to-unpreserve-folios-and-page-ranges.patch

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
Subject: kho: add interfaces to unpreserve folios and page ranges
Date: Fri, 24 Oct 2025 12:09:58 -0400

Allow users of KHO to cancel the previous preservation by adding the
necessary interfaces to unpreserve folio and pages.

Link: https://lkml.kernel.org/r/20251024161002.747372-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |   12 ++++
 kernel/kexec_handover.c        |   84 ++++++++++++++++++++++++++-----
 2 files changed, 83 insertions(+), 13 deletions(-)

--- a/include/linux/kexec_handover.h~kho-add-interfaces-to-unpreserve-folios-and-page-ranges
+++ a/include/linux/kexec_handover.h
@@ -43,7 +43,9 @@ bool kho_is_enabled(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
+int kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
+int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
@@ -76,10 +78,20 @@ static inline int kho_preserve_folio(str
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_folio(struct folio *folio)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+{
+	return -EOPNOTSUPP;
+}
 
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
--- a/kernel/kexec_handover.c~kho-add-interfaces-to-unpreserve-folios-and-page-ranges
+++ a/kernel/kexec_handover.c
@@ -157,26 +157,33 @@ static void *xa_load_or_alloc(struct xar
 	return no_free_ptr(elm);
 }
 
-static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
-			     unsigned long end_pfn)
+static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
+				   unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
 	struct kho_mem_phys *physxa;
+	const unsigned long pfn_high = pfn >> order;
 
-	while (pfn < end_pfn) {
-		const unsigned int order =
-			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		const unsigned long pfn_high = pfn >> order;
+	physxa = xa_load(&track->orders, order);
+	if (!physxa)
+		return;
+
+	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
+	if (!bits)
+		return;
 
-		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+}
+
+static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
+			     unsigned long end_pfn)
+{
+	unsigned int order;
 
-		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+	while (pfn < end_pfn) {
+		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+		__kho_unpreserve_order(track, pfn, order);
 
 		pfn += 1 << order;
 	}
@@ -746,6 +753,30 @@ int kho_preserve_folio(struct folio *fol
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
 /**
+ * kho_unpreserve_folio - unpreserve a folio.
+ * @folio: folio to unpreserve.
+ *
+ * Instructs KHO to unpreserve a folio that was preserved by
+ * kho_preserve_folio() before. The provided @folio (pfn and order)
+ * must exactly match a previously preserved folio.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_folio(struct folio *folio)
+{
+	const unsigned long pfn = folio_pfn(folio);
+	const unsigned int order = folio_order(folio);
+	struct kho_mem_track *track = &kho_out.track;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	__kho_unpreserve_order(track, pfn, order);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
+
+/**
  * kho_preserve_pages - preserve contiguous pages across kexec
  * @page: first page in the list.
  * @nr_pages: number of pages.
@@ -789,6 +820,33 @@ int kho_preserve_pages(struct page *page
 }
 EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
+/**
+ * kho_unpreserve_pages - unpreserve contiguous pages.
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
+ *
+ * Instructs KHO to unpreserve @nr_pages contiguous pages starting from @page.
+ * This must be called with the same @page and @nr_pages as the corresponding
+ * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
+ * preserved blocks is not supported.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+{
+	struct kho_mem_track *track = &kho_out.track;
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	__kho_unpreserve(track, start_pfn, end_pfn);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
+
 struct kho_vmalloc_hdr {
 	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
 };
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranges.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-kho-debugfs-directory-to-liveupdate.patch
memblock-unpreserve-memory-in-case-of-error.patch

