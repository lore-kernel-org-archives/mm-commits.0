Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7606B49DBB3
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 22:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302445; cv=none; b=h4WfSoBzzA7tyAIPWu/D4HUhue+Jjc+5qiuVHQMwLjOmz+/59cbZwpQ8GodziGs1tIQC+7YIiYCKqqWAeONhGOLd9a/FCzGey6JtmZSdgXFasdy6UbYF555MlkrRtIm8KZK2yzq7VomP/z7aBwOdUzJAuaGqKmjHPYPI4t/evVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302445; c=relaxed/simple;
	bh=7l05W4M8Kz7Wx3DPpD3TibJLu77QtZPbDBfPZ003WpI=;
	h=Date:To:From:Subject:Message-Id; b=eXyudX7it0TOz03T3n9LQe+anhsZFh1WuD7DzulQYhJis78ZB/ePkVdv41sVZtwCzVw4sVVVpec8ITVct7xWiR0spO6jyoj5t8pn4icm5Q2gwdGvmsnbilbFC4VrkhTaGuuyAjOgcOrQXk4xgdloh/PWxs6m38ewGa8IDxdWomI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVr7wc+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVr7wc+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C315F1F00A3D;
	Tue,  1 Sep 2026 22:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788302438;
	bh=sMWZ0eq+qm5UYwm2ll7HuKhl+UxUj2/k7be1Ic4HPjg=;
	h=Date:To:From:Subject;
	b=oVr7wc+85vnfHVFOjmmcSDp1DTH4AiT900fq5Z9y+5FhGQYVw2RivqAvPyzJgtXk0
	 BroEm9l4i9OoGOza2e8na/NW0k+y16NqEbjslOPMxNwSrfo3yvBb6RpY/m3XU1rJPf
	 0gUKWBLxuAYMGO1qXZT+Lhjyy2i1g45Kyo+u/L5c=
Date: Tue, 01 Sep 2026 15:40:38 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch removed from -mm tree
Message-Id: <20260901224038.C315F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: copy all referenced state via folio_migrate_lru_refs
has been removed from the -mm tree.  Its filename was
     mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/migrate: copy all referenced state via folio_migrate_lru_refs
Date: Wed, 26 Aug 2026 01:53:36 +0800

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
uptodate, so a concurrent lockless reader cannot have its reference update
overwritten by the copy.

Link: https://lore.kernel.org/20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   20 +++++++++++++++-----
 mm/migrate.c              |    6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/include/linux/mm_inline.h~mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs
+++ a/include/linux/mm_inline.h
@@ -365,11 +365,19 @@ static inline bool lru_gen_del_folio(str
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
 
@@ -398,8 +406,10 @@ static inline bool lru_gen_del_folio(str
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

mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

