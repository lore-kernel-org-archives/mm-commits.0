Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FDC3BAD84
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439060; cv=none; b=se/b9cPo6MjGFUsp8vJx6kkLc+Pmcvd1wP4raeodZEAHcPGi9AXHktX94wgcupgUIow+3t2mTGw384ApCnhDiq+q9BmmdsKefPumsSybW4sIXRfJiEPetaKvGrPufqzexwlnrueyEhKXWIvWqgJPYv6ZrwLlV4/JsE8W3An0eTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439060; c=relaxed/simple;
	bh=f/l9+SVLusg0HcAAm3gY/LdQVhE3OtXdm7cnDWO5nIU=;
	h=Date:To:From:Subject:Message-Id; b=DXA/mPKRTTOK9JET7mYpe2xaaWreXF5ZJwZ5pq8p8i+eBW+8VhCJkksMN7jSC+OTlKPv16OqasMdBCBYv91iWoLAJCUr0yNBJaEH/GUn+vdFz/k+tnoXXSmBVhmnfKJ9BC8Hu/jyylx9NepTIUmSPi6fC2o5suuBzkyfZ7c4pYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LJ+aq3ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LJ+aq3ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31561F00893;
	Tue,  2 Jun 2026 22:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439059;
	bh=UQ5rDVkesSnVCSNqVyE5Opf0IYTV+RGo+SaTLG+ll/Q=;
	h=Date:To:From:Subject;
	b=LJ+aq3ZKl+oCJwJKor+M0lRcZEHGHEY7tG316H/Mwoj814JzMT3RQS5VN5b1h4kNO
	 9vUb2mr6pFzQQ6WIx671K4uBOfbSJSlmwNclj2Az9RBkBCy1miihwy7WuXFLWOTjsm
	 QneHs2O14EjF92GcQ2PF7vvGroPcttsQAa3DPI9s=
Date: Tue, 02 Jun 2026 15:24:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch removed from -mm tree
Message-Id: <20260602222418.E31561F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove ifdefs from pindex helpers
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: remove ifdefs from pindex helpers
Date: Wed, 13 May 2026 12:35:16 +0000

The ifdefs are not technically needed here, everything used here is
always defined.

Switching to IS_ENABLED() makes the code a bit less tiresome to read.

Link: https://lore.kernel.org/20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-ifdefs-from-pindex-helpers
+++ a/mm/page_alloc.c
@@ -650,19 +650,17 @@ out:
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(!is_pmd_order(order));
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			VM_BUG_ON(!is_pmd_order(order));
 
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+			return NR_LOWORDER_PCP_LISTS + movable;
+		}
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -671,12 +669,12 @@ static inline int pindex_to_order(unsign
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+	}
 
 	return order;
 }
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-delete-stale-comment-about-cachelines.patch

