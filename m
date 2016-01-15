From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:35 -0800
Message-ID: <569973bf.2acgG4OD/1lEbCLh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcAOWdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, cmetcalf@ezchip.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove incorrect MAP_FIXED flag comparison from mmap_region
has been removed from the -mm tree.  Its filename was
     mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm/mmap.c: remove incorrect MAP_FIXED flag comparison from mmap_region

The following flag comparison in mmap_region makes no sense:

if (!(vm_flags & MAP_FIXED))
    return -ENOMEM;

The condition is always false and thus the above "return -ENOMEM" is never
executed.  The vm_flags must not be compared with MAP_FIXED flag.  The
vm_flags may only be compared with VM_* flags.  MAP_FIXED has the same
value as VM_MAYREAD.

Hitting the rlimit is a slow path and find_vma_intersection should realize
that there is no overlapping VMA for !MAP_FIXED case pretty quickly.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region
+++ a/mm/mmap.c
@@ -1551,9 +1551,6 @@ unsigned long mmap_region(struct file *f
 		 * MAP_FIXED may remove pages of mappings that intersects with
 		 * requested mapping. Account for the pages it would unmap.
 		 */
-		if (!(vm_flags & MAP_FIXED))
-			return -ENOMEM;
