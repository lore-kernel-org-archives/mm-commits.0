From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:20:51 -0800
Message-ID: <54de5ca3.T3Ry2D69fgdP5rq4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbBMUUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, hughd@google.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, mgorman@suse.de, mina86@mina86.com, paul.gortmaker@windriver.com, peterz@infradead.org, pintu.k@samsung.com, riel@redhat.com, rientjes@google.com, tim.c.chen@linux.intel.com, tj@kernel.org, vbabka@suse.cz, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: pull out init code from build_all_zonelists
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/page_alloc.c: pull out init code from build_all_zonelists

Pulling the code protected by if (system_state == SYSTEM_BOOTING) into
its own helper allows us to shrink .text a little. This relies on
build_all_zonelists already having a __ref annotation. Add a comment
explaining why so one doesn't have to track it down through git log.

The real saving comes in 3/5, ("mm/mm_init.c: Mark mminit_verify_zonelist
as __init"), where we save about 400 bytes

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-pull-out-init-code-from-build_all_zonelists mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-pull-out-init-code-from-build_all_zonelists
+++ a/mm/page_alloc.c
@@ -3871,18 +3871,29 @@ static int __build_all_zonelists(void *d
 	return 0;
 }
 
+static noinline void __init
+build_all_zonelists_init(void)
+{
+	__build_all_zonelists(NULL);
+	mminit_verify_zonelist();
+	cpuset_init_current_mems_allowed();
+}
+
 /*
  * Called with zonelists_mutex held always
  * unless system_state == SYSTEM_BOOTING.
+ *
+ * __ref due to (1) call of __meminit annotated setup_zone_pageset
+ * [we're only called with non-NULL zone through __meminit paths] and
+ * (2) call of __init annotated helper build_all_zonelists_init
+ * [protected by SYSTEM_BOOTING].
  */
 void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
 {
 	set_zonelist_order();
 
 	if (system_state == SYSTEM_BOOTING) {
-		__build_all_zonelists(NULL);
-		mminit_verify_zonelist();
-		cpuset_init_current_mems_allowed();
+		build_all_zonelists_init();
 	} else {
 #ifdef CONFIG_MEMORY_HOTPLUG
 		if (zone)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

