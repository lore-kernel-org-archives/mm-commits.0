Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793322874;
	b=lxWboiAh4t26PepzwJtlvPKfimUNCTKTCA2R9ObF3bmNDSwoVtH6K1yQO2iFtsyQ4Mcu
	 2J1hz5+LshzhzXbqOknU6a28Cg3kTX0GrnhRlsf3/cKqf0kiAKvhW8lQieSiIIBpVLoVb
	 YONr0nnPU1uXQ2JneoDMEUVPZpF5Kh1vJi8KSriS3Du/cI2XUqFD/irtAs8S7DDIpAzL8
	 mZmEYKjWmD5ZNbyWQiwrESA9P9GL557ZUxVeMqpbkoHkSs7RN8dLzzDGccNbABv5ci5F/
	 06lnmnNXlzVi9IO063LOKD033ZmLQvv7a2Y6lq92IyxwePpvlceG3APW7+WortK7n0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322874;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZDW//XwdaF5+iMIwM2kIPz4R6fTA3ESlvGS1bWgy8hQ=;
	b=KLkWE2WZjVFT7I0XmUlFLQNSd5ytk/OEMjMvzlfSPTlZqQftHhNV0YQda56kFSpykMHn
	 0g4GgAGZ7TLOL5gNCtMpryC8/u/dM/tKhtB5HmnwhvzNWRCWQPBgzanwpKAccViJBP6Vv
	 IINBbzcKa/QuKBJrOfNlwwu1LRqJa+sdTspLDMBfwL3cUl2oyuVvPS/5evU0tTIf5GSpF
	 wTZCmx1pjMCGWwxN68KOrOqKla/viNDr9QE/d+Fm6JQATiZe6HuhC4dCopDom9/yEiPhH
	 JJpkRg+s0dZCzXgIOpl09Hds9fTr2iJrOQVgEuXIhb1YA+OKr/CT1yVRvh8NVg/5xTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y3xliqXb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF62606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y3xliqXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D09C1F000C1;
	Fri, 30 Oct 2026 01:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793322873;
	bh=ZDW//XwdaF5+iMIwM2kIPz4R6fTA3ESlvGS1bWgy8hQ=;
	h=Date:To:From:Subject;
	b=Y3xliqXb6qciVNBGzI6IJy6M5qUkPhuJJGrljj43RjUPlboHDOWkXK2XBC3ejVMQX
	 +iA3gR6qFuQSQkWgXxSpZ32ySRuGdt2Gc4BSPW9FGoSCe+NwNT802joPAW6ShsD+Lu
	 c9qYTDtcpZBWwgKsO/bX9I01RpJC1ddPbmegvv1c=
Date: Thu, 29 Oct 2026 18:14:33 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,
	weixugc@google.com,shakeel.butt@linux.dev,rlmenge@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hargar@linux.microsoft.com,hannes@cmpxchg.org,david@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,apais@microsoft.com,sidchintamaneni@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-remove-get_lruvec.patch added to mm-new branch
Message-Id: <20261030011433.6D09C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: multi-gen LRU: remove get_lruvec()
has been added to the -mm mm-new branch.  Its filename is
     mm-multi-gen-lru-remove-get_lruvec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-remove-get_lruvec.patch

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
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: mm: multi-gen LRU: remove get_lruvec()
Date: Mon, 26 Oct 2026 20:23:13 +0000

get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
After commit 09f49dca570a ("mm: handle uninitialized numa nodes
gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
checks on NODE_DATA()"), that NULL check was removed, leaving
get_lruvec() as a thin wrapper around mem_cgroup_lruvec().

Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
sites.

Link: https://lore.kernel.org/20261026202313.63122-3-sidchintamaneni@gmail.com
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <apais@microsoft.com>
Cc: <rlmenge@gmail.com>
---

 mm/vmscan.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-remove-get_lruvec
+++ a/mm/vmscan.c
@@ -2862,15 +2862,6 @@ static bool should_clear_pmd_young(void)
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
 
-static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
-{
-	struct pglist_data *pgdat = NODE_DATA(nid);
-
-	VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
-
-	return mem_cgroup_lruvec(memcg, pgdat);
-}
-
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -3063,7 +3054,7 @@ void lru_gen_add_mm(struct mm_struct *mm
 	spin_lock(&mm_list->lock);
 
 	for_each_node_state(nid, N_MEMORY) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 		/* the first addition since the last iteration */
@@ -3093,7 +3084,7 @@ void lru_gen_del_mm(struct mm_struct *mm
 	spin_lock(&mm_list->lock);
 
 	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 		/* where the current iteration continues after */
@@ -4600,7 +4591,7 @@ void lru_gen_online_memcg(struct mem_cgr
 
 	for_each_node(nid) {
 		struct pglist_data *pgdat = NODE_DATA(nid);
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 		spin_lock_irq(&pgdat->memcg_lru.lock);
 
@@ -4622,7 +4613,7 @@ void lru_gen_offline_memcg(struct mem_cg
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
 	}
@@ -4635,7 +4626,7 @@ void lru_gen_release_memcg(struct mem_cg
 
 	for_each_node(nid) {
 		struct pglist_data *pgdat = NODE_DATA(nid);
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 		spin_lock_irq(&pgdat->memcg_lru.lock);
 
@@ -4656,7 +4647,7 @@ unlock:
 
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
 {
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	int type;
 
 	for (type = 0; type < ANON_AND_FILE; type++) {
@@ -4703,7 +4694,7 @@ static void try_to_inc_max_seq_nowalk(st
  */
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
 {
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	int type;
 
 	for (type = 0; type < ANON_AND_FILE; type++) {
@@ -4780,8 +4771,8 @@ void lru_gen_reparent_memcg(struct mem_c
 	struct zone *zone;
 	enum lru_list lru;
 
-	child_lruvec = get_lruvec(memcg, nid);
-	parent_lruvec = get_lruvec(parent, nid);
+	child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
 
 	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
 		for (type = 0; type < ANON_AND_FILE; type++)
@@ -5586,7 +5577,7 @@ static void lru_gen_change_state(bool en
 		int nid;
 
 		for_each_node(nid) {
-			struct lruvec *lruvec = get_lruvec(memcg, nid);
+			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 			lruvec_lock_irq(lruvec);
 
@@ -5717,7 +5708,7 @@ static void *lru_gen_seq_start(struct se
 
 		for_each_node_state(nid, N_MEMORY) {
 			if (!nr_to_skip--)
-				return get_lruvec(memcg, nid);
+				return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
@@ -5749,7 +5740,7 @@ static void *lru_gen_seq_next(struct seq
 		nid = first_memory_node;
 	}
 
-	return get_lruvec(memcg, nid);
+	return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 }
 
 static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
@@ -5934,7 +5925,7 @@ static int run_cmd(char cmd, u64 memcg_i
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
-	lruvec = get_lruvec(memcg, nid);
+	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 	if (swappiness < MIN_SWAPPINESS)
 		swappiness = get_swappiness(lruvec, sc);
@@ -6118,7 +6109,7 @@ void lru_gen_exit_memcg(struct mem_cgrou
 	VM_WARN_ON_ONCE(mm_list && !list_empty(&mm_list->fifo));
 
 	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 		VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
_

Patches currently in -mm which might be from sidchintamaneni@gmail.com are

mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec.patch
mm-multi-gen-lru-remove-get_lruvec.patch

