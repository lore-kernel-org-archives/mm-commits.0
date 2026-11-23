Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465395;
	b=zrkZGDE7XP2SBw06BjL8CKUkl2AfsYZwjs5LN7x30GiqSzpvWwZn1Mn99UHLjSdATbsp
	 cjuBJvKPejo2p0SAmWT9sVK5RnpGQsEn6JEkMeLQLVYlcpit8iua6c4O+APWjSlVFzgKp
	 rQRTnyXOTOfytk3O9aJsHy7HRJgSSIfIB2wCFE656F0kXPhmUlG+qc2nFMhGn87ipGIcp
	 3Czng30afFrus7rH5QCxL8O8qoWh/gsgEwBT+n3ke83YTzRI6oE7da+CtBeQhCf7LkgHA
	 l3KPczWLpCpjD4+k2dYyIqGIUqjmG9xydkEQf9wL0EejUbuh8ej0+CI/+8tOTM8oosA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465395;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wOB3ZntQJJU9OIMfagvnf+IaY5V1r+s3m6SfP5Vkkjw=;
	b=z+1AK7E8nKZCxxQgtrNJdzELTWxVNX8cGW3nMWjV/5baB8NQ+1tVr4Euk6vozPWZMVCW
	 ci2FkWZX040p88UEMYm4ZlBPKl6Xdv6CMRCjxgtap6xS+Ame5D+DgWz5LoY8h1SEcBU8D
	 TMPorX7CEmm3RpqG/8Nu0AvQVk4266wWQPMWPUk5LKsx0Qm4fwibHIes6uOBKStEdYCTc
	 5jbSx8V5AUmtQ2saC0yahEKbr7ewfSrew+OL1nG28tfpCFvwSn4zHv1rS3wp95Iq1Bnxr
	 o1Uobiq+zakf021Zout+SKeTfWXtgvMQPn0jBmHXCo0AiPVagX9P3CrnNdkdqqM7O1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RM6Pjt3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04742606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RM6Pjt3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335201F000C6;
	Mon, 23 Nov 2026 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465394;
	bh=wOB3ZntQJJU9OIMfagvnf+IaY5V1r+s3m6SfP5Vkkjw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RM6Pjt3R3KjXK474qIPJqHNA60krkFJ++FEIdy7DV1tZ32PS1D6NA5lv7oQzviwHj
	 7yIL7VOSXKm5WkEiO/V9Wwbyg7qwSSfGFsZdjh5/f13mE+L4C76t1Za9KH05OWyLQb
	 9I6Ooh1p4D52GYwRtCCWwuaeIHy3tVuv/6p0+z2o=
Date: Mon, 23 Nov 2026 12:23:13 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
Subject: + mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch added to mm-new branch
Message-Id: <20261123202314.335201F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: make folio lru referenced times count a generic API
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch

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
Subject: mm/mglru: make folio lru referenced times count a generic API
Date: Tue, 24 Nov 2026 02:53:00 +0800

Pure code shuffle, no behavior change.

Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
Without MGLRU the extra bits are never set, so they are inert. Move the
lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
unifying the API for checking folio referenced and workingset status.

folio_migrate_lru_refs() now migrates the complete refs count,
including PG_workingset (bit 1 of the encoding), bitwise identical to
the direct copy dropped from folio_migrate_flags().

lru_set_refs_flags() skips the nonexistent mask bits when
LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
!CONFIG_LRU_GEN builds.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 include/linux/mm_inline.h |   55 ++++++++++++++++++------------------
 mm/migrate.c              |    2 -
 2 files changed, 28 insertions(+), 29 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-make-folio-lru-referenced-times-count-a-generic-api
+++ a/include/linux/mm_inline.h
@@ -184,6 +184,12 @@ static inline int lru_get_gen_flags(unsi
 	return gen;
 }
 
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+#endif
+
 /**
  * lru_set_refs_flags - Set the LRU referenced count to folio flags.
  * @flags: pointer to the folio flags
@@ -206,7 +212,8 @@ static inline void lru_set_refs_flags(un
 		*flags |= BIT(PG_referenced);
 	if (refs & BIT(1))
 		*flags |= BIT(PG_workingset);
-	*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
+	if (LRU_REFS_WIDTH)
+		*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
 }
 
 /**
@@ -252,13 +259,31 @@ static inline void folio_set_lru_refs(st
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+#ifdef CONFIG_LRU_GEN
 void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
+#else
+static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
+{
+	/* Should not be called with !CONFIG_LRU_GEN */
+	WARN_ON_ONCE(1);
+}
+#endif
 
-static inline int folio_lru_gen(const struct folio *folio)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, or PG_referenced and PG_workingset (bits 0-1 of the
+ * encoding) for the active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+#ifdef CONFIG_LRU_GEN
 static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
 {
 	unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
@@ -424,20 +449,6 @@ static inline bool lru_gen_del_folio(str
 
 	return true;
 }
-
-/**
- * folio_migrate_lru_refs - copy the reference state to a new folio
- * @new: the destination folio
- * @old: the source folio
- *
- * Transfer the reference state to @new during migration: the MGLRU
- * refs count, including PG_referenced, or just PG_referenced for the
- * active/inactive LRU.
- */
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	folio_set_lru_refs(new, folio_lru_refs(old));
-}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -470,16 +481,6 @@ static inline bool lru_gen_del_folio(str
 {
 	return false;
 }
-
-static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
-{
-}
-
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	if (folio_test_referenced(old))
-		folio_set_referenced(new);
-}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
--- a/mm/migrate.c~mm-mglru-make-folio-lru-referenced-times-count-a-generic-api
+++ a/mm/migrate.c
@@ -807,8 +807,6 @@ void folio_migrate_flags(struct folio *n
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch
mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch
mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch
mm-mglru-make-generation-page-counters-atomic.patch
mm-memcg-add-folio-based-lruvec-live-helper.patch
mm-mglru-frequency-guided-workingset-promotion-mglru-fg.patch
mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch
mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch
mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch
mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

