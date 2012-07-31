From: akpm@linux-foundation.org
Subject: [merged] drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:55 -0700
Message-ID: <20120731185155.D67A210007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:56 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kdudka@redhat.com, alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/message/i2o/i2o_proc.c: the pointer returned from chtostr() points to an array which is no longer valid
has been removed from the -mm tree.  Its filename was
     drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kamil Dudka <kdudka@redhat.com>
Subject: drivers/message/i2o/i2o_proc.c: the pointer returned from chtostr() points to an array which is no longer valid

...  when being used in the calling function.  Although it may work, the
behavior is undefined.  Detected by cppcheck.

Signed-off-by: Kamil Dudka <kdudka@redhat.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_proc.c |   37 ++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff -puN drivers/message/i2o/i2o_proc.c~drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid drivers/message/i2o/i2o_proc.c
--- a/drivers/message/i2o/i2o_proc.c~drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid
+++ a/drivers/message/i2o/i2o_proc.c
@@ -255,9 +255,8 @@ static char *scsi_devices[] = {
 	"Array Controller Device"
 };
 
-static char *chtostr(u8 * chars, int n)
+static char *chtostr(char *tmp, u8 *chars, int n)
 {
-	char tmp[256];
 	tmp[0] = 0;
 	return strncat(tmp, (char *)chars, n);
 }
@@ -791,6 +790,7 @@ static int i2o_seq_show_ddm_table(struct
 	} *result;
 
 	i2o_exec_execute_ddm_table ddm_table;
+	char tmp[28 + 1];
 
 	result = kmalloc(sizeof(*result), GFP_KERNEL);
 	if (!result)
@@ -826,7 +826,7 @@ static int i2o_seq_show_ddm_table(struct
 		seq_printf(seq, "%-#7x", ddm_table.i2o_vendor_id);
 		seq_printf(seq, "%-#8x", ddm_table.module_id);
 		seq_printf(seq, "%-29s",
-			   chtostr(ddm_table.module_name_version, 28));
+			   chtostr(tmp, ddm_table.module_name_version, 28));
 		seq_printf(seq, "%9d  ", ddm_table.data_size);
 		seq_printf(seq, "%8d", ddm_table.code_size);
 
@@ -893,6 +893,7 @@ static int i2o_seq_show_drivers_stored(s
 
 	i2o_driver_result_table *result;
 	i2o_driver_store_table *dst;
+	char tmp[28 + 1];
 
 	result = kmalloc(sizeof(i2o_driver_result_table), GFP_KERNEL);
 	if (result == NULL)
@@ -927,8 +928,9 @@ static int i2o_seq_show_drivers_stored(s
 
 		seq_printf(seq, "%-#7x", dst->i2o_vendor_id);
 		seq_printf(seq, "%-#8x", dst->module_id);
-		seq_printf(seq, "%-29s", chtostr(dst->module_name_version, 28));
-		seq_printf(seq, "%-9s", chtostr(dst->date, 8));
+		seq_printf(seq, "%-29s",
+			   chtostr(tmp, dst->module_name_version, 28));
+		seq_printf(seq, "%-9s", chtostr(tmp, dst->date, 8));
 		seq_printf(seq, "%8d ", dst->module_size);
 		seq_printf(seq, "%8d ", dst->mpb_size);
 		seq_printf(seq, "0x%04x", dst->module_flags);
@@ -1248,6 +1250,7 @@ static int i2o_seq_show_dev_identity(str
 	// == (allow) 512d bytes (max)
 	static u16 *work16 = (u16 *) work32;
 	int token;
+	char tmp[16 + 1];
 
 	token = i2o_parm_field_get(d, 0xF100, -1, &work32, sizeof(work32));
 
@@ -1260,13 +1263,13 @@ static int i2o_seq_show_dev_identity(str
 	seq_printf(seq, "Owner TID     : %0#5x\n", work16[2]);
 	seq_printf(seq, "Parent TID    : %0#5x\n", work16[3]);
 	seq_printf(seq, "Vendor info   : %s\n",
-		   chtostr((u8 *) (work32 + 2), 16));
+		   chtostr(tmp, (u8 *) (work32 + 2), 16));
 	seq_printf(seq, "Product info  : %s\n",
-		   chtostr((u8 *) (work32 + 6), 16));
+		   chtostr(tmp, (u8 *) (work32 + 6), 16));
 	seq_printf(seq, "Description   : %s\n",
-		   chtostr((u8 *) (work32 + 10), 16));
+		   chtostr(tmp, (u8 *) (work32 + 10), 16));
 	seq_printf(seq, "Product rev.  : %s\n",
-		   chtostr((u8 *) (work32 + 14), 8));
+		   chtostr(tmp, (u8 *) (work32 + 14), 8));
 
 	seq_printf(seq, "Serial number : ");
 	print_serial_number(seq, (u8 *) (work32 + 16),
@@ -1303,6 +1306,8 @@ static int i2o_seq_show_ddm_identity(str
 		u8 pad[256];	// allow up to 256 byte (max) serial number
 	} result;
 
+	char tmp[24 + 1];
+
 	token = i2o_parm_field_get(d, 0xF101, -1, &result, sizeof(result));
 
 	if (token < 0) {
@@ -1312,9 +1317,9 @@ static int i2o_seq_show_ddm_identity(str
 
 	seq_printf(seq, "Registering DDM TID : 0x%03x\n", result.ddm_tid);
 	seq_printf(seq, "Module name         : %s\n",
-		   chtostr(result.module_name, 24));
+		   chtostr(tmp, result.module_name, 24));
 	seq_printf(seq, "Module revision     : %s\n",
-		   chtostr(result.module_rev, 8));
+		   chtostr(tmp, result.module_rev, 8));
 
 	seq_printf(seq, "Serial number       : ");
 	print_serial_number(seq, result.serial_number, sizeof(result) - 36);
@@ -1338,6 +1343,8 @@ static int i2o_seq_show_uinfo(struct seq
 		u8 instance_number[4];
 	} result;
 
+	char tmp[64 + 1];
+
 	token = i2o_parm_field_get(d, 0xF102, -1, &result, sizeof(result));
 
 	if (token < 0) {
@@ -1346,13 +1353,13 @@ static int i2o_seq_show_uinfo(struct seq
 	}
 
 	seq_printf(seq, "Device name     : %s\n",
-		   chtostr(result.device_name, 64));
+		   chtostr(tmp, result.device_name, 64));
 	seq_printf(seq, "Service name    : %s\n",
-		   chtostr(result.service_name, 64));
+		   chtostr(tmp, result.service_name, 64));
 	seq_printf(seq, "Physical name   : %s\n",
-		   chtostr(result.physical_location, 64));
+		   chtostr(tmp, result.physical_location, 64));
 	seq_printf(seq, "Instance number : %s\n",
-		   chtostr(result.instance_number, 4));
+		   chtostr(tmp, result.instance_number, 4));
 
 	return 0;
 }
_

Patches currently in -mm which might be from kdudka@redhat.com are

origin.patch

