Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0043F9F55
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525402; cv=none; b=NQDh8CACp4lU+Ey4YDC8v+eq8NYhsnZCR9SX80IXg/OJPtR5J4QcKXQlBFe5FJFNWPBA7x40qTHiHNclcZ0YQRgi/HQf/m48JCqCFsUs3580Ii/50BsquHf8BC3KOTXwg5sXeNE+7pPjy7n9MJObYr/vQGQpRLGk6BUNjrgC4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525402; c=relaxed/simple;
	bh=fnVP4OpolCeQghHBSMy1XFeKB8L5xNg7kaQvVNm6L6k=;
	h=Date:To:From:Subject:Message-Id; b=oQxKfa2XrSCE6rv9A9o6PXRPeFtSEnlvZqOlmgoa/3x10UG+D2zB69QS2+p3nY+/EhLvqyZu16gs3yoEI+CxChc5JPICVf7kjOSe9u5TYSkDwbicH/ks/J0xWirsb/yFc/awFWqFn/sjBl+CArLFb46xEeATrciEKpn3XM+mtI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B4w/Pgl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B4w/Pgl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85521F00893;
	Fri,  9 Oct 2026 05:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525400;
	bh=2gMVYhyCmv6QeAM+BvzqFe5sSBUEt5s7fKmIUaDlUIM=;
	h=Date:To:From:Subject;
	b=B4w/Pgl3sBvhneg5+JV6H+D8W+zrqvndEoEo1FBRermNWUCenTdrx7n3YqF0WgPTF
	 HgBu9k5TrqL2YNPCAQ+5uewLlc3SH6h0wJDNnXNx6qGVk5LGh3QaxGt8i0Z3ar4b9T
	 UdvspYnFia3gTkRWLi7hT85ECYs8aM/88sZ7zazw=
Date: Thu, 08 Oct 2026 22:56:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch removed from -mm tree
Message-Id: <20261009055640.B85521F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: copy all referenced state via folio_migrate_lru_refs
has been removed from the -mm tree.  Its filename was
     mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/migrate: copy all referenced state via folio_migrate_lru_refs
Date: Sun, 06 Sep 2026 00:51:08 +0800

folio_migrate_flags() copies PG_referenced separately from the MGLRU refs
counter, which folio_migrate_refs() transfers.  Yet under MGLRU,
PG_referenced and the refs counter bits together describe the referenced
status of a folio.

Consolidate the two: rename folio_migrate_refs() to
folio_migrate_lru_refs() and let it copy the complete referenced status,
i.e., the MGLRU refs count including PG_referenced, or just PG_referenced
for the active/inactive LRU.  Drop the open-coded PG_referenced copy so
the referenced status is transferred in one place.  No behavior change is
intended: under the active/inactive LRU the extra bits are unused, so
operating on them is a noop.

Transfer the reference state first, before the destination folio is marked
up to date, as a best effort to retain referenced status.

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-3-9aacbd77d4ca@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 include/linux/mm_inline.h |   20 +++++++++++++++-----
 mm/migrate.c              |    6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/include/linux/mm_inline.h~mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs
+++ a/include/linux/mm_inline.h
@@ -373,11 +373,19 @@ static inline bool lru_gen_del_folio(str
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -406,8 +414,10 @@ static inline bool lru_gen_del_folio(str
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
--- a/mm/migrate.c~mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs
+++ a/mm/migrate.c
@@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *n
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
+	/* Copy the reference state, including PG_referenced */
+	folio_migrate_lru_refs(newfolio, folio);
+
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *n
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
-	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.
_

Patches currently in -mm which might be from kasong@tencent.com are


