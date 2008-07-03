From: akpm@linux-foundation.org
Subject: + ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch added to -mm tree
Date: Thu, 03 Jul 2008 15:54:26 -0700
Message-ID: <200807032254.m63MsR6q031625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757316AbYGCWzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: crypto.c use unaligned byteorder helpers
has been added to the -mm tree.  Its filename is
     ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: crypto.c use unaligned byteorder helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Fixes the following sparse warnings:
fs/ecryptfs/crypto.c:1036:8: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1038:8: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1077:10: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1103:6: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1105:6: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1124:8: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1241:21: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1244:30: warning: incorrect type in assignment (different base types)
fs/ecryptfs/crypto.c:1414:23: warning: cast to restricted __be32
fs/ecryptfs/crypto.c:1417:32: warning: cast to restricted __be16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-cryptoc-use-unaligned-byteorder-helpers fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-cryptoc-use-unaligned-byteorder-helpers
+++ a/fs/ecryptfs/crypto.c
@@ -33,6 +33,7 @@
 #include <linux/crypto.h>
 #include <linux/file.h>
 #include <linux/scatterlist.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 static int
@@ -1032,10 +1033,8 @@ static int contains_ecryptfs_marker(char
 {
 	u32 m_1, m_2;
 
-	memcpy(&m_1, data, 4);
-	m_1 = be32_to_cpu(m_1);
-	memcpy(&m_2, (data + 4), 4);
-	m_2 = be32_to_cpu(m_2);
+	m_1 = get_unaligned_be32(data);
+	m_2 = get_unaligned_be32(data + 4);
 	if ((m_1 ^ MAGIC_ECRYPTFS_MARKER) == m_2)
 		return 1;
 	ecryptfs_printk(KERN_DEBUG, "m_1 = [0x%.8x]; m_2 = [0x%.8x]; "
@@ -1073,8 +1072,7 @@ static int ecryptfs_process_flags(struct
 	int i;
 	u32 flags;
 
-	memcpy(&flags, page_virt, 4);
-	flags = be32_to_cpu(flags);
+	flags = get_unaligned_be32(page_virt);
 	for (i = 0; i < ((sizeof(ecryptfs_flag_map)
 			  / sizeof(struct ecryptfs_flag_map_elem))); i++)
 		if (flags & ecryptfs_flag_map[i].file_flag) {
@@ -1100,11 +1098,9 @@ static void write_ecryptfs_marker(char *
 
 	get_random_bytes(&m_1, (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
 	m_2 = (m_1 ^ MAGIC_ECRYPTFS_MARKER);
-	m_1 = cpu_to_be32(m_1);
-	memcpy(page_virt, &m_1, (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
-	m_2 = cpu_to_be32(m_2);
-	memcpy(page_virt + (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2), &m_2,
-	       (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2));
+	put_unaligned_be32(m_1, page_virt);
+	page_virt += (MAGIC_ECRYPTFS_MARKER_SIZE_BYTES / 2);
+	put_unaligned_be32(m_2, page_virt);
 	(*written) = MAGIC_ECRYPTFS_MARKER_SIZE_BYTES;
 }
 
@@ -1121,8 +1117,7 @@ write_ecryptfs_flags(char *page_virt, st
 			flags |= ecryptfs_flag_map[i].file_flag;
 	/* Version is in top 8 bits of the 32-bit flag vector */
 	flags |= ((((u8)crypt_stat->file_version) << 24) & 0xFF000000);
-	flags = cpu_to_be32(flags);
-	memcpy(page_virt, &flags, 4);
+	put_unaligned_be32(flags, page_virt);
 	(*written) = 4;
 }
 
@@ -1238,11 +1233,9 @@ ecryptfs_write_header_metadata(char *vir
 	num_header_extents_at_front =
 		(u16)(crypt_stat->num_header_bytes_at_front
 		      / crypt_stat->extent_size);
-	header_extent_size = cpu_to_be32(header_extent_size);
-	memcpy(virt, &header_extent_size, 4);
+	put_unaligned_be32(header_extent_size, virt);
 	virt += 4;
-	num_header_extents_at_front = cpu_to_be16(num_header_extents_at_front);
-	memcpy(virt, &num_header_extents_at_front, 2);
+	put_unaligned_be16(num_header_extents_at_front, virt);
 	(*written) = 6;
 }
 
@@ -1410,15 +1403,13 @@ static int parse_header_metadata(struct 
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
 
-	memcpy(&header_extent_size, virt, sizeof(u32));
-	header_extent_size = be32_to_cpu(header_extent_size);
-	virt += sizeof(u32);
-	memcpy(&num_header_extents_at_front, virt, sizeof(u16));
-	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
+	header_extent_size = get_unaligned_be32(virt);
+	virt += sizeof(__be32);
+	num_header_extents_at_front = get_unaligned_be16(virt);
 	crypt_stat->num_header_bytes_at_front =
 		(((size_t)num_header_extents_at_front
 		  * (size_t)header_extent_size));
-	(*bytes_read) = (sizeof(u32) + sizeof(u16));
+	(*bytes_read) = (sizeof(__be32) + sizeof(__be16));
 	if ((validate_header_size == ECRYPTFS_VALIDATE_HEADER_SIZE)
 	    && (crypt_stat->num_header_bytes_at_front
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

