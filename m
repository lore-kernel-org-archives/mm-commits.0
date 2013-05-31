From: akpm@linux-foundation.org
Subject: +
 nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch added to -mm tree
Date: Fri, 31 May 2013 13:15:37 -0700
Message-ID: <51a904e9.Pnt8Q1dqi8mEgjzs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaUPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linuxhippy@gmail.com, konishi.ryusuke@lab.ntt.co.jp, joern@logfs.org, slava@dubeyko.com

Subject: + nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch added to -mm tree
To: slava@dubeyko.com,joern@logfs.org,konishi.ryusuke@lab.ntt.co.jp,linuxhippy@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:15:37 -0700


The patch titled
     Subject: ] nilfs2: use atomic64_t type for inodes_count and blocks_count fields in nilfs_root struct
has been added to the -mm tree.  Its filename is
     nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch

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
Subject: ] nilfs2: use atomic64_t type for inodes_count and blocks_count fields in nilfs_root struct

The cp_inodes_count and cp_blocks_count are represented as __le64 type in
on-disk structure (struct nilfs_checkpoint).  But analogous fields in
in-core structure (struct nilfs_root) are represented by atomic_t type.

This patch replaces atomic_t on atomic64_t type in representation of
inodes_count and blocks_count fields in struct nilfs_root.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Acked-by: Joern Engel <joern@logfs.org>
Cc: Clemens Eisserer <linuxhippy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ifile.c     |    2 +-
 fs/nilfs2/inode.c     |    8 ++++----
 fs/nilfs2/segment.c   |    4 ++--
 fs/nilfs2/super.c     |    8 +++++---
 fs/nilfs2/the_nilfs.c |    4 ++--
 fs/nilfs2/the_nilfs.h |    4 ++--
 6 files changed, 16 insertions(+), 14 deletions(-)

diff -puN fs/nilfs2/ifile.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct
+++ a/fs/nilfs2/ifile.c
@@ -174,7 +174,7 @@ int nilfs_ifile_count_free_inodes(struct
 	*nmaxinodes = 0;
 	*nfreeinodes = 0;
 
-	nused = atomic_read(&NILFS_I(ifile)->i_root->inodes_count);
+	nused = atomic64_read(&NILFS_I(ifile)->i_root->inodes_count);
 	err = nilfs_palloc_count_max_entries(ifile, nused, nmaxinodes);
 	if (likely(!err))
 		*nfreeinodes = *nmaxinodes - nused;
diff -puN fs/nilfs2/inode.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct
+++ a/fs/nilfs2/inode.c
@@ -54,7 +54,7 @@ void nilfs_inode_add_blocks(struct inode
 
 	inode_add_bytes(inode, (1 << inode->i_blkbits) * n);
 	if (root)
-		atomic_add(n, &root->blocks_count);
+		atomic64_add(n, &root->blocks_count);
 }
 
 void nilfs_inode_sub_blocks(struct inode *inode, int n)
@@ -63,7 +63,7 @@ void nilfs_inode_sub_blocks(struct inode
 
 	inode_sub_bytes(inode, (1 << inode->i_blkbits) * n);
 	if (root)
-		atomic_sub(n, &root->blocks_count);
+		atomic64_sub(n, &root->blocks_count);
 }
 
 /**
@@ -369,7 +369,7 @@ struct inode *nilfs_new_inode(struct ino
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
-	atomic_inc(&root->inodes_count);
+	atomic64_inc(&root->inodes_count);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = ino;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
@@ -801,7 +801,7 @@ void nilfs_evict_inode(struct inode *ino
 
 	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
 	if (!ret)
-		atomic_dec(&ii->i_root->inodes_count);
+		atomic64_dec(&ii->i_root->inodes_count);
 
 	nilfs_clear_inode(inode);
 
diff -puN fs/nilfs2/segment.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct
+++ a/fs/nilfs2/segment.c
@@ -835,9 +835,9 @@ static int nilfs_segctor_fill_in_checkpo
 	raw_cp->cp_snapshot_list.ssl_next = 0;
 	raw_cp->cp_snapshot_list.ssl_prev = 0;
 	raw_cp->cp_inodes_count =
-		cpu_to_le64(atomic_read(&sci->sc_root->inodes_count));
+		cpu_to_le64(atomic64_read(&sci->sc_root->inodes_count));
 	raw_cp->cp_blocks_count =
-		cpu_to_le64(atomic_read(&sci->sc_root->blocks_count));
+		cpu_to_le64(atomic64_read(&sci->sc_root->blocks_count));
 	raw_cp->cp_nblk_inc =
 		cpu_to_le64(sci->sc_nblk_inc + sci->sc_nblk_this_inc);
 	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
diff -puN fs/nilfs2/super.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct
+++ a/fs/nilfs2/super.c
@@ -554,8 +554,10 @@ int nilfs_attach_checkpoint(struct super
 	if (err)
 		goto failed_bh;
 
-	atomic_set(&root->inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
-	atomic_set(&root->blocks_count, le64_to_cpu(raw_cp->cp_blocks_count));
+	atomic64_set(&root->inodes_count,
+			le64_to_cpu(raw_cp->cp_inodes_count));
+	atomic64_set(&root->blocks_count,
+			le64_to_cpu(raw_cp->cp_blocks_count));
 
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
 
@@ -647,7 +649,7 @@ static int nilfs_statfs(struct dentry *d
 			 * curent inodes count as maximum possible and
 			 * zero as free inodes value.
 			 */
-			nmaxinodes = atomic_read(&root->inodes_count);
+			nmaxinodes = atomic64_read(&root->inodes_count);
 			nfreeinodes = 0;
 			err = 0;
 		} else
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct
+++ a/fs/nilfs2/the_nilfs.c
@@ -764,8 +764,8 @@ nilfs_find_or_create_root(struct the_nil
 	new->ifile = NULL;
 	new->nilfs = nilfs;
 	atomic_set(&new->count, 1);
-	atomic_set(&new->inodes_count, 0);
-	atomic_set(&new->blocks_count, 0);
+	atomic64_set(&new->inodes_count, 0);
+	atomic64_set(&new->blocks_count, 0);
 
 	rb_link_node(&new->rb_node, parent, p);
 	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct
+++ a/fs/nilfs2/the_nilfs.h
@@ -241,8 +241,8 @@ struct nilfs_root {
 	struct the_nilfs *nilfs;
 	struct inode *ifile;
 
-	atomic_t inodes_count;
-	atomic_t blocks_count;
+	atomic64_t inodes_count;
+	atomic64_t blocks_count;
 };
 
 /* Special checkpoint number */
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-implement-calculation-of-free-inodes-count.patch
nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch

