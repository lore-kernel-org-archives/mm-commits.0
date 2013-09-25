From: akpm@linux-foundation.org
Subject: +
 hfsplus-add-metadata-files-clump-size-calculation-functionality.patch added to -mm tree
Date: Wed, 25 Sep 2013 16:02:46 -0700
Message-ID: <52436b96.hkcyM0vwqsiGDTCT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3IYXCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 19:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-add-metadata-files-clump-size-calculation-functionality.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 16:02:46 -0700


The patch titled
     Subject: hfsplus: add metadata file's clump size calculation functionality
has been added to the -mm tree.  Its filename is
     hfsplus-add-metadata-files-clump-size-calculation-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-add-metadata-files-clump-size-calculation-functionality.patch

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
Subject: hfsplus: add metadata file's clump size calculation functionality

There are situation when HFS+ volume had been created without
AttributesFile.  Such situation can take place because of using old
mkfs.hfs utility or creation HFS+ volume without taking in mind necessity
to use xattrs.  For example, Mac OS X 10.4 (Tiger) doesn't create
AttributesFile during mkfs phase.  Also it is a very frequent situation
for the case of users that created HFS+ volumes under Linux.  As a result,
xattrs and POSIX ACLs on HFS+ volume are unavailable for such users.

This patchset implements functionality of AttributesFile creation on HFS+
volume in the case of this metadata file absence during operation of xattr
creation.


This patch:

Add functionality of metadata file's clump size calculation.  Operation of
AttributesFile creation needs in clump size setting.  This value will be
used when AttributesFile will be extended.

This code is adopted from code of newfs_hfs utility of diskdev_cmds packet
http://opensource.apple.com/tarballs/diskdev_cmds/.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c      |  112 ++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/hfsplus_fs.h |    1 
 2 files changed, 113 insertions(+)

diff -puN fs/hfsplus/btree.c~hfsplus-add-metadata-files-clump-size-calculation-functionality fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfsplus-add-metadata-files-clump-size-calculation-functionality
+++ a/fs/hfsplus/btree.c
@@ -15,6 +15,118 @@
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 
+/*
+ * Initial source code of clump size calculation is gotten
+ * from http://opensource.apple.com/tarballs/diskdev_cmds/
+ */
+#define CLUMP_ENTRIES	15
+
+static short clumptbl[CLUMP_ENTRIES * 3] = {
+/*
+ *	    Volume	Attributes	 Catalog	 Extents
+ *	     Size	Clump (MB)	Clump (MB)	Clump (MB)
+ */
+	/*   1GB */	  4,		  4,		 4,
+	/*   2GB */	  6,		  6,		 4,
+	/*   4GB */	  8,		  8,		 4,
+	/*   8GB */	 11,		 11,		 5,
+	/*
+	 * For volumes 16GB and larger, we want to make sure that a full OS
+	 * install won't require fragmentation of the Catalog or Attributes
+	 * B-trees.  We do this by making the clump sizes sufficiently large,
+	 * and by leaving a gap after the B-trees for them to grow into.
+	 *
+	 * For SnowLeopard 10A298, a FullNetInstall with all packages selected
+	 * results in:
+	 * Catalog B-tree Header
+	 *	nodeSize:          8192
+	 *	totalNodes:       31616
+	 *	freeNodes:         1978
+	 * (used = 231.55 MB)
+	 * Attributes B-tree Header
+	 *	nodeSize:          8192
+	 *	totalNodes:       63232
+	 *	freeNodes:          958
+	 * (used = 486.52 MB)
+	 *
+	 * We also want Time Machine backup volumes to have a sufficiently
+	 * large clump size to reduce fragmentation.
+	 *
+	 * The series of numbers for Catalog and Attribute form a geometric
+	 * series. For Catalog (16GB to 512GB), each term is 8**(1/5) times
+	 * the previous term.  For Attributes (16GB to 512GB), each term is
+	 * 4**(1/5) times the previous term.  For 1TB to 16TB, each term is
+	 * 2**(1/5) times the previous term.
+	 */
+	/*  16GB */	 64,		 32,		 5,
+	/*  32GB */	 84,		 49,		 6,
+	/*  64GB */	111,		 74,		 7,
+	/* 128GB */	147,		111,		 8,
+	/* 256GB */	194,		169,		 9,
+	/* 512GB */	256,		256,		11,
+	/*   1TB */	294,		294,		14,
+	/*   2TB */	338,		338,		16,
+	/*   4TB */	388,		388,		20,
+	/*   8TB */	446,		446,		25,
+	/*  16TB */	512,		512,		32
+};
+
+u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size,
+					u64 sectors, int file_id)
+{
+	u32 mod = max(node_size, block_size);
+	u32 clump_size;
+	int column;
+	int i;
+
+	/* Figure out which column of the above table to use for this file. */
+	switch (file_id) {
+	case HFSPLUS_ATTR_CNID:
+		column = 0;
+		break;
+	case HFSPLUS_CAT_CNID:
+		column = 1;
+		break;
+	default:
+		column = 2;
+		break;
+	}
+
+	/*
+	 * The default clump size is 0.8% of the volume size. And
+	 * it must also be a multiple of the node and block size.
+	 */
+	if (sectors < 0x200000) {
+		clump_size = sectors << 2;	/*  0.8 %  */
+		if (clump_size < (8 * node_size))
+			clump_size = 8 * node_size;
+	} else {
+		/* turn exponent into table index... */
+		for (i = 0, sectors = sectors >> 22;
+		     sectors && (i < CLUMP_ENTRIES - 1);
+		     ++i, sectors = sectors >> 1) {
+			/* empty body */
+		}
+
+		clump_size = clumptbl[column + (i) * 3] * 1024 * 1024;
+	}
+
+	/*
+	 * Round the clump size to a multiple of node and block size.
+	 * NOTE: This rounds down.
+	 */
+	clump_size /= mod;
+	clump_size *= mod;
+
+	/*
+	 * Rounding down could have rounded down to 0 if the block size was
+	 * greater than the clump size.  If so, just use one block or node.
+	 */
+	if (clump_size == 0)
+		clump_size = mod;
+
+	return clump_size;
+}
 
 /* Get a reference to a B*Tree and do some initial checks */
 struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-metadata-files-clump-size-calculation-functionality fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-metadata-files-clump-size-calculation-functionality
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -380,6 +380,7 @@ int hfsplus_block_allocate(struct super_
 int hfsplus_block_free(struct super_block *, u32, u32);
 
 /* btree.c */
+u32 hfsplus_calc_btree_clump_size(u32, u32, u64, int);
 struct hfs_btree *hfs_btree_open(struct super_block *, u32);
 void hfs_btree_close(struct hfs_btree *);
 int hfs_btree_write(struct hfs_btree *);
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-fix-issue-with-race-condition-of-competition-between-segments-for-dirty-blocks.patch
hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
hfsplus-implement-attributes-files-header-node-initialization-code.patch
hfsplus-implement-attributes-file-creation-functionality.patch

