From: akpm@linux-foundation.org
Subject: [nacked] scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch removed from -mm tree
Date: Thu, 24 Sep 2009 14:34:32 -0700
Message-ID: <200909242134.n8OLYX6q010286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZIXVfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 17:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, mm-commits@vger.kernel.org


The patch titled
     scsi: annotate gdth_rdcap_data, gdth_rdcap16_data endianness
has been removed from the -mm tree.  Its filename was
     scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: annotate gdth_rdcap_data, gdth_rdcap16_data endianness
From: Harvey Harrison <harvey.harrison@gmail.com>

It would be easy to get rid of the typedefs too, but I kept this
minimal.

Noticed by sparse:
drivers/scsi/gdth.c:2395:31: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2395:31:    expected unsigned int [unsigned] [assigned] [usertype] last_block_no
drivers/scsi/gdth.c:2395:31:    got restricted __be32 [usertype] <noident>
drivers/scsi/gdth.c:2396:27: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2396:27:    expected unsigned int [unsigned] [assigned] [usertype] block_length
drivers/scsi/gdth.c:2396:27:    got restricted __be32 [usertype] <noident>
drivers/scsi/gdth.c:2406:33: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2406:33:    expected unsigned long long [unsigned] [usertype] last_block_no
drivers/scsi/gdth.c:2406:33:    got restricted __be64 [usertype] <noident>
drivers/scsi/gdth.c:2407:33: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2407:33:    expected unsigned int [unsigned] [usertype] block_length
drivers/scsi/gdth.c:2407:33:    got restricted __be32 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 drivers/scsi/gdth.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/gdth.c~scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness
+++ a/drivers/scsi/gdth.c
@@ -2391,7 +2391,7 @@ static int gdth_internal_cache_cmd(gdth_
       case READ_CAPACITY:
         TRACE2(("Read capacity hdrive %d\n",t));
         if (ha->hdr[t].size > (ulong64)0xffffffff)
-            rdc.last_block_no = 0xffffffff;
+            rdc.last_block_no = cpu_to_be32(0xffffffff);
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
diff -puN drivers/scsi/gdth.h~scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness drivers/scsi/gdth.h
--- a/drivers/scsi/gdth.h~scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness
+++ a/drivers/scsi/gdth.h
@@ -968,14 +968,14 @@ typedef struct {
 
 /* READ_CAPACITY data format */
 typedef struct {
-    ulong32     last_block_no;
-    ulong32     block_length;
+	__be32 last_block_no;
+	__be32 block_length;
 } PACKED gdth_rdcap_data;
 
 /* READ_CAPACITY (16) data format */
 typedef struct {
-    ulong64     last_block_no;
-    ulong32     block_length;
+	__be64 last_block_no;
+	__be32 block_length;
 } PACKED gdth_rdcap16_data;
 
 /* REQUEST_SENSE data format */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch

