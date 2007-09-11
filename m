From: akpm@linux-foundation.org
Subject: + intel_agp-fix-stolen-mem-range-on-g33.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:13:26 -0700
Message-ID: <200709110513.l8B5DQVl026812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbXIKFOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, airlied@linux.ie, davej@codemonkey.org.uk


The patch titled
     intel_agp: fix stolen mem range on G33
has been added to the -mm tree.  Its filename is
     intel_agp-fix-stolen-mem-range-on-g33.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel_agp: fix stolen mem range on G33
From: Zhenyu Wang <zhenyu.z.wang@intel.com>

G33 GTT stolen memory is below graphics data stolen memory and be seperate,
so don't subtract it in stolen mem counting.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-fix-stolen-mem-range-on-g33 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-fix-stolen-mem-range-on-g33
+++ a/drivers/char/agp/intel-agp.c
@@ -513,6 +513,11 @@ static void intel_i830_init_gtt_entries(
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

intel_agp-fix-stolen-mem-range-on-g33.patch
