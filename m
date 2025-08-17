Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA611A23B6
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456871; cv=none; b=HC6F9Pl4xy6zvV9MgBpquz/Xz0FC5IHWADPgyIlqk8z27SfFJIx/jxpgBQIEgise5fW18LTPAjOiLlWUdPFVmvTHIllEpve2EsKguNeHnGifnZID0C697X8WFThayMV9lDrvs6UY1l/Av1rJ48of/ZW5ol9DEszNi+PRwshw+uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456871; c=relaxed/simple;
	bh=oa5jgCJLN8pl7fmYTiCU2d2J/3cTmvLaodADNb1Qu9s=;
	h=Date:To:From:Subject:Message-Id; b=Qk8oe7m7OHSmy2/+ZfYWP+W4B5PYFiaNH64J5RNHsAOVl1v0V1rNAcgUp81+fnFqwcv7EM+s+IQXdIN0/MNkE+h6bH3usL2L3Va/2nOrY/7EKjUtBTniz3dLTw7BX2duIeKcbT1l39zFRSYdGRdyV1a+8vNa0wYvWRVnOCLclJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLq2FqQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLq2FqQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C62C4CEEB;
	Sun, 17 Aug 2025 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456871;
	bh=oa5jgCJLN8pl7fmYTiCU2d2J/3cTmvLaodADNb1Qu9s=;
	h=Date:To:From:Subject:From;
	b=gLq2FqQVBfMsU4TSnlIDeBO7E9LaHddn4OTR+lEKHwKiu4sWmMk7umz+QrcEgjgvf
	 TB1fgP9nirCmSF2nyaio0mteThJr4oRfpc9A8iXSaXHSvPzsTy2zDzxZWjklUHB43U
	 7H+Tkfj8JHqtV24224WfXBlJT9LkXAmuEZtGzp+A=
Date: Sun, 17 Aug 2025 11:54:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_to_section-to-memdesc_section.patch added to mm-new branch
Message-Id: <20250817185430.E9C62C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert page_to_section() to memdesc_section()
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-page_to_section-to-memdesc_section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_to_section-to-memdesc_section.patch

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
Subject: mm: convert page_to_section() to memdesc_section()
Date: Tue, 5 Aug 2025 18:22:52 +0100

Pass in the memdesc_flags_t instead of a pointer to the page.  This will
allow us to remove a few conversions to struct page in upcoming patches.

Link: https://lkml.kernel.org/r/20250805172307.1302730-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 +-
 include/linux/mm.h                 |    4 ++--
 mm/sparse.c                        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/asm-generic/memory_model.h~mm-convert-page_to_section-to-memdesc_section
+++ a/include/asm-generic/memory_model.h
@@ -53,7 +53,7 @@ static inline int pfn_valid(unsigned lon
  */
 #define __page_to_pfn(pg)					\
 ({	const struct page *__pg = (pg);				\
-	int __sec = page_to_section(__pg);			\
+	int __sec = memdesc_section(__pg->flags);		\
 	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
 
--- a/include/linux/mm.h~mm-convert-page_to_section-to-memdesc_section
+++ a/include/linux/mm.h
@@ -1808,9 +1808,9 @@ static inline void set_page_section(stru
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
-static inline unsigned long page_to_section(const struct page *page)
+static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
-	return (page->flags.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
+	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #endif
 
--- a/mm/sparse.c~mm-convert-page_to_section-to-memdesc_section
+++ a/mm/sparse.c
@@ -45,7 +45,7 @@ static u16 section_to_node_table[NR_MEM_
 
 int page_to_nid(const struct page *page)
 {
-	return section_to_node_table[page_to_section(page)];
+	return section_to_node_table[memdesc_section(page->flags)];
 }
 EXPORT_SYMBOL(page_to_nid);
 
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

