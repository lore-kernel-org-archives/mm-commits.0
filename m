Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10D521C173
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343154; cv=none; b=hGyCTfm9yO/2npGbmUAB1OHqrhxkcrgKAGkxbzT/gCgJYFdgYrC5znjDyMAHhd9DBUIKNbvT4O/N+cMYh1tyf5nRJxhn08RNigHTFAWkrD3SwRbVbjP/x8au46f1+OmxSWlkj9mmlebYPijVDysF45wJB1dXwJhHsp87h4GkCL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343154; c=relaxed/simple;
	bh=/ZqwTTng3FNphxI+JdXQ9jVEaPAkxrypXJhiFehQTho=;
	h=Date:To:From:Subject:Message-Id; b=Q6CVt5WYfdVbtb8bCvKIfMCRnGULmFlOPI9idyRi+6G5926qa7GROJmjobgnYD5+H5Q0aFc9ZZrishsdvydWD4XVMXWWJT5tI4GD6O4pRA9OSKSWXJ47tkuy3Sk6HQJrNdEU3HxvS/65Ly7sLoD2ViC6LV2j9KT87iraLGJv0/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGF28Zte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGF28Zte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A541C4CEF5;
	Mon, 17 Nov 2025 01:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343154;
	bh=/ZqwTTng3FNphxI+JdXQ9jVEaPAkxrypXJhiFehQTho=;
	h=Date:To:From:Subject:From;
	b=qGF28ZteiJK+pi7KvtGcP1duNgPe4A7K+7OWLd/fPhZ7dh8AEs+GFuizllhwHs7L2
	 x8w45yZJpIXNODN+Q8ztAfirpcq9s8aoO0A1//r1JLrXEvof5ObBffCz42MjImDm4F
	 N0p2SrsQ2bGZXQNIZm2f03NR63az9+IzaxMceRC0=
Date: Sun, 16 Nov 2025 17:32:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-document-damos_quota_goal-nid-use-case.patch removed from -mm tree
Message-Id: <20251117013234.7A541C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: document damos_quota_goal->nid use case
has been removed from the -mm tree.  Its filename was
     mm-damon-document-damos_quota_goal-nid-use-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: document damos_quota_goal->nid use case
Date: Fri, 17 Oct 2025 14:26:53 -0700

Patch series "mm/damon: allow DAMOS auto-tuned for per-memcg per-node
memory usage".

Introduce two new DAMOS quota auto-tuning target metrics for per-cgroup
per-NUMA node memory utilization.  Expected use cases are cgroup level
access-aware NUMA memory managements, such as memory tiering or proactive
reclamation on cgroup-based multi-tenant NUMA systems.

Background
==========

The aim-oriented aggressiveness auto-tuning feature of DAMOS is a highly
recommended way for modern DAMOS use cases.  Using it, users can specify
what system status they want to achieve with what access-aware system
operations.  For example, reclaim cold memory aiming for 0.5 percent of
memory pressure (proactive reclaim), or migrate hot and cold memory
between NUMA nodes having different speed (memory tiering).  Then DAMOS
automatically adjusts the aggressiveness of the system operation (e.g.,
increase/decrease reclaim target coldness threshold) based on current
status of the system.

The use case is limited by the supported system status metrics for
specifying the target system status.  Two new system metrics for per-node
memory usage ratio, namely DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, were
recently added to extend the use cases for access-aware NUMA nodes
management, such as memory tiering.  Those are expected to be useful for
not only memory tiering but also general access-aware inter-NUMA node page
migration, though.

Limitation
----------

The per-node memory usage based auto-tuning can be applied only
system-wide.  For cgroups-based multi-tenant systems, it could arguably
harm the fairness.  For example, a cgroup may use faster NUMA node memory
more than other cgroup, depending on their access pattern.  If the user of
each cgroup are promised to get the same quality and amount of the system
resource, this can arguably be an unfair situation.

DAMOS supports cgroup level system operations via DAMOS filter.  But the
quota auto-tuning system is not aware of cgroups.

New DAMOS Quota Tuning Metrics for Per-Cgroup Per-NUMA Memory Usage
===================================================================

To overcome the limitation, introduce two new DAMOS quota auto-tuning goal
metrics, namely DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP.  Those can be
thought of as a variant of DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP that
extended for cgroups.

The two metrics specifies per-cgroup, per-node amount of used and unused
memory in ratio to the total memory of the node.  For example, let's
assume a system has two NUMA nodes of size 100 GiB and 50 GiB.  And two
cgroups are using 40 GiB and 60 GiB of node 0, 20 GiB and 10 GiB of node
1, respectively, as illustrated by the below table.

                     node-0    node-1
    Total memory     100 GiB   50 GiB
    Cgroup A usage   40 GiB    20 GiB
    Cgroup B usage   60 GiB    10 GiB

Then, DAMOS_QUOTA_NODE_MEMCG_USED_BP for the cgroups for the first node
are, 40 GiB / 100 GiB = 4,000 bp (40 percent) and 60 GiB / 100 GiB = 6,000
bp (60 percent), respectively.  Those for the second node are, 20 GiB / 50
GiB = 4000 bp (40 percent) and 10 GiB / 50 GiB = 2000 bp (20 percent),
respectively.

DAMOS_QUOTA_NODE_MEMCG_FREE_BP for the four cases are, 60 GiB /100 GiB =
6000 bp, 40 GiB / 100 GiB = 4000 bp, 30 GiB / 50 GiB = 6000 bp, and 40 GiB
/ 50 GiB = 8000 bp, respectively.

    DAMOS_QUOTA_NODE_MEMCG_USED_BP for cgroup A node-0: 4000 bp
    DAMOS_QUOTA_NODE_MEMCG_USED_BP for cgroup B node-0: 6000 bp
    DAMOS_QUOTA_NODE_MEMCG_USED_BP for cgroup A node-1: 4000 bp
    DAMOS_QUOTA_NODE_MEMCG_USED_BP for cgroup B node-1: 2000 bp

    DAMOS_QUOTA_NODE_MEMCG_FREE_BP for cgroup A node-0: 6000 bp
    DAMOS_QUOTA_NODE_MEMCG_FREE_BP for cgroup B node-0: 4000 bp
    DAMOS_QUOTA_NODE_MEMCG_FREE_BP for cgroup A node-1: 6000 bp
    DAMOS_QUOTA_NODE_MEMCG_FREE_BP for cgroup B node-1: 8000 bp

Using these, users can specify how much [un]used amount of memory for
per-cgroup and per-node DAMOS should make as a result of the auto-tuning.

Example Usecase: Cgroup Level Memory Tiering
============================================

Let's suppose a typical and simple tiered memory system.  The system
equips two NUMA nodes.  The first node (node 0) is CPU-attached and fast. 
The second node (node 1) is CPU-unattached and slow.  It runs two cgroups
that desire to use about 30 percent and 70 percent of the faster node as
much as possible for their hot data, respectively.  Then, the user can
implement DAMOS-based memory tiering for the system using the DAMON
user-space tool (damo), like below.

    # ./damo start \
    	`# kdamond for node 1 (slow)` \
        --numa_node 1 --monitoring_intervals_goal 4% 3 5ms 10s \
	    `# promotion scheme for cgroup a` \
            --damos_action migrate_hot 0 --damos_access_rate 5% max \
            --damos_apply_interval 1s \
	    --damos_filter allow memcg /workloads/a \
            --damos_filter allow young \
            --damos_quota_interval 1s --damos_quota_space 200MB \
            --damos_quota_goal node_memcg_used_bp 29.7% 0 /workloads/a \
	    \
	    `# promotion scheme for cgroup b` \
            --damos_action migrate_hot 0 --damos_access_rate 5% max \
            --damos_apply_interval 1s \
	    --damos_filter allow memcg /workloads/b \
            --damos_filter allow young \
            --damos_quota_interval 1s --damos_quota_space 200MB \
            --damos_quota_goal node_memcg_used_bp 69.7% 0 workloads/b \
	    \
    	`# kdamond for node 0 (fast)` \
        --numa_node 0 --monitoring_intervals_goal 4% 3 5ms 10s \
            `# demotion scheme for cgroup a` \
            --damos_action migrate_cold 1 --damos_access_rate 0% 0% \
            --damos_apply_interval 1s \
	    --damos_filter allow memcg /workloads/a \
            --damos_filter reject young \
            --damos_quota_interval 1s --damos_quota_space 200MB \
            --damos_quota_goal node_memcg_free_bp 70.5% 0 \
	    \
            `# demotion scheme for cgroup b` \
            --damos_action migrate_cold 1 --damos_access_rate 0% 0% \
            --damos_apply_interval 1s \
	    --damos_filter allow memcg /workloads/a \
            --damos_filter reject young \
            --damos_quota_interval 1s --damos_quota_space 200MB \
            --damos_quota_goal node_memcg_free_bp 30.5% 0 \
	    \
            --damos_nr_quota_goals 1 1 1 1 --damos_nr_filters 1 1 1 1 \
        --nr_targets 1 1 --nr_schemes 2 2 --nr_ctxs 1 1

With the command, the user-space tool will ask DAMON to spawn two kernel
threads, each for monitoring accesses to node 1 (slow) and node 0 (fast),
respectively.  It installs two DAMOS schemes on each thread.  Let's call
them "promotion scheme for cgroup a/b", and "demotion scheme for cgroup
a/b" in the order.  The promotion schemes are installed on the DAMON
thread for node 1 (slow), and demotion schemes are installed on the DAMON
thread for node 0 (fast).

Cgroup Level Hot Pages Migration (Promotion)
--------------------------------------------

Promotion schemes will find memory regions on node 1 (slow), that some
access was detected.  The schemes will then migrate the found memory to
node 0 (fast), hottest pages first.

For accurate and effective migration, these schemes use two page level
filters.  First, the migration will be filtered for only cgroup A and
cgroup B.  That is, "promotion scheme for cgroup B" will not do the
migration if the page is for cgroup A.  Secondly, the schemes will ignore
pages that having their page table's Accessed bits unset.  The per-page
Accessed bit check logic will also unset the bit if it was set, for the
next check.

For controlled amounts of system resource consumption and aiming on the
target memory usage, the schemes use quotas setup.  The migration is
limited to be done only up to 200 MiB per second, to limit the peak system
resource usage.  And DAMOS_QUOTA_NODE_MEMCG_USED_BP target is set for
29.7% and 69.7% of node 0 (fast), respectively.  The target value is lower
than the high level goal (30% and 70% system memory), to give headroom on
node 0 (fast).  DAMOS will adjust the speed of the pages migration based
on the target and current per-cgroup node 0 memory usage.  For example, if
cgroup A is utilizing only 10% of node 0, DAMOS will try to migrate more
of cgroup A hot pages from node 1 to node 0, up to 200 MiB per second.  If
cgroup A utilizes more than 29.7% of node 0 memory, the cgroup A hot pages
migration from node 1 to node 0 will be slowed and eventually stopped.

Cgroup Level Cold Pages Migration (Demotion)
--------------------------------------------

Demotion schemes are similar to promotion schemes, but differ in filtering
setup and quota tuning setup.  Those filter out pages having their page
table Accessed bits set.  And set 70.5% and 30.5% of node 0 memory free
rate for the cgroup A and B, respectively.  Hence, if promotion schemes or
something made cgroup A and/or B uses more than 29.5% and 69.5% of node 0,
demotion schemes will start migrating cold pages of appropriate cgroups in
node 0 to node 1, under the 200 MiB per second speed cap, while adjusting
the speed based on how much more than wanted memory is being used.

The quota target values are set to overlap with promotion targets, to keep
a minimum level of page exchanges between the nodes.  This is to avoid a
case that the target memory utilization is met, and then access pattern
changes (pages in node 1 become hotter than pages in node 0) while the
memory utilization is unchanged.  Without the overlap, neither promotion
of hotter pages in node 1, nor demotion of colder pages in node 0 will
happen since both goals are met.  As a result, the faster and slower node
will unexpectedly serve cold and hot data.

Test: Per-cgroup Memory Tiering
===============================

I ran a simplified cgroup level memory tiering using the feature, and
confirmed it works as intended.

Setup
-----

I configured a QEMU virtual machine representing a simplified version of
the system that described on the above cgroup level memory tiering example
use case.  The system equips 40 CPU cores and two NUMA nodes each having
30 GiB physical memory.  The first node (node 0) represents the faster
NUMA node, and the second node (node 1) represents the slower NUMA node. 
In specific, below qemu command line options are used.

    [...]
    -object memory-backend-ram,size=30G,id=m0 \
    -object memory-backend-ram,size=30G,id=m1 \
    -numa node,cpus=0-39,memdev=m0 \
    -numa node,memdev=m1 \
    [...]

I booted the virtual machine with a kernel that this patch series is
applied.  On the virtual machine, I created two cgroups, namely workload_a
and workload_b.  And ran a test program in each cgroup, resulting in one
process per cgroup.  The test program allocates 10 GiB memory and evenly
split it into 10 regions.  After the allocation, it repeatedly access the
first region for one minute, than the second one for one minute, and so
on.  After the one minute repeated access for the 10-th region is done, it
repeats the access from the first region.  So the process has 10 GiB of
data in total, but only 1 GiB of it is hot at a given moment, and the hot
data is gradually changed.

While the processes are running, run DAMON for a simple access-aware
memory tiering using below script.  It migrates hot and cold data of the
cgroups into node 0 and node 1, aiming the first and the second cgroups
(workload_a and workload_b, respectively) utilizing about 9.7 percent and
19.7 percent of node 0, respectively.

Note that this setup is a simplified version of the above example use
case, for ease of test.  Also note that we assigned 30 GiB physical memory
to node 0, but DAMON in this setup works for only 27 GiB of the memory. 
It is due to an internal implementation detail of DAMON user-space tool
that not really important for this test.

    #!/bin/bash
    damo start \
        --numa_node 1 \
            --damos_action migrate_hot 0 --damos_access_rate 5% max \
                --damos_apply_interval 1s \
                --damos_filter allow memcg /workload_a \
                --damos_filter allow young \
                --damos_quota_interval 1s \
                --damos_quota_goal node_memcg_used_bp 9.7% 0 /workload_a \
            --damos_action migrate_hot 0 --damos_access_rate 5% max \
                --damos_apply_interval 1s \
                --damos_filter allow memcg /workload_b \
                --damos_filter allow young \
                --damos_quota_interval 1s \
                --damos_quota_goal node_memcg_used_bp 19.7% 0 /workload_b \
        --numa_node 0 \
            --damos_action migrate_cold 1 --damos_access_rate 0% 0% \
                --damos_apply_interval 1s \
                --damos_filter allow memcg /workload_a \
                --damos_filter reject young \
                --damos_quota_interval 1s \
                --damos_quota_goal node_memcg_free_bp 90.5% 0 /workload_a \
            --damos_action migrate_cold 1 --damos_access_rate 0% 0% \
                --damos_apply_interval 1s \
                --damos_filter allow memcg /workload_b \
                --damos_filter reject young \
                --damos_quota_interval 1s \
                --damos_quota_goal node_memcg_free_bp 80.5% 0 /workload_b \
                --damos_nr_quota_goals 1 1 1 1 --damos_nr_filters 2 2 2 2 \
        --nr_targets 1 1 --nr_schemes 2 2 --nr_ctxs 1 1

After starting DAMON, the pages continuously be migrated across nodes.  A
few minutes later, the memory usage of the cgroups converges into the
aimed amounts, and keeps the level, as expected.  To confirm the status is
kept in the target level as expected, I collected the memory usage stat of
the cgroups using memory.numa_stat file, after the stats are converged.  I
repeat the stat collection 42 times with 5 seconds delay between each of
the collections.  The results are as below:

    node0_memory_usage  average  stdev
    workload_a          2.79GiB  522.06MiB
    workload_b          5.15GiB  739.10MiB

The average values are quite close to the targeted values: 27 GiB * 9.7% =
2.619 GiB for workload_a, and 27 GiB * 19.7% = 5.319 GiB.  A level of
variances are expected, given the overlap of the promotion/demotion
targets, and dynamic data access pattern of the workloads.  Give that, the
measured variances are at a reasonable level.

Patches Sequence
================

The first patch (patch 1) updates the kernel-doc comment of
damos_quota_goal struct to clarify usage of optional fields of the struct,
since later patches will add such optional fields.

Following four patches (patches 2-5) implement a new DAMOS quota goal
metric for per-cgroup per-node memory usage.  Those extends the core layer
interface for the new metric (patch 2), implement the metric value
calculation on the core layer (patch 3), add DAMON sysfs interface file
for the target cgroup specification (patch 4), and implement support of
the new metric on DAMON sysfs interface (patch 5).

Next two patches implment the second new DAMOS quota goal metric for
per-cgroup per-node free (or, unused) memory.  Those implement it in the
core layer (patch 6) and DAMON sysfs interface (patch 7), extending the
existing implementation for memory usage metric.

Final three patches update the design (patch 8), the usage (patch 9), and
the ABI (patch 10) documents for the changes that are introduced by this
patch series.


This patch (of 10):

damos_quota_goal kerneldoc comment is not explaining when @metric is used.
Update the comment for that.

Link: https://lkml.kernel.org/r/20251017212706.183502-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251017212706.183502-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/damon.h~mm-damon-document-damos_quota_goal-nid-use-case
+++ a/include/linux/damon.h
@@ -176,6 +176,9 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_USER_INPUT, @current_value should be manually
  * entered by the user, probably inside the kdamond callbacks.  Otherwise,
  * DAMON sets @current_value with self-measured value of @metric.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
+ * id of the target node to account the used/free memory.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

