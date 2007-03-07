From: akpm@linux-foundation.org
Subject: - cciss-fix-for-2tb-support.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:34 -0800
Message-ID: <200703070421.l274LY7x018909@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbXCGEYw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix for 2TB support
has been removed from the -mm tree.  Its filename was
     cciss-fix-for-2tb-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: fix for 2TB support
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

This patch changes the way we determine if a logical volume is larger than
2TB. 

The original test looked for a total_size of 0.  Originally we added 1 to the
total_size.  That would make our read_capacity return size 0 for >2TB lv's. 
We assumed that we could not have a lv size of 0 so it seemed OK until we were
in a clustered system.  The backup node would see a size of 0 due to the
reservation on the drive.  That caused the driver to switch to 16-byte CDB's
which are not supported on older controllers.  After that everything was
broken.

It may seem petty but I don't see the value in trying to determine if the LBA
is beyond the 2TB boundary.  That's why when we switch we use 16-byte CDB's
for all read/write operations.  Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-for-2tb-support drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-for-2tb-support
+++ a/drivers/block/cciss.c
@@ -1291,13 +1291,19 @@ static void cciss_update_drive_info(int 
 	if (inq_buff == NULL)
 		goto mem_msg;
 
+ 	/* testing to see if 16-byte CDBs are already being used */
+ 	if (h->cciss_read == CCISS_READ_16) {
+ 		cciss_read_capacity_16(h->ctlr, drv_index, 1,
+ 			&total_size, &block_size);
+ 		goto geo_inq;
+ 	}
+
 	cciss_read_capacity(ctlr, drv_index, 1,
 			    &total_size, &block_size);
 
-	/* total size = last LBA + 1 */
-	/* FFFFFFFF + 1 = 0, cannot have a logical volume of size 0 */
-	/* so we assume this volume this must be >2TB in size */
-	if (total_size == (__u32) 0) {
+  	/* if read_capacity returns all F's this volume is >2TB in size */
+  	/* so we switch to 16-byte CDB's for all read/write ops */
+  	if (total_size == 0xFFFFFFFFULL) {
 		cciss_read_capacity_16(ctlr, drv_index, 1,
 		&total_size, &block_size);
 		h->cciss_read = CCISS_READ_16;
@@ -1306,6 +1312,7 @@ static void cciss_update_drive_info(int 
 		h->cciss_read = CCISS_READ_10;
 		h->cciss_write = CCISS_WRITE_10;
 	}
+geo_inq:
 	cciss_geometry_inquiry(ctlr, drv_index, 1, total_size, block_size,
 			       inq_buff, &h->drv[drv_index]);
 
@@ -1917,13 +1924,14 @@ static void cciss_geometry_inquiry(int c
 			drv->raid_level = inq_buff->data_byte[8];
 		}
 		drv->block_size = block_size;
-		drv->nr_blocks = total_size;
+		drv->nr_blocks = total_size + 1;
 		t = drv->heads * drv->sectors;
 		if (t > 1) {
-			unsigned rem = sector_div(total_size, t);
+			sector_t real_size = total_size + 1;
+			unsigned long rem = sector_div(real_size, t);
 			if (rem)
-				total_size++;
-			drv->cylinders = total_size;
+				real_size++;
+			drv->cylinders = real_size;
 		}
 	} else {		/* Get geometry failed */
 		printk(KERN_WARNING "cciss: reading geometry failed\n");
@@ -1953,16 +1961,16 @@ cciss_read_capacity(int ctlr, int logvol
 				ctlr, buf, sizeof(ReadCapdata_struct),
 					1, logvol, 0, NULL, TYPE_CMD);
 	if (return_code == IO_OK) {
-		*total_size = be32_to_cpu(*(__u32 *) buf->total_size)+1;
+		*total_size = be32_to_cpu(*(__u32 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__u32 *) buf->block_size);
 	} else {		/* read capacity command failed */
 		printk(KERN_WARNING "cciss: read capacity failed\n");
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
-	if (*total_size != (__u32) 0)
+	if (*total_size != 0)
 		printk(KERN_INFO "      blocks= %llu block_size= %d\n",
-		(unsigned long long)*total_size, *block_size);
+		(unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 	return;
 }
@@ -1989,7 +1997,7 @@ cciss_read_capacity_16(int ctlr, int log
 				1, logvol, 0, NULL, TYPE_CMD);
 	}
 	if (return_code == IO_OK) {
-		*total_size = be64_to_cpu(*(__u64 *) buf->total_size)+1;
+		*total_size = be64_to_cpu(*(__u64 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__u32 *) buf->block_size);
 	} else {		/* read capacity command failed */
 		printk(KERN_WARNING "cciss: read capacity failed\n");
@@ -1997,7 +2005,7 @@ cciss_read_capacity_16(int ctlr, int log
 		*block_size = BLOCK_SIZE;
 	}
 	printk(KERN_INFO "      blocks= %llu block_size= %d\n",
-	       (unsigned long long)*total_size, *block_size);
+	       (unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 	return;
 }
@@ -3119,8 +3127,9 @@ static void cciss_getgeometry(int cntl_n
 		}
 		cciss_read_capacity(cntl_num, i, 0, &total_size, &block_size);
 
-		/* total_size = last LBA + 1 */
-		if(total_size == (__u32) 0) {
+		/* If read_capacity returns all F's the logical is >2TB */
+		/* so we switch to 16-byte CDBs for all read/write ops */
+		if(total_size == 0xFFFFFFFFULL) {
 			cciss_read_capacity_16(cntl_num, i, 0,
 			&total_size, &block_size);
 			hba[cntl_num]->cciss_read = CCISS_READ_16;
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

origin.patch
