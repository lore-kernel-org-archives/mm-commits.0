Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8B221D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489960; cv=none; b=jNTj5V+GqC4NKb+SQiyL8MR+vZDhbZYm72Az24bwV/W2wBSjVyWRGNmfYBqXRa4uWmA68uWHA396pSe9MvSuBXL1rS7brP8djLdCVwVR1glmkxdMiDSD1HTPCPodaee9xdALznZs2JxqVgHiwQYEnH90ARF3bkpkThiTwz1zm40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489960; c=relaxed/simple;
	bh=vkzwe9chz0l8+EW/HYwXkFSwmz3VMR+VZxIeSMry/FI=;
	h=Date:To:From:Subject:Message-Id; b=KT7V8chUtubNBgs6yhOdkC5Zi3xrm54CH6DoMFNZwfTZqGZXy5NL1aNS+MTyui2EHyric0KkPPUxf185G14avTuLTyBMMXtlQijpPvBL/itbSFDd9mniAwaFJGCKP5UHCrnK7IXRbqDJv/U3VVfOktZJeo30BcPhkRRRS//0QhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RU4cGA70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RU4cGA70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80F4C4CEE7;
	Sun, 21 Sep 2025 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489959;
	bh=vkzwe9chz0l8+EW/HYwXkFSwmz3VMR+VZxIeSMry/FI=;
	h=Date:To:From:Subject:From;
	b=RU4cGA70WW+b1whrVHQ4HQnxe9qhdmzIPjHA1l44nYLwhKlQyUaf7KeGlazySOoQI
	 zAtFJGZbRQxmBK1G1F9k/6MENI4EPH/ngyf/BPl1gLySuQ7yefb/0FkhmjmxVew1cP
	 qLfgDuFAJxD6gu1/z/lnhNzhP4n8+BenFT1QKDj8=
Date: Sun, 21 Sep 2025 14:25:59 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch removed from -mm tree
Message-Id: <20250921212559.C80F4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()
has been removed from the -mm tree.  Its filename was
     ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ksm-use-a-folio-inside-cmp_and_merge_page.patch

