From: akpm@linux-foundation.org
Subject: + intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix.patch added to -mm tree
Date: Thu, 08 May 2008 14:05:13 -0700
Message-ID: <200805082105.m48L5D5q005870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbYEHVFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 17:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, greg@kroah.com, jbarnes@virtuousgeek.org


The patch titled
     intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running fix
has been added to the -mm tree.  Its filename is
     intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running fix
From: mark gross <mgross@linux.intel.com>

Think-oh in patch.  it works as implemented but the panic line does not
need the KERN_ERR string included :(  Can you use the following?

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix
+++ a/drivers/pci/intel-iommu.c
@@ -496,7 +496,7 @@ static int iommu_alloc_root_entry(struct
 		if (cond)\
 			break;\
 		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
-			panic(KERN_ERR "DMAR hardware is malfunctioning\n");\
+			panic("DMAR hardware is malfunctioning\n");\
 		cpu_relax();\
 	}\
 }
_

Patches currently in -mm which might be from mgross@linux.intel.com are

intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running.patch
intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix.patch

