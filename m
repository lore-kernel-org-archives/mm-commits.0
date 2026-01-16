Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4337230EF7B
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 22:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602520; cv=none; b=lmdAGK6hDe+kcRtlQDmJtQ10tNBfnPq2/ygQhSShEehE6eRyrHhfdnaxy8czHzA5BNQsbG2IR+rodc3YFDSOxZjiHUUcUWRwvWEGzuecYAu0aMfWUxHp5FClYKVqgnl9h5qgj+t3dxN5iOEb8zqgTihblXP80tAL/6oqGp+UtEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602520; c=relaxed/simple;
	bh=4uaVMPkkbyptkPwPapM1ar//G3cQ/SdQaIW7G+cxqnA=;
	h=Date:To:From:Subject:Message-Id; b=PnFgGPdvXJ85eRsvZhVcC6ORWR9Snkjuj08NvL/ljB65rDmdTWqks69p0CjF3HoRPMDTg2G8b/vGzXGaZwey6Sa5mYBMtqcpWL2ruqHv/GkKZFWmz81SUBPC0gQbjNUbB299zffuNyOKJJa5atOWWNFkUhDkKR6iINMVpdfVges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c+WYqxIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c+WYqxIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D96C116C6;
	Fri, 16 Jan 2026 22:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768602519;
	bh=4uaVMPkkbyptkPwPapM1ar//G3cQ/SdQaIW7G+cxqnA=;
	h=Date:To:From:Subject:From;
	b=c+WYqxIzfob6/RKdCIqypOvyuDFb9+eFN+FB1wXYvxUe0y8sHuleS+CVVRq7lC+dh
	 fjQZbhWajAooprLsFZYLBU8fgYl4M4Zi7DiBTRN90STYJL5MpSVbifQ8C7B2H2WF7Y
	 jLA38v+Fd5ZB1GT1Y/2s8su6gGwW/DtEQtOlb8ek=
Date: Fri, 16 Jan 2026 14:28:39 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-use-unsigned-long-for-nr_pages.patch added to mm-nonmm-unstable branch
Message-Id: <20260116222839.B9D96C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: use unsigned long for nr_pages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-use-unsigned-long-for-nr_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-use-unsigned-long-for-nr_pages.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: use unsigned long for nr_pages
Date: Fri, 16 Jan 2026 11:22:14 +0000

Patch series "kho: clean up page initialization logic", v2.

This series simplifies the page initialization logic in
kho_restore_page().  It was originally only a single patch [0], but on
Pasha's suggestion, I added another patch to use unsigned long for
nr_pages.

Technically speaking, the patches aren't related and can be applied
independently, but bundling them together since patch 2 relies on 1 and it
is easier to manage them this way.


This patch (of 2):

With 4k pages, a 32-bit nr_pages can span up to 16 TiB.  While it is a
lot, there exist systems with terabytes of RAM.  gup is also moving to
using long for nr_pages.  Use unsigned long and make KHO future-proof.

Link: https://lkml.kernel.org/r/20260116112217.915803-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260116112217.915803-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h     |    6 +++---
 kernel/liveupdate/kexec_handover.c |   11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/kexec_handover.h~kho-use-unsigned-long-for-nr_pages
+++ a/include/linux/kexec_handover.h
@@ -22,15 +22,15 @@ bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
-int kho_preserve_pages(struct page *page, unsigned int nr_pages);
-void kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
+int kho_preserve_pages(struct page *page, unsigned long nr_pages);
+void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
-struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
+struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
--- a/kernel/liveupdate/kexec_handover.c~kho-use-unsigned-long-for-nr_pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -219,7 +219,8 @@ static int __kho_preserve_order(struct k
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned int nr_pages, ref_cnt;
+	unsigned long nr_pages;
+	unsigned int ref_cnt;
 	union kho_page_info info;
 
 	if (!page)
@@ -246,7 +247,7 @@ static struct page *kho_restore_page(phy
 	 * count of 1
 	 */
 	ref_cnt = is_folio ? 0 : 1;
-	for (unsigned int i = 1; i < nr_pages; i++)
+	for (unsigned long i = 1; i < nr_pages; i++)
 		set_page_count(page + i, ref_cnt);
 
 	if (is_folio && info.order)
@@ -281,7 +282,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
  *
  * Return: 0 on success, error code on failure
  */
-struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
+struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 {
 	const unsigned long start_pfn = PHYS_PFN(phys);
 	const unsigned long end_pfn = start_pfn + nr_pages;
@@ -830,7 +831,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
  *
  * Return: 0 on success, error code on failure
  */
-int kho_preserve_pages(struct page *page, unsigned int nr_pages)
+int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 {
 	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
@@ -874,7 +875,7 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
  * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
  * preserved blocks is not supported.
  */
-void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)
 {
 	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-print-which-scratch-buffer-failed-to-be-reserved.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

