From: akpm@linux-foundation.org
Subject: +
 include-kernelh-deduplicate-code-implementing-clamp-macros.patch added to
 -mm tree
Date: Thu, 25 Sep 2014 12:23:05 -0700
Message-ID: <54246b99.kb4fyPJKuDIZwrac%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaIYTXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 15:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, hagen@jauu.net, jeffrey.t.kirsher@intel.com, mark.d.rustad@intel.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kernel.h: deduplicate code implementing clamp* macros
has been added to the -mm tree.  Its filename is
     include-kernelh-deduplicate-code-implementing-clamp-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-kernelh-deduplicate-code-implementing-clamp-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-kernelh-deduplicate-code-implementing-clamp-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: include/linux/kernel.h: deduplicate code implementing clamp* macros

Instead of open-coding clamp_t macro min_t and max_t the way clamp macro
does and instead of open-coding clamp_val simply use clamp_t. 
Furthermore, normalise argument naming in the macros to be lo and hi.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff -puN include/linux/kernel.h~include-kernelh-deduplicate-code-implementing-clamp-macros include/linux/kernel.h
--- a/include/linux/kernel.h~include-kernelh-deduplicate-code-implementing-clamp-macros
+++ a/include/linux/kernel.h
@@ -734,7 +734,7 @@ static inline void ftrace_dump(enum ftra
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of min/max to make sure they are of the
+ * This macro does strict typechecking of lo/hi to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
 #define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
@@ -759,36 +759,26 @@ static inline void ftrace_dump(enum ftra
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
  * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
  *
  * This macro does no typechecking and uses temporary variables of type
  * 'type' to make all the comparisons.
  */
-#define clamp_t(type, val, min, max) ({		\
-	type __val = (val);			\
-	type __min = (min);			\
-	type __max = (max);			\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
  * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
  *
  * This macro does no typechecking and uses temporary variables of whatever
  * type the input argument 'val' is.  This is useful when val is an unsigned
  * type and min and max are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, min, max) ({		\
-	typeof(val) __val = (val);		\
-	typeof(val) __min = (min);		\
-	typeof(val) __max = (max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 
 /*
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
drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
include-kernelh-deduplicate-code-implementing-clamp-macros.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

