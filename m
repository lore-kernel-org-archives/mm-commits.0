Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873AEEEDD
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719423735; cv=none; b=TpE4u3Ef4hjIOTjnPiggvpxQAZhljDXkdDY5la7A0aqJ+HMiGjcfL0WLBJKiDmfAXb6jhVlQoXSKhxwtIFSJ4WKxh9E1AhzUy+SwOX8IzN9Tx1eEoIA6QrbOAt5wSKjWK7yKy7xFG/Hi02dDaJV7FscGXHoGLgzCTHsaunznC40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719423735; c=relaxed/simple;
	bh=ZhmWlj2laawO8w/UU2N25BZC4utUIucKfPvbaZzvYuM=;
	h=Date:To:From:Subject:Message-Id; b=fw6ErsoHle03m0EkeE1mBtHKYjAd+iDnsc2s+wGiKVshj0x/OUA/ecV6kn8FoF7gIdHGqrWGe+fP/ulMJGxOOSTj9NE5yDWuTZ92aAMkiXquIxMHbb0Wa/zqDQMjbUjXH92iPa3SjDzeYM6NpFQBIB6jYeO+7vygofV49MOBWWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IqcLxOTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IqcLxOTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0674DC116B1;
	Wed, 26 Jun 2024 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719423735;
	bh=ZhmWlj2laawO8w/UU2N25BZC4utUIucKfPvbaZzvYuM=;
	h=Date:To:From:Subject:From;
	b=IqcLxOTmQdlp/sIzM61q5TFn4sCb/vAHg1GIn37FgaX4+2ForZQCS7B+6A7x8uxav
	 34s44c2hRzi3q5EOY/9JOyTpBAqukaUVuci75vu1WPBzhP5zDCx6WOBxoM4s+6r6CN
	 pWhDk1sLZYrAq2xMVlxMjrF28Tk034shzZyZ3McU=
Date: Wed, 26 Jun 2024 10:42:14 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,wangkefeng.wang@huawei.com,tj@kernel.org,shakeel.butt@linux.dev,shakeelb@google.com,roman.gushchin@linux.dev,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,findns94@gmail.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,schatzberg.dan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-swapiness=-arg-to-memoryreclaim.patch added to mm-unstable branch
Message-Id: <20240626174215.0674DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add swappiness= arg to memory.reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-swapiness=-arg-to-memoryreclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-swapiness=-arg-to-memoryreclaim.patch

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
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: mm: add swappiness= arg to memory.reclaim
Date: Wed, 3 Jan 2024 08:48:37 -0800

Allow proactive reclaimers to submit an additional swappiness=<val>
argument to memory.reclaim.  This overrides the global or per-memcg
swappiness setting for that reclaim attempt.

For example:

echo "2M swappiness=0" > /sys/fs/cgroup/memory.reclaim

will perform reclaim on the rootcg with a swappiness setting of 0 (no
swap) regardless of the vm.swappiness sysctl setting.

Userspace proactive reclaimers use the memory.reclaim interface to trigger
reclaim.  The memory.reclaim interface does not allow for any way to
effect the balance of file vs anon during proactive reclaim.  The only
approach is to adjust the vm.swappiness setting.  However, there are a few
reasons we look to control the balance of file vs anon during proactive
reclaim, separately from reactive reclaim:

* Swapout should be limited to manage SSD write endurance.  In near-OOM
  situations we are fine with lots of swap-out to avoid OOMs.  As these
  are typically rare events, they have relatively little impact on write
  endurance.  However, proactive reclaim runs continuously and so its
  impact on SSD write endurance is more significant.  Therefore it is
  desireable to control swap-out for proactive reclaim separately from
  reactive reclaim

* Some userspace OOM killers like systemd-oomd[1] support OOM killing on
  swap exhaustion.  This makes sense if the swap exhaustion is triggered
  due to reactive reclaim but less so if it is triggered due to proactive
  reclaim (e.g.  one could see OOMs when free memory is ample but anon is
  just particularly cold).  Therefore, it's desireable to have proactive
  reclaim reduce or stop swap-out before the threshold at which OOM
  killing occurs.

In the case of Meta's Senpai proactive reclaimer, we adjust vm.swappiness
before writes to memory.reclaim[2].  This has been in production for
nearly two years and has addressed our needs to control proactive vs
reactive reclaim behavior but is still not ideal for a number of reasons:

* vm.swappiness is a global setting, adjusting it can race/interfere
  with other system administration that wishes to control vm.swappiness. 
  In our case, we need to disable Senpai before adjusting vm.swappiness.

* vm.swappiness is stateful - so a crash or restart of Senpai can leave
  a misconfigured setting.  This requires some additional management to
  record the "desired" setting and ensure Senpai always adjusts to it.

With this patch, we avoid these downsides of adjusting vm.swappiness
globally.

[1]https://www.freedesktop.org/software/systemd/man/latest/systemd-oomd.service.html
[2]https://github.com/facebookincubator/oomd/blob/main/src/oomd/plugins/Senpai.cpp#L585-L598

Link: https://lkml.kernel.org/r/20240103164841.2800183-3-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yue Zhao <findns94@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   18 ++++---
 include/linux/swap.h                    |    3 -
 mm/memcontrol-v1.c                      |    4 -
 mm/memcontrol.c                         |   53 ++++++++++++++++++----
 mm/vmscan.c                             |   25 +++++++++-
 5 files changed, 81 insertions(+), 22 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-swapiness=-arg-to-memoryreclaim
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1299,17 +1299,10 @@ PAGE_SIZE multiple when read back.
 	This is a simple interface to trigger memory reclaim in the
 	target cgroup.
 
-	This file accepts a single key, the number of bytes to reclaim.
-	No nested keys are currently supported.
-
 	Example::
 
 	  echo "1G" > memory.reclaim
 
-	The interface can be later extended with nested keys to
-	configure the reclaim behavior. For example, specify the
-	type of memory to reclaim from (anon, file, ..).
-
 	Please note that the kernel can over or under reclaim from
 	the target cgroup. If less bytes are reclaimed than the
 	specified amount, -EAGAIN is returned.
@@ -1321,6 +1314,17 @@ PAGE_SIZE multiple when read back.
 	This means that the networking layer will not adapt based on
 	reclaim induced by memory.reclaim.
 
+The following nested keys are defined.
+
+	  ==========            ================================
+	  swappiness            Swappiness value to reclaim with
+	  ==========            ================================
+
+	Specifying a swappiness value instructs the kernel to perform
+	the reclaim with that swappiness value. Note that this has the
+	same semantics as vm.swappiness applied to memcg reclaim with
+	all the existing limitations and potential future extensions.
+
   memory.peak
 	A read-only single value file which exists on non-root
 	cgroups.
--- a/include/linux/swap.h~mm-add-swapiness=-arg-to-memoryreclaim
+++ a/include/linux/swap.h
@@ -410,7 +410,8 @@ extern unsigned long try_to_free_pages(s
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
-						  unsigned int reclaim_options);
+						  unsigned int reclaim_options,
+						  int *swappiness);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
--- a/mm/memcontrol.c~mm-add-swapiness=-arg-to-memoryreclaim
+++ a/mm/memcontrol.c
@@ -48,6 +48,7 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/parser.h>
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
 #include <linux/mm_inline.h>
@@ -1921,7 +1922,8 @@ static unsigned long reclaim_high(struct
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
-							MEMCG_RECLAIM_MAY_SWAP);
+							MEMCG_RECLAIM_MAY_SWAP,
+							NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2227,7 +2229,7 @@ retry:
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options);
+						    gfp_mask, reclaim_options, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4135,7 +4137,7 @@ static ssize_t memory_high_write(struct
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -4184,7 +4186,7 @@ static ssize_t memory_max_write(struct k
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
 				nr_reclaims--;
 			continue;
 		}
@@ -4314,19 +4316,50 @@ static ssize_t memory_oom_group_write(st
 	return nbytes;
 }
 
+enum {
+	MEMORY_RECLAIM_SWAPPINESS = 0,
+	MEMORY_RECLAIM_NULL,
+};
+
+static const match_table_t tokens = {
+	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
+	{ MEMORY_RECLAIM_NULL, NULL },
+};
+
 static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	int swappiness = -1;
 	unsigned int reclaim_options;
-	int err;
+	char *old_buf, *start;
+	substring_t args[MAX_OPT_ARGS];
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "", &nr_to_reclaim);
-	if (err)
-		return err;
+
+	old_buf = buf;
+	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
+	if (buf == old_buf)
+		return -EINVAL;
+
+	buf = strstrip(buf);
+
+	while ((start = strsep(&buf, " ")) != NULL) {
+		if (!strlen(start))
+			continue;
+		switch (match_token(start, tokens, args)) {
+		case MEMORY_RECLAIM_SWAPPINESS:
+			if (match_int(&args[0], &swappiness))
+				return -EINVAL;
+			if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
+				return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
 
 	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
 	while (nr_reclaimed < nr_to_reclaim) {
@@ -4346,7 +4379,9 @@ static ssize_t memory_reclaim(struct ker
 			lru_add_drain_all();
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-					batch_size, GFP_KERNEL, reclaim_options);
+					batch_size, GFP_KERNEL,
+					reclaim_options,
+					swappiness == -1 ? NULL : &swappiness);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
--- a/mm/memcontrol-v1.c~mm-add-swapiness=-arg-to-memoryreclaim
+++ a/mm/memcontrol-v1.c
@@ -2241,7 +2241,7 @@ static int mem_cgroup_resize_max(struct
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -2273,7 +2273,7 @@ static int mem_cgroup_force_empty(struct
 			return -EINTR;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP))
+						  MEMCG_RECLAIM_MAY_SWAP, NULL))
 			nr_retries--;
 	}
 
--- a/mm/vmscan.c~mm-add-swapiness=-arg-to-memoryreclaim
+++ a/mm/vmscan.c
@@ -92,6 +92,11 @@ struct scan_control {
 	unsigned long	anon_cost;
 	unsigned long	file_cost;
 
+#ifdef CONFIG_MEMCG
+	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
+	int *proactive_swappiness;
+#endif
+
 	/* Can active folios be deactivated as part of reclaim? */
 #define DEACTIVATE_ANON 1
 #define DEACTIVATE_FILE 2
@@ -236,6 +241,13 @@ static bool writeback_throttling_sane(st
 #endif
 	return false;
 }
+
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	if (sc->proactive && sc->proactive_swappiness)
+		return *sc->proactive_swappiness;
+	return mem_cgroup_swappiness(memcg);
+}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -251,6 +263,11 @@ static bool writeback_throttling_sane(st
 {
 	return true;
 }
+
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	return READ_ONCE(vm_swappiness);
+}
 #endif
 
 static void set_task_reclaim_state(struct task_struct *task,
@@ -2351,7 +2368,7 @@ static void get_scan_count(struct lruvec
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	unsigned long anon_cost, file_cost, total_cost;
-	int swappiness = mem_cgroup_swappiness(memcg);
+	int swappiness = sc_swappiness(sc, memcg);
 	u64 fraction[ANON_AND_FILE];
 	u64 denominator = 0;	/* gcc */
 	enum scan_balance scan_balance;
@@ -2632,7 +2649,7 @@ static int get_swappiness(struct lruvec
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return mem_cgroup_swappiness(memcg);
+	return sc_swappiness(sc, memcg);
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -6549,12 +6566,14 @@ unsigned long mem_cgroup_shrink_node(str
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   unsigned int reclaim_options)
+					   unsigned int reclaim_options,
+					   int *swappiness)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
+		.proactive_swappiness = swappiness,
 		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.reclaim_idx = MAX_NR_ZONES - 1,
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

mm-add-defines-for-min-max-swappiness.patch
mm-add-swapiness=-arg-to-memoryreclaim.patch

