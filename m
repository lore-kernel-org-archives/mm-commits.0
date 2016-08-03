From: akpm@linux-foundation.org
Subject: [merged] lib-iommu-helper-skip-to-next-segment.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:19 -0700
Message-ID: <57a23403.SUoq2Grvly4fez5d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbcHCSNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/iommu-helper: skip to next segment
has been removed from the -mm tree.  Its filename was
     lib-iommu-helper-skip-to-next-segment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: lib/iommu-helper: skip to next segment

When a large enough area in the iommu bitmap is found but would span a
boundary we continue the search starting from the next bit position.  For
large allocations this can lead to several useless invocations of
bitmap_find_next_zero_area() and iommu_is_span_boundary().

Continue the search from the start of the next segment (which is the next
bit position such that we'll not cross the same segment boundary again).

Link: http://lkml.kernel.org/r/alpine.LFD.2.20.1606081910070.3211@schleppi
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iommu-helper.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/iommu-helper.c~lib-iommu-helper-skip-to-next-segment lib/iommu-helper.c
--- a/lib/iommu-helper.c~lib-iommu-helper-skip-to-next-segment
+++ a/lib/iommu-helper.c
@@ -29,8 +29,7 @@ again:
 	index = bitmap_find_next_zero_area(map, size, start, nr, align_mask);
 	if (index < size) {
 		if (iommu_is_span_boundary(index, nr, shift, boundary_size)) {
-			/* we could do more effectively */
-			start = index + 1;
+			start = ALIGN(shift + index, boundary_size) - shift;
 			goto again;
 		}
 		bitmap_set(map, index, nr);
_

Patches currently in -mm which might be from sebott@linux.vnet.ibm.com are


