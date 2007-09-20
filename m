From: akpm@linux-foundation.org
Subject: - intel-agp-fix-i830-mask-variable-that-changed-with-g33-support.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:39 -0700
Message-ID: <200709202115.l8KLFdmZ002927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbXITV2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, laga@laga.ath.cx, zhenyu.z.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel-agp: Fix i830 mask variable that changed with G33 support
has been removed from the -mm tree.  Its filename was
     intel-agp-fix-i830-mask-variable-that-changed-with-g33-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel-agp: Fix i830 mask variable that changed with G33 support
From: Dave Airlie <airlied@linux.ie>

The mask on i830 should be 0x70 always, later chips 0xF0 should be okay.

Signed-off-by: Dave Airlie <airlied@linux.ie>
Cc: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Michael Haas <laga@laga.ath.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h       |    3 ++-
 drivers/char/agp/intel-agp.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/agp/agp.h~intel-agp-fix-i830-mask-variable-that-changed-with-g33-support drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~intel-agp-fix-i830-mask-variable-that-changed-with-g33-support
+++ a/drivers/char/agp/agp.h
@@ -176,7 +176,7 @@ struct agp_bridge_data {
 #define I830_GMCH_MEM_MASK		0x1
 #define I830_GMCH_MEM_64M		0x1
 #define I830_GMCH_MEM_128M		0
-#define I830_GMCH_GMS_MASK		0xF0
+#define I830_GMCH_GMS_MASK		0x70
 #define I830_GMCH_GMS_DISABLED		0x00
 #define I830_GMCH_GMS_LOCAL		0x10
 #define I830_GMCH_GMS_STOLEN_512	0x20
@@ -190,6 +190,7 @@ struct agp_bridge_data {
 #define INTEL_I830_ERRSTS	0x92
 
 /* Intel 855GM/852GM registers */
+#define I855_GMCH_GMS_MASK		0xF0
 #define I855_GMCH_GMS_STOLEN_0M		0x0
 #define I855_GMCH_GMS_STOLEN_1M		(0x1 << 4)
 #define I855_GMCH_GMS_STOLEN_4M		(0x2 << 4)
diff -puN drivers/char/agp/intel-agp.c~intel-agp-fix-i830-mask-variable-that-changed-with-g33-support drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agp-fix-i830-mask-variable-that-changed-with-g33-support
+++ a/drivers/char/agp/intel-agp.c
@@ -511,7 +511,7 @@ static void intel_i830_init_gtt_entries(
 		 */
 		if (IS_G33)
 			size = 0;
-		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
+		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
 			gtt_entries = MB(1) - KB(size);
 			break;
_

Patches currently in -mm which might be from airlied@linux.ie are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-drm.patch
drm-via-invalid-device-ids-removal.patch
agp-fix-race-condition-between-unmapping-and-freeing-pages.patch
convert-ill-defined-log2-to-ilog2.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
