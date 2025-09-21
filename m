Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E999228DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489849; cv=none; b=mmPWHq56X/OuMKav2I4rLqleuo4uBqagtVkpkqQoPJ+jJ4H0gMPlx5ziWgLWFLH7jEUulm7thW3bq8Dm3VzTWLl6gu9D0qua6NDMiEfnYS7qoQA7R/L1G76pZM3VUgv37IRTCZUroo7fvbAP24lMjyAID66gwBI0K2ilTbl377M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489849; c=relaxed/simple;
	bh=dIVzTEvd+P+KKPhS4MGjhrYd31HLeb4aLxUjQe7DPsk=;
	h=Date:To:From:Subject:Message-Id; b=ThnaIYxFdutEmhiqjW1FSqcjgl63oMiI+QjX4H3bUUkq1VL8PYsdWtg+16tmGepO4J1JozGwgHrjcb7bWLEol8OzTtHraZWNuUWWkd49c6oXfxfLCmnNiRKGMf5aeo9vjtCnUNJBmPPLOQcXlWygdKjvhmzQMfLVS2jOqtr8ttw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zcRCbyiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zcRCbyiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF573C4CEE7;
	Sun, 21 Sep 2025 21:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489848;
	bh=dIVzTEvd+P+KKPhS4MGjhrYd31HLeb4aLxUjQe7DPsk=;
	h=Date:To:From:Subject:From;
	b=zcRCbyiUibj67Zhzy2q64Q4m45oMedBoRYDosuTvWDlcY+nL9r04pKFLuhJ5MTljO
	 XJ0NXaE9zHxKIVIS9iL+YhZ8GrvrilgiNzkkHzpvJSSEkD5TVTGmjpXdJ14DNc9Gbk
	 CNmTBxrIlpRKqrDpzF1KxEzUJ/q3JAtEgUhthyIM=
Date: Sun, 21 Sep 2025 14:24:08 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,glider@google.com,elver@google.com,dvyukov@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kfence-drop-nth_page-usage.patch removed from -mm tree
Message-Id: <20250921212408.BF573C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfence: drop nth_page() usage
has been removed from the -mm tree.  Its filename was
     kfence-drop-nth_page-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kfence: drop nth_page() usage
Date: Mon, 1 Sep 2025 17:03:56 +0200

We want to get rid of nth_page(), and kfence init code is the last user.

Unfortunately, we might actually walk a PFN range where the pages are not
contiguous, because we might be allocating an area from memblock that
could span memory sections in problematic kernel configs (SPARSEMEM
without SPARSEMEM_VMEMMAP).

We could check whether the page range is contiguous using
page_range_contiguous() and failing kfence init, or making kfence
incompatible these problemtic kernel configs.

Let's keep it simple and simply use pfn_to_page() by iterating PFNs.

Link: https://lkml.kernel.org/r/20250901150359.867252-36-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/kfence/core.c~kfence-drop-nth_page-usage
+++ a/mm/kfence/core.c
@@ -594,15 +594,14 @@ static void rcu_guarded_free(struct rcu_
  */
 static unsigned long kfence_init_pool(void)
 {
-	unsigned long addr;
-	struct page *pages;
+	unsigned long addr, start_pfn;
 	int i;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
 
 	addr = (unsigned long)__kfence_pool;
-	pages = virt_to_page(__kfence_pool);
+	start_pfn = PHYS_PFN(virt_to_phys(__kfence_pool));
 
 	/*
 	 * Set up object pages: they must have PGTY_slab set to avoid freeing
@@ -613,11 +612,12 @@ static unsigned long kfence_init_pool(vo
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
+		slab = page_slab(pfn_to_page(start_pfn + i));
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
@@ -665,10 +665,12 @@ static unsigned long kfence_init_pool(vo
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
+
+		slab = page_slab(pfn_to_page(start_pfn + i));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
_

Patches currently in -mm which might be from david@redhat.com are


