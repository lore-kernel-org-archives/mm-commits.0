Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04EE47F4A
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757372357; cv=none; b=UE6F8lMvd8NL+SYvi5tD6txiGilqVBhZTiIZkJgxwZZI2JAsSw3s4se6F+OzFXwWbKLUTzc/26oqZ2s4TK6cwwwGJWVw4am22Ix+xMSf1Ol/Ut/iFaRqTRs83gNaIGM3CB8UOOO+n/KyQaiuOfJE78rptRHCiGPUGuTYth+5N5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757372357; c=relaxed/simple;
	bh=3TRknvpvayCDYdmr/5ggCCbKTFpDSPD+00nzqLPqtLc=;
	h=Date:To:From:Subject:Message-Id; b=f6hZSQzJEa2m3Wmhh5OqSe7ixXQvKWZObVfFqFBTpHUSu8lHOpYPZqRyt1SUTZSSfB/87jSTel3CNCTLtnbGqFprLcWdhbwHuRsTHewZCNOW3Oo5rxI2t184+OeeQrcchwFiihGRFIwMy0m4m1s5SZvHZeYZ2W6Rl56rJ2Ok8H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F5sdAvlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F5sdAvlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD06C4CEF1;
	Mon,  8 Sep 2025 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757372355;
	bh=3TRknvpvayCDYdmr/5ggCCbKTFpDSPD+00nzqLPqtLc=;
	h=Date:To:From:Subject:From;
	b=F5sdAvlqsFgDurfoJqiruyUOCZvmmaam8D29EcU/NBg08wHgQU2Oqh/23HNYyYGns
	 eVXn2jAfVHFW05jGfkDpLtMq7UsGUnAVLzkb3BsER9hInQUHL/CzJ7ltRpI198Vp+z
	 Pc9IfhwvTN+EJz9zU5qK91tmnvywZHIBjG1fWmhA=
Date: Mon, 08 Sep 2025 15:59:14 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch added to mm-new branch
Message-Id: <20250908225915.1CD06C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()
has been added to the -mm mm-new branch.  Its filename is
     ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch

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
Subject: ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()
Date: Mon, 8 Sep 2025 18:11:01 +0100

In preparation for splitting struct ptdesc from struct page and struct
folio, remove mentions of struct folio from these functions.  Introduce
ptdesc_nr_pages() to avoid using lruvec_stat_add/sub_folio()

Link: https://lkml.kernel.org/r/20250908171104.2409217-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor
+++ a/include/linux/mm.h
@@ -2097,9 +2097,9 @@ static inline long folio_nr_pages(const
  * page.  compound_nr() can be called on a tail page, and is defined to
  * return 1 in that case.
  */
-static inline long compound_nr(struct page *page)
+static inline long compound_nr(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 1;
@@ -3066,21 +3066,26 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
+static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
+{
+	return compound_nr(ptdesc_page(ptdesc));
+}
+
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
+	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
 
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__SetPageTable(ptdesc_page(ptdesc));
+	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
+	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
 
 	ptlock_free(ptdesc);
-	__folio_clear_pgtable(folio);
-	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+	__ClearPageTable(ptdesc_page(ptdesc));
+	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-introduce-memdesc_flags_t-fix.patch
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
mm-remove-mlock_count-from-struct-page.patch
ptdesc-convert-__page_flags-to-pt_flags.patch
ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch
ptdesc-remove-ptdesc_to_virt.patch

