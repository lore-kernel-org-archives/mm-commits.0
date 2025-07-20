Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B612413774D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976894; cv=none; b=A/q3MXZs06xxUPDNPOn/HFHRtcWR4QXxtsrCNGABmfX+m1uWNRl+mwZbtB7M3LERdpw1caq/yGsO4B3scF2JRO9K/OCXS9WGB5gvWQdPwZzNrCLd+jPgD6zJWJKheJGFWjRwBZXZhFr08EBbDXiOYRDoZY6BxoyYI5UYDaWF+4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976894; c=relaxed/simple;
	bh=reWLv3wr7xvHcVlNCs4BvK4xzwNKLGWovFX8rt1f0SY=;
	h=Date:To:From:Subject:Message-Id; b=KtqW+7PKZqMC+j8IX9M5Lfbg+e2O8IYD5+ABMQkNWAxUX2U/Dkqn+rIrGj/E1Jm5Qmie8BwTBSeo7w7aiUbPcTVCIcu+OfOYbleWd2nhAotXz5IAd55+Ig2TM9Ysh6Zl8qxM88tAGYMnFCgck7tgGM2rZg3JX2KuzR9lGbrOek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W7wcp/QN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7wcp/QN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C87C4CEE3;
	Sun, 20 Jul 2025 02:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976894;
	bh=reWLv3wr7xvHcVlNCs4BvK4xzwNKLGWovFX8rt1f0SY=;
	h=Date:To:From:Subject:From;
	b=W7wcp/QNZaFEIDQ/uV/ZG7sh0oaiTwDXRmNfKO+dCwaeYrx/jgkr6D/hLSVcXyqBH
	 x3aBYxmV+iBaWxgXTE9MYJphvGqmNMBUWXsVkgX84tyf7s5Odgto+pYSDJOLUw1mLu
	 ZCG+sizpRpEtnGImASftxHh5kuBk0Ff6IrAUUoAQ=
Date: Sat, 19 Jul 2025 19:01:33 -0700
To: mm-commits@vger.kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-struct-damos_migrate_dests.patch removed from -mm tree
Message-Id: <20250720020134.86C87C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add struct damos_migrate_dests
has been removed from the -mm tree.  Its filename was
     mm-damon-add-struct-damos_migrate_dests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add struct damos_migrate_dests
Date: Tue, 8 Jul 2025 19:59:31 -0500

Patch series "mm/damon/vaddr: Allow interleaving in migrate_{hot,cold}
actions", v4.

A recent patchset automatically sets the interleave weight for each node
according to the node's maximum bandwidth [1].  In another thread, the
patch set's author, Joshua Hahn, wondered if/how thes weights should be
changed if the bandwidth utilization of the system changes [2].

This patch set adds the mechanism for dynamically changing how application
data is interleaved across nodes while leaving the policy of what the
interleave weights should be to userspace.  It does this by having the
migrate_{hot,cold} operating schemes interleave application data according
to the list of migration nodes and weights passed in via the DAMON sysfs
interface.  This functionality can be used to dynamically adjust how
folios are interleaved by having a userspace process adjust those weights.
If no specific destination nodes or weights are provided, the
migrate_{hot,cold} actions will only migrate folios to damos->target_nid
as before.

The algorithm used to interleave the folios is similar to the one used for
the weighted interleave mempolicy [3].  It uses the offset from which a
folio is mapped into a VMA to determine the node the folio should be
placed in.  This method is convenient because for a given set of
interleave weights, a folio has only one valid node it can be placed in,
limitng the amount of unnecessary data movement.  However, finding out how
a folio is mapped inside of a VMA requires a costly rmap walk when using a
paddr scheme.  As such, we have decided that this functionality makes more
sense as a vaddr scheme [4].  To this end, this patch set also adds vaddr
versions of the migrate_{hot,cold}.

Motivation
==========
There have been prior discussions about how changing the interleave
weights in response to the system's bandwidth utilization can be
beneficial [2].  However, currently the interleave weights only are
applied when data is allocated.  Migrating already allocated pages
according to the dynamically changing weights will better help balance the
bandwidth utilization across nodes.

As a toy example, imagine some application that uses 75% of the local
bandwidth.  Assuming sufficient capacity, when running alone, we want to
keep that application's data in local memory.  However, if a second
instance of that application begins, using the same amount of bandwidth,
it would be best to interleave the data of both processes to alleviate the
bandwidth pressure from the local node.  Likewise, when one of the
processes ends, the data should be moves back to local memory.

We imagine there would be a userspace application that would monitor
system performance characteristics, such as bandwidth utilization or
memory access latency, and uses that information to tune the interleave
weights.  Others seem to have come to a similar conclusion in previous
discussions [5].  We are currently working on a userspace program that
does this, but it is not quite ready to be published yet.

After the userspace application tunes the interleave weights, there must
be some mechanism that actually migrates pages to be consistent with those
weights.  This patchset is what provides this mechanism.

We believe DAMON is the correct venue for the interleaving mechanism for a
few reasons.  First, we noticed that we don't have to migrate all of the
application's pages to improve performance.  we just need to migrate the
frequently accessed pages.  DAMON's existing hotness traching is very
useful for this.  Second, DAMON's quota system can be used to ensure we
are not using too much bandwidth for migrations.  Finally, as Ying pointed
out [6], a complete solution must also handle when a memory node is at
capacity.  The existing migrate_cold action can be used in conjunction
with the functionality added in this patch set to provide that complete
solution.

Functionality Test
==================
Below is an example of this new functionality in use to confirm that these
patches behave as intended.

In this example, the user starts an application, alloc_data, which
allocates 1GB using the default memory policy (i.e.  allocate to local
memory) then sleeps.  Afterwards, we start DAMON to interleave the data at
a 1:1 ratio.  Using numastat, we show that DAMON has migrated the
application's data to match the new interleave ratio.

For this example, I modified the userspace damo tool [8] to write to the
migration_dest sysfs files.  I plan to upstream these changes when these
patches are merged.

  $ # Allocate the data initially
  $ ./alloc_data 1G &
  [1] 6587
  $ numastat -c -p alloc_data

  Per-node process memory usage (in MBs) for PID 6587 (alloc_data)
           Node 0 Node 1 Total
           ------ ------ -----
  Huge          0      0     0
  Heap          0      0     0
  Stack         0      0     0
  Private    1027      0  1027
  -------  ------ ------ -----
  Total      1027      0  1027
  $ # Start DAMON to interleave data at a 1:1 ratio
  $ cat ./interleave_vaddr.yaml
  kdamonds:
  - contexts:
    - ops: vaddr
      addr_unit: null
      targets:
      - pid: 6587
        regions: []
      intervals:
        sample_us: 500 ms
        aggr_us: 5 s
        ops_update_us: 20 s
        intervals_goal:
          access_bp: 0 %
          aggrs: '0'
          min_sample_us: 0 ns
          max_sample_us: 0 ns
      nr_regions:
        min: '20'
        max: '50'
      schemes:
      - action: migrate_hot
        dests:
        - nid: 0
          weight: 1
        - nid: 1
          weight: 1
        access_pattern:
          sz_bytes:
            min: 0 B
            max: max
          nr_accesses:
            min: 0 %
            max: 100 %
          age:
            min: 0 ns
            max: max
  $ sudo ./damo/damo interleave_vaddr.yaml
  $ # Verify that DAMON has migrated data to match the 1:1 ratio
  $ numastat -c -p alloc_data

  Per-node process memory usage (in MBs) for PID 6587 (alloc_data)
           Node 0 Node 1 Total
           ------ ------ -----
  Huge          0      0     0
  Heap          0      0     0
  Stack         0      0     0
  Private     514    514  1027
  -------  ------ ------ -----
  Total       514    514  1027

Performance Test
================
Below is a simple example showing that interleaving application data using
these patches can improve application performance.  To do this, we run a
bandwidth intensive embedding reduction application [7].  This workload is
useful for this test because it reports the time it takes each iteration
to run and each iteration reuses the same allocation, allowing us to see
the benefits of the migration.

We evaluate this on a 128 core/256 thread AMD CPU with 72GB/s of local DDR
bandwidth and 26 GB/s of CXL bandwidth.

Before we start the workload, the system bandwidth utilization is low, so
we start with the interleave weights of 1:0, i.e.  allocating all data to
local memory.  When the workload beings, it saturates the local bandwidth,
making the page placement suboptimal.  To alleviate this, we modify the
interleave weights, triggering DAMON to migrate the workload's data.

We use the same interleave_vaddr.yaml file to setup DAMON, except we
configure it to begin with a 1:0 interleave ratio, and attach it to the
shell and its children processes.

  $ sudo ./damo/damo start interleave_vaddr.yaml --include_child_tasks &
  $ <path>/eval_baseline -d amazon_All -c 255 -r 100
  <clip startup output>
  Eval Phase 3: Running Baseline...
  
  REPEAT # 0 Baseline Total time : 7323.54 ms
  REPEAT # 1 Baseline Total time : 7624.56 ms
  REPEAT # 2 Baseline Total time : 7619.61 ms
  REPEAT # 3 Baseline Total time : 7617.12 ms
  REPEAT # 4 Baseline Total time : 7638.64 ms
  REPEAT # 5 Baseline Total time : 7611.27 ms
  REPEAT # 6 Baseline Total time : 7629.32 ms
  REPEAT # 7 Baseline Total time : 7695.63 ms
  # Interleave weights set to 3:1
  REPEAT # 8 Baseline Total time : 7077.5 ms
  REPEAT # 9 Baseline Total time : 5633.23 ms
  REPEAT # 10 Baseline Total time : 5644.6 ms
  REPEAT # 11 Baseline Total time : 5627.66 ms
  REPEAT # 12 Baseline Total time : 5629.76 ms
  REPEAT # 13 Baseline Total time : 5633.05 ms
  REPEAT # 14 Baseline Total time : 5641.24 ms
  REPEAT # 15 Baseline Total time : 5631.18 ms
  REPEAT # 16 Baseline Total time : 5631.33 ms

Updating the interleave weights and having DAMON migrate the workload data
according to the weights resulted in an approximarely 25% speedup.

Patches Sequence
================
Patches 1-7 extend the DAMON API to specify multiple destination nodes and
weights for the migrate_{hot,cold} actions.  These patches are from SJ'S
RFC [8].

Patches 8-10 add a vaddr implementation of the migrate_{hot,cold} schemes.

Patch 11 modifies the vaddr migrate_{hot,cold} schemes to interleave data
according to the weights provided by damos->migrate_dest.

Patches 12-13 allow the vaddr migrate_{hot,cold} implementation to filter
out folios like the paddr version.


This patch (of 13):

Introduce a new struct, namely damos_migrate_dests, for specifying
multiple DAMOS' migration destination nodes and their weights.

Link: https://lkml.kernel.org/r/20250709005952.17776-1-bijan311@gmail.com
Link: https://lkml.kernel.org/r/20250709005952.17776-2-bijan311@gmail.com
Link: https://lore.kernel.org/linux-mm/20250520141236.2987309-1-joshua.hahnjy@gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/20250313155705.1943522-1-joshua.hahnjy@gmail.com/ [2]
Link: https://elixir.bootlin.com/linux/v6.15.4/source/mm/mempolicy.c#L2015 [3]
Link: https://lore.kernel.org/damon/20250624223310.55786-1-sj@kernel.org/ [4]
Link: https://lore.kernel.org/linux-mm/20250314151137.892379-1-joshua.hahnjy@gmail.com/ [5]
Link: https://lore.kernel.org/linux-mm/87frjfx6u4.fsf@DESKTOP-5N7EMDA/ [6]
Link: https://github.com/SNU-ARC/MERCI [7]
Link: https://lore.kernel.org/damon/20250702051558.54138-1-sj@kernel.org/ [8]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/linux/damon.h~mm-damon-add-struct-damos_migrate_dests
+++ a/include/linux/damon.h
@@ -448,6 +448,22 @@ struct damos_access_pattern {
 };
 
 /**
+ * struct damos_migrate_dests - Migration destination nodes and their weights.
+ * @node_id_arr:	Array of migration destination node ids.
+ * @weight_arr:		Array of migration weights for @node_id_arr.
+ * @nr_dests:		Length of the @node_id_arr and @weight_arr arrays.
+ *
+ * @node_id_arr is an array of the ids of migration destination nodes.
+ * @weight_arr is an array of the weights for those.  The weights in
+ * @weight_arr are for nodes in @node_id_arr of same array index.
+ */
+struct damos_migrate_dests {
+	unsigned int *node_id_arr;
+	unsigned int *weight_arr;
+	size_t nr_dests;
+};
+
+/**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @pattern:		Access pattern of target regions.
  * @action:		&damos_action to be applied to the target regions.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

