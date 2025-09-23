Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BEA2836A4
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663048; cv=none; b=DAahsKaJgvqnKQrUy/Dl58DY8IwRgCv5OEKj6P7v4qQWKbRS3Zi/6ZOovj1ghAhtxXQ8AVKJsMIy7SCRQhR5d15nCu2+xBuw6NZhp07SOOd8yVyAJxRQkt6Lm6c3qzZtdRhJV/ubhIuxXLLpRmzC9FFetAFUwuSwgl0kXv8uBKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663048; c=relaxed/simple;
	bh=5YWO5H4vc3TNUuQ5GgJuNv/kt6fzPxcA03MKIVs8fG4=;
	h=Date:To:From:Subject:Message-Id; b=oBo+zKLWlKulUSgKIGqANPQHRutDaHIDMfZ7jySwK95Vfwy4DWJj4RXyuif8bLI0EAcPsPxHSeZNdOu+sUfE3fIqD0p2TwGskkPnv8QZ/xp71JcVfGes0FruUjnR0wtU62UKmbhQsXHav6Wjn+g5VW1/CcazcKCFsscFmK8FjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WIYvcZMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WIYvcZMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F35CC4CEF5;
	Tue, 23 Sep 2025 21:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758663048;
	bh=5YWO5H4vc3TNUuQ5GgJuNv/kt6fzPxcA03MKIVs8fG4=;
	h=Date:To:From:Subject:From;
	b=WIYvcZMx8IaennUM6Z+hoLCwxsb1X3JpvgvvtSmukfmzaAzqCeBqJ93PLXwcSG/5F
	 FO+YxHLv226ZaoTNia4kv0URaNtYHm703pvkamBhGkaW8/Rmbab3eqHGaoW+xz8/Os
	 8kYtjt5ny4wZod8P+zi3UrZkfA/1JvNTcx6m+uhs=
Date: Tue, 23 Sep 2025 14:30:47 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-map-entire-large-folio-faultaround.patch added to mm-unstable branch
Message-Id: <20250923213048.0F35CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: map entire large folio faultaround
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-map-entire-large-folio-faultaround.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-map-entire-large-folio-faultaround.patch

This patch will later appear in the mm-unstable branch at
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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/filemap: map entire large folio faultaround
Date: Tue, 23 Sep 2025 12:07:10 +0100

Currently, kernel only maps part of large folio that fits into
start_pgoff/end_pgoff range.

Map entire folio where possible.  It will match finish_fault() behaviour
that user hits on cold page cache.

Mapping large folios at once will allow the rmap code to mlock it on add,
as it will recognize that it is fully mapped and mlocking is safe.

Link: https://lkml.kernel.org/r/20250923110711.690639-6-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/filemap.c~mm-filemap-map-entire-large-folio-faultaround
+++ a/mm/filemap.c
@@ -3670,6 +3670,21 @@ static vm_fault_t filemap_map_folio_rang
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
 	pte_t *old_ptep = vmf->pte;
+	unsigned long addr0;
+
+	/*
+	 * Map the large folio fully where possible.
+	 *
+	 * The folio must not cross VMA or page table boundary.
+	 */
+	addr0 = addr - start * PAGE_SIZE;
+	if (folio_within_vma(folio, vmf->vma) &&
+	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
+		vmf->pte -= start;
+		page -= start;
+		addr = addr0;
+		nr_pages = folio_nr_pages(folio);
+	}
 
 	do {
 		if (PageHWPoison(page + count))
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-filemap-map-entire-large-folio-faultaround.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

