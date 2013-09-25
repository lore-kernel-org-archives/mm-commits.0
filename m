From: akpm@linux-foundation.org
Subject: +
 hfsplus-implement-attributes-files-header-node-initialization-code.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 16:02:47 -0700
Message-ID: <52436b97.Y9fLqmax5Td4Di9i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3IYXCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 19:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-attributes-files-header-node-initialization-code.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 16:02:47 -0700


The patch titled
     Subject: hfsplus: implement attributes file's header node initialization code
has been added to the -mm tree.  Its filename is
     hfsplus-implement-attributes-files-header-node-initialization-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-attributes-files-header-node-initialization-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-attributes-files-header-node-initialization-code.patch

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
Subject: hfsplus: implement attributes file's header node initialization code

Implement functionality of AttributesFile's header node initialization.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |    3 +
 fs/hfsplus/xattr.c       |   63 +++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-implement-attributes-files-header-node-initialization-code fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-implement-attributes-files-header-node-initialization-code
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -187,6 +187,9 @@ struct hfs_btree_header_rec {
 /* HFS+ BTree misc info */
 #define HFSPLUS_TREE_HEAD 0
 #define HFSPLUS_NODE_MXSZ 32768
+#define HFSPLUS_ATTR_TREE_NODE_SIZE		8192
+#define HFSPLUS_BTREE_HDR_NODE_RECS_COUNT	3
+#define HFSPLUS_BTREE_HDR_USER_BYTES		128
 
 /* Some special File ID numbers (stolen from hfs.h) */
 #define HFSPLUS_POR_CNID		1	/* Parent Of the Root */
diff -puN fs/hfsplus/xattr.c~hfsplus-implement-attributes-files-header-node-initialization-code fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-implement-attributes-files-header-node-initialization-code
+++ a/fs/hfsplus/xattr.c
@@ -127,6 +127,69 @@ static int can_set_xattr(struct inode *i
 	return 0;
 }
 
+#define SETOFFSET(buf, ndsiz, offset, rec) \
+	(*(u16 *)((u8 *)(buf) + (ndsiz) + (-2 * (rec))) = (cpu_to_be16(offset)))
+
+static void hfsplus_init_header_node(struct inode *attr_file,
+					u32 clump_size,
+					char *buf, size_t node_size)
+{
+	struct hfs_bnode_desc *desc;
+	struct hfs_btree_header_rec *head;
+	u16 offset;
+	u32 hdr_node_map_rec_bits;
+	char *bmp;
+	u32 temp;
+
+	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %zu\n",
+				clump_size, node_size);
+
+	desc = (struct hfs_bnode_desc *)buf;
+	desc->type = HFS_NODE_HEADER;
+	desc->num_recs = cpu_to_be16(HFSPLUS_BTREE_HDR_NODE_RECS_COUNT);
+	offset = sizeof(struct hfs_bnode_desc);
+	SETOFFSET(buf, node_size, offset, 1);
+
+	head = (struct hfs_btree_header_rec *)(buf + offset);
+	head->node_size = cpu_to_be16(node_size);
+	head->node_count = cpu_to_be32(i_size_read(attr_file) / node_size);
+	head->free_nodes = cpu_to_be32(be32_to_cpu(head->node_count) - 1);
+	head->clump_size = cpu_to_be32(clump_size);
+	head->attributes |= cpu_to_be32(HFS_TREE_BIGKEYS | HFS_TREE_VARIDXKEYS);
+	head->max_key_len = cpu_to_be16(HFSPLUS_ATTR_KEYLEN - sizeof(u16));
+	offset += sizeof(struct hfs_btree_header_rec);
+	SETOFFSET(buf, node_size, offset, 2);
+
+	offset += HFSPLUS_BTREE_HDR_USER_BYTES;
+	SETOFFSET(buf, node_size, offset, 3);
+
+	hdr_node_map_rec_bits = 8 * (node_size - offset - (4 * sizeof(u16)));
+	if (be32_to_cpu(head->node_count) > hdr_node_map_rec_bits) {
+		u32 map_node_bits;
+		u32 map_nodes;
+
+		desc->next = cpu_to_be32(be32_to_cpu(head->leaf_tail) + 1);
+		map_node_bits = 8 * (node_size - sizeof(struct hfs_bnode_desc) -
+					(2 * sizeof(u16)) - 2);
+		map_nodes = (be32_to_cpu(head->node_count) -
+				hdr_node_map_rec_bits +
+				(map_node_bits - 1)) / map_node_bits;
+		be32_add_cpu(&head->free_nodes, 0 - map_nodes);
+	}
+
+	bmp = buf + offset;
+	temp = be32_to_cpu(head->node_count) - be32_to_cpu(head->free_nodes);
+
+	/* Working a byte at a time is endian safe */
+	while (temp >= 8) {
+		*bmp = 0xFF; temp -= 8; bmp++;
+	}
+	*bmp = ~(0xFF >> temp);
+	offset += hdr_node_map_rec_bits / 8;
+
+	SETOFFSET(buf, node_size, offset, 4);
+}
+
 int __hfsplus_setxattr(struct inode *inode, const char *name,
 			const void *value, size_t size, int flags)
 {
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-fix-issue-with-race-condition-of-competition-between-segments-for-dirty-blocks.patch
hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
hfsplus-implement-attributes-files-header-node-initialization-code.patch
hfsplus-implement-attributes-file-creation-functionality.patch

