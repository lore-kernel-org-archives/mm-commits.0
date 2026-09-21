Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ECC146D5A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963780; cv=none; b=oxPQTl0wcL7y6rVo+DqWI/Xi/Ub/KlFrhafoJQBptFqiXWEXZONlX0d777mN6j1mAjGn8kFEd+81lfSYrsQAlAIBXV3k4XqNlbCKYnj1UfiQGkGTVKKNa2tOswVpSP5Of6FB6ijL/m+XT/TcTd5Z7Nk2nTLG4vdP2+kMDpfrK2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963780; c=relaxed/simple;
	bh=uhCVX8T2W0/Pe7dIxiBuGi9xyW5goiPEDuDC5E83Ljw=;
	h=Date:To:From:Subject:Message-Id; b=n+Qb+PKv8PCrutVi7nHj/+XTFUdPgeSsw2cpkrWM65WlkoTiD9Rl7xchGD3lfZVsayAUhxYiYu2NS2J9yc9pxR9/VoxpGwZ+lwGbDG39sc7LcipzeLncKqdHLCJphD2RNmWZxV2riG/rXES89JEzsjKri1uQjQMcDBBpYyxoYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wW8pZB0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wW8pZB0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87341F000FF;
	Mon, 21 Sep 2026 04:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963779;
	bh=0WWt3n3s6wHEfPHHonHiWv3CoFRGMV2bEXHEGuIniPo=;
	h=Date:To:From:Subject;
	b=wW8pZB0tXAU1e88XvSsIxzdlgR0SpkIIwS/jOEZbSp41TK24i6bX/3MPVm962zKRd
	 j9pqjRSD+Sae0yKGw5L3ph3AiGwIOEti9/BhA8VMdTpz3nq+8NLj67zpxJXuJqqGO3
	 QGRmySx3iwCXgqgbtka5bdeMsbHRh0t0XL/UlLzo=
Date: Sun, 20 Sep 2026 21:09:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch added to mm-unstable branch
Message-Id: <20260921040938.D87341F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xen/grant-table: stop setting PG_private on pages for grant mapping
has been added to the -mm mm-unstable branch.  Its filename is
     xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch

This patch will later appear in the mm-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: xen/grant-table: stop setting PG_private on pages for grant mapping
Date: Sun, 20 Sep 2026 22:27:59 -0400

gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
pointer to an allocated xen_page_foreign is stored; on 64-bit,
xen_page_forCcgn is stored inline. Checking page->private != NULL is enough
to tell whether a xen_page_foreign needs to be freed on 32-bit and
page->private is zeroed unconditionally on 64-bit.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-3-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
---

 drivers/xen/grant-table.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/xen/grant-table.c~xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping
+++ a/drivers/xen/grant-table.c
@@ -863,10 +863,10 @@ EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_
 
 int gnttab_pages_set_private(int nr_pages, struct page **pages)
 {
+#if BITS_PER_LONG < 64
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-#if BITS_PER_LONG < 64
 		struct xen_page_foreign *foreign;
 
 		foreign = kzalloc_obj(*foreign);
@@ -874,9 +874,9 @@ int gnttab_pages_set_private(int nr_page
 			return -ENOMEM;
 
 		set_page_private(pages[i], (unsigned long)foreign);
-#endif
-		SetPagePrivate(pages[i]);
 	}
+#endif
+	/* Data is stored in page->private on 64-bit */
 
 	return 0;
 }
@@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_p
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-		if (PagePrivate(pages[i])) {
 #if BITS_PER_LONG < 64
+		if (page_private(pages[i]))
 			kfree((void *)page_private(pages[i]));
 #endif
-			ClearPagePrivate(pages[i]);
-		}
+		set_page_private(pages[i], 0);
 	}
 }
 EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

