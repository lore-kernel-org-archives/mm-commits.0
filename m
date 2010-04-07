From: akpm@linux-foundation.org
Subject: + scsi-use-__ux-types-for-headers-exported-to-user-space.patch added to -mm tree
Date: Wed, 07 Apr 2010 15:26:14 -0700
Message-ID: <201004072226.o37MQEwf011272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab0DGW0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 18:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, james.smart@emulex.com


The patch titled
     scsi: use __uX types for headers exported to user space
has been added to the -mm tree.  Its filename is
     scsi-use-__ux-types-for-headers-exported-to-user-space.patch

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
Subject: scsi: use __uX types for headers exported to user space
From: Peter Korsgaard <jacmet@sunsite.dk>

Commit 9e4f5e29 ("FC Pass Thru support") exported a number of header files
in include/scsi to user space, but didn't change the uX types to the
userspace-compatible __uX types.  Without that you'll get compile errors
when including them - E.G.:

include/scsi/scsi.h:145: error: expected specifier-qualifier-list before `u8'

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi.h         |    8 ++++----
 include/scsi/scsi_netlink.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/scsi/scsi.h~scsi-use-__ux-types-for-headers-exported-to-user-space include/scsi/scsi.h
--- a/include/scsi/scsi.h~scsi-use-__ux-types-for-headers-exported-to-user-space
+++ a/include/scsi/scsi.h
@@ -149,10 +149,10 @@ struct scsi_cmnd;
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
diff -puN include/scsi/scsi_netlink.h~scsi-use-__ux-types-for-headers-exported-to-user-space include/scsi/scsi_netlink.h
--- a/include/scsi/scsi_netlink.h~scsi-use-__ux-types-for-headers-exported-to-user-space
+++ a/include/scsi/scsi_netlink.h
@@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
  *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
  */
 #define SCSI_NL_VID_TYPE_SHIFT		56
-#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
-#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
 #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
 
 
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

linux-next.patch
scsi-use-__ux-types-for-headers-exported-to-user-space.patch

