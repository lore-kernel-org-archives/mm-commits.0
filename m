From: akpm@linux-foundation.org
Subject: [merged] nilfs2-implement-calculation-of-free-inodes-count.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:27 -0700
Message-ID: <51db147f.VeNWvR7k7XitRDIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GHTf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linuxhippy@gmail.com, konishi.ryusuke@lab.ntt.co.jp, joern@logfs.org, slava@dubeyko.com

Subject: [merged] nilfs2-implement-calculation-of-free-inodes-count.patch removed from -mm tree
To: slava@dubeyko.com,joern@logfs.org,konishi.ryusuke@lab.ntt.co.jp,linuxhippy@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:27 -0700


The patch titled
     Subject: nilfs2: implement calculation of free inodes count
has been removed from the -mm tree.  Its filename was
     nilfs2-implement-calculation-of-free-inodes-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: implement calculation of free inodes count

Currently, NILFS2 returns 0 as free inodes count (f_ffree) and current
used inodes count as total file nodes in file system (f_files):

df -i
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/loop0           2      2       0  100% /mnt/nilfs2

This patch implements real calculation of free inodes count.  First of
all, it is calculated total file nodes in file system as
(desc_blocks_count * groups_per_desc_block * entries_per_group).  Then, it
is calculated free inodes count as difference the total file nodes and
used inodes count.  As a result, we have such output for NILFS2:

df -i
Filesystem       Inodes   IUsed    IFree IUse% Mounted on
/dev/loop0      4194304 2114701  2079603   51% /mnt/nilfs2

Reported-by: Clemens Eisserer <linuxhippy@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   63 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/alloc.h |    2 +
 fs/nilfs2/ifile.c |   22 +++++++++++++++
 fs/nilfs2/ifile.h |    2 +
 fs/nilfs2/super.c |   25 ++++++++++++++++-
 5 files changed, 112 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-implement-calculation-of-free-inodes-count fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-implement-calculation-of-free-inodes-count
+++ a/fs/nilfs2/alloc.c
@@ -398,6 +398,69 @@ nilfs_palloc_rest_groups_in_desc_block(c
 }
 
 /**
+ * nilfs_palloc_count_desc_blocks - count descriptor blocks number
+ * @inode: inode of metadata file using this allocator
+ * @desc_blocks: descriptor blocks number [out]
+ */
+static int nilfs_palloc_count_desc_blocks(struct inode *inode,
+					    unsigned long *desc_blocks)
+{
+	unsigned long blknum;
+	int ret;
+
+	ret = nilfs_bmap_last_key(NILFS_I(inode)->i_bmap, &blknum);
+	if (likely(!ret))
+		*desc_blocks = DIV_ROUND_UP(
+			blknum, NILFS_MDT(inode)->mi_blocks_per_desc_block);
+	return ret;
+}
+
+/**
+ * nilfs_palloc_mdt_file_can_grow - check potential opportunity for
+ *					MDT file growing
+ * @inode: inode of metadata file using this allocator
+ * @desc_blocks: known current descriptor blocks count
+ */
+static inline bool nilfs_palloc_mdt_file_can_grow(struct inode *inode,
+						    unsigned long desc_blocks)
+{
+	return (nilfs_palloc_groups_per_desc_block(inode) * desc_blocks) <
+			nilfs_palloc_groups_count(inode);
+}
+
+/**
+ * nilfs_palloc_count_max_entries - count max number of entries that can be
+ *					described by descriptor blocks count
+ * @inode: inode of metadata file using this allocator
+ * @nused: current number of used entries
+ * @nmaxp: max number of entries [out]
+ */
+int nilfs_palloc_count_max_entries(struct inode *inode, u64 nused, u64 *nmaxp)
+{
+	unsigned long desc_blocks = 0;
+	u64 entries_per_desc_block, nmax;
+	int err;
+
+	err = nilfs_palloc_count_desc_blocks(inode, &desc_blocks);
+	if (unlikely(err))
+		return err;
+
+	entries_per_desc_block = (u64)nilfs_palloc_entries_per_group(inode) *
+				nilfs_palloc_groups_per_desc_block(inode);
+	nmax = entries_per_desc_block * desc_blocks;
+
+	if (nused == nmax &&
+			nilfs_palloc_mdt_file_can_grow(inode, desc_blocks))
+		nmax += entries_per_desc_block;
+
+	if (nused > nmax)
+		return -ERANGE;
+
+	*nmaxp = nmax;
+	return 0;
+}
+
+/**
  * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
diff -puN fs/nilfs2/alloc.h~nilfs2-implement-calculation-of-free-inodes-count fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-implement-calculation-of-free-inodes-count
+++ a/fs/nilfs2/alloc.h
@@ -48,6 +48,8 @@ int nilfs_palloc_get_entry_block(struct
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
 
+int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
+
 /**
  * nilfs_palloc_req - persistent allocator request and reply
  * @pr_entry_nr: entry number (vblocknr or inode number)
diff -puN fs/nilfs2/ifile.c~nilfs2-implement-calculation-of-free-inodes-count fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-implement-calculation-of-free-inodes-count
+++ a/fs/nilfs2/ifile.c
@@ -160,6 +160,28 @@ int nilfs_ifile_get_inode_block(struct i
 }
 
 /**
+ * nilfs_ifile_count_free_inodes - calculate free inodes count
+ * @ifile: ifile inode
+ * @nmaxinodes: current maximum of available inodes count [out]
+ * @nfreeinodes: free inodes count [out]
+ */
+int nilfs_ifile_count_free_inodes(struct inode *ifile,
+				    u64 *nmaxinodes, u64 *nfreeinodes)
+{
+	u64 nused;
+	int err;
+
+	*nmaxinodes = 0;
+	*nfreeinodes = 0;
+
+	nused = atomic_read(&NILFS_I(ifile)->i_root->inodes_count);
+	err = nilfs_palloc_count_max_entries(ifile, nused, nmaxinodes);
+	if (likely(!err))
+		*nfreeinodes = *nmaxinodes - nused;
+	return err;
+}
+
+/**
  * nilfs_ifile_read - read or get ifile inode
  * @sb: super block instance
  * @root: root object
diff -puN fs/nilfs2/ifile.h~nilfs2-implement-calculation-of-free-inodes-count fs/nilfs2/ifile.h
--- a/fs/nilfs2/ifile.h~nilfs2-implement-calculation-of-free-inodes-count
+++ a/fs/nilfs2/ifile.h
@@ -49,6 +49,8 @@ int nilfs_ifile_create_inode(struct inod
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
+int nilfs_ifile_count_free_inodes(struct inode *, u64 *, u64 *);
+
 int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
 		     size_t inode_size, struct nilfs_inode *raw_inode,
 		     struct inode **inodep);
diff -puN fs/nilfs2/super.c~nilfs2-implement-calculation-of-free-inodes-count fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-implement-calculation-of-free-inodes-count
+++ a/fs/nilfs2/super.c
@@ -609,6 +609,7 @@ static int nilfs_statfs(struct dentry *d
 	unsigned long overhead;
 	unsigned long nrsvblocks;
 	sector_t nfreeblocks;
+	u64 nmaxinodes, nfreeinodes;
 	int err;
 
 	/*
@@ -633,14 +634,34 @@ static int nilfs_statfs(struct dentry *d
 	if (unlikely(err))
 		return err;
 
+	err = nilfs_ifile_count_free_inodes(root->ifile,
+					    &nmaxinodes, &nfreeinodes);
+	if (unlikely(err)) {
+		printk(KERN_WARNING
+			"NILFS warning: fail to count free inodes: err %d.\n",
+			err);
+		if (err == -ERANGE) {
+			/*
+			 * If nilfs_palloc_count_max_entries() returns
+			 * -ERANGE error code then we simply treat
+			 * curent inodes count as maximum possible and
+			 * zero as free inodes value.
+			 */
+			nmaxinodes = atomic_read(&root->inodes_count);
+			nfreeinodes = 0;
+			err = 0;
+		} else
+			return err;
+	}
+
 	buf->f_type = NILFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = blocks - overhead;
 	buf->f_bfree = nfreeblocks;
 	buf->f_bavail = (buf->f_bfree >= nrsvblocks) ?
 		(buf->f_bfree - nrsvblocks) : 0;
-	buf->f_files = atomic_read(&root->inodes_count);
-	buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
+	buf->f_files = nmaxinodes;
+	buf->f_ffree = nfreeinodes;
 	buf->f_namelen = NILFS_NAME_LEN;
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

