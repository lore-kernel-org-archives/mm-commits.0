From: akpm@linux-foundation.org
Subject: + memstick-annotate-endianness-of-attribute-structs.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:51:11 -0700
Message-ID: <200810270651.m9R6pBVx029613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbYJ0Gvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, oakad@yahoo.com


The patch titled
     memstick: annotate endianness of attribute structs
has been added to the -mm tree.  Its filename is
     memstick-annotate-endianness-of-attribute-structs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: annotate endianness of attribute structs
From: Harvey Harrison <harvey.harrison@gmail.com>

The code was shifting the endianness appropriately everywhere, annotate
the structs to avoid the sparse warnings when assigning the endian types
to the struct members, or passing them to be[16|32]_to_cpu:

drivers/memstick/core/mspro_block.c:331:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:333:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:335:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:337:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:341:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:347:4: warning: cast to restricted __be32
drivers/memstick/core/mspro_block.c:356:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:358:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:364:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:367:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:369:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:371:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:377:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:478:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:480:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:482:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:484:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:486:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:689:22:    expected unsigned int [unsigned] [assigned] data_address
drivers/memstick/core/mspro_block.c:689:22:    got restricted __be32 [usertype] <noident>
drivers/memstick/core/mspro_block.c:697:3: warning: cast to restricted __be32
drivers/memstick/core/mspro_block.c:960:17: warning: incorrect type in initializer (different base types)
drivers/memstick/core/mspro_block.c:960:17:    expected unsigned short [unsigned] data_count
drivers/memstick/core/mspro_block.c:960:17:    got restricted __be16 [usertype] <noident>
drivers/memstick/core/mspro_block.c:993:6: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:995:28: warning: cast to restricted __be16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   43 ++++++++++++--------------
 include/linux/memstick.h            |    4 +-
 2 files changed, 23 insertions(+), 24 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-annotate-endianness-of-attribute-structs drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-annotate-endianness-of-attribute-structs
+++ a/drivers/memstick/core/mspro_block.c
@@ -52,14 +52,14 @@ struct mspro_sys_attr {
 };
 
 struct mspro_attr_entry {
-	unsigned int  address;
-	unsigned int  size;
+	__be32 address;
+	__be32 size;
 	unsigned char id;
 	unsigned char reserved[3];
 } __attribute__((packed));
 
 struct mspro_attribute {
-	unsigned short          signature;
+	__be16 signature;
 	unsigned short          version;
 	unsigned char           count;
 	unsigned char           reserved[11];
@@ -69,28 +69,28 @@ struct mspro_attribute {
 struct mspro_sys_info {
 	unsigned char  class;
 	unsigned char  reserved0;
-	unsigned short block_size;
-	unsigned short block_count;
-	unsigned short user_block_count;
-	unsigned short page_size;
+	__be16 block_size;
+	__be16 block_count;
+	__be16 user_block_count;
+	__be16 page_size;
 	unsigned char  reserved1[2];
 	unsigned char  assembly_date[8];
-	unsigned int   serial_number;
+	__be32 serial_number;
 	unsigned char  assembly_maker_code;
 	unsigned char  assembly_model_code[3];
-	unsigned short memory_maker_code;
-	unsigned short memory_model_code;
+	__be16 memory_maker_code;
+	__be16 memory_model_code;
 	unsigned char  reserved2[4];
 	unsigned char  vcc;
 	unsigned char  vpp;
-	unsigned short controller_number;
-	unsigned short controller_function;
-	unsigned short start_sector;
-	unsigned short unit_size;
+	__be16 controller_number;
+	__be16 controller_function;
+	__be16 start_sector;
+	__be16 unit_size;
 	unsigned char  ms_sub_class;
 	unsigned char  reserved3[4];
 	unsigned char  interface_type;
-	unsigned short controller_code;
+	__be16 controller_code;
 	unsigned char  format_type;
 	unsigned char  reserved4;
 	unsigned char  device_type;
@@ -124,11 +124,11 @@ struct mspro_specfile {
 } __attribute__((packed));
 
 struct mspro_devinfo {
-	unsigned short cylinders;
-	unsigned short heads;
-	unsigned short bytes_per_track;
-	unsigned short bytes_per_sector;
-	unsigned short sectors_per_track;
+	__be16 cylinders;
+	__be16 heads;
+	__be16 bytes_per_track;
+	__be16 bytes_per_sector;
+	__be16 sectors_per_track;
 	unsigned char  reserved[6];
 } __attribute__((packed));
 
@@ -338,8 +338,7 @@ static ssize_t mspro_block_attr_show_sys
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
 			"GMT%+d:%d %04u-%02u-%02u %02u:%02u:%02u\n",
 			date_tz, date_tz_f,
-			be16_to_cpu(*(unsigned short *)
-				    &x_sys->assembly_date[1]),
+			be16_to_cpup((__be16 *)&x_sys->assembly_date[1]),
 			x_sys->assembly_date[3], x_sys->assembly_date[4],
 			x_sys->assembly_date[5], x_sys->assembly_date[6],
 			x_sys->assembly_date[7]);
diff -puN include/linux/memstick.h~memstick-annotate-endianness-of-attribute-structs include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-annotate-endianness-of-attribute-structs
+++ a/include/linux/memstick.h
@@ -100,8 +100,8 @@ struct mspro_param_register {
 #define MEMSTICK_SYS_PAR8   0x40
 #define MEMSTICK_SYS_SERIAL 0x80
 
-	unsigned short data_count;
-	unsigned int   data_address;
+	__be16 data_count;
+	__be32 data_address;
 	unsigned char  tpc_param;
 } __attribute__((packed));
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
memstick-annotate-endianness-of-attribute-structs.patch

