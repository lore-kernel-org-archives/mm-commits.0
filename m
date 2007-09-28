From: akpm@linux-foundation.org
Subject: + x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:36:33 -0700
Message-ID: <200709280636.l8S6aXVl014884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756847AbXI1Ggg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org


The patch titled
     x86-64: pci-gart iommu sg chaining zeroes wrong sg
has been added to the -mm tree.  Its filename is
     x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -428,8 +428,10 @@ static int gart_map_sg(struct device *de
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
x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg.patch
