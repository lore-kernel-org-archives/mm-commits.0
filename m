From: akpm@linux-foundation.org
Subject: - drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:50 -0700
Message-ID: <200807242331.m6ONVo1i011672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756740AbYGXXcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/aty/radeon_base.c: notify user if sysfs_create_bin_file() failed
has been removed from the -mm tree.  Its filename was
     drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/aty/radeon_base.c: notify user if sysfs_create_bin_file() failed
From: Tony Breeds <tony@bakeyournoodle.com>

Current kernel builds warn about:
drivers/video/aty/radeon_base.c: In function 'radeonfb_pci_register':
drivers/video/aty/radeon_base.c:2334: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
drivers/video/aty/radeon_base.c:2336: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result

Do minimal checking of these functions and issue a warning if either
fails.  They don't seem to be critical..

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed
+++ a/drivers/video/aty/radeon_base.c
@@ -2161,6 +2161,7 @@ static int __devinit radeonfb_pci_regist
 	struct radeonfb_info *rinfo;
 	int ret;
 	unsigned char c1, c2;
+	int err = 0;
 
 	pr_debug("radeonfb_pci_register BEGIN\n");
 	
@@ -2340,9 +2341,14 @@ static int __devinit radeonfb_pci_regist
 
 	/* Register some sysfs stuff (should be done better) */
 	if (rinfo->mon1_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj,
+						&edid1_attr);
 	if (rinfo->mon2_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj,
+						&edid2_attr);
+	if (err)
+		pr_warning("%s() Creating sysfs files failed, continuing\n",
+			   __func__);
 
 	/* save current mode regs before we switch into the new one
 	 * so we can restore this upon __exit
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

origin.patch

