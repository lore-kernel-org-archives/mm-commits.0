Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5D36F8FE
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027648; cv=none; b=NRbB+GZgSYvH6XKLigpYVO1q0NmE+1CDds6Es6UekV/CeL8mK+xNs18pPL9NO//5MdMzORnjkNQHYTsgE2vRopu8+o/RSpxnSA/VmL6NnD4yNCg+KH2ZTmza/6a31wBrjhjmfWI5vF4jodGO8tUsL+h/t9oJYwFu/XQHP+6ojh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027648; c=relaxed/simple;
	bh=lmu07rsWIom8LklPOSsn7KbZxQEIeIXrl6zcv5W6QHI=;
	h=Date:To:From:Subject:Message-Id; b=YvmNRvVPG24lPCqqw+L4hCVFCcKJhPQIF9xs2EN77IK1N/3xhKkCJvTpif9P5CnxhiZ/E18r85N93J8B0Weal9iluFWBX+Kk5nKK5S0JKa/bRAlwcjTvB6AQ7uhniIqjGdlDBcLPMlOh3nz2sVmpFxdnYTU0gYvIV2X6u9U/T+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jrsngvrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jrsngvrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8168F1F00893;
	Fri, 29 May 2026 04:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027646;
	bh=l749mlOKy7z6XB12oKDoyr8iupVeD2OaScyCtYc3DCA=;
	h=Date:To:From:Subject;
	b=jrsngvrjkxaRcUgwJ3l8va/7nTgEFZvv2orkEVQ6hiISNsyBhZnJn90RXmosp482z
	 QWiQbbvUk0RdpkIpuutICdMfvi61MMPM3tvDFde6pY75rG6h4zDcGMDvDjH1zx1iyK
	 TE90EsAzsS8yHJvCgKZQZCVqFnBs8ZDvxE7CCIOo=
Date: Thu, 28 May 2026 21:07:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hank20010209@gmail.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-support-madv_collapse-via-damos_collapse-scheme-action.patch removed from -mm tree
Message-Id: <20260529040726.8168F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
has been removed from the -mm tree.  Its filename was
     mm-damon-support-madv_collapse-via-damos_collapse-scheme-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Sun, 26 Apr 2026 16:16:17 -0700

This patch set introces a new action:  DAMOS_COLLAPSE.

For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
working, since it relies on hugepage_madvise to add a new slot.  This slot
should be picked up by khugepaged and eventually collapse (or not, if we
are using DAMOS_NOHUGEPAGE) the pages.  If THP is not enabled, khugepaged
will not be working, and therefore no collapse will happen.

DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse the
address range synchronously.  In cases where there is a large VMA
(databases, for example), DAMOS_COLLAPSE allows us to collapse only the
hot region, and not the entire VMA.

This new action may be required to support autotuning with hugepage
as a goal[1].

=========
Benchmarks:
=========

MySQL
=====

Tests were performed in an ARM physical server with MariaDB 10.5 and
sysbench. Read only benchmark was perform with gaussian row hitting,
which follows a normal distribution.

T n, D h: THP set to never, DAMON action set to hugepage
T m, D h: THP set to madvise, DAMON action set to hugepage
T n, D c: THP set to never, DAMON action set to collapse

Memory consumption. Lower is better.

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.13     | 2.20     | 2.20     |
| Huge pages       | 0        | 1.3      | 1.27     |
+------------------+----------+----------+----------+

Performance in TPS (Transactions Per Second). Higher is better.

T n, D h: 18225.58
T m, D h 18252.93
T n, D c: 18270.21

Performance counter

I got the number of L1 D/I TLB accesses and the number a D/I TLB
accesses that triggered a page walk. I divided the second by the
first to get the percentage of page walkes per TLB access. The
lower the better.

+---------------+--------------+--------------+--------------+
|               | T n, D h     | T m, D h     | T n, D c     |
+---------------+--------------+--------------+--------------+
| L1 DTLB       | 127248242753 | 125431020479 | 125327001821 |
| L1 ITLB       | 80332558619  | 79346759071  | 79298139590  |
| DTLB walk     | 75011087     | 52800418     | 55895794     |
| ITLB walk     | 71577076     | 71505137     | 67262140     |
| DTLB % misses | 0.058948623  | 0.042095183  | 0.044599961  |
| ITLB % misses | 0.089100954  | 0.090117275  | 0.084821839  |
+---------------+--------------+--------------+--------------+

Masim
=====

I used masim with the "demo" configuration, but changing the times
to 100 seconds for the initial phase and 50 seconds for the rest of
the phases.

Memory consumption:

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.38 GB  | 2.36 GB  | 2.37 GB  |
| Huge pages       | 0        | 190 MB   | 188 MB   |
+------------------+----------+----------+----------+

Performance:

THP never, DAMOS_HUGEPAGE
initial phase:                40,491 accesses/msec, 100001 msecs run
low phase 0:                  39,658 accesses/msec, 50002 msecs run
high phase 0:                 41,678 accesses/msec, 50000 msecs run
low phase 1:                  39,625 accesses/msec, 50003 msecs run
high phase 1:                 41,658 accesses/msec, 50002 msecs run
low phase 2:                  39,642 accesses/msec, 50002 msecs run
high phase 2:                 41,640 accesses/msec, 50001 msecs run

THP madvise, DAMOS_HUGEPAGE
initial phase:                51,977 accesses/msec, 100000 msecs run
low phase 0:                  86,953 accesses/msec, 50000 msecs run
high phase 0:                 94,812 accesses/msec, 50000 msecs run
low phase 1:                 101,017 accesses/msec, 50000 msecs run
high phase 1:                 94,841 accesses/msec, 50000 msecs run
low phase 2:                 100,993 accesses/msec, 50000 msecs run
high phase 2:                 94,791 accesses/msec, 50001 msecs run

THP never, DAMOS_COLLAPSE
initial phase:                93,678 accesses/msec, 100001 msecs run
low phase 0:                 101,475 accesses/msec, 50000 msecs run
high phase 0:                 98,589 accesses/msec, 50000 msecs run
low phase 1:                 101,531 accesses/msec, 50001 msecs run
high phase 1:                 98,506 accesses/msec, 50001 msecs run
low phase 2:                 101,458 accesses/msec, 50001 msecs run
high phase 2:                 98,555 accesses/msec, 50000 msecs run

Memory consumption dynamic (how quickly collapses occur):

It shows in seconds how many huge pages are allocated.

+----+----------+----------+
|    | T m, D h | T n, D c |
+----+----------+----------+
| 5  | 32       | 188      |
| 10 | 48       | 188      |
| 15 | 64       | 188      |
| 20 | 96       | 188      |
| 30 | 112      | 188      |
| 35 | 144      | 188      |
| 40 | 160      | 188      |
| 45 | 190      | 188      |
| 50 | 190      | 188      |
| 55 | 190      | 188      |
| 60 | 190      | 188      |
+----+----------+----------+

=========

- We can see that DAMOS "hugepage" action works only when THP is set
  to madvise. "collapse" action works even when THP is set to never.
- Performance for "collapse" action is slightly lower than "hugepage"
  action and THP madvise. This is due to the fact that collapases
  occur synchronously. With "hugepage" they may occur during page
  faults.
- Memory consumption is slighly lower for "collapse" than "hugepage"
  with THP madvise. This is due to the khugepage collapses all VMAs,
  while "collapse" action only collapses the VMAs in the hot region.
- There is an improvement in TLB utilization when collapse through
  "hugepage" or "collapse" actions are triggered. The amount of
  TLB misses is lower.
- "collapse" action is performance synchronously, which means that
  page collapses happen earlier and more rapidly. This can be
  useful or not, depending on the scenario.
- "hugepage" action may trigger a VMA split in some scenarios, since
  it needs to change the flag of the VMA to THP enabled. This may
  lead to additional overhead.

Collapse action just adds a new option to chose the correct system
balance.

Link: https://lore.kernel.org/20260426231619.107231-5-sj@kernel.org
Link: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/ [1]
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Cheng-Han Wu <hank20010209@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst      |    4 ++++
 include/linux/damon.h                  |    2 ++
 mm/damon/sysfs-schemes.c               |    4 ++++
 mm/damon/vaddr.c                       |    3 +++
 tools/testing/selftests/damon/sysfs.py |   11 ++++++-----
 5 files changed, 19 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/design.rst~mm-damon-support-madv_collapse-via-damos_collapse-scheme-action
+++ a/Documentation/mm/damon/design.rst
@@ -474,6 +474,10 @@ that supports each action are as below.
    Supported by ``vaddr`` and ``fvaddr`` operations set. When
    TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
    fail.
+ - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
--- a/include/linux/damon.h~mm-damon-support-madv_collapse-via-damos_collapse-scheme-action
+++ a/include/linux/damon.h
@@ -121,6 +121,7 @@ struct damon_target {
  * @DAMOS_PAGEOUT:	Reclaim the region.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
+ * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
@@ -140,6 +141,7 @@ enum damos_action {
 	DAMOS_PAGEOUT,
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
+	DAMOS_COLLAPSE,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
--- a/mm/damon/sysfs-schemes.c~mm-damon-support-madv_collapse-via-damos_collapse-scheme-action
+++ a/mm/damon/sysfs-schemes.c
@@ -2117,6 +2117,10 @@ static struct damos_sysfs_action_name da
 		.name = "nohugepage",
 	},
 	{
+		.action = DAMOS_COLLAPSE,
+		.name = "collapse",
+	},
+	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
 	},
--- a/mm/damon/vaddr.c~mm-damon-support-madv_collapse-via-damos_collapse-scheme-action
+++ a/mm/damon/vaddr.c
@@ -903,6 +903,9 @@ static unsigned long damon_va_apply_sche
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+	case DAMOS_COLLAPSE:
+		madv_action = MADV_COLLAPSE;
+		break;
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
--- a/tools/testing/selftests/damon/sysfs.py~mm-damon-support-madv_collapse-via-damos_collapse-scheme-action
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -127,11 +127,12 @@ def assert_scheme_committed(scheme, dump
             'pageout': 2,
             'hugepage': 3,
             'nohugeapge': 4,
-            'lru_prio': 5,
-            'lru_deprio': 6,
-            'migrate_hot': 7,
-            'migrate_cold': 8,
-            'stat': 9,
+            'collapse': 5,
+            'lru_prio': 6,
+            'lru_deprio': 7,
+            'migrate_hot': 8,
+            'migrate_cold': 9,
+            'stat': 10,
             }
     assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
     assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are


