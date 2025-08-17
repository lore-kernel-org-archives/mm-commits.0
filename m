Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AE61A23B6
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456874; cv=none; b=MsbK4steFxgBkBb1y4kSIrE5P7EIGELmwbpKyfh/3aICcKB9MngybQuT7/82h0+xiPjd+nXT4mg8ii0+fSUVsiHhQATGkD92GMxAgPGN24hbMtfO+a0fZ7JeUFQJa7dBu+D+J84Xlz7483osAf99x1+NROlri5+d/2f6vOATZX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456874; c=relaxed/simple;
	bh=A8bGweWGMk1BTxSePk4oYVEku6P2ZNbP5UBeIrQOcrs=;
	h=Date:To:From:Subject:Message-Id; b=qky+j/wJuZLSJtDBuNzm6Vbq6wypUJ7ys3m1/q9nMAGyJpEibW57zso9MYo3uPp6tb+UvinzdzSTAUwpE+p6tIMSx6VGwHwFwmiODyyDYPKt1zRQrh+6EYpmRiQ62HBAsTdRcXYUdrNZguE38N3OOqpm+f8NLLLuYa3mq2HZRXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njvHeSRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njvHeSRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E34C4CEEB;
	Sun, 17 Aug 2025 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456873;
	bh=A8bGweWGMk1BTxSePk4oYVEku6P2ZNbP5UBeIrQOcrs=;
	h=Date:To:From:Subject:From;
	b=njvHeSRqGCzqZF/mDVrFWsCbetn0ei6vumfOGiyMDZdct5P0vQLtuBhMcoUm8LF+e
	 ccHS99RJ0kIgfDZ1UbVycww0KzzD/q+LiElLqph3PpL9JNOsmUpvvgBNIbJoznokoQ
	 5AtMd7bcFTo72znJzJqzUtbIcnky4rvIVZGYjDWI=
Date: Sun, 17 Aug 2025 11:54:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-memdesc_nid.patch added to mm-new branch
Message-Id: <20250817185433.D5E34C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce memdesc_nid()
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-memdesc_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-memdesc_nid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: introduce memdesc_nid()
Date: Tue, 5 Aug 2025 18:22:53 +0100

Remove a conversion from folio to page by passing the folio->flags (which
are a copy of the page->flags) to the new memdesc_nid() function.

Link: https://lkml.kernel.org/r/20250805172307.1302730-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++++++++++--------
 mm/sparse.c        |    6 +++---
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-introduce-memdesc_nid
+++ a/include/linux/mm.h
@@ -1558,17 +1558,22 @@ static inline int page_zone_id(struct pa
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-int page_to_nid(const struct page *page);
+int memdesc_nid(memdesc_flags_t mdf);
 #else
-static inline int page_to_nid(const struct page *page)
+static inline int memdesc_nid(memdesc_flags_t mdf)
 {
-	return (PF_POISONED_CHECK(page)->flags.f >> NODES_PGSHIFT) & NODES_MASK;
+	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
+static inline int page_to_nid(const struct page *page)
+{
+	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+}
+
 static inline int folio_nid(const struct folio *folio)
 {
-	return page_to_nid(&folio->page);
+	return memdesc_nid(folio->flags);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -1791,14 +1796,14 @@ static inline pg_data_t *page_pgdat(cons
 	return NODE_DATA(page_to_nid(page));
 }
 
-static inline struct zone *folio_zone(const struct folio *folio)
+static inline pg_data_t *folio_pgdat(const struct folio *folio)
 {
-	return page_zone(&folio->page);
+	return NODE_DATA(folio_nid(folio));
 }
 
-static inline pg_data_t *folio_pgdat(const struct folio *folio)
+static inline struct zone *folio_zone(const struct folio *folio)
 {
-	return page_pgdat(&folio->page);
+	return &folio_pgdat(folio)->node_zones[folio_zonenum(folio)];
 }
 
 #ifdef SECTION_IN_PAGE_FLAGS
--- a/mm/sparse.c~mm-introduce-memdesc_nid
+++ a/mm/sparse.c
@@ -43,11 +43,11 @@ static u8 section_to_node_table[NR_MEM_S
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
-int page_to_nid(const struct page *page)
+int memdesc_nid(memdesc_flags_t mdf)
 {
-	return section_to_node_table[memdesc_section(page->flags)];
+	return section_to_node_table[memdesc_section(mdf)];
 }
-EXPORT_SYMBOL(page_to_nid);
+EXPORT_SYMBOL(memdesc_nid);
 
 static void set_section_nid(unsigned long section_nr, int nid)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch

