From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 088/166] mm: use fallthrough;
Date: Mon, 06 Apr 2020 20:08:39 -0700
Message-ID: <20200407030839.2vw2YSSgQ%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgDGDIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:41 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gustavo@embeddedor.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -1102,7 +1102,7 @@ retry:
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
@@ -467,14 +467,14 @@ static int hugetlb_cgroup_read_u64_max(s
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
@@ -514,7 +514,7 @@ static ssize_t hugetlb_cgroup_write(stru
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
@@ -5813,7 +5813,7 @@ retry:
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
@@ -1460,7 +1460,7 @@ unsigned long do_mmap(struct file *file,
 			 * with MAP_SHARED to preserve backward compatibility.
 			 */
 			flags &= LEGACY_MAP_MASK;
-			/* fall through */
+			fallthrough;
 		case MAP_SHARED_VALIDATE:
 			if (flags & ~flags_mask)
 				return -EOPNOTSUPP;
@@ -1487,8 +1487,7 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
