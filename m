From: akpm@linux-foundation.org
Subject: - x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:18 -0700
Message-ID: <200710051958.l95JwIBb022536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762031AbXJEUBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, mm-commits@vger.kernel.org


The patch titled
     x86-64: pci-gart iommu sg chaining zeroes wrong sg
has been removed from the -mm tree.  Its filename was
     x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: pci-gart iommu sg chaining zeroes wrong sg
From: FUJITA Tomonori <tomof@acm.org>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-gart.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/pci-gart.c~x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -426,8 +426,10 @@ int gart_map_sg(struct device *dev, stru
 		goto error;
 	out++;
 	flush_gart();
-	if (out < nents)
-		ps->dma_length = 0;
+	if (out < nents) {
+		sgmap = sg_next(sgmap);
+		sgmap->dma_length = 0;
+	}
 	return out;
 
 error:
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
git-block.patch
git-block-intel-iommu-sg-chaining-support.patch
