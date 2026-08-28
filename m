Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B33F1066
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 23:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787959066; cv=none; b=uRa9lQvBRDg5HDfTujMmgPFE2cR6gQUCMcs/mDhUdsldiUxpw8coGZZzSjBttl0MNbQjFupoy+9um5dOwLDULi7IvkKlvur+oZnP97rnDdAqaQrJtbR6fN0cS9o12g3CAeQxOEUY75tJXiS5KDRbewGaBXgo8GYv4HeMy+2k3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787959066; c=relaxed/simple;
	bh=FJDqf8w2bFt3XPWtHa/SIkBDexS//HMqQ8rARMV0+YE=;
	h=Date:To:From:Subject:Message-Id; b=imHImbGVVpC/4euyb3PYBd6bJ49z2DxCl+B/K5WxG0e/rQrBcl2ywhAy/RiOO/2HM/uNtqvxR8Oi6B1lRKXHB3VkG1d2poF5walCQEVJZ8vK+dCUD0Hx/JSmH7PiCx5yritNvvRPVFaroH9Hoz9hxvWwK8lUH6qHdoIofVfLBA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OAYntfEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OAYntfEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3911F000E9;
	Fri, 28 Aug 2026 23:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787959064;
	bh=OTPDZ954DkGdIm98v6FODHOhlDi0ZfvZ1wz3oG5Go/4=;
	h=Date:To:From:Subject;
	b=OAYntfEB7Ahpw00vlNazWqaKv3YC6bPiQavdas/JaU6cI739/QLCSb10K6waMj1zE
	 PtWiMeRBdNunr1rT2tUQUEnv2Z4ap3hh2OKFMZnKzA69HrBPmuS2k2TpzxK51TpMuC
	 1J15tMhNcNfNmcon6XL2iWQUYkhBEomkAALZqOiQ=
Date: Fri, 28 Aug 2026 16:17:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch added to mm-new branch
Message-Id: <20260828231744.4A3911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: copy all referenced state via folio_migrate_lru_refs
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch

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
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
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

mm-memcontrol-make-lru_zone_size-atomic-and-simplify-sanity-check.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

