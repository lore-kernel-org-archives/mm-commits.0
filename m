Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795147870;
	b=JJ5lUen+xpsdDN0s+XMmBORSsUFDughK9cDfqTg1362xD5msyZcxqWSUku7wq+tbLusB
	 QQUUL0b+Vaa9t7UqE6NTkyK7uay2gtM68FPoXbgwC3ojWmjL8/BQQnLD1ekw7/jrMUFT2
	 0LVJ89RC4n9cHviQkO7Zq5E2ThM+a51OI/9HtZMeUxz94a/G5bxWGN7fahQybJ5Vr/Dzm
	 +279zxDkvmQztutNeEDBouku851K4cjf0fn+U7pVuJ+LF3sjSc+YA8S1s5gJC1AYFcUo1
	 khOrewBYvKRmVev3/EJpogRGhb5RvBySWJpx5XvpHq0dRAfGP+wY/NxgSt8/p4zJAqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795147870;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=1IayqUlBBl7GozK+cOaIuoHW1MeEwDtE8Tt2k8ichKc=;
	b=IJxyI7KQWK2RUxJDtODUpTpBfIwBKXvF9Mwb244nuFXPNFqVm7uOLERpK1nzjV4fLZmd
	 9PpYxVdmOXC2bla2x+gJI1AmDYQ2tFpU1GH8luA3zJBPonSjVQFJYcLO+d+nOw/v2HvqQ
	 kRNFekE5zVDnMtWAH4PQZHzb4AChfXrugEqHgkZo+gtNRBmf2XSAXts1cJ+Ma8jQgTJXQ
	 08Mz9MMF4gzlZO23DA9DEUHXPmj37gPLMpuMzrIQOvXmbGqi8FaXg80+cZouFPpZ9eMnE
	 DsXSs4nls68iKHfWdq8EZcDz1ZjTefcSdR37NHjiY4gedm+9sUMYVr8rafRG0CEmS8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tdtyA5QX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA4E606A325
	for <mm-commits@vger.kernel.org>; Fri, 20 Nov 2026 04:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tdtyA5QX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB00E1F000C4;
	Fri, 20 Nov 2026 04:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795147869;
	bh=1IayqUlBBl7GozK+cOaIuoHW1MeEwDtE8Tt2k8ichKc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=tdtyA5QXJ3Ia7Ke3vG+jcVjl9LLUj8v9ARnuJ568VdUS2CzIZC6P37r1PH3zqA1Fc
	 au4aoV/rnBtZkX8d3vGCKDe7ZBnZitxqRa3g7CzRm9xlBVGtUS7+Ut6n+1jO6RxYbi
	 QwT0CWWECuI26RH46S020B3jul0s/xTlBFSuks3c=
Date: Thu, 19 Nov 2026 20:11:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zenghui.yu@linux.dev,
	surenb@google.com,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,nilayvaish@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119233119.1721789-1-nilayvaish@google.com>
References: <20261119233119.1721789-1-nilayvaish@google.com>
Subject: + lib-test_hmm-fix-alloc-tag-leak-when-splitting-device-private-folios.patch added to mm-new branch
Message-Id: <20261120041109.BB00E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/test_hmm: fix alloc tag leak when splitting device-private folios
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-fix-alloc-tag-leak-when-splitting-device-private-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-fix-alloc-tag-leak-when-splitting-device-private-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Nilay Vaish <nilayvaish@google.com>
Subject: lib/test_hmm: fix alloc tag leak when splitting device-private folios
Date: Thu, 19 Nov 2026 15:31:19 -0800

For device-private memory, test_hmm backs each fake device folio with real
system RAM of the same order, allocated with folio_alloc() in
dmirror_devmem_alloc_page().

When the core MM splits a large device-private folio, the driver's
->folio_split() callback, dmirror_devmem_folio_split(), has to split the
backing memory as well.  It does that by hand: clear_compound_head() on
the tail pages, folio_reset_order() on the head page, and
folio_set_count() on each of them.  dmirror_devmem_free() then frees every
backing page as an order-0 page.

This open-coded split does not split the allocator's metadata.  The
allocation tag and the page_owner record still describe one high-order
allocation, and PG_head stays set on the head page.  When the pages are
freed one by one, the tag is debited for only one page when the head is
freed, and the tail pages carry no tag at all.  With
CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading the
module reports the leak:

  lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page has 16744448 allocated at module unload

and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0

The backing memory is a private buffer of the test driver and nothing
requires it to be a folio.  Allocate it with alloc_pages() instead and
split it right away with split_page(), which splits the allocation tag,
page_owner and memcg state and is already exported to modules.  It is
still allocated as one high-order block rather than as individual order-0
pages because the driver finds the backing page of the Nth page of a
device folio by offsetting from the first backing page, so the backing
pages have to be physically contiguous.  Every backing page is then an
independent order-0 page for its whole lifetime, so
dmirror_devmem_folio_split() only has to point the new device folio at its
backing page, and dmirror_devmem_free() frees the backing pages one at a
time.

As the backing pages no longer form a folio, take the order from the
device folio rather than from the backing page, and index and copy the
backing pages individually instead of using folio_page() and folio_copy().

With this patch the device-private HMM selftests pass and the module
unloads without the messages above.

Link: https://patch.msgid.link/20261119233119.1721789-1-nilayvaish@google.com
Fixes: 56ef39899643 ("mm/memremap: add driver callback support for folio splitting")
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/linux-mm/8ef6e92d-4cb3-444e-857e-fdbf88c035ea@kernel.org/
Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
  Link: https://lore.kernel.org/aa414751-9913-43ac-9782-aa9043b77517@linux.dev
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>

 lib/test_hmm.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-alloc-tag-leak-when-splitting-device-private-folios
+++ a/lib/test_hmm.c
@@ -201,6 +201,7 @@ static void dmirror_device_evict_chunk(s
 	migrate_device_range(src_pfns, start_pfn, npages);
 	for (i = 0; i < npages; i++) {
 		struct page *dpage, *spage;
+		unsigned int j;
 
 		spage = migrate_pfn_to_page(src_pfns[i]);
 		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
@@ -227,7 +228,8 @@ static void dmirror_device_evict_chunk(s
 			dst_pfns[i] |= MIGRATE_PFN_WRITE;
 		if (order)
 			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
-		folio_copy(page_folio(dpage), page_folio(spage));
+		for (j = 0; j < (1U << order); j++)
+			copy_highpage(dpage + j, spage + j);
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
@@ -805,7 +807,7 @@ static struct page *dmirror_devmem_alloc
 	 * data and ignore rpage.
 	 */
 	if (dmirror_is_private_zone(mdevice)) {
-		rpage = folio_page(folio_alloc(GFP_HIGHUSER, order), 0);
+		rpage = alloc_pages(GFP_HIGHUSER, order);
 		if (!rpage)
 			return NULL;
 	}
@@ -827,6 +829,9 @@ static struct page *dmirror_devmem_alloc
 			goto error;
 	}
 
+	if (rpage && order)
+		split_page(rpage, order);
+
 	zone_device_folio_init(page_folio(dpage),
 			       page_pgmap(folio_page(page_folio(dpage), 0)),
 			       order);
@@ -1029,10 +1034,9 @@ static int dmirror_migrate_finalize_and_
 		WARN_ON_ONCE(end_pfn < start_pfn + nr);
 
 		rpage = BACKING_PAGE(dpage);
-		VM_WARN_ON(folio_nr_pages(page_folio(rpage)) != nr);
 
 		for (i = 0; i < nr; i++) {
-			entry = folio_page(page_folio(rpage), i);
+			entry = rpage + i;
 			if (*dst & MIGRATE_PFN_WRITE)
 				entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
 			entry = xa_store(&dmirror->pt, pfn + i, entry, GFP_ATOMIC);
@@ -1130,8 +1134,8 @@ static vm_fault_t dmirror_devmem_fault_a
 			goto next;
 		}
 
-		spage = BACKING_PAGE(spage);
 		order = folio_order(page_folio(spage));
+		spage = BACKING_PAGE(spage);
 		if (order)
 			*dst = MIGRATE_PFN_COMPOUND;
 		if (*src & MIGRATE_PFN_WRITE)
@@ -1724,14 +1728,12 @@ static void dmirror_devmem_free(struct f
 	struct page *page = &folio->page;
 	struct page *rpage = BACKING_PAGE(page);
 	struct dmirror_device *mdevice;
-	struct folio *rfolio = page_folio(rpage);
-	unsigned int order = folio_order(rfolio);
+	unsigned int order = folio_order(folio);
+	unsigned int i;
 
 	if (rpage != page) {
-		if (order)
-			__free_pages(rpage, order);
-		else
-			__free_page(rpage);
+		for (i = 0; i < (1U << order); i++)
+			__free_page(rpage + i);
 		rpage = NULL;
 	}
 
@@ -1835,34 +1837,24 @@ static void dmirror_devmem_folio_split(s
 {
 	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
 	struct page *rpage_tail;
-	struct folio *rfolio;
-	unsigned long offset = 0;
+	unsigned long offset;
 
 	if (!rpage) {
 		tail->page.zone_device_data = NULL;
 		return;
 	}
 
-	rfolio = page_folio(rpage);
-
-	if (tail == NULL) {
-		folio_reset_order(rfolio);
-		rfolio->mapping = NULL;
-		folio_set_count(rfolio, 1);
+	if (!tail)
 		return;
-	}
 
 	offset = folio_pfn(tail) - folio_pfn(head);
 
-	rpage_tail = folio_page(rfolio, offset);
+	rpage_tail = rpage + offset;
 	tail->page.zone_device_data = rpage_tail;
 	rpage_tail->zone_device_data = rpage->zone_device_data;
-	clear_compound_head(rpage_tail);
-	rpage_tail->mapping = NULL;
 
 	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
 	tail->pgmap = head->pgmap;
-	folio_set_count(page_folio(rpage_tail), 1);
 }
 
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
_

Patches currently in -mm which might be from nilayvaish@google.com are

lib-test_hmm-fix-alloc-tag-leak-when-splitting-device-private-folios.patch

