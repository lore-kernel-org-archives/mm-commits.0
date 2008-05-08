From: akpm@linux-foundation.org
Subject: + intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running.patch added to -mm tree
Date: Thu, 08 May 2008 13:34:39 -0700
Message-ID: <200805082034.m48KYdNf004506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbYEHUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:35:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, greg@kroah.com, jbarnes@virtuousgeek.org


The patch titled
     intel-iommu: make intel iommu_wait_op() work when jiffies aren't running
has been added to the -mm tree.  Its filename is
     intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running.patch

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
Subject: intel-iommu: make intel iommu_wait_op() work when jiffies aren't running
From: mark gross <mgross@linux.intel.com>

I've noticed that a few times when the bios is buggy the code for detecting
failing DMAR hardware can get stuck in an infinite loop in early boot waiting
for jiffies to time out.  Which are not running at the time we get stuck in
this macro.

This patch replaces the use of the jiffies to detect the failing hardware with
the tsc counter.  Not a big change, instead of getting a black screen forever,
you get a panic...

I also changed the time out from an arbitrary 60 seconds to an arbitrary 10
seconds.

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running
+++ a/drivers/pci/intel-iommu.c
@@ -49,7 +49,7 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
 
-#define DMAR_OPERATION_TIMEOUT (HZ*60) /* 1m */
+#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
 
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
@@ -490,13 +490,13 @@ static int iommu_alloc_root_entry(struct
 
 #define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
 {\
-	unsigned long start_time = jiffies;\
+	cycles_t start_time = get_cycles();\
 	while (1) {\
 		sts = op (iommu->reg + offset);\
 		if (cond)\
 			break;\
-		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))\
-			panic("DMAR hardware is malfunctioning\n");\
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
+			panic(KERN_ERR "DMAR hardware is malfunctioning\n");\
 		cpu_relax();\
 	}\
 }
_

Patches currently in -mm which might be from mgross@linux.intel.com are

intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running.patch

