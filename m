From: akpm@linux-foundation.org
Subject: - memstick-fix-parsing-of-assembly_date-attribute-field.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:59 -0700
Message-ID: <200803110321.m2B3LxVX019766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbYCKDWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: fix parsing of "assembly_date" attribute field
has been removed from the -mm tree.  Its filename was
     memstick-fix-parsing-of-assembly_date-attribute-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: fix parsing of "assembly_date" attribute field
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-fix-parsing-of-assembly_date-attribute-field drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-fix-parsing-of-assembly_date-attribute-field
+++ a/drivers/memstick/core/mspro_block.c
@@ -303,6 +303,20 @@ static ssize_t mspro_block_attr_show_sys
 						     dev_attr);
 	struct mspro_sys_info *x_sys = x_attr->data;
 	ssize_t rc = 0;
+	int date_tz = 0, date_tz_f = 0;
+
+	if (x_sys->assembly_date[0] > 0x80U) {
+		date_tz = (~x_sys->assembly_date[0]) + 1;
+		date_tz_f = date_tz & 3;
+		date_tz >>= 2;
+		date_tz = -date_tz;
+		date_tz_f *= 15;
+	} else if (x_sys->assembly_date[0] < 0x80U) {
+		date_tz = x_sys->assembly_date[0];
+		date_tz_f = date_tz & 3;
+		date_tz >>= 2;
+		date_tz_f *= 15;
+	}
 
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
 			x_sys->class);
@@ -315,8 +329,8 @@ static ssize_t mspro_block_attr_show_sys
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
 			be16_to_cpu(x_sys->page_size));
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
-			"%d %04u-%02u-%02u %02u:%02u:%02u\n",
-			x_sys->assembly_date[0],
+			"GMT%+d:%d %04u-%02u-%02u %02u:%02u:%02u\n",
+			date_tz, date_tz_f,
 			be16_to_cpu(*(unsigned short *)
 				    &x_sys->assembly_date[1]),
 			x_sys->assembly_date[3], x_sys->assembly_date[4],
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch

