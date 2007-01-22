From: akpm@osdl.org
Subject: - cpiac-buffer-overflow.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:45:49 -0800
Message-ID: <200701222045.l0MKjnu5001499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50348 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbXAVUqi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     cpia.c: buffer overflow
has been removed from the -mm tree.  Its filename was
     cpiac-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpia.c: buffer overflow
From: Alexey Dobriyan <adobriyan@gmail.com>

If assigned minor is 10 or greater, terminator will be put beyound the end.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/cpia.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/cpia.c~cpiac-buffer-overflow drivers/media/video/cpia.c
--- a/drivers/media/video/cpia.c~cpiac-buffer-overflow
+++ a/drivers/media/video/cpia.c
@@ -1350,13 +1350,13 @@ out:
 
 static void create_proc_cpia_cam(struct cam_data *cam)
 {
-	char name[7];
+	char name[5 + 1 + 10 + 1];
 	struct proc_dir_entry *ent;
 
 	if (!cpia_proc_root || !cam)
 		return;
 
-	sprintf(name, "video%d", cam->vdev.minor);
+	snprintf(name, sizeof(name), "video%d", cam->vdev.minor);
 
 	ent = create_proc_entry(name, S_IFREG|S_IRUGO|S_IWUSR, cpia_proc_root);
 	if (!ent)
@@ -1376,12 +1376,12 @@ static void create_proc_cpia_cam(struct 
 
 static void destroy_proc_cpia_cam(struct cam_data *cam)
 {
-	char name[7];
+	char name[5 + 1 + 10 + 1];
 
 	if (!cam || !cam->proc_entry)
 		return;
 
-	sprintf(name, "video%d", cam->vdev.minor);
+	snprintf(name, sizeof(name), "video%d", cam->vdev.minor);
 	remove_proc_entry(name, cpia_proc_root);
 	cam->proc_entry = NULL;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
proc-remove-useless-and-buggy-nlink-settings.patch
