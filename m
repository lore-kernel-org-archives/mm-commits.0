Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E576485CF5
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283058; cv=none; b=i4lKTzvNM3UXm52li8d+yv3nVSOWVziDfakzuA6cB41f+Yi1BFJXJazIkKvxp4lzy/z3l4UmwjSqaydhI+3VRaU+IEJflSOVcHk8tbTMtDjLo/aVpEN1+KBcxa3Z/ij2reOVYXzT3mTfgot1KTWD5ZamyvujFM2g4vXrxEg/jB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283058; c=relaxed/simple;
	bh=RdXxQ4FBfoXdybergdCMJ30W5SnIITEQ9zNnNHidt1Y=;
	h=Date:To:From:Subject:Message-Id; b=uKwSmXhRpcCbDLY7T8sn3kARyD7FsbKL+VXd4YMoTkPcvisfYCP3/w2APZjD6SakmYTtYDuqTMM6RbIhns92RGwa611LRT/CDhf78XVcmiBQk5cXvZhAwUR/xgtH40V7tlALrLUAFnF33ye7YFcUhg4wYEKILpqF3tzLKUOtTzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rk1sth/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rk1sth/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D40E1F000E9;
	Tue,  1 Sep 2026 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283056;
	bh=sNx5/u3Hf8ryi4spx1sybeiDBtp9F3niEZh5hvfYXYQ=;
	h=Date:To:From:Subject;
	b=rk1sth/OmL5hUdCh+AhI06GIM05BJbjk/6AydgBldVdQEZpPAoO1ILi4Pf+OQchz/
	 TqConhIx4DJycFxrc1DjeaAkcSothr8x8E82JnSREt8/x3QyP/au0Bf97N0CYZWhJ0
	 un0RngpaSCc9GU1mbWvU+/RFM924/eBusaXERAS0=
Date: Tue, 01 Sep 2026 10:17:35 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch added to mm-new branch
Message-Id: <20260901171736.1D40E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Tue, 1 Sep 2026 06:24:48 -0700

Patch series "mm/damon: introduce data access-as-a-data attribute", v1.1.

TL;DR: extend DAMON's data attributes monitoring system to support page
table accessed bit and PG_idle based access monitoring.

DAMON was initially introduced as a data access monitor.  Users found data
access pattern becomes more useful when it is combined with other data
attributes such as belonging cgroups and backing page types.  For such
cases, DAMON has extended to support such data attributes monitoring in
addition to the original data access monitoring.  The DAMON probes system
was introduced for this purpose.  Users set probes for filtering data
attributes of their interest.  For use cases where the primary interests
are the attributes but the access pattern, probe weights system has been
introduced.  When it is used, DAMON applies its adaptive regions
adjustment based on the monitored data attributes.

However, DAMON stops access monitoring when the probe weights are used. 
DAMON cannot optimally help users who have interests in both data
attributes and access patterns.  Data access can also be thought of as
another data attribute, though.  Extend the probe system to support data
access as a data attribute.

Introduce a new probe filter type, pgidle_unset.  It shows if the page is
not set as idle.  Specifically, it shows the page table accessed bit and
the PG_idle flag.  It can inform if the region is ever accessed.  But it
cannot say when it is accessed.  To answer the second question, introduce
a new probe feature, prep actions.  Using the features, Users can specify
what preparation actions should be made to each region for each probe. 
DAMON executes the preparation actions for each sampling interval, like it
is doing the preparation for access check in the access monitoring mode. 
To help 'pgidle_unset' probe action use case, 'set_pgidle' preparation
action is introduced together.  The action does exactly what the access
monitoring was doing: clearing the page table accessed bits and setting
the PG_idle flags.

Tests
=====

I compared the access pattern monitoring results from the classic way and
the probe based way.  As expected, the probe based way shows the results
similar to that of the classic way.  More detailed test methods and
results are below.

First, do the access monitoring using the DAMON user-space tool [1] in the
classic way.  The system is idle.  It shows no access as expected.

    $ sudo ./damo/damo start
    $ sudo ./damo/damo report access
    heatmap:
    00000000000000000000000000000000000000008999999811111110000000000000000000000000
    # min/max temperatures: -640,000,000, -100,000,000, column size: 99.800
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 3.898 GiB   access 0 hz   age 6.400 s
    1   addr 3.898 GiB    size 787.301 MiB access 0 hz   age 1 s
    2   addr 4.667 GiB    size 773.457 MiB access 0 hz   age 5.800 s
    3   addr 5.423 GiB    size 2.374 GiB   access 0 hz   age 6.400 s
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start an artificial memory access generator (masim) [2] in another window.

    $ ./masim/masim.py run --config_file ./masim/configs/zigzag.cfg

Show the monitoring results.  As expected, it captures accesses.

    $ sudo ./damo/damo report access
    heatmap:
    00000000000000000000000000000000000000011111111111111118888888833378988888888888
    # min/max temperatures: -1,470,000,000, -12,482,536, column size: 99.800
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 1.542 GiB   access 0 hz   age 14.700 s
    1   addr 1.542 GiB    size 788.324 MiB access 0 hz   age 14.600 s
    2   addr 2.311 GiB    size 772.844 MiB access 0 hz   age 14.200 s
    [...]
    50  addr 6.839 GiB    size 1.742 MiB   access 0 hz   age 1.300 s
    51  addr 6.840 GiB    size 8.000 KiB   access 100 hz age 0 ns
    52  addr 6.840 GiB    size 1.496 MiB   access 160 hz age 0 ns
    [...]
    97  addr 7.162 GiB    size 1.199 MiB   access 40 hz  age 400 ms
    98  addr 7.163 GiB    size 1.199 MiB   access 20 hz  age 400 ms
    99  addr 7.164 GiB    size 2.004 MiB   access 160 hz age 0 ns
    100 addr 7.166 GiB    size 646.004 MiB access 0 hz   age 400 ms
    memory bw estimate: 26.148 GiB per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

After the artificial memory access generator (masim) is terminated,
restart DAMON with the probe-based access monitoring.  As expected, it
shows no access since the system is idle again.

    $ sudo ./damo/damo stop
    $ sudo ./damo/damo start --probe_prep set_pgidle \
            --probe_filter allow pgidle_unset --probe_weight 1
    $ sudo ./damo/damo report attrs
    heatmap:
    00000000000000000000000000000000000000008999999711111100000000000000000000000000
    # min/max temperatures: -600,000,000, -430,000,000, column size: 99.800
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   addr         size         age           probe_hits
    0   4.000 KiB    3.898 GiB    6 s           0
    1   5.285 GiB    2.512 GiB    6 s           0
    2   4.659 GiB    641.816 MiB  5.700 s       0
    3   3.898 GiB    778.375 MiB  4.300 s       0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start the artificial memory access generator [2] again.

    $ ./masim/masim.py run --config_file ./masim/configs/zigzag.cfg

Show the monitoring results.  As expected, it captures accesses similar to
the classic monitoring mode.

    $ sudo ./damo/damo report attrs
    heatmap:
    00000000000000000000000000000000000000011111110000000177777777777777878798887777
    # min/max temperatures: -1,330,000,000, 84,847,514, column size: 99.800
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   addr         size         age           probe_hits
    0   4.000 KiB    1.508 GiB    13.300 s      0
    1   1.508 GiB    794.684 MiB  13.200 s      0
    2   2.284 GiB    764.555 MiB  13 s          0
    [...]
    50  6.711 GiB    4.625 MiB    0 ns          17
    51  6.716 GiB    2.504 MiB    0 ns          17
    52  6.732 GiB    796.000 KiB  0 ns          17
    [...]
    90  7.162 GiB    512.000 KiB  2.200 s       2
    91  7.061 GiB    700.000 KiB  2.300 s       1
    92  6.935 GiB    316.000 KiB  2.300 s       4
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Patches Sequence
================

First four patches (patches 1-4) introduce the new probe filter type for
knowing if a region is accessed.  Patch 1 defines the new type in the
core.  Patch 2 implements the execution of the new filter in the physical
address space DAMON operation set.  Patch 3 implements a user interface on
DAMON sysfs interface.  Patch 4 updates the documentation for the new
filter type.

Following 13 patches (patches 5-17) introduce the probe preparation
actions feature.  Patch 5 defines the data structure for specifying the
preparation actions.  Patch 6 completes setup of the API parameter for the
prep.  Patch 7 extends the DAMON operation set callback list to connect
the parameter with the underlying operation set.  Patch 8 implements the
execution of the prep in the physical address space DAMON operation set.

Following five patches (patches 9-13) extends DAMON sysfs interface for
the new prep feature.  Patch 14 adds simple selftest for basic file
operations of the new sysfs files.  Final three patches (patches 15-17)
respectively update design, usage and ABI documents for the new feature
and its interface.




Introduce a new DAMON filter type, pgidle_unset.  It will match pages that
have their PG_Idle flag unset, or the page table accessed bit set.  In
other words, it says if the page is accessed.

Link: https://lore.kernel.org/20260901132506.99243-1-sj@kernel.org
Link: https://lore.kernel.org/20260901132506.99243-2-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Link: https://github.com/sjp38/masim [2]
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_filter_type_pgidle_unset
+++ a/include/linux/damon.h
@@ -745,12 +745,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch

