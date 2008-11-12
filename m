From: akpm@linux-foundation.org
Subject: + dlm-trivial-annotation-of-be16-value.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:28:05 -0800
Message-ID: <200811122228.mACMS5oI025019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYKLW20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:28:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     dlm: trivial annotation of be16 value
has been added to the -mm tree.  Its filename is
     dlm-trivial-annotation-of-be16-value.patch

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
Subject: dlm: trivial annotation of be16 value
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/dlm/dir.c:419:14: warning: incorrect type in assignment (different base types)
fs/dlm/dir.c:419:14:    expected unsigned short [unsigned] [addressable] [assigned] [usertype] be_namelen
fs/dlm/dir.c:419:14:    got restricted __be16 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/dir.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/dlm/dir.c~dlm-trivial-annotation-of-be16-value fs/dlm/dir.c
--- a/fs/dlm/dir.c~dlm-trivial-annotation-of-be16-value
+++ a/fs/dlm/dir.c
@@ -374,7 +374,7 @@ void dlm_copy_master_names(struct dlm_ls
 	struct list_head *list;
 	struct dlm_rsb *r;
 	int offset = 0, dir_nodeid;
-	uint16_t be_namelen;
+	__be16 be_namelen;
 
 	down_read(&ls->ls_root_sem);
 
@@ -410,15 +410,15 @@ void dlm_copy_master_names(struct dlm_ls
 
 		if (offset + sizeof(uint16_t)*2 + r->res_length > outlen) {
 			/* Write end-of-block record */
-			be_namelen = 0;
-			memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-			offset += sizeof(uint16_t);
+			be_namelen = cpu_to_be16(0);
+			memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+			offset += sizeof(__be16);
 			goto out;
 		}
 
 		be_namelen = cpu_to_be16(r->res_length);
-		memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-		offset += sizeof(uint16_t);
+		memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+		offset += sizeof(__be16);
 		memcpy(outbuf + offset, r->res_name, r->res_length);
 		offset += r->res_length;
 	}
@@ -430,9 +430,9 @@ void dlm_copy_master_names(struct dlm_ls
 
 	if ((list == &ls->ls_root_list) &&
 	    (offset + sizeof(uint16_t) <= outlen)) {
-		be_namelen = 0xFFFF;
-		memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-		offset += sizeof(uint16_t);
+		be_namelen = cpu_to_be16(0xFFFF);
+		memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+		offset += sizeof(__be16);
 	}
 
  out:
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
dlm-trivial-annotation-of-be16-value.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
wusb-annotate-association-types-withe-proper-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch

