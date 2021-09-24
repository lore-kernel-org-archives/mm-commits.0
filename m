Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFC4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F5AB61250
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348351AbhIXUIC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348349AbhIXUIB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E37A261242;
        Fri, 24 Sep 2021 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632513988;
        bh=7e1ujAG3UoXO71ivGMP6rkm+duLAr92GAIX++SBLJCQ=;
        h=Date:From:To:Subject:From;
        b=MIhrSa+RSnzn03Mw7j1nXDchtNcCiKqBF8/b3eE++pF3+aRo3W0jeAE/M6Y5606ec
         zVbXHCE88UT3DO4lFoyrCfCs/hoBGKaB7F8iDf7y582RETrXkoI5gToIxC4KujSjFK
         kC8lx2JqyjlYZSZKWcO2SYDzLRHP0meTiPoHXHe0=
Date:   Fri, 24 Sep 2021 13:06:27 -0700
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, hannes@cmpxchg.org, lizefan.x@bytedance.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-detect-allocation-forbidden-by-cpuset-and-?=
 =?US-ASCII?Q?bail-out-early.patch?= added to -mm tree
Message-ID: <20210924200627.GbijaOPJl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: detect allocation forbidden by cpuset and bail out early
has been added to the -mm tree.  Its filename is
     mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/page_alloc: detect allocation forbidden by cpuset and bail out early

There was a report that starting an Ubuntu in docker while using cpuset to
bind it to movable nodes (a node only has movable zone, like a node for
hotplug or a Persistent Memory node in normal usage) will fail due to
memory allocation failure, and then OOM is involved and many other
innocent processes got killed.  It can be reproduced with command: $docker
run -it --rm --cpuset-mems 4 ubuntu:latest bash -c "grep Mems_allowed
/proc/self/status" (node 4 is a movable node)

  runc:[2:INIT] invoked oom-killer: gfp_mask=0x500cc2(GFP_HIGHUSER|__GFP_ACCOUNT), order=0, oom_score_adj=0
  CPU: 8 PID: 8291 Comm: runc:[2:INIT] Tainted: G        W I E     5.8.2-0.g71b519a-default #1 openSUSE Tumbleweed (unreleased)
  Hardware name: Dell Inc. PowerEdge R640/0PHYDR, BIOS 2.6.4 04/09/2020
  Call Trace:
   dump_stack+0x6b/0x88
   dump_header+0x4a/0x1e2
   oom_kill_process.cold+0xb/0x10
   out_of_memory.part.0+0xaf/0x230
   out_of_memory+0x3d/0x80
   __alloc_pages_slowpath.constprop.0+0x954/0xa20
   __alloc_pages_nodemask+0x2d3/0x300
   pipe_write+0x322/0x590
   new_sync_write+0x196/0x1b0
   vfs_write+0x1c3/0x1f0
   ksys_write+0xa7/0xe0
   do_syscall_64+0x52/0xd0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

  Mem-Info:
  active_anon:392832 inactive_anon:182 isolated_anon:0
   active_file:68130 inactive_file:151527 isolated_file:0
   unevictable:2701 dirty:0 writeback:7
   slab_reclaimable:51418 slab_unreclaimable:116300
   mapped:45825 shmem:735 pagetables:2540 bounce:0
   free:159849484 free_pcp:73 free_cma:0
  Node 4 active_anon:1448kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:0kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB all_unreclaimable? no
  Node 4 Movable free:130021408kB min:9140kB low:139160kB high:269180kB reserved_highatomic:0KB active_anon:1448kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:130023424kB managed:130023424kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:292kB local_pcp:84kB free_cma:0kB
  lowmem_reserve[]: 0 0 0 0 0
  Node 4 Movable: 1*4kB (M) 0*8kB 0*16kB 1*32kB (M) 0*64kB 0*128kB 1*256kB (M) 1*512kB (M) 1*1024kB (M) 0*2048kB 31743*4096kB (M) = 130021156kB

  oom-kill:constraint=CONSTRAINT_CPUSET,nodemask=(null),cpuset=docker-9976a269caec812c134fa317f27487ee36e1129beba7278a463dd53e5fb9997b.scope,mems_allowed=4,global_oom,task_memcg=/system.slice/containerd.service,task=containerd,pid=4100,uid=0
  Out of memory: Killed process 4100 (containerd) total-vm:4077036kB, anon-rss:51184kB, file-rss:26016kB, shmem-rss:0kB, UID:0 pgtables:676kB oom_score_adj:0
  oom_reaper: reaped process 8248 (docker), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
  oom_reaper: reaped process 2054 (node_exporter), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
  oom_reaper: reaped process 1452 (systemd-journal), now anon-rss:0kB, file-rss:8564kB, shmem-rss:4kB
  oom_reaper: reaped process 2146 (munin-node), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
  oom_reaper: reaped process 8291 (runc:[2:INIT]), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

The reason is, in the case, the target cpuset nodes only have movable
zone, while the creation of an OS in docker sometimes needs to allocate
memory in non-movable zones (dma/dma32/normal) like GFP_HIGHUSER, and the
cpuset limit forbids the allocation, then out-of-memory killing is
involved even when normal nodes and movable nodes both have many free
memory.

The OOM killer cannot help to resolve the situation as there is no usable
memory for the request in the cpuset scope.  The only reasonable measure
to take is to fail the allocation right away and have the caller to deal
with it.

So add a check for cases like this in the slowpath of allocation, and bail
out early returning NULL for the allocation.

As page allocation is one of the hottest path in kernel, this check will
hurt all users with sane cpuset configuration, add a static branch check
and detect the abnormal config in cpuset memory binding setup so that the
extra check cost in page allocation is not paid by everyone.

[thanks to Micho Hocko and David Rientjes for suggesting not handling
 it inside OOM code, adding cpuset check, refining comments]

Link: https://lkml.kernel.org/r/1632481657-68112-1-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   17 +++++++++++++++++
 include/linux/mmzone.h |   22 ++++++++++++++++++++++
 kernel/cgroup/cpuset.c |   23 +++++++++++++++++++++++
 mm/page_alloc.c        |   13 +++++++++++++
 4 files changed, 75 insertions(+)

--- a/include/linux/cpuset.h~mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early
+++ a/include/linux/cpuset.h
@@ -34,6 +34,8 @@
  */
 extern struct static_key_false cpusets_pre_enable_key;
 extern struct static_key_false cpusets_enabled_key;
+extern struct static_key_false cpusets_insane_config_key;
+
 static inline bool cpusets_enabled(void)
 {
 	return static_branch_unlikely(&cpusets_enabled_key);
@@ -51,6 +53,19 @@ static inline void cpuset_dec(void)
 	static_branch_dec_cpuslocked(&cpusets_pre_enable_key);
 }
 
+/*
+ * This will get enabled whenever a cpuset configuration is considered
+ * unsupportable in general. E.g. movable only node which cannot satisfy
+ * any non movable allocations (see update_nodemask). Page allocator
+ * needs to make additional checks for those configurations and this
+ * check is meant to guard those checks without any overhead for sane
+ * configurations.
+ */
+static inline bool cpusets_insane_config(void)
+{
+	return static_branch_unlikely(&cpusets_insane_config_key);
+}
+
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
@@ -167,6 +182,8 @@ static inline void set_mems_allowed(node
 
 static inline bool cpusets_enabled(void) { return false; }
 
+static inline bool cpusets_insane_config(void) { return false; }
+
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
--- a/include/linux/mmzone.h~mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early
+++ a/include/linux/mmzone.h
@@ -1220,6 +1220,28 @@ static inline struct zoneref *first_zone
 #define for_each_zone_zonelist(zone, z, zlist, highidx) \
 	for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, NULL)
 
+/* Whether the 'nodes' are all movable nodes */
+static inline bool movable_only_nodes(nodemask_t *nodes)
+{
+	struct zonelist *zonelist;
+	struct zoneref *z;
+	int nid;
+
+	if (nodes_empty(*nodes))
+		return false;
+
+	/*
+	 * We can chose arbitrary node from the nodemask to get a
+	 * zonelist as they are interlinked. We just need to find
+	 * at least one zone that can satisfy kernel allocations.
+	 */
+	nid = first_node(*nodes);
+	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
+	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
+	return (!z->zone) ? true : false;
+}
+
+
 #ifdef CONFIG_SPARSEMEM
 #include <asm/sparsemem.h>
 #endif
--- a/kernel/cgroup/cpuset.c~mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early
+++ a/kernel/cgroup/cpuset.c
@@ -69,6 +69,13 @@
 DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
 DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
 
+/*
+ * There could be abnormal cpuset configurations for cpu or memory
+ * node binding, add this key to provide a quick low-cost judgement
+ * of the situation.
+ */
+DEFINE_STATIC_KEY_FALSE(cpusets_insane_config_key);
+
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -370,6 +377,17 @@ static DECLARE_WORK(cpuset_hotplug_work,
 
 static DECLARE_WAIT_QUEUE_HEAD(cpuset_attach_wq);
 
+static inline void check_insane_mems_config(nodemask_t *nodes)
+{
+	if (!cpusets_insane_config() &&
+		movable_only_nodes(nodes)) {
+		static_branch_enable(&cpusets_insane_config_key);
+		pr_info("Unsupported (movable nodes only) cpuset configuration detected (nmask=%*pbl)!\n"
+			"Cpuset allocations might fail even with a lot of memory available.\n",
+			nodemask_pr_args(nodes));
+	}
+}
+
 /*
  * Cgroup v2 behavior is used on the "cpus" and "mems" control files when
  * on default hierarchy or when the cpuset_v2_mode flag is set by mounting
@@ -1868,6 +1886,8 @@ static int update_nodemask(struct cpuset
 	if (retval < 0)
 		goto done;
 
+	check_insane_mems_config(&trialcs->mems_allowed);
+
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
@@ -3171,6 +3191,9 @@ update_tasks:
 	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
 	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
 
+	if (mems_updated)
+		check_insane_mems_config(&new_mems);
+
 	if (is_in_v2_mode())
 		hotplug_update_tasks(cs, &new_cpus, &new_mems,
 				     cpus_updated, mems_updated);
--- a/mm/page_alloc.c~mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early
+++ a/mm/page_alloc.c
@@ -4908,6 +4908,19 @@ retry_cpuset:
 	if (!ac->preferred_zoneref->zone)
 		goto nopage;
 
+	/*
+	 * Check for insane configurations where the cpuset doesn't contain
+	 * any suitable zone to satisfy the request - e.g. non-movable
+	 * GFP_HIGHUSER allocations from MOVABLE nodes only.
+	 */
+	if (cpusets_insane_config() && (gfp_mask & __GFP_HARDWALL)) {
+		struct zoneref *z = first_zones_zonelist(ac->zonelist,
+					ac->highest_zoneidx,
+					&cpuset_current_mems_allowed);
+		if (!z->zone)
+			goto nopage;
+	}
+
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);
 
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-page_alloc-detect-allocation-forbidden-by-cpuset-and-bail-out-early.patch

