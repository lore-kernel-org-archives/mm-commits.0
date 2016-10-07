From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-percpuc-correct-max_distance-calculation-for-pcpu_embed_first_chunk.patch removed from -mm tree
Date: Fri, 07 Oct 2016 15:35:38 -0700
Message-ID: <57f8233a.KGqxHNNqe+bhuDSF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37131 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbcJGWfj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 18:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, cl@linux.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu.c: correct max_distance calculation for pcpu_embed_first_chunk()
has been removed from the -mm tree.  Its filename was
     mm-percpuc-correct-max_distance-calculation-for-pcpu_embed_first_chunk.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/percpu.c: correct max_distance calculation for pcpu_embed_first_chunk()

It is am error to represent the max range max_distance spanned by all the
group areas as the offset of the highest group area plus unit size in
pcpu_embed_first_chunk().  It should be equal to the offset plus the size
of the highest group area.

In order to fix this issue, let us find the highest group area which has
the biggest base address, then max_distance is formed by adding its offset
and size values.

The type of variable max_distance is changed from size_t to unsigned long
to prevent potential overflows.

Link: http://lkml.kernel.org/r/0310bf92-c8da-459f-58e3-40b8bfbb7223@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/percpu.c~mm-percpuc-correct-max_distance-calculation-for-pcpu_embed_first_chunk mm/percpu.c
--- a/mm/percpu.c~mm-percpuc-correct-max_distance-calculation-for-pcpu_embed_first_chunk
+++ a/mm/percpu.c
@@ -1961,7 +1961,8 @@ int __init pcpu_embed_first_chunk(size_t
 	void *base = (void *)ULONG_MAX;
 	void **areas = NULL;
 	struct pcpu_alloc_info *ai;
-	size_t size_sum, areas_size, max_distance;
+	size_t size_sum, areas_size;
+	unsigned long max_distance;
 	int group, i, rc;
 
 	ai = pcpu_build_alloc_info(reserved_size, dyn_size, atom_size,
@@ -2023,17 +2024,18 @@ int __init pcpu_embed_first_chunk(size_t
 	}
 
 	/* base address is now known, determine group base offsets */
-	max_distance = 0;
+	i = 0;
 	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
-		max_distance = max_t(size_t, max_distance,
-				     ai->groups[group].base_offset);
+		if (areas[group] > areas[i])
+			i = group;
 	}
-	max_distance += ai->unit_size;
+	max_distance = ai->groups[i].base_offset +
+		(unsigned long)ai->unit_size * ai->groups[i].nr_units;
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
-		pr_warn("max_distance=0x%zx too large for vmalloc space 0x%lx\n",
+		pr_warn("max_distance=0x%lx too large for vmalloc space 0x%lx\n",
 			max_distance, VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
_

Patches currently in -mm which might be from zijun_hu@htc.com are

mm-vmalloc-fix-align-value-calculation-error.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch
mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements.patch
mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch
linux-mmh-canonicalize-macro-page_aligned-definition.patch

