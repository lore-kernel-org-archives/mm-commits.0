Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D11338AC88
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787959073; cv=none; b=nMxOvaWr1jgbayJhBViA6AYY61OnEJovYYpOM9qGxFyxs/r6d0yjdWp26udVz5tW5aoMfAYk+/mxFnhxnF3XxS+YDJUtu5UalT2US0d26qpPb7IJQ5FQlnZyQXXlgOIkjd4JRv9/h6/mO3CM2m6yePpcvnaXBzkTBI6zn8+WtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787959073; c=relaxed/simple;
	bh=XJ0DDbvRh0gWy8lOQVtFXpsocWWYUAELD35TdZeq85I=;
	h=Date:To:From:Subject:Message-Id; b=EwttqjugHP/k9T8YgxEbD0puxXxig+tkvuaK3/2a2xZ2j0FRkAnrxhWUhuPSDo5m2Qvu+yHWeDrnWKoOcKlUVlQxafJPew0hnnUNv1F4kxytGGxWd/SsF9O8hjkfQb9HMcwNXyHPmBrCIWnHYmhmIRTaDhxxVwyvoUUQSryh8ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e/8a5bmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e/8a5bmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2391F000E9;
	Fri, 28 Aug 2026 23:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787959072;
	bh=ggLQHTbUH0Ai7e85mPwPqTIh4w1BMjSDhuR+4d7XdlA=;
	h=Date:To:From:Subject;
	b=e/8a5bmmbT7MZ0IVQ7FBJpDOdkRaEni+LGa30e1RotZIpAEnNp6B2ZLv0rps41xO8
	 yGCCyzcBoYVF+MYA1k2egGKLPogZBvEzyqNZNTCbDpWKabj5LctHtrfUFq7hgtW1ja
	 e9JIkfNcCpTJ3B9hgiTQ8wgmEqBU1LxnCogq0lPs=
Date: Fri, 28 Aug 2026 16:17:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-potential-generation-folio-number-leak.patch added to mm-new branch
Message-Id: <20260828231751.EB2391F000E9@smtp.kernel.org>
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
Date: Wed, 26 Aug 2026 01:53:39 +0800

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

Link: https://lore.kernel.org/20260826-mglru-flags-cleanup-v3-6-d9f1c75549c8@tencent.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

 include/linux/mm_inline.h |    7 ++++++-
 mm/vmscan.c               |   13 +++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-fix-potential-generation-folio-number-leak
+++ a/include/linux/mm_inline.h
@@ -10,6 +10,11 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/leafops.h>
 
+static inline int folio_flags_is_file_lru(const unsigned long *flags)
+{
+	return !test_bit(PG_swapbacked, flags);
+}
+
 /**
  * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
  * @folio: The folio to test.
@@ -27,7 +32,7 @@
  */
 static inline int folio_is_file_lru(const struct folio *folio)
 {
-	return !folio_test_swapbacked(folio);
+	return folio_flags_is_file_lru(const_folio_flags(folio, 0));
 }
 
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
--- a/mm/vmscan.c~mm-mglru-fix-potential-generation-folio-number-leak
+++ a/mm/vmscan.c
@@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctr
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, int *is_file,
+			    const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int old_gen;
@@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio
 		new_flags |= BIT(PG_workingset);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
+	*is_file = folio_flags_is_file_lru(&old_flags);
 	return old_gen;
 }
 
@@ -3328,9 +3330,8 @@ static int folio_inc_gen(struct lruvec *
 }
 
 static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int old_gen, int new_gen)
+			      int old_gen, int new_gen, int type)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 
@@ -3519,7 +3520,7 @@ static bool suitable_to_scan(int total,
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
 		struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int new_gen, old_gen;
+	int new_gen, old_gen, file;
 
 	if (!folio)
 		return;
@@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru
 		folio_mark_dirty(folio);
 
 	if (walk) {
-		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
+		old_gen = folio_update_gen(folio, new_gen, &file, &vma->flags);
 		if (old_gen >= 0 && old_gen != new_gen)
-			update_batch_size(walk, folio, old_gen, new_gen);
+			update_batch_size(walk, folio, old_gen, new_gen, file);
 	} else if (lru_gen_set_refs(folio, &vma->flags)) {
 		old_gen = folio_lru_gen(folio);
 		if (old_gen >= 0 && old_gen != new_gen)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-make-lru_zone_size-atomic-and-simplify-sanity-check.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

