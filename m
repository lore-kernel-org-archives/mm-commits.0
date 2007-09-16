From: akpm@linux-foundation.org
Subject: - intel_agp-fix-stolen-mem-range-on-g33.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:12 -0700
Message-ID: <200709160926.l8G9QCZc009166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbXIPJii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, airlied@linux.ie, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel_agp: fix stolen mem range on G33
has been removed from the -mm tree.  Its filename was
     intel_agp-fix-stolen-mem-range-on-g33.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_agp: fix stolen mem range on G33
From: Zhenyu Wang <zhenyu.z.wang@intel.com>

G33 GTT stolen memory is below graphics data stolen memory and be seperate,
so don't subtract it in stolen mem counting.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Acked-by: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-fix-stolen-mem-range-on-g33 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-fix-stolen-mem-range-on-g33
+++ a/drivers/char/agp/intel-agp.c
@@ -506,6 +506,11 @@ static void intel_i830_init_gtt_entries(
 			break;
 		}
 	} else {
+		/* G33's GTT stolen memory is separate from gfx data
+		 * stolen memory.
+		 */
+		if (IS_G33)
+			size = 0;
 		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
 			gtt_entries = MB(1) - KB(size);
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

origin.patch
intel-agp-fix-i830-mask-variable-that-changed-with-g33-support.patch
