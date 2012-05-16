From: akpm@linux-foundation.org
Subject: [merged] video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:11 -0700
Message-ID: <20120516184711.52F5CA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38400 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760358Ab2EPSrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so126690qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.nawrocki@samsung.com, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos mipi dsi: Properly interpret the interrupt source flags
has been removed from the -mm tree.  Its filename was
     video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: video: exynos mipi dsi: Properly interpret the interrupt source flags

Rework the interrupt handler so the RX_DONE, FIFO_EMPTY interrupts are
properly detected.  This prevents missing the interrupts when there are
other bits set in the INTSRC register than just RX_DONE and FIFO_EMPTY.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi_common.c |   28 +++++-----------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/video/exynos/exynos_mipi_dsi_common.c~video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags drivers/video/exynos/exynos_mipi_dsi_common.c
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c~video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags
+++ a/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -76,33 +76,25 @@ static unsigned int dpll_table[15] = {
 
 irqreturn_t exynos_mipi_dsi_interrupt_handler(int irq, void *dev_id)
 {
-	unsigned int intsrc = 0;
-	unsigned int intmsk = 0;
-	struct mipi_dsim_device *dsim = NULL;
-
-	dsim = dev_id;
-	if (!dsim) {
-		dev_dbg(dsim->dev, KERN_ERR "%s:error: wrong parameter\n",
-							__func__);
-		return IRQ_HANDLED;
+	struct mipi_dsim_device *dsim = dev_id;
+	unsigned int intsrc, intmsk;
+
+	if (dsim == NULL) {
+		dev_err(dsim->dev, "%s: wrong parameter\n", __func__);
+		return IRQ_NONE;
 	}
 
 	intsrc = exynos_mipi_dsi_read_interrupt(dsim);
 	intmsk = exynos_mipi_dsi_read_interrupt_mask(dsim);
+	intmsk = ~intmsk & intsrc;
 
-	intmsk = ~(intmsk) & intsrc;
