From: akpm@linux-foundation.org
Subject: + mm-add-locked-parameter-to-get_user_pages_remote-fix.patch
 added to -mm tree
Date: Tue, 22 Nov 2016 16:31:38 -0800
Message-ID: <5834e36a./qpbLYk3qezU6YJE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbcKWAbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:31:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, lstoakes@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfio iommu type1: merge fix for get_user_pages_remote API change
has been added to the -mm tree.  Its filename is
     mm-add-locked-parameter-to-get_user_pages_remote-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-locked-parameter-to-get_user_pages_remote-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-locked-parameter-to-get_user_pages_remote-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: vfio iommu type1: merge fix for get_user_pages_remote API change

Link: http://lkml.kernel.org/r/20161122210511.024ec341@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/vfio_iommu_type1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/vfio/vfio_iommu_type1.c~mm-add-locked-parameter-to-get_user_pages_remote-fix drivers/vfio/vfio_iommu_type1.c
--- a/drivers/vfio/vfio_iommu_type1.c~mm-add-locked-parameter-to-get_user_pages_remote-fix
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -362,7 +362,7 @@ static int vaddr_get_pfn(struct mm_struc
 
 		down_read(&mm->mmap_sem);
 		ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
-					    NULL);
+					    NULL, NULL);
 		up_read(&mm->mmap_sem);
 	}
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-add-locked-parameter-to-get_user_pages_remote-fix.patch

