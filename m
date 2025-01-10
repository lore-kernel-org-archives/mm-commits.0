Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5B72080F6
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 22:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549772; cv=none; b=TZcsTYIlCGsgWkh7LEOPg5kor456L+jCh2ucEDfatm0N1bc7iwmCPX6KqQ401KmsvTbC7pwwhdAu099C0A8s9WfXCE7zjW4zO9eybZ/NcVLhmeB8/1bAa3iTSmD4th1nLARwVT6TeQfJQ89RIecTiFFsMjtbQmjym/UxaQIE4R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549772; c=relaxed/simple;
	bh=WP/7OgQbN2s+/LKCOWsOMTH+LemzIbfQvMlCAh3ALDA=;
	h=Date:To:From:Subject:Message-Id; b=PMvcu6bkHSm0OMislS94Ypj0Dbwbykb4aAb//k6cNbtStrp7VRUUONUcTxnpYzumA0H3JQIkMV0Ynx8bkAogP3jkhnKBqemNKs82GCjJOU7+835LOEY8xWuhBoRTafe6gwioHDL+0gEkFUmo9Aja4msHS5JFG00y50Itk93hvXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RiTXqRle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RiTXqRle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934BDC4CED6;
	Fri, 10 Jan 2025 22:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736549771;
	bh=WP/7OgQbN2s+/LKCOWsOMTH+LemzIbfQvMlCAh3ALDA=;
	h=Date:To:From:Subject:From;
	b=RiTXqRlemq1h5eFicoyTY4HpLFWyeFR1yy/s/Ta0Po9k6YdykSbZI71KNyFdt1kbA
	 NG5DGZyot1ipUZUbPbPfd1RbjC/ZyY8uWyOZFENNDf+epAXuYnYmZavwOlXr4n4Lmh
	 on/bcfhQWU/Ay0VSinSHWRxVFtscETbOrO95m1R0=
Date: Fri, 10 Jan 2025 14:56:11 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch added to mm-unstable branch
Message-Id: <20250110225611.934BDC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: add an example monitoring intervals tuning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon: add an example monitoring intervals tuning
Date: Fri, 10 Jan 2025 10:52:29 -0800

Add a DAMON monitoring intervals tuning example that contains output from
a demonstration of the guide on a real server workload system.  The
example with real world numbers will help users better understanding the
guide instructions and what outputs they can expect and verify.  Those
will again help finding the rooms for improvements on the guide.

Link: https://lkml.kernel.org/r/20250110185232.54907-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst                              |    9 
 Documentation/mm/damon/monitoring_intervals_tuning_example.rst |  247 ++++++++++
 2 files changed, 256 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-add-an-example-monitoring-intervals-tuning
+++ a/Documentation/mm/damon/design.rst
@@ -266,6 +266,8 @@ tracepoints.  For more details, please r
 respectively.
 
 
+.. _damon_design_monitoring_params_tuning_guide:
+
 Monitoring Parameters Tuning Guide
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -311,6 +313,13 @@ sufficient for the given purpose, it sho
 lowered.  It is recommended to be set proportional to ``aggregation interval``.
 By default, the ratio is set as ``1/20``, and it is still recommended.
 
+Refer to below documents for an example tuning based on the above guide.
+
+.. toctree::
+   :maxdepth: 1
+
+   monitoring_intervals_tuning_example
+
 
 .. _damon_design_damos:
 
diff --git a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
@@ -0,0 +1,247 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================================
+DAMON Moniting Interval Parameters Tuning Example
+=================================================
+
+DAMON's monitoring parameters need tuning based on given workload and the
+monitoring purpose.  There is a :ref:`tuning guide
+<damon_design_monitoring_params_tuning_guide>` for that.  This document
+provides an example tuning based on the guide.
+
+Setup
+=====
+
+For below example, DAMON of Linux kernel v6.11 and `damo
+<https://github.com/damonitor/damo>`_ (DAMON user-space tool) v2.5.9 was used to
+monitor and visualize access patterns on the physical address space of a system
+running a real-world server workload.
+
+5ms/100ms intervals: Too Short Interval
+=======================================
+
+Let's start by capturing the access pattern snapshot on the physical address
+space of the system using DAMON, with the default interval parameters (5
+milliseconds and 100 milliseconds for the sampling and the aggregation
+intervals, respectively).  Wait ten minutes between the start of DAMON and
+the capturing of the snapshot, to show a meaningful time-wise access patterns.
+::
+
+    # damo start
+    # sleep 600
+    # damo record --snapshot 0 1
+    # damo stop
+
+Then, list the DAMON-found regions of different access patterns, sorted by the
+"access temperature".  "Access temperature" is a metric representing the
+access-hotness of a region.  It is calculated as a weighted sum of the access
+frequency and the age of the region.  If the access frequency is 0 %, the
+temperature is multipled by minus one.  That is, if a region is not accessed,
+it gets minus temperature and it gets lower as not accessed for longer time.
+The sorting is in temperature-ascendint order, so the region at the top of the
+list is the coldest, and the one at the bottom is the hottest one. ::
+
+    # damo report access --sort_regions_by temperature
+    0   addr 16.052 GiB   size 5.985 GiB   access 0 %   age 5.900 s    # coldest
+    1   addr 22.037 GiB   size 6.029 GiB   access 0 %   age 5.300 s
+    2   addr 28.065 GiB   size 6.045 GiB   access 0 %   age 5.200 s
+    3   addr 10.069 GiB   size 5.983 GiB   access 0 %   age 4.500 s
+    4   addr 4.000 GiB    size 6.069 GiB   access 0 %   age 4.400 s
+    5   addr 62.008 GiB   size 3.992 GiB   access 0 %   age 3.700 s
+    6   addr 56.795 GiB   size 5.213 GiB   access 0 %   age 3.300 s
+    7   addr 39.393 GiB   size 6.096 GiB   access 0 %   age 2.800 s
+    8   addr 50.782 GiB   size 6.012 GiB   access 0 %   age 2.800 s
+    9   addr 34.111 GiB   size 5.282 GiB   access 0 %   age 2.300 s
+    10  addr 45.489 GiB   size 5.293 GiB   access 0 %   age 1.800 s    # hottest
+    total size: 62.000 GiB
+
+The list shows not seemingly hot regions, and only minimum access pattern
+diversity.  Every region has zero access frequency.  The number of region is
+10, which is the default ``min_nr_regions value``.  Size of each region is also
+nearly idential.  We can suspect this is because “adaptive regions adjustment”
+mechanism was not well working.  As the guide suggested, we can get relative
+hotness of regions using ``age`` as the recency information.  That would be
+better than nothing, but given the fact that the longest age is only about 6
+seconds while we waited about ten minuts, it is unclear how useful this will
+be.
+
+The temperature ranges to total size of regions of each range histogram
+visualization of the results also shows no interesting distribution pattern. ::
+
+    # damo report access --style temperature-sz-hist
+    <temperature> <total size>
+    [-,590,000,000, -,549,000,000) 5.985 GiB  |**********          |
+    [-,549,000,000, -,508,000,000) 12.074 GiB |********************|
+    [-,508,000,000, -,467,000,000) 0 B        |                    |
+    [-,467,000,000, -,426,000,000) 12.052 GiB |********************|
+    [-,426,000,000, -,385,000,000) 0 B        |                    |
+    [-,385,000,000, -,344,000,000) 3.992 GiB  |*******             |
+    [-,344,000,000, -,303,000,000) 5.213 GiB  |*********           |
+    [-,303,000,000, -,262,000,000) 12.109 GiB |********************|
+    [-,262,000,000, -,221,000,000) 5.282 GiB  |*********           |
+    [-,221,000,000, -,180,000,000) 0 B        |                    |
+    [-,180,000,000, -,139,000,000) 5.293 GiB  |*********           |
+    total size: 62.000 GiB
+
+In short, the parameters provide poor quality monitoring results for hot
+regions detection. According to the :ref:`guide
+<damon_design_monitoring_params_tuning_guide>`, this is due to the too short
+aggregation interval.
+
+100ms/2s intervals: Starts Showing Small Hot Regions
+====================================================
+
+Following the guide, increase the interval 20 times (100 milliseocnds and 2
+seconds for sampling and aggregation intervals, respectively). ::
+
+    # damo start -s 100ms -a 2s
+    # sleep 600
+    # damo record --snapshot 0 1
+    # damo stop
+    # damo report access --sort_regions_by temperature
+    0   addr 10.180 GiB   size 6.117 GiB   access 0 %   age 7 m 8 s    # coldest
+    1   addr 49.275 GiB   size 6.195 GiB   access 0 %   age 6 m 14 s
+    2   addr 62.421 GiB   size 3.579 GiB   access 0 %   age 6 m 4 s
+    3   addr 40.154 GiB   size 6.127 GiB   access 0 %   age 5 m 40 s
+    4   addr 16.296 GiB   size 6.182 GiB   access 0 %   age 5 m 32 s
+    5   addr 34.254 GiB   size 5.899 GiB   access 0 %   age 5 m 24 s
+    6   addr 46.281 GiB   size 2.995 GiB   access 0 %   age 5 m 20 s
+    7   addr 28.420 GiB   size 5.835 GiB   access 0 %   age 5 m 6 s
+    8   addr 4.000 GiB    size 6.180 GiB   access 0 %   age 4 m 16 s
+    9   addr 22.478 GiB   size 5.942 GiB   access 0 %   age 3 m 58 s
+    10  addr 55.470 GiB   size 915.645 MiB access 0 %   age 3 m 6 s
+    11  addr 56.364 GiB   size 6.056 GiB   access 0 %   age 2 m 8 s
+    12  addr 56.364 GiB   size 4.000 KiB   access 95 %  age 16 s
+    13  addr 49.275 GiB   size 4.000 KiB   access 100 % age 8 m 24 s   # hottest
+    total size: 62.000 GiB
+    # damo report access --style temperature-sz-hist
+    <temperature> <total size>
+    [-42,800,000,000, -33,479,999,000) 22.018 GiB |*****************   |
+    [-33,479,999,000, -24,159,998,000) 27.090 GiB |********************|
+    [-24,159,998,000, -14,839,997,000) 6.836 GiB  |******              |
+    [-14,839,997,000, -5,519,996,000)  6.056 GiB  |*****               |
+    [-5,519,996,000, 3,800,005,000)    4.000 KiB  |*                   |
+    [3,800,005,000, 13,120,006,000)    0 B        |                    |
+    [13,120,006,000, 22,440,007,000)   0 B        |                    |
+    [22,440,007,000, 31,760,008,000)   0 B        |                    |
+    [31,760,008,000, 41,080,009,000)   0 B        |                    |
+    [41,080,009,000, 50,400,010,000)   0 B        |                    |
+    [50,400,010,000, 59,720,011,000)   4.000 KiB  |*                   |
+    total size: 62.000 GiB
+
+DAMON found two distinct 4 KiB regions that pretty hot.  The regions are also
+well aged.  The hottest 4 KiB region was keeping the access frequency for about
+8 minutes, and the coldest region was keeping no access for about 7 minutes.
+The distribution on the histogram also looks like having a pattern.
+
+Especially, the finding of the 4 KiB regions among the 62 GiB total memory
+shows DAMON’s adaptive regions adjustment is working as designed.
+
+Still the number of regions is close to the ``min_nr_regions``, and sizes of
+cold regions are similar, though.  Apparently it is improved, but it still has
+rooms to improve.
+
+400ms/8s intervals: Pretty Improved Results
+===========================================
+
+Increase the intervals four times (400 milliseconds and 8 seconds
+for sampling and aggregation intervals, respectively). ::
+
+    # damo start -s 400ms -a 8s
+    # sleep 600
+    # damo record --snapshot 0 1
+    # damo stop
+    # damo report access --sort_regions_by temperature
+    0   addr 64.492 GiB   size 1.508 GiB   access 0 %   age 6 m 48 s    # coldest
+    1   addr 21.749 GiB   size 5.674 GiB   access 0 %   age 6 m 8 s
+    2   addr 27.422 GiB   size 5.801 GiB   access 0 %   age 6 m
+    3   addr 49.431 GiB   size 8.675 GiB   access 0 %   age 5 m 28 s
+    4   addr 33.223 GiB   size 5.645 GiB   access 0 %   age 5 m 12 s
+    5   addr 58.321 GiB   size 6.170 GiB   access 0 %   age 5 m 4 s
+    [...]
+    25  addr 6.615 GiB    size 297.531 MiB access 15 %  age 0 ns
+    26  addr 9.513 GiB    size 12.000 KiB  access 20 %  age 0 ns
+    27  addr 9.511 GiB    size 108.000 KiB access 25 %  age 0 ns
+    28  addr 9.513 GiB    size 20.000 KiB  access 25 %  age 0 ns
+    29  addr 9.511 GiB    size 12.000 KiB  access 30 %  age 0 ns
+    30  addr 9.520 GiB    size 4.000 KiB   access 40 %  age 0 ns
+    [...]
+    41  addr 9.520 GiB    size 4.000 KiB   access 80 %  age 56 s
+    42  addr 9.511 GiB    size 12.000 KiB  access 100 % age 6 m 16 s
+    43  addr 58.321 GiB   size 4.000 KiB   access 100 % age 6 m 24 s
+    44  addr 9.512 GiB    size 4.000 KiB   access 100 % age 6 m 48 s
+    45  addr 58.106 GiB   size 4.000 KiB   access 100 % age 6 m 48 s    # hottest
+    total size: 62.000 GiB
+    # damo report access --style temperature-sz-hist
+    <temperature> <total size>
+    [-40,800,000,000, -32,639,999,000) 21.657 GiB  |********************|
+    [-32,639,999,000, -24,479,998,000) 17.938 GiB  |*****************   |
+    [-24,479,998,000, -16,319,997,000) 16.885 GiB  |****************    |
+    [-16,319,997,000, -8,159,996,000)  586.879 MiB |*                   |
+    [-8,159,996,000, 5,000)            4.946 GiB   |*****               |
+    [5,000, 8,160,006,000)             260.000 KiB |*                   |
+    [8,160,006,000, 16,320,007,000)    0 B         |                    |
+    [16,320,007,000, 24,480,008,000)   0 B         |                    |
+    [24,480,008,000, 32,640,009,000)   0 B         |                    |
+    [32,640,009,000, 40,800,010,000)   16.000 KiB  |*                   |
+    [40,800,010,000, 48,960,011,000)   8.000 KiB   |*                   |
+    total size: 62.000 GiB
+
+The number of regions having different access patterns has significantly
+increased.  Size of each region is also more varied. Total size of non-zero
+access frequency regions is also significantly increased. Maybe this is already
+good enough to make some meaningful memory management efficieny changes.
+
+800ms/16s intervals: Another bias
+=================================
+
+Further double the intervals (800 milliseconds and 16 seconds for sampling
+and aggregation intervals, respectively).  The results is more improved for the
+hot regions detection, but starts looking degrading cold regions detection. ::
+
+    # damo start -s 800ms -a 16s
+    # sleep 600
+    # damo record --snapshot 0 1
+    # damo stop
+    # damo report access --sort_regions_by temperature
+    0   addr 64.781 GiB   size 1.219 GiB   access 0 %   age 4 m 48 s
+    1   addr 24.505 GiB   size 2.475 GiB   access 0 %   age 4 m 16 s
+    2   addr 26.980 GiB   size 504.273 MiB access 0 %   age 4 m
+    3   addr 29.443 GiB   size 2.462 GiB   access 0 %   age 4 m
+    4   addr 37.264 GiB   size 5.645 GiB   access 0 %   age 4 m
+    5   addr 31.905 GiB   size 5.359 GiB   access 0 %   age 3 m 44 s
+    [...]
+    20  addr 8.711 GiB    size 40.000 KiB  access 5 %   age 2 m 40 s
+    21  addr 27.473 GiB   size 1.970 GiB   access 5 %   age 4 m
+    22  addr 48.185 GiB   size 4.625 GiB   access 5 %   age 4 m
+    23  addr 47.304 GiB   size 902.117 MiB access 10 %  age 4 m
+    24  addr 8.711 GiB    size 4.000 KiB   access 100 % age 4 m
+    25  addr 20.793 GiB   size 3.713 GiB   access 5 %   age 4 m 16 s
+    26  addr 8.773 GiB    size 4.000 KiB   access 100 % age 4 m 16 s
+    total size: 62.000 GiB
+    # damo report access --style temperature-sz-hist
+    <temperature> <total size>
+    [-28,800,000,000, -23,359,999,000) 12.294 GiB  |*****************   |
+    [-23,359,999,000, -17,919,998,000) 9.753 GiB   |*************       |
+    [-17,919,998,000, -12,479,997,000) 15.131 GiB  |********************|
+    [-12,479,997,000, -7,039,996,000)  0 B         |                    |
+    [-7,039,996,000, -1,599,995,000)   7.506 GiB   |**********          |
+    [-1,599,995,000, 3,840,006,000)    6.127 GiB   |*********           |
+    [3,840,006,000, 9,280,007,000)     0 B         |                    |
+    [9,280,007,000, 14,720,008,000)    136.000 KiB |*                   |
+    [14,720,008,000, 20,160,009,000)   40.000 KiB  |*                   |
+    [20,160,009,000, 25,600,010,000)   11.188 GiB  |***************     |
+    [25,600,010,000, 31,040,011,000)   4.000 KiB   |*                   |
+    total size: 62.000 GiB
+
+It found more non-zero access frequency regions. The number of regions is still
+much higher than the ``min_nr_regions``, but it is reduced from that of the
+previous setup. And apparently the distribution seems bit biased to hot
+regions.
+
+Conclusion
+==========
+
+With the above experimental tuning results, we can conclude the theory and the
+guide makes sense to at least this workload, and could be applied to similar
+cases.
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-fixup-damos_filter-kernel-doc.patch
mm-damon-core-add-damos_filter-allow-field.patch
mm-damon-core-support-damos_filter-allow.patch
mm-damon-paddr-support-damos_filter-allow.patch
mm-damon-add-allow-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch
docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch
docs-abi-damon-document-damos-filter-allow-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch
docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

