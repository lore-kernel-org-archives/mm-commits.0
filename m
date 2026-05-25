Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF42E156F45;
	Mon, 25 May 2026 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779745802; cv=none; b=Uu2GbYqQvWrH800sAlfMdIGIRuyP6Pyyws6jJyvsmYropvBAkZLPgVz0AnIMCXiojbWkUaB+V9ShUdhqjumzKSBBMIfzCuxIPBjfdzFujX1ubMco70lN+Xf9Fy+J0//hvLXjb5FTHWDLKuruDRUYmPn7dzv2TdsT3Qda2HflB/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779745802; c=relaxed/simple;
	bh=QLK/wBmwIX/EE/eVtfESUxdlvgf+74JixaElDaNPq/4=;
	h=Date:To:From:Subject:Message-Id; b=pDq0Kwzzg590XZUk2sJLUmONebDN+jUbSbp6AS6uf29JDWzUNzbMdf+KOuKul27058EspiCaIs1ewbIGnfqsP8/LDclf36LjRGrI6ZhL3gSOosRPJMz0igQ8kKwliMNoyhtiLCTJEyXjSoEOajEoCiaaC5hvUUy+vJ5XxIYMmGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BPYKn25X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BPYKn25X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FBE1F000E9;
	Mon, 25 May 2026 21:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779745800;
	bh=AEu3UiBHKdoTTuSWrpLLwUGyuaXJEOQsbZK+TgcrS1o=;
	h=Date:To:From:Subject;
	b=BPYKn25XacHWjc/CQmzjDoDGbL5aBhAW4ER6efaKdd2+/U3SysPs/9CLlHJt7jgAP
	 yw/8gA+EmJ56vek3OzNMh8j6wXbcbp6bfCv+iDksQSJUTE0UQW9tU3USMpEgonBoYi
	 ThEjQPSwc1Ip5A4g6V/pf4CL0dQlPIIe33GNQc4o=
Date: Mon, 25 May 2026 14:49:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@kernel.org,kas@kernel.org,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch added to mm-hotfixes-unstable branch
Message-Id: <20260525215000.73FBE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
Date: Mon, 25 May 2026 10:52:13 +0800

vmemmap_restore_pte() rebuilds restored vmemmap pages from a tail-page
template derived from compound_head().  This is wrong when the current PTE
already maps a page whose contents are not tail-page metadata.

In the rollback path of vmemmap_remap_free(), the first restored PTE is
backed by vmemmap_head and contains head-page metadata.  Reconstructing
that page from a tail-page template overwrites the head-page state and
corrupts the restored vmemmap page.

Fix this by copying the full page from the page currently mapped by the
PTE.  Also pass vmemmap_tail to the rollback walk so only PTEs backed by
the shared tail page are restored, while the head PTE remains mapped to
vmemmap_head.  Add VM_WARN_ON_ONCE() checks for unexpected cases.

Link: https://lore.kernel.org/20260525025213.2229628-1-songmuchun@bytedance.com
Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback
+++ a/mm/hugetlb_vmemmap.c
@@ -207,6 +207,8 @@ static void vmemmap_remap_pte(pte_t *pte
 
 	/* Remapping the head page requires r/w */
 	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+
 		list_del(&walk->vmemmap_head->lru);
 
 		/*
@@ -218,6 +220,8 @@ static void vmemmap_remap_pte(pte_t *pte
 
 		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
 	} else {
+		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
+
 		/*
 		 * Remap the tail pages as read-only to catch illegal write
 		 * operation to the tail pages.
@@ -232,33 +236,28 @@ static void vmemmap_remap_pte(pte_t *pte
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	struct page *page;
-	struct page *from, *to;
-
-	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&page->lru);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
 	/*
-	 * Initialize tail pages in the newly allocated vmemmap page.
-	 *
-	 * There is folio-scope metadata that is encoded in the first few
-	 * tail pages.
-	 *
-	 * Use the value last tail page in the page with the head page
-	 * to initialize the rest of tail pages.
+	 * When rolling back vmemmap_remap_free(), keep the copied head page
+	 * mapping and restore only PTEs currently pointing at the shared tail
+	 * page.
 	 */
-	from = compound_head((struct page *)addr) +
-		PAGE_SIZE / sizeof(struct page) - 1;
-	to = page_to_virt(page);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++)
-		*to = *from;
+	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
+		return;
+
+	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+
+	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
+	list_del(&dst->lru);
+	copy_page(page_to_virt(dst), page_to_virt(src));
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
 /**
@@ -324,6 +323,7 @@ static int vmemmap_remap_free(unsigned l
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch
mm-cma-fix-reserved-page-leak-on-activation-failure.patch
mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

