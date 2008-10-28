From: akpm@linux-foundation.org
Subject: + ibmpex-add-endian-annotation-to-extract_data-helper.patch added to -mm tree
Date: Mon, 27 Oct 2008 17:34:03 -0700
Message-ID: <200810280034.m9S0Y3uT002276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbYJ1AeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, djwong@us.ibm.com


The patch titled
     ibmpex: add endian annotation to extract_data() helper
has been added to the -mm tree.  Its filename is
     ibmpex-add-endian-annotation-to-extract_data-helper.patch

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
Subject: ibmpex: add endian annotation to extract_data() helper
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmpex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/ibmpex.c~ibmpex-add-endian-annotation-to-extract_data-helper drivers/hwmon/ibmpex.c
--- a/drivers/hwmon/ibmpex.c~ibmpex-add-endian-annotation-to-extract_data-helper
+++ a/drivers/hwmon/ibmpex.c
@@ -40,7 +40,7 @@
 
 static inline u16 extract_value(const char *data, int offset)
 {
-	return be16_to_cpup((u16 *)&data[offset]);
+	return be16_to_cpup((__be16 *)&data[offset]);
 }
 
 #define TEMP_SENSOR		1
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
gfs2-sparse-annotation-of-gl-gl_spin.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
sparc-use-the-new-byteorder-headers.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
memstick-annotate-endianness-of-attribute-structs.patch

