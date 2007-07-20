From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-tag-11-writing-code.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:27:08 -0700
Message-ID: <200707202227.l6KMR8K9019755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763329AbXGTW1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix Tag 11 writing code
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-tag-11-writing-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix Tag 11 writing code
From: Michael Halcrow <mhalcrow@us.ibm.com>

Fix up the Tag 11 writing code to handle size limits and boundaries more
explicitly.  It looks like the packet length was 1 shorter than it should have
been, chopping off the last byte of the key identifier.  This is largely
inconsequential, since it is not much more likely that a key identifier
collision will occur with 7 bytes rather than 8.  This patch fixes the packet
to use the full number of bytes that were originally intended to be used for
the key identifier.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-fix-tag-11-writing-code fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-fix-tag-11-writing-code
+++ a/fs/ecryptfs/keystore.c
@@ -1449,47 +1449,52 @@ out:
  * Returns zero on success; non-zero on error.
  */
 static int
-write_tag_11_packet(char *dest, int max, char *contents, size_t contents_length,
-		    size_t *packet_length)
+write_tag_11_packet(char *dest, int *remaining_bytes, char *contents,
+		    size_t contents_length, size_t *packet_length)
 {
 	size_t packet_size_length;
+	size_t max_packet_size;
 	int rc = 0;
 
 	(*packet_length) = 0;
-	if ((13 + contents_length) > max) {
+	/* This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 11 */
+	max_packet_size = (1                   /* Tag 11 identifier */
+			   + 3                 /* Max Tag 11 packet size */
+			   + 1                 /* Binary format specifier */
+			   + 1                 /* Filename length */
+			   + 8                 /* Filename ("_CONSOLE") */
+			   + 4                 /* Modification date */
+			   + contents_length); /* Literal data */
+	if (max_packet_size > (*remaining_bytes)) {
+		printk(KERN_ERR "Packet length larger than maximum allowable; "
+		       "need up to [%d] bytes, but there are only [%d] "
+		       "available\n", max_packet_size, (*remaining_bytes));
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "Packet length larger than "
-				"maximum allowable\n");
 		goto out;
 	}
-	/* General packet header */
-	/* Packet tag */
 	dest[(*packet_length)++] = ECRYPTFS_TAG_11_PACKET_TYPE;
-	/* Packet length */
 	rc = write_packet_length(&dest[(*packet_length)],
-				 (13 + contents_length), &packet_size_length);
+				 (max_packet_size - 4), &packet_size_length);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error generating tag 11 packet "
-				"header; cannot generate packet length\n");
+		printk(KERN_ERR "Error generating tag 11 packet header; cannot "
+		       "generate packet length. rc = [%d]\n", rc);
 		goto out;
 	}
 	(*packet_length) += packet_size_length;
-	/* Tag 11 specific */
-	/* One-octet field that describes how the data is formatted */
-	dest[(*packet_length)++] = 0x62; /* binary data */
-	/* One-octet filename length followed by filename */
+	dest[(*packet_length)++] = 0x62; /* binary data format specifier */
 	dest[(*packet_length)++] = 8;
 	memcpy(&dest[(*packet_length)], "_CONSOLE", 8);
 	(*packet_length) += 8;
-	/* Four-octet number indicating modification date */
 	memset(&dest[(*packet_length)], 0x00, 4);
 	(*packet_length) += 4;
-	/* Remainder is literal data */
 	memcpy(&dest[(*packet_length)], contents, contents_length);
 	(*packet_length) += contents_length;
  out:
 	if (rc)
 		(*packet_length) = 0;
+	else
+		(*remaining_bytes) -= (*packet_length);
 	return rc;
 }
 
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
