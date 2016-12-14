From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-locked-parameter-to-get_user_pages_remote-fix.patch removed from -mm tree
Date: Wed, 14 Dec 2016 14:31:34 -0800
Message-ID: <5851c846.auujSO7d4t/pPFG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbcLNWaq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:30:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, lstoakes@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfio iommu type1: merge fix for get_user_pages_remote API change
has been removed from the -mm tree.  Its filename was
     mm-add-locked-parameter-to-get_user_pages_remote-fix.patch

This patch was dropped because it was folded into mm-add-locked-parameter-to-get_user_pages_remote.patch

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

mm-add-locked-parameter-to-get_user_pages_remote.patch

