Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7E650279A
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793611; cv=none; b=eWezFiDr0yjbHEh+8YfIB7J/BomC0eTJ2aeeuYTHLq1gaRAHyc1uZVVtTdIeX+eWZwXRKyNnkgJFpCNQOE6eThak6XGK+R9Eb+plAMkg7vScg9uJI+F+BDi/uYRpFJLOzeg+JBSGO8AVRaeZv2rYjWNbUrzzP3PHSuuNZ4cEV+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793611; c=relaxed/simple;
	bh=UtRZr5I6mwR7+3Hm9P6wJXVcdNXghUuiA0m2eru5EKk=;
	h=Date:To:From:Subject:Message-Id; b=DaWQAscy7gQDgsXZ3Wv+WCBoGNfN0sypJLJb0e3Rvjsagqa/5ogq0Tg74V6IFDjU6c+JgFGLxpohCAFW3qdze09aanNjoKl1kUOGgytTy1bcSrMwvBt1Hgs+V3b9OCSJLdj08xawne4NOHoOoo5oEytcTEN2+7MD6gTNrUSJB78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAXD2Lf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAXD2Lf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96301F000FF;
	Wed, 30 Sep 2026 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790793609;
	bh=k5wjR/OXPdKctON3hLsTKhOAu0LGTe6Yz0pFcXtlhb8=;
	h=Date:To:From:Subject;
	b=HAXD2Lf5zEjnUlIaXRmd4QVcOAbvJ/CvMgoQqFEtcCa5yZ4A/09pY3D6TmBfWsUY5
	 D+P5SNSsLRAcoYA6zaUDrtnaLH+WExAGv3emA53Vyv15JHao0YpmqyzK/f/xpDCB6f
	 2aaxBwLGutLioF2q8Eo58sukbXxndUGxVkC433S0=
Date: Wed, 30 Sep 2026 11:40:09 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-open-code-init_compound_tail.patch removed from -mm tree
Message-Id: <20260930184009.C96301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: open-code init_compound_tail()
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-open-code-init_compound_tail.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: open-code init_compound_tail()
Date: Sun, 27 Sep 2026 10:54:33 +0800

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Link: https://lore.kernel.org/20260927025441.741633-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/internal.h       |    9 ---------
 mm/sparse-vmemmap.c |    5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/mm/internal.h~mm-sparse-vmemmap-open-code-init_compound_tail
+++ a/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(st
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-open-code-init_compound_tail
+++ a/mm/sparse-vmemmap.c
@@ -217,7 +217,10 @@ struct page __ref *vmemmap_shared_tail_p
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

