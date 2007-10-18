From: akpm@linux-foundation.org
Subject: - floppy-tolerate-dma-channel-unavailability.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:16 -0700
Message-ID: <200710180657.l9I6vGlP030801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760048AbXJRHPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     floppy: tolerate DMA channel unavailability
has been removed from the -mm tree.  Its filename was
     floppy-tolerate-dma-channel-unavailability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: floppy: tolerate DMA channel unavailability
From: "Jan Beulich" <jbeulich@novell.com>

The floppy driver is already written to be able to operate in virtual DMA
mode.  Thus it can easily be adjusted to tolerate failure from
fd_request_dma() as long as virtual DMA mode is not disallowed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/block/floppy.c~floppy-tolerate-dma-channel-unavailability drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-tolerate-dma-channel-unavailability
+++ a/drivers/block/floppy.c
@@ -4388,11 +4388,15 @@ static int floppy_grab_irq_and_dma(void)
 	if (fd_request_dma()) {
 		DPRINT("Unable to grab DMA%d for the floppy driver\n",
 		       FLOPPY_DMA);
-		fd_free_irq();
-		spin_lock_irqsave(&floppy_usage_lock, flags);
-		usage_count--;
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
-		return -1;
+		if (can_use_virtual_dma & 2)
+			use_virtual_dma = can_use_virtual_dma = 1;
+		if (!(can_use_virtual_dma & 1)) {
+			fd_free_irq();
+			spin_lock_irqsave(&floppy_usage_lock, flags);
+			usage_count--;
+			spin_unlock_irqrestore(&floppy_usage_lock, flags);
+			return -1;
+		}
 	}
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
