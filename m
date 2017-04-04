From: akpm@linux-foundation.org
Subject: +
 mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch
 added to -mm tree
Date: Tue, 04 Apr 2017 13:33:13 -0700
Message-ID: <58e40309./PKC4zCm1jTW/YP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54090 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdDDUdO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2017 16:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, bsingharora@gmail.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: replace SHM_HUGE_MASK with MAP_HUGE_MASK inside mmap_pgoff
has been added to the -mm tree.  Its filename is
     mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch

