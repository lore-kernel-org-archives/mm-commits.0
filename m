From: akpm@linux-foundation.org
Subject: [merged] slub-use-raw_cpu_inc-for-incrementing-statistics.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:47:45 -0700
Message-ID: <53446e81.rki6bYIlAAzXG6xs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbaDHVrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, fengguang.wu@intel.com, cl@linux.com

Subject: [merged] slub-use-raw_cpu_inc-for-incrementing-statistics.patch removed from -mm tree
To: cl@linux.com,fengguang.wu@intel.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:47:45 -0700


The patch titled
     Subject: slub: use raw_cpu_inc for incrementing statistics
has been removed from the -mm tree.  Its filename was
     slub-use-raw_cpu_inc-for-incrementing-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: use raw_cpu_inc for incrementing statistics

Statistics are not critical to the operation of the allocation
but should also not cause too much overhead.

When __this_cpu_inc is altered to check if preemption is disabled this
triggers.  Use raw_cpu_inc to avoid the checks.  Using this_cpu_ops may
cause interrupt disable/enable sequences on various arches which may
significantly impact allocator performance.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-use-raw_cpu_inc-for-incrementing-statistics mm/slub.c
--- a/mm/slub.c~slub-use-raw_cpu_inc-for-incrementing-statistics
+++ a/mm/slub.c
@@ -224,7 +224,11 @@ static inline void memcg_propagate_slab_
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
-	__this_cpu_inc(s->cpu_slab->stat[si]);
+	/*
+	 * The rmw is racy on a preemptible kernel but this is acceptable, so
+	 * avoid this_cpu_add()'s irq-disable overhead.
+	 */
+	raw_cpu_inc(s->cpu_slab->stat[si]);
 #endif
 }
 
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

