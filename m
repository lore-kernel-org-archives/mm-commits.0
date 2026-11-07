Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023631;
	b=IdTI5GzogRLJRR2OPJ/loTDVZqJHqhhU1cynBtotH2r2sMcDJdX/YZ8dJKHBTaTp/XuU
	 YPjGjOgxUil7GXkGZb2lQt6vW+szJU0n0ljyxm3DcP9bP6pnIBs151upBfZByqGhF9Hnr
	 ZSexETgI2sU9MiTdr3W+oDV43zJ8g2vYnC9K3llcImtd2D2pVnO6abtLCvZyR8oznkSMu
	 L/TJASSH8UcC7H2RIMgTNym8SAPW9N7s2afE7EvbubHg4L6HEanxbYehV4T8vd8RO2nk5
	 H/8nRBAsHCCI2wPiAHwdphzHiJrLuDRZBF8r0g11GsHcCZ5C8JZoAaP0ozgVW2x/QWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023631;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HEKXK+YMh0DJ2vZbMLis9jWW3TypKn7aT/H7ThOqKtc=;
	b=kcZuTdq6Byj4/rtCzRXwgZG0qjGMoz0MMEcQdRyK1x1mgkcTECGQumsPM2rcbnc1WPPA
	 zldtmvcEMptTJ+ktcZfAEXDkdTiXTFbR8+tKigCbRudELQ5ETB33jDFmIfxiDHapOylsm
	 5CsxbGnKb7p41EDYVsVmrZradDoBTgp+uPY+L1VU1gJGGNQZtf8eCqeJ5Wp4iquY5B/hE
	 ytEp3tBOpXjyypbg+etUkXbD5Aj4Fzfi+KCeAMnVv8qO5c+luDgPZf0tLVcXEzPEMrRvI
	 7cxSYeQb2pN1J2TEUaUjlB7nt93tn3rymDRL7+gPeC1RXgxYjyNXGIJTzp3SNesB71w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JMuQ1cH5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8240606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JMuQ1cH5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727481F008A1;
	Sat,  7 Nov 2026 03:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023630;
	bh=HEKXK+YMh0DJ2vZbMLis9jWW3TypKn7aT/H7ThOqKtc=;
	h=Date:To:From:Subject;
	b=JMuQ1cH5LZiwXUQgaH9V3FtDTKXEKSP5QowHuVqDUizr8UbbNFbxa2vqE24A2cH5K
	 AcO17dJSTzfgZ1wAWYWlH53CH0SBrpDYWPYNvmoKonZEo5lXlrwZJ1FXfppJtTVYvr
	 Zolxh1TZZxgpo2qev2BRwK5P+7ECfXMxm7lPj42o=
Date: Fri, 06 Nov 2026 19:53:50 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch added to mm-unstable branch
Message-Id: <20261107035350.727481F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Sat, 07 Nov 2026 10:27:52 +0800

Keep alloc_vmemmap_page_list() together with
free_vmemmap_page_list(). This also allows the folio-oriented
optimization helper introduced in a subsequent change to reuse the
allocator without a forward declaration.

No functional change intended.

Link: https://lore.kernel.org/20261107022756.77731-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Yili Zhang <zhangyili01@baidu.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   44 ++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper
+++ a/mm/hugetlb_vmemmap.c
@@ -197,6 +197,28 @@ static void free_vmemmap_page_list(struc
 		free_vmemmap_page(page);
 }
 
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid, gfp_t gfp_mask)
+{
+	struct page *page, *next;
+	LIST_HEAD(new_pages);
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
+		if (!page)
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
+	}
+	list_splice(&new_pages, head);
+	memmap_pages_add(nr_pages);
+
+	return 0;
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
+		__free_page(page);
+	return -ENOMEM;
+}
+
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 		struct list_head *vmemmap_pages)
 {
@@ -324,28 +346,6 @@ static int vmemmap_remap_free(unsigned l
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(struct list_head *head,
-		unsigned int nr_pages, int nid, gfp_t gfp_mask)
-{
-	struct page *page, *next;
-	LIST_HEAD(new_pages);
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
-		if (!page)
-			goto free_pages;
-		list_add(&page->lru, &new_pages);
-	}
-	list_splice(&new_pages, head);
-	memmap_pages_add(nr_pages);
-
-	return 0;
-free_pages:
-	list_for_each_entry_safe(page, next, &new_pages, lru)
-		__free_page(page);
-	return -ENOMEM;
-}
-
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

