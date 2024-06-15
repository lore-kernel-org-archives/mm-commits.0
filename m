Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31E71FBA
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 01:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718413612; cv=none; b=e/SB6gPqeXtZbwwlpV5cLuKDTXoNmJmc/0ZMnaolWJHGlsUUfeNJrAqWfVFyJhZzI/GIMN6o8bSMsc7MgI8qWuXhDxiBEwtpCvh5L5iJ1BNJ1hvl659iamgii2gXzyT8bWDGNneQiQM9NEsi+ySHl65D7RlGKKlX4ymsxoAZtjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718413612; c=relaxed/simple;
	bh=w0BYSw/2UayLRUFJTNDfYNG6H2CEBamjW0wf/T+aY9c=;
	h=Date:To:From:Subject:Message-Id; b=IcIbydh6askdvfWy7yeGAr5MLUsSUa+frnF6VrPoXcWkT7QaHytMSQUebeih9Y1OAYy3+bn9tYeMDH3z6XCFgPOvz/uaDT48QAirUQGbbLAi9TsQKpf0cSm5u0TJpVIn3W+04Gtb96C2Xk7f/k2k8f/fDPR+3xfkRTUgmkurao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=An7BOhJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="An7BOhJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EBCC2BD10;
	Sat, 15 Jun 2024 01:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718413612;
	bh=w0BYSw/2UayLRUFJTNDfYNG6H2CEBamjW0wf/T+aY9c=;
	h=Date:To:From:Subject:From;
	b=An7BOhJmvkmM2RFuor9ZX7CVHow/oxRBinzyUPkgWYFVxcgpaKbdgVKLRGcva+U8C
	 /CS3RpCl8b3u3KPCArq0ZPfOP2MYNvFPN0D6Pu0fWt4/agNf4OUGNZL7xlJU0RJdZU
	 bZmKRczqnocpZnGpIRZhwIO29q9mlsBvCv8aEJ30=
Date: Fri, 14 Jun 2024 18:06:51 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,21cnbao@gmail.com,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-mthp-allocate-swap-entries-from-nonfull-list.patch added to mm-unstable branch
Message-Id: <20240615010652.78EBCC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: mTHP allocate swap entries from nonfull list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-mthp-allocate-swap-entries-from-nonfull-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-mthp-allocate-swap-entries-from-nonfull-list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: mm: swap: mTHP allocate swap entries from nonfull list
Date: Fri, 14 Jun 2024 16:48:08 -0700

Track the nonfull cluster as well as the empty cluster on lists.  Each
order has one nonfull cluster list.

The cluster will remember which order it was used during new cluster
allocation.

When the cluster has free entry, add to the nonfull[order] list. 
Allocation use the nonfull cluster list before using the the free cluster
list.

This improves the mTHP swap allocation success rate.

There are limitations if the distribution of numbers of different orders
of mTHP changes a lot.  e.g.  there are a lot of nonfull cluster assign to
order A while later time there are a lot of order B allocation while very
little allocation in order A.  Currently the cluster used by order A will
not reused by order B unless the cluster is 100% empty.

Link: https://lkml.kernel.org/r/20240614-swap-allocator-v2-2-2a513b4a7f2f@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 +++++--
 mm/swapfile.c        |   49 ++++++++++++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-swap-mthp-allocate-swap-entries-from-nonfull-list
+++ a/include/linux/swap.h
@@ -245,18 +245,21 @@ enum {
  */
 struct swap_cluster_info {
 	spinlock_t lock;	/*
-				 * Protect swap_cluster_info count and state
-				 * field and swap_info_struct->swap_map
+				 * Protect swap_cluster_info bitfields
+				 * and swap_info_struct->swap_map
 				 * elements correspond to the swap
 				 * cluster
 				 */
 	unsigned int count:12;
 	unsigned int state:3;
+	unsigned int order:4;
 	struct list_head list;	/* Protected by swap_info_struct->lock */
 };
 
 #define CLUSTER_STATE_FREE	1 /* This cluster is free */
 #define CLUSTER_STATE_PER_CPU	2 /* This cluster on per_cpu_cluster  */
+#define CLUSTER_STATE_SCANNED	3 /* This cluster off per_cpu_cluster */
+#define CLUSTER_STATE_NONFULL	4 /* This cluster is on nonfull list */
 
 
 /*
@@ -295,6 +298,8 @@ struct swap_info_struct {
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
+	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
+					/* list of cluster that contains at least one free slot */
 	unsigned int lowest_bit;	/* index of first free in swap_map */
 	unsigned int highest_bit;	/* index of last free in swap_map */
 	unsigned int pages;		/* total of usable pages of swap */
--- a/mm/swapfile.c~mm-swap-mthp-allocate-swap-entries-from-nonfull-list
+++ a/mm/swapfile.c
@@ -361,8 +361,12 @@ static void swap_cluster_schedule_discar
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
+	if (ci->state == CLUSTER_STATE_NONFULL)
+		list_move_tail(&ci->list, &si->free_clusters);
+	else
+		list_add_tail(&ci->list, &si->free_clusters);
 	ci->state = CLUSTER_STATE_FREE;
-	list_add_tail(&ci->list, &si->free_clusters);
+	ci->order = 0;
 }
 
 /*
@@ -484,7 +488,12 @@ static void dec_cluster_info_page(struct
 	ci->count--;
 
 	if (!ci->count)
-		free_cluster(p, ci);
+		return free_cluster(p, ci);
+
+	if (ci->state == CLUSTER_STATE_SCANNED) {
+		list_add_tail(&ci->list, &p->nonfull_clusters[ci->order]);
+		ci->state = CLUSTER_STATE_NONFULL;
+	}
 }
 
 /*
@@ -535,17 +544,25 @@ static bool scan_swap_map_try_ssd_cluste
 	unsigned int nr_pages = 1 << order;
 	struct percpu_cluster *cluster;
 	struct swap_cluster_info *ci;
-	unsigned int tmp, max;
+	unsigned int tmp, max, found = 0;
 
 new_cluster:
 	cluster = this_cpu_ptr(si->percpu_cluster);
 	tmp = cluster->next[order];
 	if (tmp == SWAP_NEXT_INVALID) {
-		if (!list_empty(&si->free_clusters)) {
+		if (!list_empty(&si->nonfull_clusters[order])) {
+			ci = list_first_entry(&si->nonfull_clusters[order], struct swap_cluster_info, list);
+			list_del(&ci->list);
+			spin_lock(&ci->lock);
+			ci->state = CLUSTER_STATE_PER_CPU;
+			spin_unlock(&ci->lock);
+			tmp = (ci - si->cluster_info) * SWAPFILE_CLUSTER;
+		} else if (!list_empty(&si->free_clusters)) {
 			ci = list_first_entry(&si->free_clusters, struct swap_cluster_info, list);
 			list_del(&ci->list);
 			spin_lock(&ci->lock);
 			ci->state = CLUSTER_STATE_PER_CPU;
+			ci->order = order;
 			spin_unlock(&ci->lock);
 			tmp = (ci - si->cluster_info) * SWAPFILE_CLUSTER;
 		} else if (!list_empty(&si->discard_clusters)) {
@@ -570,21 +587,24 @@ new_cluster:
 	max = min_t(unsigned long, si->max, ALIGN(tmp + 1, SWAPFILE_CLUSTER));
 	if (tmp < max) {
 		ci = lock_cluster(si, tmp);
-		while (tmp < max) {
+		while (!found && tmp < max) {
 			if (swap_range_empty(si->swap_map, tmp, nr_pages))
-				break;
+				found = tmp;
 			tmp += nr_pages;
 		}
+		if (tmp >= max) {
+			ci->state = CLUSTER_STATE_SCANNED;
+			cluster->next[order] = SWAP_NEXT_INVALID;
+		} else
+			cluster->next[order] = tmp;
+		WARN_ONCE(ci->order != order, "expecting order %d got %d", order, ci->order);
 		unlock_cluster(ci);
 	}
-	if (tmp >= max) {
-		cluster->next[order] = SWAP_NEXT_INVALID;
+	if (!found)
 		goto new_cluster;
-	}
-	*offset = tmp;
-	*scan_base = tmp;
-	tmp += nr_pages;
-	cluster->next[order] = tmp < max ? tmp : SWAP_NEXT_INVALID;
+
+	*offset = found;
+	*scan_base = found;
 	return true;
 }
 
@@ -2896,6 +2916,9 @@ static int setup_swap_map_and_extents(st
 	INIT_LIST_HEAD(&p->free_clusters);
 	INIT_LIST_HEAD(&p->discard_clusters);
 
+	for (i = 0; i < SWAP_NR_ORDERS; i++)
+		INIT_LIST_HEAD(&p->nonfull_clusters[i]);
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 		if (page_nr == 0 || page_nr > swap_header->info.last_page)
_

Patches currently in -mm which might be from chrisl@kernel.org are

mm-swap-swap-cluster-switch-to-double-link-list.patch
mm-swap-mthp-allocate-swap-entries-from-nonfull-list.patch

