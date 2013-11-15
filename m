From: akpm@linux-foundation.org
Subject: [merged]
 hfsplus-fix-undefined-__divdi3-in-hfsplus_init_header_node.patch removed
 from -mm tree
Date: Fri, 15 Nov 2013 12:09:33 -0800
Message-ID: <52867f7d.XByOMxVy2PNPw3c9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3KOUJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, geert@linux-m68k.org

Subject: [merged] hfsplus-fix-undefined-__divdi3-in-hfsplus_init_header_node.patch removed from -mm tree
To: geert@linux-m68k.org,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:33 -0800


The patch titled
     Subject: hfsplus: Fix undefined __divdi3 in hfsplus_init_header_node()
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-undefined-__divdi3-in-hfsplus_init_header_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: hfsplus: Fix undefined __divdi3 in hfsplus_init_header_node()

ERROR: "__divdi3" [fs/hfsplus/hfsplus.ko] undefined!

Introduced by 099e9245e04d50b ("hfsplus: implement attributes file's
header node initialization code").

i_size_read() returns loff_t, which is long long, i.e.  64-bit.  node_size
is size_t, which is either 32-bit or 64-bit.  Hence
"i_size_read(attr_file) / node_size" is a 64-by-32 or 64-by-64 division,
causing (some versions of) gcc to emit a call to __divdi3().

Fortunately node_size is actually 16-bit, as the sole caller of
hfsplus_init_header_node() passes a u16.  Hence change its type from
size_t to u16, and use do_div() to perform a 64-by-32 division.

Not seen in m68k/allmodconfig in -next, so it really depends on the
verion of gcc.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-fix-undefined-__divdi3-in-hfsplus_init_header_node fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-fix-undefined-__divdi3-in-hfsplus_init_header_node
+++ a/fs/hfsplus/xattr.c
@@ -129,7 +129,7 @@ static int can_set_xattr(struct inode *i
 
 static void hfsplus_init_header_node(struct inode *attr_file,
 					u32 clump_size,
-					char *buf, size_t node_size)
+					char *buf, u16 node_size)
 {
 	struct hfs_bnode_desc *desc;
 	struct hfs_btree_header_rec *head;
@@ -139,8 +139,9 @@ static void hfsplus_init_header_node(str
 	char *bmp;
 	u32 used_nodes;
 	u32 used_bmp_bytes;
+	loff_t tmp;
 
-	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %zu\n",
+	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %u\n",
 				clump_size, node_size);
 
 	/* The end of the node contains list of record offsets */
@@ -154,7 +155,9 @@ static void hfsplus_init_header_node(str
 
 	head = (struct hfs_btree_header_rec *)(buf + offset);
 	head->node_size = cpu_to_be16(node_size);
-	head->node_count = cpu_to_be32(i_size_read(attr_file) / node_size);
+	tmp = i_size_read(attr_file);
+	do_div(tmp, node_size);
+	head->node_count = cpu_to_be32(tmp);
 	head->free_nodes = cpu_to_be32(be32_to_cpu(head->node_count) - 1);
 	head->clump_size = cpu_to_be32(clump_size);
 	head->attributes |= cpu_to_be32(HFS_TREE_BIGKEYS | HFS_TREE_VARIDXKEYS);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
linux-next.patch

