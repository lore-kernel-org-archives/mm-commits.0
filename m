From: akpm@linux-foundation.org
Subject: +
 hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch added to -mm tree
Date: Mon, 30 Sep 2013 14:27:48 -0700
Message-ID: <5249ecd4.vczf6mfWmss6sMkQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3I3V1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 17:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 14:27:48 -0700


The patch titled
     Subject: hfsplus-implement-attributes-files-header-node-initialization-code-v2
has been added to the -mm tree.  Its filename is
     hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus-implement-attributes-files-header-node-initialization-code-v2

* SETOFFSET macro was removed (Andrew Morton).
* Record offsets logic was reworked in hfsplus_init_header_node() (Al Viro).
* AttributesFile's header node's bitmap is initialized by memset() (Al Viro).
* Logic of checking attributes tree state before AttributesFile
  creation was reworked for HFSPLUS_CREATING_ATTR_TREE case (Andrew Morton).
* Setting error code was added after read_mapping_page()
  call in hfsplus_create_attributes_file() method (Andrew Morton).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-implement-attributes-files-header-node-initialization-code-v2 fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-implement-attributes-files-header-node-initialization-code-v2
+++ a/fs/hfsplus/xattr.c
@@ -127,9 +127,6 @@ static int can_set_xattr(struct inode *i
 	return 0;
 }
 
-#define SETOFFSET(buf, ndsiz, offset, rec) \
-	(*(u16 *)((u8 *)(buf) + (ndsiz) + (-2 * (rec))) = (cpu_to_be16(offset)))
-
 static void hfsplus_init_header_node(struct inode *attr_file,
 					u32 clump_size,
 					char *buf, size_t node_size)
@@ -137,18 +134,23 @@ static void hfsplus_init_header_node(str
 	struct hfs_bnode_desc *desc;
 	struct hfs_btree_header_rec *head;
 	u16 offset;
+	__be16 *rec_offsets;
 	u32 hdr_node_map_rec_bits;
 	char *bmp;
-	u32 temp;
+	u32 used_nodes;
+	u32 used_bmp_bytes;
 
 	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %zu\n",
 				clump_size, node_size);
 
+	/* The end of the node contains list of record offsets */
+	rec_offsets = (__be16 *)(buf + node_size);
+
 	desc = (struct hfs_bnode_desc *)buf;
 	desc->type = HFS_NODE_HEADER;
 	desc->num_recs = cpu_to_be16(HFSPLUS_BTREE_HDR_NODE_RECS_COUNT);
 	offset = sizeof(struct hfs_bnode_desc);
-	SETOFFSET(buf, node_size, offset, 1);
+	*--rec_offsets = cpu_to_be16(offset);
 
 	head = (struct hfs_btree_header_rec *)(buf + offset);
 	head->node_size = cpu_to_be16(node_size);
@@ -158,10 +160,9 @@ static void hfsplus_init_header_node(str
 	head->attributes |= cpu_to_be32(HFS_TREE_BIGKEYS | HFS_TREE_VARIDXKEYS);
 	head->max_key_len = cpu_to_be16(HFSPLUS_ATTR_KEYLEN - sizeof(u16));
 	offset += sizeof(struct hfs_btree_header_rec);
-	SETOFFSET(buf, node_size, offset, 2);
-
+	*--rec_offsets = cpu_to_be16(offset);
 	offset += HFSPLUS_BTREE_HDR_USER_BYTES;
-	SETOFFSET(buf, node_size, offset, 3);
+	*--rec_offsets = cpu_to_be16(offset);
 
 	hdr_node_map_rec_bits = 8 * (node_size - offset - (4 * sizeof(u16)));
 	if (be32_to_cpu(head->node_count) > hdr_node_map_rec_bits) {
@@ -178,16 +179,17 @@ static void hfsplus_init_header_node(str
 	}
 
 	bmp = buf + offset;
-	temp = be32_to_cpu(head->node_count) - be32_to_cpu(head->free_nodes);
-
-	/* Working a byte at a time is endian safe */
-	while (temp >= 8) {
-		*bmp = 0xFF; temp -= 8; bmp++;
+	used_nodes =
+		be32_to_cpu(head->node_count) - be32_to_cpu(head->free_nodes);
+	used_bmp_bytes = used_nodes / 8;
+	if (used_bmp_bytes) {
+		memset(bmp, 0xFF, used_bmp_bytes);
+		bmp += used_bmp_bytes;
+		used_nodes %= 8;
 	}
-	*bmp = ~(0xFF >> temp);
+	*bmp = ~(0xFF >> used_nodes);
 	offset += hdr_node_map_rec_bits / 8;
