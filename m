From: akpm@linux-foundation.org
Subject: [merged]
 kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:00 -0800
Message-ID: <54de5cac.j1ehc3zUDFR9xgG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbBMUVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, hughd@google.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, mgorman@suse.de, mina86@mina86.com, paul.gortmaker@windriver.com, peterz@infradead.org, pintu.k@samsung.com, riel@redhat.com, rientjes@google.com, tim.c.chen@linux.intel.com, tj@kernel.org, vbabka@suse.cz, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpuset.c: Mark cpuset_init_current_mems_allowed as __init
has been removed from the -mm tree.  Its filename was
     kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/cpuset.c: Mark cpuset_init_current_mems_allowed as __init

The only caller of cpuset_init_current_mems_allowed is the __init
annotated build_all_zonelists_init, so we can also make the former __init.

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

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init
+++ a/kernel/cpuset.c
@@ -2400,7 +2400,7 @@ void cpuset_cpus_allowed_fallback(struct
 	 */
 }
 
-void cpuset_init_current_mems_allowed(void)
+void __init cpuset_init_current_mems_allowed(void)
 {
 	nodes_setall(current->mems_allowed);
 }
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

