From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-tag-11-parsing-code.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:18 -0700
Message-ID: <200710162040.l9GKeIfY015676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbXJPVF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: fix Tag 11 parsing code
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-tag-11-parsing-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: fix Tag 11 parsing code
From: Michael Halcrow <mhalcrow@us.ibm.com>

Fix up the Tag 11 parsing code to handle size limits and boundaries more
explicitly.  Pay attention to *8* bytes for the key identifier (literal data),
no more, no less.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   76 +++++++++++++--------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-fix-tag-11-parsing-code fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-fix-tag-11-parsing-code
+++ a/fs/ecryptfs/keystore.c
@@ -803,82 +803,60 @@ parse_tag_11_packet(unsigned char *data,
 
 	(*packet_size) = 0;
 	(*tag_11_contents_size) = 0;
-
-	/* check that:
-	 *   one byte for the Tag 11 ID flag
-	 *   two bytes for the Tag 11 length
-	 * do not exceed the maximum_packet_size
+	/* This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 11
+	 *
+	 * Tag 11 identifier (1 byte)
+	 * Max Tag 11 packet size (max 3 bytes)
+	 * Binary format specifier (1 byte)
+	 * Filename length (1 byte)
+	 * Filename ("_CONSOLE") (8 bytes)
+	 * Modification date (4 bytes)
+	 * Literal data (arbitrary)
+	 *
+	 * We need at least 16 bytes of data for the packet to even be
+	 * valid.
 	 */
-	if (unlikely((*packet_size) + 3 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+	if (max_packet_size < 16) {
+		printk(KERN_ERR "Maximum packet size too small\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* check for Tag 11 identifyer - one byte */
 	if (data[(*packet_size)++] != ECRYPTFS_TAG_11_PACKET_TYPE) {
-		ecryptfs_printk(KERN_WARNING,
-				"Invalid tag 11 packet format\n");
+		printk(KERN_WARNING "Invalid tag 11 packet format\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* get Tag 11 content length - one or two bytes */
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING,
-				"Invalid tag 11 packet format\n");
+	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				      &length_size))) {
+		printk(KERN_WARNING "Invalid tag 11 packet format\n");
 		goto out;
 	}
-	(*packet_size) += length_size;
-
-	if (body_size < 13) {
-		ecryptfs_printk(KERN_WARNING, "Invalid body size ([%d])\n",
-				body_size);
+	if (body_size < 14) {
+		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
 		rc = -EINVAL;
 		goto out;
 	}
-	/* We have 13 bytes of surrounding packet values */
-	(*tag_11_contents_size) = (body_size - 13);
-
-	/* now we know the length of the remainting Tag 11 packet size:
-	 *   14 fix bytes for: special flag one, special flag two,
-	 *   		       12 skipped bytes
-	 *   body_size bytes minus the stuff above is the Tag 11 content
-	 */
-	/* FIXME why is the body size one byte smaller than the actual
-	 * size of the body?
-	 * this seems to be an error here as well as in
-	 * write_tag_11_packet() */
+	(*packet_size) += length_size;
+	(*tag_11_contents_size) = (body_size - 14);
 	if (unlikely((*packet_size) + body_size + 1 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* special flag one - one byte */
 	if (data[(*packet_size)++] != 0x62) {
-		ecryptfs_printk(KERN_WARNING, "Unrecognizable packet\n");
+		printk(KERN_WARNING "Unrecognizable packet\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* special flag two - one byte */
 	if (data[(*packet_size)++] != 0x08) {
-		ecryptfs_printk(KERN_WARNING, "Unrecognizable packet\n");
+		printk(KERN_WARNING "Unrecognizable packet\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* skip the next 12 bytes */
-	(*packet_size) += 12; /* We don't care about the filename or
-			       * the timestamp */
-
-	/* get the Tag 11 contents - tag_11_contents_size bytes */
+	(*packet_size) += 12; /* Ignore filename and modification date */
 	memcpy(contents, &data[(*packet_size)], (*tag_11_contents_size));
 	(*packet_size) += (*tag_11_contents_size);
-
 out:
 	if (rc) {
 		(*packet_size) = 0;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
