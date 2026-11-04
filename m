Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793768280;
	b=WL/3VqJQ7y1knz7Da4L2mVvs6wE6x7bus/vLqJnfZ7ULZFCkJGfnwpDQTKVroMY7lv72
	 ydfX4sw3YNH6mLc+l574sRtW+NrDjpE4zeSBVn/r/CBGlgtk5JQ0MyovJWkuwafAwWZp7
	 5x0J1w+vY05LKJ4sGQ0yR7A4wySfqqen0jPrjEYc97sp9tv0WPDI7siaQlTJOWO5EMmZm
	 +58b6vng0DMLIABWD4Bk2y3Q8DxJmc2c3O8BnKgTci7mwPSNIjP9BR/kPGma2uI7uomQr
	 gt2u0deCx5dR0QRjZOncFT8jGwZn35e4QeudIh1WSC+v2c9KhW6yFvu95sApnpUBG9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793768280;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lxL/NdYz8BO7AkXkGoNIy7RQaFVMc9yudnRVauvFIpk=;
	b=mmO/gX5dW8+4XdBBOyPg+lICX6Guyp2nQb0XDUCVCPi8cVlfX9smmNt3ZcE8m0ejUr8F
	 Vuwy0PKJdwxkhC/qBHAniUZMJx4KY1gPZU3FSrZZogXYiSe6TFx5A2jytSUEP60BJSefN
	 lKVI9LUamk6Yz6yA/3tBSDRXoFIONV/clYV4gcPVhbn1WSIPIylALid6Z+fpfQHtA5LzK
	 Tzzal59oDomz9W8zB1wdLHJsWsm4TlShbNED3E9p1mg8szJZ/XPCcbGHk+DqSgND2NCk+
	 Iw+WnO+PLJaoh42r6/F5Y+B8Nl9zzu1VwOKX+T0I5MIaFbyZ/iEu+4U9PxsN1hhPCZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UjzlVySY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52605606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 04:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UjzlVySY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE781F000C1;
	Wed,  4 Nov 2026 04:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793768280;
	bh=lxL/NdYz8BO7AkXkGoNIy7RQaFVMc9yudnRVauvFIpk=;
	h=Date:To:From:Subject;
	b=UjzlVySY0VEiW2lBfafXczfRJWvfGFdZ30frFO7+8oNaBJUTR8KUbFgIHtMuhFVIf
	 QmnOcloWaF6tkV2tvSheXIktupeUEcex+zdpauqTjoe4EPc0eAyxA9sCZ8xYYWRTaF
	 dDygVjO134jvwzSg4Ka7ct8Mo12nH9EuAQChabI0=
Date: Tue, 03 Nov 2026 20:57:59 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,
	osalvador@suse.de,lance.yang@linux.dev,jthoughton@google.com,
	david@kernel.org,chenhuacai@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch added to mm-new branch
Message-Id: <20261104045800.0CE781F000C1@smtp.kernel.org>
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
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Wed, 04 Nov 2026 10:35:06 +0800

Keep alloc_vmemmap_page_list() together with free_vmemmap_page_list(). 
This also allows the folio-oriented optimization helper introduced in a
subsequent change to reuse the allocator without a forward declaration.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
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
+		unsigned int nr_pages, int nid)
+{
+	LIST_HEAD(new_pages);
+	struct page *page, *next;
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
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
-		unsigned int nr_pages, int nid)
-{
-	LIST_HEAD(new_pages);
-	struct page *page, *next;
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
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

