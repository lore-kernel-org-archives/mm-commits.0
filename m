Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057B66026D
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709572834; cv=none; b=uxkguNOg+pARP/fHMzsuyJ1G1fj4poBXDGhUuqqtC2UA7Zhk5FxUcHuavun9majuZXhLl+W5UPL0A6uPuSQOyrzy4jHhzAEniT3EilCgmhmQb16+XusKEhTaN9HYH7Zaqu8zU54lbfljtgQUArfldtZg0Y4f6wh1RJ8DVnMjyTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709572834; c=relaxed/simple;
	bh=zq6WNa5Ca76jz72HP3NXhc8z434iO49HM+jbxwCUu8s=;
	h=Date:To:From:Subject:Message-Id; b=RB6PDPNlsyaXlUALmPbedSNwhFFyUucTxdtYRx5htfYOQrK8MclMzPraAw11UwKw2Hio1as/xKTlwRs4g2QOXmePwzvvV8MNKZY1VT83MdxVNV3xUnKBxOrBOF+0HCmynz4XCSS/XiJM8HREi5lu84FZV03JbP3HALPPzl+HakM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7HK/1cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7HK/1cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD67C433F1;
	Mon,  4 Mar 2024 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709572833;
	bh=zq6WNa5Ca76jz72HP3NXhc8z434iO49HM+jbxwCUu8s=;
	h=Date:To:From:Subject:From;
	b=h7HK/1cc4/SRVg7mkZODL03tvbvg+ZWVOOOdSOQHw8sUiPdmrcna+Avbkyy8H9uPP
	 tThMrMIIiUd3IXQuCHMYD/MC/gSJO85inyZmQEckH9xQQNmQY9LSysIsLpGLjWafcH
	 yaob7AtcKeiWMOn7/yGFyNMRN15ScUnmCRzIU56I=
Date: Mon, 04 Mar 2024 09:20:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,rppt@kernel.org,muchun.song@linux.dev,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-supplement-for-ptdesc-conversion.patch added to mm-unstable branch
Message-Id: <20240304172033.CBD67C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: supplement for ptdesc conversion
has been added to the -mm mm-unstable branch.  Its filename is
     s390-supplement-for-ptdesc-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-supplement-for-ptdesc-conversion.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: s390: supplement for ptdesc conversion
Date: Mon, 4 Mar 2024 19:07:20 +0800

After commit 6326c26c1514 ("s390: convert various pgalloc functions to use
ptdescs"), there are still some positions that use page->{lru, index}
instead of ptdesc->{pt_list, pt_index}.  In order to make the use of
ptdesc->{pt_list, pt_index} clearer, it would be better to convert them as
well.

Link: https://lkml.kernel.org/r/04beaf3255056ffe131a5ea595736066c1e84756.1709541697.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgalloc.h |    4 +--
 arch/s390/mm/gmap.c             |   38 +++++++++++++++---------------
 arch/s390/mm/pgalloc.c          |    8 +++---
 3 files changed, 26 insertions(+), 24 deletions(-)

--- a/arch/s390/include/asm/pgalloc.h~s390-supplement-for-ptdesc-conversion
+++ a/arch/s390/include/asm/pgalloc.h
@@ -23,9 +23,9 @@ unsigned long *crst_table_alloc(struct m
 void crst_table_free(struct mm_struct *, unsigned long *);
 
 unsigned long *page_table_alloc(struct mm_struct *);
-struct page *page_table_alloc_pgste(struct mm_struct *mm);
+struct ptdesc *page_table_alloc_pgste(struct mm_struct *mm);
 void page_table_free(struct mm_struct *, unsigned long *);
-void page_table_free_pgste(struct page *page);
+void page_table_free_pgste(struct ptdesc *ptdesc);
 extern int page_table_allocate_pgste;
 
 static inline void crst_table_init(unsigned long *crst, unsigned long entry)
--- a/arch/s390/mm/gmap.c~s390-supplement-for-ptdesc-conversion
+++ a/arch/s390/mm/gmap.c
@@ -206,9 +206,11 @@ static void gmap_free(struct gmap *gmap)
 
 	/* Free additional data for a shadow gmap */
 	if (gmap_is_shadow(gmap)) {
+		struct ptdesc *ptdesc;
+
 		/* Free all page tables. */
-		list_for_each_entry_safe(page, next, &gmap->pt_list, lru)
-			page_table_free_pgste(page);
+		list_for_each_entry_safe(ptdesc, next, &gmap->pt_list, pt_list)
+			page_table_free_pgste(ptdesc);
 		gmap_rmap_radix_tree_free(&gmap->host_to_rmap);
 		/* Release reference to the parent */
 		gmap_put(gmap->parent);
@@ -1348,7 +1350,7 @@ static void gmap_unshadow_pgt(struct gma
 {
 	unsigned long *ste;
 	phys_addr_t sto, pgt;
-	struct page *page;
+	struct ptdesc *ptdesc;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	ste = gmap_table_walk(sg, raddr, 1); /* get segment pointer */
@@ -1361,9 +1363,9 @@ static void gmap_unshadow_pgt(struct gma
 	*ste = _SEGMENT_ENTRY_EMPTY;
 	__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 	/* Free page table */
-	page = phys_to_page(pgt);
-	list_del(&page->lru);
-	page_table_free_pgste(page);
+	ptdesc = page_ptdesc(phys_to_page(pgt));
+	list_del(&ptdesc->pt_list);
+	page_table_free_pgste(ptdesc);
 }
 
 /**
@@ -1377,7 +1379,7 @@ static void gmap_unshadow_pgt(struct gma
 static void __gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr,
 				unsigned long *sgt)
 {
-	struct page *page;
+	struct ptdesc *ptdesc;
 	phys_addr_t pgt;
 	int i;
 
@@ -1389,9 +1391,9 @@ static void __gmap_unshadow_sgt(struct g
 		sgt[i] = _SEGMENT_ENTRY_EMPTY;
 		__gmap_unshadow_pgt(sg, raddr, __va(pgt));
 		/* Free page table */
-		page = phys_to_page(pgt);
-		list_del(&page->lru);
-		page_table_free_pgste(page);
+		ptdesc = page_ptdesc(phys_to_page(pgt));
+		list_del(&ptdesc->pt_list);
+		page_table_free_pgste(ptdesc);
 	}
 }
 
@@ -2058,19 +2060,19 @@ int gmap_shadow_pgt(struct gmap *sg, uns
 {
 	unsigned long raddr, origin;
 	unsigned long *table;
-	struct page *page;
+	struct ptdesc *ptdesc;
 	phys_addr_t s_pgt;
 	int rc;
 
 	BUG_ON(!gmap_is_shadow(sg) || (pgt & _SEGMENT_ENTRY_LARGE));
 	/* Allocate a shadow page table */
-	page = page_table_alloc_pgste(sg->mm);
-	if (!page)
+	ptdesc = page_table_alloc_pgste(sg->mm);
+	if (!ptdesc)
 		return -ENOMEM;
-	page->index = pgt & _SEGMENT_ENTRY_ORIGIN;
+	ptdesc->pt_index = pgt & _SEGMENT_ENTRY_ORIGIN;
 	if (fake)
-		page->index |= GMAP_SHADOW_FAKE_TABLE;
-	s_pgt = page_to_phys(page);
+		ptdesc->pt_index |= GMAP_SHADOW_FAKE_TABLE;
+	s_pgt = page_to_phys(ptdesc_page(ptdesc));
 	/* Install shadow page table */
 	spin_lock(&sg->guest_table_lock);
 	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
@@ -2088,7 +2090,7 @@ int gmap_shadow_pgt(struct gmap *sg, uns
 	/* mark as invalid as long as the parent table is not protected */
 	*table = (unsigned long) s_pgt | _SEGMENT_ENTRY |
 		 (pgt & _SEGMENT_ENTRY_PROTECT) | _SEGMENT_ENTRY_INVALID;
-	list_add(&page->lru, &sg->pt_list);
+	list_add(&ptdesc->pt_list, &sg->pt_list);
 	if (fake) {
 		/* nothing to protect for fake tables */
 		*table &= ~_SEGMENT_ENTRY_INVALID;
@@ -2114,7 +2116,7 @@ int gmap_shadow_pgt(struct gmap *sg, uns
 	return rc;
 out_free:
 	spin_unlock(&sg->guest_table_lock);
-	page_table_free_pgste(page);
+	page_table_free_pgste(ptdesc);
 	return rc;
 
 }
--- a/arch/s390/mm/pgalloc.c~s390-supplement-for-ptdesc-conversion
+++ a/arch/s390/mm/pgalloc.c
@@ -135,7 +135,7 @@ err_p4d:
 
 #ifdef CONFIG_PGSTE
 
-struct page *page_table_alloc_pgste(struct mm_struct *mm)
+struct ptdesc *page_table_alloc_pgste(struct mm_struct *mm)
 {
 	struct ptdesc *ptdesc;
 	u64 *table;
@@ -147,12 +147,12 @@ struct page *page_table_alloc_pgste(stru
 		memset64(table, _PAGE_INVALID, PTRS_PER_PTE);
 		memset64(table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
 	}
-	return ptdesc_page(ptdesc);
+	return ptdesc;
 }
 
-void page_table_free_pgste(struct page *page)
+void page_table_free_pgste(struct ptdesc *ptdesc)
 {
-	pagetable_free(page_ptdesc(page));
+	pagetable_free(ptdesc);
 }
 
 #endif /* CONFIG_PGSTE */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch
mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch
mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch
s390-supplement-for-ptdesc-conversion.patch

