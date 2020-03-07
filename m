From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-fallthrough.patch added to -mm tree
Date: Sat, 07 Mar 2020 13:01:29 -0800
Message-ID: <20200307210129.MbheUEC3x%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgCGVBb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 16:01:31 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@embeddedor.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use fallthrough;
has been added to the -mm tree.  Its filename is
     mm-use-fallthrough.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-fallthrough.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-fallthrough.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: use fallthrough;

Convert the various /* fallthrough */ comments to the pseudo-keyword
fallthrough;

Done via script:
https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe@perches.com/

Link: http://lkml.kernel.org/r/f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c            |    2 +-
 mm/hugetlb_cgroup.c |    6 +++---
 mm/ksm.c            |    3 +--
 mm/list_lru.c       |    2 +-
 mm/memcontrol.c     |    2 +-
 mm/mempolicy.c      |    3 ---
 mm/mmap.c           |    5 ++---
 mm/shmem.c          |    2 +-
 mm/zsmalloc.c       |    2 +-
 9 files changed, 11 insertions(+), 16 deletions(-)

--- a/mm/gup.c~mm-use-fallthrough
+++ a/mm/gup.c
@@ -1072,7 +1072,7 @@ retry:
 				goto retry;
 			case -EBUSY:
 				ret = 0;
-				/* FALLTHRU */
+				fallthrough;
 			case -EFAULT:
 			case -ENOMEM:
 			case -EHWPOISON:
--- a/mm/hugetlb_cgroup.c~mm-use-fallthrough
+++ a/mm/hugetlb_cgroup.c
@@ -468,14 +468,14 @@ static int hugetlb_cgroup_read_u64_max(s
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_RSVD_USAGE:
 		counter = &h_cg->rsvd_hugepage[idx];
-		/* Fall through. */
+		fallthrough;
 	case RES_USAGE:
 		val = (u64)page_counter_read(counter);
 		seq_printf(seq, "%llu\n", val * PAGE_SIZE);
 		break;
 	case RES_RSVD_LIMIT:
 		counter = &h_cg->rsvd_hugepage[idx];
-		/* Fall through. */
+		fallthrough;
 	case RES_LIMIT:
 		val = (u64)counter->max;
 		if (val == limit)
@@ -515,7 +515,7 @@ static ssize_t hugetlb_cgroup_write(stru
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_RSVD_LIMIT:
 		rsvd = true;
-		/* Fall through. */
+		fallthrough;
 	case RES_LIMIT:
 		mutex_lock(&hugetlb_limit_mutex);
 		ret = page_counter_set_max(
--- a/mm/ksm.c~mm-use-fallthrough
+++ a/mm/ksm.c
@@ -2813,8 +2813,7 @@ static int ksm_memory_callback(struct no
 		 */
 		ksm_check_stable_tree(mn->start_pfn,
 				      mn->start_pfn + mn->nr_pages);
-		/* fallthrough */
-
+		fallthrough;
 	case MEM_CANCEL_OFFLINE:
 		mutex_lock(&ksm_thread_mutex);
 		ksm_run &= ~KSM_RUN_OFFLINE;
--- a/mm/list_lru.c~mm-use-fallthrough
+++ a/mm/list_lru.c
@@ -223,7 +223,7 @@ restart:
 		switch (ret) {
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
-			/* fall through */
+			fallthrough;
 		case LRU_REMOVED:
 			isolated++;
 			nlru->nr_items--;
--- a/mm/memcontrol.c~mm-use-fallthrough
+++ a/mm/memcontrol.c
@@ -5781,7 +5781,7 @@ retry:
 		switch (get_mctgt_type(vma, addr, ptent, &target)) {
 		case MC_TARGET_DEVICE:
 			device = true;
-			/* fall through */
+			fallthrough;
 		case MC_TARGET_PAGE:
 			page = target.page;
 			/*
--- a/mm/mempolicy.c~mm-use-fallthrough
+++ a/mm/mempolicy.c
@@ -881,7 +881,6 @@ static void get_policy_nodemask(struct m
 
 	switch (p->mode) {
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		*nodes = p->v.nodes;
 		break;
@@ -2066,7 +2065,6 @@ bool init_nodemask_of_mempolicy(nodemask
 		break;
 
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		*mask =  mempolicy->v.nodes;
 		break;
@@ -2333,7 +2331,6 @@ bool __mpol_equal(struct mempolicy *a, s
 
 	switch (a->mode) {
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		return !!nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
--- a/mm/mmap.c~mm-use-fallthrough
+++ a/mm/mmap.c
@@ -1457,7 +1457,7 @@ unsigned long do_mmap(struct file *file,
 			 * with MAP_SHARED to preserve backward compatibility.
 			 */
 			flags &= LEGACY_MAP_MASK;
-			/* fall through */
+			fallthrough;
 		case MAP_SHARED_VALIDATE:
 			if (flags & ~flags_mask)
 				return -EOPNOTSUPP;
@@ -1484,8 +1484,7 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
-
-			/* fall through */
+			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
 				return -EACCES;
--- a/mm/shmem.c~mm-use-fallthrough
+++ a/mm/shmem.c
@@ -3992,7 +3992,7 @@ bool shmem_huge_enabled(struct vm_area_s
 			if (i_size >= HPAGE_PMD_SIZE &&
 					i_size >> PAGE_SHIFT >= off)
 				return true;
-			/* fall through */
+			fallthrough;
 		case SHMEM_HUGE_ADVISE:
 			/* TODO: implement fadvise() hints */
 			return (vma->vm_flags & VM_HUGEPAGE);
--- a/mm/zsmalloc.c~mm-use-fallthrough
+++ a/mm/zsmalloc.c
@@ -424,7 +424,7 @@ static void *zs_zpool_map(void *pool, un
 	case ZPOOL_MM_WO:
 		zs_mm = ZS_MM_WO;
 		break;
-	case ZPOOL_MM_RW: /* fall through */
+	case ZPOOL_MM_RW:
 	default:
 		zs_mm = ZS_MM_RW;
 		break;
_

Patches currently in -mm which might be from joe@perches.com are

mm-use-fallthrough.patch
string-add-stracpy-and-stracpy_pad-mechanisms.patch
checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
checkpatch-prefer-fallthrough-over-fallthrough-comments.patch
checkpatch-improve-gerrit-change-id-test.patch
