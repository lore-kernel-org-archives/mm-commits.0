Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343C418A55
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525532; cv=none; b=X7ON1crfa/Ef5M9UB1J8r1N5r+5apiz3Vt9Nap/zyzDtrljLx+1dOwoPvZthoAKHYaG5mTjor9rAleQzXMjgr41V5rGzW7yVxyJiecb0OZ9Zky0fM6sI09WgDPVCZHeMnkBFeQMgrR6IuUxD5+jJZ24aubsyOJGmBNPGlmwU9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525532; c=relaxed/simple;
	bh=NYFs6MVIcCRyzVUmPWVMwkCpUdYqpGK6PcgBA8IId+o=;
	h=Date:To:From:Subject:Message-Id; b=pd77SyEFK7u8ANzYEeNbR26k9XycWOOC4VBS1/KUItpacXdi9cbmohDSzKtX+Kznyl8dkxXuSlFJQ1ufIEmVu+SVL0cbOW/8KGRU09a8X9GT7ipFyA87hb3FHJUZZyTvEmmuYhpvm9m4NXfLdQvi3XGaw2B5D/0G7bGFHXBSb2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oL99Jta6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oL99Jta6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BDC1F00893;
	Fri,  9 Oct 2026 05:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525530;
	bh=QLEvW9fOxz4raFeLsDjHZ0Q2tUtLG+/97SkqxdSawz4=;
	h=Date:To:From:Subject;
	b=oL99Jta6sbYQ+SdOlE5w5usFVJeKqY7chMsdjLC90HuVonKeuNGiTRMhO3yK3ziso
	 in9uyOP0ZCV0dkUJ8HqeMoPGaU4/eys1N1fPUWMB/GR7zGL7YREPSRVNEhwW2jEN8V
	 HeNVFbxvim8xtYJhs3KHAXEV32u05lg+tEiMw4Gw=
Date: Thu, 08 Oct 2026 22:58:50 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch removed from -mm tree
Message-Id: <20261009055850.96BDC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: allocate shared tail page array dynamically
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: allocate shared tail page array dynamically
Date: Wed, 30 Sep 2026 22:06:17 +0800

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") added the
per-zone vmemmap_tails array.  Its size depends on MAX_FOLIO_ORDER, which
had been moved to mmzone.h in preparation for the array.

PUD_ORDER is defined by linux/pgtable.h, which cannot be included from
mmzone.h without creating an include cycle.  It was therefore open-coded
as PUD_SHIFT - PAGE_SHIFT.

This removed the dependency on PUD_ORDER, but not the underlying
dependency on architecture page-table definitions.  PUD_SHIFT is generally
provided by architecture page-table headers, which are not guaranteed to
have been included when mmzone.h is parsed.

The dependency remained hidden because vmemmap_tails was originally
guarded by CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP.  Under that condition,
MAX_FOLIO_ORDER resolves to either MAX_PAGE_ORDER or the fixed HugeTLB
limit, rather than the PUD_SHIFT-based definition.

Device DAX, however, does not require CONFIG_HUGETLB_PAGE.  When it is
converted to use section-based vmemmap optimization, MAX_FOLIO_ORDER can
resolve to PUD_SHIFT - PAGE_SHIFT while it is being used to size
vmemmap_tails.  This would make struct zone depend on architecture
page-table definitions being available when mmzone.h is parsed.

Replace the embedded array with a pointer and allocate it on first use. 
This moves the order-count evaluation into sparse-vmemmap.c, after the
architecture page-table definitions are available, and removes the
dependency from mmzone.h.

Removing the compile-time array also removes the original reason for
keeping MAX_FOLIO_ORDER and the vmemmap optimization sizing definitions in
mmzone.h.  Follow-up cleanups can place each definition in the header
owned by its respective subsystem.

Link: https://lore.kernel.org/20260930140627.57431-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 include/linux/mmzone.h |    7 +------
 mm/sparse-vmemmap.c    |   39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically
+++ a/include/linux/mmzone.h
@@ -113,11 +113,6 @@
 	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
-#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
-	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
-#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
-
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -1156,7 +1151,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
+	struct page **vmemmap_tails;
 #endif
 } ____cacheline_internodealigned_in_smp;
 
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically
+++ a/mm/sparse-vmemmap.c
@@ -170,16 +170,47 @@ static void * __meminit vmemmap_alloc_bl
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+
+static __ref struct page **vmemmap_tails(struct zone *zone)
+{
+	const size_t size = array_size(VMEMMAP_OPTIMIZATION_NR_ORDERS,
+				       sizeof(*zone->vmemmap_tails));
+	struct page **pages = READ_ONCE(zone->vmemmap_tails);
+
+	if (pages)
+		return pages;
+
+	pages = slab_is_available() ? kzalloc_objs(*pages, VMEMMAP_OPTIMIZATION_NR_ORDERS) :
+		memblock_alloc(size, __alignof__(*pages));
+	if (!pages)
+		return NULL;
+
+	if (cmpxchg(&zone->vmemmap_tails, NULL, pages) != NULL) {
+		if (slab_is_available())
+			kfree(pages);
+		else
+			memblock_free(pages, size);
+		pages = READ_ONCE(zone->vmemmap_tails);
+	}
+
+	return pages;
+}
+
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	struct page *page;
+	struct page *page, **pages;
 	void *addr;
 
 	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
 		return NULL;
 
-	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	pages = vmemmap_tails(zone);
+	if (!pages)
+		return NULL;
+
+	page = READ_ONCE(pages[idx]);
 	if (page)
 		return page;
 
@@ -194,12 +225,12 @@ struct page __ref *vmemmap_shared_tail_p
 	}
 
 	page = virt_to_page(addr);
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+	if (cmpxchg(&pages[idx], NULL, page) != NULL) {
 		if (slab_is_available())
 			__free_page(page);
 		else
 			memblock_free(addr, PAGE_SIZE);
-		page = READ_ONCE(zone->vmemmap_tails[idx]);
+		page = READ_ONCE(pages[idx]);
 	}
 
 	return page;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

