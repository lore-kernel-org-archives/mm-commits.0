Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6757384238
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788647123; cv=none; b=L0p3MH06VMKE6H3tC6yd2BF/WAMcSV0CkZM3TccT2lzoCAOAz3RNfv86Y3ciTpTAoTVQIKlqS9pndrEnk7B8+kwofZfROfLCGy2dvyksC3LqaA0/a2wEYeFGCaZs6edaIvOH3QpauEhfMFH6idcHMuCkBia6r4cQ0mqpRkzeq/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788647123; c=relaxed/simple;
	bh=boftizCIAF7eLwr+LdB5/7huC5UHS/YlVxnSk4pH3bY=;
	h=Date:To:From:Subject:Message-Id; b=UP/19y9tzuw9HrgxSLMH9Hf7oUdUn26otP8MpwTp80IQj6JlRU4YZDpmq9EiTQj676nN8Owj/4U06pjjJawHM35R1DPzWPqzbrgOpJ81QCTLU0Kdu5W3eHJnfl/L5KFlPhqK9ngOMQdsHntJnKSaXQrLTEjrLqHmmd6vKRK2BWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CG5J/F1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CG5J/F1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB2D1F00A3A;
	Sat,  5 Sep 2026 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788647121;
	bh=NDcxoEcfhTmwjX0P54h+4YFCmIWrcb91H2PL7kLyYuA=;
	h=Date:To:From:Subject;
	b=CG5J/F1U8KDA8l7s/304p26ZwpoCkIx8vN1dzO5wmnPWupyWQHAEl2h5ZMx7DpwS3
	 5tjtjwp4BMwM+vyATz+H97H6bXK7XK47wR/73IMVyiyliA9l8JlZ+NAtOtqu8I+FdE
	 +8Tl7h1WPT2jGtCyAl7NcaK8dBcTsy5ySnQA0amo=
Date: Sat, 05 Sep 2026 15:25:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-potential-generation-folio-number-leak.patch added to mm-new branch
Message-Id: <20260905222521.1AB2D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix potential generation folio number leak
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-fix-potential-generation-folio-number-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-potential-generation-folio-number-leak.patch

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
Subject: mm/mglru: fix potential generation folio number leak
Date: Sun, 06 Sep 2026 00:51:11 +0800

Each generation of MGLRU accounts anon and file folio numbers separately,
and the page table walker updates each generation's counters in batch once
the walk is done.  The walker promotes a folio's generation with a cmpxchg
on folio->flags, and update_batch_size() then reads the live flags again
to pick the anon/file column to charge.  The walk holds neither the lruvec
lock nor the folio lock, so the type can flip between the cmpxchg and that
read: the lazyfree path clears PG_swapbacked, and reclaim sets it back on
a dirty lazyfree folio.  The batched delta pair is then recorded in the
wrong type column.  Nothing reconciles it afterwards, permanently skewing
lrugen->nr_pages and the reclaim budgets derived from it.

Fix it by capturing the type from the flags snapshot the cmpxchg
linearized against: folio_update_gen() returns the type of the state it
transitioned from, and update_batch_size() accounts with that.

A folio's type only changes while it is off the LRU list, inside a del/add
pair under the lruvec lock, with the gen bits cleared in between.  The
generation and PG_swapbacked sit in the same folio->flags word, so the
cmpxchg snapshot captures them together.  Let G be the generation that
snapshot captured (old_gen) and G' the one it wrote (new_gen); the CAS can
land in only three places:

  - before the del: the folio is anon at G; the batch records anon
    G -> G', and the del later removes the folio from the anon
    counters;
  - between del and add: gen == -1, so folio_update_gen() returns -1
    without touching the flags and no batch is recorded; the del/add
    pair accounts for the move alone;
  - after the add: the folio is file at the fresh generation the add
    charged; the batch records file, that gen -> G', matching that
    charge.

Unlike the drift of lazy promotions, which sort_folio() repairs under the
lruvec lock, the phantom deltas from before this fix land in a column the
folio never occupies again, so nothing ever repairs them.

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-6-9aacbd77d4ca@tencent.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
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

 include/linux/mm_inline.h |   11 +++++++++++
 mm/vmscan.c               |   13 +++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-fix-potential-generation-folio-number-leak
+++ a/include/linux/mm_inline.h
@@ -30,6 +30,17 @@ static inline int folio_is_file_lru(cons
 	return !folio_test_swapbacked(folio);
 }
 
+/**
+ * folio_flags_is_file_lru - Should the folio be on a file LRU or anon LRU?
+ * @flags: The folio's flags.
+ *
+ * Just like folio_is_file_lru but take the folio flags directly instead.
+ */
+static inline int folio_flags_is_file_lru(const unsigned long *flags)
+{
+	return !test_bit(PG_swapbacked, flags);
+}
+
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
--- a/mm/vmscan.c~mm-mglru-fix-potential-generation-folio-number-leak
+++ a/mm/vmscan.c
@@ -3294,7 +3294,8 @@ static bool positive_ctrl_err(struct ctr
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, int *type,
+			    const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int old_gen;
@@ -3323,6 +3324,7 @@ static int folio_update_gen(struct folio
 		new_flags |= BIT(PG_workingset);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
+	*type = folio_flags_is_file_lru(&old_flags);
 	return old_gen;
 }
 
@@ -3368,9 +3370,8 @@ static int folio_inc_gen(struct lruvec *
 }
 
 static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int old_gen, int new_gen)
+			      int old_gen, int new_gen, int type)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 
@@ -3559,7 +3560,7 @@ static bool suitable_to_scan(int total,
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
 		struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int new_gen, old_gen;
+	int new_gen, old_gen, type;
 
 	if (!folio)
 		return;
@@ -3572,9 +3573,9 @@ static void walk_update_folio(struct lru
 		folio_mark_dirty(folio);
 
 	if (walk) {
-		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
+		old_gen = folio_update_gen(folio, new_gen, &type, &vma->flags);
 		if (old_gen >= 0 && old_gen != new_gen)
-			update_batch_size(walk, folio, old_gen, new_gen);
+			update_batch_size(walk, folio, old_gen, new_gen, type);
 	} else if (lru_gen_set_refs(folio, &vma->flags)) {
 		old_gen = folio_lru_gen(folio);
 		if (old_gen >= 0 && old_gen != new_gen)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

