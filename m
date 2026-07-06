Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F12236E0
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783381683; cv=none; b=upKAWg4rLUfUpVraCL4/DJHjNqMBfsQqUIOoo0lnpiAqw5tKV8+QKcHv75SdF5MqDtXujcPJmo9X3D7PkX2xdvyiDRy9qBS0R6iaYkEHxQq2KmabPxng1rjw/fJD6ux3wIXt7U4UzYUsIpNpZDff1FCw8FpWLUBVqrnky2LpuX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783381683; c=relaxed/simple;
	bh=Aack4p4m8qxtyCvi/By5yCoshX+L+jj7kHA+n/BH7QA=;
	h=Date:To:From:Subject:Message-Id; b=mDwTGWsxPZQcig7SPYLC9p0zj5I8S1scCRerDhOKkfpEb7BTL9FM1i30DATV1zBgmCI5rdhRzC6tkF7X40KZmMns1ltzENf+av/Uqst6U023W8sa6O3mc87tacQm2zA//V4Iw16QCEUB9Ii2Fkx7d9a7KKHjVmLl5CahNyMOAHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BG0UZPfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BG0UZPfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117A81F000E9;
	Mon,  6 Jul 2026 23:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783381681;
	bh=5qtKeCKKdAjQnXypfQa0i7V3+5APVbnqmY+w7qSZTRc=;
	h=Date:To:From:Subject;
	b=BG0UZPfkBPRRV/DGNW6P3oR2YL/pLiCopGBqE6SCKD4t91IyQPfVaQxWFSC8Vb3Ip
	 QYDECipXdRUfAPi3wtx693ATSOXOcwNAWCH4gNN427IRHccLaaR+TZJbDyV/boV31g
	 aLFfl0TLkiYFHGyCmMLbK6imXyAQxqr0lz8ho3GU=
Date: Mon, 06 Jul 2026 16:48:00 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-add-linear_page_index-into-ksm_rmap_item.patch added to mm-new branch
Message-Id: <20260706234801.117A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: add linear_page_index into ksm_rmap_item
has been added to the -mm mm-new branch.  Its filename is
     ksm-add-linear_page_index-into-ksm_rmap_item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-add-linear_page_index-into-ksm_rmap_item.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: add linear_page_index into ksm_rmap_item
Date: Fri, 3 Jul 2026 16:23:57 +0800 (CST)

Patch series "KSM: performance optimizations for rmap_walk_ksm", v11.

This series fixes a severe KSM reverse-mapping performance problem that
can freeze applications for hundreds of milliseconds under memory pressure
especially when a lot of unrelated VMAs sharing a single anon_vma.

Two key highlights:

1. Lock hold time drops from >500ms to <2ms
   - In our benchmark (20,000 VMAs sharing an anon_vma), worst-case
     anon_vma lock hold time during KSM rmap walk went from 705ms
     down to 1.67ms (max) and 1.44ms (avg).

2. Real user impact
   - The anon_vma lock is also acquired by page faults, reclaim,
     migration, compaction, mlock, exit_mmap, and cgroup accounting.

   - A long hold due to inefficient rmap walks stalls application
     threads, causing latency spikes, reduced throughput, or even
     container timeouts.

   - The problem occurs even without fork() – VMA splitting (e.g.,
     via mprotect or madvise over time) can create tens of thousands
     of VMAs all attached to the same anon_vma.

Real-world examples:

 - JVM / Go runtime: These use mmap for heap regions and later call
   mprotect(PROT_NONE) for garbage collection barriers or guard pages,
   splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers or
   anonymous mappings are managed with madvise(MADV_DONTNEED) to release
   specific pages, which also splits VMAs.

Why the benchmark numbers are realistic: We observed ~20,000 VMAs sharing
one anon_vma on a production system running a Java application with KSM
enabled.  The lock hold time before the patch was measured at 228 ms
(max) during rmap walks triggered by memory compaction and page migration.
The benchmark reproduces that VMA count and lock‑hold behavior in a
controlled environment.

For systems that do not have thousands of VMAs per anon_vma, the patch
adds negligible overhead (a single pgoff comparison).  For systems that do
suffer from this issue, the improvement is dramatic: 1) Worst‑case
anon_vma lock hold time drops from hundreds of milliseconds to under
2 ms.2)This directly reduces blocking of parallel operations that need
the same lock – page faults, reclaim, migration, compaction, mlock, and
exit_mmap.

End‑users will see lower tail latency (fewer application stalls), higher
throughput under memory pressure, and no more spurious lockup warnings or
container timeouts caused by excessive lock hold times.

In short: workloads that do not hit this pathological pattern are
unaffected; those that do will see a 100x to 500x reduction in lock hold
times, which translates directly into a more responsive system.


This patch (of 3):

As preparation for KSM rmap optimizations, let's track the original
linear_page_index() of a de-duplicated page in its ksm_rmap_item, so we
can efficiently search for the page in an address space, avoiding scanning
the entire address space.  This was previously discussed in [1, 2].

To avoid growing ksm_rmap_item, let's squeeze it into the existing
structure by overlying some members (oldchecksum, age, remaining_skips)
that are only relevant while on the unstable tree.  The new entry will
only be relevant for entries in the stable tree.

However, as the age information is read by should_skip_rmap_item() with
the smart-scanning approach even while we have an entry in the stable
tree, but the page changes (no longer a KSM page, for example due to COW),
we have to change the handling there a bit.

We'll calculate the linear page index in try_to_merge_with_ksm_page(),
when adding it to the stable tree, and reset the index (to reset overlayed
data) when removing an item from the stable tree -- in
remove_rmap_item_from_tree(), remove_node_from_stable_tree() and
break_cow().

To be specially clarified, the reason for resetting the stored index at
break_cow() is:

- When a page successfully becomes a KSM page (i.e., after
  stable_tree_append() sets STABLE_FLAG), both anon_vma and the index are
  stored and remain valid.

- However, during the merging process, there are several failure paths
  where we already prepared an rmap item to be added to the stable tree,
  but must revert that as some part of the merge process failed. Examples
  include:
    1 The second call to try_to_merge_with_ksm_page() fails in
      try_to_merge_two_pages().
    2 stable_tree_insert() fails in cmp_and_merge_page().
  In such cases, break_cow() is invoked to break the COW mapping and
  discard the KSM state.

Currently, break_cow() already contains a
put_anon_vma(rmap_item->anon_vma) to release the reference taken during
the aborted merge.  Because the index is logically paired with anon_vma
(both are only meaningful when the rmap_item is in a stable state), it
must also be cleared (or reset) in break_cow() to avoid leaving stale
linear_page_index values that could confuse subsequent rmap walks or
scanning logic.

Link: https://lore.kernel.org/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn
Link: https://lore.kernel.org/20260703162357853iIa-RP7if9hRlAIuTh5La@zte.com.cn
Link: https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/ [1]
Link: https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/ [2]
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~ksm-add-linear_page_index-into-ksm_rmap_item
+++ a/mm/ksm.c
@@ -195,22 +195,28 @@ struct ksm_stable_node {
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
- * @age: number of scan iterations since creation
- * @remaining_skips: how many scans to skip
+ * @age: number of scan iterations since creation (unstable node)
+ * @remaining_skips: how many scans to skip (unstable node)
+ * @linear_page_index: the original page's index before merged by KSM (stable node)
  */
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
 	union {
-		struct anon_vma *anon_vma;	/* when stable */
+		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
 #ifdef CONFIG_NUMA
 		int nid;		/* when node of unstable tree */
 #endif
 	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
-	unsigned int oldchecksum;	/* when unstable */
-	rmap_age_t age;
-	rmap_age_t remaining_skips;
+	union {
+		struct {
+			unsigned int oldchecksum;
+			rmap_age_t age;
+			rmap_age_t remaining_skips;
+		};			/* when unstable */
+		unsigned long linear_page_index;    /* for reverse mapping, when stable */
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -776,6 +782,11 @@ static struct vm_area_struct *find_merge
 	return vma;
 }
 
+/*
+ * break_cow: actively break COW, replacing the KSM page by a fresh anonymous
+ * page. This is called when rmap_item has not yet become stable, but page
+ * has been merged.
+ */
 static void break_cow(struct ksm_rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -787,6 +798,11 @@ static void break_cow(struct ksm_rmap_it
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
+	/*
+	 * Reset linear_page_index that might overlay age-related
+	 * information. (it's still unstable node)
+	 */
+	rmap_item->linear_page_index = 0;
 
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -899,6 +915,8 @@ static void remove_node_from_stable_tree
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset linear_page_index that might overlay age-related information. */
+		rmap_item->linear_page_index = 0;
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1052,6 +1070,8 @@ static void remove_rmap_item_from_tree(s
 		stable_node->rmap_hlist_len--;
 
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset linear_page_index that might overlay age-related information. */
+		rmap_item->linear_page_index = 0;
 		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;
 
@@ -1598,8 +1618,15 @@ static int try_to_merge_with_ksm_page(st
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);
 
-	/* Must get reference to anon_vma while still holding mmap_lock */
+	/*
+	 * We can consider the VMA only while still holding the mmap lock,
+	 * so lock, so reference the anon_vma and calculate the linear
+	 * page index early, before stable_tree_append(). If anything goes
+	 * wrong that prevents the rmap_item from being added to the
+	 * stable_tree, break_cow() will clean it up.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -2459,6 +2486,13 @@ static bool should_skip_rmap_item(struct
 	if (folio_test_ksm(folio))
 		return false;
 
+	/*
+	 * There is no age information in stable-tree nodes. We might end up
+	 * here without a KSM page for example after COW.
+	 */
+	if (rmap_item->address & STABLE_FLAG)
+		return false;
+
 	age = rmap_item->age;
 	if (age != U8_MAX)
 		rmap_item->age++;
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch

