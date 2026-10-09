Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BD041BA60
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525535; cv=none; b=irq0aoN2yjHhh5FWgqwjqFYHNE1d6ePhY27j8ALtT9rzYt0I8MxHm4cVwyQhwgvvsTv6qRmvgroUiLvnNopYk905lbhg/SCwHOLh5zBKs6JPk4350+3rVUB12BkXR5iQKRE4v8ITwil+LMdrP0/9B5Yt7Cdy2qFjDtCHU2/K7D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525535; c=relaxed/simple;
	bh=JIF5y48ipiHiYgAALqYJWQvso3jtdB2E/mxrcUowOB8=;
	h=Date:To:From:Subject:Message-Id; b=qiVkltrTV0O1M7+5roBrOKP/o/jzyW4MIVUcjkBxm4tcNxV0/S+1vUO1UXs9kpe1mSz6dMHN6knDY3tq30aVj6Sevrnwb2t3Sz6ol7dea8bULlSCuj4mpDFqdpJdJ+oMt9Y7l/1jhXWoygAALIbYULNmv5INnt3+DgTkqsZwCHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1ft7+47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1ft7+47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3631F00893;
	Fri,  9 Oct 2026 05:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525533;
	bh=8XIirQqlD6zCTy5NdEPvFAfqzt6DPXTaVxIxv3z6oiY=;
	h=Date:To:From:Subject;
	b=t1ft7+47GMdUFz+yl45j2LR+qkX2OLg9FO51LbMseGkRU9LvPL+1i4VV+9yArHjKO
	 0uiRgHRoZgzVEKDZ009RID3E7ul+uW9/xYRXIDByNBmPuhMPJhm+XwqWRd2sap2wHM
	 U9qrX53asqDhLsgzUMH67sIGTryUBe7yNjOrkkr4=
Date: Thu, 08 Oct 2026 22:58:53 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-open-code-init_compound_tail.patch removed from -mm tree
Message-Id: <20261009055853.AB3631F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: open-code init_compound_tail()
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-open-code-init_compound_tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: open-code init_compound_tail()
Date: Wed, 30 Sep 2026 22:06:19 +0800

init_compound_tail() is only used by vmemmap_shared_tail_page(), where the
shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid. 
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Link: https://lore.kernel.org/20260930140627.57431-5-songmuchun@bytedance.com
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
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
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
@@ -221,7 +221,10 @@ struct page __ref *vmemmap_shared_tail_p
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

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

