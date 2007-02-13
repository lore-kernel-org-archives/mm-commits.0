From: akpm@linux-foundation.org
Subject: + saa7134-cleanup.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:15:17 -0800
Message-ID: <200702130515.l1D5FHIr022407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54770 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161027AbXBMFPn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:15:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shdl@zakalwe.fi, heikki.orsila@iki.fi, mchehab@infradead.org


The patch titled
     saa7134: cleanup
has been added to the -mm tree.  Its filename is
     saa7134-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: saa7134: cleanup
From: Heikki Orsila <shdl@zakalwe.fi>

 - use generic sort instead of bubblesort
 - removed useless saa7134_video_fini function
 - small coding style changes

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-core.c  |    1 
 drivers/media/video/saa7134/saa7134-video.c |   76 ++++++------------
 drivers/media/video/saa7134/saa7134.h       |    1 
 3 files changed, 28 insertions(+), 50 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-core.c~saa7134-cleanup drivers/media/video/saa7134/saa7134-core.c
--- a/drivers/media/video/saa7134/saa7134-core.c~saa7134-cleanup
+++ a/drivers/media/video/saa7134/saa7134-core.c
@@ -703,7 +703,6 @@ static int saa7134_hwfini(struct saa7134
 		saa7134_ts_fini(dev);
 	saa7134_input_fini(dev);
 	saa7134_vbi_fini(dev);
-	saa7134_video_fini(dev);
 	saa7134_tvaudio_fini(dev);
 	return 0;
 }
diff -puN drivers/media/video/saa7134/saa7134.h~saa7134-cleanup drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~saa7134-cleanup
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -620,7 +620,6 @@ int saa7134_common_ioctl(struct saa7134_
 
 int saa7134_video_init1(struct saa7134_dev *dev);
 int saa7134_video_init2(struct saa7134_dev *dev);
-int saa7134_video_fini(struct saa7134_dev *dev);
 void saa7134_irq_video_intl(struct saa7134_dev *dev);
 void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status);
 
diff -puN drivers/media/video/saa7134/saa7134-video.c~saa7134-cleanup drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~saa7134-cleanup
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -26,6 +26,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 
 #include "saa7134-reg.h"
 #include "saa7134.h"
@@ -516,14 +517,12 @@ static int res_get(struct saa7134_dev *d
 	return 1;
 }
 
-static
-int res_check(struct saa7134_fh *fh, unsigned int bit)
+static int res_check(struct saa7134_fh *fh, unsigned int bit)
 {
 	return (fh->resources & bit);
 }
 
-static
-int res_locked(struct saa7134_dev *dev, unsigned int bit)
+static int res_locked(struct saa7134_dev *dev, unsigned int bit)
 {
 	return (dev->resources & bit);
 }
@@ -732,25 +731,6 @@ struct cliplist {
 	__u8  disable;
 };
 
-static void sort_cliplist(struct cliplist *cl, int entries)
-{
-	struct cliplist swap;
-	int i,j,n;
-
-	for (i = entries-2; i >= 0; i--) {
-		for (n = 0, j = 0; j <= i; j++) {
-			if (cl[j].position > cl[j+1].position) {
-				swap = cl[j];
-				cl[j] = cl[j+1];
-				cl[j+1] = swap;
-				n++;
-			}
-		}
-		if (0 == n)
-			break;
-	}
-}
-
 static void set_cliplist(struct saa7134_dev *dev, int reg,
 			struct cliplist *cl, int entries, char *name)
 {
@@ -784,15 +764,27 @@ static int clip_range(int val)
 	return val;
 }
 
+/* Sort into smallest position first order */
+static int cliplist_cmp(const void *a, const void *b)
+{
+	const struct cliplist *cla = a;
+	const struct cliplist *clb = b;
+	if (cla->position < clb->position)
+		return -1;
+	if (cla->position > clb->position)
+		return 1;
+	return 0;
+}
+
 static int setup_clipping(struct saa7134_dev *dev, struct v4l2_clip *clips,
 			  int nclips, int interlace)
 {
 	struct cliplist col[16], row[16];
-	int cols, rows, i;
+	int cols = 0, rows = 0, i;
 	int div = interlace ? 2 : 1;
 
-	memset(col,0,sizeof(col)); cols = 0;
-	memset(row,0,sizeof(row)); rows = 0;
+	memset(col, 0, sizeof(col));
+	memset(row, 0, sizeof(row));
 	for (i = 0; i < nclips && i < 8; i++) {
 		col[cols].position = clip_range(clips[i].c.left);
 		col[cols].enable   = (1 << i);
@@ -808,8 +800,8 @@ static int setup_clipping(struct saa7134
 		row[rows].disable  = (1 << i);
 		rows++;
 	}
-	sort_cliplist(col,cols);
-	sort_cliplist(row,rows);
+	sort(col, cols, sizeof col[0], cliplist_cmp, NULL);
+	sort(row, rows, sizeof row[0], cliplist_cmp, NULL);
 	set_cliplist(dev,0x380,col,cols,"cols");
 	set_cliplist(dev,0x384,row,rows,"rows");
 	return 0;
@@ -1261,19 +1253,14 @@ static struct videobuf_queue* saa7134_qu
 
 static int saa7134_resource(struct saa7134_fh *fh)
 {
-	int res = 0;
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return RESOURCE_VIDEO;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		res = RESOURCE_VIDEO;
-		break;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		res = RESOURCE_VBI;
-		break;
-	default:
-		BUG();
-	}
-	return res;
+	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
+		return RESOURCE_VBI;
+
+	BUG();
+	return 0;
 }
 
 static int video_open(struct inode *inode, struct file *file)
@@ -1461,8 +1448,7 @@ static int video_release(struct inode *i
 	return 0;
 }
 
-static int
-video_mmap(struct file *file, struct vm_area_struct * vma)
+static int video_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct saa7134_fh *fh = file->private_data;
 
@@ -2461,12 +2447,6 @@ int saa7134_video_init2(struct saa7134_d
 	return 0;
 }
 
-int saa7134_video_fini(struct saa7134_dev *dev)
-{
-	/* nothing */
-	return 0;
-}
-
 void saa7134_irq_video_intl(struct saa7134_dev *dev)
 {
 	static const char *st[] = {
_

Patches currently in -mm which might be from shdl@zakalwe.fi are

saa7134-cleanup.patch
