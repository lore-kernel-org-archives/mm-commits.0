From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:12:26 -0700
Message-ID: <20170504191226.S_nA3BAHV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756354AbdEDTM1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:12:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, khandual@linux.vnet.ibm.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: replace SHM_HUGE_MASK with MAP_HUGE_MASK inside mmap_pgoff
has been removed from the -mm tree.  Its filename was
     mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/mmap: replace SHM_HUGE_MASK with MAP_HUGE_MASK inside mmap_pgoff

091d0d55b286 ("shm: fix null pointer deref when userspace specifies
invalid hugepage size") had replaced MAP_HUGE_MASK with SHM_HUGE_MASK. 
Though both of them contain the same numeric value of 0x3f, MAP_HUGE_MASK
flag sounds more appropriate than the other one in the context.  Hence
change it back.

Link: http://lkml.kernel.org/r/20170404045635.616-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff mm/mmap.c
--- a/mm/mmap.c~mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff
+++ a/mm/mmap.c
@@ -1479,7 +1479,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 		struct user_struct *user = NULL;
 		struct hstate *hs;
 
-		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & SHM_HUGE_MASK);
+		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
 		if (!hs)
 			return -EINVAL;
 
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

selftests-vm-add-a-test-for-virtual-address-range-mapping.patch

