From: akpm@linux-foundation.org
Subject: - fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:25 -0800
Message-ID: <200802070028.m170S6JE007117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935071AbYBGAot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbcon: fix sparse warning about shadowing 'rotate' symbol
has been removed from the -mm tree.  Its filename was
     fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: fix sparse warning about shadowing 'rotate' symbol
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-sparse-warning-about-shadowing-rotate-symbol drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-sparse-warning-about-shadowing-rotate-symbol
+++ a/drivers/video/console/fbcon.c
@@ -147,7 +147,7 @@ static char fontname[40];
 static int info_idx = -1;
 
 /* console rotation */
-static int rotate;
+static int initial_rotation;
 static int fbcon_has_sysfs;
 
 static const struct consw fb_con;
@@ -537,9 +537,9 @@ static int __init fb_console_setup(char 
 		if (!strncmp(options, "rotate:", 7)) {
 			options += 7;
 			if (*options)
-				rotate = simple_strtoul(options, &options, 0);
-			if (rotate > 3)
-				rotate = 0;
+				initial_rotation = simple_strtoul(options, &options, 0);
+			if (initial_rotation > 3)
+				initial_rotation = 0;
 		}
 	}
 	return 1;
@@ -989,7 +989,7 @@ static const char *fbcon_startup(void)
 	ops->graphics = 1;
 	ops->cur_rotate = -1;
 	info->fbcon_par = ops;
-	p->con_rotate = rotate;
+	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
 
 	if (info->fix.type != FB_TYPE_TEXT) {
@@ -1176,7 +1176,7 @@ static void fbcon_init(struct vc_data *v
 		con_copy_unimap(vc, svc);
 
 	ops = info->fbcon_par;
-	p->con_rotate = rotate;
+	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
 
 	cols = vc->vc_cols;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core.patch
ext3-replace-all-adds-to-little-endians-variables-with-le_add_cpu.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
