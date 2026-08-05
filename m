Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D79A3BED23
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896649; cv=none; b=LNAV3/9kJdV/3wyX09yGf934zg5iHGt7ecwmmOr6wySfkePZ1uqeNy+GUoQpMz3ACUoiQmXioxsegGKllt5N1e2rua3N2IZI2MbuJUWWiqPvXeSkky6S4REdj7+uTL+WcEqJst9hcUGjxNC64UhI+JJWbHXRgSuOQmu73NpXtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896649; c=relaxed/simple;
	bh=KUkz27g9DKGRKXhMWtj0zynLTUquZrLJls/hoZkuJQI=;
	h=Date:To:From:Subject:Message-Id; b=Px4zLCyeffJ+y93VzvHrlk6kMQMK9AqcxgTUr1/T8qcTKGBq7VbM+qjVnNqs17km+loRoCSibgvZxcJTTmitXrqyt/HW04a0bbrvkly26l/RWdjWd6FF6pbGbCzHbIdyVOz/Q8yCgahbL1U7wLxkF0gXQXqeuobhjZ5ug/SY298=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6wK89pu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6wK89pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232421F000E9;
	Wed,  5 Aug 2026 02:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896648;
	bh=C9+QV9y/DUIj0edNe2R+hVCisTIioNxSYczIo4yt7ck=;
	h=Date:To:From:Subject;
	b=g6wK89puBksen2p7pWBp5jdR5Sfc8nbPFHjdcVNjuEmv17H6OktYYNlCvX6McWYRw
	 HKvnvSkyeNfPqfRkbzvGsLyCcBQyy5gXqfSCop2sQABKuROooOvuKxrNFLhyhUJfjz
	 zhbkP/g4Oam59KWwYISbRt28XuMq82h3jZ7KVZog=
Date: Tue, 04 Aug 2026 19:24:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-provide-free_reserved_pages-removing-x86-variant.patch removed from -mm tree
Message-Id: <20260805022408.232421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: provide free_reserved_pages(), removing x86 variant
has been removed from the -mm tree.  Its filename was
     mm-provide-free_reserved_pages-removing-x86-variant.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: provide free_reserved_pages(), removing x86 variant
Date: Thu, 16 Jul 2026 16:51:01 +0200

Let's extend free_reserved_page() in page_alloc.c to
free_reserved_pages(), dropping the custom x86 variant.  The common-code
variant will consume an order, so adjust the x86 callers accordingly.

Make free_reserved_pages() assume that we are freeing ordinary high-order
pages, just with the special "reserved" flavor.  The target use case for
now is freeing vmemmap PMD pages.

Set the refcount directly to 0 (instead of 1) and call
__free_frozen_pages().  Set the page count to 0 before clearing
PG_reserved, so someone checking PG_reserved (and not finding it set) to
then try grabbing a ref would not suddenly have that ref be dropped.  That
is arguably cleaner and safer than the old way of doing it.

Add some kerneldoc.  Use a single adjust_managed_page_count() call.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-2-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    8 +-------
 include/linux/mm.h    |    8 ++++++--
 mm/page_alloc.c       |   33 ++++++++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 16 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-provide-free_reserved_pages-removing-x86-variant
+++ a/arch/x86/mm/init_64.c
@@ -1000,12 +1000,6 @@ int arch_add_memory(int nid, u64 start,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-static void free_reserved_pages(struct page *page, unsigned long nr_pages)
-{
-	while (nr_pages--)
-		free_reserved_page(page++);
-}
-
 static void __meminit free_pagetable(struct page *page)
 {
 	/* bootmem page has reserved flag */
@@ -1038,7 +1032,7 @@ static void __meminit free_vmemmap_pages
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
-			free_reserved_pages(page, nr_pages);
+			free_reserved_pages(page, order);
 		}
 	} else {
 		__free_pages(page, order);
--- a/include/linux/mm.h~mm-provide-free_reserved_pages-removing-x86-variant
+++ a/include/linux/mm.h
@@ -3996,8 +3996,12 @@ extern unsigned long free_reserved_area(
 
 extern void adjust_managed_page_count(struct page *page, long count);
 
-/* Free the reserved page into the buddy system, so it gets managed. */
-void free_reserved_page(struct page *page);
+void free_reserved_pages(struct page *page, unsigned int order);
+
+static inline void free_reserved_page(struct page *page)
+{
+	free_reserved_pages(page, 0);
+}
 
 static inline void mark_page_reserved(struct page *page)
 {
--- a/mm/page_alloc.c~mm-provide-free_reserved_pages-removing-x86-variant
+++ a/mm/page_alloc.c
@@ -6389,15 +6389,34 @@ void adjust_managed_page_count(struct pa
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
-void free_reserved_page(struct page *page)
+/**
+ * free_reserved_pages - free reserved pages
+ * @page: First page to free.
+ * @order: The page order to free.
+ *
+ * Free pages allocated through memblock during boot, letting the buddy
+ * manage them from now on.
+ *
+ * @page must be naturally aligned to the order and the order must not
+ * exceed MAX_PAGE_ORDER. All pages must be reserved.
+ */
+void free_reserved_pages(struct page *page, unsigned int order)
 {
-	clear_page_tag_ref(page);
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	adjust_managed_page_count(page, 1);
+	const unsigned long nr_pages = 1UL << order;
+	int i;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(page_to_pfn(page), nr_pages));
+	VM_WARN_ON_ONCE(order > MAX_PAGE_ORDER);
+
+	for (i = 0; i < nr_pages; i++) {
+		clear_page_tag_ref(page + i);
+		set_page_count(page + i, 0);
+		ClearPageReserved(page + i);
+	}
+	adjust_managed_page_count(page, nr_pages);
+	__free_frozen_pages(page, order, FPI_NONE);
 }
-EXPORT_SYMBOL(free_reserved_page);
+EXPORT_SYMBOL(free_reserved_pages);
 
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

