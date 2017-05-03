From: akpm@linux-foundation.org
Subject: [patch 067/102] mm/mmap: replace SHM_HUGE_MASK with
 MAP_HUGE_MASK inside mmap_pgoff
Date: Wed, 03 May 2017 14:55:00 -0700
Message-ID: <20170503215500.q3rV6arpa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdECV4B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, khandual@linux.vnet.ibm.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
