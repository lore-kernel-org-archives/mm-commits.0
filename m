From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
 removed from -mm tree
Date: Thu, 04 Sep 2014 14:35:04 -0700
Message-ID: <5408db08.8oi1xej9B0npEKvR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaIDVfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 17:35:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: include/linux/kernel.h:744:28: note: in expansion of macro 'min'
has been removed from the -mm tree.  Its filename was
     include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch

This patch was dropped because it was folded into include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: include/linux/kernel.h:744:28: note: in expansion of macro 'min'

On Fri, Jun 20 2014, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>> include/linux/kernel.h:744:28: note: in expansion of macro 'min'
>     #define clamp(val, lo, hi) min(max(val, lo), hi)
>                                ^
>>> drivers/net/ethernet/intel/i40e/i40e_debugfs.c:1901:11: note: in expans=
ion of macro 'clamp'
>       bytes =3D clamp(bytes, (u16)1024, (u16)I40E_MAX_AQ_BUF_SIZE);
>               ^

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix include/linux/kernel.h
--- a/include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix
+++ a/include/linux/kernel.h
@@ -715,8 +715,8 @@ static inline void ftrace_dump(enum ftra
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
-#define min3(x, y, z) min(min(x, y), z)
-#define max3(x, y, z) max(max(x, y), z)
+#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define max3(x, y, z) max((typeof(x))max(x, y), z)
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
@@ -737,7 +737,7 @@ static inline void ftrace_dump(enum ftra
  * This macro does strict typechecking of min/max to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min(max(val, lo), hi)
+#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
 
 /*
  * ..and if you can't take the strict
_

Patches currently in -mm which might be from mina86@mina86.com are

mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

