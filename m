From: akpm@linux-foundation.org
Subject: + nilfs2-continuous-snapshotting-file-system.patch added to -mm tree
Date: Wed, 20 Aug 2008 00:43:37 -0700
Message-ID: <200808200743.m7K7hbHU031067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbYHTHnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 03:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: continuous snapshotting file system
has been added to the -mm tree.  Its filename is
     nilfs2-continuous-snapshotting-file-system.patch

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
Subject: nilfs2: continuous snapshotting file system
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This is a kernel patch of NILFS2 file system which was previously
announced in [1].  Since the original code did not comply with the
Linux Coding Style, I've rewritten it a lot.

NILFS2 is a log-structured file system (LFS) supporting ``continuous
snapshotting''.  In addition to versioning capability of the entire
file system, users can even restore files and namespaces mistakenly
overwritten or destroyed just a few seconds ago.

NILFS2 creates a number of checkpoints every few seconds or per
synchronous write basis (unless there is no change).  Users can select
significant versions among continuously created checkpoints, and can
change them into snapshots which will be preserved until they are
changed back to checkpoints.

There is no limit on the number of snapshots until the volume gets
full.  Each snapshot is mountable as a read-only file system
concurrently with its writable mount, and this feature is convenient
for online backup.  It will be also favorable for time-machine like
user environment or appliances.

Please see [2] for details on the project.

Other features are:

- Quick crash recovery on-mount (like conventional LFS)
- B-tree based file, inode, and other meta data management including
  snapshots.
- 64-bit data structures; support many files, large files and disks.
- Online disk space reclamation by userland daemon, which can maintain
  multiple snapshots.
- Less use of barrier with keeping reliability. The barrier is enabled
  by default.
- Easy and quickly performable snapshot administration

Some impressive benchmark results on SSD are shown in [3], however the
current NILFS2 performance is sensitive to machine environment due to
its immature implementation.

It has many TODO items:

- performance improvement (better block I/O submission)
- better integration of b-tree node cache with filemap and buffer code.
- cleanups, further simplification.
- atime support
- extendend attributes support
- POSIX ACL support
- Quota support

The patch against 2.6.27-rc3 (hopefully applicable to the next -mm
tree) is available at:

http://www.nilfs.org/pub/patch/nilfs2-continuous-snapshotting-file-system.patch

It is not yet divided into pieces (sorry).  Unlike original code
available at [4], many code lines to support past kernel versions and
peculiar debug code are removed in this patch.

The userland tools are included in nilfs-utils package, which is
available from [4].  Details on the tools are described in the man
pages included in the package.

Here is an example:

- To use nilfs2 as a local file system, simply:

 # mkfs -t nilfs2 /dev/block_device
 # mount -t nilfs2 /dev/block_device /dir

  This will also invoke the cleaner through the mount helper program
  (mount.nilfs2).

- Checkpoints and snapshots are managed by the following commands.
  Their manpages are included in the nilfs-utils package above.

   lscp     list checkpoints or snapshots.
   mkcp     make a checkpoint or a snapshot.
   chcp     change an existing checkpoint to a snapshot or vice versa.
   rmcp     invalidate specified checkpoint(s).

  For example,

 # chcp ss 2

  changes the checkpoint No. 2 into snapshot.

- To mount a snapshot,

 # mount -t nilfs2 -r -o cp=<cno> /dev/block_device /snap_dir

  where <cno> is the checkpoint number of the snapshot.

- More illustrative example is found in [5].

Thank you,
Ryusuke Konishi, NILFS Team, NTT.

1. NILFS version2 now available
http://marc.info/?l=linux-fsdevel&m=118187597808509&w=2

2. NILFS homepage
http://www.nilfs.org/en/index.html

3. Dongjun Shin, About SSD
http://www.usenix.org/event/lsf08/tech/shin_SSD.pdf

4. Source archive
http://www.nilfs.org/en/download.html

5. Using NILFS
http://www.nilfs.org/en/about_nilfs.html


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/00-INDEX   |    2 
 Documentation/filesystems/nilfs2.txt |  106 
 fs/Kconfig                           |   26 
 fs/Makefile                          |    1 
 fs/nilfs2/Makefile                   |    5 
 fs/nilfs2/alloc.c                    |  283 ++
 fs/nilfs2/alloc.h                    |  155 +
 fs/nilfs2/bmap.c                     |  785 ++++++
 fs/nilfs2/bmap.h                     |  253 +
 fs/nilfs2/bmap_union.h               |   42 
 fs/nilfs2/btnode.c                   |  782 ++++++
 fs/nilfs2/btnode.h                   |  114 
 fs/nilfs2/btree.c                    | 2283 +++++++++++++++++
 fs/nilfs2/btree.h                    |  137 +
 fs/nilfs2/cpfile.c                   | 1145 ++++++++
 fs/nilfs2/cpfile.h                   |   50 
 fs/nilfs2/dat.c                      | 1125 ++++++++
 fs/nilfs2/dat.h                      |   91 
 fs/nilfs2/dir.c                      |  711 +++++
 fs/nilfs2/direct.c                   |  428 +++
 fs/nilfs2/direct.h                   |   78 
 fs/nilfs2/file.c                     |  124 
 fs/nilfs2/gcdat.c                    |  229 +
 fs/nilfs2/gcinode.c                  |  296 ++
 fs/nilfs2/ifile.c                    |  257 +
 fs/nilfs2/ifile.h                    |   47 
 fs/nilfs2/inode.c                    |  825 ++++++
 fs/nilfs2/ioctl.c                    | 1009 +++++++
 fs/nilfs2/mdt.c                      |  673 +++++
 fs/nilfs2/mdt.h                      |  147 +
 fs/nilfs2/namei.c                    |  452 +++
 fs/nilfs2/nilfs.h                    |  295 ++
 fs/nilfs2/page.c                     |  566 ++++
 fs/nilfs2/page.h                     |  127 
 fs/nilfs2/recovery.c                 |  939 +++++++
 fs/nilfs2/sb.h                       |   97 
 fs/nilfs2/segbuf.c                   |  439 +++
 fs/nilfs2/segbuf.h                   |  215 +
 fs/nilfs2/seglist.h                  |   85 
 fs/nilfs2/segment.c                  | 3230 +++++++++++++++++++++++++
 fs/nilfs2/segment.h                  |  294 ++
 fs/nilfs2/sufile.c                   |  758 +++++
 fs/nilfs2/sufile.h                   |   67 
 fs/nilfs2/super.c                    | 1377 ++++++++++
 fs/nilfs2/the_nilfs.c                |  515 +++
 fs/nilfs2/the_nilfs.h                |  286 ++
 include/linux/nilfs2_fs.h            |  867 ++++++
 47 files changed, 22818 insertions(+)

diff -puN Documentation/filesystems/00-INDEX~nilfs2-continuous-snapshotting-file-system Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~nilfs2-continuous-snapshotting-file-system
+++ a/Documentation/filesystems/00-INDEX
@@ -68,6 +68,8 @@ ncpfs.txt
 	- info on Novell Netware(tm) filesystem using NCP protocol.
 nfsroot.txt
 	- short guide on setting up a diskless box with NFS root filesystem.
+nilfs2.txt
+	- info and mount options for the NILFS2 filesystem.
 ntfs.txt
 	- info and mount options for the NTFS filesystem (Windows NT).
 ocfs2.txt
diff -puN /dev/null Documentation/filesystems/nilfs2.txt
--- /dev/null
+++ a/Documentation/filesystems/nilfs2.txt
@@ -0,0 +1,106 @@
+NILFS2
+------
+
+NILFS2 is a log-structured file system (LFS) supporting continuous
+snapshotting.  In addition to versioning capability of the entire file
+system, users can even restore files mistakenly overwritten or
+destroyed just a few seconds ago.  Since NILFS2 can keep consistency
+like conventional LFS, it achieves quick recovery after system
+crashes.
+
+NILFS2 creates a number of checkpoints every few seconds or per
+synchronous write basis (unless there is no change).  Users can select
+significant versions among continuously created checkpoints, and can
+change them into snapshots which will be preserved until they are
+changed back to checkpoints.
+
+There is no limit on the number of snapshots until the volume gets
+full.  Each snapshot is mountable as a read-only file system
+concurrently with its writable mount, and this feature is convenient
+for online backup.
+
+The userland tools are included in nilfs-utils package, which is
+available from the following download page.  At least "mkfs.nilfs2",
+"mount.nilfs2", "umount.nilfs2", and "nilfs_cleanerd" (so called
+cleaner or garbage collector) are required.  Details on the tools are
+described in the man pages included in the package.
+
+Project web page:    http://www.nilfs.org/en/
+Download page:       http://www.nilfs.org/en/download.html
+Git tree web page:   http://www.nilfs.org/git/
+NILFS mailing lists: http://www.nilfs.org/mailman/listinfo/users
+
+Caveats
+=======
+
+Features which NILFS2 does not support yet:
+
+	- atime
+	- extended attributes
+	- POSIX ACLs
+	- quotas
+	- writable snapshots
+	- remote backup (CDP)
+	- data integrity
+	- defragmentation
+
+Mount options
+=============
+
+NILFS2 supports the following mount options:
+(*) == default
+
+barrier=on(*)		This enables/disables barriers. barrier=off disables
+			it, barrier=on enables it.
+errors=continue(*)	Keep going on a filesystem error.
+errors=remount-ro	Remount the filesystem read-only on an error.
+errors=panic		Panic and halt the machine if an error occurs.
+cp=n			Specify the checkpoint-number of the snapshot to be
+			mounted.  Checkpoints and snapshots are listed by lscp
+			user command.  Only the checkpoints marked as snapshot
+			are mountable with this option.  Snapshot is read-only,
+			so a read-only mount option must be specified together.
+order=relaxed(*)	Apply relaxed order semantics that allows modified data
+			blocks to be written to disk without making a
+			checkpoint if no metadata update is going.  This mode
+			is equivalent to the ordered data mode of the ext3
+			filesystem except for the updates on data blocks still
+			conserve atomicity.  This will improve synchronous
+			write performance for overwriting.
+order=strict		Apply strict in-order semantics that preserves sequence
+			of all file operations including overwriting of data
+			blocks.  That means, it is guaranteed that no
+			overtaking of events occurs in the recovered file
+			system after a crash.
+
+NILFS2 usage
+============
+
+To use nilfs2 as a local file system, simply:
+
+ # mkfs -t nilfs2 /dev/block_device
+ # mount -t nilfs2 /dev/block_device /dir
+
+This will also invoke the cleaner through the mount helper program
+(mount.nilfs2).
+
+Checkpoints and snapshots are managed by the following commands.
+Their manpages are included in the nilfs-utils package above.
+
+  lscp     list checkpoints or snapshots.
+  mkcp     make a checkpoint or a snapshot.
+  chcp     change an existing checkpoint to a snapshot or vice versa.
+  rmcp     invalidate specified checkpoint(s).
+
+To mount a snapshot,
+
+ # mount -t nilfs2 -r -o cp=<cno> /dev/block_device /snap_dir
+
+where <cno> is the checkpoint number of the snapshot.
+
+To unmount the NILFS2 mount point or snapshot, simply:
+
+ # umount /dir
+
+Then, the cleaner daemon is automatically shut down by the umount
+helper program (umount.nilfs2).
diff -puN fs/Kconfig~nilfs2-continuous-snapshotting-file-system fs/Kconfig
--- a/fs/Kconfig~nilfs2-continuous-snapshotting-file-system
+++ a/fs/Kconfig
@@ -1392,6 +1392,32 @@ config MINIX_FS
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
 
+config NILFS2_FS
+	tristate "NILFS2 file system support (EXPERIMENTAL)"
+	depends on BLOCK && EXPERIMENTAL
+	select CRC32
+	help
+	  NILFS2 is a log-structured file system (LFS) supporting continuous
+	  snapshotting.  In addition to versioning capability of the entire
+	  file system, users can even restore files mistakenly overwritten or
+	  destroyed just a few seconds ago.  Since this file system can keep
+	  consistency like conventional LFS, it achieves quick recovery after
+	  system crashes.
+
+	  NILFS2 creates a number of checkpoints every few seconds or per
+	  synchronous write basis (unless there is no change).  Users can
+	  select significant versions among continuously created checkpoints,
+	  and can change them into snapshots which will be preserved for long
+	  periods until they are changed back to checkpoints.  Each
+	  snapshot is mountable as a read-only file system concurrently with
+	  its writable mount, and this feature is convenient for online backup.
+
+	  Some features including atime, extended attributes, and POSIX ACLs,
+	  are not supported yet.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called nilfs2.  If unsure, say N.
+
 config OMFS_FS
 	tristate "SonicBlue Optimized MPEG File System support"
 	depends on BLOCK
diff -puN fs/Makefile~nilfs2-continuous-snapshotting-file-system fs/Makefile
--- a/fs/Makefile~nilfs2-continuous-snapshotting-file-system
+++ a/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_NILFS2_FS)		+= nilfs2/
diff -puN /dev/null fs/nilfs2/Makefile
--- /dev/null
+++ a/fs/nilfs2/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_NILFS2_FS) += nilfs2.o
+nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
+	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
+	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
+	ifile.o alloc.o gcinode.o ioctl.o gcdat.o
diff -puN /dev/null fs/nilfs2/alloc.c
--- /dev/null
+++ a/fs/nilfs2/alloc.c
@@ -0,0 +1,283 @@
+/*
+ * alloc.c - NILFS dat/inode allocator
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include "mdt.h"
+#include "alloc.h"
+
+static inline unsigned long
+nilfs_persistent_desc_offset(struct inode *inode, unsigned long group)
+{
+	return group % nilfs_persistent_group_descs_per_block(inode);
+}
+
+
+struct nilfs_persistent_group_desc *
+nilfs_persistent_get_group_desc(struct inode *inode, unsigned long group,
+				const struct buffer_head *desc_bh)
+{
+	void *kaddr = kmap(desc_bh->b_page);
+
+	return (struct nilfs_persistent_group_desc *)
+		(kaddr + bh_offset(desc_bh)) +
+		nilfs_persistent_desc_offset(inode, group);
+}
+
+static void
+nilfs_persistent_desc_block_init(struct inode *inode, struct buffer_head *bh,
+				 void *kaddr)
+{
+	struct nilfs_persistent_group_desc *desc = kaddr + bh_offset(bh);
+	int i;
+
+	for (i = 0; i < nilfs_persistent_group_descs_per_block(inode); i++) {
+		desc->pg_nfrees =
+			cpu_to_le32(nilfs_persistent_entries_per_group(inode));
+		desc++;
+	}
+}
+
+char *
+nilfs_persistent_get_group_bitmap_buffer(struct inode *inode,
+					 const struct buffer_head *bitmap_bh)
+{
+	void *kaddr = kmap(bitmap_bh->b_page);
+
+	return (char *)(kaddr + bh_offset(bitmap_bh));
+}
+
+void
+nilfs_persistent_put_group_bitmap_buffer(struct inode *inode,
+					 const struct buffer_head *bitmap_bh)
+{
+	kunmap(bitmap_bh->b_page);
+}
+
+int
+nilfs_persistent_get_group_desc_block(struct inode *inode, unsigned long group,
+				      struct buffer_head **desc_bhp)
+{
+	unsigned long blkoff =
+		nilfs_persistent_group_desc_blkoff(inode, group);
+
+	return nilfs_mdt_get_block(inode, blkoff, 1,
+				   nilfs_persistent_desc_block_init, desc_bhp);
+}
+
+static int
+nilfs_persistent_get_group_bitmap_block(struct inode *inode,
+					unsigned long group,
+					struct buffer_head **bitmap_bhp)
+{
+	unsigned long blkoff =
+		nilfs_persistent_group_bitmap_blkoff(inode, group);
+
+	return nilfs_mdt_get_block(inode, blkoff, 1, NULL, bitmap_bhp);
+}
+
+static int
+nilfs_persistent_group_find_available_slot(struct inode *inode,
+					   unsigned long group,
+					   unsigned long target,
+					   unsigned char *bitmap,
+					   int bsize)
+{
+	int curr, pos, end;
+	int i;
+
+	if (target > 0) {
+		end = (target + BITS_PER_LONG - 1) & ~(BITS_PER_LONG - 1);
+		if (end > bsize)
+			end = bsize;
+		pos = nilfs_persistent_find_next_zero_bit(bitmap, end, target);
+		if ((pos < end) &&
+		    !nilfs_persistent_set_bit_atomic(
+			    nilfs_mdt_bgl_lock(inode, group), pos, bitmap))
+			return pos;
+	} else
+		end = 0;
+
+	for (i = 0, curr = end;
+	     i < bsize;
+	     i += BITS_PER_LONG, curr += BITS_PER_LONG) {
+		/* wrap around */
+		if (curr >= bsize)
+			curr = 0;
+		while (*((unsigned long *)bitmap + curr / BITS_PER_LONG)
+		       != ~0UL) {
+			end = curr + BITS_PER_LONG;
+			if (end > bsize)
+				end = bsize;
+			pos = nilfs_persistent_find_next_zero_bit(bitmap, end,
+								  curr);
+			if ((pos < end) &&
+			    !nilfs_persistent_set_bit_atomic(
+				    nilfs_mdt_bgl_lock(inode, group), pos,
+				    bitmap))
+				return pos;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+int nilfs_persistent_prepare_alloc_entry(struct inode *inode,
+					 struct nilfs_persistent_req *req,
+					 unsigned long *group_p, int *target_p)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	struct nilfs_persistent_group_desc *desc;
+	unsigned long group;
+	unsigned long ngroups;
+	char *start;
+	int pos, target, ret, bsize;
+	unsigned long i;
+
+	bsize = nilfs_persistent_entries_per_group(inode);
+
+	group = *group_p;
+	target = *target_p;
+
+	ngroups = NILFS_MDT(inode)->mi_groups_count;
+
+	for (i = 0; i < ngroups; i++, group++) {
+		if (group >= ngroups)
+			group = 0;
+		ret = nilfs_persistent_get_group_desc_block(inode, group,
+							    &desc_bh);
+		if (ret < 0)
+			return ret;
+		desc = nilfs_persistent_get_group_desc(inode, group, desc_bh);
+		if (le32_to_cpu(desc->pg_nfrees) > 0) {
+			ret = nilfs_persistent_get_group_bitmap_block(
+				inode, group, &bitmap_bh);
+			if (ret < 0) {
+				nilfs_persistent_put_group_desc(inode, desc_bh);
+				nilfs_persistent_put_group_desc_block(
+					inode, desc_bh);
+				return ret;
+			}
+			start = nilfs_persistent_get_group_bitmap_buffer(
+				inode, bitmap_bh);
+			pos = nilfs_persistent_group_find_available_slot(
+				inode, group, target, start, bsize);
+			if (pos >= 0) {
+				/* found a free inode number */
+				spin_lock(nilfs_mdt_bgl_lock(inode, group));
+				desc->pg_nfrees = cpu_to_le32(
+					le32_to_cpu(desc->pg_nfrees) - 1);
+				spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+
+				*group_p = group;
+				*target_p = pos;
+				req->pr_desc_bh = desc_bh;
+				req->pr_bitmap_bh = bitmap_bh;
+				return 0;
+			}
+			nilfs_persistent_put_group_bitmap_buffer(inode,
+								 bitmap_bh);
+			nilfs_persistent_put_group_bitmap_block(inode,
+								bitmap_bh);
+		}
+		nilfs_persistent_put_group_desc(inode, desc_bh);
+		nilfs_persistent_put_group_desc_block(inode, desc_bh);
+		target = 0;
+	}
+
+	return -ENOSPC;
+}
+
+void nilfs_persistent_commit_alloc_entry(struct inode *inode,
+					 struct nilfs_persistent_req *req)
+{
+	nilfs_mdt_mark_buffer_dirty(req->pr_bitmap_bh);
+	nilfs_mdt_mark_buffer_dirty(req->pr_desc_bh);
+
+	nilfs_persistent_put_group_bitmap_buffer(inode, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_bitmap_block(inode, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_desc(inode, req->pr_desc_bh);
+	nilfs_persistent_put_group_desc_block(inode, req->pr_desc_bh);
+}
+
+void nilfs_persistent_abort_alloc_entry(struct inode *inode,
+					struct nilfs_persistent_req *req,
+					unsigned long group, int grpoff)
+{
+	struct nilfs_persistent_group_desc *desc;
+	char *bitmap_buffer;
+
+	desc = nilfs_persistent_get_group_desc(inode, group, req->pr_desc_bh);
+	bitmap_buffer = nilfs_persistent_get_group_bitmap_buffer(
+		inode, req->pr_bitmap_bh);
+
+	if (!nilfs_persistent_clear_bit_atomic(
+		    nilfs_mdt_bgl_lock(inode, group), grpoff, bitmap_buffer))
+		printk(KERN_WARNING
+		       "persistent entry numer %lu already freed\n",
+		       req->pr_ino);
+
+	spin_lock(nilfs_mdt_bgl_lock(inode, group));
+	desc->pg_nfrees = cpu_to_le32(le32_to_cpu(desc->pg_nfrees) + 1);
+	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+
+	nilfs_persistent_put_group_bitmap_buffer(inode, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_bitmap_block(inode, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_desc(inode, req->pr_desc_bh);
+	nilfs_persistent_put_group_desc_block(inode, req->pr_desc_bh);
+
+	req->pr_nslot = 0;
+	req->pr_bitmap_bh = NULL;
+	req->pr_desc_bh = NULL;
+}
+
+int nilfs_persistent_prepare_free_entry(struct inode *inode,
+					struct nilfs_persistent_req *req,
+					unsigned long group)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	int ret;
+
+	ret = nilfs_persistent_get_group_desc_block(inode, group, &desc_bh);
+	if (ret < 0)
+		return ret;
+	ret = nilfs_persistent_get_group_bitmap_block(inode, group, &bitmap_bh);
+	if (ret < 0) {
+		nilfs_persistent_put_group_desc_block(inode, desc_bh);
+		return ret;
+	}
+
+	req->pr_desc_bh = desc_bh;
+	req->pr_bitmap_bh = bitmap_bh;
+
+	return 0;
+}
+
+void nilfs_persistent_abort_free_entry(struct inode *inode,
+				       struct nilfs_persistent_req *req)
+{
+	nilfs_persistent_put_group_bitmap_buffer(inode, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_bitmap_block(inode, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_desc(inode, req->pr_desc_bh);
+	nilfs_persistent_put_group_desc_block(inode, req->pr_desc_bh);
+
+	req->pr_nslot = 0;
+	req->pr_bitmap_bh = NULL;
+	req->pr_desc_bh = NULL;
+}
diff -puN /dev/null fs/nilfs2/alloc.h
--- /dev/null
+++ a/fs/nilfs2/alloc.h
@@ -0,0 +1,155 @@
+/*
+ * alloc.h - persistent object (dat entry/disk inode) allocator/deallocator
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>
+ */
+
+#ifndef _NILFS_ALLOC_H
+#define _NILFS_ALLOC_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/fs.h>
+#include <linux/bitops.h>
+
+
+#define NILFS_PERSISTENT_CHAR_BIT	8
+
+#define nilfs_persistent_set_bit_atomic		ext2_set_bit_atomic
+#define nilfs_persistent_clear_bit_atomic	ext2_clear_bit_atomic
+#define nilfs_persistent_test_bit		ext2_test_bit
+#define nilfs_persistent_find_next_zero_bit	ext2_find_next_zero_bit
+
+static inline int nilfs_persistent_entries_per_group(struct inode *inode)
+{
+	return (1UL << inode->i_blkbits) * NILFS_PERSISTENT_CHAR_BIT;
+}
+
+static inline int nilfs_persistent_group_descs_per_block(struct inode *inode)
+{
+	return (1UL << inode->i_blkbits) /
+		sizeof(struct nilfs_persistent_group_desc);
+}
+
+static inline int
+nilfs_persistent_blocks_per_groups(struct inode *inode)
+{
+	/* including block descriptor block */
+	return NILFS_MDT(inode)->mi_blocks_per_group
+		* nilfs_persistent_group_descs_per_block(inode) + 1;
+}
+
+static inline unsigned long
+nilfs_persistent_group_desc_blkoff(struct inode *inode, unsigned long group)
+{
+	unsigned long g =
+		group / nilfs_persistent_group_descs_per_block(inode);
+	return g * (nilfs_persistent_group_descs_per_block(inode) *
+		 (nilfs_persistent_entries_per_group(inode) /
+		  NILFS_MDT(inode)->mi_entries_per_block + 1) + 1);
+}
+
+static inline unsigned long
+nilfs_persistent_group_bitmap_blkoff(struct inode *inode, unsigned long group)
+{
+	unsigned long group_offset =
+		group % nilfs_persistent_group_descs_per_block(inode);
+
+	return nilfs_persistent_group_desc_blkoff(inode, group) + 1 +
+		group_offset * (nilfs_persistent_entries_per_group(inode) /
+				NILFS_MDT(inode)->mi_entries_per_block + 1);
+}
+
+/**
+ * nilfs_persistent_req - request and reply
+ * @nr: vblocknr or inode number
+ * @pr_desc_bh: buffer head of the buffer containing block group descriptors
+ * @pr_bitmap_bh: buffer head of the buffer containing a block group bitmap
+ * @pr_entry_bh: buffer head of the buffer containing translation entries
+ */
+struct nilfs_persistent_req {
+	struct buffer_head *pr_desc_bh;
+	struct buffer_head *pr_bitmap_bh;
+	struct buffer_head *pr_entry_bh;
+	union {
+		__u64	pr_vblocknr;
+		ino_t	pr_ino;
+		__u64	pr_nslot;	/* for clear both vblocknr and ino */
+	} nr;
+};
+
+#define pr_vblocknr nr.vblocknr
+#define pr_ino nr.pr_ino
+#define pr_nslot nr.pr_nslot
+
+static inline void
+nilfs_persistent_put_group_bitmap_block(const struct inode *inode,
+					struct buffer_head *bitmap_bh)
+{
+	brelse(bitmap_bh);
+}
+
+
+static inline void
+nilfs_persistent_put_entry_block(const struct inode *inode,
+				 struct buffer_head *bh)
+{
+	brelse(bh);
+}
+
+extern int nilfs_persistent_prepare_alloc_entry(struct inode *,
+						struct nilfs_persistent_req *,
+						unsigned long *, int *);
+extern void nilfs_persistent_abort_alloc_entry(struct inode *,
+					       struct nilfs_persistent_req *,
+					       unsigned long, int);
+extern void nilfs_persistent_commit_alloc_entry(struct inode *,
+						struct nilfs_persistent_req *);
+extern int nilfs_persistent_prepare_free_entry(struct inode *,
+					       struct nilfs_persistent_req *,
+					       unsigned long);
+extern void nilfs_persistent_abort_free_entry(struct inode *,
+					      struct nilfs_persistent_req *);
+extern char *
+nilfs_persistent_get_group_bitmap_buffer(struct inode *,
+					 const struct buffer_head *);
+
+extern struct nilfs_persistent_group_desc *
+nilfs_persistent_get_group_desc(struct inode *, unsigned long,
+				const struct buffer_head *);
+extern void
+nilfs_persistent_put_group_bitmap_buffer(struct inode *,
+					 const struct buffer_head *);
+
+static inline void
+nilfs_persistent_put_group_desc(struct inode *inode,
+				const struct buffer_head *desc_bh)
+{
+	kunmap(desc_bh->b_page);
+}
+
+static inline void
+nilfs_persistent_put_group_desc_block(const struct inode *inode,
+				      struct buffer_head *desc_bh)
+{
+	brelse(desc_bh);
+}
+
+
+#endif	/* _NILFS_ALLOC_H */
diff -puN /dev/null fs/nilfs2/bmap.c
--- /dev/null
+++ a/fs/nilfs2/bmap.c
@@ -0,0 +1,785 @@
+/*
+ * bmap.c - NILFS block mapping.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include "nilfs.h"
+#include "sb.h"
+#include "btnode.h"
+#include "mdt.h"
+#include "dat.h"
+#include "bmap.h"
+
+int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
+			       __u64 *ptrp)
+{
+	__u64 ptr;
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_lookup)(bmap, key, level, ptrp);
+	if (ret < 0)
+		goto out;
+	if (bmap->b_pops->bpop_translate != NULL) {
+		ret = (*bmap->b_pops->bpop_translate)(bmap, *ptrp, &ptr);
+		if (ret < 0)
+			goto out;
+		*ptrp = ptr;
+	}
+
+ out:
+	up_read(&bmap->b_sem);
+	return ret;
+}
+
+
+/**
+ * nilfs_bmap_lookup - find a record
+ * @bmap: bmap
+ * @key: key
+ * @recp: pointer to record
+ *
+ * Description: nilfs_bmap_lookup() finds a record whose key matches @key in
+ * @bmap.
+ *
+ * Return Value: On success, 0 is returned and the record associated with @key
+ * is stored in the place pointed by @recp. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A record associated with @key does not exist.
+ */
+int nilfs_bmap_lookup(struct nilfs_bmap *bmap,
+		      unsigned long key,
+		      unsigned long *recp)
+{
+	__u64 ptr;
+	int ret;
+
+	/* XXX: use macro for level 1 */
+	ret = nilfs_bmap_lookup_at_level(bmap, key, 1, &ptr);
+	if (recp != NULL)
+		*recp = ptr;
+	return ret;
+}
+
+static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
+{
+	__u64 keys[NILFS_BMAP_SMALL_HIGH + 1];
+	__u64 ptrs[NILFS_BMAP_SMALL_HIGH + 1];
+	int ret, n;
+
+	if (bmap->b_ops->bop_check_insert != NULL) {
+		ret = (*bmap->b_ops->bop_check_insert)(bmap, key);
+		if (ret > 0) {
+			n = (*bmap->b_ops->bop_gather_data)(
+				bmap, keys, ptrs, NILFS_BMAP_SMALL_HIGH + 1);
+			if (n < 0)
+				return n;
+			ret = (*nilfs_bmap_large_convert_and_insert)(
+				bmap, key, ptr, keys, ptrs, n,
+				NILFS_BMAP_LARGE_LOW, NILFS_BMAP_LARGE_HIGH);
+			if (ret == 0)
+				bmap->b_u.u_flags |= NILFS_BMAP_LARGE;
+
+			return ret;
+		} else if (ret < 0)
+			return ret;
+	}
+
+	return (*bmap->b_ops->bop_insert)(bmap, key, ptr);
+}
+
+/**
+ * nilfs_bmap_insert - insert a new key-record pair into a bmap
+ * @bmap: bmap
+ * @key: key
+ * @rec: record
+ *
+ * Description: nilfs_bmap_insert() inserts the new key-record pair specified
+ * by @key and @rec into @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EEXIST - A record associated with @key already exist.
+ */
+int nilfs_bmap_insert(struct nilfs_bmap *bmap,
+		      unsigned long key,
+		      unsigned long rec)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_do_insert(bmap, key, rec);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
+{
+	__u64 keys[NILFS_BMAP_LARGE_LOW + 1];
+	__u64 ptrs[NILFS_BMAP_LARGE_LOW + 1];
+	int ret, n;
+
+	if (bmap->b_ops->bop_check_delete != NULL) {
+		ret = (*bmap->b_ops->bop_check_delete)(bmap, key);
+		if (ret > 0) {
+			n = (*bmap->b_ops->bop_gather_data)(
+				bmap, keys, ptrs, NILFS_BMAP_LARGE_LOW + 1);
+			if (n < 0)
+				return n;
+			ret = (*nilfs_bmap_small_delete_and_convert)(
+				bmap, key, keys, ptrs, n,
+				NILFS_BMAP_SMALL_LOW, NILFS_BMAP_SMALL_HIGH);
+			if (ret == 0)
+				bmap->b_u.u_flags &= ~NILFS_BMAP_LARGE;
+
+			return ret;
+		} else if (ret < 0)
+			return ret;
+	}
+
+	return (*bmap->b_ops->bop_delete)(bmap, key);
+}
+
+int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
+{
+	__u64 lastkey;
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+	if (!ret)
+		*key = lastkey;
+	up_read(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_delete - delete a key-record pair from a bmap
+ * @bmap: bmap
+ * @key: key
+ *
+ * Description: nilfs_bmap_delete() deletes the key-record pair specified by
+ * @key from @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A record associated with @key does not exist.
+ */
+int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_do_delete(bmap, key);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
+{
+	__u64 lastkey;
+	int ret;
+
+	ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+	if (ret < 0) {
+		if (ret == -ENOENT)
+			ret = 0;
+		return ret;
+	}
+
+	while (key <= lastkey) {
+		ret = nilfs_bmap_do_delete(bmap, lastkey);
+		if (ret < 0)
+			return ret;
+		ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+		if (ret < 0) {
+			if (ret == -ENOENT)
+				ret = 0;
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * nilfs_bmap_truncate - truncate a bmap to a specified key
+ * @bmap: bmap
+ * @key: key
+ *
+ * Description: nilfs_bmap_truncate() removes key-record pairs whose keys are
+ * greater than or equal to @key from @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_do_truncate(bmap, key);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_clear - free resources a bmap holds
+ * @bmap: bmap
+ *
+ * Description: nilfs_bmap_clear() frees resources associated with @bmap.
+ */
+void nilfs_bmap_clear(struct nilfs_bmap *bmap)
+{
+	down_write(&bmap->b_sem);
+	if (bmap->b_ops->bop_clear != NULL)
+		(*bmap->b_ops->bop_clear)(bmap);
+	up_write(&bmap->b_sem);
+}
+
+/**
+ * nilfs_bmap_propagate - propagate dirty state
+ * @bmap: bmap
+ * @bh: buffer head
+ *
+ * Description: nilfs_bmap_propagate() marks the buffers that directly or
+ * indirectly refer to the block specified by @bh dirty.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_propagate)(bmap, bh);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_lookup_dirty_buffers -
+ * @bmap: bmap
+ * @listp: pointer to buffer head list
+ */
+void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *bmap,
+				     struct list_head *listp)
+{
+	if (bmap->b_ops->bop_lookup_dirty_buffers != NULL)
+		(*bmap->b_ops->bop_lookup_dirty_buffers)(bmap, listp);
+}
+
+/**
+ * nilfs_bmap_assign - assign a new block number to a block
+ * @bmap: bmap
+ * @bhp: pointer to buffer head
+ * @blocknr: block number
+ * @binfo: block information
+ *
+ * Description: nilfs_bmap_assign() assigns the block number @blocknr to the
+ * buffer specified by @bh.
+ *
+ * Return Value: On success, 0 is returned and the buffer head of a newly
+ * create buffer and the block information associated with the buffer are
+ * stored in the place pointed by @bh and @binfo, respectively. On error, one
+ * of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_assign(struct nilfs_bmap *bmap,
+		      struct buffer_head **bh,
+		      unsigned long blocknr,
+		      union nilfs_binfo *binfo)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_assign)(bmap, bh, blocknr, binfo);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_mark - mark block dirty
+ * @bmap: bmap
+ * @key: key
+ * @level: level
+ *
+ * Description: nilfs_bmap_mark() marks the block specified by @key and @level
+ * as dirty.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
+{
+	int ret;
+
+	if (bmap->b_ops->bop_mark == NULL)
+		return 0;
+
+	down_write(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_mark)(bmap, key, level);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_test_and_clear_dirty - test and clear a bmap dirty state
+ * @bmap: bmap
+ *
+ * Description: nilfs_test_and_clear() is the atomic operation to test and
+ * clear the dirty state of @bmap.
+ *
+ * Return Value: 1 is returned if @bmap is dirty, or 0 if clear.
+ */
+int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_dirty(bmap);
+	nilfs_bmap_clear_dirty(bmap);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+
+/*
+ * Internal use only
+ */
+
+void nilfs_bmap_add_blocks(const struct nilfs_bmap *bmap, int n)
+{
+	inode_add_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
+	if (NILFS_MDT(bmap->b_inode))
+		nilfs_mdt_mark_dirty(bmap->b_inode);
+	else
+		mark_inode_dirty(bmap->b_inode);
+}
+
+void nilfs_bmap_sub_blocks(const struct nilfs_bmap *bmap, int n)
+{
+	inode_sub_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
+	if (NILFS_MDT(bmap->b_inode))
+		nilfs_mdt_mark_dirty(bmap->b_inode);
+	else
+		mark_inode_dirty(bmap->b_inode);
+}
+
+int nilfs_bmap_get_block(const struct nilfs_bmap *bmap, __u64 ptr,
+			 struct buffer_head **bhp)
+{
+	return nilfs_btnode_get(&NILFS_BMAP_I(bmap)->i_btnode_cache, ptr, bhp);
+}
+
+void nilfs_bmap_put_block(const struct nilfs_bmap *bmap,
+			  struct buffer_head *bh)
+{
+	brelse(bh);
+}
+
+int nilfs_bmap_get_new_block(const struct nilfs_bmap *bmap, __u64 ptr,
+			     struct buffer_head **bhp)
+{
+	int ret;
+
+	ret = nilfs_btnode_get_new(&NILFS_BMAP_I(bmap)->i_btnode_cache,
+				   ptr, bhp);
+	if (ret < 0)
+		return ret;
+	set_buffer_nilfs_volatile(*bhp);
+	return 0;
+}
+
+void nilfs_bmap_delete_block(const struct nilfs_bmap *bmap,
+			     struct buffer_head *bh)
+{
+	nilfs_btnode_delete(bh);
+}
+
+__u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
+			      const struct buffer_head *bh)
+{
+	struct buffer_head *pbh;
+	__u64 key;
+
+	key = page_index(bh->b_page) << (PAGE_CACHE_SHIFT -
+					 bmap->b_inode->i_blkbits);
+	for (pbh = page_buffers(bh->b_page); pbh != bh;
+	     pbh = pbh->b_this_page, key++);
+
+	return key;
+}
+
+__u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *bmap, __u64 key)
+{
+	__s64 diff;
+
+	diff = key - bmap->b_last_allocated_key;
+	if ((nilfs_bmap_keydiff_abs(diff) < NILFS_INODE_BMAP_SIZE) &&
+	    (bmap->b_last_allocated_ptr != NILFS_BMAP_INVALID_PTR) &&
+	    (bmap->b_last_allocated_ptr + diff > 0))
+		return bmap->b_last_allocated_ptr + diff;
+	else
+		return NILFS_BMAP_INVALID_PTR;
+}
+
+static struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
+{
+	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
+}
+
+#define NILFS_BMAP_GROUP_DIV	8
+__u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
+{
+	struct inode *dat = nilfs_bmap_get_dat(bmap);
+	unsigned long entries_per_group, group;
+
+	entries_per_group = nilfs_dat_entries_per_group(dat);
+	group = bmap->b_inode->i_ino / entries_per_group;
+
+	return group * entries_per_group +
+		(bmap->b_inode->i_ino % NILFS_BMAP_GROUP_DIV) *
+		(entries_per_group / NILFS_BMAP_GROUP_DIV);
+	/* XXX: for user-land test */
+	/* return 0; */
+}
+
+static int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	return nilfs_dat_prepare_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_commit_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *bmap,
+				     union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_abort_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static int nilfs_bmap_prepare_start_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	return nilfs_dat_prepare_start(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_commit_start_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req,
+				      sector_t blocknr)
+{
+	nilfs_dat_commit_start(nilfs_bmap_get_dat(bmap), &req->bpr_req,
+			       blocknr);
+}
+
+static void nilfs_bmap_abort_start_v(struct nilfs_bmap *bmap,
+				     union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_abort_start(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static int nilfs_bmap_prepare_end_v(struct nilfs_bmap *bmap,
+				    union nilfs_bmap_ptr_req *req)
+{
+	return nilfs_dat_prepare_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_commit_end_v(struct nilfs_bmap *bmap,
+				    union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req, 0);
+}
+
+static void nilfs_bmap_commit_end_vmdt(struct nilfs_bmap *bmap,
+				       union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req, 1);
+}
+
+static void nilfs_bmap_abort_end_v(struct nilfs_bmap *bmap,
+				   union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_abort_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+int nilfs_bmap_move_v(const struct nilfs_bmap *bmap, __u64 vblocknr,
+		      sector_t blocknr)
+{
+	return nilfs_dat_move(nilfs_bmap_get_dat(bmap), vblocknr, blocknr);
+}
+
+int nilfs_bmap_mark_dirty(const struct nilfs_bmap *bmap, __u64 vblocknr)
+{
+	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), vblocknr);
+}
+
+int nilfs_bmap_prepare_update(struct nilfs_bmap *bmap,
+			      union nilfs_bmap_ptr_req *oldreq,
+			      union nilfs_bmap_ptr_req *newreq)
+{
+	int ret;
+
+	ret = (*bmap->b_pops->bpop_prepare_end_ptr)(bmap, oldreq);
+	if (ret < 0)
+		return ret;
+	ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, newreq);
+	if (ret < 0)
+		(*bmap->b_pops->bpop_abort_end_ptr)(bmap, oldreq);
+
+	return ret;
+}
+
+void nilfs_bmap_commit_update(struct nilfs_bmap *bmap,
+			      union nilfs_bmap_ptr_req *oldreq,
+			      union nilfs_bmap_ptr_req *newreq)
+{
+	(*bmap->b_pops->bpop_commit_end_ptr)(bmap, oldreq);
+	(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, newreq);
+}
+
+void nilfs_bmap_abort_update(struct nilfs_bmap *bmap,
+			     union nilfs_bmap_ptr_req *oldreq,
+			     union nilfs_bmap_ptr_req *newreq)
+{
+	(*bmap->b_pops->bpop_abort_end_ptr)(bmap, oldreq);
+	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, newreq);
+}
+
+static int nilfs_bmap_translate_v(const struct nilfs_bmap *bmap, __u64 ptr,
+				  __u64 *ptrp)
+{
+	sector_t blocknr;
+	int ret;
+
+	ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), ptr, &blocknr);
+	if (ret < 0)
+		return ret;
+	if (ptrp != NULL)
+		*ptrp = blocknr;
+	return 0;
+}
+
+static int nilfs_bmap_prepare_alloc_p(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	/* ignore target ptr */
+	req->bpr_ptr = bmap->b_last_allocated_ptr++;
+	return 0;
+}
+
+static void nilfs_bmap_commit_alloc_p(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	/* do nothing */
+}
+
+static void nilfs_bmap_abort_alloc_p(struct nilfs_bmap *bmap,
+				     union nilfs_bmap_ptr_req *req)
+{
+	bmap->b_last_allocated_ptr--;
+}
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_v = {
+	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
+	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
+	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
+	.bpop_prepare_start_ptr	=	nilfs_bmap_prepare_start_v,
+	.bpop_commit_start_ptr	=	nilfs_bmap_commit_start_v,
+	.bpop_abort_start_ptr	=	nilfs_bmap_abort_start_v,
+	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
+	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_v,
+	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
+
+	.bpop_translate		=	nilfs_bmap_translate_v,
+};
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_vmdt = {
+	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
+	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
+	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
+	.bpop_prepare_start_ptr	=	nilfs_bmap_prepare_start_v,
+	.bpop_commit_start_ptr	=	nilfs_bmap_commit_start_v,
+	.bpop_abort_start_ptr	=	nilfs_bmap_abort_start_v,
+	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
+	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_vmdt,
+	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
+
+	.bpop_translate		=	nilfs_bmap_translate_v,
+};
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_p = {
+	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_p,
+	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_p,
+	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_p,
+	.bpop_prepare_start_ptr	=	NULL,
+	.bpop_commit_start_ptr	=	NULL,
+	.bpop_abort_start_ptr	=	NULL,
+	.bpop_prepare_end_ptr	=	NULL,
+	.bpop_commit_end_ptr	=	NULL,
+	.bpop_abort_end_ptr	=	NULL,
+
+	.bpop_translate		=	NULL,
+};
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_gc = {
+	.bpop_prepare_alloc_ptr	=	NULL,
+	.bpop_commit_alloc_ptr	=	NULL,
+	.bpop_abort_alloc_ptr	=	NULL,
+	.bpop_prepare_start_ptr	=	NULL,
+	.bpop_commit_start_ptr	=	NULL,
+	.bpop_abort_start_ptr	=	NULL,
+	.bpop_prepare_end_ptr	=	NULL,
+	.bpop_commit_end_ptr	=	NULL,
+	.bpop_abort_end_ptr	=	NULL,
+
+	.bpop_translate		=	NULL,
+};
+
+/**
+ * nilfs_bmap_read - read a bmap from an inode
+ * @bmap: bmap
+ * @raw_inode: on-disk inode
+ *
+ * Description: nilfs_bmap_read() initializes the bmap @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
+{
+	if (raw_inode == NULL)
+		memset(bmap->b_u.u_data, 0, NILFS_BMAP_SIZE);
+	else
+		memcpy(bmap->b_u.u_data, raw_inode->i_bmap, NILFS_BMAP_SIZE);
+
+	init_rwsem(&bmap->b_sem);
+	bmap->b_state = 0;
+	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+	switch (bmap->b_inode->i_ino) {
+	case NILFS_DAT_INO:
+		bmap->b_pops = &nilfs_bmap_ptr_ops_p;
+		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
+		break;
+	case NILFS_CPFILE_INO:
+	case NILFS_SUFILE_INO:
+		bmap->b_pops = &nilfs_bmap_ptr_ops_vmdt;
+		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+		break;
+	default:
+		bmap->b_pops = &nilfs_bmap_ptr_ops_v;
+		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+		break;
+	}
+
+	return (bmap->b_u.u_flags & NILFS_BMAP_LARGE) ?
+		nilfs_bmap_large_init(bmap,
+				      NILFS_BMAP_LARGE_LOW,
+				      NILFS_BMAP_LARGE_HIGH) :
+		nilfs_bmap_small_init(bmap,
+				      NILFS_BMAP_SMALL_LOW,
+				      NILFS_BMAP_SMALL_HIGH);
+}
+
+/**
+ * nilfs_bmap_write - write back a bmap to an inode
+ * @bmap: bmap
+ * @raw_inode: on-disk inode
+ *
+ * Description: nilfs_bmap_write() stores @bmap in @raw_inode.
+ */
+void nilfs_bmap_write(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
+{
+	down_write(&bmap->b_sem);
+	memcpy(raw_inode->i_bmap, bmap->b_u.u_data,
+	       NILFS_INODE_BMAP_SIZE * sizeof(__le64));
+	if (bmap->b_inode->i_ino == NILFS_DAT_INO)
+		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
+
+	up_write(&bmap->b_sem);
+}
+
+void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
+{
+	memset(&bmap->b_u, 0, NILFS_BMAP_SIZE);
+	init_rwsem(&bmap->b_sem);
+	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+	bmap->b_pops = &nilfs_bmap_ptr_ops_gc;
+	bmap->b_last_allocated_key = 0;
+	bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+	bmap->b_state = 0;
+	nilfs_btree_init_gc(bmap);
+}
+
+void nilfs_bmap_init_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
+{
+	memcpy(gcbmap, bmap, sizeof(union nilfs_bmap_union));
+	init_rwsem(&gcbmap->b_sem);
+	gcbmap->b_inode = &NILFS_BMAP_I(gcbmap)->vfs_inode;
+}
+
+void nilfs_bmap_commit_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
+{
+	memcpy(bmap, gcbmap, sizeof(union nilfs_bmap_union));
+	init_rwsem(&bmap->b_sem);
+	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+}
diff -puN /dev/null fs/nilfs2/bmap.h
--- /dev/null
+++ a/fs/nilfs2/bmap.h
@@ -0,0 +1,253 @@
+/*
+ * bmap.h - NILFS block mapping.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_BMAP_H
+#define _NILFS_BMAP_H
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "sb.h"
+#include "dat.h"
+
+#define NILFS_BMAP_INVALID_PTR	0
+
+#define nilfs_bmap_dkey_to_key(dkey)	le64_to_cpu(dkey)
+#define nilfs_bmap_key_to_dkey(key)	cpu_to_le64(key)
+#define nilfs_bmap_dptr_to_ptr(dptr)	le64_to_cpu(dptr)
+#define nilfs_bmap_ptr_to_dptr(ptr)	cpu_to_le64(ptr)
+
+#define nilfs_bmap_keydiff_abs(diff)	((diff) < 0 ? -(diff) : (diff))
+
+
+struct nilfs_bmap;
+
+/**
+ * union nilfs_bmap_ptr_req - request for bmap ptr
+ * @bpr_ptr:
+ * @bpr_req:
+ */
+union nilfs_bmap_ptr_req {
+	__u64 bpr_ptr;
+	struct nilfs_dat_req bpr_req;
+};
+
+/**
+ * struct nilfs_bmap_stats - bmap statistics
+ * @bs_nblocks: number of blocks created or deleted
+ */
+struct nilfs_bmap_stats {
+	unsigned int bs_nblocks;
+};
+
+/**
+ * struct nilfs_bmap_operations - bmap operation table
+ */
+struct nilfs_bmap_operations {
+	int (*bop_lookup)(const struct nilfs_bmap *, __u64, int, __u64 *);
+	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
+	int (*bop_delete)(struct nilfs_bmap *, __u64);
+	void (*bop_clear)(struct nilfs_bmap *);
+
+	int (*bop_propagate)(const struct nilfs_bmap *, struct buffer_head *);
+	void (*bop_lookup_dirty_buffers)(struct nilfs_bmap *,
+					 struct list_head *);
+
+	int (*bop_assign)(struct nilfs_bmap *,
+			  struct buffer_head **,
+			  sector_t,
+			  union nilfs_binfo *);
+	int (*bop_mark)(struct nilfs_bmap *, __u64, int);
+
+	/* The following functions are internal use only. */
+	int (*bop_last_key)(const struct nilfs_bmap *, __u64 *);
+	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
+	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
+	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
+};
+
+
+/**
+ * struct nilfs_bmap_ptr_operations - bmap ptr operation table
+ */
+struct nilfs_bmap_ptr_operations {
+	int (*bpop_prepare_alloc_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *);
+	void (*bpop_commit_alloc_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *);
+	void (*bpop_abort_alloc_ptr)(struct nilfs_bmap *,
+				     union nilfs_bmap_ptr_req *);
+	int (*bpop_prepare_start_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *);
+	void (*bpop_commit_start_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *,
+				      sector_t);
+	void (*bpop_abort_start_ptr)(struct nilfs_bmap *,
+				     union nilfs_bmap_ptr_req *);
+	int (*bpop_prepare_end_ptr)(struct nilfs_bmap *,
+				    union nilfs_bmap_ptr_req *);
+	void (*bpop_commit_end_ptr)(struct nilfs_bmap *,
+				    union nilfs_bmap_ptr_req *);
+	void (*bpop_abort_end_ptr)(struct nilfs_bmap *,
+				   union nilfs_bmap_ptr_req *);
+
+	int (*bpop_translate)(const struct nilfs_bmap *, __u64, __u64 *);
+};
+
+
+#define NILFS_BMAP_SIZE		(NILFS_INODE_BMAP_SIZE * sizeof(__le64))
+#define NILFS_BMAP_CHAR_BIT	8	/* number of bits in char */
+#define NILFS_BMAP_KEY_BIT	(sizeof(unsigned long) * NILFS_BMAP_CHAR_BIT)
+#define NILFS_BMAP_NEW_PTR_INIT	\
+	(1UL << (sizeof(unsigned long) * NILFS_BMAP_CHAR_BIT - 1))
+
+static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
+{
+	return !!(ptr & NILFS_BMAP_NEW_PTR_INIT);
+}
+
+
+/**
+ * struct nilfs_bmap - bmap structure
+ * @b_u: raw data
+ * @b_sem: semaphore
+ * @b_inode: owner of bmap
+ * @b_ops: bmap operation table
+ * @b_pops: bmap ptr operation table
+ * @b_low: low watermark of conversion
+ * @b_high: high watermark of conversion
+ * @b_last_allocated_key: last allocated key for data block
+ * @b_last_allocated_ptr: last allocated ptr for data block
+ * @b_state: state
+ */
+struct nilfs_bmap {
+	union {
+		__u8 u_flags;
+		__le64 u_data[NILFS_BMAP_SIZE / sizeof(__le64)];
+	} b_u;
+	struct rw_semaphore b_sem;
+	struct inode *b_inode;
+	const struct nilfs_bmap_operations *b_ops;
+	const struct nilfs_bmap_ptr_operations *b_pops;
+	__u64 b_low;
+	__u64 b_high;
+	__u64 b_last_allocated_key;
+	__u64 b_last_allocated_ptr;
+	int b_state;
+};
+
+/* state */
+#define NILFS_BMAP_DIRTY	0x00000001
+
+
+int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
+int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
+void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
+int nilfs_bmap_lookup(struct nilfs_bmap *, unsigned long, unsigned long *);
+int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
+int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
+int nilfs_bmap_last_key(struct nilfs_bmap *, unsigned long *);
+int nilfs_bmap_truncate(struct nilfs_bmap *, unsigned long);
+void nilfs_bmap_clear(struct nilfs_bmap *);
+int nilfs_bmap_propagate(struct nilfs_bmap *, struct buffer_head *);
+void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *, struct list_head *);
+int nilfs_bmap_assign(struct nilfs_bmap *, struct buffer_head **,
+		      unsigned long, union nilfs_binfo *);
+int nilfs_bmap_lookup_at_level(struct nilfs_bmap *, __u64, int, __u64 *);
+int nilfs_bmap_mark(struct nilfs_bmap *, __u64, int);
+
+void nilfs_bmap_init_gc(struct nilfs_bmap *);
+void nilfs_bmap_init_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
+void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
+
+
+/*
+ * Internal use only
+ */
+
+int nilfs_bmap_move_v(const struct nilfs_bmap *, __u64, sector_t);
+int nilfs_bmap_mark_dirty(const struct nilfs_bmap *, __u64);
+
+
+__u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *,
+			      const struct buffer_head *);
+
+__u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *, __u64);
+__u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *);
+
+int nilfs_bmap_prepare_update(struct nilfs_bmap *,
+			      union nilfs_bmap_ptr_req *,
+			      union nilfs_bmap_ptr_req *);
+void nilfs_bmap_commit_update(struct nilfs_bmap *,
+			      union nilfs_bmap_ptr_req *,
+			      union nilfs_bmap_ptr_req *);
+void nilfs_bmap_abort_update(struct nilfs_bmap *,
+			     union nilfs_bmap_ptr_req *,
+			     union nilfs_bmap_ptr_req *);
+
+void nilfs_bmap_add_blocks(const struct nilfs_bmap *, int);
+void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
+
+
+int nilfs_bmap_get_block(const struct nilfs_bmap *, __u64,
+			 struct buffer_head **);
+void nilfs_bmap_put_block(const struct nilfs_bmap *, struct buffer_head *);
+int nilfs_bmap_get_new_block(const struct nilfs_bmap *, __u64,
+			     struct buffer_head **);
+void nilfs_bmap_delete_block(const struct nilfs_bmap *, struct buffer_head *);
+
+
+/* Assume that bmap semaphore is locked. */
+static inline int nilfs_bmap_dirty(const struct nilfs_bmap *bmap)
+{
+	return !!(bmap->b_state & NILFS_BMAP_DIRTY);
+}
+
+/* Assume that bmap semaphore is locked. */
+static inline void nilfs_bmap_set_dirty(struct nilfs_bmap *bmap)
+{
+	bmap->b_state |= NILFS_BMAP_DIRTY;
+}
+
+/* Assume that bmap semaphore is locked. */
+static inline void nilfs_bmap_clear_dirty(struct nilfs_bmap *bmap)
+{
+	bmap->b_state &= ~NILFS_BMAP_DIRTY;
+}
+
+
+#define NILFS_BMAP_LARGE	0x1
+
+#define NILFS_BMAP_SMALL_LOW	NILFS_DIRECT_KEY_MIN
+#define NILFS_BMAP_SMALL_HIGH	NILFS_DIRECT_KEY_MAX
+#define NILFS_BMAP_LARGE_LOW	NILFS_BTREE_ROOT_NCHILDREN_MAX
+#define NILFS_BMAP_LARGE_HIGH	NILFS_BTREE_KEY_MAX
+
+#define nilfs_bmap_small_init			nilfs_direct_init
+#define nilfs_bmap_small_convert_and_insert	NULL
+#define nilfs_bmap_small_delete_and_convert	nilfs_direct_delete_and_convert
+#define nilfs_bmap_large_init			nilfs_btree_init
+#define nilfs_bmap_large_convert_and_insert	nilfs_btree_convert_and_insert
+#define nilfs_bmap_large_delete_and_convert	NULL
+
+#endif	/* _NILFS_BMAP_H */
diff -puN /dev/null fs/nilfs2/bmap_union.h
--- /dev/null
+++ a/fs/nilfs2/bmap_union.h
@@ -0,0 +1,42 @@
+/*
+ * bmap_union.h - NILFS block mapping.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_BMAP_UNION_H
+#define _NILFS_BMAP_UNION_H
+
+#include "bmap.h"
+#include "direct.h"
+#include "btree.h"
+
+/**
+ * nilfs_bmap_union -
+ * @bi_bmap: bmap structure
+ * @bi_btree: direct map structure
+ * @bi_direct: B-tree structure
+ */
+union nilfs_bmap_union {
+	struct nilfs_bmap bi_bmap;
+	struct nilfs_direct bi_direct;
+	struct nilfs_btree bi_btree;
+};
+
+#endif	/* _NILFS_BMAP_UNION_H */
diff -puN /dev/null fs/nilfs2/btnode.c
--- /dev/null
+++ a/fs/nilfs2/btnode.c
@@ -0,0 +1,782 @@
+/*
+ * btnode.c - NILFS B-tree node block
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Seiji Kihara <kihara@osrg.net>
+ * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include "nilfs.h"
+#include "mdt.h"
+#include "page.h"
+#include "btnode.h"
+
+
+#define NILFS_BTNODE_GANG_SIZE	16	/* Array size for gang lookups */
+#define NILFS_BTNODE_CLEAN_BH_STATE \
+	((1 << BH_NILFS_Node) | (1 << BH_NILFS_Allocated))
+
+/*
+ * Expediential macros
+ *
+ * - B2P: block to page_index
+ * - B2O: block to offset in the page
+ */
+#define B2P(blocknr, inode) \
+	(unsigned long)((blocknr) >> (PAGE_CACHE_SHIFT - (inode)->i_blkbits))
+#define B2O(blocknr, inode) \
+	((unsigned int)((blocknr) & \
+			((1UL << (PAGE_CACHE_SHIFT - (inode)->i_blkbits)) - 1)))
+
+static inline struct nilfs_btnode_cache *PAGE_BTNC(struct page *page)
+{
+	struct inode *inode =
+		container_of(page->mapping, struct inode, i_data);
+	return &NILFS_I(inode)->i_btnode_cache;
+}
+
+static inline struct inode *BTNC_I(struct nilfs_btnode_cache *btnc)
+{
+	struct nilfs_inode_info *ii =
+		container_of(btnc, struct nilfs_inode_info, i_btnode_cache);
+	return &ii->vfs_inode;
+}
+
+unsigned nilfs_btnode_find_get_pages(struct nilfs_btnode_cache *btnc,
+				     struct page **pages, pgoff_t *index,
+				     unsigned int nr_pages)
+{
+	unsigned int i, res;
+
+	nilfs_btnode_read_lock(btnc);
+	res = nilfs_btnode_gang_lookup_nolock(btnc, pages, *index, nr_pages);
+	for (i = 0; i < res; i++)
+		page_cache_get(pages[i]);
+	if (res)
+		*index = pages[res - 1]->index + 1;
+	nilfs_btnode_read_unlock(btnc);
+	return res;
+}
+
+unsigned nilfs_btnode_find_get_pages_tag(struct nilfs_btnode_cache *btnc,
+					 struct page **pages, pgoff_t *index,
+					 unsigned int nr_pages, int tag)
+{
+	unsigned int i, res;
+
+	nilfs_btnode_read_lock(btnc);
+	res = nilfs_btnode_gang_lookup_tag_nolock(btnc, pages, *index,
+						  nr_pages, tag);
+	for (i = 0; i < res; i++)
+		page_cache_get(pages[i]);
+	if (res)
+		*index = pages[res - 1]->index + 1;
+	nilfs_btnode_read_unlock(btnc);
+	return res;
+}
+
+/* borrowed from mm/filemap.c::find_get_page */
+static struct page *nilfs_btnode_find_get_page(struct nilfs_btnode_cache *btnc,
+					       unsigned long index)
+{
+	struct page *page;
+
+	nilfs_btnode_read_lock(btnc);
+	page = radix_tree_lookup(&btnc->page_tree, index);
+	if (page)
+		page_cache_get(page);
+	BUG_ON(page && !page_has_buffers(page));
+	nilfs_btnode_read_unlock(btnc);
+	return page;
+}
+
+static inline struct page *
+nilfs_btnode_alloc_page(struct nilfs_btnode_cache *btnc)
+{
+	struct inode *inode = BTNC_I(btnc);
+	return nilfs_alloc_buffer_page(NILFS_I_NILFS(inode)->ns_bdev,
+				       1UL << inode->i_blkbits,
+				       1UL << BH_NILFS_Node);
+}
+
+static int
+nilfs_btnode_page_add_cache(struct page *page, struct nilfs_btnode_cache *btnc,
+			    unsigned long index)
+{
+	int err;
+
+	err = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (unlikely(err))
+		return err;
+	nilfs_btnode_write_lock(btnc);
+	err = radix_tree_insert(&btnc->page_tree, index, page);
+	if (likely(!err)) {
+		page_cache_get(page);	/* for radix-tree */
+		page->index = index;
+		page->mapping = BTNC_I(btnc)->i_mapping;
+	}
+	nilfs_btnode_write_unlock(btnc);
+	radix_tree_preload_end();
+	return err;
+}
+
+static struct nilfs_btnode_cache *
+nilfs_btnode_altbc(struct nilfs_btnode_cache *btnc)
+{
+	struct inode *orig_inode = NILFS_ORIG_I(BTNC_I(btnc));
+
+	return orig_inode ? &NILFS_I(orig_inode)->i_btnode_cache : NULL;
+}
+
+/* some codes borrowed from mm/filemap.c::read_cache_page() */
+static int nilfs_btnode_get_page(struct nilfs_btnode_cache *btnc,
+				 unsigned long index,
+				 struct page **res, int try_altbc)
+{
+	struct page *page, *cached_page = NULL;
+	struct nilfs_btnode_cache *altbc;
+	int err = 0;
+
+repeat:
+	page = nilfs_btnode_find_get_page(btnc, index);
+	if (!page) {
+		if (!cached_page) {
+			cached_page = nilfs_btnode_alloc_page(btnc);
+			if (unlikely(!cached_page))
+				return -ENOMEM;
+		}
+		err = nilfs_btnode_page_add_cache(cached_page, btnc, index);
+		if (unlikely(err)) {
+			if (err == -EEXIST)
+				goto repeat;
+			goto out_free;
+		}
+		page = cached_page;
+		cached_page = NULL;
+		nilfs_page_add_to_lru(page, 0);
+
+		if (try_altbc) {
+			altbc = nilfs_btnode_altbc(btnc);
+			if (altbc != NULL) {
+				struct page *opage =
+					nilfs_btnode_find_get_page(altbc,
+								   index);
+				if (opage) {
+					lock_page(opage);
+					/* Dirty page does not appear here */
+					BUG_ON(PageDirty(opage));
+					nilfs_copy_buffer_page(opage, page, 0);
+					unlock_page(opage);
+					page_cache_release(opage);
+				}
+			}
+		}
+		/* pass page_count from btnode_alloc_page to caller */
+		unlock_page(page);
+	}
+out_free:
+	/*
+	 * maybe -ENOMEM occured at radix_tree_insert() if cached_page remains.
+	 * it is not in the inactive list in this case.
+	 */
+	if (cached_page)
+		nilfs_free_buffer_page(cached_page);
+
+	if (likely(page)) {
+		nilfs_page_mark_accessed(page);
+		*res = page;
+		err = 0;
+		if (unlikely(!nilfs_btnode_page_referenced(page, 0)))
+			NILFS_PAGE_BUG(page, "page not referred");
+	}
+	return err;
+}
+
+/* page must be locked by caller */
+int __nilfs_btnode_get(struct nilfs_btnode_cache *btnc, __u64 blocknr,
+		       sector_t pblocknr, struct buffer_head **result,
+		       int newblk)
+{
+	struct page *page = NULL;
+	struct buffer_head *bh = NULL;
+	struct inode *inode = BTNC_I(btnc);
+	int err;
+
+	err = nilfs_btnode_get_page(btnc, B2P(blocknr, inode), &page, 1);
+	if (unlikely(err))
+		goto out_nopage;
+
+	lock_page(page);
+
+	bh = nilfs_page_get_nth_block(page, B2O(blocknr, inode));
+
+	if (newblk) {
+		if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
+			     buffer_dirty(bh))) {
+			brelse(bh);
+			BUG();
+		}
+		bh->b_blocknr = blocknr;
+		set_buffer_mapped(bh);
+		set_buffer_uptodate(bh);
+		goto found;
+	}
+
+	if (buffer_uptodate(bh) || buffer_dirty(bh))
+		goto found;
+
+	if (pblocknr == 0) {
+		pblocknr = blocknr;
+		if (inode->i_ino != NILFS_DAT_INO) {
+			struct inode *dat =
+				nilfs_dat_inode(NILFS_I_NILFS(inode));
+
+			/* blocknr is a Virtual BN */
+			err = nilfs_dat_translate(dat, blocknr, &pblocknr);
+			if (unlikely(err)) {
+				brelse(bh);
+				goto out_locked;
+			}
+		}
+	}
+	bh->b_blocknr = pblocknr; /* set block address for read */
+	set_buffer_mapped(bh);
+
+	lock_buffer(bh);
+	err = bh_submit_read(bh);
+	if (unlikely(err)) {
+		brelse(bh);
+		goto out_locked;
+	}
+	bh->b_blocknr = blocknr; /* set back to the given block address */
+found:
+	*result = bh;
+	err = 0;
+out_locked:
+	unlock_page(page);
+	page_cache_release(page);	/* from nilfs_btnode_get_page() */
+out_nopage:
+	return err;
+}
+
+static void __nilfs_btnode_set_page_dirty(struct nilfs_btnode_cache *btnc,
+					  struct page *page)
+
+{
+	if (TestSetPageDirty(page))
+		return;
+	nilfs_btnode_write_lock(btnc);
+	radix_tree_tag_set(&btnc->page_tree, page->index, PAGECACHE_TAG_DIRTY);
+	nilfs_btnode_write_unlock(btnc);
+}
+
+void nilfs_btnode_set_page_dirty(struct page *page)
+
+{
+	__nilfs_btnode_set_page_dirty(PAGE_BTNC(page), page);
+}
+
+/**
+ * nilfs_btnode_mark_dirty() - mark buffer dirty and set page state
+ * @bh: buffer head
+ *
+ * The caller must check state of buffer head @bh previously.
+ */
+void nilfs_btnode_mark_dirty(struct buffer_head *bh)
+{
+	struct page *page = bh->b_page;
+
+	lock_page(page);
+	if (!test_set_buffer_dirty(bh))
+		nilfs_btnode_set_page_dirty(page);
+	unlock_page(page);
+}
+
+/**
+ * nilfs_btnode_page_clear_dirty - clear page dirty state
+ * @page: page to be cleared
+ */
+void nilfs_btnode_page_clear_dirty(struct page *page)
+{
+	struct nilfs_btnode_cache *btnc;
+
+	if (!page->mapping) {
+		ClearPageDirty(page);
+		return;
+	}
+	btnc = PAGE_BTNC(page);
+	nilfs_btnode_write_lock(btnc);
+	if (TestClearPageDirty(page))
+		/* may be called twice for the same page with DIRTY bit */
+		radix_tree_tag_clear(&btnc->page_tree, page_index(page),
+				     PAGECACHE_TAG_DIRTY);
+	nilfs_btnode_write_unlock(btnc);
+}
+
+/**
+ * nilfs_btnode_invalidate_page - invalidate a page and remove it from cache
+ * @page: page to be removed from cache
+ * @force: force flag
+ *
+ * The caller must lock @page and must hold the reference count.
+ */
+int nilfs_btnode_invalidate_page(struct page *page, int force)
+{
+	struct nilfs_btnode_cache *btnc = PAGE_BTNC(page);
+	struct buffer_head *head, *bh;
+	struct page *page2;
+	int busy = 0;
+
+	nilfs_btnode_write_lock(btnc);
+	/* check refs in critical section, page count 1 for caller */
+	if (nilfs_btnode_page_referenced(page, 1) ||
+	    nilfs_page_buffers_busy(page)) {
+		busy++;
+		if (!force)
+			goto out_locked;
+	}
+
+	/* Ths following cleanup is omissible if no one will see buffers
+	   on the invalidated page */
+	head = bh = page_buffers(page);
+	do {
+		bh->b_state = (1 << BH_NILFS_Allocated);
+		if (unlikely(!list_empty(&bh->b_assoc_buffers)))
+			list_del_init(&bh->b_assoc_buffers);
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	/* remove page and associated tags from cache */
+	page2 = radix_tree_delete(&btnc->page_tree, page->index);
+	if (unlikely(page != page2))
+		NILFS_PAGE_BUG(page, "radix_tree_delete failed (page2=%p)",
+			       page2);
+
+	page->mapping = NULL;
+	page->index = 0;
+	page_cache_release(page);	/* ref for radix-tree */
+
+out_locked:
+	nilfs_btnode_write_unlock(btnc);
+	return busy;
+}
+
+/**
+ * nilfs_btnode_delete_page - remove a page from cache and free it
+ * @page: page to be deleted
+ * @force: force flag
+ *
+ * nilfs_btnode_delete_page() removes @page from btnode cache.
+ * If the page is used by someone and @force is zero, the removal is not
+ * performed. If @force is not zero, the page is always removed.
+ * For both cases, the value whether the page is busy or not is returned.
+ * If the page was not busy or @force is not zero, it is removed from lru,
+ * and is freed with its buffers.
+ * The caller must lock @page and must hold a refcnt.
+ * The caller must not refer to the page when removing forcibly or
+ * after this function returned zero.
+ */
+static int nilfs_btnode_delete_page(struct page *page, int force)
+{
+	int busy = nilfs_btnode_invalidate_page(page, force);
+	/* The shrinker may be using the page because it gets pages before
+	   locking them. */
+	if (!busy | force) {
+		nilfs_page_delete_from_lru(page);
+		    /* If page is not in any LRU list, it is a BUG. */
+		nilfs_free_buffer_page(page);
+		    /* nilfs_btnode_invalidate_page performs busy check
+		       for buffers;  if this call failed it's a BUG */
+	}
+	return busy;
+}
+
+/**
+ * nilfs_btnode_delete_bh - invalidate a buffer entry from a page
+ * @bh: pointer of a btnode buffer
+ *
+ * The caller must lock the page.
+ */
+static void nilfs_btnode_delete_bh(struct buffer_head *bh)
+{
+	struct page *page = bh->b_page;
+
+	clear_buffer_dirty(bh);
+	clear_buffer_nilfs_volatile(bh);
+	if (nilfs_page_buffers_clean(page))
+		nilfs_btnode_page_clear_dirty(page);
+	clear_buffer_uptodate(bh);
+	clear_buffer_mapped(bh);
+	bh->b_blocknr = 0;
+	brelse(bh);	/* hold by caller */
+}
+
+/**
+ * nilfs_btnode_delete - delete btnode buffer
+ * @bh: buffer to be deleted
+ *
+ * nilfs_btnode_delete() invalidates the specified buffer and delete the page
+ * including the buffer if the page gets unbusy.
+ */
+void nilfs_btnode_delete(struct buffer_head *bh)
+{
+	struct page *page = bh->b_page;
+	struct buffer_head *b;
+
+	page_cache_get(page);	/* for dealloc */
+	lock_page(page);
+	if (unlikely(!nilfs_doing_construction() && PageWriteback(page)))
+		NILFS_PAGE_BUG(page, "page is on writeback");
+
+	nilfs_btnode_delete_bh(bh);	/* bh ref freed */
+
+	b = bh;
+	do {
+		if (nilfs_buffer_busy(b) || buffer_mapped(b))
+			goto out_unlock; /* valid bh remains in page */
+		b = b->b_this_page;
+	} while (b != bh);
+	if (!nilfs_btnode_delete_page(page, 0))
+		return; /* successfully freed */
+	/* if someone looking, shrinker will remove later. */
+out_unlock:
+	unlock_page(page);
+	page_cache_release(page);
+}
+
+/**
+ * nilfs_btnode_prepare_change_key
+ *  prepare to move contents of the block for old key to one of new key.
+ *  the old buffer will not be removed, but might be reused for new buffer.
+ *  it might return -ENOMEM because of memory allocation errors,
+ *  and might return -EIO because of disk read errors.
+ */
+int nilfs_btnode_prepare_change_key(struct nilfs_btnode_cache *btnc,
+				    struct nilfs_btnode_chkey_ctxt *ctxt)
+{
+	int err;
+	struct buffer_head *obh, *nbh;
+	struct inode *inode = BTNC_I(btnc);
+	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
+
+	if (oldkey == newkey)
+		return 0;
+
+	obh = ctxt->bh;
+	if (inode->i_blkbits == PAGE_CACHE_SHIFT) {
+		err = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+		if (err)
+			goto out;
+
+		/* BUG_ON(oldkey != obh->b_page->index); */
+		if (unlikely(oldkey != obh->b_page->index))
+			NILFS_PAGE_BUG(obh->b_page,
+				       "invalid oldkey %lld (newkey=%lld)",
+				       (unsigned long long)oldkey,
+				       (unsigned long long)newkey);
+
+ retry:
+		nilfs_btnode_write_lock(btnc);
+		err = radix_tree_insert(&btnc->page_tree, newkey, obh->b_page);
+		nilfs_btnode_write_unlock(btnc);
+		/*
+		 * Note: page->index will not change to newkey until
+		 * nilfs_btnode_commit_change_key() will be called.
+		 * When using page->index (or page_index(page)), we need care
+		 * for independent tasks like the shrinker.  At present,
+		 * it doesn't matter because the shrinker sees page->index
+		 * only when no one refer to the page.
+		 */
+		radix_tree_preload_end();
+		if (likely(!err))
+			ctxt->newbh = NULL;
+		else if (err == -EEXIST) {
+			struct page *page;
+
+			BUG_ON(inode->i_ino != NILFS_DAT_INO);
+			page = nilfs_btnode_find_get_page(btnc, newkey);
+			if (page) {
+				nilfs_pages_disable_shrinker();
+				/* needed to avoid the possibility that
+				   the shrinker disturbs busy check and drives
+				   nilfs_btnode_delete_page() into failure */
+				lock_page(page);
+				if (nilfs_btnode_delete_page(page, 0))
+					NILFS_PAGE_BUG(
+						page, "busy page for key %lld",
+						(unsigned long long)newkey);
+
+				nilfs_pages_enable_shrinker();
+			}
+			goto retry;
+		} /* Other errors (eg -ENOMEM) are just returned */
+	} else {
+		err = nilfs_btnode_get_new(btnc, newkey, &nbh);
+		if (unlikely(err)) /* -ENOMEM or -EIO */
+			goto out;
+
+		BUG_ON(nbh == obh);
+		ctxt->newbh = nbh;
+	}
+out:
+	return err;
+}
+
+/**
+ * nilfs_btnode_commit_change_key
+ *  commit the change_key operation prepared by prepare_change_key().
+ */
+void nilfs_btnode_commit_change_key(struct nilfs_btnode_cache *btnc,
+				    struct nilfs_btnode_chkey_ctxt *ctxt)
+{
+	struct buffer_head *obh, *nbh;
+	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
+	struct page *opage;
+
+	if (oldkey == newkey)
+		return;
+
+	obh = ctxt->bh;
+	nbh = ctxt->newbh;
+	if (nbh == NULL) {	/* blocksize == pagesize */
+		opage = obh->b_page;
+		/* BUG_ON(oldkey != opage->index); */
+		if (unlikely(oldkey != opage->index))
+			NILFS_PAGE_BUG(opage,
+				       "invalid oldkey %lld (newkey=%lld)",
+				       (unsigned long long)oldkey,
+				       (unsigned long long)newkey);
+
+		lock_page(opage);
+		if (!test_set_buffer_dirty(obh) && TestSetPageDirty(opage))
+			BUG();
+		nilfs_btnode_write_lock(btnc);
+		radix_tree_delete(&btnc->page_tree, oldkey);
+		radix_tree_tag_set(&btnc->page_tree, newkey,
+				   PAGECACHE_TAG_DIRTY);
+		nilfs_btnode_write_unlock(btnc);
+		unlock_page(opage);
+		opage->index = obh->b_blocknr = newkey;
+	} else {
+		memcpy(nbh->b_data, obh->b_data, obh->b_size);
+		nilfs_copy_buffer_state(nbh, obh, NILFS_BUFFER_INHERENT_BITS);
+		/*
+		 * This copy of buffer state doesn't use atomic operations and
+		 * needs care;  the page having nbh has already been added
+		 * to an active or inactive list, and NILFS shrinker may refer
+		 * to the state.  However, it's barely safe because the
+		 * shrinker checks a reference counter of the buffer
+		 * together with the state.
+		 */
+		nilfs_btnode_mark_dirty(nbh);
+
+		nbh->b_blocknr = newkey;
+		ctxt->bh = nbh;
+		nilfs_btnode_delete(obh); /* will decrement bh->b_count */
+	}
+}
+
+/**
+ * nilfs_btnode_abort_change_key
+ *  abort the change_key operation prepared by prepare_change_key().
+ */
+void nilfs_btnode_abort_change_key(struct nilfs_btnode_cache *btnc,
+				   struct nilfs_btnode_chkey_ctxt *ctxt)
+{
+	struct buffer_head *nbh;
+	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
+
+	if (oldkey == newkey)
+		return;
+
+	nbh = ctxt->newbh;
+	if (nbh == NULL) {	/* blocksize == pagesize */
+		nilfs_btnode_write_lock(btnc);
+		radix_tree_delete(&btnc->page_tree, newkey);
+		nilfs_btnode_write_unlock(btnc);
+	} else
+		brelse(nbh);
+		/* should be reclaimed by shrinker, or reuse by others */
+}
+
+void nilfs_btnode_clear_dirty_pages(struct nilfs_btnode_cache *btnc)
+{
+	struct page *pages[NILFS_BTNODE_GANG_SIZE], *page;
+	pgoff_t offset;
+	pgoff_t index = 0;
+	unsigned int i, n;
+	int ncleaned = 0, ndeleted = 0;
+	struct buffer_head *bh, *head;
+
+ repeat:
+	n = nilfs_btnode_find_get_pages_tag(btnc, pages, &index,
+					    NILFS_BTNODE_GANG_SIZE,
+					    PAGECACHE_TAG_DIRTY);
+	if (!n)
+		return;
+
+	for (i = 0; i < n; i++) {
+		page = pages[i];
+		lock_page(page);
+		offset = page_index(page);
+		BUG_ON(PageWriteback(page));
+
+		bh = head = page_buffers(page);
+		do {
+			/* invalidate buffer */
+			bh->b_state = NILFS_BTNODE_CLEAN_BH_STATE;
+			bh = bh->b_this_page;
+		} while (bh != head);
+
+		nilfs_btnode_write_lock(btnc);
+		if (TestClearPageDirty(page))
+			radix_tree_tag_clear(&btnc->page_tree, offset,
+					     PAGECACHE_TAG_DIRTY);
+		nilfs_btnode_write_unlock(btnc);
+
+		ncleaned++;
+		if (nilfs_btnode_invalidate_page(page, 0))
+			ndeleted++;
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	goto repeat;
+}
+
+int nilfs_btnode_copy_dirty_pages(struct nilfs_btnode_cache *src,
+				  struct nilfs_btnode_cache *dst)
+{
+	struct page *pages[NILFS_BTNODE_GANG_SIZE];
+	pgoff_t index = 0;
+	unsigned int i, n;
+	int err;
+
+repeat:
+	n = nilfs_btnode_find_get_pages_tag(src, pages, &index,
+					    NILFS_BTNODE_GANG_SIZE,
+					    PAGECACHE_TAG_DIRTY);
+	if (!n)
+		return 0;
+
+	for (i = 0; i < n; i++) {
+		struct page *page = pages[i], *dpage;
+
+		lock_page(page);
+		/* do not search original dat cache */
+		err = nilfs_btnode_get_page(dst, page->index, &dpage, 0);
+		if (unlikely(err)) {
+			unlock_page(page);
+			goto failed;
+		}
+		lock_page(dpage);
+
+		if (PageDirty(page))
+			__nilfs_btnode_set_page_dirty(dst, dpage);
+		nilfs_copy_buffer_page(page, dpage, 1);
+
+		unlock_page(dpage);
+		page_cache_release(dpage);
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	goto repeat;
+ failed:
+	while (i < n)
+		page_cache_release(pages[i++]);
+	return err;
+}
+
+void nilfs_btnode_copy_cache(struct nilfs_btnode_cache *src,
+			     struct nilfs_btnode_cache *dst)
+{
+	struct page *pages[NILFS_BTNODE_GANG_SIZE];
+	unsigned int i, n;
+	pgoff_t index = 0;
+
+repeat:
+	n = nilfs_btnode_find_get_pages(src, pages, &index,
+					NILFS_BTNODE_GANG_SIZE);
+	if (!n)
+		return;
+	/* note: mdt dirty flags should be cleared by segctor. */
+	for (i = 0; i < n; i++) {
+		struct page *page = pages[i], *dpage;
+		pgoff_t offset = page->index;
+
+		lock_page(page);
+		dpage = nilfs_btnode_find_get_page(dst, offset);
+		if (dpage) {
+			/* override existing page on the destination cache */
+			/* XXX skip if identical */
+			lock_page(dpage);
+			/* dirty or pdirty pages do not appear in src cache */
+			BUG_ON(PageDirty(dpage));
+			nilfs_copy_buffer_page(page, dpage, 0);
+			unlock_page(dpage);
+			page_cache_release(dpage);
+		} else {
+			struct page *page2;
+
+			/* move the page to the destination cache */
+			nilfs_btnode_write_lock(src);
+			page2 = radix_tree_delete(&src->page_tree, offset);
+			if (unlikely(page2 != page))
+				NILFS_PAGE_BUG(page, "page removal failed "
+					       "(offset=%lu, page2=%p)",
+					       offset, page2);
+
+			page->mapping = NULL;
+			page_cache_release(page);
+			nilfs_btnode_write_unlock(src);
+
+			nilfs_btnode_page_add_cache(page, dst, offset);
+		}
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	goto repeat;
+}
+
+void nilfs_btnode_cache_clear(struct nilfs_btnode_cache *btnc)
+{
+	struct page *pages[NILFS_BTNODE_GANG_SIZE], *page;
+	pgoff_t index = 0;
+	unsigned int i, n;
+
+ repeat:
+	n = nilfs_btnode_find_get_pages(btnc, pages, &index,
+					NILFS_BTNODE_GANG_SIZE);
+	if (!n)
+		return;
+
+	nilfs_pages_disable_shrinker(); /* needed to avoid possible refcount
+					   errors on the shrinker */
+	for (i = 0; i < n; i++) {
+		page = pages[i];
+		lock_page(page);
+		if (unlikely(!nilfs_doing_construction() &&
+			     PageWriteback(page)))
+			NILFS_PAGE_BUG(page, "page is on writeback");
+
+		nilfs_btnode_delete_page(page, 1);
+	}
+	nilfs_pages_enable_shrinker();
+	goto repeat;
+}
diff -puN /dev/null fs/nilfs2/btnode.h
--- /dev/null
+++ a/fs/nilfs2/btnode.h
@@ -0,0 +1,114 @@
+/*
+ * btnode.h - NILFS BT-Node prototypes and definitions
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Seiji Kihara <kihara@osrg.net>
+ */
+
+#ifndef _NILFS_BTNODE_H
+#define _NILFS_BTNODE_H
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/spinlock.h>
+#include <linux/radix-tree.h>
+
+struct nilfs_btnode_cache {
+	struct radix_tree_root page_tree;
+	rwlock_t tree_lock;
+};
+
+struct nilfs_btnode_chkey_ctxt {
+	__u64 oldkey;
+	__u64 newkey;
+	struct buffer_head *bh;
+	struct buffer_head *newbh;
+};
+
+static inline void
+nilfs_btnode_cache_init_once(struct nilfs_btnode_cache *btnc)
+{
+	INIT_RADIX_TREE(&btnc->page_tree, GFP_ATOMIC);
+	rwlock_init(&btnc->tree_lock);
+}
+
+void nilfs_btnode_cache_clear(struct nilfs_btnode_cache *);
+
+int __nilfs_btnode_get(struct nilfs_btnode_cache *, __u64, sector_t,
+		       struct buffer_head **, int);
+void nilfs_btnode_delete(struct buffer_head *);
+
+#define nilfs_btnode_get(btnc, bn, res)	\
+	__nilfs_btnode_get(btnc, bn, 0, res, 0 /* exist */)
+#define nilfs_btnode_get_new(btnc, bn, res) \
+	__nilfs_btnode_get(btnc, bn, 0, res, 1 /* new */)
+#define nilfs_btnode_get_pb(btnc, bn, pbn, res)	\
+	__nilfs_btnode_get(btnc, bn, pbn, res, 0 /* exist */)
+
+#define nilfs_btnode_read_lock(btnc)	read_lock(&(btnc)->tree_lock)
+#define nilfs_btnode_read_unlock(btnc)	read_unlock(&(btnc)->tree_lock)
+#define nilfs_btnode_write_lock(btnc)	write_lock(&(btnc)->tree_lock)
+#define nilfs_btnode_write_unlock(btnc)	write_unlock(&(btnc)->tree_lock)
+
+static inline int nilfs_btnode_page_referenced(struct page *p, int ref)
+{
+	return page_count(p) - ref >
+		!!p->mapping + page_has_buffers(p) + !list_empty(&p->lru);
+}
+
+static inline unsigned
+nilfs_btnode_gang_lookup_nolock(struct nilfs_btnode_cache *btnc,
+				struct page **pages, unsigned long index,
+				int size)
+{
+	return radix_tree_gang_lookup(&btnc->page_tree, (void **)pages, index,
+				      size);
+}
+
+static inline unsigned
+nilfs_btnode_gang_lookup_tag_nolock(struct nilfs_btnode_cache *btnc,
+				    struct page **pages, unsigned long index,
+				    int size, int tag)
+{
+	return radix_tree_gang_lookup_tag(&btnc->page_tree, (void **)pages,
+					  index, size, tag);
+}
+
+unsigned nilfs_btnode_find_get_pages(struct nilfs_btnode_cache *,
+				     struct page **, pgoff_t *, unsigned int);
+unsigned nilfs_btnode_find_get_pages_tag(struct nilfs_btnode_cache *,
+					 struct page **, pgoff_t *,
+					 unsigned int, int);
+void nilfs_btnode_mark_dirty(struct buffer_head *);
+void nilfs_btnode_set_page_dirty(struct page *);
+void nilfs_btnode_page_clear_dirty(struct page *);
+int nilfs_btnode_invalidate_page(struct page *, int);
+int nilfs_btnode_prepare_change_key(struct nilfs_btnode_cache *,
+				    struct nilfs_btnode_chkey_ctxt *);
+void nilfs_btnode_commit_change_key(struct nilfs_btnode_cache *,
+				    struct nilfs_btnode_chkey_ctxt *);
+void nilfs_btnode_abort_change_key(struct nilfs_btnode_cache *,
+				   struct nilfs_btnode_chkey_ctxt *);
+int nilfs_btnode_copy_dirty_pages(struct nilfs_btnode_cache *,
+				  struct nilfs_btnode_cache *);
+void nilfs_btnode_clear_dirty_pages(struct nilfs_btnode_cache *);
+void nilfs_btnode_copy_cache(struct nilfs_btnode_cache *,
+			     struct nilfs_btnode_cache *);
+
+#endif	/* _NILFS_BTNODE_H */
diff -puN /dev/null fs/nilfs2/btree.c
--- /dev/null
+++ a/fs/nilfs2/btree.c
@@ -0,0 +1,2283 @@
+/*
+ * btree.c - NILFS B-tree.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include "nilfs.h"
+#include "btnode.h"
+#include "btree.h"
+
+
+/*
+ * B-tree path operations
+ */
+
+static struct kmem_cache *nilfs_btree_path_cache;
+
+int __init nilfs_btree_path_cache_init(void)
+{
+	nilfs_btree_path_cache =
+		kmem_cache_create("nilfs2_btree_path_cache",
+				  sizeof(struct nilfs_btree_path) *
+				  NILFS_BTREE_LEVEL_MAX, 0, 0, NULL);
+	return (nilfs_btree_path_cache != NULL) ? 0 : -ENOMEM;
+}
+
+void nilfs_btree_path_cache_destroy(void)
+{
+	kmem_cache_destroy(nilfs_btree_path_cache);
+}
+
+static inline struct nilfs_btree_path *
+nilfs_btree_alloc_path(const struct nilfs_btree *btree)
+{
+	return (struct nilfs_btree_path *)
+		kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
+}
+
+static inline void nilfs_btree_free_path(const struct nilfs_btree *btree,
+					 struct nilfs_btree_path *path)
+{
+	kmem_cache_free(nilfs_btree_path_cache, path);
+}
+
+static void nilfs_btree_init_path(const struct nilfs_btree *btree,
+				  struct nilfs_btree_path *path)
+{
+	int level;
+
+	for (level = NILFS_BTREE_LEVEL_DATA;
+	     level < NILFS_BTREE_LEVEL_MAX;
+	     level++) {
+		path[level].bp_bh = NULL;
+		path[level].bp_sib_bh = NULL;
+		path[level].bp_index = 0;
+		path[level].bp_oldreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
+		path[level].bp_newreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
+		path[level].bp_op = NULL;
+	}
+}
+
+static void nilfs_btree_clear_path(const struct nilfs_btree *btree,
+				   struct nilfs_btree_path *path)
+{
+	int level;
+
+	for (level = NILFS_BTREE_LEVEL_DATA;
+	     level < NILFS_BTREE_LEVEL_MAX;
+	     level++) {
+		if (path[level].bp_bh != NULL) {
+			nilfs_bmap_put_block(&btree->bt_bmap,
+					     path[level].bp_bh);
+			path[level].bp_bh = NULL;
+		}
+		/* sib_bh is released or deleted by prepare or commit
+		 * operations. */
+		path[level].bp_sib_bh = NULL;
+		path[level].bp_index = 0;
+		path[level].bp_oldreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
+		path[level].bp_newreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
+		path[level].bp_op = NULL;
+	}
+}
+
+
+/*
+ * B-tree node operations
+ */
+
+static inline int
+nilfs_btree_node_get_flags(const struct nilfs_btree *btree,
+			   const struct nilfs_btree_node *node)
+{
+	return node->bn_flags;
+}
+
+static inline void
+nilfs_btree_node_set_flags(struct nilfs_btree *btree,
+			   struct nilfs_btree_node *node,
+			   int flags)
+{
+	node->bn_flags = flags;
+}
+
+static inline int nilfs_btree_node_root(const struct nilfs_btree *btree,
+					const struct nilfs_btree_node *node)
+{
+	return nilfs_btree_node_get_flags(btree, node) & NILFS_BTREE_NODE_ROOT;
+}
+
+static inline int
+nilfs_btree_node_get_level(const struct nilfs_btree *btree,
+			   const struct nilfs_btree_node *node)
+{
+	return node->bn_level;
+}
+
+static inline void
+nilfs_btree_node_set_level(struct nilfs_btree *btree,
+			   struct nilfs_btree_node *node,
+			   int level)
+{
+	node->bn_level = level;
+}
+
+static inline int
+nilfs_btree_node_get_nchildren(const struct nilfs_btree *btree,
+			       const struct nilfs_btree_node *node)
+{
+	return le16_to_cpu(node->bn_nchildren);
+}
+
+static inline void
+nilfs_btree_node_set_nchildren(struct nilfs_btree *btree,
+			       struct nilfs_btree_node *node,
+			       int nchildren)
+{
+	node->bn_nchildren = cpu_to_le16(nchildren);
+}
+
+static inline int
+nilfs_btree_node_size(const struct nilfs_btree *btree)
+{
+	return 1 << btree->bt_bmap.b_inode->i_blkbits;
+}
+
+static inline int
+nilfs_btree_node_nchildren_min(const struct nilfs_btree *btree,
+			       const struct nilfs_btree_node *node)
+{
+	return nilfs_btree_node_root(btree, node) ?
+		NILFS_BTREE_ROOT_NCHILDREN_MIN :
+		NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
+}
+
+static inline int
+nilfs_btree_node_nchildren_max(const struct nilfs_btree *btree,
+			       const struct nilfs_btree_node *node)
+{
+	return nilfs_btree_node_root(btree, node) ?
+		NILFS_BTREE_ROOT_NCHILDREN_MAX :
+		NILFS_BTREE_NODE_NCHILDREN_MAX(nilfs_btree_node_size(btree));
+}
+
+static inline __le64 *
+nilfs_btree_node_dkeys(const struct nilfs_btree *btree,
+		       const struct nilfs_btree_node *node)
+{
+	return (__le64 *)((char *)(node + 1) +
+			  (nilfs_btree_node_root(btree, node) ?
+			   0 : NILFS_BTREE_NODE_EXTRA_PAD_SIZE));
+}
+
+static inline __le64 *
+nilfs_btree_node_dptrs(const struct nilfs_btree *btree,
+		       const struct nilfs_btree_node *node)
+{
+	return (__le64 *)(nilfs_btree_node_dkeys(btree, node) +
+			  nilfs_btree_node_nchildren_max(btree, node));
+}
+
+static inline __u64
+nilfs_btree_node_get_key(const struct nilfs_btree *btree,
+			 const struct nilfs_btree_node *node, int index)
+{
+	return nilfs_bmap_dkey_to_key(*(nilfs_btree_node_dkeys(btree, node) +
+					index));
+}
+
+static inline void
+nilfs_btree_node_set_key(struct nilfs_btree *btree,
+			 struct nilfs_btree_node *node, int index, __u64 key)
+{
+	*(nilfs_btree_node_dkeys(btree, node) + index) =
+		nilfs_bmap_key_to_dkey(key);
+}
+
+static inline __u64
+nilfs_btree_node_get_ptr(const struct nilfs_btree *btree,
+			 const struct nilfs_btree_node *node,
+			 int index)
+{
+	return nilfs_bmap_dptr_to_ptr(*(nilfs_btree_node_dptrs(btree, node) +
+					index));
+}
+
+static inline void
+nilfs_btree_node_set_ptr(struct nilfs_btree *btree,
+			 struct nilfs_btree_node *node,
+			 int index,
+			 __u64 ptr)
+{
+	*(nilfs_btree_node_dptrs(btree, node) + index) =
+		nilfs_bmap_ptr_to_dptr(ptr);
+}
+
+static void nilfs_btree_node_init(struct nilfs_btree *btree,
+				  struct nilfs_btree_node *node,
+				  int flags, int level, int nchildren,
+				  const __u64 *keys, const __u64 *ptrs)
+{
+	__le64 *dkeys;
+	__le64 *dptrs;
+	int i;
+
+	nilfs_btree_node_set_flags(btree, node, flags);
+	nilfs_btree_node_set_level(btree, node, level);
+	nilfs_btree_node_set_nchildren(btree, node, nchildren);
+
+	dkeys = nilfs_btree_node_dkeys(btree, node);
+	dptrs = nilfs_btree_node_dptrs(btree, node);
+	for (i = 0; i < nchildren; i++) {
+		dkeys[i] = nilfs_bmap_key_to_dkey(keys[i]);
+		dptrs[i] = nilfs_bmap_ptr_to_dptr(ptrs[i]);
+	}
+}
+
+/* Assume the buffer heads corresponding to left and right are locked. */
+static void nilfs_btree_node_move_left(struct nilfs_btree *btree,
+				       struct nilfs_btree_node *left,
+				       struct nilfs_btree_node *right,
+				       int n)
+{
+	__le64 *ldkeys, *rdkeys;
+	__le64 *ldptrs, *rdptrs;
+	int lnchildren, rnchildren;
+
+	ldkeys = nilfs_btree_node_dkeys(btree, left);
+	ldptrs = nilfs_btree_node_dptrs(btree, left);
+	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+
+	rdkeys = nilfs_btree_node_dkeys(btree, right);
+	rdptrs = nilfs_btree_node_dptrs(btree, right);
+	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+
+	memcpy(ldkeys + lnchildren, rdkeys, n * sizeof(*rdkeys));
+	memcpy(ldptrs + lnchildren, rdptrs, n * sizeof(*rdptrs));
+	memmove(rdkeys, rdkeys + n, (rnchildren - n) * sizeof(*rdkeys));
+	memmove(rdptrs, rdptrs + n, (rnchildren - n) * sizeof(*rdptrs));
+
+	lnchildren += n;
+	rnchildren -= n;
+	nilfs_btree_node_set_nchildren(btree, left, lnchildren);
+	nilfs_btree_node_set_nchildren(btree, right, rnchildren);
+}
+
+/* Assume that the buffer heads corresponding to left and right are locked. */
+static void nilfs_btree_node_move_right(struct nilfs_btree *btree,
+					struct nilfs_btree_node *left,
+					struct nilfs_btree_node *right,
+					int n)
+{
+	__le64 *ldkeys, *rdkeys;
+	__le64 *ldptrs, *rdptrs;
+	int lnchildren, rnchildren;
+
+	ldkeys = nilfs_btree_node_dkeys(btree, left);
+	ldptrs = nilfs_btree_node_dptrs(btree, left);
+	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+
+	rdkeys = nilfs_btree_node_dkeys(btree, right);
+	rdptrs = nilfs_btree_node_dptrs(btree, right);
+	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+
+	memmove(rdkeys + n, rdkeys, rnchildren * sizeof(*rdkeys));
+	memmove(rdptrs + n, rdptrs, rnchildren * sizeof(*rdptrs));
+	memcpy(rdkeys, ldkeys + lnchildren - n, n * sizeof(*rdkeys));
+	memcpy(rdptrs, ldptrs + lnchildren - n, n * sizeof(*rdptrs));
+
+	lnchildren -= n;
+	rnchildren += n;
+	nilfs_btree_node_set_nchildren(btree, left, lnchildren);
+	nilfs_btree_node_set_nchildren(btree, right, rnchildren);
+}
+
+/* Assume that the buffer head corresponding to node is locked. */
+static void nilfs_btree_node_insert(struct nilfs_btree *btree,
+				    struct nilfs_btree_node *node,
+				    __u64 key, __u64 ptr, int index)
+{
+	__le64 *dkeys;
+	__le64 *dptrs;
+	int nchildren;
+
+	dkeys = nilfs_btree_node_dkeys(btree, node);
+	dptrs = nilfs_btree_node_dptrs(btree, node);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	if (index < nchildren) {
+		memmove(dkeys + index + 1, dkeys + index,
+			(nchildren - index) * sizeof(*dkeys));
+		memmove(dptrs + index + 1, dptrs + index,
+			(nchildren - index) * sizeof(*dptrs));
+	}
+	dkeys[index] = nilfs_bmap_key_to_dkey(key);
+	dptrs[index] = nilfs_bmap_ptr_to_dptr(ptr);
+	nchildren++;
+	nilfs_btree_node_set_nchildren(btree, node, nchildren);
+}
+
+/* Assume that the buffer head corresponding to node is locked. */
+static void nilfs_btree_node_delete(struct nilfs_btree *btree,
+				    struct nilfs_btree_node *node,
+				    __u64 *keyp, __u64 *ptrp, int index)
+{
+	__u64 key;
+	__u64 ptr;
+	__le64 *dkeys;
+	__le64 *dptrs;
+	int nchildren;
+
+	dkeys = nilfs_btree_node_dkeys(btree, node);
+	dptrs = nilfs_btree_node_dptrs(btree, node);
+	key = nilfs_bmap_dkey_to_key(dkeys[index]);
+	ptr = nilfs_bmap_dptr_to_ptr(dptrs[index]);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	if (keyp != NULL)
+		*keyp = key;
+	if (ptrp != NULL)
+		*ptrp = ptr;
+
+	if (index < nchildren - 1) {
+		memmove(dkeys + index, dkeys + index + 1,
+			(nchildren - index - 1) * sizeof(*dkeys));
+		memmove(dptrs + index, dptrs + index + 1,
+			(nchildren - index - 1) * sizeof(*dptrs));
+	}
+	nchildren--;
+	nilfs_btree_node_set_nchildren(btree, node, nchildren);
+}
+
+static int nilfs_btree_node_lookup(const struct nilfs_btree *btree,
+				   const struct nilfs_btree_node *node,
+				   __u64 key, int *indexp)
+{
+	__u64 nkey;
+	int index, low, high, s;
+
+	/* binary search */
+	low = 0;
+	high = nilfs_btree_node_get_nchildren(btree, node) - 1;
+	index = 0;
+	s = 0;
+	while (low <= high) {
+		index = (low + high) / 2;
+		nkey = nilfs_btree_node_get_key(btree, node, index);
+		if (nkey == key) {
+			s = 0;
+			goto out;
+		} else if (nkey < key) {
+			low = index + 1;
+			s = -1;
+		} else {
+			high = index - 1;
+			s = 1;
+		}
+	}
+
+	/* adjust index */
+	if (nilfs_btree_node_get_level(btree, node) >
+	    NILFS_BTREE_LEVEL_NODE_MIN) {
+		if ((s > 0) && (index > 0))
+			index--;
+	} else if (s < 0)
+		index++;
+
+ out:
+	BUG_ON(indexp == NULL);
+	*indexp = index;
+
+	return s == 0;
+}
+
+static inline struct nilfs_btree_node *
+nilfs_btree_get_root(const struct nilfs_btree *btree)
+{
+	return (struct nilfs_btree_node *)btree->bt_bmap.b_u.u_data;
+}
+
+static inline struct nilfs_btree_node *
+nilfs_btree_get_nonroot_node(const struct nilfs_btree *btree,
+			     const struct nilfs_btree_path *path,
+			     int level)
+{
+	return (struct nilfs_btree_node *)path[level].bp_bh->b_data;
+}
+
+static inline struct nilfs_btree_node *
+nilfs_btree_get_sib_node(const struct nilfs_btree *btree,
+			 const struct nilfs_btree_path *path,
+			 int level)
+{
+	return (struct nilfs_btree_node *)path[level].bp_sib_bh->b_data;
+}
+
+static inline int nilfs_btree_height(const struct nilfs_btree *btree)
+{
+	return nilfs_btree_node_get_level(btree, nilfs_btree_get_root(btree))
+		+ 1;
+}
+
+static inline struct nilfs_btree_node *
+nilfs_btree_get_node(const struct nilfs_btree *btree,
+		     const struct nilfs_btree_path *path,
+		     int level)
+{
+	return (level == nilfs_btree_height(btree) - 1) ?
+		nilfs_btree_get_root(btree) :
+		nilfs_btree_get_nonroot_node(btree, path, level);
+}
+
+static int nilfs_btree_do_lookup(const struct nilfs_btree *btree,
+				 struct nilfs_btree_path *path,
+				 __u64 key, __u64 *ptrp, int minlevel)
+{
+	struct nilfs_btree_node *node;
+	__u64 ptr;
+	int level, index, found, ret;
+
+	BUG_ON(minlevel <= NILFS_BTREE_LEVEL_DATA);
+
+	node = nilfs_btree_get_root(btree);
+	level = nilfs_btree_node_get_level(btree, node);
+	if ((level < minlevel) ||
+	    (nilfs_btree_node_get_nchildren(btree, node) <= 0))
+		return -ENOENT;
+
+	found = nilfs_btree_node_lookup(btree, node, key, &index);
+	ptr = nilfs_btree_node_get_ptr(btree, node, index);
+	path[level].bp_bh = NULL;
+	path[level].bp_index = index;
+
+	for (level--; level >= minlevel; level--) {
+		ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr,
+					   &path[level].bp_bh);
+		if (ret < 0)
+			return ret;
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		BUG_ON(level != nilfs_btree_node_get_level(btree, node));
+		if (!found)
+			found = nilfs_btree_node_lookup(btree, node, key,
+							&index);
+		else
+			index = 0;
+		if (index < nilfs_btree_node_nchildren_max(btree, node))
+			ptr = nilfs_btree_node_get_ptr(btree, node, index);
+		else {
+			BUG_ON(found || level != NILFS_BTREE_LEVEL_NODE_MIN);
+			/* insert */
+			ptr = NILFS_BMAP_INVALID_PTR;
+		}
+		path[level].bp_index = index;
+	}
+	if (!found)
+		return -ENOENT;
+
+	if (ptrp != NULL)
+		*ptrp = ptr;
+
+	return 0;
+}
+
+static int nilfs_btree_do_lookup_last(const struct nilfs_btree *btree,
+				      struct nilfs_btree_path *path,
+				      __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node;
+	__u64 ptr;
+	int index, level, ret;
+
+	node = nilfs_btree_get_root(btree);
+	index = nilfs_btree_node_get_nchildren(btree, node) - 1;
+	if (index < 0)
+		return -ENOENT;
+	level = nilfs_btree_node_get_level(btree, node);
+	ptr = nilfs_btree_node_get_ptr(btree, node, index);
+	path[level].bp_bh = NULL;
+	path[level].bp_index = index;
+
+	for (level--; level > 0; level--) {
+		ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr,
+					   &path[level].bp_bh);
+		if (ret < 0)
+			return ret;
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		BUG_ON(level != nilfs_btree_node_get_level(btree, node));
+		index = nilfs_btree_node_get_nchildren(btree, node) - 1;
+		ptr = nilfs_btree_node_get_ptr(btree, node, index);
+		path[level].bp_index = index;
+	}
+
+	if (keyp != NULL)
+		*keyp = nilfs_btree_node_get_key(btree, node, index);
+	if (ptrp != NULL)
+		*ptrp = ptr;
+
+	return 0;
+}
+
+static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
+			      __u64 key, int level, __u64 *ptrp)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	__u64 ptr;
+	int ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+
+	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
+
+	if (ptrp != NULL)
+		*ptrp = ptr;
+
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+
+	return ret;
+}
+
+static void nilfs_btree_promote_key(struct nilfs_btree *btree,
+				    struct nilfs_btree_path *path,
+				    int level, __u64 key)
+{
+	if (level < nilfs_btree_height(btree) - 1) {
+		do {
+			lock_buffer(path[level].bp_bh);
+			nilfs_btree_node_set_key(
+				btree,
+				nilfs_btree_get_nonroot_node(
+					btree, path, level),
+				path[level].bp_index, key);
+			if (!buffer_dirty(path[level].bp_bh))
+				nilfs_btnode_mark_dirty(path[level].bp_bh);
+			unlock_buffer(path[level].bp_bh);
+		} while ((path[level].bp_index == 0) &&
+			 (++level < nilfs_btree_height(btree) - 1));
+	}
+
+	/* root */
+	if (level == nilfs_btree_height(btree) - 1) {
+		nilfs_btree_node_set_key(btree,
+					 nilfs_btree_get_root(btree),
+					 path[level].bp_index, key);
+	}
+}
+
+static void nilfs_btree_do_insert(struct nilfs_btree *btree,
+				  struct nilfs_btree_path *path,
+				  int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node;
+
+	if (level < nilfs_btree_height(btree) - 1) {
+		lock_buffer(path[level].bp_bh);
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
+					path[level].bp_index);
+		if (!buffer_dirty(path[level].bp_bh))
+			nilfs_btnode_mark_dirty(path[level].bp_bh);
+		unlock_buffer(path[level].bp_bh);
+
+		if (path[level].bp_index == 0)
+			nilfs_btree_promote_key(btree, path, level + 1,
+						nilfs_btree_node_get_key(
+							btree, node, 0));
+	} else {
+		node = nilfs_btree_get_root(btree);
+		nilfs_btree_node_insert(btree, node, *keyp, *ptrp,
+					path[level].bp_index);
+	}
+}
+
+static void nilfs_btree_carry_left(struct nilfs_btree *btree,
+				   struct nilfs_btree_path *path,
+				   int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *left;
+	int nchildren, lnchildren, n, move;
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	left = nilfs_btree_get_sib_node(btree, path, level);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+	move = 0;
+
+	n = (nchildren + lnchildren + 1) / 2 - lnchildren;
+	if (n > path[level].bp_index) {
+		/* move insert point */
+		n--;
+		move = 1;
+	}
+
+	nilfs_btree_node_move_left(btree, left, node, n);
+
+	if (!buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	nilfs_btree_promote_key(btree, path, level + 1,
+				nilfs_btree_node_get_key(btree, node, 0));
+
+	if (move) {
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_bh);
+		path[level].bp_bh = path[level].bp_sib_bh;
+		path[level].bp_sib_bh = NULL;
+		path[level].bp_index += lnchildren;
+		path[level + 1].bp_index--;
+	} else {
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		path[level].bp_sib_bh = NULL;
+		path[level].bp_index -= n;
+	}
+
+	nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
+}
+
+static void nilfs_btree_carry_right(struct nilfs_btree *btree,
+				    struct nilfs_btree_path *path,
+				    int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *right;
+	int nchildren, rnchildren, n, move;
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	right = nilfs_btree_get_sib_node(btree, path, level);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+	move = 0;
+
+	n = (nchildren + rnchildren + 1) / 2 - rnchildren;
+	if (n > nchildren - path[level].bp_index) {
+		/* move insert point */
+		n--;
+		move = 1;
+	}
+
+	nilfs_btree_node_move_right(btree, node, right, n);
+
+	if (!buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	path[level + 1].bp_index++;
+	nilfs_btree_promote_key(btree, path, level + 1,
+				nilfs_btree_node_get_key(btree, right, 0));
+	path[level + 1].bp_index--;
+
+	if (move) {
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_bh);
+		path[level].bp_bh = path[level].bp_sib_bh;
+		path[level].bp_sib_bh = NULL;
+		path[level].bp_index -=
+			nilfs_btree_node_get_nchildren(btree, node);
+		path[level + 1].bp_index++;
+	} else {
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		path[level].bp_sib_bh = NULL;
+	}
+
+	nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
+}
+
+static void nilfs_btree_split(struct nilfs_btree *btree,
+			      struct nilfs_btree_path *path,
+			      int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *right;
+	__u64 newkey;
+	__u64 newptr;
+	int nchildren, n, move;
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	right = nilfs_btree_get_sib_node(btree, path, level);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	move = 0;
+
+	n = (nchildren + 1) / 2;
+	if (n > nchildren - path[level].bp_index) {
+		n--;
+		move = 1;
+	}
+
+	nilfs_btree_node_move_right(btree, node, right, n);
+
+	if (!buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	newkey = nilfs_btree_node_get_key(btree, right, 0);
+	newptr = path[level].bp_newreq.bpr_ptr;
+
+	if (move) {
+		path[level].bp_index -=
+			nilfs_btree_node_get_nchildren(btree, node);
+		nilfs_btree_node_insert(btree, right, *keyp, *ptrp,
+					path[level].bp_index);
+
+		*keyp = nilfs_btree_node_get_key(btree, right, 0);
+		*ptrp = path[level].bp_newreq.bpr_ptr;
+
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_bh);
+		path[level].bp_bh = path[level].bp_sib_bh;
+		path[level].bp_sib_bh = NULL;
+	} else {
+		nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
+
+		*keyp = nilfs_btree_node_get_key(btree, right, 0);
+		*ptrp = path[level].bp_newreq.bpr_ptr;
+
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		path[level].bp_sib_bh = NULL;
+	}
+
+	path[level + 1].bp_index++;
+}
+
+static void nilfs_btree_grow(struct nilfs_btree *btree,
+			     struct nilfs_btree_path *path,
+			     int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *root, *child;
+	int n;
+
+	lock_buffer(path[level].bp_sib_bh);
+
+	root = nilfs_btree_get_root(btree);
+	child = nilfs_btree_get_sib_node(btree, path, level);
+
+	n = nilfs_btree_node_get_nchildren(btree, root);
+
+	nilfs_btree_node_move_right(btree, root, child, n);
+	nilfs_btree_node_set_level(btree, root, level + 1);
+
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_sib_bh);
+
+	path[level].bp_bh = path[level].bp_sib_bh;
+	path[level].bp_sib_bh = NULL;
+
+	nilfs_btree_do_insert(btree, path, level, keyp, ptrp);
+
+	*keyp = nilfs_btree_node_get_key(btree, child, 0);
+	*ptrp = path[level].bp_newreq.bpr_ptr;
+}
+
+static __u64 nilfs_btree_find_near(const struct nilfs_btree *btree,
+				   const struct nilfs_btree_path *path)
+{
+	struct nilfs_btree_node *node;
+	int level;
+
+	if (path == NULL)
+		return NILFS_BMAP_INVALID_PTR;
+
+	/* left sibling */
+	level = NILFS_BTREE_LEVEL_NODE_MIN;
+	if (path[level].bp_index > 0) {
+		node = nilfs_btree_get_node(btree, path, level);
+		return nilfs_btree_node_get_ptr(btree, node,
+						path[level].bp_index - 1);
+	}
+
+	/* parent */
+	level = NILFS_BTREE_LEVEL_NODE_MIN + 1;
+	if (level <= nilfs_btree_height(btree) - 1) {
+		node = nilfs_btree_get_node(btree, path, level);
+		return nilfs_btree_node_get_ptr(btree, node,
+						path[level].bp_index);
+	}
+
+	return NILFS_BMAP_INVALID_PTR;
+}
+
+static __u64 nilfs_btree_find_target_v(const struct nilfs_btree *btree,
+				       const struct nilfs_btree_path *path,
+				       __u64 key)
+{
+	__u64 ptr;
+
+	ptr = nilfs_bmap_find_target_seq(&btree->bt_bmap, key);
+	if (ptr != NILFS_BMAP_INVALID_PTR)
+		/* sequential access */
+		return ptr;
+	else {
+		ptr = nilfs_btree_find_near(btree, path);
+		if (ptr != NILFS_BMAP_INVALID_PTR)
+			/* near */
+			return ptr;
+	}
+	/* block group */
+	return nilfs_bmap_find_target_in_group(&btree->bt_bmap);
+}
+
+static void nilfs_btree_set_target_v(struct nilfs_btree *btree, __u64 key,
+				     __u64 ptr)
+{
+	btree->bt_bmap.b_last_allocated_key = key;
+	btree->bt_bmap.b_last_allocated_ptr = ptr;
+}
+
+static int nilfs_btree_prepare_insert(struct nilfs_btree *btree,
+				      struct nilfs_btree_path *path,
+				      int *levelp, __u64 key, __u64 ptr,
+				      struct nilfs_bmap_stats *stats)
+{
+	struct buffer_head *bh;
+	struct nilfs_btree_node *node, *parent, *sib;
+	__u64 sibptr;
+	int pindex, level, ret;
+
+	stats->bs_nblocks = 0;
+	level = NILFS_BTREE_LEVEL_DATA;
+
+	/* allocate a new ptr for data block */
+	if (btree->bt_ops->btop_find_target != NULL)
+		path[level].bp_newreq.bpr_ptr =
+			(*btree->bt_ops->btop_find_target)(btree, path, key);
+
+	ret = (*btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr)(
+		&btree->bt_bmap, &path[level].bp_newreq);
+	if (ret < 0)
+		goto err_out_data;
+
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
+	     level < nilfs_btree_height(btree) - 1;
+	     level++) {
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		if (nilfs_btree_node_get_nchildren(btree, node) <
+		    nilfs_btree_node_nchildren_max(btree, node)) {
+			path[level].bp_op = nilfs_btree_do_insert;
+			stats->bs_nblocks++;
+			goto out;
+		}
+
+		parent = nilfs_btree_get_node(btree, path, level + 1);
+		pindex = path[level + 1].bp_index;
+
+		/* left sibling */
+		if (pindex > 0) {
+			sibptr = nilfs_btree_node_get_ptr(btree, parent,
+							  pindex - 1);
+			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
+						   &bh);
+			if (ret < 0)
+				goto err_out_child_node;
+			sib = (struct nilfs_btree_node *)bh->b_data;
+			if (nilfs_btree_node_get_nchildren(btree, sib) <
+			    nilfs_btree_node_nchildren_max(btree, sib)) {
+				path[level].bp_sib_bh = bh;
+				path[level].bp_op = nilfs_btree_carry_left;
+				stats->bs_nblocks++;
+				goto out;
+			} else
+				nilfs_bmap_put_block(&btree->bt_bmap, bh);
+		}
+
+		/* right sibling */
+		if (pindex <
+		    nilfs_btree_node_get_nchildren(btree, parent) - 1) {
+			sibptr = nilfs_btree_node_get_ptr(btree, parent,
+							  pindex + 1);
+			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
+						   &bh);
+			if (ret < 0)
+				goto err_out_child_node;
+			sib = (struct nilfs_btree_node *)bh->b_data;
+			if (nilfs_btree_node_get_nchildren(btree, sib) <
+			    nilfs_btree_node_nchildren_max(btree, sib)) {
+				path[level].bp_sib_bh = bh;
+				path[level].bp_op = nilfs_btree_carry_right;
+				stats->bs_nblocks++;
+				goto out;
+			} else
+				nilfs_bmap_put_block(&btree->bt_bmap, bh);
+		}
+
+		/* split */
+		path[level].bp_newreq.bpr_ptr =
+			path[level - 1].bp_newreq.bpr_ptr + 1;
+		ret = (*btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr)(
+			&btree->bt_bmap, &path[level].bp_newreq);
+		if (ret < 0)
+			goto err_out_child_node;
+		ret = nilfs_bmap_get_new_block(&btree->bt_bmap,
+					       path[level].bp_newreq.bpr_ptr,
+					       &bh);
+		if (ret < 0)
+			goto err_out_curr_node;
+
+		stats->bs_nblocks++;
+
+		lock_buffer(bh);
+		nilfs_btree_node_init(btree,
+				      (struct nilfs_btree_node *)bh->b_data,
+				      0, level, 0, NULL, NULL);
+		unlock_buffer(bh);
+		path[level].bp_sib_bh = bh;
+		path[level].bp_op = nilfs_btree_split;
+	}
+
+	/* root */
+	node = nilfs_btree_get_root(btree);
+	if (nilfs_btree_node_get_nchildren(btree, node) <
+	    nilfs_btree_node_nchildren_max(btree, node)) {
+		path[level].bp_op = nilfs_btree_do_insert;
+		stats->bs_nblocks++;
+		goto out;
+	}
+
+	/* grow */
+	path[level].bp_newreq.bpr_ptr = path[level - 1].bp_newreq.bpr_ptr + 1;
+	ret = (*btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr)(
+		&btree->bt_bmap, &path[level].bp_newreq);
+	if (ret < 0)
+		goto err_out_child_node;
+	ret = nilfs_bmap_get_new_block(&btree->bt_bmap,
+				       path[level].bp_newreq.bpr_ptr, &bh);
+	if (ret < 0)
+		goto err_out_curr_node;
+
+	lock_buffer(bh);
+	nilfs_btree_node_init(btree, (struct nilfs_btree_node *)bh->b_data,
+			      0, level, 0, NULL, NULL);
+	unlock_buffer(bh);
+	path[level].bp_sib_bh = bh;
+	path[level].bp_op = nilfs_btree_grow;
+
+	level++;
+	path[level].bp_op = nilfs_btree_do_insert;
+
+	/* a newly-created node block and a data block are added */
+	stats->bs_nblocks += 2;
+
+	/* success */
+ out:
+	*levelp = level;
+	return ret;
+
+	/* error */
+ err_out_curr_node:
+	(*btree->bt_bmap.b_pops->bpop_abort_alloc_ptr)(&btree->bt_bmap,
+						       &path[level].bp_newreq);
+ err_out_child_node:
+	for (level--; level > NILFS_BTREE_LEVEL_DATA; level--) {
+		nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		(*btree->bt_bmap.b_pops->bpop_abort_alloc_ptr)(
+			&btree->bt_bmap, &path[level].bp_newreq);
+
+	}
+
+	(*btree->bt_bmap.b_pops->bpop_abort_alloc_ptr)(&btree->bt_bmap,
+						       &path[level].bp_newreq);
+ err_out_data:
+	*levelp = level;
+	stats->bs_nblocks = 0;
+	return ret;
+}
+
+static void nilfs_btree_commit_insert(struct nilfs_btree *btree,
+				      struct nilfs_btree_path *path,
+				      int maxlevel, __u64 key, __u64 ptr)
+{
+	int level;
+
+	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
+	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
+	if (btree->bt_ops->btop_set_target != NULL)
+		(*btree->bt_ops->btop_set_target)(btree, key, ptr);
+
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
+		if (btree->bt_bmap.b_pops->bpop_commit_alloc_ptr != NULL) {
+			(*btree->bt_bmap.b_pops->bpop_commit_alloc_ptr)(
+				&btree->bt_bmap, &path[level - 1].bp_newreq);
+		}
+		(*path[level].bp_op)(btree, path, level, &key, &ptr);
+	}
+
+	if (!nilfs_bmap_dirty(&btree->bt_bmap))
+		nilfs_bmap_set_dirty(&btree->bt_bmap);
+}
+
+static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	struct nilfs_bmap_stats stats;
+	int level, ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+
+	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
+				    NILFS_BTREE_LEVEL_NODE_MIN);
+	if (ret != -ENOENT) {
+		if (ret == 0)
+			ret = -EEXIST;
+		goto out;
+	}
+
+	ret = nilfs_btree_prepare_insert(btree, path, &level, key, ptr, &stats);
+	if (ret < 0)
+		goto out;
+	nilfs_btree_commit_insert(btree, path, level, key, ptr);
+	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+
+ out:
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+	return ret;
+}
+
+static void nilfs_btree_do_delete(struct nilfs_btree *btree,
+				  struct nilfs_btree_path *path,
+				  int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node;
+
+	if (level < nilfs_btree_height(btree) - 1) {
+		lock_buffer(path[level].bp_bh);
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		nilfs_btree_node_delete(btree, node, keyp, ptrp,
+					path[level].bp_index);
+		if (!buffer_dirty(path[level].bp_bh))
+			nilfs_btnode_mark_dirty(path[level].bp_bh);
+		unlock_buffer(path[level].bp_bh);
+		if (path[level].bp_index == 0)
+			nilfs_btree_promote_key(btree, path, level + 1,
+				nilfs_btree_node_get_key(btree, node, 0));
+	} else {
+		node = nilfs_btree_get_root(btree);
+		nilfs_btree_node_delete(btree, node, keyp, ptrp,
+					path[level].bp_index);
+	}
+}
+
+static void nilfs_btree_borrow_left(struct nilfs_btree *btree,
+				    struct nilfs_btree_path *path,
+				    int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *left;
+	int nchildren, lnchildren, n;
+
+	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	left = nilfs_btree_get_sib_node(btree, path, level);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	lnchildren = nilfs_btree_node_get_nchildren(btree, left);
+
+	n = (nchildren + lnchildren) / 2 - nchildren;
+
+	nilfs_btree_node_move_right(btree, left, node, n);
+
+	if (!buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	nilfs_btree_promote_key(btree, path, level + 1,
+				nilfs_btree_node_get_key(btree, node, 0));
+
+	nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+	path[level].bp_sib_bh = NULL;
+	path[level].bp_index += n;
+}
+
+static void nilfs_btree_borrow_right(struct nilfs_btree *btree,
+				     struct nilfs_btree_path *path,
+				     int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *right;
+	int nchildren, rnchildren, n;
+
+	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	right = nilfs_btree_get_sib_node(btree, path, level);
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	rnchildren = nilfs_btree_node_get_nchildren(btree, right);
+
+	n = (nchildren + rnchildren) / 2 - nchildren;
+
+	nilfs_btree_node_move_left(btree, node, right, n);
+
+	if (!buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	path[level + 1].bp_index++;
+	nilfs_btree_promote_key(btree, path, level + 1,
+				nilfs_btree_node_get_key(btree, right, 0));
+	path[level + 1].bp_index--;
+
+	nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+	path[level].bp_sib_bh = NULL;
+}
+
+static void nilfs_btree_concat_left(struct nilfs_btree *btree,
+				    struct nilfs_btree_path *path,
+				    int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *left;
+	int n;
+
+	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	left = nilfs_btree_get_sib_node(btree, path, level);
+
+	n = nilfs_btree_node_get_nchildren(btree, node);
+
+	nilfs_btree_node_move_left(btree, left, node, n);
+
+	if (!buffer_dirty(path[level].bp_sib_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_sib_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_bh);
+	path[level].bp_bh = path[level].bp_sib_bh;
+	path[level].bp_sib_bh = NULL;
+	path[level].bp_index += nilfs_btree_node_get_nchildren(btree, left);
+}
+
+static void nilfs_btree_concat_right(struct nilfs_btree *btree,
+				     struct nilfs_btree_path *path,
+				     int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *node, *right;
+	int n;
+
+	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
+
+	lock_buffer(path[level].bp_bh);
+	lock_buffer(path[level].bp_sib_bh);
+
+	node = nilfs_btree_get_nonroot_node(btree, path, level);
+	right = nilfs_btree_get_sib_node(btree, path, level);
+
+	n = nilfs_btree_node_get_nchildren(btree, right);
+
+	nilfs_btree_node_move_left(btree, node, right, n);
+
+	if (!buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+
+	unlock_buffer(path[level].bp_bh);
+	unlock_buffer(path[level].bp_sib_bh);
+
+	nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_sib_bh);
+	path[level].bp_sib_bh = NULL;
+	path[level + 1].bp_index++;
+}
+
+static void nilfs_btree_shrink(struct nilfs_btree *btree,
+			       struct nilfs_btree_path *path,
+			       int level, __u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *root, *child;
+	int n;
+
+	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
+
+	lock_buffer(path[level].bp_bh);
+	root = nilfs_btree_get_root(btree);
+	child = nilfs_btree_get_nonroot_node(btree, path, level);
+
+	nilfs_btree_node_delete(btree, root, NULL, NULL, 0);
+	nilfs_btree_node_set_level(btree, root, level);
+	n = nilfs_btree_node_get_nchildren(btree, child);
+	nilfs_btree_node_move_left(btree, root, child, n);
+	unlock_buffer(path[level].bp_bh);
+
+	nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_bh);
+	path[level].bp_bh = NULL;
+}
+
+
+static int nilfs_btree_prepare_delete(struct nilfs_btree *btree,
+				      struct nilfs_btree_path *path,
+				      int *levelp,
+				      struct nilfs_bmap_stats *stats)
+{
+	struct buffer_head *bh;
+	struct nilfs_btree_node *node, *parent, *sib;
+	__u64 sibptr;
+	int pindex, level, ret;
+
+	ret = 0;
+	stats->bs_nblocks = 0;
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
+	     level < nilfs_btree_height(btree) - 1;
+	     level++) {
+		node = nilfs_btree_get_nonroot_node(btree, path, level);
+		path[level].bp_oldreq.bpr_ptr =
+			nilfs_btree_node_get_ptr(btree, node,
+						 path[level].bp_index);
+		if (btree->bt_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
+			ret = (*btree->bt_bmap.b_pops->bpop_prepare_end_ptr)(
+				&btree->bt_bmap, &path[level].bp_oldreq);
+			if (ret < 0)
+				goto err_out_child_node;
+		}
+
+		if (nilfs_btree_node_get_nchildren(btree, node) >
+		    nilfs_btree_node_nchildren_min(btree, node)) {
+			path[level].bp_op = nilfs_btree_do_delete;
+			stats->bs_nblocks++;
+			goto out;
+		}
+
+		parent = nilfs_btree_get_node(btree, path, level + 1);
+		pindex = path[level + 1].bp_index;
+
+		if (pindex > 0) {
+			/* left sibling */
+			sibptr = nilfs_btree_node_get_ptr(btree, parent,
+							  pindex - 1);
+			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
+						   &bh);
+			if (ret < 0)
+				goto err_out_curr_node;
+			sib = (struct nilfs_btree_node *)bh->b_data;
+			if (nilfs_btree_node_get_nchildren(btree, sib) >
+			    nilfs_btree_node_nchildren_min(btree, sib)) {
+				path[level].bp_sib_bh = bh;
+				path[level].bp_op = nilfs_btree_borrow_left;
+				stats->bs_nblocks++;
+				goto out;
+			} else {
+				path[level].bp_sib_bh = bh;
+				path[level].bp_op = nilfs_btree_concat_left;
+				stats->bs_nblocks++;
+				/* continue; */
+			}
+		} else if (pindex <
+			   nilfs_btree_node_get_nchildren(btree, parent) - 1) {
+			/* right sibling */
+			sibptr = nilfs_btree_node_get_ptr(btree, parent,
+							  pindex + 1);
+			ret = nilfs_bmap_get_block(&btree->bt_bmap, sibptr,
+						   &bh);
+			if (ret < 0)
+				goto err_out_curr_node;
+			sib = (struct nilfs_btree_node *)bh->b_data;
+			if (nilfs_btree_node_get_nchildren(btree, sib) >
+			    nilfs_btree_node_nchildren_min(btree, sib)) {
+				path[level].bp_sib_bh = bh;
+				path[level].bp_op = nilfs_btree_borrow_right;
+				stats->bs_nblocks++;
+				goto out;
+			} else {
+				path[level].bp_sib_bh = bh;
+				path[level].bp_op = nilfs_btree_concat_right;
+				stats->bs_nblocks++;
+				/* continue; */
+			}
+		} else {
+			/* no siblings */
+			/* the only child of the root node */
+			BUG_ON(level != nilfs_btree_height(btree) - 2);
+			if (nilfs_btree_node_get_nchildren(btree, node) - 1 <=
+			    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
+				path[level].bp_op = nilfs_btree_shrink;
+				stats->bs_nblocks += 2;
+			} else {
+				path[level].bp_op = nilfs_btree_do_delete;
+				stats->bs_nblocks++;
+			}
+
+			goto out;
+
+		}
+	}
+
+	node = nilfs_btree_get_root(btree);
+	path[level].bp_oldreq.bpr_ptr =
+		nilfs_btree_node_get_ptr(btree, node, path[level].bp_index);
+	if (btree->bt_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
+		ret = (*btree->bt_bmap.b_pops->bpop_prepare_end_ptr)(
+			&btree->bt_bmap, &path[level].bp_oldreq);
+		if (ret < 0)
+			goto err_out_child_node;
+	}
+	/* child of the root node is deleted */
+	path[level].bp_op = nilfs_btree_do_delete;
+	stats->bs_nblocks++;
+
+	/* success */
+ out:
+	*levelp = level;
+	return ret;
+
+	/* error */
+ err_out_curr_node:
+	if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
+		(*btree->bt_bmap.b_pops->bpop_abort_end_ptr)(
+			&btree->bt_bmap, &path[level].bp_oldreq);
+ err_out_child_node:
+	for (level--; level >= NILFS_BTREE_LEVEL_NODE_MIN; level--) {
+		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
+		if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
+			(*btree->bt_bmap.b_pops->bpop_abort_end_ptr)(
+				&btree->bt_bmap, &path[level].bp_oldreq);
+	}
+	*levelp = level;
+	stats->bs_nblocks = 0;
+	return ret;
+}
+
+static void nilfs_btree_commit_delete(struct nilfs_btree *btree,
+				      struct nilfs_btree_path *path,
+				      int maxlevel)
+{
+	int level;
+
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
+		if (btree->bt_bmap.b_pops->bpop_commit_end_ptr != NULL)
+			(*btree->bt_bmap.b_pops->bpop_commit_end_ptr)(
+				&btree->bt_bmap, &path[level].bp_oldreq);
+		(*path[level].bp_op)(btree, path, level, NULL, NULL);
+	}
+
+	if (!nilfs_bmap_dirty(&btree->bt_bmap))
+		nilfs_bmap_set_dirty(&btree->bt_bmap);
+}
+
+static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
+
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	struct nilfs_bmap_stats stats;
+	int level, ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
+				    NILFS_BTREE_LEVEL_NODE_MIN);
+	if (ret < 0)
+		goto out;
+
+	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats);
+	if (ret < 0)
+		goto out;
+	nilfs_btree_commit_delete(btree, path, level);
+	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
+
+out:
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+	return ret;
+}
+
+static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	int ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+
+	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
+
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+
+	return ret;
+}
+
+static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
+{
+	struct buffer_head *bh;
+	struct nilfs_btree *btree;
+	struct nilfs_btree_node *root, *node;
+	__u64 maxkey, nextmaxkey;
+	__u64 ptr;
+	int nchildren, ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	root = nilfs_btree_get_root(btree);
+	switch (nilfs_btree_height(btree)) {
+	case 2:
+		bh = NULL;
+		node = root;
+		break;
+	case 3:
+		nchildren = nilfs_btree_node_get_nchildren(btree, root);
+		if (nchildren > 1)
+			return 0;
+		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
+		ret = nilfs_bmap_get_block(bmap, ptr, &bh);
+		if (ret < 0)
+			return ret;
+		node = (struct nilfs_btree_node *)bh->b_data;
+		break;
+	default:
+		return 0;
+	}
+
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	maxkey = nilfs_btree_node_get_key(btree, node, nchildren - 1);
+	nextmaxkey = (nchildren > 1) ?
+		nilfs_btree_node_get_key(btree, node, nchildren - 2) : 0;
+	if (bh != NULL)
+		nilfs_bmap_put_block(bmap, bh);
+
+	return (maxkey == key) && (nextmaxkey < bmap->b_low);
+}
+
+static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
+				   __u64 *keys, __u64 *ptrs, int nitems)
+{
+	struct buffer_head *bh;
+	struct nilfs_btree *btree;
+	struct nilfs_btree_node *node, *root;
+	__le64 *dkeys;
+	__le64 *dptrs;
+	__u64 ptr;
+	int nchildren, i, ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	root = nilfs_btree_get_root(btree);
+	switch (nilfs_btree_height(btree)) {
+	case 2:
+		bh = NULL;
+		node = root;
+		break;
+	case 3:
+		nchildren = nilfs_btree_node_get_nchildren(btree, root);
+		BUG_ON(nchildren > 1);
+		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
+		ret = nilfs_bmap_get_block(bmap, ptr, &bh);
+		if (ret < 0)
+			return ret;
+		node = (struct nilfs_btree_node *)bh->b_data;
+		break;
+	default:
+		node = NULL;
+		BUG();
+	}
+
+	nchildren = nilfs_btree_node_get_nchildren(btree, node);
+	if (nchildren < nitems)
+		nitems = nchildren;
+	dkeys = nilfs_btree_node_dkeys(btree, node);
+	dptrs = nilfs_btree_node_dptrs(btree, node);
+	for (i = 0; i < nitems; i++) {
+		keys[i] = nilfs_bmap_dkey_to_key(dkeys[i]);
+		ptrs[i] = nilfs_bmap_dptr_to_ptr(dptrs[i]);
+	}
+
+	if (bh != NULL)
+		nilfs_bmap_put_block(bmap, bh);
+
+	return nitems;
+}
+
+static int
+nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *bmap, __u64 key,
+				       union nilfs_bmap_ptr_req *dreq,
+				       union nilfs_bmap_ptr_req *nreq,
+				       struct buffer_head **bhp,
+				       struct nilfs_bmap_stats *stats)
+{
+	struct buffer_head *bh;
+	struct nilfs_btree *btree;
+	int ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	stats->bs_nblocks = 0;
+
+	/* for data */
+	/* cannot find near ptr */
+	if (btree->bt_ops->btop_find_target != NULL)
+		dreq->bpr_ptr
+			= (*btree->bt_ops->btop_find_target)(btree, NULL, key);
+	ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, dreq);
+	if (ret < 0)
+		return ret;
+
+	*bhp = NULL;
+	stats->bs_nblocks++;
+	if (nreq != NULL) {
+		nreq->bpr_ptr = dreq->bpr_ptr + 1;
+		ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, nreq);
+		if (ret < 0)
+			goto err_out_dreq;
+
+		ret = nilfs_bmap_get_new_block(bmap, nreq->bpr_ptr, &bh);
+		if (ret < 0)
+			goto err_out_nreq;
+
+		*bhp = bh;
+		stats->bs_nblocks++;
+	}
+
+	/* success */
+	return 0;
+
+	/* error */
+ err_out_nreq:
+	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, nreq);
+ err_out_dreq:
+	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, dreq);
+	stats->bs_nblocks = 0;
+	return ret;
+
+}
+
+static void
+nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
+				      __u64 key, __u64 ptr,
+				      const __u64 *keys, const __u64 *ptrs,
+				      int n, __u64 low, __u64 high,
+				      union nilfs_bmap_ptr_req *dreq,
+				      union nilfs_bmap_ptr_req *nreq,
+				      struct buffer_head *bh)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_node *node;
+	__u64 tmpptr;
+
+	/* free resources */
+	if (bmap->b_ops->bop_clear != NULL)
+		(*bmap->b_ops->bop_clear)(bmap);
+
+	/* ptr must be a pointer to a buffer head. */
+	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
+
+	/* convert and insert */
+	btree = (struct nilfs_btree *)bmap;
+	nilfs_btree_init(bmap, low, high);
+	if (nreq != NULL) {
+		if (bmap->b_pops->bpop_commit_alloc_ptr != NULL) {
+			(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, dreq);
+			(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, nreq);
+		}
+
+		/* create child node at level 1 */
+		lock_buffer(bh);
+		node = (struct nilfs_btree_node *)bh->b_data;
+		nilfs_btree_node_init(btree, node, 0, 1, n, keys, ptrs);
+		nilfs_btree_node_insert(btree, node,
+					key, dreq->bpr_ptr, n);
+		if (!buffer_dirty(bh))
+			nilfs_btnode_mark_dirty(bh);
+		if (!nilfs_bmap_dirty(bmap))
+			nilfs_bmap_set_dirty(bmap);
+
+		unlock_buffer(bh);
+		nilfs_bmap_put_block(bmap, bh);
+
+		/* create root node at level 2 */
+		node = nilfs_btree_get_root(btree);
+		tmpptr = nreq->bpr_ptr;
+		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
+				      2, 1, &keys[0], &tmpptr);
+	} else {
+		if (bmap->b_pops->bpop_commit_alloc_ptr != NULL)
+			(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, dreq);
+
+		/* create root node at level 1 */
+		node = nilfs_btree_get_root(btree);
+		nilfs_btree_node_init(btree, node, NILFS_BTREE_NODE_ROOT,
+				      1, n, keys, ptrs);
+		nilfs_btree_node_insert(btree, node,
+					key, dreq->bpr_ptr, n);
+		if (!nilfs_bmap_dirty(bmap))
+			nilfs_bmap_set_dirty(bmap);
+	}
+
+	if (btree->bt_ops->btop_set_target != NULL)
+		(*btree->bt_ops->btop_set_target)(btree, key, dreq->bpr_ptr);
+}
+
+/**
+ * nilfs_btree_convert_and_insert -
+ * @bmap:
+ * @key:
+ * @ptr:
+ * @keys:
+ * @ptrs:
+ * @n:
+ * @low:
+ * @high:
+ */
+int nilfs_btree_convert_and_insert(struct nilfs_bmap *bmap,
+				   __u64 key, __u64 ptr,
+				   const __u64 *keys, const __u64 *ptrs,
+				   int n, __u64 low, __u64 high)
+{
+	struct buffer_head *bh;
+	union nilfs_bmap_ptr_req dreq, nreq, *di, *ni;
+	struct nilfs_bmap_stats stats;
+	int ret;
+
+	if (n + 1 <= NILFS_BTREE_ROOT_NCHILDREN_MAX) {
+		di = &dreq;
+		ni = NULL;
+	} else if ((n + 1) <= NILFS_BTREE_NODE_NCHILDREN_MAX(
+			   1 << bmap->b_inode->i_blkbits)) {
+		di = &dreq;
+		ni = &nreq;
+	} else {
+		di = NULL;
+		ni = NULL;
+		BUG();
+	}
+
+	ret = nilfs_btree_prepare_convert_and_insert(bmap, key, di, ni, &bh,
+						     &stats);
+	if (ret < 0)
+		return ret;
+	nilfs_btree_commit_convert_and_insert(bmap, key, ptr, keys, ptrs, n,
+					      low, high, di, ni, bh);
+	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+	return 0;
+}
+
+static int nilfs_btree_propagate_p(struct nilfs_btree *btree,
+				   struct nilfs_btree_path *path,
+				   int level,
+				   struct buffer_head *bh)
+{
+	while ((++level < nilfs_btree_height(btree) - 1) &&
+	       !buffer_dirty(path[level].bp_bh))
+		nilfs_btnode_mark_dirty(path[level].bp_bh);
+
+	return 0;
+}
+
+static int nilfs_btree_prepare_update_v(struct nilfs_btree *btree,
+					struct nilfs_btree_path *path,
+					int level)
+{
+	struct nilfs_btree_node *parent;
+	int ret;
+
+	parent = nilfs_btree_get_node(btree, path, level + 1);
+	path[level].bp_oldreq.bpr_ptr =
+		nilfs_btree_node_get_ptr(btree, parent,
+					 path[level + 1].bp_index);
+	path[level].bp_newreq.bpr_ptr = path[level].bp_oldreq.bpr_ptr + 1;
+	ret = nilfs_bmap_prepare_update(&btree->bt_bmap,
+					&path[level].bp_oldreq,
+					&path[level].bp_newreq);
+	if (ret < 0)
+		return ret;
+
+	if (buffer_nilfs_node(path[level].bp_bh)) {
+		path[level].bp_ctxt.oldkey = path[level].bp_oldreq.bpr_ptr;
+		path[level].bp_ctxt.newkey = path[level].bp_newreq.bpr_ptr;
+		path[level].bp_ctxt.bh = path[level].bp_bh;
+		ret = nilfs_btnode_prepare_change_key(
+			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&path[level].bp_ctxt);
+		if (ret < 0) {
+			nilfs_bmap_abort_update(&btree->bt_bmap,
+						&path[level].bp_oldreq,
+						&path[level].bp_newreq);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void nilfs_btree_commit_update_v(struct nilfs_btree *btree,
+					struct nilfs_btree_path *path,
+					int level)
+{
+	struct nilfs_btree_node *parent;
+
+	nilfs_bmap_commit_update(&btree->bt_bmap,
+				 &path[level].bp_oldreq,
+				 &path[level].bp_newreq);
+
+	if (buffer_nilfs_node(path[level].bp_bh)) {
+		nilfs_btnode_commit_change_key(
+			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&path[level].bp_ctxt);
+		path[level].bp_bh = path[level].bp_ctxt.bh;
+	}
+	set_buffer_nilfs_volatile(path[level].bp_bh);
+
+	parent = nilfs_btree_get_node(btree, path, level + 1);
+	nilfs_btree_node_set_ptr(btree, parent, path[level + 1].bp_index,
+				 path[level].bp_newreq.bpr_ptr);
+}
+
+static void nilfs_btree_abort_update_v(struct nilfs_btree *btree,
+				       struct nilfs_btree_path *path,
+				       int level)
+{
+	nilfs_bmap_abort_update(&btree->bt_bmap,
+				&path[level].bp_oldreq,
+				&path[level].bp_newreq);
+	if (buffer_nilfs_node(path[level].bp_bh))
+		nilfs_btnode_abort_change_key(
+			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&path[level].bp_ctxt);
+}
+
+static int nilfs_btree_prepare_propagate_v(struct nilfs_btree *btree,
+					   struct nilfs_btree_path *path,
+					   int minlevel,
+					   int *maxlevelp)
+{
+	int level, ret;
+
+	level = minlevel;
+	if (!buffer_nilfs_volatile(path[level].bp_bh)) {
+		ret = nilfs_btree_prepare_update_v(btree, path, level);
+		if (ret < 0)
+			return ret;
+	}
+	while ((++level < nilfs_btree_height(btree) - 1) &&
+	       !buffer_dirty(path[level].bp_bh)) {
+
+		BUG_ON(buffer_nilfs_volatile(path[level].bp_bh));
+		ret = nilfs_btree_prepare_update_v(btree, path, level);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* success */
+	BUG_ON(maxlevelp == NULL);
+	*maxlevelp = level - 1;
+	return 0;
+
+	/* error */
+ out:
+	while (--level > minlevel)
+		nilfs_btree_abort_update_v(btree, path, level);
+	if (!buffer_nilfs_volatile(path[level].bp_bh))
+		nilfs_btree_abort_update_v(btree, path, level);
+	return ret;
+}
+
+static void nilfs_btree_commit_propagate_v(struct nilfs_btree *btree,
+					   struct nilfs_btree_path *path,
+					   int minlevel,
+					   int maxlevel,
+					   struct buffer_head *bh)
+{
+	int level;
+
+	if (!buffer_nilfs_volatile(path[minlevel].bp_bh))
+		nilfs_btree_commit_update_v(btree, path, minlevel);
+
+	for (level = minlevel + 1; level <= maxlevel; level++)
+		nilfs_btree_commit_update_v(btree, path, level);
+}
+
+static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
+				   struct nilfs_btree_path *path,
+				   int level,
+				   struct buffer_head *bh)
+{
+	int maxlevel, ret;
+	struct nilfs_btree_node *parent;
+	__u64 ptr;
+
+	get_bh(bh);
+	path[level].bp_bh = bh;
+	ret = nilfs_btree_prepare_propagate_v(btree, path, level, &maxlevel);
+	if (ret < 0)
+		goto out;
+
+	if (buffer_nilfs_volatile(path[level].bp_bh)) {
+		parent = nilfs_btree_get_node(btree, path, level + 1);
+		ptr = nilfs_btree_node_get_ptr(btree, parent,
+					       path[level + 1].bp_index);
+		ret = nilfs_bmap_mark_dirty(&btree->bt_bmap, ptr);
+		if (ret < 0)
+			goto out;
+	}
+
+	nilfs_btree_commit_propagate_v(btree, path, level, maxlevel, bh);
+
+ out:
+	brelse(path[level].bp_bh);
+	path[level].bp_bh = NULL;
+	return ret;
+}
+
+static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
+				 struct buffer_head *bh)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	struct nilfs_btree_node *node;
+	__u64 key;
+	int level, ret;
+
+	BUG_ON(!buffer_dirty(bh));
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+
+	if (buffer_nilfs_node(bh)) {
+		node = (struct nilfs_btree_node *)bh->b_data;
+		key = nilfs_btree_node_get_key(btree, node, 0);
+		level = nilfs_btree_node_get_level(btree, node);
+	} else {
+		key = nilfs_bmap_data_get_key(bmap, bh);
+		level = NILFS_BTREE_LEVEL_DATA;
+	}
+
+	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1);
+	if (ret < 0) {
+		/* BUG_ON(ret == -ENOENT); */
+		if (ret == -ENOENT) {
+			printk(KERN_CRIT "%s: key = %llu, level == %d\n",
+			       __func__, (unsigned long long)key, level);
+			BUG();
+		}
+		goto out;
+	}
+
+	ret = (*btree->bt_ops->btop_propagate)(btree, path, level, bh);
+
+ out:
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+
+	return ret;
+}
+
+static int nilfs_btree_propagate_gc(const struct nilfs_bmap *bmap,
+				    struct buffer_head *bh)
+{
+	return nilfs_bmap_mark_dirty(bmap, bh->b_blocknr);
+}
+
+static void nilfs_btree_add_dirty_buffer(struct nilfs_btree *btree,
+					 struct list_head *lists,
+					 struct buffer_head *bh)
+{
+	struct list_head *head;
+	struct buffer_head *cbh;
+	struct nilfs_btree_node *node, *cnode;
+	__u64 key, ckey;
+	int level;
+
+	get_bh(bh);
+	node = (struct nilfs_btree_node *)bh->b_data;
+	key = nilfs_btree_node_get_key(btree, node, 0);
+	level = nilfs_btree_node_get_level(btree, node);
+	list_for_each(head, &lists[level]) {
+		cbh = list_entry(head, struct buffer_head, b_assoc_buffers);
+		cnode = (struct nilfs_btree_node *)cbh->b_data;
+		ckey = nilfs_btree_node_get_key(btree, cnode, 0);
+		if (key < ckey)
+			break;
+	}
+	list_add_tail(&bh->b_assoc_buffers, head);
+}
+
+static void nilfs_btree_lookup_dirty_page_buffers(struct nilfs_btree *btree,
+						  struct page *page,
+						  struct list_head *lists)
+{
+	struct buffer_head *bh;
+
+	bh = page_buffers(page);
+	do {
+		if (buffer_dirty(bh))
+			nilfs_btree_add_dirty_buffer(btree, lists, bh);
+		bh = bh->b_this_page;
+	} while (bh != page_buffers(page));
+}
+
+#define NILFS_BTREE_GANG_LOOKUP_SIZE 16
+static void
+nilfs_btree_lookup_dirty_buffers_tag(struct nilfs_btree *btree,
+				     struct nilfs_btnode_cache *btcache,
+				     struct list_head *lists,
+				     int tag)
+{
+	struct page *pages[NILFS_BTREE_GANG_LOOKUP_SIZE];
+	__u64 index;
+	int i, n;
+
+	index = 0;
+	n = nilfs_btnode_gang_lookup_tag_nolock(btcache, pages, index,
+						NILFS_BTREE_GANG_LOOKUP_SIZE,
+						tag);
+	while (n > 0) {
+		index = page_index(pages[n - 1]) + 1;
+		for (i = 0; i < n; i++) {
+			nilfs_btree_lookup_dirty_page_buffers(
+				btree, pages[i], lists);
+		}
+		n = nilfs_btnode_gang_lookup_tag_nolock(
+			btcache, pages, index,
+			NILFS_BTREE_GANG_LOOKUP_SIZE, tag);
+	}
+}
+
+static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *bmap,
+					     struct list_head *listp)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btnode_cache *btcache;
+	struct list_head lists[NILFS_BTREE_LEVEL_MAX];
+	int level;
+
+	btree = (struct nilfs_btree *)bmap;
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
+	     level < NILFS_BTREE_LEVEL_MAX;
+	     level++)
+		INIT_LIST_HEAD(&lists[level]);
+
+	btcache = &NILFS_BMAP_I(bmap)->i_btnode_cache;
+	nilfs_btnode_read_lock(btcache);
+	nilfs_btree_lookup_dirty_buffers_tag(btree, btcache, lists,
+					     PAGECACHE_TAG_DIRTY);
+	nilfs_btnode_read_unlock(btcache);
+
+	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
+	     level < NILFS_BTREE_LEVEL_MAX;
+	     level++)
+		list_splice(&lists[level], listp->prev);
+}
+
+static int nilfs_btree_assign_p(struct nilfs_btree *btree,
+				struct nilfs_btree_path *path,
+				int level,
+				struct buffer_head **bh,
+				sector_t blocknr,
+				union nilfs_binfo *binfo)
+{
+	struct nilfs_btree_node *parent;
+	__u64 key;
+	__u64 ptr;
+	int ret;
+
+	parent = nilfs_btree_get_node(btree, path, level + 1);
+	ptr = nilfs_btree_node_get_ptr(btree, parent,
+				       path[level + 1].bp_index);
+	if (buffer_nilfs_node(*bh)) {
+		path[level].bp_ctxt.oldkey = ptr;
+		path[level].bp_ctxt.newkey = blocknr;
+		path[level].bp_ctxt.bh = *bh;
+		ret = nilfs_btnode_prepare_change_key(
+			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&path[level].bp_ctxt);
+		if (ret < 0)
+			return ret;
+		nilfs_btnode_commit_change_key(
+			&NILFS_BMAP_I(&btree->bt_bmap)->i_btnode_cache,
+			&path[level].bp_ctxt);
+		*bh = path[level].bp_ctxt.bh;
+	}
+
+	nilfs_btree_node_set_ptr(btree, parent,
+				 path[level + 1].bp_index, blocknr);
+
+	key = nilfs_btree_node_get_key(btree, parent,
+				       path[level + 1].bp_index);
+	/* on-disk format */
+	binfo->bi_dat.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_dat.bi_level = level;
+
+	return 0;
+}
+
+static int nilfs_btree_assign_v(struct nilfs_btree *btree,
+				struct nilfs_btree_path *path,
+				int level,
+				struct buffer_head **bh,
+				sector_t blocknr,
+				union nilfs_binfo *binfo)
+{
+	struct nilfs_btree_node *parent;
+	__u64 key;
+	__u64 ptr;
+	union nilfs_bmap_ptr_req req;
+	int ret;
+
+	parent = nilfs_btree_get_node(btree, path, level + 1);
+	ptr = nilfs_btree_node_get_ptr(btree, parent,
+				       path[level + 1].bp_index);
+	req.bpr_ptr = ptr;
+	ret = (*btree->bt_bmap.b_pops->bpop_prepare_start_ptr)(&btree->bt_bmap,
+							       &req);
+	if (ret < 0)
+		return ret;
+	(*btree->bt_bmap.b_pops->bpop_commit_start_ptr)(&btree->bt_bmap,
+							&req, blocknr);
+
+	key = nilfs_btree_node_get_key(btree, parent,
+				       path[level + 1].bp_index);
+	/* on-disk format */
+	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
+	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+
+	return 0;
+}
+
+static int nilfs_btree_assign(struct nilfs_bmap *bmap,
+			      struct buffer_head **bh,
+			      sector_t blocknr,
+			      union nilfs_binfo *binfo)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	struct nilfs_btree_node *node;
+	__u64 key;
+	int level, ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+
+	if (buffer_nilfs_node(*bh)) {
+		node = (struct nilfs_btree_node *)(*bh)->b_data;
+		key = nilfs_btree_node_get_key(btree, node, 0);
+		level = nilfs_btree_node_get_level(btree, node);
+	} else {
+		key = nilfs_bmap_data_get_key(bmap, *bh);
+		level = NILFS_BTREE_LEVEL_DATA;
+	}
+
+	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1);
+	if (ret < 0) {
+		BUG_ON(ret == -ENOENT);
+		goto out;
+	}
+
+	ret = (*btree->bt_ops->btop_assign)(btree, path, level, bh,
+					    blocknr, binfo);
+
+ out:
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+
+	return ret;
+}
+
+static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
+				 struct buffer_head **bh,
+				 sector_t blocknr,
+				 union nilfs_binfo *binfo)
+{
+	struct nilfs_btree *btree;
+	struct nilfs_btree_node *node;
+	__u64 key;
+	int ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	ret = nilfs_bmap_move_v(bmap, (*bh)->b_blocknr, blocknr);
+	if (ret < 0)
+		return ret;
+
+	if (buffer_nilfs_node(*bh)) {
+		node = (struct nilfs_btree_node *)(*bh)->b_data;
+		key = nilfs_btree_node_get_key(btree, node, 0);
+	} else
+		key = nilfs_bmap_data_get_key(bmap, *bh);
+
+	/* on-disk format */
+	binfo->bi_v.bi_vblocknr = cpu_to_le64((*bh)->b_blocknr);
+	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+
+	return 0;
+}
+
+static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
+{
+	struct buffer_head *bh;
+	struct nilfs_btree *btree;
+	struct nilfs_btree_path *path;
+	__u64 ptr;
+	int ret;
+
+	btree = (struct nilfs_btree *)bmap;
+	path = nilfs_btree_alloc_path(btree);
+	if (path == NULL)
+		return -ENOMEM;
+	nilfs_btree_init_path(btree, path);
+
+	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1);
+	if (ret < 0) {
+		BUG_ON(ret == -ENOENT);
+		goto out;
+	}
+	ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr, &bh);
+	if (ret < 0) {
+		BUG_ON(ret == -ENOENT);
+		goto out;
+	}
+
+	if (!buffer_dirty(bh))
+		nilfs_btnode_mark_dirty(bh);
+	nilfs_bmap_put_block(&btree->bt_bmap, bh);
+	if (!nilfs_bmap_dirty(&btree->bt_bmap))
+		nilfs_bmap_set_dirty(&btree->bt_bmap);
+
+ out:
+	nilfs_btree_clear_path(btree, path);
+	nilfs_btree_free_path(btree, path);
+	return ret;
+}
+
+static const struct nilfs_bmap_operations nilfs_btree_ops = {
+	.bop_lookup		=	nilfs_btree_lookup,
+	.bop_insert		=	nilfs_btree_insert,
+	.bop_delete		=	nilfs_btree_delete,
+	.bop_clear		=	NULL,
+
+	.bop_propagate		=	nilfs_btree_propagate,
+
+	.bop_lookup_dirty_buffers =	nilfs_btree_lookup_dirty_buffers,
+
+	.bop_assign		=	nilfs_btree_assign,
+	.bop_mark		=	nilfs_btree_mark,
+
+	.bop_last_key		=	nilfs_btree_last_key,
+	.bop_check_insert	=	NULL,
+	.bop_check_delete	=	nilfs_btree_check_delete,
+	.bop_gather_data	=	nilfs_btree_gather_data,
+};
+
+static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
+	.bop_lookup		=	NULL,
+	.bop_insert		=	NULL,
+	.bop_delete		=	NULL,
+	.bop_clear		=	NULL,
+
+	.bop_propagate		=	nilfs_btree_propagate_gc,
+
+	.bop_lookup_dirty_buffers =	nilfs_btree_lookup_dirty_buffers,
+
+	.bop_assign		=	nilfs_btree_assign_gc,
+	.bop_mark		=	NULL,
+
+	.bop_last_key		=	NULL,
+	.bop_check_insert	=	NULL,
+	.bop_check_delete	=	NULL,
+	.bop_gather_data	=	NULL,
+};
+
+static const struct nilfs_btree_operations nilfs_btree_ops_v = {
+	.btop_find_target	=	nilfs_btree_find_target_v,
+	.btop_set_target	=	nilfs_btree_set_target_v,
+	.btop_propagate		=	nilfs_btree_propagate_v,
+	.btop_assign		=	nilfs_btree_assign_v,
+};
+
+static const struct nilfs_btree_operations nilfs_btree_ops_p = {
+	.btop_find_target	=	NULL,
+	.btop_set_target	=	NULL,
+	.btop_propagate		=	nilfs_btree_propagate_p,
+	.btop_assign		=	nilfs_btree_assign_p,
+};
+
+int nilfs_btree_init(struct nilfs_bmap *bmap, __u64 low, __u64 high)
+{
+	struct nilfs_btree *btree;
+
+	btree = (struct nilfs_btree *)bmap;
+	bmap->b_ops = &nilfs_btree_ops;
+	bmap->b_low = low;
+	bmap->b_high = high;
+	switch (bmap->b_inode->i_ino) {
+	case NILFS_DAT_INO:
+		btree->bt_ops = &nilfs_btree_ops_p;
+		break;
+	default:
+		btree->bt_ops = &nilfs_btree_ops_v;
+		break;
+	}
+
+	return 0;
+}
+
+void nilfs_btree_init_gc(struct nilfs_bmap *bmap)
+{
+	bmap->b_low = NILFS_BMAP_LARGE_LOW;
+	bmap->b_high = NILFS_BMAP_LARGE_HIGH;
+	bmap->b_ops = &nilfs_btree_ops_gc;
+}
diff -puN /dev/null fs/nilfs2/btree.h
--- /dev/null
+++ a/fs/nilfs2/btree.h
@@ -0,0 +1,137 @@
+/*
+ * btree.h - NILFS B-tree.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_BTREE_H
+#define _NILFS_BTREE_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/list.h>
+#include <linux/nilfs2_fs.h>
+#include "btnode.h"
+#include "bmap.h"
+
+
+struct nilfs_btree;
+
+/**
+ * struct nilfs_btree_path - A path on which B-tree operations are executed
+ * @bp_bh: buffer head of node block
+ * @bp_sib_bh: buffer head of sibling node block
+ * @bp_index: index of child node
+ * @bp_oldreq: ptr end request for old ptr
+ * @bp_newreq: ptr alloc request for new ptr
+ * @bp_op: rebalance operation
+ */
+struct nilfs_btree_path {
+	struct buffer_head *bp_bh;
+	struct buffer_head *bp_sib_bh;
+	int bp_index;
+	union nilfs_bmap_ptr_req bp_oldreq;
+	union nilfs_bmap_ptr_req bp_newreq;
+	struct nilfs_btnode_chkey_ctxt bp_ctxt;
+	void (*bp_op)(struct nilfs_btree *, struct nilfs_btree_path *,
+		      int, __u64 *, __u64 *);
+};
+
+/**
+ * struct nilfs_btree_operations - B-tree operation table
+ */
+struct nilfs_btree_operations {
+	__u64 (*btop_find_target)(const struct nilfs_btree *,
+				  const struct nilfs_btree_path *, __u64);
+	void (*btop_set_target)(struct nilfs_btree *, __u64, __u64);
+
+	struct the_nilfs *(*btop_get_nilfs)(struct nilfs_btree *);
+
+	int (*btop_propagate)(struct nilfs_btree *,
+			      struct nilfs_btree_path *,
+			      int,
+			      struct buffer_head *);
+	int (*btop_assign)(struct nilfs_btree *,
+			   struct nilfs_btree_path *,
+			   int,
+			   struct buffer_head **,
+			   sector_t,
+			   union nilfs_binfo *);
+};
+
+/**
+ * struct nilfs_btree_node - B-tree node
+ * @bn_flags: flags
+ * @bn_level: level
+ * @bn_nchildren: number of children
+ * @bn_pad: padding
+ */
+struct nilfs_btree_node {
+	__u8 bn_flags;
+	__u8 bn_level;
+	__le16 bn_nchildren;
+	__le32 bn_pad;
+};
+
+/* flags */
+#define NILFS_BTREE_NODE_ROOT	0x01
+
+/* level */
+#define NILFS_BTREE_LEVEL_DATA		0
+#define NILFS_BTREE_LEVEL_NODE_MIN	(NILFS_BTREE_LEVEL_DATA + 1)
+#define NILFS_BTREE_LEVEL_MAX		14
+
+/**
+ * struct nilfs_btree - B-tree structure
+ * @bt_bmap: bmap base structure
+ * @bt_ops: B-tree operation table
+ */
+struct nilfs_btree {
+	struct nilfs_bmap bt_bmap;
+
+	/* B-tree-specific members */
+	const struct nilfs_btree_operations *bt_ops;
+};
+
+
+#define NILFS_BTREE_ROOT_SIZE		NILFS_BMAP_SIZE
+#define NILFS_BTREE_ROOT_NCHILDREN_MAX					\
+	((NILFS_BTREE_ROOT_SIZE - sizeof(struct nilfs_btree_node)) /	\
+	 (sizeof(__le64 /* dkey */) + sizeof(__le64 /* dptr */)))
+#define NILFS_BTREE_ROOT_NCHILDREN_MIN	0
+#define NILFS_BTREE_NODE_EXTRA_PAD_SIZE	(sizeof(__le64))
+#define NILFS_BTREE_NODE_NCHILDREN_MAX(nodesize)			\
+	(((nodesize) - sizeof(struct nilfs_btree_node) -		\
+		NILFS_BTREE_NODE_EXTRA_PAD_SIZE) /			\
+	 (sizeof(__le64 /* dkey */) + sizeof(__le64 /* dptr */)))
+#define NILFS_BTREE_NODE_NCHILDREN_MIN(nodesize)			\
+	((NILFS_BTREE_NODE_NCHILDREN_MAX(nodesize) - 1) / 2 + 1)
+#define NILFS_BTREE_KEY_MIN	((__u64)0)
+#define NILFS_BTREE_KEY_MAX	(~(__u64)0)
+
+
+int nilfs_btree_path_cache_init(void);
+void nilfs_btree_path_cache_destroy(void);
+int nilfs_btree_init(struct nilfs_bmap *, __u64, __u64);
+int nilfs_btree_convert_and_insert(struct nilfs_bmap *, __u64, __u64,
+				   const __u64 *, const __u64 *,
+				   int, __u64, __u64);
+void nilfs_btree_init_gc(struct nilfs_bmap *);
+
+#endif	/* _NILFS_BTREE_H */
diff -puN /dev/null fs/nilfs2/cpfile.c
--- /dev/null
+++ a/fs/nilfs2/cpfile.c
@@ -0,0 +1,1145 @@
+/*
+ * cpfile.c - NILFS checkpoint file.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/buffer_head.h>
+#include <linux/errno.h>
+#include <linux/nilfs2_fs.h>
+#include "mdt.h"
+#include "cpfile.h"
+
+
+static inline unsigned long
+nilfs_cpfile_checkpoints_per_block(const struct inode *cpfile)
+{
+	return (1UL << cpfile->i_blkbits) / sizeof(struct nilfs_checkpoint);
+}
+
+/* block number from the beginning of the file */
+static inline unsigned long
+nilfs_cpfile_get_blkoff(const struct inode *cpfile, __u64 cno)
+{
+	__u64 tcno;
+
+	/* checkpoint number 0 is invalid */
+	BUG_ON(cno == 0);
+	tcno = cno + NILFS_CPFILE_FIRST_CHECKPOINT_OFFSET - 1;
+	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
+	return (unsigned long)tcno;
+}
+
+/* offset in block */
+static inline unsigned long
+nilfs_cpfile_get_offset(const struct inode *cpfile, __u64 cno)
+{
+	__u64 tcno;
+
+	tcno = cno + NILFS_CPFILE_FIRST_CHECKPOINT_OFFSET - 1;
+	return do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
+}
+
+static inline unsigned long
+nilfs_cpfile_checkpoints_in_block(const struct inode *cpfile,
+				  __u64 curr,
+				  __u64 max)
+{
+	return min_t(__u64,
+		     nilfs_cpfile_checkpoints_per_block(cpfile) -
+		     nilfs_cpfile_get_offset(cpfile, curr),
+		     max - curr);
+}
+
+static inline int nilfs_cpfile_is_in_first(const struct inode *cpfile,
+					   __u64 cno)
+{
+	return nilfs_cpfile_get_blkoff(cpfile, cno) == 0;
+}
+
+static unsigned int
+nilfs_cpfile_block_add_valid_checkpoints(const struct inode *cpfile,
+					 struct buffer_head *bh,
+					 void *kaddr,
+					 unsigned int n)
+{
+	struct nilfs_checkpoint *cp;
+	unsigned int count;
+
+	cp = (struct nilfs_checkpoint *)(kaddr + bh_offset(bh));
+	count = le32_to_cpu(cp->cp_checkpoints_count) + n;
+	cp->cp_checkpoints_count = cpu_to_le32(count);
+	return count;
+}
+
+static unsigned int
+nilfs_cpfile_block_sub_valid_checkpoints(const struct inode *cpfile,
+					 struct buffer_head *bh,
+					 void *kaddr,
+					 unsigned int n)
+{
+	struct nilfs_checkpoint *cp;
+	unsigned int count;
+
+	cp = (struct nilfs_checkpoint *)(kaddr + bh_offset(bh));
+	BUG_ON(le32_to_cpu(cp->cp_checkpoints_count) < n);
+	count = le32_to_cpu(cp->cp_checkpoints_count) - n;
+	cp->cp_checkpoints_count = cpu_to_le32(count);
+	return count;
+}
+
+static inline struct nilfs_cpfile_header *
+nilfs_cpfile_block_get_header(const struct inode *cpfile,
+			      struct buffer_head *bh,
+			      void *kaddr)
+{
+	return (struct nilfs_cpfile_header *)(kaddr + bh_offset(bh));
+}
+
+static inline struct nilfs_checkpoint *
+nilfs_cpfile_block_get_checkpoint(const struct inode *cpfile,
+				  __u64 cno,
+				  struct buffer_head *bh,
+				  void *kaddr)
+{
+	return (struct nilfs_checkpoint *)(kaddr + bh_offset(bh)) +
+		nilfs_cpfile_get_offset(cpfile, cno);
+}
+
+static void nilfs_cpfile_block_init(struct inode *cpfile,
+				    struct buffer_head *bh,
+				    void *kaddr)
+{
+	struct nilfs_checkpoint *cp;
+	int i;
+
+	memset(kaddr + bh_offset(bh), 0, 1UL << cpfile->i_blkbits);
+	for (i = 0, cp = (struct nilfs_checkpoint *)(kaddr + bh_offset(bh));
+	     i < nilfs_cpfile_checkpoints_per_block(cpfile);
+	     i++, cp++)
+		nilfs_checkpoint_set_invalid(cp);
+}
+
+static int nilfs_cpfile_get_block(struct inode *cpfile,
+				  unsigned long blkoff,
+				  int create,
+				  struct buffer_head **bhp)
+{
+	struct buffer_head *bh;
+	int ret;
+
+	ret = nilfs_mdt_read_block(cpfile, blkoff, &bh);
+	if (ret < 0) {
+		if ((ret != -ENOENT) || !create)
+			return ret;
+		/* first block must be allocated by mkfs.nilfs */
+		BUG_ON(blkoff == 0);
+		ret = nilfs_mdt_create_block(cpfile, blkoff, &bh,
+					     nilfs_cpfile_block_init);
+		if (ret < 0)
+			return ret;
+	}
+
+	BUG_ON(bhp == NULL);
+	*bhp = bh;
+	return ret;
+}
+
+static inline int nilfs_cpfile_get_header_block(struct inode *cpfile,
+						struct buffer_head **bhp)
+{
+	return nilfs_cpfile_get_block(cpfile, 0, 0, bhp);
+}
+
+static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
+						    __u64 cno,
+						    int create,
+						    struct buffer_head **bhp)
+{
+	return nilfs_cpfile_get_block(cpfile,
+				      nilfs_cpfile_get_blkoff(cpfile, cno),
+				      create,
+				      bhp);
+}
+
+static inline int nilfs_cpfile_delete_checkpoint_block(struct inode *cpfile,
+						       __u64 cno)
+{
+	return nilfs_mdt_delete_block(cpfile,
+				      nilfs_cpfile_get_blkoff(cpfile, cno));
+}
+
+static inline unsigned long
+nilfs_cpfile_header_add_checkpoints(const struct inode *cpfile,
+				    struct nilfs_cpfile_header *header,
+				    unsigned long n)
+{
+	unsigned long ns;
+
+	ns = le64_to_cpu(header->ch_ncheckpoints) + n;
+	header->ch_ncheckpoints = cpu_to_le64(ns);
+	return ns;
+}
+
+static inline unsigned long
+nilfs_cpfile_header_sub_checkpoints(const struct inode *cpfile,
+				    struct nilfs_cpfile_header *header,
+				    unsigned long n)
+{
+	unsigned long ns;
+
+	BUG_ON(le64_to_cpu(header->ch_ncheckpoints) < n);
+	ns = le64_to_cpu(header->ch_ncheckpoints) - n;
+	header->ch_ncheckpoints = cpu_to_le64(ns);
+	return ns;
+}
+
+static inline unsigned long
+nilfs_cpfile_header_add_snapshots(const struct inode *cpfile,
+				  struct nilfs_cpfile_header *header,
+				  unsigned long n)
+{
+	unsigned long ns;
+
+	ns = le64_to_cpu(header->ch_nsnapshots) + n;
+	header->ch_nsnapshots = cpu_to_le64(ns);
+	return ns;
+}
+
+static inline unsigned long
+nilfs_cpfile_header_sub_snapshots(const struct inode *cpfile,
+				  struct nilfs_cpfile_header *header,
+				  unsigned long n)
+{
+	unsigned long ns;
+
+	BUG_ON(le64_to_cpu(header->ch_nsnapshots) < n);
+	ns = le64_to_cpu(header->ch_nsnapshots) - n;
+	header->ch_nsnapshots = cpu_to_le64(ns);
+	return ns;
+}
+
+/**
+ * nilfs_cpfile_get_checkpoint - get a checkpoint
+ * @cpfile: inode of checkpoint file
+ * @cno: checkpoint number
+ * @create: create flag
+ * @cpp: pointer to a checkpoint
+ * @bhp: pointer to a buffer head
+ *
+ * Description: nilfs_cpfile_get_checkpoint() acquires the checkpoint
+ * specified by @cno. A new checkpoint will be created if @cno is the current
+ * checkpoint number and @create is nonzero.
+ *
+ * Return Value: On success, 0 is returned, and the checkpoint and the
+ * buffer head of the buffer on which the checkpoint is located are stored in
+ * the place pointed by @cpp and @bhp, respectively. On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - No such checkpoint.
+ */
+int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
+				__u64 cno,
+				int create,
+				struct nilfs_checkpoint **cpp,
+				struct buffer_head **bhp)
+{
+	struct buffer_head *header_bh, *cp_bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	void *kaddr;
+	int ret;
+
+	BUG_ON((cno < 1) ||
+	       (cno > nilfs_mdt_cno(cpfile)) ||
+	       ((cno < nilfs_mdt_cno(cpfile)) && create));
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, create, &cp_bh);
+	if (ret < 0)
+		goto out_header;
+	kaddr = kmap(cp_bh->b_page);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	if (nilfs_checkpoint_invalid(cp)) {
+		if (!create) {
+			kunmap(cp_bh->b_page);
+			brelse(cp_bh);
+			ret = -ENOENT;
+			goto out_header;
+		}
+		/* a newly-created checkpoint */
+		nilfs_checkpoint_clear_invalid(cp);
+		if (!nilfs_cpfile_is_in_first(cpfile, cno))
+			nilfs_cpfile_block_add_valid_checkpoints(cpfile, cp_bh,
+								 kaddr, 1);
+		nilfs_mdt_mark_buffer_dirty(cp_bh);
+
+		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
+						       kaddr);
+		nilfs_cpfile_header_add_checkpoints(cpfile, header, 1);
+		kunmap_atomic(kaddr, KM_USER0);
+		nilfs_mdt_mark_buffer_dirty(header_bh);
+
+		nilfs_mdt_mark_dirty(cpfile);
+	}
+
+	if (cpp != NULL)
+		*cpp = cp;
+	BUG_ON(bhp == NULL);
+	*bhp = cp_bh;
+
+ out_header:
+	brelse(header_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_cpfile_put_checkpoint - put a checkpoint
+ * @cpfile: inode of checkpoint file
+ * @cno: checkpoint number
+ * @bh: buffer head
+ *
+ * Description: nilfs_cpfile_put_checkpoint() releases the checkpoint
+ * specified by @cno. @bh must be the buffer head which has been returned by
+ * a previous call to nilfs_cpfile_get_checkpoint() with @cno.
+ */
+void nilfs_cpfile_put_checkpoint(struct inode *cpfile,
+				 __u64 cno,
+				 struct buffer_head *bh)
+{
+	/* XXX: must check cno */
+	kunmap(bh->b_page);
+	brelse(bh);
+}
+
+/**
+ * nilfs_cpfile_delete_checkpoints - delete checkpoints
+ * @cpfile: inode of checkpoint file
+ * @start: start checkpoint number
+ * @end: end checkpoint numer
+ *
+ * Description: nilfs_cpfile_delete_checkpoints() deletes the checkpoints in
+ * the period from @start to @end, excluding @end itself. The checkpoints
+ * which have been already deleted are ignored.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - invalid checkpoints.
+ */
+int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
+				    __u64 start,
+				    __u64 end)
+{
+	struct buffer_head *header_bh, *cp_bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	__u64 cno;
+	void *kaddr;
+	unsigned long tnicps;
+	int ret, ncps, nicps, count, i;
+
+	if ((start == 0) || (start > end)) {
+		printk(KERN_CRIT "%s: start = %llu, end = %llu\n",
+		       __func__,
+		       (unsigned long long)start,
+		       (unsigned long long)end);
+		BUG();
+	}
+
+	/* cannot delete the latest checkpoint */
+	if (start == nilfs_mdt_cno(cpfile) - 1)
+		return -EPERM;
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+	tnicps = 0;
+
+	for (cno = start; cno < end; cno += ncps) {
+		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, end);
+		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out_sem;
+			/* skip hole */
+			ret = 0;
+			continue;
+		}
+
+		kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+		cp = nilfs_cpfile_block_get_checkpoint(
+			cpfile, cno, cp_bh, kaddr);
+		nicps = 0;
+		for (i = 0; i < ncps; i++, cp++) {
+			BUG_ON(nilfs_checkpoint_snapshot(cp));
+			if (!nilfs_checkpoint_invalid(cp)) {
+				nilfs_checkpoint_set_invalid(cp);
+				nicps++;
+			}
+		}
+		if (nicps > 0) {
+			tnicps += nicps;
+			nilfs_mdt_mark_buffer_dirty(cp_bh);
+			nilfs_mdt_mark_dirty(cpfile);
+			if (!nilfs_cpfile_is_in_first(cpfile, cno) &&
+			    ((count = nilfs_cpfile_block_sub_valid_checkpoints(
+				      cpfile, cp_bh, kaddr, nicps)) == 0)) {
+				/* make hole */
+				kunmap_atomic(kaddr, KM_USER0);
+				brelse(cp_bh);
+				ret = nilfs_cpfile_delete_checkpoint_block(
+					cpfile, cno);
+				if (ret < 0) {
+					printk(KERN_ERR
+					       "%s: cannot delete block\n",
+					       __func__);
+					goto out_sem;
+				}
+				continue;
+			}
+		}
+
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(cp_bh);
+	}
+
+	if (tnicps > 0) {
+		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
+						       kaddr);
+		nilfs_cpfile_header_sub_checkpoints(cpfile, header, tnicps);
+		nilfs_mdt_mark_buffer_dirty(header_bh);
+		nilfs_mdt_mark_dirty(cpfile);
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+	brelse(header_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_cpfile_get_checkpoints -
+ * @cpfile: inode of checkpoint file
+ * @cno: checkpoint number to start looking
+ * @cps: array of checkpoint
+ * @size: size of checkpoint array
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned and .... On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_cpfile_get_checkpoints(struct inode *cpfile,
+				 __u64 cno,
+				 struct nilfs_checkpoint *cps,
+				 unsigned long *size)
+{
+	struct nilfs_checkpoint *cp;
+	struct buffer_head *bh;
+	void *kaddr;
+	unsigned long n;
+	int ncps, ret, i;
+
+	down_read(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = 0;
+	for (n = 0; (cno < nilfs_mdt_cno(cpfile)) && (n < *size); cno += ncps) {
+		ncps = nilfs_cpfile_checkpoints_in_block(
+			cpfile, cno, nilfs_mdt_cno(cpfile));
+		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out;
+			/* skip hole */
+			continue;
+		}
+
+		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
+		for (i = 0; (i < ncps) && (n < *size); i++, cp++) {
+			if (!nilfs_checkpoint_invalid(cp))
+				cps[n++] = *cp;	/* copy structure */
+		}
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(bh);
+	}
+
+ out:
+	*size = n;
+
+	up_read(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+static void nilfs_cpfile_checkpoint_to_cpinfo(struct inode *cpfile,
+					      struct nilfs_checkpoint *cp,
+					      struct nilfs_cpinfo *ci)
+{
+	ci->ci_flags = le32_to_cpu(cp->cp_flags);
+	ci->ci_cno = le64_to_cpu(cp->cp_cno);
+	ci->ci_create = le64_to_cpu(cp->cp_create);
+	ci->ci_nblk_inc = le64_to_cpu(cp->cp_nblk_inc);
+	ci->ci_inodes_count = le64_to_cpu(cp->cp_inodes_count);
+	ci->ci_blocks_count = le64_to_cpu(cp->cp_blocks_count);
+	ci->ci_next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
+}
+
+static ssize_t
+nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 cno,
+			   struct nilfs_cpinfo *ci, size_t nci)
+{
+	struct nilfs_checkpoint *cp;
+	struct buffer_head *bh;
+	void *kaddr;
+	int n, ret;
+	int ncps, i;
+
+	down_read(&NILFS_MDT(cpfile)->mi_sem);
+
+	for (n = 0; (cno < nilfs_mdt_cno(cpfile)) && (n < nci); cno += ncps) {
+		ncps = nilfs_cpfile_checkpoints_in_block(
+			cpfile, cno, nilfs_mdt_cno(cpfile));
+		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out;
+			/* skip hole */
+			continue;
+		}
+
+		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
+		for (i = 0; (i < ncps) && (n < nci); i++, cp++) {
+			if (!nilfs_checkpoint_invalid(cp))
+				nilfs_cpfile_checkpoint_to_cpinfo(
+					cpfile, cp, &ci[n++]);
+		}
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(bh);
+	}
+
+	ret = n;
+
+ out:
+	up_read(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+static ssize_t
+nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
+			   struct nilfs_cpinfo *ci, size_t nci)
+{
+	struct buffer_head *bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	__u64 curr, next;
+	unsigned long curr_blkoff, next_blkoff;
+	void *kaddr;
+	int n, ret;
+
+	down_read(&NILFS_MDT(cpfile)->mi_sem);
+
+	if (cno == 0) {
+		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
+		if (ret < 0)
+			goto out;
+		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
+		curr = le64_to_cpu(header->ch_snapshot_list.ssl_next);
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(bh);
+		if (curr == 0) {
+			ret = 0;
+			goto out;
+		}
+	} else
+		curr = cno;
+	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
+	if (ret < 0)
+		goto out;
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	for (n = 0; n < nci; n++) {
+		cp = nilfs_cpfile_block_get_checkpoint(
+			cpfile, curr, bh, kaddr);
+		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n]);
+		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
+		if (next == 0) {
+			curr = next;
+			n++;
+			break;
+		}
+		next_blkoff = nilfs_cpfile_get_blkoff(cpfile, next);
+		if (curr_blkoff != next_blkoff) {
+			kunmap_atomic(kaddr, KM_USER0);
+			brelse(bh);
+			ret = nilfs_cpfile_get_checkpoint_block(cpfile, next,
+								0, &bh);
+			if (ret < 0)
+				goto out;
+			kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		}
+		curr = next;
+		curr_blkoff = next_blkoff;
+	}
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(bh);
+	ret = n;
+
+ out:
+	up_read(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_cpfile_get_cpinfo -
+ * @cpfile:
+ * @cno:
+ * @ci:
+ * @nci:
+ */
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile,
+				__u64 cno, int mode,
+				struct nilfs_cpinfo *ci, size_t nci)
+{
+	switch (mode) {
+	case NILFS_CHECKPOINT:
+		return nilfs_cpfile_do_get_cpinfo(cpfile, cno, ci, nci);
+	case NILFS_SNAPSHOT:
+		return nilfs_cpfile_do_get_ssinfo(cpfile, cno, ci, nci);
+	default:
+		return -EINVAL;
+	}
+}
+
+/**
+ * nilfs_cpfile_delete_checkpoint -
+ * @cpfile:
+ * @cno:
+ */
+int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
+{
+	struct nilfs_cpinfo ci;
+	ssize_t nci;
+	int ret;
+
+	/* checkpoint number 0 is invalid */
+	if (cno == 0)
+		return -ENOENT;
+	nci = nilfs_cpfile_do_get_cpinfo(cpfile, cno, &ci, 1);
+	if (nci < 0)
+		return nci;
+	else if ((nci == 0) || (ci.ci_cno != cno))
+		return -ENOENT;
+
+	/* cannot delete the latest checkpoint nor snapshots */
+	ret = nilfs_cpinfo_snapshot(&ci);
+	if (ret < 0)
+		return ret;
+	else if ((ret > 0) || (cno == nilfs_mdt_cno(cpfile) - 1))
+		return -EPERM;
+
+	return nilfs_cpfile_delete_checkpoints(cpfile, cno, cno + 1);
+}
+
+static struct nilfs_snapshot_list *
+nilfs_cpfile_block_get_snapshot_list(const struct inode *cpfile,
+				     __u64 cno,
+				     struct buffer_head *bh,
+				     void *kaddr)
+{
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	struct nilfs_snapshot_list *list;
+
+	if (cno != 0) {
+		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
+		list = &cp->cp_snapshot_list;
+	} else {
+		header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
+		list = &header->ch_snapshot_list;
+	}
+	return list;
+}
+
+static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
+{
+	struct buffer_head *header_bh, *curr_bh, *prev_bh, *cp_bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	struct nilfs_snapshot_list *list;
+	__u64 curr, prev;
+	unsigned long curr_blkoff, prev_blkoff;
+	void *kaddr;
+	int ret;
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
+	if (ret < 0)
+		goto out_sem;
+	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	if (nilfs_checkpoint_invalid(cp)) {
+		ret = -ENOENT;
+		kunmap_atomic(kaddr, KM_USER0);
+		goto out_cp;
+	}
+	if (nilfs_checkpoint_snapshot(cp)) {
+		ret = 0;
+		kunmap_atomic(kaddr, KM_USER0);
+		goto out_cp;
+	}
+	kunmap_atomic(kaddr, KM_USER0);
+
+	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
+	if (ret < 0)
+		goto out_cp;
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
+	list = &header->ch_snapshot_list;
+	curr_bh = header_bh;
+	get_bh(curr_bh);
+	curr = 0;
+	curr_blkoff = 0;
+	prev = le64_to_cpu(list->ssl_prev);
+	while (prev > cno) {
+		prev_blkoff = nilfs_cpfile_get_blkoff(cpfile, prev);
+		curr = prev;
+		if (curr_blkoff != prev_blkoff) {
+			kunmap_atomic(kaddr, KM_USER0);
+			brelse(curr_bh);
+			ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr,
+								0, &curr_bh);
+			if (ret < 0)
+				goto out_header;
+			kaddr = kmap_atomic(curr_bh->b_page, KM_USER0);
+		}
+		curr_blkoff = prev_blkoff;
+		cp = nilfs_cpfile_block_get_checkpoint(
+			cpfile, curr, curr_bh, kaddr);
+		list = &cp->cp_snapshot_list;
+		prev = le64_to_cpu(list->ssl_prev);
+	}
+	kunmap_atomic(kaddr, KM_USER0);
+
+	if (prev != 0) {
+		ret = nilfs_cpfile_get_checkpoint_block(cpfile, prev, 0,
+							&prev_bh);
+		if (ret < 0)
+			goto out_curr;
+	} else {
+		prev_bh = header_bh;
+		get_bh(prev_bh);
+	}
+
+	kaddr = kmap_atomic(curr_bh->b_page, KM_USER0);
+	list = nilfs_cpfile_block_get_snapshot_list(
+		cpfile, curr, curr_bh, kaddr);
+	list->ssl_prev = cpu_to_le64(cno);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	cp->cp_snapshot_list.ssl_next = cpu_to_le64(curr);
+	cp->cp_snapshot_list.ssl_prev = cpu_to_le64(prev);
+	nilfs_checkpoint_set_snapshot(cp);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(prev_bh->b_page, KM_USER0);
+	list = nilfs_cpfile_block_get_snapshot_list(
+		cpfile, prev, prev_bh, kaddr);
+	list->ssl_next = cpu_to_le64(cno);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
+	nilfs_cpfile_header_add_snapshots(cpfile, header, 1);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(prev_bh);
+	nilfs_mdt_mark_buffer_dirty(curr_bh);
+	nilfs_mdt_mark_buffer_dirty(cp_bh);
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_mdt_mark_dirty(cpfile);
+
+	brelse(prev_bh);
+
+ out_curr:
+	brelse(curr_bh);
+
+ out_header:
+	brelse(header_bh);
+
+ out_cp:
+	brelse(cp_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
+{
+	struct buffer_head *header_bh, *next_bh, *prev_bh, *cp_bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	struct nilfs_snapshot_list *list;
+	__u64 next, prev;
+	void *kaddr;
+	int ret;
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
+	if (ret < 0)
+		goto out_sem;
+	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	if (nilfs_checkpoint_invalid(cp)) {
+		ret = -ENOENT;
+		kunmap_atomic(kaddr, KM_USER0);
+		goto out_cp;
+	}
+	if (!nilfs_checkpoint_snapshot(cp)) {
+		ret = 0;
+		kunmap_atomic(kaddr, KM_USER0);
+		goto out_cp;
+	}
+
+	list = &cp->cp_snapshot_list;
+	next = le64_to_cpu(list->ssl_next);
+	prev = le64_to_cpu(list->ssl_prev);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
+	if (ret < 0)
+		goto out_cp;
+	if (next != 0) {
+		ret = nilfs_cpfile_get_checkpoint_block(cpfile, next, 0,
+							&next_bh);
+		if (ret < 0)
+			goto out_header;
+	} else {
+		next_bh = header_bh;
+		get_bh(next_bh);
+	}
+	if (prev != 0) {
+		ret = nilfs_cpfile_get_checkpoint_block(cpfile, prev, 0,
+							&prev_bh);
+		if (ret < 0)
+			goto out_next;
+	} else {
+		prev_bh = header_bh;
+		get_bh(prev_bh);
+	}
+
+	kaddr = kmap_atomic(next_bh->b_page, KM_USER0);
+	list = nilfs_cpfile_block_get_snapshot_list(
+		cpfile, next, next_bh, kaddr);
+	list->ssl_prev = cpu_to_le64(prev);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(prev_bh->b_page, KM_USER0);
+	list = nilfs_cpfile_block_get_snapshot_list(
+		cpfile, prev, prev_bh, kaddr);
+	list->ssl_next = cpu_to_le64(next);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	cp->cp_snapshot_list.ssl_next = cpu_to_le64(0);
+	cp->cp_snapshot_list.ssl_prev = cpu_to_le64(0);
+	nilfs_checkpoint_clear_snapshot(cp);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
+	nilfs_cpfile_header_sub_snapshots(cpfile, header, 1);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(next_bh);
+	nilfs_mdt_mark_buffer_dirty(prev_bh);
+	nilfs_mdt_mark_buffer_dirty(cp_bh);
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_mdt_mark_dirty(cpfile);
+
+	brelse(prev_bh);
+
+ out_next:
+	brelse(next_bh);
+
+ out_header:
+	brelse(header_bh);
+
+ out_cp:
+	brelse(cp_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_cpfile_is_snapshot -
+ * @cpfile: inode of checkpoint file
+ * @cno: checkpoint number
+ *
+ * Description:
+ *
+ * Return Value: On success, 1 is returned if the checkpoint specified by
+ * @cno is a snapshot, or 0 if not. On error, one of the following negative
+ * error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - No such checkpoint.
+ */
+int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
+{
+	struct buffer_head *bh;
+	struct nilfs_checkpoint *cp;
+	void *kaddr;
+	int ret;
+
+	down_read(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
+	if (ret < 0)
+		goto out;
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
+	ret = nilfs_checkpoint_snapshot(cp);
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(bh);
+
+ out:
+	up_read(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_cpfile_change_cpmode - change checkpoint mode
+ * @cpfile: inode of checkpoint file
+ * @cno: checkpoint number
+ * @status: mode of checkpoint
+ *
+ * Description: nilfs_change_cpmode() changes the mode of the checkpoint
+ * specified by @cno. The mode @mode is NILFS_CHECKPOINT or NILFS_SNAPSHOT.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - No such checkpoint.
+ */
+int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
+{
+	struct the_nilfs *nilfs;
+	int ret;
+
+	nilfs = NILFS_MDT(cpfile)->mi_nilfs;
+
+	switch (mode) {
+	case NILFS_CHECKPOINT:
+		/*
+		 * Check for protecting existing snapshot mounts:
+		 * bd_mount_sem is used to make this operation atomic and
+		 * exclusive with a new mount job.  Though it doesn't cover
+		 * umount, it's enough for the purpose.
+		 */
+		down(&nilfs->ns_bdev->bd_mount_sem);
+		if (nilfs_checkpoint_is_mounted(nilfs, cno, 1)) {
+			/* Current implementation does not have to protect
+			   plain read-only mounts since they are exclusive
+			   with a read/write mount and are protected from the
+			   cleaner. */
+			ret = -EBUSY;
+		} else
+			ret = nilfs_cpfile_clear_snapshot(cpfile, cno);
+		up(&nilfs->ns_bdev->bd_mount_sem);
+		return ret;
+	case NILFS_SNAPSHOT:
+		return nilfs_cpfile_set_snapshot(cpfile, cno);
+	default:
+		return -EINVAL;
+	}
+}
+
+/**
+ * nilfs_cpfile_get_stat - get checkpoint statistics
+ * @cpfile: inode of checkpoint file
+ * @stat: pointer to a structure of checkpoint statistics
+ *
+ * Description: nilfs_cpfile_get_stat() returns information about checkpoints.
+ *
+ * Return Value: On success, 0 is returned, and checkpoints information is
+ * stored in the place pointed by @stat. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
+{
+	struct buffer_head *bh;
+	struct nilfs_cpfile_header *header;
+	void *kaddr;
+	int ret;
+
+	down_read(&NILFS_MDT(cpfile)->mi_sem);
+
+	ret = nilfs_cpfile_get_header_block(cpfile, &bh);
+	if (ret < 0)
+		goto out_sem;
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
+	cpstat->cs_cno = nilfs_mdt_cno(cpfile);
+	cpstat->cs_ncps = le64_to_cpu(header->ch_ncheckpoints);
+	cpstat->cs_nsss = le64_to_cpu(header->ch_nsnapshots);
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(bh);
+
+ out_sem:
+	up_read(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_cpfile_get_snapshots -
+ * @cpfile: inode of checkpoint file
+ * @snapshots: array of checkpoint number
+ * @size: size of snapshots array
+ * @next: checkpoint number of next snapshot
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned and .... On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_cpfile_get_snapshots(struct inode *cpfile,
+			       __u64 *snapshots,
+			       unsigned long *size,
+			       __u64 *cno)
+{
+	struct buffer_head *bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	__u64 curr, next;
+	unsigned long curr_blkoff, next_blkoff;
+	void *kaddr;
+	unsigned long n;
+	int ret;
+
+	BUG_ON((size == NULL) || (cno == NULL));
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+
+	if (*cno == 0) {
+		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
+		if (ret < 0)
+			goto out_sem;
+		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
+		curr = le64_to_cpu(header->ch_snapshot_list.ssl_next);
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(bh);
+		if (curr == 0) {
+			n = 0;
+			goto out_assign;
+		}
+	} else
+		curr = *cno;
+	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
+	if (ret < 0)
+		goto out_sem;
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	for (n = 0; n < *size; n++) {
+		snapshots[n] = curr;
+
+		cp = nilfs_cpfile_block_get_checkpoint(cpfile, curr, bh, kaddr);
+		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
+		if (next == 0) {
+			curr = next;
+			n++;
+			break;
+		}
+		next_blkoff = nilfs_cpfile_get_blkoff(cpfile, next);
+		if (curr_blkoff != next_blkoff) {
+			kunmap_atomic(kaddr, KM_USER0);
+			brelse(bh);
+			ret = nilfs_cpfile_get_checkpoint_block(cpfile, next,
+								0, &bh);
+			if (ret < 0)
+				goto out_sem;
+			kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		}
+		curr = next;
+		curr_blkoff = next_blkoff;
+	}
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(bh);
+
+ out_assign:
+	*size = n;
+	*cno = curr;
+
+ out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
diff -puN /dev/null fs/nilfs2/cpfile.h
--- /dev/null
+++ a/fs/nilfs2/cpfile.h
@@ -0,0 +1,50 @@
+/*
+ * cpfile.h - NILFS checkpoint file.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_CPFILE_H
+#define _NILFS_CPFILE_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+
+#define NILFS_CPFILE_GFP	NILFS_MDT_GFP
+
+
+int nilfs_cpfile_get_checkpoint(struct inode *, __u64, int,
+				struct nilfs_checkpoint **,
+				struct buffer_head **);
+void nilfs_cpfile_put_checkpoint(struct inode *, __u64, struct buffer_head *);
+int nilfs_cpfile_delete_checkpoints(struct inode *, __u64, __u64);
+int nilfs_cpfile_delete_checkpoint(struct inode *, __u64);
+int nilfs_cpfile_get_checkpoints(struct inode *, __u64,
+				 struct nilfs_checkpoint *, unsigned long *);
+int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
+int nilfs_cpfile_is_snapshot(struct inode *, __u64);
+int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
+int nilfs_cpfile_get_snapshots(struct inode *, __u64 *, unsigned long *,
+			       __u64 *);
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64, int,
+				struct nilfs_cpinfo *, size_t);
+
+
+#endif	/* _NILFS_CPFILE_H */
diff -puN /dev/null fs/nilfs2/dat.c
--- /dev/null
+++ a/fs/nilfs2/dat.c
@@ -0,0 +1,1125 @@
+/*
+ * dat.c - NILFS disk address translation.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include "nilfs.h"	/* XXX: nilfs_error() */
+#include "sb.h"
+#include "mdt.h"
+#include "dat.h"
+
+
+#define NILFS_CNO_MIN	((__u64)1)
+#define NILFS_CNO_MAX	(~(__u64)0)
+
+static inline unsigned long
+nilfs_dat_groups_per_desc_block(const struct inode *dat)
+{
+	return (1UL << dat->i_blkbits) / sizeof(struct nilfs_dat_group_desc);
+}
+
+static inline unsigned long
+nilfs_dat_blocks_per_group(const struct inode *dat)
+{
+	/* including a bitmap block */
+	return (nilfs_dat_entries_per_group(dat) - 1) /
+		nilfs_dat_entries_per_block(dat) + 1 +
+		1;
+}
+
+static inline unsigned long
+nilfs_dat_blocks_per_desc_block(const struct inode *dat)
+{
+	/* including a group descriptor block and group bitmap blocks */
+	return nilfs_dat_groups_per_desc_block(dat) *
+		nilfs_dat_blocks_per_group(dat) + 1;
+}
+
+static inline unsigned long
+nilfs_dat_group(const struct inode *dat, __u64 vblocknr)
+{
+	__u64 group = vblocknr;
+
+	do_div(group, nilfs_dat_entries_per_group(dat));
+	return group;
+}
+
+static inline unsigned long
+nilfs_dat_group_offset(const struct inode *dat, __u64 vblocknr)
+{
+	return do_div(vblocknr, nilfs_dat_entries_per_group(dat));
+}
+
+static inline unsigned long
+nilfs_dat_desc_block(const struct inode *dat, unsigned long group)
+{
+	return group / nilfs_dat_groups_per_desc_block(dat);
+}
+
+static inline unsigned long
+nilfs_dat_desc_offset(const struct inode *dat, unsigned long group)
+{
+	return group % nilfs_dat_groups_per_desc_block(dat);
+}
+
+static inline unsigned long
+nilfs_dat_entry_block(const struct inode *dat, unsigned long group_offset)
+{
+	return group_offset / nilfs_dat_entries_per_block(dat);
+}
+
+static inline unsigned long
+nilfs_dat_entry_offset(const struct inode *dat, __u64 vblocknr)
+{
+	return nilfs_dat_group_offset(dat, vblocknr) %
+		nilfs_dat_entries_per_block(dat);
+}
+
+static inline unsigned long
+nilfs_dat_rest_groups_in_desc_block(const struct inode *dat,
+				    unsigned long curr, unsigned long max)
+{
+	return min_t(unsigned long,
+		     nilfs_dat_groups_per_desc_block(dat) -
+		     nilfs_dat_desc_offset(dat, curr),
+		     max - curr + 1);
+}
+
+static inline unsigned long
+nilfs_dat_desc_blkoff(const struct inode *dat, unsigned long group)
+{
+	return nilfs_dat_desc_block(dat, group) *
+		nilfs_dat_blocks_per_desc_block(dat);
+}
+
+static inline unsigned long
+nilfs_dat_bitmap_blkoff(const struct inode *dat, unsigned long group)
+{
+	return nilfs_dat_desc_blkoff(dat, group) + 1 +
+		nilfs_dat_desc_offset(dat, group) *
+		nilfs_dat_blocks_per_group(dat);
+}
+
+static inline unsigned long
+nilfs_dat_entry_blkoff(const struct inode *dat, __u64 vblocknr)
+{
+	return nilfs_dat_bitmap_blkoff(dat, nilfs_dat_group(dat, vblocknr)) +
+		1 +
+		nilfs_dat_entry_block(dat,
+				      nilfs_dat_group_offset(dat, vblocknr));
+}
+
+static inline unsigned long
+nilfs_dat_group_desc_get_nfrees(struct inode *dat,
+				unsigned long group,
+				const struct nilfs_dat_group_desc *desc)
+{
+	unsigned long nfree;
+
+	spin_lock(nilfs_mdt_bgl_lock(dat, group));
+	nfree = le32_to_cpu(desc->dg_nfrees);
+	spin_unlock(nilfs_mdt_bgl_lock(dat, group));
+
+	return nfree;
+}
+
+static inline void
+nilfs_dat_group_desc_set_nfrees(const struct inode *dat,
+				struct nilfs_dat_group_desc *desc,
+				unsigned long nfrees)
+{
+	desc->dg_nfrees = cpu_to_le32(nfrees);
+}
+
+static inline unsigned long
+nilfs_dat_group_desc_add_entries(struct inode *dat,
+				 unsigned long group,
+				 struct nilfs_dat_group_desc *desc,
+				 unsigned long n)
+{
+	unsigned long nfrees;
+
+	spin_lock(nilfs_mdt_bgl_lock(dat, group));
+	nfrees = le32_to_cpu(desc->dg_nfrees) + n;
+	desc->dg_nfrees = cpu_to_le32(nfrees);
+	spin_unlock(nilfs_mdt_bgl_lock(dat, group));
+
+	return nfrees;
+}
+
+static inline unsigned long
+nilfs_dat_group_desc_sub_entries(struct inode *dat,
+				 unsigned long group,
+				 struct nilfs_dat_group_desc *desc,
+				 unsigned long n)
+{
+	unsigned long nfrees;
+
+	spin_lock(nilfs_mdt_bgl_lock(dat, group));
+	nfrees = le32_to_cpu(desc->dg_nfrees) - n;
+	desc->dg_nfrees = cpu_to_le32(nfrees);
+	spin_unlock(nilfs_mdt_bgl_lock(dat, group));
+
+	return nfrees;
+}
+
+static inline __u64
+nilfs_dat_entry_get_start(const struct inode *dat,
+			  const struct nilfs_dat_entry *entry)
+{
+	return le64_to_cpu(entry->de_start);
+}
+
+static inline void nilfs_dat_entry_set_start(const struct inode *dat,
+					     struct nilfs_dat_entry *entry,
+					     __u64 start)
+{
+	entry->de_start = cpu_to_le64(start);
+}
+
+static inline __u64
+nilfs_dat_entry_get_end(const struct inode *dat,
+			const struct nilfs_dat_entry *entry)
+{
+	return le64_to_cpu(entry->de_end);
+}
+
+static inline void nilfs_dat_entry_set_end(const struct inode *dat,
+					   struct nilfs_dat_entry *entry,
+					   __u64 end)
+{
+	entry->de_end = cpu_to_le64(end);
+}
+
+static inline sector_t
+nilfs_dat_entry_get_blocknr(const struct inode *dat,
+			    const struct nilfs_dat_entry *entry)
+{
+	return le64_to_cpu(entry->de_blocknr);
+}
+
+static inline void nilfs_dat_entry_set_blocknr(const struct inode *dat,
+					       struct nilfs_dat_entry *entry,
+					       sector_t blocknr)
+{
+	entry->de_blocknr = cpu_to_le64(blocknr);
+}
+
+static void nilfs_dat_desc_block_init(struct inode *dat,
+				      struct buffer_head *bh,
+				      void *kaddr)
+{
+	struct nilfs_dat_group_desc *desc;
+	unsigned long i;
+
+	for (i = 0, desc = (struct nilfs_dat_group_desc *)
+		     (kaddr + bh_offset(bh));
+	     i < nilfs_dat_groups_per_desc_block(dat);
+	     i++, desc++)
+		nilfs_dat_group_desc_set_nfrees(
+			dat, desc, nilfs_dat_entries_per_group(dat));
+}
+
+#define nilfs_dat_bitmap_block_init	NULL
+
+static inline int nilfs_dat_get_desc_block(struct inode *dat,
+					   unsigned long group,
+					   int create,
+					   struct buffer_head **bhp)
+{
+	return nilfs_mdt_get_block(dat, nilfs_dat_desc_blkoff(dat, group),
+				   create, nilfs_dat_desc_block_init, bhp);
+}
+
+static inline int nilfs_dat_get_bitmap_block(struct inode *dat,
+					     unsigned long group,
+					     int create,
+					     struct buffer_head **bhp)
+{
+	return nilfs_mdt_get_block(dat, nilfs_dat_bitmap_blkoff(dat, group),
+				   create, nilfs_dat_bitmap_block_init, bhp);
+}
+
+static inline int
+nilfs_dat_get_entry_block(struct inode *dat, __u64 vblocknr, int create,
+			  struct buffer_head **bhp)
+{
+	return nilfs_mdt_get_block(dat, nilfs_dat_entry_blkoff(dat, vblocknr),
+				   create, NULL, bhp);
+}
+
+static inline struct nilfs_dat_group_desc *
+nilfs_dat_block_get_group_desc(const struct inode *dat,
+			       unsigned long group,
+			       const struct buffer_head *bh,
+			       void *kaddr)
+{
+	return (struct nilfs_dat_group_desc *)(kaddr + bh_offset(bh)) +
+		nilfs_dat_desc_offset(dat, group);
+}
+
+static inline unsigned char *
+nilfs_dat_block_get_bitmap(const struct inode *dat,
+			   const struct buffer_head *bh,
+			   void *kaddr)
+{
+	return (unsigned char *)(kaddr + bh_offset(bh));
+}
+
+static inline struct nilfs_dat_entry *
+nilfs_dat_block_get_entry(const struct inode *dat,
+			  __u64 vblocknr,
+			  const struct buffer_head *bh,
+			  void *kaddr)
+{
+	return (struct nilfs_dat_entry *)(kaddr + bh_offset(bh)) +
+		nilfs_dat_entry_offset(dat, vblocknr);
+}
+
+
+static int
+nilfs_dat_group_find_available_vblocknr(struct inode *dat,
+					unsigned long group,
+					unsigned long target,
+					unsigned char *bitmap,
+					int size)	/* size in bits */
+{
+	int curr, end, result, i;
+
+	if (target > 0) {
+		end = (target + BITS_PER_LONG - 1) & ~(BITS_PER_LONG - 1);
+		if (end > size)
+			end = size;
+		result = nilfs_dat_find_next_zero_bit(bitmap, end, target);
+		if ((result < end) &&
+		    !nilfs_dat_set_bit_atomic(nilfs_mdt_bgl_lock(dat, group),
+					      result, bitmap))
+			return result;
+	} else
+		end = 0;
+
+	for (i = 0, curr = end;
+	     i < size;
+	     i += BITS_PER_LONG, curr += BITS_PER_LONG) {
+		/* wrap around */
+		if (curr >= size)
+			curr = 0;
+		while (*((unsigned long *)bitmap + curr / BITS_PER_LONG)
+		       != ~0UL) {
+			end = curr + BITS_PER_LONG;
+			if (end > size)
+				end = size;
+			result = nilfs_dat_find_next_zero_bit(
+				bitmap, end, curr);
+			if ((result < end) &&
+			    !nilfs_dat_set_bit_atomic(
+				    nilfs_mdt_bgl_lock(dat, group),
+				    result, bitmap))
+				return result;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static int nilfs_dat_prepare_alloc_vblocknr(struct inode *dat,
+					    struct nilfs_dat_req *req)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	struct nilfs_dat_group_desc *desc;
+	unsigned char *bitmap;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned long group, maxgroup, ngroups;
+	unsigned long  group_offset;
+	unsigned long n, entries_per_group, groups_per_desc_block;
+	unsigned long i, j;
+	int res, ret;
+
+	ngroups = NILFS_MDT(dat)->mi_groups_count;
+	maxgroup = ngroups - 1;
+	group = nilfs_dat_group(dat, req->dr_vblocknr);
+	group_offset = nilfs_dat_group_offset(dat, req->dr_vblocknr);
+	entries_per_group = nilfs_dat_entries_per_group(dat);
+	groups_per_desc_block = nilfs_dat_groups_per_desc_block(dat);
+	for (i = 0; i < ngroups; i += n) {
+		if (group >= ngroups) {
+			/* wrap around */
+			group = 0;
+			maxgroup = nilfs_dat_group(dat, req->dr_vblocknr) - 1;
+		}
+		ret = nilfs_dat_get_desc_block(dat, group, 1, &desc_bh);
+		if (ret < 0)
+			return ret;
+		desc_kaddr = kmap(desc_bh->b_page);
+		desc = nilfs_dat_block_get_group_desc(
+			dat, group, desc_bh, desc_kaddr);
+		n = nilfs_dat_rest_groups_in_desc_block(dat, group, maxgroup);
+		for (j = 0; j < n; j++, desc++, group++) {
+			if (nilfs_dat_group_desc_get_nfrees(
+				    dat, group, desc) > 0) {
+				ret = nilfs_dat_get_bitmap_block(dat, group, 1,
+								 &bitmap_bh);
+				if (ret < 0)
+					goto out_desc;
+				bitmap_kaddr = kmap(bitmap_bh->b_page);
+				bitmap = nilfs_dat_block_get_bitmap(
+					dat, bitmap_bh, bitmap_kaddr);
+				res = nilfs_dat_group_find_available_vblocknr(
+					dat, group, group_offset, bitmap,
+					entries_per_group);
+				if (res >= 0) {
+					nilfs_dat_group_desc_sub_entries(
+						dat, group, desc, 1);
+					req->dr_vblocknr =
+						entries_per_group * group + res;
+					kunmap(desc_bh->b_page);
+					kunmap(bitmap_bh->b_page);
+
+					req->dr_desc_bh = desc_bh;
+					req->dr_bitmap_bh = bitmap_bh;
+					return 0;
+				}
+				kunmap(bitmap_bh->b_page);
+				brelse(bitmap_bh);
+			}
+
+			group_offset = 0;
+		}
+
+		kunmap(desc_bh->b_page);
+		brelse(desc_bh);
+	}
+
+	/* no virtual block numbers left */
+	return -ENOSPC;
+
+ out_desc:
+	kunmap(desc_bh->b_page);
+	brelse(desc_bh);
+	return ret;
+}
+
+static void nilfs_dat_commit_alloc_vblocknr(struct inode *dat,
+					    struct nilfs_dat_req *req)
+{
+	nilfs_mdt_mark_buffer_dirty(req->dr_bitmap_bh);
+	nilfs_mdt_mark_buffer_dirty(req->dr_desc_bh);
+	nilfs_mdt_mark_dirty(dat);
+
+	brelse(req->dr_bitmap_bh);
+	brelse(req->dr_desc_bh);
+}
+
+static void nilfs_dat_abort_alloc_vblocknr(struct inode *dat,
+					   struct nilfs_dat_req *req)
+{
+	struct nilfs_dat_group_desc *desc;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned char *bitmap;
+	unsigned long group;
+	unsigned long group_offset;
+
+	group = nilfs_dat_group(dat, req->dr_vblocknr);
+	group_offset = nilfs_dat_group_offset(dat, req->dr_vblocknr);
+	desc_kaddr = kmap(req->dr_desc_bh->b_page);
+	desc = nilfs_dat_block_get_group_desc(dat, group, req->dr_desc_bh,
+					      desc_kaddr);
+	bitmap_kaddr = kmap(req->dr_bitmap_bh->b_page);
+	bitmap = nilfs_dat_block_get_bitmap(dat, req->dr_bitmap_bh,
+					    bitmap_kaddr);
+
+	if (!nilfs_dat_clear_bit_atomic(nilfs_mdt_bgl_lock(dat, group),
+					group_offset, bitmap)) {
+		/*
+		nilfs_error(dat->i_sb, __func__,
+			    "virtual block number %llu already freed",
+			    (unsigned long long)req->dr_vblocknr);
+		*/
+		printk(KERN_CRIT
+		       "%s: virtual block number %llu already freed\n",
+		       __func__, (unsigned long long)req->dr_vblocknr);
+		BUG();
+	}
+
+	nilfs_dat_group_desc_add_entries(dat, group, desc, 1);
+
+	kunmap(req->dr_bitmap_bh->b_page);
+	kunmap(req->dr_desc_bh->b_page);
+
+	brelse(req->dr_bitmap_bh);
+	brelse(req->dr_desc_bh);
+
+	req->dr_vblocknr = 0;
+	req->dr_bitmap_bh = NULL;
+	req->dr_desc_bh = NULL;
+}
+
+static int nilfs_dat_prepare_free_vblocknr(struct inode *dat,
+					   struct nilfs_dat_req *req)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	unsigned long group;
+	int ret;
+
+	group = nilfs_dat_group(dat, req->dr_vblocknr);
+	ret = nilfs_dat_get_desc_block(dat, group, 0, &desc_bh);
+	if (ret < 0)
+		return ret;
+	ret = nilfs_dat_get_bitmap_block(dat, group, 0, &bitmap_bh);
+	if (ret < 0) {
+		brelse(desc_bh);
+		return ret;
+	}
+
+	req->dr_desc_bh = desc_bh;
+	req->dr_bitmap_bh = bitmap_bh;
+	return 0;
+}
+
+static void nilfs_dat_commit_free_vblocknr(struct inode *dat,
+					   struct nilfs_dat_req *req)
+{
+	struct nilfs_dat_group_desc *desc;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned char *bitmap;
+	unsigned long group;
+	unsigned long group_offset;
+
+	group = nilfs_dat_group(dat, req->dr_vblocknr);
+	group_offset = nilfs_dat_group_offset(dat, req->dr_vblocknr);
+	desc_kaddr = kmap(req->dr_desc_bh->b_page);
+	desc = nilfs_dat_block_get_group_desc(
+		dat, group, req->dr_desc_bh, desc_kaddr);
+	bitmap_kaddr = kmap(req->dr_bitmap_bh->b_page);
+	bitmap = nilfs_dat_block_get_bitmap(
+		dat, req->dr_bitmap_bh, bitmap_kaddr);
+
+	if (!nilfs_dat_clear_bit_atomic(nilfs_mdt_bgl_lock(dat, group),
+					group_offset, bitmap)) {
+		/*
+		nilfs_error(dat->i_sb, __func__,
+			    "virtual block number %llu already freed",
+			    (unsigned long long)req->dr_vblocknr);
+		*/
+		printk(KERN_CRIT
+		       "%s: virtual block number %llu already freed\n",
+		       __func__, (unsigned long long)req->dr_vblocknr);
+		BUG();
+	}
+
+	nilfs_dat_group_desc_add_entries(dat, group, desc, 1);
+
+	kunmap(req->dr_bitmap_bh->b_page);
+	kunmap(req->dr_desc_bh->b_page);
+
+	nilfs_mdt_mark_buffer_dirty(req->dr_bitmap_bh);
+	nilfs_mdt_mark_buffer_dirty(req->dr_desc_bh);
+	nilfs_mdt_mark_dirty(dat);
+
+	brelse(req->dr_bitmap_bh);
+	brelse(req->dr_desc_bh);
+}
+
+static void nilfs_dat_abort_free_vblocknr(struct inode *dat,
+					  struct nilfs_dat_req *req)
+{
+	brelse(req->dr_bitmap_bh);
+	brelse(req->dr_desc_bh);
+
+	req->dr_vblocknr = 0;
+	req->dr_bitmap_bh = NULL;
+	req->dr_desc_bh = NULL;
+}
+
+static int nilfs_dat_prepare_entry(struct inode *dat,
+				   struct nilfs_dat_req *req,
+				   int create)
+{
+	return nilfs_dat_get_entry_block(dat, req->dr_vblocknr,
+					 create, &req->dr_entry_bh);
+}
+
+static void nilfs_dat_commit_entry(struct inode *dat,
+				   struct nilfs_dat_req *req)
+{
+	nilfs_mdt_mark_buffer_dirty(req->dr_entry_bh);
+	nilfs_mdt_mark_dirty(dat);
+	brelse(req->dr_entry_bh);
+}
+
+static void nilfs_dat_abort_entry(struct inode *dat,
+				  struct nilfs_dat_req *req)
+{
+	brelse(req->dr_entry_bh);
+}
+
+/**
+ * nilfs_dat_prepare_alloc -
+ * @dat:
+ * @req:
+ */
+int nilfs_dat_prepare_alloc(struct inode *dat, struct nilfs_dat_req *req)
+{
+	int ret;
+
+	ret = nilfs_dat_prepare_alloc_vblocknr(dat, req);
+	if (ret < 0)
+		return ret;
+
+	ret = nilfs_dat_prepare_entry(dat, req, 1);
+	if (ret < 0)
+		nilfs_dat_abort_alloc_vblocknr(dat, req);
+
+	return ret;
+}
+
+/**
+ * nilfs_dat_commit_alloc -
+ * @dat:
+ * @req:
+ */
+void nilfs_dat_commit_alloc(struct inode *dat, struct nilfs_dat_req *req)
+{
+	struct nilfs_dat_entry *entry;
+	void *entry_kaddr;
+
+	entry_kaddr = kmap_atomic(req->dr_entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, req->dr_vblocknr,
+					  req->dr_entry_bh, entry_kaddr);
+	nilfs_dat_entry_set_start(dat, entry, NILFS_CNO_MIN);
+	nilfs_dat_entry_set_end(dat, entry, NILFS_CNO_MAX);
+	nilfs_dat_entry_set_blocknr(dat, entry, 0);
+
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	nilfs_dat_commit_alloc_vblocknr(dat, req);
+	nilfs_dat_commit_entry(dat, req);
+}
+
+/**
+ * nilfs_dat_abort_alloc -
+ * @dat:
+ * @req:
+ */
+void nilfs_dat_abort_alloc(struct inode *dat, struct nilfs_dat_req *req)
+{
+	nilfs_dat_abort_entry(dat, req);
+	nilfs_dat_abort_alloc_vblocknr(dat, req);
+}
+
+/**
+ * nilfs_dat_prepare_free -
+ * @dat:
+ * @req:
+ */
+int nilfs_dat_prepare_free(struct inode *dat, struct nilfs_dat_req *req)
+{
+	int ret;
+
+	ret = nilfs_dat_prepare_free_vblocknr(dat, req);
+	if (ret < 0)
+		return ret;
+	ret = nilfs_dat_prepare_entry(dat, req, 0);
+	if (ret < 0) {
+		nilfs_dat_abort_free_vblocknr(dat, req);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * nilfs_dat_commit_free -
+ * @dat:
+ * @req:
+ */
+void nilfs_dat_commit_free(struct inode *dat, struct nilfs_dat_req *req)
+{
+	struct nilfs_dat_entry *entry;
+	void *entry_kaddr;
+
+	entry_kaddr = kmap_atomic(req->dr_entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, req->dr_vblocknr,
+					  req->dr_entry_bh, entry_kaddr);
+
+	nilfs_dat_entry_set_start(dat, entry, NILFS_CNO_MIN);
+	nilfs_dat_entry_set_end(dat, entry, NILFS_CNO_MIN);
+	nilfs_dat_entry_set_blocknr(dat, entry, 0);
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	nilfs_dat_commit_entry(dat, req);
+	nilfs_dat_commit_free_vblocknr(dat, req);
+}
+
+/**
+ * nilfs_dat_abort_free -
+ * @dat:
+ * @req:
+ */
+void nilfs_dat_abort_free(struct inode *dat, struct nilfs_dat_req *req)
+{
+	nilfs_dat_abort_entry(dat, req);
+	nilfs_dat_abort_free_vblocknr(dat, req);
+}
+
+/**
+ * nilfs_dat_prepare_start -
+ * @dat:
+ * @req:
+ */
+int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_dat_req *req)
+{
+	int ret;
+
+	ret = nilfs_dat_prepare_entry(dat, req, 0);
+	BUG_ON(ret == -ENOENT);
+	return ret;
+}
+
+/**
+ * nilfs_dat_commit_start -
+ * @dat:
+ * @req:
+ * @blocknr:
+ */
+void nilfs_dat_commit_start(struct inode *dat,
+			    struct nilfs_dat_req *req,
+			    sector_t blocknr)
+{
+	struct nilfs_dat_entry *entry;
+	void *entry_kaddr;
+
+	entry_kaddr = kmap_atomic(req->dr_entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, req->dr_vblocknr,
+					  req->dr_entry_bh, entry_kaddr);
+	nilfs_dat_entry_set_start(dat, entry, nilfs_mdt_cno(dat));
+	if ((nilfs_dat_entry_get_blocknr(dat, entry) != 0) ||
+	    (nilfs_dat_entry_get_end(dat, entry) != NILFS_CNO_MAX)) {
+		printk(KERN_CRIT
+		       "%s: vbn = %llu, start = %llu, end = %llu, pbn = %llu\n",
+		       __func__, (unsigned long long)req->dr_vblocknr,
+		       (unsigned long long)nilfs_dat_entry_get_start(dat,
+								     entry),
+		       (unsigned long long)nilfs_dat_entry_get_end(dat, entry),
+		       (unsigned long long)nilfs_dat_entry_get_blocknr(dat,
+								       entry));
+		BUG();
+	}
+	nilfs_dat_entry_set_blocknr(dat, entry, blocknr);
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	nilfs_dat_commit_entry(dat, req);
+}
+
+/**
+ * nilfs_dat_abort_start -
+ * @dat:
+ * @req:
+ */
+void nilfs_dat_abort_start(struct inode *dat, struct nilfs_dat_req *req)
+{
+	nilfs_dat_abort_entry(dat, req);
+}
+
+/**
+ * nilfs_dat_prepare_end -
+ * @dat:
+ * @req:
+ */
+int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_dat_req *req)
+{
+	struct nilfs_dat_entry *entry;
+	__u64 start;
+	sector_t blocknr;
+	void *entry_kaddr;
+	int ret;
+
+	ret = nilfs_dat_prepare_entry(dat, req, 0);
+	if (ret < 0) {
+		BUG_ON(ret == -ENOENT);
+		return ret;
+	}
+
+	entry_kaddr = kmap_atomic(req->dr_entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, req->dr_vblocknr,
+					  req->dr_entry_bh, entry_kaddr);
+	start = nilfs_dat_entry_get_start(dat, entry);
+	blocknr = nilfs_dat_entry_get_blocknr(dat, entry);
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	if (blocknr == 0) {
+		ret = nilfs_dat_prepare_free_vblocknr(dat, req);
+		if (ret < 0) {
+			nilfs_dat_abort_entry(dat, req);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * nilfs_dat_commit_end -
+ * @dat:
+ * @req:
+ * @dead:
+ */
+void nilfs_dat_commit_end(struct inode *dat, struct nilfs_dat_req *req,
+			  int dead)
+{
+	struct nilfs_dat_entry *entry;
+	__u64 start, end;
+	sector_t blocknr;
+	void *entry_kaddr;
+
+	entry_kaddr = kmap_atomic(req->dr_entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, req->dr_vblocknr,
+					  req->dr_entry_bh, entry_kaddr);
+	end = start = nilfs_dat_entry_get_start(dat, entry);
+	if (!dead) {
+		end = nilfs_mdt_cno(dat);
+		BUG_ON(start > end);
+	}
+	nilfs_dat_entry_set_end(dat, entry, end);
+	blocknr = nilfs_dat_entry_get_blocknr(dat, entry);
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	if (blocknr == 0)
+		nilfs_dat_commit_free(dat, req);
+	else
+		nilfs_dat_commit_entry(dat, req);
+}
+
+/**
+ * nilfs_dat_abort_end -
+ * @dat:
+ * @req:
+ */
+void nilfs_dat_abort_end(struct inode *dat, struct nilfs_dat_req *req)
+{
+	struct nilfs_dat_entry *entry;
+	__u64 start;
+	sector_t blocknr;
+	void *entry_kaddr;
+
+	entry_kaddr = kmap_atomic(req->dr_entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, req->dr_vblocknr,
+					  req->dr_entry_bh, entry_kaddr);
+	start = nilfs_dat_entry_get_start(dat, entry);
+	blocknr = nilfs_dat_entry_get_blocknr(dat, entry);
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	if ((start == nilfs_mdt_cno(dat)) && (blocknr == 0))
+		nilfs_dat_abort_free_vblocknr(dat, req);
+	nilfs_dat_abort_entry(dat, req);
+}
+
+/**
+ * nilfs_dat_mark_dirty -
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
+{
+	struct nilfs_dat_req req;
+	int ret;
+
+	req.dr_vblocknr = vblocknr;
+	ret = nilfs_dat_prepare_entry(dat, &req, 0);
+	if (ret == 0)
+		nilfs_dat_commit_entry(dat, &req);
+	return ret;
+}
+
+/**
+ * nilfs_dat_alloc - allocate a virtual block number
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ *
+ * Description: nilfs_dat_alloc() allocates a new virtual block number,
+ * preferably @vblocknr.
+ *
+ * Return Value: On success, 0 is returned and the newly allocated virtual
+ * block number is stored in the place pointed by @vblocknr. On error, one of
+ * the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - No virtual block number left.
+ */
+int nilfs_dat_alloc(struct inode *dat, __u64 *vblocknr)
+{
+	struct nilfs_dat_req req;
+	int ret;
+
+	req.dr_vblocknr = *vblocknr;
+	ret = nilfs_dat_prepare_alloc(dat, &req);
+	if (ret < 0)
+		return ret;
+	nilfs_dat_commit_alloc(dat, &req);
+	*vblocknr = req.dr_vblocknr;
+	return 0;
+}
+
+static inline int
+nilfs_dat_group_is_in(struct inode *dat, unsigned long group, __u64 vblocknr)
+{
+	__u64 first, last;
+
+	first = group * nilfs_dat_entries_per_group(dat);
+	last = first + nilfs_dat_entries_per_group(dat) - 1;
+	return (vblocknr >= first) && (vblocknr <= last);
+}
+
+/**
+ * nilfs_dat_freev - free virtual block numbers
+ * @dat: DAT file inode
+ * @vblocknrs: array of virtual block numbers
+ * @nitems: number of virtual block numbers
+ *
+ * Description: nilfs_dat_freev() frees the virtual block numbers specified by
+ * @vblocknrs and @nitems.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * nagative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - The virtual block number have not been allocated.
+ */
+int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	struct nilfs_dat_group_desc *desc;
+	unsigned char *bitmap;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned long group;
+	unsigned long group_offset;
+	int i, j, n, ret;
+
+	for (i = 0; i < nitems; i += n) {
+		group = nilfs_dat_group(dat, vblocknrs[i]);
+		ret = nilfs_dat_get_desc_block(dat, group, 0, &desc_bh);
+		if (ret < 0)
+			return ret;
+		ret = nilfs_dat_get_bitmap_block(dat, group, 0, &bitmap_bh);
+		if (ret < 0) {
+			brelse(desc_bh);
+			return ret;
+		}
+		desc_kaddr = kmap(desc_bh->b_page);
+		desc = nilfs_dat_block_get_group_desc(
+			dat, group, desc_bh, desc_kaddr);
+		bitmap_kaddr = kmap(bitmap_bh->b_page);
+		bitmap = nilfs_dat_block_get_bitmap(
+			dat, bitmap_bh, bitmap_kaddr);
+		for (j = i, n = 0;
+		     (j < nitems) && nilfs_dat_group_is_in(dat, group,
+							   vblocknrs[j]);
+		     j++, n++) {
+			group_offset = nilfs_dat_group_offset(
+				dat, vblocknrs[j]);
+			if (!nilfs_dat_clear_bit_atomic(
+				    nilfs_mdt_bgl_lock(dat, group),
+				    group_offset, bitmap)) {
+				printk(KERN_CRIT
+				       "%s: virtual block number %llu already "
+				       "freed\n",
+				       __func__,
+				       (unsigned long long)vblocknrs[j]);
+				BUG();
+			}
+		}
+		nilfs_dat_group_desc_add_entries(dat, group, desc, n);
+
+		kunmap(bitmap_bh->b_page);
+		kunmap(desc_bh->b_page);
+
+		nilfs_mdt_mark_buffer_dirty(desc_bh);
+		nilfs_mdt_mark_buffer_dirty(bitmap_bh);
+		nilfs_mdt_mark_dirty(dat);
+
+		brelse(bitmap_bh);
+		brelse(desc_bh);
+	}
+
+	return 0;
+}
+
+/**
+ * nilfs_dat_move - change a block number
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ * @blocknr: block number
+ *
+ * Description: nilfs_dat_move() changes the block number associated with
+ * @vblocknr to @blocknr.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
+{
+	struct buffer_head *entry_bh;
+	struct nilfs_dat_entry *entry;
+	void *entry_kaddr;
+	int ret;
+
+	ret = nilfs_dat_get_entry_block(dat, vblocknr, 0, &entry_bh);
+	if (ret < 0)
+		return ret;
+	entry_kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(
+		dat, vblocknr, entry_bh, entry_kaddr);
+	if (nilfs_dat_entry_get_blocknr(dat, entry) == 0) {
+		printk(KERN_CRIT "%s: vbn = %llu, [%llu, %llu)\n",
+		       __func__,
+		       (unsigned long long)vblocknr,
+		       (unsigned long long)nilfs_dat_entry_get_start(dat,
+								     entry),
+		       (unsigned long long)nilfs_dat_entry_get_end(dat, entry));
+		BUG();
+	}
+	BUG_ON(blocknr == 0);
+	nilfs_dat_entry_set_blocknr(dat, entry, blocknr);
+	kunmap_atomic(entry_kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(entry_bh);
+	nilfs_mdt_mark_dirty(dat);
+
+	brelse(entry_bh);
+
+	return 0;
+}
+
+/**
+ * nilfs_dat_translate - translate a virtual block number to a block number
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ * @blocknrp: pointer to a block number
+ *
+ * Description: nilfs_dat_translate() maps the virtual block number @vblocknr
+ * to the corresponding block number.
+ *
+ * Return Value: On success, 0 is returned and the block number associated
+ * with @vblocknr is stored in the place pointed by @blocknrp. On error, one
+ * of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A block number associated with @vblocknr does not exist.
+ */
+int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
+{
+	struct buffer_head *entry_bh;
+	struct nilfs_dat_entry *entry;
+	sector_t blocknr;
+	void *entry_kaddr;
+	int ret;
+
+	ret = nilfs_dat_get_entry_block(dat, vblocknr, 0, &entry_bh);
+	if (ret < 0)
+		return ret;
+
+	entry_kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+	entry = nilfs_dat_block_get_entry(dat, vblocknr, entry_bh, entry_kaddr);
+	blocknr = nilfs_dat_entry_get_blocknr(dat, entry);
+	if (blocknr == 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (blocknrp != NULL)
+		*blocknrp = blocknr;
+
+ out:
+	kunmap_atomic(entry_kaddr, KM_USER0);
+	brelse(entry_bh);
+	return ret;
+}
+
+/**
+ * nilfs_dat_get_vinfo -
+ * @vinfo:
+ * @nvinfo:
+ */
+ssize_t nilfs_dat_get_vinfo(struct inode *dat,
+			    struct nilfs_vinfo *vinfo,
+			    size_t nvi)
+{
+	struct buffer_head *entry_bh;
+	struct nilfs_dat_entry *entry;
+	__u64 first, last;
+	void *kaddr;
+	unsigned long entries_per_block;
+	int i, j, n, ret;
+
+	entries_per_block = nilfs_dat_entries_per_block(dat);
+	for (i = 0; i < nvi; i += n) {
+		ret = nilfs_dat_get_entry_block(dat, vinfo[i].vi_vblocknr, 0,
+						&entry_bh);
+		if (ret < 0)
+			return ret;
+		kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+		/* last virtual block number in this block */
+		first = vinfo[i].vi_vblocknr;
+		do_div(first, entries_per_block);
+		first *= entries_per_block;
+		last = first + entries_per_block - 1;
+		for (j = i, n = 0;
+		     (j < nvi) && (vinfo[j].vi_vblocknr >= first) &&
+			     (vinfo[j].vi_vblocknr <= last);
+		     j++, n++) {
+			entry = nilfs_dat_block_get_entry(
+				dat, vinfo[j].vi_vblocknr, entry_bh, kaddr);
+			vinfo[j].vi_start =
+				nilfs_dat_entry_get_start(dat, entry);
+			vinfo[j].vi_end = nilfs_dat_entry_get_end(dat, entry);
+			vinfo[j].vi_blocknr =
+				nilfs_dat_entry_get_blocknr(dat, entry);
+		}
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(entry_bh);
+	}
+
+	return nvi;
+}
diff -puN /dev/null fs/nilfs2/dat.h
--- /dev/null
+++ a/fs/nilfs2/dat.h
@@ -0,0 +1,91 @@
+/*
+ * dat.h - NILFS disk address translation.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_DAT_H
+#define _NILFS_DAT_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/fs.h>
+#include <linux/bitops.h>
+#include <linux/nilfs2_fs.h>
+
+
+#define NILFS_DAT_GFP	NILFS_MDT_GFP
+#define NILFS_DAT_GROUPS_COUNT(blkbits) \
+	(1UL << (BITS_PER_LONG - ((blkbits) + 3 /* log2(8) */)))
+
+/**
+ * nilfs_dat_req - request to DAT
+ * @dr_vblocknr: virtual block number
+ * @dr_desc_bh: buffer head of the buffer containing block group descriptors
+ * @dr_bitmap_bh: buffer head of the buffer containing a block group bitmap
+ * @dr_entry_bh: buffer head of the buffer containing translation entries
+ */
+struct nilfs_dat_req {
+	__u64 dr_vblocknr;
+	struct buffer_head *dr_desc_bh;
+	struct buffer_head *dr_bitmap_bh;
+	struct buffer_head *dr_entry_bh;
+};
+
+
+#define NILFS_DAT_CHAR_BIT	8
+
+#define nilfs_dat_set_bit_atomic	ext2_set_bit_atomic
+#define nilfs_dat_clear_bit_atomic	ext2_clear_bit_atomic
+#define nilfs_dat_test_bit		ext2_test_bit
+#define nilfs_dat_find_next_zero_bit	ext2_find_next_zero_bit
+
+static inline unsigned long
+nilfs_dat_entries_per_block(const struct inode *dat)
+{
+	return (1UL << dat->i_blkbits) / sizeof(struct nilfs_dat_entry);
+}
+
+static inline unsigned long
+nilfs_dat_entries_per_group(const struct inode *dat)
+{
+	return (1UL << dat->i_blkbits) * NILFS_DAT_CHAR_BIT;
+}
+
+
+int nilfs_dat_translate(struct inode *, __u64, sector_t *);
+
+int nilfs_dat_prepare_alloc(struct inode *, struct nilfs_dat_req *);
+void nilfs_dat_commit_alloc(struct inode *, struct nilfs_dat_req *);
+void nilfs_dat_abort_alloc(struct inode *, struct nilfs_dat_req *);
+int nilfs_dat_prepare_start(struct inode *, struct nilfs_dat_req *);
+void nilfs_dat_commit_start(struct inode *, struct nilfs_dat_req *, sector_t);
+void nilfs_dat_abort_start(struct inode *, struct nilfs_dat_req *);
+int nilfs_dat_prepare_end(struct inode *, struct nilfs_dat_req *);
+void nilfs_dat_commit_end(struct inode *, struct nilfs_dat_req *, int);
+void nilfs_dat_abort_end(struct inode *, struct nilfs_dat_req *);
+
+int nilfs_dat_alloc(struct inode *, __u64 *);
+
+int nilfs_dat_mark_dirty(struct inode *, __u64);
+int nilfs_dat_freev(struct inode *, __u64 *, size_t);
+int nilfs_dat_move(struct inode *, __u64, sector_t);
+ssize_t nilfs_dat_get_vinfo(struct inode *, struct nilfs_vinfo *, size_t);
+
+#endif	/* _NILFS_DAT_H */
diff -puN /dev/null fs/nilfs2/dir.c
--- /dev/null
+++ a/fs/nilfs2/dir.c
@@ -0,0 +1,711 @@
+/*
+ * dir.c - NILFS directory entry operations
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>
+ */
+/*
+ *  linux/fs/ext2/dir.c
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/fs/minix/dir.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  ext2 directory handling functions
+ *
+ *  Big-endian to little-endian byte-swapping/bitmaps by
+ *        David S. Miller (davem@caip.rutgers.edu), 1995
+ *
+ * All code that works with directory layout had been switched to pagecache
+ * and moved here. AV
+ */
+
+#include "nilfs.h"
+#include <linux/pagemap.h>
+#include <linux/smp_lock.h>
+#include "page.h"
+
+/*
+ * nilfs uses block-sized chunks. Arguably, sector-sized ones would be
+ * more robust, but we have what we have
+ */
+static inline unsigned nilfs_chunk_size(struct inode *inode)
+{
+	return inode->i_sb->s_blocksize;
+}
+
+static inline void nilfs_put_page(struct page *page)
+{
+	kunmap(page);
+	page_cache_release(page);
+}
+
+static inline unsigned long dir_pages(struct inode *inode)
+{
+	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
+}
+
+/*
+ * Return the offset into page `page_nr' of the last valid
+ * byte in that page, plus one.
+ */
+static unsigned nilfs_last_byte(struct inode *inode, unsigned long page_nr)
+{
+	unsigned last_byte = inode->i_size;
+
+	last_byte -= page_nr << PAGE_CACHE_SHIFT;
+	if (last_byte > PAGE_CACHE_SIZE)
+		last_byte = PAGE_CACHE_SIZE;
+	return last_byte;
+}
+
+static int nilfs_prepare_chunk_uninterruptible(struct page *page,
+					       struct address_space *mapping,
+					       unsigned from, unsigned to)
+{
+	loff_t pos = page_offset(page) + from;
+	return block_write_begin(NULL, mapping, pos, to - from,
+				 AOP_FLAG_UNINTERRUPTIBLE, &page,
+				 NULL, nilfs_get_block);
+}
+
+static int nilfs_prepare_chunk(struct page *page,
+			       struct address_space *mapping,
+			       unsigned from, unsigned to)
+{
+	loff_t pos = page_offset(page) + from;
+	return block_write_begin(NULL, mapping, pos, to - from, 0, &page,
+				 NULL, nilfs_get_block);
+}
+
+static int nilfs_commit_chunk(struct page *page,
+			      struct address_space *mapping,
+			      unsigned from, unsigned to)
+{
+	struct inode *dir = mapping->host;
+	struct nilfs_sb_info *sbi = NILFS_SB(dir->i_sb);
+	loff_t pos = page_offset(page) + from;
+	unsigned len = to - from;
+	unsigned nr_dirty, copied;
+	int err;
+
+	nr_dirty = nilfs_page_count_clean_buffers(page, from, to);
+	copied = block_write_end(NULL, mapping, pos, len, len, page, NULL);
+	if (pos + copied > dir->i_size) {
+		i_size_write(dir, pos + copied);
+		mark_inode_dirty(dir);
+	}
+	if (IS_DIRSYNC(dir))
+		nilfs_set_transaction_flag(NILFS_TI_SYNC);
+	err = nilfs_set_file_dirty(sbi, dir, nr_dirty);
+	unlock_page(page);
+	return err;
+}
+
+static void nilfs_check_page(struct page *page)
+{
+	struct inode *dir = page->mapping->host;
+	struct super_block *sb = dir->i_sb;
+	unsigned chunk_size = nilfs_chunk_size(dir);
+	char *kaddr = page_address(page);
+	unsigned offs, rec_len;
+	unsigned limit = PAGE_CACHE_SIZE;
+	struct nilfs_dir_entry *p;
+	char *error;
+
+	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
+		limit = dir->i_size & ~PAGE_CACHE_MASK;
+		if (limit & (chunk_size - 1))
+			goto Ebadsize;
+		if (!limit)
+			goto out;
+	}
+	for (offs = 0; offs <= limit - NILFS_DIR_REC_LEN(1); offs += rec_len) {
+		p = (struct nilfs_dir_entry *)(kaddr + offs);
+		rec_len = le16_to_cpu(p->rec_len);
+
+		if (rec_len < NILFS_DIR_REC_LEN(1))
+			goto Eshort;
+		if (rec_len & 3)
+			goto Ealign;
+		if (rec_len < NILFS_DIR_REC_LEN(p->name_len))
+			goto Enamelen;
+		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
+			goto Espan;
+	}
+	if (offs != limit)
+		goto Eend;
+out:
+	SetPageChecked(page);
+	return;
+
+	/* Too bad, we had an error */
+
+Ebadsize:
+	nilfs_error(sb, "nilfs_check_page",
+		    "size of directory #%lu is not a multiple of chunk size",
+		    dir->i_ino
+	);
+	goto fail;
+Eshort:
+	error = "rec_len is smaller than minimal";
+	goto bad_entry;
+Ealign:
+	error = "unaligned directory entry";
+	goto bad_entry;
+Enamelen:
+	error = "rec_len is too small for name_len";
+	goto bad_entry;
+Espan:
+	error = "directory entry across blocks";
+bad_entry:
+	nilfs_error(sb, "nilfs_check_page", "bad entry in directory #%lu: %s - "
+		    "offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
+		    dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		    (unsigned long) le64_to_cpu(p->inode),
+		    rec_len, p->name_len);
+	goto fail;
+Eend:
+	p = (struct nilfs_dir_entry *)(kaddr + offs);
+	nilfs_error(sb, "nilfs_check_page",
+		    "entry in directory #%lu spans the page boundary"
+		    "offset=%lu, inode=%lu",
+		    dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		    (unsigned long) le64_to_cpu(p->inode));
+fail:
+	SetPageChecked(page);
+	SetPageError(page);
+}
+
+static struct page *nilfs_get_page(struct inode *dir, unsigned long n)
+{
+	struct address_space *mapping = dir->i_mapping;
+	struct page *page = read_cache_page(mapping, n,
+				(filler_t *)mapping->a_ops->readpage, NULL);
+	if (!IS_ERR(page)) {
+		wait_on_page_locked(page);
+		kmap(page);
+		if (!PageUptodate(page))
+			goto fail;
+		if (!PageChecked(page))
+			nilfs_check_page(page);
+		if (PageError(page))
+			goto fail;
+	}
+	return page;
+
+fail:
+	nilfs_put_page(page);
+	return ERR_PTR(-EIO);
+}
+
+/*
+ * NOTE! unlike strncmp, nilfs_match returns 1 for success, 0 for failure.
+ *
+ * len <= NILFS_NAME_LEN and de != NULL are guaranteed by caller.
+ */
+static int
+nilfs_match(int len, const char * const name, struct nilfs_dir_entry *de)
+{
+	if (len != de->name_len)
+		return 0;
+	if (!de->inode)
+		return 0;
+	return !memcmp(name, de->name, len);
+}
+
+/*
+ * p is at least 6 bytes before the end of page
+ */
+static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
+{
+	return (struct nilfs_dir_entry *)((char *)p + le16_to_cpu(p->rec_len));
+}
+
+static unsigned char
+nilfs_filetype_table[NILFS_FT_MAX] = {
+	[NILFS_FT_UNKNOWN]	= DT_UNKNOWN,
+	[NILFS_FT_REG_FILE]	= DT_REG,
+	[NILFS_FT_DIR]		= DT_DIR,
+	[NILFS_FT_CHRDEV]	= DT_CHR,
+	[NILFS_FT_BLKDEV]	= DT_BLK,
+	[NILFS_FT_FIFO]		= DT_FIFO,
+	[NILFS_FT_SOCK]		= DT_SOCK,
+	[NILFS_FT_SYMLINK]	= DT_LNK,
+};
+
+#define S_SHIFT 12
+static unsigned char
+nilfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+	[S_IFREG >> S_SHIFT]	= NILFS_FT_REG_FILE,
+	[S_IFDIR >> S_SHIFT]	= NILFS_FT_DIR,
+	[S_IFCHR >> S_SHIFT]	= NILFS_FT_CHRDEV,
+	[S_IFBLK >> S_SHIFT]	= NILFS_FT_BLKDEV,
+	[S_IFIFO >> S_SHIFT]	= NILFS_FT_FIFO,
+	[S_IFSOCK >> S_SHIFT]	= NILFS_FT_SOCK,
+	[S_IFLNK >> S_SHIFT]	= NILFS_FT_SYMLINK,
+};
+
+static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode *inode)
+{
+	mode_t mode = inode->i_mode;
+
+	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+}
+
+static int nilfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	loff_t pos = filp->f_pos;
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	unsigned int offset = pos & ~PAGE_CACHE_MASK;
+	unsigned long n = pos >> PAGE_CACHE_SHIFT;
+	unsigned long npages = dir_pages(inode);
+/*	unsigned chunk_mask = ~(nilfs_chunk_size(inode)-1); */
+	unsigned char *types = NULL;
+	int ret;
+
+	if (pos > inode->i_size - NILFS_DIR_REC_LEN(1))
+		goto success;
+
+	types = nilfs_filetype_table;
+
+	for ( ; n < npages; n++, offset = 0) {
+		char *kaddr, *limit;
+		struct nilfs_dir_entry *de;
+		struct page *page = nilfs_get_page(inode, n);
+
+		if (IS_ERR(page)) {
+			nilfs_error(sb, __func__, "bad page in #%lu",
+				    inode->i_ino);
+			filp->f_pos += PAGE_CACHE_SIZE - offset;
+			ret = -EIO;
+			goto done;
+		}
+		kaddr = page_address(page);
+		de = (struct nilfs_dir_entry *)(kaddr + offset);
+		limit = kaddr + nilfs_last_byte(inode, n) -
+			NILFS_DIR_REC_LEN(1);
+		for ( ; (char *)de <= limit; de = nilfs_next_entry(de)) {
+			if (de->rec_len == 0) {
+				nilfs_error(sb, __func__,
+					    "zero-length directory entry");
+				ret = -EIO;
+				nilfs_put_page(page);
+				goto done;
+			}
+			if (de->inode) {
+				int over;
+				unsigned char d_type = DT_UNKNOWN;
+
+				if (types && de->file_type < NILFS_FT_MAX)
+					d_type = types[de->file_type];
+
+				offset = (char *)de - kaddr;
+				over = filldir(dirent, de->name, de->name_len,
+						(n<<PAGE_CACHE_SHIFT) | offset,
+						le64_to_cpu(de->inode), d_type);
+				if (over) {
+					nilfs_put_page(page);
+					goto success;
+				}
+			}
+			filp->f_pos += le16_to_cpu(de->rec_len);
+		}
+		nilfs_put_page(page);
+	}
+
+success:
+	ret = 0;
+done:
+	return ret;
+}
+
+/*
+ *	nilfs_find_entry()
+ *
+ * finds an entry in the specified directory with the wanted name. It
+ * returns the page in which the entry was found, and the entry itself
+ * (as a parameter - res_dir). Page is returned mapped and unlocked.
+ * Entry is guaranteed to be valid.
+ */
+struct nilfs_dir_entry *
+nilfs_find_entry(struct inode *dir, struct dentry *dentry,
+		 struct page **res_page)
+{
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned reclen = NILFS_DIR_REC_LEN(namelen);
+	unsigned long start, n;
+	unsigned long npages = dir_pages(dir);
+	struct page *page = NULL;
+	struct nilfs_inode_info *ei = NILFS_I(dir);
+	struct nilfs_dir_entry *de;
+
+	if (npages == 0)
+		goto out;
+
+	/* OFFSET_CACHE */
+	*res_page = NULL;
+
+	start = ei->i_dir_start_lookup;
+	if (start >= npages)
+		start = 0;
+	n = start;
+	do {
+		char *kaddr;
+		page = nilfs_get_page(dir, n);
+		if (!IS_ERR(page)) {
+			kaddr = page_address(page);
+			de = (struct nilfs_dir_entry *)kaddr;
+			kaddr += nilfs_last_byte(dir, n) - reclen;
+			while ((char *) de <= kaddr) {
+				if (de->rec_len == 0) {
+					nilfs_error(dir->i_sb, __func__,
+						"zero-length directory entry");
+					nilfs_put_page(page);
+					goto out;
+				}
+				if (nilfs_match(namelen, name, de))
+					goto found;
+				de = nilfs_next_entry(de);
+			}
+			nilfs_put_page(page);
+		}
+		if (++n >= npages)
+			n = 0;
+		/* next page is past the blocks we've got */
+		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
+			nilfs_error(dir->i_sb, __func__,
+			       "dir %lu size %lld exceeds block cout %llu",
+			       dir->i_ino, dir->i_size,
+			       (unsigned long long)dir->i_blocks);
+			goto out;
+		}
+	} while (n != start);
+out:
+	return NULL;
+
+found:
+	*res_page = page;
+	ei->i_dir_start_lookup = n;
+	return de;
+}
+
+struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct page **p)
+{
+	struct page *page = nilfs_get_page(dir, 0);
+	struct nilfs_dir_entry *de = NULL;
+
+	if (!IS_ERR(page)) {
+		de = nilfs_next_entry(
+			(struct nilfs_dir_entry *)page_address(page));
+		*p = page;
+	}
+	return de;
+}
+
+ino_t nilfs_inode_by_name(struct inode *dir, struct dentry *dentry)
+{
+	ino_t res = 0;
+	struct nilfs_dir_entry *de;
+	struct page *page;
+
+	de = nilfs_find_entry(dir, dentry, &page);
+	if (de) {
+		res = le64_to_cpu(de->inode);
+		kunmap(page);
+		page_cache_release(page);
+	}
+	return res;
+}
+
+/* Releases the page */
+void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+		    struct page *page, struct inode *inode)
+{
+	unsigned from = (char *) de - (char *) page_address(page);
+	unsigned to = from + le16_to_cpu(de->rec_len);
+	struct address_space *mapping = page->mapping;
+	int err;
+
+	lock_page(page);
+	err = nilfs_prepare_chunk_uninterruptible(page, mapping, from, to);
+	BUG_ON(err);
+	de->inode = cpu_to_le64(inode->i_ino);
+	nilfs_set_de_type(de, inode);
+	err = nilfs_commit_chunk(page, mapping, from, to);
+	nilfs_put_page(page);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+/*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
+	mark_inode_dirty(dir);
+}
+
+/*
+ *	Parent is locked.
+ */
+int nilfs_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned chunk_size = nilfs_chunk_size(dir);
+	unsigned reclen = NILFS_DIR_REC_LEN(namelen);
+	unsigned short rec_len, name_len;
+	struct page *page = NULL;
+	struct nilfs_dir_entry *de;
+	unsigned long npages = dir_pages(dir);
+	unsigned long n;
+	char *kaddr;
+	unsigned from, to;
+	int err;
+
+	/*
+	 * We take care of directory expansion in the same loop.
+	 * This code plays outside i_size, so it locks the page
+	 * to protect that region.
+	 */
+	for (n = 0; n <= npages; n++) {
+		char *dir_end;
+
+		page = nilfs_get_page(dir, n);
+		err = PTR_ERR(page);
+		if (IS_ERR(page))
+			goto out;
+		lock_page(page);
+		kaddr = page_address(page);
+		dir_end = kaddr + nilfs_last_byte(dir, n);
+		de = (struct nilfs_dir_entry *)kaddr;
+		kaddr += PAGE_CACHE_SIZE - reclen;
+		while ((char *)de <= kaddr) {
+			if ((char *)de == dir_end) {
+				/* We hit i_size */
+				name_len = 0;
+				rec_len = chunk_size;
+				de->rec_len = cpu_to_le16(chunk_size);
+				de->inode = 0;
+				goto got_it;
+			}
+			if (de->rec_len == 0) {
+				nilfs_error(dir->i_sb, __func__,
+					    "zero-length directory entry");
+				err = -EIO;
+				goto out_unlock;
+			}
+			err = -EEXIST;
+			if (nilfs_match(namelen, name, de))
+				goto out_unlock;
+			name_len = NILFS_DIR_REC_LEN(de->name_len);
+			rec_len = le16_to_cpu(de->rec_len);
+			if (!de->inode && rec_len >= reclen)
+				goto got_it;
+			if (rec_len >= name_len + reclen)
+				goto got_it;
+			de = (struct nilfs_dir_entry *)((char *)de + rec_len);
+		}
+		unlock_page(page);
+		nilfs_put_page(page);
+	}
+	BUG();
+	return -EINVAL;
+
+got_it:
+	from = (char *)de - (char *)page_address(page);
+	to = from + rec_len;
+	err = nilfs_prepare_chunk(page, page->mapping, from, to);
+	if (err)
+		goto out_unlock;
+	if (de->inode) {
+		struct nilfs_dir_entry *de1;
+
+		de1 = (struct nilfs_dir_entry *)((char *)de + name_len);
+		de1->rec_len = cpu_to_le16(rec_len - name_len);
+		de->rec_len = cpu_to_le16(name_len);
+		de = de1;
+	}
+	de->name_len = namelen;
+	memcpy(de->name, name, namelen);
+	de->inode = cpu_to_le64(inode->i_ino);
+	nilfs_set_de_type(de, inode);
+	err = nilfs_commit_chunk(page, page->mapping, from, to);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+/*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
+	mark_inode_dirty(dir);
+	/* OFFSET_CACHE */
+out_put:
+	nilfs_put_page(page);
+out:
+	return err;
+out_unlock:
+	unlock_page(page);
+	goto out_put;
+}
+
+/*
+ * nilfs_delete_entry deletes a directory entry by merging it with the
+ * previous entry. Page is up-to-date. Releases the page.
+ */
+int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	char *kaddr = page_address(page);
+	unsigned from = ((char *)dir - kaddr) & ~(nilfs_chunk_size(inode) - 1);
+	unsigned to = ((char *)dir - kaddr) + le16_to_cpu(dir->rec_len);
+	struct nilfs_dir_entry *pde = NULL;
+	struct nilfs_dir_entry *de = (struct nilfs_dir_entry *)(kaddr + from);
+	int err;
+
+	while ((char *)de < (char *)dir) {
+		if (de->rec_len == 0) {
+			nilfs_error(inode->i_sb, __func__,
+				    "zero-length directory entry");
+			err = -EIO;
+			goto out;
+		}
+		pde = de;
+		de = nilfs_next_entry(de);
+	}
+	if (pde)
+		from = (char *)pde - (char *)page_address(page);
+	lock_page(page);
+	err = nilfs_prepare_chunk(page, mapping, from, to);
+	BUG_ON(err);
+	if (pde)
+		pde->rec_len = cpu_to_le16(to - from);
+	dir->inode = 0;
+	err = nilfs_commit_chunk(page, mapping, from, to);
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+/*	NILFS_I(inode)->i_flags &= ~NILFS_BTREE_FL; */
+	mark_inode_dirty(inode);
+out:
+	nilfs_put_page(page);
+	return err;
+}
+
+/*
+ * Set the first fragment of directory.
+ */
+int nilfs_make_empty(struct inode *inode, struct inode *parent)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct page *page = grab_cache_page(mapping, 0);
+	unsigned chunk_size = nilfs_chunk_size(inode);
+	struct nilfs_dir_entry *de;
+	int err;
+	void *kaddr;
+
+	if (!page)
+		return -ENOMEM;
+
+	err = nilfs_prepare_chunk(page, mapping, 0, chunk_size);
+	if (unlikely(err)) {
+		unlock_page(page);
+		goto fail;
+	}
+	kaddr = kmap_atomic(page, KM_USER0);
+	memset(kaddr, 0, chunk_size);
+	de = (struct nilfs_dir_entry *)kaddr;
+	de->name_len = 1;
+	de->rec_len = cpu_to_le16(NILFS_DIR_REC_LEN(1));
+	memcpy(de->name, ".\0\0", 4);
+	de->inode = cpu_to_le64(inode->i_ino);
+	nilfs_set_de_type(de, inode);
+
+	de = (struct nilfs_dir_entry *)(kaddr + NILFS_DIR_REC_LEN(1));
+	de->name_len = 2;
+	de->rec_len = cpu_to_le16(chunk_size - NILFS_DIR_REC_LEN(1));
+	de->inode = cpu_to_le64(parent->i_ino);
+	memcpy(de->name, "..\0", 4);
+	nilfs_set_de_type(de, inode);
+	kunmap_atomic(kaddr, KM_USER0);
+	err = nilfs_commit_chunk(page, mapping, 0, chunk_size);
+fail:
+	page_cache_release(page);
+	return err;
+}
+
+/*
+ * routine to check that the specified directory is empty (for rmdir)
+ */
+int nilfs_empty_dir(struct inode *inode)
+{
+	struct page *page = NULL;
+	unsigned long i, npages = dir_pages(inode);
+
+	for (i = 0; i < npages; i++) {
+		char *kaddr;
+		struct nilfs_dir_entry *de;
+
+		page = nilfs_get_page(inode, i);
+		if (IS_ERR(page))
+			continue;
+
+		kaddr = page_address(page);
+		de = (struct nilfs_dir_entry *)kaddr;
+		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);
+
+		while ((char *)de <= kaddr) {
+			if (de->rec_len == 0) {
+				nilfs_error(inode->i_sb, __func__,
+					    "zero-length directory entry "
+					    "(kaddr=%p, de=%p)\n", kaddr, de);
+				goto not_empty;
+			}
+			if (de->inode != 0) {
+				/* check for . and .. */
+				if (de->name[0] != '.')
+					goto not_empty;
+				if (de->name_len > 2)
+					goto not_empty;
+				if (de->name_len < 2) {
+					if (de->inode !=
+					    cpu_to_le64(inode->i_ino))
+						goto not_empty;
+				} else if (de->name[1] != '.')
+					goto not_empty;
+			}
+			de = nilfs_next_entry(de);
+		}
+		nilfs_put_page(page);
+	}
+	return 1;
+
+not_empty:
+	nilfs_put_page(page);
+	return 0;
+}
+
+struct file_operations nilfs_dir_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.readdir	= nilfs_readdir,
+	.ioctl		= nilfs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= nilfs_compat_ioctl,
+#endif	/* CONFIG_COMPAT */
+	.fsync		= nilfs_sync_file,
+
+};
diff -puN /dev/null fs/nilfs2/direct.c
--- /dev/null
+++ a/fs/nilfs2/direct.c
@@ -0,0 +1,428 @@
+/*
+ * direct.c - NILFS direct block pointer.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/errno.h>
+#include "nilfs.h"
+#include "direct.h"
+
+
+static inline __le64 *nilfs_direct_dptrs(const struct nilfs_direct *direct)
+{
+	return (__le64 *)
+		((struct nilfs_direct_node *)direct->d_bmap.b_u.u_data + 1);
+}
+
+static inline __u64
+nilfs_direct_get_ptr(const struct nilfs_direct *direct, __u64 key)
+{
+	return nilfs_bmap_dptr_to_ptr(*(nilfs_direct_dptrs(direct) + key));
+}
+
+static inline void nilfs_direct_set_ptr(struct nilfs_direct *direct,
+					__u64 key, __u64 ptr)
+{
+	*(nilfs_direct_dptrs(direct) + key) = nilfs_bmap_ptr_to_dptr(ptr);
+}
+
+static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
+			       __u64 key, int level, __u64 *ptrp)
+{
+	struct nilfs_direct *direct;
+	__u64 ptr;
+
+	direct = (struct nilfs_direct *)bmap;
+	if ((key > NILFS_DIRECT_KEY_MAX) ||
+	    (level != 1) ||	/* XXX: use macro for level 1 */
+	    ((ptr = nilfs_direct_get_ptr(direct, key)) ==
+	     NILFS_BMAP_INVALID_PTR))
+		return -ENOENT;
+
+	if (ptrp != NULL)
+		*ptrp = ptr;
+	return 0;
+}
+
+static __u64
+nilfs_direct_find_target_v(const struct nilfs_direct *direct, __u64 key)
+{
+	__u64 ptr;
+
+	ptr = nilfs_bmap_find_target_seq(&direct->d_bmap, key);
+	if (ptr != NILFS_BMAP_INVALID_PTR)
+		/* sequential access */
+		return ptr;
+	else
+		/* block group */
+		return nilfs_bmap_find_target_in_group(&direct->d_bmap);
+}
+
+static void nilfs_direct_set_target_v(struct nilfs_direct *direct,
+				      __u64 key, __u64 ptr)
+{
+	direct->d_bmap.b_last_allocated_key = key;
+	direct->d_bmap.b_last_allocated_ptr = ptr;
+}
+
+static int nilfs_direct_prepare_insert(struct nilfs_direct *direct,
+				       __u64 key,
+				       union nilfs_bmap_ptr_req *req,
+				       struct nilfs_bmap_stats *stats)
+{
+	int ret;
+
+	if (direct->d_ops->dop_find_target != NULL)
+		req->bpr_ptr = (*direct->d_ops->dop_find_target)(direct, key);
+	ret = (*direct->d_bmap.b_pops->bpop_prepare_alloc_ptr)(&direct->d_bmap,
+							       req);
+	if (ret < 0)
+		return ret;
+
+	stats->bs_nblocks = 1;
+	return 0;
+}
+
+static void nilfs_direct_commit_insert(struct nilfs_direct *direct,
+				       union nilfs_bmap_ptr_req *req,
+				       __u64 key, __u64 ptr)
+{
+	struct buffer_head *bh;
+
+	/* ptr must be a pointer to a buffer head. */
+	bh = (struct buffer_head *)((unsigned long)ptr);
+	set_buffer_nilfs_volatile(bh);
+
+	if (direct->d_bmap.b_pops->bpop_commit_alloc_ptr != NULL)
+		(*direct->d_bmap.b_pops->bpop_commit_alloc_ptr)(
+			&direct->d_bmap, req);
+	nilfs_direct_set_ptr(direct, key, req->bpr_ptr);
+
+	if (!nilfs_bmap_dirty(&direct->d_bmap))
+		nilfs_bmap_set_dirty(&direct->d_bmap);
+
+	if (direct->d_ops->dop_set_target != NULL)
+		(*direct->d_ops->dop_set_target)(direct, key, req->bpr_ptr);
+}
+
+static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
+{
+	struct nilfs_direct *direct;
+	union nilfs_bmap_ptr_req req;
+	struct nilfs_bmap_stats stats;
+	int ret;
+
+	direct = (struct nilfs_direct *)bmap;
+	if (key > NILFS_DIRECT_KEY_MAX)
+		return -ENOENT;
+	if (nilfs_direct_get_ptr(direct, key) != NILFS_BMAP_INVALID_PTR)
+		return -EEXIST;
+
+	ret = nilfs_direct_prepare_insert(direct, key, &req, &stats);
+	if (ret < 0)
+		return ret;
+	nilfs_direct_commit_insert(direct, &req, key, ptr);
+	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+
+	return 0;
+}
+
+static int nilfs_direct_prepare_delete(struct nilfs_direct *direct,
+				       union nilfs_bmap_ptr_req *req,
+				       __u64 key,
+				       struct nilfs_bmap_stats *stats)
+{
+	int ret;
+
+	if (direct->d_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
+		req->bpr_ptr = nilfs_direct_get_ptr(direct, key);
+		ret = (*direct->d_bmap.b_pops->bpop_prepare_end_ptr)(
+			&direct->d_bmap, req);
+		if (ret < 0)
+			return ret;
+	}
+
+	stats->bs_nblocks = 1;
+	return 0;
+}
+
+static void nilfs_direct_commit_delete(struct nilfs_direct *direct,
+				       union nilfs_bmap_ptr_req *req,
+				       __u64 key)
+{
+	if (direct->d_bmap.b_pops->bpop_commit_end_ptr != NULL)
+		(*direct->d_bmap.b_pops->bpop_commit_end_ptr)(
+			&direct->d_bmap, req);
+	nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
+}
+
+static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
+{
+	struct nilfs_direct *direct;
+	union nilfs_bmap_ptr_req req;
+	struct nilfs_bmap_stats stats;
+	int ret;
+
+	direct = (struct nilfs_direct *)bmap;
+	if ((key > NILFS_DIRECT_KEY_MAX) ||
+	    nilfs_direct_get_ptr(direct, key) == NILFS_BMAP_INVALID_PTR)
+		return -ENOENT;
+
+	ret = nilfs_direct_prepare_delete(direct, &req, key, &stats);
+	if (ret < 0)
+		return ret;
+	nilfs_direct_commit_delete(direct, &req, key);
+	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
+
+	return 0;
+}
+
+static int nilfs_direct_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
+{
+	struct nilfs_direct *direct;
+	__u64 key, lastkey;
+
+	direct = (struct nilfs_direct *)bmap;
+	lastkey = NILFS_DIRECT_KEY_MAX + 1;
+	for (key = NILFS_DIRECT_KEY_MIN; key <= NILFS_DIRECT_KEY_MAX; key++)
+		if (nilfs_direct_get_ptr(direct, key) !=
+		    NILFS_BMAP_INVALID_PTR)
+			lastkey = key;
+
+	if (lastkey == NILFS_DIRECT_KEY_MAX + 1)
+		return -ENOENT;
+
+	BUG_ON(keyp == NULL);
+	*keyp = lastkey;
+
+	return 0;
+}
+
+static int nilfs_direct_check_insert(const struct nilfs_bmap *bmap, __u64 key)
+{
+	return key > NILFS_DIRECT_KEY_MAX;
+}
+
+static int nilfs_direct_gather_data(struct nilfs_bmap *bmap,
+				    __u64 *keys, __u64 *ptrs, int nitems)
+{
+	struct nilfs_direct *direct;
+	__u64 key;
+	__u64 ptr;
+	int n;
+
+	direct = (struct nilfs_direct *)bmap;
+	if (nitems > NILFS_DIRECT_NBLOCKS)
+		nitems = NILFS_DIRECT_NBLOCKS;
+	n = 0;
+	for (key = 0; key < nitems; key++) {
+		ptr = nilfs_direct_get_ptr(direct, key);
+		if (ptr != NILFS_BMAP_INVALID_PTR) {
+			keys[n] = key;
+			ptrs[n] = ptr;
+			n++;
+		}
+	}
+	return n;
+}
+
+int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
+				    __u64 key, __u64 *keys, __u64 *ptrs,
+				    int n, __u64 low, __u64 high)
+{
+	struct nilfs_direct *direct;
+	__le64 *dptrs;
+	int ret, i, j;
+
+	/* no need to allocate any resource for conversion */
+
+	/* delete */
+	ret = (*bmap->b_ops->bop_delete)(bmap, key);
+	if (ret < 0)
+		return ret;
+
+	/* free resources */
+	if (bmap->b_ops->bop_clear != NULL)
+		(*bmap->b_ops->bop_clear)(bmap);
+
+	/* convert */
+	direct = (struct nilfs_direct *)bmap;
+	dptrs = nilfs_direct_dptrs(direct);
+	for (i = 0, j = 0; i < NILFS_DIRECT_NBLOCKS; i++) {
+		if ((j < n) && (i == keys[j])) {
+			dptrs[i] = (i != key) ?
+				nilfs_bmap_ptr_to_dptr(ptrs[j]) :
+				NILFS_BMAP_INVALID_PTR;
+			j++;
+		} else
+			dptrs[i] = NILFS_BMAP_INVALID_PTR;
+	}
+
+	nilfs_direct_init(bmap, low, high);
+
+	return 0;
+}
+
+static int nilfs_direct_propagate_v(struct nilfs_direct *direct,
+				    struct buffer_head *bh)
+{
+	union nilfs_bmap_ptr_req oldreq, newreq;
+	__u64 key;
+	__u64 ptr;
+	int ret;
+
+	key = nilfs_bmap_data_get_key(&direct->d_bmap, bh);
+	ptr = nilfs_direct_get_ptr(direct, key);
+	if (!buffer_nilfs_volatile(bh)) {
+		oldreq.bpr_ptr = ptr;
+		newreq.bpr_ptr = ptr;
+		ret = nilfs_bmap_prepare_update(&direct->d_bmap, &oldreq,
+						&newreq);
+		if (ret < 0)
+			return ret;
+		nilfs_bmap_commit_update(&direct->d_bmap, &oldreq, &newreq);
+		set_buffer_nilfs_volatile(bh);
+		nilfs_direct_set_ptr(direct, key, newreq.bpr_ptr);
+	} else
+		ret = nilfs_bmap_mark_dirty(&direct->d_bmap, ptr);
+
+	return ret;
+}
+
+static int nilfs_direct_propagate(const struct nilfs_bmap *bmap,
+				  struct buffer_head *bh)
+{
+	struct nilfs_direct *direct;
+
+	direct = (struct nilfs_direct *)bmap;
+	return (direct->d_ops->dop_propagate != NULL) ?
+		(*direct->d_ops->dop_propagate)(direct, bh) :
+		0;
+}
+
+static int nilfs_direct_assign_v(struct nilfs_direct *direct,
+				 __u64 key, __u64 ptr,
+				 struct buffer_head **bh,
+				 sector_t blocknr,
+				 union nilfs_binfo *binfo)
+{
+	union nilfs_bmap_ptr_req req;
+	int ret;
+
+	req.bpr_ptr = ptr;
+	ret = (*direct->d_bmap.b_pops->bpop_prepare_start_ptr)(
+		&direct->d_bmap, &req);
+	if (ret < 0)
+		return ret;
+	(*direct->d_bmap.b_pops->bpop_commit_start_ptr)(&direct->d_bmap,
+							&req, blocknr);
+
+	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
+	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+
+	return 0;
+}
+
+static int nilfs_direct_assign_p(struct nilfs_direct *direct,
+				 __u64 key, __u64 ptr,
+				 struct buffer_head **bh,
+				 sector_t blocknr,
+				 union nilfs_binfo *binfo)
+{
+	nilfs_direct_set_ptr(direct, key, blocknr);
+
+	binfo->bi_dat.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_dat.bi_level = 0;
+
+	return 0;
+}
+
+static int nilfs_direct_assign(struct nilfs_bmap *bmap,
+			       struct buffer_head **bh,
+			       sector_t blocknr,
+			       union nilfs_binfo *binfo)
+{
+	struct nilfs_direct *direct;
+	__u64 key;
+	__u64 ptr;
+
+	direct = (struct nilfs_direct *)bmap;
+	key = nilfs_bmap_data_get_key(bmap, *bh);
+	BUG_ON(key > NILFS_DIRECT_KEY_MAX);
+	ptr = nilfs_direct_get_ptr(direct, key);
+	BUG_ON(ptr == NILFS_BMAP_INVALID_PTR);
+
+	return (*direct->d_ops->dop_assign)(direct, key, ptr, bh,
+					    blocknr, binfo);
+}
+
+static const struct nilfs_bmap_operations nilfs_direct_ops = {
+	.bop_lookup		=	nilfs_direct_lookup,
+	.bop_insert		=	nilfs_direct_insert,
+	.bop_delete		=	nilfs_direct_delete,
+	.bop_clear		=	NULL,
+
+	.bop_propagate		=	nilfs_direct_propagate,
+
+	.bop_lookup_dirty_buffers	=	NULL,
+
+	.bop_assign		=	nilfs_direct_assign,
+	.bop_mark		=	NULL,
+
+	.bop_last_key		=	nilfs_direct_last_key,
+	.bop_check_insert	=	nilfs_direct_check_insert,
+	.bop_check_delete	=	NULL,
+	.bop_gather_data	=	nilfs_direct_gather_data,
+};
+
+
+static const struct nilfs_direct_operations nilfs_direct_ops_v = {
+	.dop_find_target	=	nilfs_direct_find_target_v,
+	.dop_set_target		=	nilfs_direct_set_target_v,
+	.dop_propagate		=	nilfs_direct_propagate_v,
+	.dop_assign		=	nilfs_direct_assign_v,
+};
+
+static const struct nilfs_direct_operations nilfs_direct_ops_p = {
+	.dop_find_target	=	NULL,
+	.dop_set_target		=	NULL,
+	.dop_propagate		=	NULL,
+	.dop_assign		=	nilfs_direct_assign_p,
+};
+
+int nilfs_direct_init(struct nilfs_bmap *bmap, __u64 low, __u64 high)
+{
+	struct nilfs_direct *direct;
+
+	direct = (struct nilfs_direct *)bmap;
+	bmap->b_ops = &nilfs_direct_ops;
+	bmap->b_low = low;
+	bmap->b_high = high;
+	switch (bmap->b_inode->i_ino) {
+	case NILFS_DAT_INO:
+		direct->d_ops = &nilfs_direct_ops_p;
+		break;
+	default:
+		direct->d_ops = &nilfs_direct_ops_v;
+		break;
+	}
+
+	return 0;
+}
diff -puN /dev/null fs/nilfs2/direct.h
--- /dev/null
+++ a/fs/nilfs2/direct.h
@@ -0,0 +1,78 @@
+/*
+ * direct.h - NILFS direct block pointer.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_DIRECT_H
+#define _NILFS_DIRECT_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include "bmap.h"
+
+
+struct nilfs_direct;
+
+/**
+ * struct nilfs_direct_operations - direct mapping operation table
+ */
+struct nilfs_direct_operations {
+	__u64 (*dop_find_target)(const struct nilfs_direct *, __u64);
+	void (*dop_set_target)(struct nilfs_direct *, __u64, __u64);
+	int (*dop_propagate)(struct nilfs_direct *, struct buffer_head *);
+	int (*dop_assign)(struct nilfs_direct *, __u64, __u64,
+			  struct buffer_head **, sector_t,
+			  union nilfs_binfo *);
+};
+
+/**
+ * struct nilfs_direct_node - direct node
+ * @dn_flags: flags
+ * @dn_pad: padding
+ */
+struct nilfs_direct_node {
+	__u8 dn_flags;
+	__u8 pad[7];
+};
+
+/**
+ * struct nilfs_direct - direct mapping
+ * @d_bmap: bmap structure
+ * @d_ops: direct mapping operation table
+ */
+struct nilfs_direct {
+	struct nilfs_bmap d_bmap;
+
+	/* direct-mapping-specific members */
+	const struct nilfs_direct_operations *d_ops;
+};
+
+
+#define NILFS_DIRECT_NBLOCKS	(NILFS_BMAP_SIZE / sizeof(__le64) - 1)
+#define NILFS_DIRECT_KEY_MIN	0
+#define NILFS_DIRECT_KEY_MAX	(NILFS_DIRECT_NBLOCKS - 1)
+
+
+int nilfs_direct_init(struct nilfs_bmap *, __u64, __u64);
+int nilfs_direct_delete_and_convert(struct nilfs_bmap *, __u64, __u64 *,
+				    __u64 *, int, __u64, __u64);
+
+
+#endif	/* _NILFS_DIRECT_H */
diff -puN /dev/null fs/nilfs2/file.c
--- /dev/null
+++ a/fs/nilfs2/file.c
@@ -0,0 +1,124 @@
+/*
+ * file.c - NILFS regular file handling primitives including fsync().
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>,
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/writeback.h>
+#include "nilfs.h"
+
+int nilfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
+{
+	/*
+	 * Called from fsync() system call
+	 * This is the only entry point that can catch write and synch
+	 * timing for both data blocks and intermediate blocks.
+	 *
+	 * This function should be implemented when the writeback function
+	 * will be implemented.
+	 */
+	struct inode *inode = dentry->d_inode;
+	int err;
+
+	if (!nilfs_inode_dirty(inode))
+		return 0;
+
+	if (datasync)
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+	else
+		err = nilfs_construct_segment(inode->i_sb);
+
+	return err;
+}
+
+static ssize_t
+nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+		     unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_dentry->d_inode;
+	ssize_t ret;
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	if (ret <= 0)
+		return ret;
+
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+		int err;
+
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+		if (unlikely(err))
+			return err;
+	}
+	return ret;
+}
+
+static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
+		return -EPERM;
+	SetPageChecked(page);
+	wait_on_page_writeback(page);
+	return 0;
+}
+
+struct vm_operations_struct nilfs_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= nilfs_page_mkwrite,
+};
+
+static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	file_accessed(file);
+	vma->vm_ops = &nilfs_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
+/*
+ * We have mostly NULL's here: the current defaults are ok for
+ * the nilfs filesystem.
+ */
+struct file_operations nilfs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= nilfs_file_aio_write,
+	.ioctl		= nilfs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= nilfs_compat_ioctl,
+#endif	/* CONFIG_COMPAT */
+	.mmap		= nilfs_file_mmap,
+	.open		= generic_file_open,
+	/* .release	= nilfs_release_file, */
+	.fsync		= nilfs_sync_file,
+	.splice_read	= generic_file_splice_read,
+};
+
+struct inode_operations nilfs_file_inode_operations = {
+	.truncate	= nilfs_truncate,
+	.setattr	= nilfs_setattr,
+	.permission     = nilfs_permission,
+};
+
+/* end of file */
diff -puN /dev/null fs/nilfs2/gcdat.c
--- /dev/null
+++ a/fs/nilfs2/gcdat.c
@@ -0,0 +1,229 @@
+/*
+ * gcdat.c - NILFS shadow DAT inode for GC
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
+ *            and Ryusuke Konishi <ryusuke@osrg.net>.
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/pagevec.h>
+#include "nilfs.h"
+#include "page.h"
+#include "mdt.h"
+
+
+static int nilfs_gcdat_copy_dirty_data(struct address_space *src,
+				       struct address_space *dst)
+{
+	struct pagevec pvec;
+	unsigned int i;
+	pgoff_t index = 0;
+	int err = 0;
+
+	pagevec_init(&pvec, 0);
+repeat:
+	if (!pagevec_lookup_tag(&pvec, src, &index, PAGECACHE_TAG_DIRTY,
+				PAGEVEC_SIZE))
+		return 0;
+
+	for (i = 0; i < pagevec_count(&pvec); i++) {
+		struct page *page = pvec.pages[i], *dpage;
+
+		lock_page(page);
+		if (unlikely(!PageDirty(page)))
+			NILFS_PAGE_BUG(page, "inconsistent dirty state");
+
+		dpage = grab_cache_page(dst, page->index);
+		if (unlikely(!dpage)) {
+			/* No empty page is added to the page cache */
+			err = -ENOMEM;
+			unlock_page(page);
+			break;
+		}
+		if (unlikely(!page_has_buffers(page)))
+			NILFS_PAGE_BUG(page,
+				       "found empty page in dat page cache");
+
+		nilfs_copy_buffer_page(page, dpage, 1);
+		__set_page_dirty_nobuffers(dpage);
+
+		unlock_page(dpage);
+		page_cache_release(dpage);
+		unlock_page(page);
+	}
+	pagevec_release(&pvec);
+	cond_resched();
+
+	if (likely(!err))
+		goto repeat;
+	return err;
+}
+
+static void nilfs_gcdat_clear_dirty_data(struct address_space *mapping)
+{
+	struct pagevec pvec;
+	unsigned int i;
+	pgoff_t index = 0;
+
+	pagevec_init(&pvec, 0);
+
+	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
+				  PAGEVEC_SIZE)) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+			struct buffer_head *bh, *head;
+
+			lock_page(page);
+			ClearPageUptodate(page);
+			bh = head = page_buffers(page);
+			do {
+				lock_buffer(bh);
+				clear_buffer_dirty(bh);
+				clear_buffer_nilfs_volatile(bh);
+				clear_buffer_uptodate(bh);
+				clear_buffer_mapped(bh);
+				unlock_buffer(bh);
+				bh = bh->b_this_page;
+			} while (bh != head);
+			__nilfs_clear_page_dirty(page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+}
+
+static void nilfs_gcdat_copy_mapping(struct address_space *gmapping,
+				     struct address_space *mapping)
+{
+	struct pagevec pvec;
+	unsigned int i, n;
+	pgoff_t index = 0;
+
+	pagevec_init(&pvec, 0);
+repeat:
+	n = pagevec_lookup(&pvec, gmapping, index, PAGEVEC_SIZE);
+	if (!n)
+		return;
+	index = pvec.pages[n - 1]->index + 1;
+	/* note: mdt dirty flags should be cleared by segctor. */
+
+	for (i = 0; i < pagevec_count(&pvec); i++) {
+		struct page *page = pvec.pages[i], *dpage;
+		pgoff_t offset = page->index;
+
+		lock_page(page);
+		dpage = find_lock_page(mapping, offset);
+		if (dpage) {
+			/* XXX skip if identical */
+			BUG_ON(PageDirty(dpage));
+			nilfs_copy_buffer_page(page, dpage, 0);
+			unlock_page(dpage);
+			page_cache_release(dpage);
+		} else {
+			int err;
+
+			/* move page from gcdat to dat cache */
+			spin_lock_irq(&gmapping->tree_lock);
+			radix_tree_delete(&gmapping->page_tree, offset);
+			gmapping->nrpages--;
+			spin_unlock_irq(&gmapping->tree_lock);
+			spin_lock_irq(&mapping->tree_lock);
+			err = radix_tree_insert(&mapping->page_tree, offset,
+						page);
+			if (unlikely(err < 0)) {
+				/* No pages must no be added to the cache
+				   during commiting gcdat.  This is ensured by
+				   the dat mi_sem and nilfs->ns_segctor_sem */
+				BUG_ON(err == -EEXIST);
+				 /* XXX: -ENOMEM */
+				page->mapping = NULL;
+				page_cache_release(page); /* for cache */
+				goto skip_unlock;
+			}
+			page->mapping = mapping;
+			mapping->nrpages++;
+			if (PageDirty(page))
+				radix_tree_tag_set(&mapping->page_tree, offset,
+						   PAGECACHE_TAG_DIRTY);
+skip_unlock:
+			spin_unlock_irq(&mapping->tree_lock);
+		}
+		unlock_page(page);
+	}
+	pagevec_release(&pvec);
+	cond_resched();
+
+	goto repeat;
+}
+
+int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
+{
+	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
+	struct nilfs_inode_info *dii = NILFS_I(dat), *gii = NILFS_I(gcdat);
+	int err;
+
+	gcdat->i_state = 0;
+	gcdat->i_blocks = dat->i_blocks;
+	gii->i_flags = dii->i_flags;
+	gii->i_state = dii->i_state | (1 << NILFS_I_GCDAT);
+	gii->i_cno = 0;
+	nilfs_bmap_init_gcdat(gii->i_bmap, dii->i_bmap);
+	err = nilfs_gcdat_copy_dirty_data(dat->i_mapping, gcdat->i_mapping);
+	if (unlikely(err))
+		return err;
+
+	err = nilfs_btnode_copy_dirty_pages(&dii->i_btnode_cache,
+					    &gii->i_btnode_cache);
+	return err;
+}
+
+void nilfs_commit_gcdat_inode(struct the_nilfs *nilfs)
+{
+	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
+	struct nilfs_inode_info *dii = NILFS_I(dat), *gii = NILFS_I(gcdat);
+	struct address_space *mapping = dat->i_mapping;
+	struct address_space *gmapping = gcdat->i_mapping;
+
+	down_write(&NILFS_MDT(dat)->mi_sem);
+	dat->i_blocks = gcdat->i_blocks;
+	dii->i_flags = gii->i_flags;
+	dii->i_state = gii->i_state & ~(1 << NILFS_I_GCDAT);
+
+	nilfs_bmap_commit_gcdat(gii->i_bmap, dii->i_bmap);
+
+	nilfs_gcdat_clear_dirty_data(mapping);
+	nilfs_gcdat_copy_mapping(gmapping, mapping);
+
+	nilfs_btnode_clear_dirty_pages(&dii->i_btnode_cache);
+	nilfs_btnode_copy_cache(&gii->i_btnode_cache, &dii->i_btnode_cache);
+	up_write(&NILFS_MDT(dat)->mi_sem);
+}
+
+void nilfs_clear_gcdat_inode(struct the_nilfs *nilfs)
+{
+	struct inode *gcdat = nilfs->ns_gc_dat;
+	struct nilfs_inode_info *gii = NILFS_I(gcdat);
+
+	gcdat->i_state = I_CLEAR;
+	gii->i_flags = 0;
+	truncate_inode_pages(gcdat->i_mapping, 0);
+	nilfs_btnode_cache_clear(&gii->i_btnode_cache);
+}
diff -puN /dev/null fs/nilfs2/gcinode.c
--- /dev/null
+++ a/fs/nilfs2/gcinode.c
@@ -0,0 +1,296 @@
+/*
+ * gcinode.c - NILFS memory inode for GC
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
+ *            and Ryusuke Konishi <ryusuke@osrg.net>.
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/mpage.h>
+#include <linux/hash.h>
+#include <linux/swap.h>
+#include "nilfs.h"
+#include "page.h"
+#include "mdt.h"
+#include "ifile.h"
+
+static struct address_space_operations def_gcinode_aops = {};
+/* XXX need def_gcinode_iops/fops? */
+
+/*
+ * nilfs_gccache_add_data() - add data on pbn to cache
+ * @inode - gc inode
+ * @offset - dummy offset treated as the key for the page cache
+ * @pbn - physical block number for the block
+ * @vbn - virtual block number for the block, 0 for non-virtual block
+ *
+ * Description: nilfs_gccache_add_data() registers the data buffer
+ * specified by @pbn to the GC pagecache with the key @offset.
+ * The function set @vbn (@pbn if @vbn is zero) to b_blocknr in the buffer.
+ *
+ * Return Value: On success, 0 is returned. On Error, one of the following
+ * negative error code is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - The block specified with @pbn does not exist.
+ *
+ * %-EEXIST - The block specified with @vbn already exist.
+ *
+ * Note: pages should be removed by truncate_inode_pages().
+ */
+int nilfs_gccache_add_data(struct inode *inode, sector_t offset, sector_t pbn,
+			   __u64 vbn)
+{
+	struct page *page = NULL;
+	struct buffer_head *bh;
+	int blkbits = inode->i_blkbits, err = -ENOMEM;
+	unsigned long index = offset >> (PAGE_CACHE_SHIFT - blkbits);
+
+	page = grab_cache_page(inode->i_mapping, index);
+	if (!page)
+		goto failed;
+
+	bh = nilfs_get_page_block(page, offset, index, blkbits);
+	if (!bh)
+		goto out_unlock;
+
+	if (!buffer_uptodate(bh)) {
+		if (pbn == 0) {
+			struct inode *dat_inode;
+
+			/* use original dat, not gc dat. */
+			dat_inode = NILFS_I_NILFS(inode)->ns_dat;
+			err = nilfs_dat_translate(dat_inode, vbn, &pbn);
+			if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
+				goto out_free_bh;
+		}
+		bh->b_blocknr = pbn;
+		if (!buffer_mapped(bh)) {
+			bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
+			set_buffer_mapped(bh);
+		}
+		lock_buffer(bh);
+		err = bh_submit_read(bh);
+		if (unlikely(err))
+			goto out_free_bh;
+	}
+	bh->b_blocknr = vbn ? vbn : pbn;
+	err = -EEXIST;
+	if (!buffer_dirty(bh)) {
+		nilfs_mdt_mark_buffer_dirty(bh);
+		err = 0;
+	}
+out_free_bh:
+	brelse(bh);
+out_unlock:
+	unlock_page(page);
+	page_cache_release(page);
+failed:
+	return err;
+}
+
+/*
+ * nilfs_gccache_add_node() - add btree node data on pbn to cache
+ * @inode - gc inode
+ * @pbn - physical block number for the block
+ * @vbn - virtual block number for the block
+ *
+ * Description: nilfs_gccache_add_node() registers the node buffer
+ * specified by @vbn to the GC pagecache.  @pbn may be supplied by the
+ * caller to avoid translation of the disk block addresses.
+ *
+ * Return Value: On success, 0 is returned. On Error, one of the following
+ * negative error code is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EEXIST - The block specified with @vbn already exist.
+ *
+ * Note: pages should be removed by nilfs_btnode_delete_all().
+ */
+int nilfs_gccache_add_node(struct inode *inode, sector_t pbn, __u64 vbn)
+{
+	struct nilfs_btnode_cache *bc = &NILFS_I(inode)->i_btnode_cache;
+	struct buffer_head *bh;
+	int ret;
+
+	ret = nilfs_btnode_get_pb(bc, vbn ? vbn : pbn, pbn, &bh);
+	if (ret < 0)
+		return ret;	/* -ENOMEM or -EIO */
+	ret = -EEXIST;
+	if (!buffer_dirty(bh)) {
+		nilfs_btnode_mark_dirty(bh);
+		ret = 0;
+	}
+	brelse(bh);
+	return ret;
+}
+
+/*
+ * nilfs_init_gcinode() - allocate and initialize gc_inode hash table
+ * @nilfs - the_nilfs
+ *
+ * Return Value: On success, 0.
+ * On error, a negative error code is returned.
+ */
+int nilfs_init_gcinode(struct the_nilfs *nilfs)
+{
+	int loop;
+
+	BUG_ON(nilfs->ns_gc_inodes_h);
+
+	spin_lock_init(&nilfs->ns_gc_inode_lock);
+	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
+
+	nilfs->ns_gc_inodes_h =
+		kmalloc(sizeof(struct hlist_head) * NILFS_GCINODE_HASH_SIZE,
+			GFP_NOFS);
+	if (nilfs->ns_gc_inodes_h == NULL)
+		return -ENOMEM;
+
+	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++)
+		INIT_HLIST_HEAD(&nilfs->ns_gc_inodes_h[loop]);
+	return 0;
+}
+
+/*
+ * nilfs_destroy_gcinode() - free gc_inode hash table
+ * @nilfs - the nilfs
+ */
+void nilfs_destroy_gcinode(struct the_nilfs *nilfs)
+{
+	if (nilfs->ns_gc_inodes_h) {
+		nilfs_remove_all_gcinode(nilfs);
+		kfree(nilfs->ns_gc_inodes_h);
+		nilfs->ns_gc_inodes_h = NULL;
+	}
+}
+
+static struct inode *alloc_gcinode(struct the_nilfs *nilfs, ino_t ino,
+				   __u64 cno, unsigned long hv)
+{
+	struct inode *inode = nilfs_mdt_new_common(nilfs, NULL, ino, GFP_NOFS);
+	struct nilfs_inode_info *ii;
+
+	if (!inode)
+		return NULL;
+
+	inode->i_op = NULL;
+	inode->i_fop = NULL;
+	inode->i_mapping->a_ops = &def_gcinode_aops;
+
+	ii = NILFS_I(inode);
+	ii->i_cno = cno;
+	ii->i_flags = 0;
+	ii->i_state = 1 << NILFS_I_GCINODE;
+	ii->i_bh = NULL;
+	ii->i_dtime = 0;
+	nilfs_bmap_init_gc(ii->i_bmap);
+
+	return inode;
+}
+
+static unsigned long ihash(ino_t ino, __u64 cno)
+{
+	return hash_long((unsigned long)((ino << 2) + cno),
+			 NILFS_GCINODE_HASH_BITS);
+}
+
+/*
+ * nilfs_gc_iget() - find inode with ino/cno. if not exist, newly create.
+ * @sb - super_block
+ * @ino - inode number
+ * @cno - check point number
+ *
+ * Return Value: On success, inode pointer
+ * On error, NULL
+ */
+struct inode *nilfs_gc_iget(struct the_nilfs *nilfs, ino_t ino, __u64 cno)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct inode *inode = NULL;
+	struct nilfs_inode_info *ii;
+	unsigned long hv = ihash(ino, cno);
+
+	spin_lock(&nilfs->ns_gc_inode_lock);
+	head = nilfs->ns_gc_inodes_h + hv;
+	hlist_for_each_entry(inode, node, head, i_hash) {
+		ii = NILFS_I(inode);
+		if (inode->i_ino == ino && ii->i_cno == cno)
+			break;
+	}
+	spin_unlock(&nilfs->ns_gc_inode_lock);
+
+	if (node)
+		return inode;
+
+	inode = alloc_gcinode(nilfs, ino, cno, hv);
+	if (!inode)
+		return NULL;
+
+	spin_lock(&nilfs->ns_gc_inode_lock);
+	head = nilfs->ns_gc_inodes_h + hv;
+	hlist_add_head(&inode->i_hash, head);
+	list_add(&NILFS_I(inode)->i_dirty, &nilfs->ns_gc_inodes);
+	spin_unlock(&nilfs->ns_gc_inode_lock);
+
+	return inode;
+}
+
+/*
+ * nilfs_clear_gcinode() - clear and free a gc inode
+ * @inode - inode
+ */
+void nilfs_clear_gcinode(struct inode *inode)
+{
+	nilfs_mdt_clear(inode);
+	inode->i_state = I_CLEAR;
+	nilfs_mdt_destroy(inode);
+}
+
+/*
+ * nilfs_remove_all_gcinode() - remove all inodes from the_nilfs
+ * @nilfs - the_nilfs
+ */
+void nilfs_remove_all_gcinode(struct the_nilfs *nilfs)
+{
+	struct hlist_head *head = nilfs->ns_gc_inodes_h;
+	struct hlist_node *node, *n;
+	struct inode *inode;
+	int loop;
+
+	spin_lock(&nilfs->ns_gc_inode_lock);
+	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++, head++) {
+		hlist_for_each_entry_safe(inode, node, n, head, i_hash) {
+			hlist_del_init(&inode->i_hash);
+			list_del_init(&NILFS_I(inode)->i_dirty);
+			spin_unlock(&nilfs->ns_gc_inode_lock);
+			nilfs_clear_gcinode(inode); /* might sleep */
+			spin_lock(&nilfs->ns_gc_inode_lock);
+		}
+	}
+	spin_unlock(&nilfs->ns_gc_inode_lock);
+}
diff -puN /dev/null fs/nilfs2/ifile.c
--- /dev/null
+++ a/fs/nilfs2/ifile.c
@@ -0,0 +1,257 @@
+/*
+ * ifile.c - NILFS file operations.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>,
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#include <linux/buffer_head.h>
+#include "nilfs.h"
+#include "page.h"
+#include "mdt.h"
+#include "ifile.h"
+
+struct nilfs_inode *
+nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
+{
+	void *kaddr = kmap(ibh->b_page);
+	void *raw_inode = (kaddr + bh_offset(ibh)) +
+		(ino % NILFS_MDT(ifile)->mi_entries_per_block)
+		* NILFS_MDT(ifile)->mi_entry_size;
+
+	return (struct nilfs_inode *)raw_inode;
+}
+
+void nilfs_ifile_unmap_inode(struct inode *ifile, ino_t ino,
+			     struct buffer_head *ibh)
+{
+	kunmap(ibh->b_page);
+}
+
+static int nilfs_ifile_prepare_alloc_ino(struct inode *ifile,
+					 struct nilfs_persistent_req *req)
+{
+	int entries_per_group = nilfs_persistent_entries_per_group(ifile);
+	unsigned long group = req->pr_ino / entries_per_group;
+	int target = req->pr_ino % entries_per_group;
+	int ret;
+
+	ret = nilfs_persistent_prepare_alloc_entry(ifile, req, &group,
+						   &target);
+	if (!ret)
+		req->pr_ino = entries_per_group * group + target;
+	return ret;
+}
+
+static void nilfs_ifile_abort_alloc_ino(struct inode *ifile,
+					struct nilfs_persistent_req *req)
+{
+	int entries_per_group = nilfs_persistent_entries_per_group(ifile);
+	unsigned long group = req->pr_ino / entries_per_group;
+	int grpoff = req->pr_ino % entries_per_group;
+
+	nilfs_persistent_abort_alloc_entry(ifile, req, group, grpoff);
+}
+
+static unsigned long nilfs_ifile_entry_blkoff(struct inode *ifile, ino_t ino)
+{
+	int entries_per_group = nilfs_persistent_entries_per_group(ifile);
+	unsigned long group = ino / entries_per_group;
+	int grpoff = ino % entries_per_group;
+
+	return nilfs_persistent_group_bitmap_blkoff(ifile, group) + 1 +
+		grpoff / NILFS_MDT(ifile)->mi_entries_per_block;
+}
+
+static int nilfs_ifile_prepare_entry(struct inode *ifile,
+				     struct nilfs_persistent_req *req)
+{
+	unsigned long blkoff = nilfs_ifile_entry_blkoff(ifile, req->pr_ino);
+
+	return nilfs_mdt_get_block(ifile, blkoff, 1, NULL, &req->pr_entry_bh);
+}
+
+static void nilfs_ifile_commit_free_ino(struct inode *ifile,
+					struct nilfs_persistent_req *req)
+{
+	struct nilfs_persistent_group_desc *desc;
+	unsigned long group;
+	char *bitmap_buffer;
+	int grpoff;
+
+	group = req->pr_ino / nilfs_persistent_entries_per_group(ifile);
+	grpoff = req->pr_ino % nilfs_persistent_entries_per_group(ifile);
+	bitmap_buffer =
+		nilfs_persistent_get_group_bitmap_buffer(ifile,
+							 req->pr_bitmap_bh);
+
+	if (!nilfs_persistent_clear_bit_atomic(nilfs_mdt_bgl_lock(ifile,
+								  group),
+					       grpoff, bitmap_buffer))
+		printk(KERN_WARNING "inode number %lu already freed\n",
+		       req->pr_ino);
+
+	desc = nilfs_persistent_get_group_desc(ifile, group, req->pr_desc_bh);
+	spin_lock(nilfs_mdt_bgl_lock(ifile, group));
+	desc->pg_nfrees = cpu_to_le32(le32_to_cpu(desc->pg_nfrees) + 1);
+	spin_unlock(nilfs_mdt_bgl_lock(ifile, group));
+
+	nilfs_mdt_mark_buffer_dirty(req->pr_entry_bh);
+	nilfs_mdt_mark_buffer_dirty(req->pr_bitmap_bh);
+
+	nilfs_persistent_put_group_bitmap_buffer(ifile, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_bitmap_block(ifile, req->pr_bitmap_bh);
+	nilfs_persistent_put_group_desc(ifile, req->pr_desc_bh);
+	nilfs_persistent_put_group_desc_block(ifile, req->pr_desc_bh);
+}
+
+static void
+nilfs_ifile_commit_free(struct inode *ifile, struct nilfs_persistent_req *req)
+{
+	struct nilfs_inode *entry;
+
+	entry = nilfs_ifile_map_inode(ifile, req->pr_ino, req->pr_entry_bh);
+	/* XXX: flags == 0 means unused ?? */
+	entry->i_flags = 0;
+	nilfs_ifile_unmap_inode(ifile, req->pr_ino, req->pr_entry_bh);
+
+	nilfs_mdt_mark_buffer_dirty(req->pr_entry_bh);
+	nilfs_ifile_commit_free_ino(ifile, req);
+}
+
+/**
+ * nilfs_ifile_create_inode - create a NILFS disk inode
+ * @ifile: ifile inode
+ * @ino: inode number
+ * @out_bh: buffer_head contains newly allocated disk inode
+ *
+ * Description: nilfs_ifile_create_inode() creates a new disk inode.
+ * preferably @ino.
+ *
+ * Return Value: On success, 0 is returned and the newly allocated inode
+ * number is stored in the place pointed by @ino, and buffer_head pointer
+ * that contains newly allocated disk inode structure is stored in the
+ * place pointed by @out_bh
+ * On error, one of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - No inode left.
+ */
+
+int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
+			     struct buffer_head **out_bh)
+{
+	struct nilfs_persistent_req req;
+	int ret;
+
+	req.pr_ino = 0;	/* 0 says find free inode from beginning of
+			   a group. dull code!! */
+	req.pr_entry_bh = NULL;
+
+	ret = nilfs_ifile_prepare_alloc_ino(ifile, &req);
+	if (!ret) {
+		ret = nilfs_ifile_prepare_entry(ifile, &req);
+		if (ret < 0)
+			nilfs_ifile_abort_alloc_ino(ifile, &req);
+	}
+	if (ret < 0) {
+		brelse(req.pr_entry_bh);
+		return ret;
+	}
+	nilfs_persistent_commit_alloc_entry(ifile, &req);
+	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	nilfs_mdt_mark_dirty(ifile);
+	*out_ino = req.pr_ino;
+	*out_bh = req.pr_entry_bh;
+	return 0;
+}
+
+/**
+ * nilfs_ifile_delete_inode - delete a inode
+ * @ifile: ifile inode
+ * @ino: inode number
+ *
+ * Description: nilfs_ifile_delete_inode() deletes the disk inode specified by
+ * @ino, which must have been allocated by a call to nilfs_ifile_create_inode().
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - The inode number @ino have not been allocated.
+ */
+int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
+{
+	struct nilfs_persistent_req req = {
+		.pr_ino = ino, .pr_entry_bh = NULL
+	};
+	unsigned long group = ino / nilfs_persistent_entries_per_group(ifile);
+	int ret;
+
+	ret = nilfs_persistent_prepare_free_entry(ifile, &req, group);
+	if (!ret) {
+		ret = nilfs_ifile_prepare_entry(ifile, &req);
+		if (ret < 0)
+			nilfs_persistent_abort_free_entry(ifile, &req);
+	}
+	if (ret < 0) {
+		brelse(req.pr_entry_bh);
+		return ret;
+	}
+
+	/* XXX: check! race condition mark dirty and put_bh() */
+	nilfs_ifile_commit_free(ifile, &req);
+	brelse(req.pr_entry_bh);
+
+	nilfs_mdt_mark_dirty(ifile);
+
+	return 0;
+}
+
+int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
+				struct buffer_head **out_bh)
+{
+	struct super_block *sb = ifile->i_sb;
+	unsigned long blkoff;
+	int err;
+
+	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
+		nilfs_error(sb, __func__, "bad inode number: %lu",
+			    (unsigned long) ino);
+		return -EINVAL;
+	}
+
+	blkoff = nilfs_ifile_entry_blkoff(ifile, ino);
+	err = nilfs_mdt_read_block(ifile, blkoff, out_bh);
+	if (unlikely(err)) {
+		if (err == -EINVAL)
+			nilfs_error(sb, __func__, "ifile is broken");
+		else
+			nilfs_warning(sb, __func__,
+				      "unable to read inode: %lu",
+				      (unsigned long) ino);
+	}
+	return err;
+}
diff -puN /dev/null fs/nilfs2/ifile.h
--- /dev/null
+++ a/fs/nilfs2/ifile.h
@@ -0,0 +1,47 @@
+/*
+ * ifile.h - NILFS inode file
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>,
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#ifndef _NILFS_IFILE_H
+#define _NILFS_IFILE_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "mdt.h"
+#include "alloc.h"
+
+/* disk inode specific functions */
+extern struct nilfs_inode *nilfs_ifile_map_inode(struct inode *, ino_t,
+						 struct buffer_head *);
+extern void nilfs_ifile_unmap_inode(struct inode *, ino_t,
+				    struct buffer_head *);
+
+int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
+int nilfs_ifile_delete_inode(struct inode *, ino_t);
+int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
+
+#define NILFS_IFILE_GFP  NILFS_MDT_GFP
+#define NILFS_IFILE_GROUPS_COUNT(blkbits) \
+	(1UL << (BITS_PER_LONG - ((blkbits) + 3 /* log2(8) */)))
+
+#endif	/* _NILFS_IFILE_H */
diff -puN /dev/null fs/nilfs2/inode.c
--- /dev/null
+++ a/fs/nilfs2/inode.c
@@ -0,0 +1,825 @@
+/*
+ * inode.c - NILFS inode operations.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/mpage.h>
+#include <linux/writeback.h>
+#include "nilfs.h"
+#include "page.h"
+#include "mdt.h"
+#include "cpfile.h"
+#include "ifile.h"
+
+
+/**
+ * nilfs_get_block() - get a file block on the filesystem (callback function)
+ * @inode - inode struct of the target file
+ * @blkoff - file block number
+ * @bh_result - buffer head to be mapped on
+ * @create - indicate whether allocating the block or not when it has not
+ *      been allocated yet.
+ *
+ * This function does not issue actual read request of the specified data
+ * block. It is done by VFS.
+ * Bulk read for direct-io is not supported yet. (should be supported)
+ */
+int nilfs_get_block(struct inode *inode, sector_t blkoff,
+		    struct buffer_head *bh_result, int create)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	unsigned long blknum = 0;
+	int err = 0, ret;
+	struct inode *dat = nilfs_dat_inode(NILFS_I_NILFS(inode));
+
+	/* This exclusion control is a workaround; should be revised */
+	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	ret = nilfs_bmap_lookup(ii->i_bmap, (unsigned long)blkoff, &blknum);
+	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	if (ret == 0) {	/* found */
+		map_bh(bh_result, inode->i_sb, blknum);
+		goto out;
+	}
+	if (unlikely(ret == 1)) {
+		printk(KERN_ERR "nilfs_get_block: bmap_lookup returns "
+		       "buffer_head pointer (blkoff=%llu, blknum=%lu)\n",
+		       (unsigned long long)blkoff, blknum);
+		BUG();
+	}
+	/* data block was not found */
+	if (ret == -ENOENT && create) {
+		struct nilfs_transaction_info ti;
+
+		bh_result->b_blocknr = 0;
+		err = nilfs_transaction_begin(inode->i_sb, &ti, 1);
+		if (unlikely(err))
+			goto out;
+		err = nilfs_bmap_insert(ii->i_bmap, (unsigned long)blkoff,
+					(unsigned long)bh_result);
+		nilfs_transaction_end(inode->i_sb, !err);
+		if (unlikely(err != 0)) {
+			if (err == -EEXIST) {
+				/*
+				 * The get_block() function could be called
+				 * from multiple callers for an inode.
+				 * However, the page having this block must
+				 * be locked in this case.
+				 */
+				printk(KERN_ERR
+				       "nilfs_get_block: a race condition "
+				       "while inserting a data block. "
+				       "(inode number=%lu, file block "
+				       "offset=%llu)\n",
+				       inode->i_ino,
+				       (unsigned long long)blkoff);
+				BUG();
+			} else if (err == -EINVAL) {
+				nilfs_error(inode->i_sb, __func__,
+					    "broken bmap (inode=%lu)\n",
+					    inode->i_ino);
+				err = -EIO;
+			}
+			goto out;
+		}
+		/* Error handling should be detailed */
+		set_buffer_new(bh_result);
+		map_bh(bh_result, inode->i_sb, 0); /* dbn must be changed
+						      to proper value */
+	} else if (ret == -ENOENT) {
+		/* not found is not error (e.g. hole); must return without
+		   the mapped state flag. */
+		;
+	} else {
+		err = ret;
+	}
+
+ out:
+	return err;
+}
+
+/**
+ * nilfs_readpage() - implement readpage() method of nilfs_aops {}
+ * address_space_operations.
+ * @file - file struct of the file to be read
+ * @page - the page to be read
+ */
+static int nilfs_readpage(struct file *file, struct page *page)
+{
+	return mpage_readpage(page, nilfs_get_block);
+}
+
+/**
+ * nilfs_readpages() - implement readpages() method of nilfs_aops {}
+ * address_space_operations.
+ * @file - file struct of the file to be read
+ * @mapping - address_space struct used for reading multiple pages
+ * @pages - the pages to be read
+ * @nr_pages - number of pages to be read
+ */
+static int nilfs_readpages(struct file *file, struct address_space *mapping,
+			   struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, nilfs_get_block);
+}
+
+static int nilfs_writepages(struct address_space *mapping,
+			    struct writeback_control *wbc)
+{
+	/* This empty method is required not to call generic_writepages() */
+	return 0;
+}
+
+static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	int err;
+
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+
+	if (wbc->sync_mode == WB_SYNC_ALL) {
+		err = nilfs_construct_segment(inode->i_sb);
+		if (unlikely(err))
+			return err;
+	} else if (wbc->for_reclaim)
+		nilfs_flush_segment(inode->i_sb, inode->i_ino);
+
+	return 0;
+}
+
+static int nilfs_set_page_dirty(struct page *page)
+{
+	int ret = __set_page_dirty_buffers(page);
+
+	if (ret) {
+		struct inode *inode = page->mapping->host;
+		struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+
+		nilfs_set_file_dirty(sbi, inode, nr_dirty);
+	}
+	return ret;
+}
+
+static int nilfs_write_begin(struct file *file, struct address_space *mapping,
+			     loff_t pos, unsigned len, unsigned flags,
+			     struct page **pagep, void **fsdata)
+
+{
+	struct inode *inode = mapping->host;
+	int err = nilfs_transaction_begin(inode->i_sb, NULL, 1);
+
+	if (unlikely(err))
+		return err;
+
+	*pagep = NULL;
+	err = block_write_begin(file, mapping, pos, len, flags, pagep,
+				fsdata, nilfs_get_block);
+	if (unlikely(err))
+		nilfs_transaction_end(inode->i_sb, 0);
+	return err;
+}
+
+static int nilfs_write_end(struct file *file, struct address_space *mapping,
+			   loff_t pos, unsigned len, unsigned copied,
+			   struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	unsigned start = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned nr_dirty;
+	int err;
+
+	nr_dirty = nilfs_page_count_clean_buffers(page, start,
+						  start + copied);
+	copied = generic_write_end(file, mapping, pos, len, copied, page,
+				   fsdata);
+	nilfs_set_file_dirty(NILFS_SB(inode->i_sb), inode, nr_dirty);
+	err = nilfs_transaction_end(inode->i_sb, 1);
+	return err ? : copied;
+}
+
+static ssize_t
+nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
+		loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t size;
+	int err;
+
+	err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+	if (unlikely(err))
+		return err;
+
+	if (rw == WRITE)
+		return 0;
+
+	/* Needs synchronization with the cleaner */
+	size = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+				  offset, nr_segs, nilfs_get_block, NULL);
+	return size;
+}
+
+struct address_space_operations nilfs_aops = {
+	.writepage		= nilfs_writepage,
+	.readpage		= nilfs_readpage,
+	/* .sync_page		= nilfs_sync_page, */
+	.writepages		= nilfs_writepages,
+	.set_page_dirty		= nilfs_set_page_dirty,
+	.readpages		= nilfs_readpages,
+	.write_begin		= nilfs_write_begin,
+	.write_end		= nilfs_write_end,
+	/* .releasepage		= nilfs_releasepage, */
+	.invalidatepage		= block_invalidatepage,
+	.direct_IO		= nilfs_direct_IO,
+};
+
+struct inode *nilfs_new_inode(struct inode *dir, int mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct inode *inode;
+	struct nilfs_inode_info *ii;
+	int err = -ENOMEM;
+	ino_t ino;
+
+	inode = new_inode(sb);
+	if (unlikely(!inode))
+		goto failed;
+
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+
+	ii = NILFS_I(inode);
+	ii->i_state = 1 << NILFS_I_NEW;
+
+	err = nilfs_ifile_create_inode(sbi->s_ifile, &ino, &ii->i_bh);
+	if (unlikely(err))
+		goto failed_ifile_create_inode;
+	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
+
+	atomic_inc(&sbi->s_inodes_count);
+
+	inode->i_uid = current->fsuid;
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode->i_gid = current->fsgid;
+
+	inode->i_mode = mode;
+	inode->i_ino = ino;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+
+	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)) {
+		err = nilfs_bmap_read(ii->i_bmap, NULL);
+		if (err < 0)
+			goto failed_bmap;
+
+		set_bit(NILFS_I_BMAP, &ii->i_state);
+		/* No lock is needed; iget() ensures it. */
+	}
+
+	ii->i_flags = NILFS_I(dir)->i_flags;
+	if (S_ISLNK(mode))
+		ii->i_flags &= ~(NILFS_IMMUTABLE_FL | NILFS_APPEND_FL);
+	if (!S_ISDIR(mode))
+		ii->i_flags &= ~NILFS_DIRSYNC_FL;
+
+	/* ii->i_file_acl = 0; */
+	/* ii->i_dir_acl = 0; */
+	ii->i_dtime = 0;
+	ii->i_dir_start_lookup = 0;
+#ifdef CONFIG_NILFS_FS_POSIX_ACL
+	ii->i_acl = NULL;
+	ii->i_default_acl = NULL;
+#endif
+	ii->i_cno = 0;
+	nilfs_set_inode_flags(inode);
+	spin_lock(&sbi->s_next_gen_lock);
+	inode->i_generation = sbi->s_next_generation++;
+	spin_unlock(&sbi->s_next_gen_lock);
+	insert_inode_hash(inode);
+
+	err = nilfs_init_acl(inode, dir);
+	if (unlikely(err))
+		goto failed_acl; /* never occur. When supporting
+				    nilfs_init_acl(), proper cancellation of
+				    above jobs should be considered */
+
+	mark_inode_dirty(inode);
+	return inode;
+
+ failed_acl:
+ failed_bmap:
+	inode->i_nlink = 0;
+	iput(inode);  /* raw_inode will be deleted through
+			 generic_delete_inode() */
+	goto failed;
+
+ failed_ifile_create_inode:
+	make_bad_inode(inode);
+	iput(inode);  /* if i_nlink == 1, generic_forget_inode() will be
+			 called */
+ failed:
+	return ERR_PTR(err);
+}
+
+void nilfs_free_inode(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+
+	clear_inode(inode);
+	/* XXX: check error code? Is there any thing can I do? */
+	(void) nilfs_ifile_delete_inode(sbi->s_ifile, inode->i_ino);
+	atomic_dec(&sbi->s_inodes_count);
+}
+
+void nilfs_set_inode_flags(struct inode *inode)
+{
+	unsigned int flags = NILFS_I(inode)->i_flags;
+
+	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
+			    S_DIRSYNC);
+	if (flags & NILFS_SYNC_FL)
+		inode->i_flags |= S_SYNC;
+	if (flags & NILFS_APPEND_FL)
+		inode->i_flags |= S_APPEND;
+	if (flags & NILFS_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+#ifndef NILFS_ATIME_DISABLE
+	if (flags & NILFS_NOATIME_FL)
+#endif
+		inode->i_flags |= S_NOATIME;
+	if (flags & NILFS_DIRSYNC_FL)
+		inode->i_flags |= S_DIRSYNC;
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+}
+
+int nilfs_read_inode_common(struct inode *inode,
+			    struct nilfs_inode *raw_inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int err;
+
+	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
+	inode->i_uid = (uid_t)le32_to_cpu(raw_inode->i_uid);
+	inode->i_gid = (gid_t)le32_to_cpu(raw_inode->i_gid);
+	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
+	inode->i_size = le64_to_cpu(raw_inode->i_size);
+	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
+	inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
+	inode->i_mtime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
+	inode->i_atime.tv_nsec = 0;
+	inode->i_ctime.tv_nsec = 0;
+	inode->i_mtime.tv_nsec = 0;
+	ii->i_dtime = le64_to_cpu(raw_inode->i_dtime);
+	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ii->i_dtime))
+		return -EINVAL; /* this inode is deleted */
+
+	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
+	ii->i_flags = le32_to_cpu(raw_inode->i_flags);
+#if 0
+	ii->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
+	ii->i_dir_acl = S_ISREG(inode->i_mode) ?
+		0 : le32_to_cpu(raw_inode->i_dir_acl);
+#endif
+	ii->i_cno = 0;
+	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
+
+	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+	    S_ISLNK(inode->i_mode)) {
+		err = nilfs_bmap_read(ii->i_bmap, raw_inode);
+		if (err < 0)
+			return err;
+		set_bit(NILFS_I_BMAP, &ii->i_state);
+		/* No lock is needed; iget() ensures it. */
+	}
+	return 0;
+}
+
+static int nilfs_read_sketch_inode(struct inode *inode)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+	int err = 0;
+
+	if (sbi->s_snapshot_cno) {
+		struct the_nilfs *nilfs = sbi->s_nilfs;
+		struct buffer_head *bh_cp;
+		struct nilfs_checkpoint *raw_cp;
+
+		err = nilfs_cpfile_get_checkpoint(
+			nilfs->ns_cpfile, sbi->s_snapshot_cno, 0, &raw_cp,
+			&bh_cp);
+		if (likely(!err)) {
+			if (!nilfs_checkpoint_sketch(raw_cp))
+				inode->i_size = 0;
+			nilfs_cpfile_put_checkpoint(
+				nilfs->ns_cpfile, sbi->s_snapshot_cno, bh_cp);
+		}
+		inode->i_flags |= S_NOCMTIME;
+	}
+	return err;
+}
+
+static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
+			      struct inode *inode)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct inode *dat = nilfs_dat_inode(sbi->s_nilfs);
+	struct buffer_head *bh;
+	struct nilfs_inode *raw_inode;
+	int err;
+
+	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	err = nilfs_ifile_get_inode_block(sbi->s_ifile, ino, &bh);
+	if (unlikely(err))
+		goto bad_inode;
+
+	raw_inode = nilfs_ifile_map_inode(sbi->s_ifile, ino, bh);
+
+	if (unlikely(raw_inode->i_flags &
+		     cpu_to_le32(NILFS_INODE_NEW | NILFS_INODE_UNUSED))) {
+		nilfs_warning(sb, __func__,
+			      "read request for unused inode: %lu", ino);
+		goto failed_unmap;
+	}
+
+#ifdef CONFIG_NILFS_FS_POSIX_ACL
+	ii->i_acl = NILFS_ACL_NOT_CACHED;
+	ii->i_default_acl = NILFS_ACL_NOT_CACHED;
+#endif
+	if (nilfs_read_inode_common(inode, raw_inode))
+		goto failed_unmap;
+
+	if (S_ISREG(inode->i_mode)) {
+		inode->i_op = &nilfs_file_inode_operations;
+		inode->i_fop = &nilfs_file_operations;
+		inode->i_mapping->a_ops = &nilfs_aops;
+		if (unlikely(inode->i_ino == NILFS_SKETCH_INO)) {
+			err = nilfs_read_sketch_inode(inode);
+			if (unlikely(err))
+				goto failed_unmap;
+		}
+	} else if (S_ISDIR(inode->i_mode)) {
+		inode->i_op = &nilfs_dir_inode_operations;
+		inode->i_fop = &nilfs_dir_operations;
+		inode->i_mapping->a_ops = &nilfs_aops;
+	} else if (S_ISLNK(inode->i_mode)) {
+		inode->i_op = &nilfs_symlink_inode_operations;
+		inode->i_mapping->a_ops = &nilfs_aops;
+	} else {
+		inode->i_op = &nilfs_special_inode_operations;
+		init_special_inode(
+			inode, inode->i_mode,
+			new_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
+	}
+	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, bh);
+	brelse(bh);
+	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	nilfs_set_inode_flags(inode);
+	return 0;
+
+ failed_unmap:
+	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, bh);
+	brelse(bh);
+
+ bad_inode:
+	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	return err;
+}
+
+struct inode *nilfs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct inode *inode;
+	int err;
+
+	inode = iget_locked(sb, ino);
+	if (unlikely(!inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	err = __nilfs_read_inode(sb, ino, inode);
+	if (unlikely(err)) {
+		iget_failed(inode);
+		return ERR_PTR(err);
+	}
+	unlock_new_inode(inode);
+	return inode;
+}
+
+void nilfs_write_inode_common(struct inode *inode,
+			      struct nilfs_inode *raw_inode, int has_bmap)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+
+	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
+	raw_inode->i_uid = cpu_to_le32(inode->i_uid);
+	raw_inode->i_gid = cpu_to_le32(inode->i_gid);
+	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
+	raw_inode->i_size = cpu_to_le64(inode->i_size);
+	raw_inode->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
+	raw_inode->i_mtime = cpu_to_le64(inode->i_mtime.tv_sec);
+	raw_inode->i_blocks = cpu_to_le64(inode->i_blocks);
+
+	raw_inode->i_dtime = cpu_to_le64(ii->i_dtime);
+	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
+	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
+
+	if (has_bmap)
+		nilfs_bmap_write(ii->i_bmap, raw_inode);
+	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
+		raw_inode->i_device_code =
+			cpu_to_le64(new_encode_dev(inode->i_rdev));
+	/* When extending inode, nilfs->ns_inode_size should be checked
+	   for substitutions of appended fields */
+}
+
+void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
+{
+	ino_t ino = inode->i_ino;
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_inode *raw_inode;
+
+	raw_inode = nilfs_ifile_map_inode(sbi->s_ifile, ino, ibh);
+
+	/* The buffer is guarded with lock_buffer() by the caller */
+	if (test_and_clear_bit(NILFS_I_NEW, &ii->i_state))
+		memset(raw_inode, 0, NILFS_MDT(sbi->s_ifile)->mi_entry_size);
+	set_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
+
+	nilfs_write_inode_common(inode, raw_inode, 0);
+		/* XXX: call with has_bmap = 0 is a workaround to avoid
+		   deadlock of bmap. This delays update of i_bmap to just
+		   before writing */
+	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, ibh);
+}
+
+#define NILFS_MAX_TRUNCATE_BLOCKS	16384  /* 64MB for 4KB block */
+
+static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
+				unsigned long from)
+{
+	unsigned long b;
+	int ret;
+
+	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
+		return;
+ repeat:
+	ret = nilfs_bmap_last_key(ii->i_bmap, &b);
+	if (ret == -ENOENT)
+		return;
+	else if (ret < 0)
+		goto failed;
+
+	if (b < from)
+		return;
+
+	b -= min_t(unsigned long, NILFS_MAX_TRUNCATE_BLOCKS, b - from);
+	ret = nilfs_bmap_truncate(ii->i_bmap, b);
+	nilfs_relax_pressure_in_lock(ii->vfs_inode.i_sb);
+	if (!ret || (ret == -ENOMEM &&
+		     nilfs_bmap_truncate(ii->i_bmap, b) == 0))
+		goto repeat;
+
+ failed:
+	if (ret == -EINVAL)
+		nilfs_error(ii->vfs_inode.i_sb, __func__,
+			    "bmap is broken (ino=%lu)", ii->vfs_inode.i_ino);
+	else
+		nilfs_warning(ii->vfs_inode.i_sb, __func__,
+			      "failed to truncate bmap (ino=%lu, err=%d)",
+			      ii->vfs_inode.i_ino, ret);
+}
+
+void nilfs_truncate(struct inode *inode)
+{
+	unsigned long blkoff;
+	unsigned int blocksize;
+	struct nilfs_transaction_info ti;
+	struct super_block *sb = inode->i_sb;
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int ret;
+
+	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
+		return;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return;
+
+	blocksize = sb->s_blocksize;
+	blkoff = (inode->i_size + blocksize - 1) >> NILFS_BLOCK_SIZE_BITS(sb);
+	ret = nilfs_transaction_begin(sb, &ti, 0);
+	BUG_ON(ret);
+
+	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
+
+	nilfs_truncate_bmap(ii, blkoff);
+
+	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	if (IS_SYNC(inode))
+		nilfs_set_transaction_flag(NILFS_TI_SYNC);
+
+	nilfs_set_file_dirty(NILFS_SB(sb), inode, 0);
+	nilfs_transaction_end(sb, 1);
+	/* May construct a logical segment and may fail in sync mode.
+	   But truncate has no return value. */
+}
+
+void nilfs_delete_inode(struct inode *inode)
+{
+	struct nilfs_transaction_info ti;
+	struct super_block *sb = inode->i_sb;
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int err;
+
+	if (unlikely(is_bad_inode(inode))) {
+		if (inode->i_data.nrpages)
+			truncate_inode_pages(&inode->i_data, 0);
+		clear_inode(inode);
+		return;
+	}
+	err = nilfs_transaction_begin(sb, &ti, 0);
+	BUG_ON(err);
+	if (inode->i_data.nrpages)
+		truncate_inode_pages(&inode->i_data, 0);
+
+	nilfs_truncate_bmap(ii, 0);
+	nilfs_free_inode(inode);
+	/* nilfs_free_inode() marks inode buffer dirty */
+	if (IS_SYNC(inode))
+		nilfs_set_transaction_flag(NILFS_TI_SYNC);
+	nilfs_transaction_end(sb, 1);
+	/* May construct a logical segment and may fail in sync mode.
+	   But delete_inode has no return value. */
+}
+
+int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct nilfs_transaction_info ti;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	int err, err2;
+
+	err = inode_change_ok(inode, iattr);
+	if (err)
+		return err;
+
+	err = nilfs_transaction_begin(sb, &ti, 0);
+	if (unlikely(err))
+		return err;
+	err = inode_setattr(inode, iattr);
+	if (!err && (iattr->ia_valid & ATTR_MODE))
+		err = nilfs_acl_chmod(inode);
+	err2 = nilfs_transaction_end(sb, 1);
+	return err ? : err2;
+}
+
+int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
+			   struct buffer_head **pbh)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int err;
+
+	spin_lock(&sbi->s_inode_lock);
+	/* Caller of this function MUST lock s_inode_lock */
+	if (ii->i_bh == NULL) {
+		spin_unlock(&sbi->s_inode_lock);
+		err = nilfs_ifile_get_inode_block(sbi->s_ifile, inode->i_ino,
+						  pbh);
+		if (unlikely(err))
+			return err;
+		spin_lock(&sbi->s_inode_lock);
+		if (ii->i_bh == NULL)
+			ii->i_bh = *pbh;
+		else {
+			brelse(*pbh);
+			*pbh = ii->i_bh;
+		}
+	} else
+		*pbh = ii->i_bh;
+
+	get_bh(*pbh);
+	spin_unlock(&sbi->s_inode_lock);
+	return 0;
+}
+
+int nilfs_inode_dirty(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+	int ret = 0;
+
+	if (!list_empty(&ii->i_dirty)) {
+		spin_lock(&sbi->s_inode_lock);
+		ret = test_bit(NILFS_I_DIRTY, &ii->i_state) ||
+			test_bit(NILFS_I_BUSY, &ii->i_state);
+		spin_unlock(&sbi->s_inode_lock);
+	}
+	return ret;
+}
+
+int nilfs_set_file_dirty(struct nilfs_sb_info *sbi, struct inode *inode,
+			 unsigned nr_dirty)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+
+	atomic_add(nr_dirty, &sbi->s_nilfs->ns_ndirtyblks);
+
+	if (test_and_set_bit(NILFS_I_DIRTY, &ii->i_state) ||
+	    unlikely(inode->i_ino == NILFS_SKETCH_INO))
+		return 0;
+
+	spin_lock(&sbi->s_inode_lock);
+	if (!test_bit(NILFS_I_QUEUED, &ii->i_state) &&
+	    !test_bit(NILFS_I_BUSY, &ii->i_state)) {
+		/* Because this routine may race with nilfs_dispose_list(),
+		   we have to check NILFS_I_QUEUED here, too. */
+		if (list_empty(&ii->i_dirty) && igrab(inode) == NULL) {
+			/* This will happen when somebody is freeing
+			   this inode. */
+			nilfs_warning(sbi->s_super, __func__,
+				      "cannot get inode (ino=%lu)\n",
+				      inode->i_ino);
+			spin_unlock(&sbi->s_inode_lock);
+			return -EINVAL; /* NILFS_I_DIRTY may remain for
+					   freeing inode */
+		}
+		list_del(&ii->i_dirty);
+		list_add_tail(&ii->i_dirty, &sbi->s_dirty_files);
+		set_bit(NILFS_I_QUEUED, &ii->i_state);
+	}
+	spin_unlock(&sbi->s_inode_lock);
+	return 0;
+}
+
+int nilfs_mark_inode_dirty(struct inode *inode)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+	struct buffer_head *ibh;
+	int err;
+
+	err = nilfs_load_inode_block(sbi, inode, &ibh);
+	if (unlikely(err)) {
+		nilfs_warning(inode->i_sb, __func__,
+			      "failed to reget inode block.\n");
+		return err;
+	}
+	lock_buffer(ibh);
+	nilfs_update_inode(inode, ibh);
+	unlock_buffer(ibh);
+	nilfs_mdt_mark_buffer_dirty(ibh);
+	nilfs_mdt_mark_dirty(sbi->s_ifile);
+	brelse(ibh);
+	return 0;
+}
+
+/**
+ * nilfs_dirty_inode - reflect changes on given inode to an inode block.
+ * @inode: inode of the file to be registered.
+ *
+ * nilfs_dirty_inode() loads a inode block containing the specified
+ * @inode and copies data from a nilfs_inode to a corresponding inode
+ * entry in the inode block. This operation is excluded from the segment
+ * construction. This function can be called both as a single operation
+ * and as a part of indivisible file operations.
+ */
+void nilfs_dirty_inode(struct inode *inode)
+{
+	struct nilfs_transaction_info ti;
+
+	if (is_bad_inode(inode)) {
+		nilfs_warning(inode->i_sb, __func__,
+			      "tried to mark bad_inode dirty. ignored.\n");
+		dump_stack();
+		return;
+	}
+	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	if (likely(inode->i_ino != NILFS_SKETCH_INO))
+		nilfs_mark_inode_dirty(inode);
+	nilfs_transaction_end(inode->i_sb, 1); /* never fails */
+}
diff -puN /dev/null fs/nilfs2/ioctl.c
--- /dev/null
+++ a/fs/nilfs2/ioctl.c
@@ -0,0 +1,1009 @@
+/*
+ * ioctl.c - NILFS ioctl operations.
+ *
+ * Copyright (C) 2007, 2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/fs.h>
+#include <linux/wait.h>
+#include <linux/smp_lock.h>	/* lock_kernel(), unlock_kernel() */
+#include <linux/capability.h>	/* capable() */
+#include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
+#include <linux/nilfs2_fs.h>
+#include "nilfs.h"
+#include "sb.h"
+#include "bmap.h"
+#include "cpfile.h"
+#include "sufile.h"
+#include "dat.h"
+
+
+#define KMALLOC_SIZE_MIN	4096	/* 4KB */
+#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
+static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
+				 struct nilfs_argv *argv, int dir,
+				 ssize_t (*dofunc)(struct the_nilfs *,
+						   int, int,
+						   void *, size_t, size_t))
+{
+	void *buf;
+	size_t ksize, maxmembs, total, n;
+	ssize_t nr;
+	int ret, i;
+
+	if (argv->v_nmembs == 0)
+		return 0;
+
+	for (ksize = KMALLOC_SIZE_MAX; ksize >= KMALLOC_SIZE_MIN; ksize /= 2) {
+		buf = kmalloc(ksize, GFP_NOFS);
+		if (buf != NULL)
+			break;
+	}
+	if (ksize < KMALLOC_SIZE_MIN)
+		return -ENOMEM;
+	maxmembs = ksize / argv->v_size;
+
+	ret = 0;
+	total = 0;
+	for (i = 0; i < argv->v_nmembs; i += n) {
+		n = (argv->v_nmembs - i < maxmembs) ?
+			argv->v_nmembs - i : maxmembs;
+		if ((dir & _IOC_WRITE) &&
+		    copy_from_user(buf,
+			    (void __user *)argv->v_base + argv->v_size * i,
+			    argv->v_size * n)) {
+			ret = -EFAULT;
+			break;
+		}
+		nr = (*dofunc)(nilfs, argv->v_index + i, argv->v_flags, buf,
+			       argv->v_size, n);
+		if (nr < 0) {
+			ret = nr;
+			break;
+		}
+		if ((dir & _IOC_READ) &&
+		    copy_to_user(
+			    (void __user *)argv->v_base + argv->v_size * i,
+			    buf, argv->v_size * nr)) {
+			ret = -EFAULT;
+			break;
+		}
+		total += nr;
+	}
+	argv->v_nmembs = total;
+
+	kfree(buf);
+	return ret;
+}
+
+static int
+nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
+			  unsigned int cmd, unsigned long arg)
+{
+	struct inode *cpfile;
+	struct nilfs_transaction_info ti;
+	struct nilfs_cpmode cpmode;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&cpmode, (struct nilfs_cpmode __user *)arg,
+			   sizeof(cpmode)))
+		return -EFAULT;
+	cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_cpfile_change_cpmode(
+		cpfile, cpmode.cm_cno, cpmode.cm_mode);
+	if (nilfs_transaction_end(inode->i_sb, !ret))
+		BUG();
+	return ret;
+}
+
+static int
+nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	struct inode *cpfile;
+	struct nilfs_transaction_info ti;
+	__u64 cno;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&cno, (__u64 __user *)arg, sizeof(cno)))
+		return -EFAULT;
+
+	cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_cpfile_delete_checkpoint(cpfile, cno);
+	if (nilfs_transaction_end(inode->i_sb, !ret))
+		BUG();
+	return ret;
+}
+
+static ssize_t
+nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, int index, int flags,
+			  void *buf, size_t size, size_t nmembs)
+{
+	struct inode *cpfile;
+	struct nilfs_cpinfo *cpinfo;
+
+	cpfile = nilfs->ns_cpfile;
+	cpinfo = (struct nilfs_cpinfo *)buf;
+
+	return nilfs_cpfile_get_cpinfo(cpfile, index, flags, cpinfo, nmembs);
+}
+
+static int nilfs_ioctl_get_cpinfo(struct inode *inode, struct file *filp,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct the_nilfs *nilfs;
+	struct nilfs_argv argv;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	if (copy_from_user(&argv, (struct nilfs_argv __user *)arg,
+			   sizeof(argv)))
+		return -EFAULT;
+
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
+				    nilfs_ioctl_do_get_cpinfo);
+	if (nilfs_transaction_end(inode->i_sb, 0))
+		BUG();
+
+	if (copy_to_user((struct nilfs_argv __user *)arg, &argv, sizeof(argv)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct inode *cpfile;
+	struct nilfs_cpstat cpstat;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_cpfile_get_stat(cpfile, &cpstat);
+	if (nilfs_transaction_end(inode->i_sb, 0))
+		BUG();
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user((struct nilfs_cpstat __user *)arg, &cpstat,
+			 sizeof(cpstat)))
+		return -EFAULT;
+	return 0;
+}
+
+static ssize_t
+nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, int index, int flags,
+			  void *buf, size_t size, size_t nmembs)
+{
+	struct inode *sufile;
+	struct nilfs_suinfo *suinfo;
+
+	sufile = nilfs->ns_sufile;
+	suinfo = (struct nilfs_suinfo *)buf;
+
+	return nilfs_sufile_get_suinfo(sufile, index, suinfo, nmembs);
+}
+
+static int nilfs_ioctl_get_suinfo(struct inode *inode, struct file *filp,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct the_nilfs *nilfs;
+	struct nilfs_argv argv;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	if (copy_from_user(&argv, (struct nilfs_argv __user *)arg,
+			   sizeof(argv)))
+		return -EFAULT;
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
+				    nilfs_ioctl_do_get_suinfo);
+	if (nilfs_transaction_end(inode->i_sb, 0))
+		BUG();
+
+	if (copy_to_user((struct nilfs_argv __user *)arg, &argv, sizeof(argv)))
+		ret = -EFAULT;
+	return ret;
+}
+
+static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct inode *sufile;
+	struct nilfs_sustat sustat;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	sufile = NILFS_SB(inode->i_sb)->s_nilfs->ns_sufile;
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_sufile_get_stat(sufile, &sustat);
+	if (nilfs_transaction_end(inode->i_sb, 0))
+		BUG();
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user((struct nilfs_sustat __user *)arg, &sustat,
+			 sizeof(sustat)))
+		return -EFAULT;
+	return 0;
+}
+
+static ssize_t
+nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, int index, int flags,
+			 void *buf, size_t size, size_t nmembs)
+{
+	struct inode *dat;
+	struct nilfs_vinfo *vinfo;
+
+	dat = nilfs_dat_inode(nilfs);
+	vinfo = (struct nilfs_vinfo *)buf;
+
+	return nilfs_dat_get_vinfo(dat, vinfo, nmembs);
+}
+
+static int nilfs_ioctl_get_vinfo(struct inode *inode, struct file *filp,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct the_nilfs *nilfs;
+	struct nilfs_argv argv;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	if (copy_from_user(&argv, (struct nilfs_argv __user *)arg,
+			   sizeof(argv)))
+		return -EFAULT;
+
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
+				    nilfs_ioctl_do_get_vinfo);
+	if (nilfs_transaction_end(inode->i_sb, 0))
+		BUG();
+
+	if (copy_to_user((struct nilfs_argv __user *)arg, &argv, sizeof(argv)))
+		ret = -EFAULT;
+	return ret;
+}
+
+static ssize_t
+nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, int index, int flags,
+			  void *buf, size_t size, size_t nmembs)
+{
+	struct inode *dat;
+	struct nilfs_bmap *bmap;
+	struct nilfs_bdesc *bdescs;
+	int ret, i;
+
+	bdescs = (struct nilfs_bdesc *)buf;
+
+	dat = nilfs_dat_inode(nilfs);
+	bmap = NILFS_I(dat)->i_bmap;
+	for (i = 0; i < nmembs; i++) {
+		ret = nilfs_bmap_lookup_at_level(bmap,
+						 bdescs[i].bd_offset,
+						 bdescs[i].bd_level + 1,
+						 &bdescs[i].bd_blocknr);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				return ret;
+			ret = 0;
+			bdescs[i].bd_blocknr = 0;
+		}
+	}
+	return nmembs;
+}
+
+static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct the_nilfs *nilfs;
+	struct nilfs_argv argv;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	if (copy_from_user(&argv, (struct nilfs_argv __user *)arg,
+			   sizeof(argv)))
+		return -EFAULT;
+
+	if (nilfs_transaction_begin(inode->i_sb, &ti, 0))
+		BUG();
+	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
+				    nilfs_ioctl_do_get_bdescs);
+	if (nilfs_transaction_end(inode->i_sb, 0))
+		BUG();
+
+	if (copy_to_user((struct nilfs_argv __user *)arg, &argv, sizeof(argv)))
+		ret = -EFAULT;
+	return ret;
+}
+
+static int nilfs_ioctl_move_inode_block(struct inode *inode,
+					struct nilfs_vdesc *vdesc)
+{
+	int ret;
+
+	if (vdesc->vd_flags == 0) {
+		ret = nilfs_gccache_add_data(inode, vdesc->vd_offset,
+					     vdesc->vd_blocknr,
+					     vdesc->vd_vblocknr);
+		if (ret < 0) {
+			if ((ret == -ENOENT) || (ret == -EEXIST)) {
+				printk(KERN_CRIT "%s: ino = %llu, cno = %llu, "
+				       "offset = %llu, blocknr = %llu, "
+				       "vblocknr = %llu\n",
+				       __func__,
+				       (unsigned long long)vdesc->vd_ino,
+				       (unsigned long long)vdesc->vd_cno,
+				       (unsigned long long)vdesc->vd_offset,
+				       (unsigned long long)vdesc->vd_blocknr,
+				       (unsigned long long)vdesc->vd_vblocknr);
+				BUG();
+			}
+			return ret;
+		}
+	} else {
+		ret = nilfs_gccache_add_node(inode, vdesc->vd_blocknr,
+					     vdesc->vd_vblocknr);
+		if (ret < 0) {
+			if (ret == -EEXIST) {
+				printk(KERN_CRIT "%s: ino = %llu, cno = %llu, "
+				       "blocknr = %llu, vblocknr = %llu\n",
+				       __func__,
+				       (unsigned long long)vdesc->vd_ino,
+				       (unsigned long long)vdesc->vd_cno,
+				       (unsigned long long)vdesc->vd_blocknr,
+				       (unsigned long long)vdesc->vd_vblocknr);
+				BUG();
+			}
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t
+nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, int index, int flags,
+			   void *buf, size_t size, size_t nmembs)
+{
+	struct inode *inode;
+	struct nilfs_vdesc *vdescs;
+	ino_t ino;
+	__u64 cno;
+	int i, j, n, ret;
+
+	vdescs = (struct nilfs_vdesc *)buf;
+
+	for (i = 0; i < nmembs; i += n) {
+		ino = vdescs[i].vd_ino;
+		cno = vdescs[i].vd_cno;
+		inode = nilfs_gc_iget(nilfs, ino, cno);
+		if (inode == NULL)
+			return -ENOMEM;
+		for (j = i, n = 0;
+		     (j < nmembs) && (vdescs[j].vd_ino == ino) &&
+			     (vdescs[j].vd_cno == cno);
+		     j++, n++) {
+			ret = nilfs_ioctl_move_inode_block(inode, &vdescs[j]);
+			if (ret < 0)
+				return ret;
+		}
+		/* XXX: nilfs_gc_iput() ??? */
+	}
+
+	return nmembs;
+}
+
+static inline int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
+					  struct nilfs_argv *argv,
+					  int dir)
+{
+	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
+				     nilfs_ioctl_do_move_blocks);
+}
+
+static ssize_t
+nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, int index,
+				  int flags, void *buf, size_t size,
+				  size_t nmembs)
+{
+	struct inode *cpfile;
+	struct nilfs_period *periods;
+	int ret, i;
+
+	cpfile = nilfs->ns_cpfile;
+	periods = (struct nilfs_period *)buf;
+
+	for (i = 0; i < nmembs; i++) {
+		ret = nilfs_cpfile_delete_checkpoints(
+			cpfile, periods[i].p_start, periods[i].p_end);
+		if (ret < 0)
+			return ret;
+	}
+	return nmembs;
+}
+
+static inline int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
+						 struct nilfs_argv *argv,
+						 int dir)
+{
+	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
+				     nilfs_ioctl_do_delete_checkpoints);
+}
+
+static ssize_t
+nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, int index, int flags,
+			      void *buf, size_t size, size_t nmembs)
+{
+	struct inode *dat;
+	__u64 *vbns;
+	int ret;
+
+	dat = nilfs_dat_inode(nilfs);
+	vbns = (__u64 *)buf;
+
+	ret = nilfs_dat_freev(dat, vbns, nmembs);
+	if (ret < 0)
+		return ret;
+	return nmembs;
+}
+
+static inline int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
+					     struct nilfs_argv *argv,
+					     int dir)
+{
+	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
+				     nilfs_ioctl_do_free_vblocknrs);
+}
+
+static ssize_t
+nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, int index, int flags,
+				 void *buf, size_t size, size_t nmembs)
+{
+	struct inode *dat;
+	struct nilfs_bmap *bmap;
+	struct nilfs_bdesc *bdescs;
+	int ret, i;
+
+	bdescs = (struct nilfs_bdesc *)buf;
+
+	dat = nilfs_dat_inode(nilfs);
+	bmap = NILFS_I(dat)->i_bmap;
+	for (i = 0; i < nmembs; i++) {
+		/* XXX: use macro or inline func to check liveness */
+		ret = nilfs_bmap_lookup_at_level(bmap,
+						 bdescs[i].bd_offset,
+						 bdescs[i].bd_level + 1,
+						 &bdescs[i].bd_blocknr);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				return ret;
+			ret = 0;
+			bdescs[i].bd_blocknr = 0;
+		}
+		if (bdescs[i].bd_blocknr != bdescs[i].bd_oblocknr)
+			/* skip dead block */
+			continue;
+		if (bdescs[i].bd_level == 0) {
+			ret = nilfs_mdt_mark_block_dirty(dat,
+							 bdescs[i].bd_offset);
+			if (ret < 0) {
+				BUG_ON(ret == -ENOENT);
+				return ret;
+			}
+		} else {
+			ret = nilfs_bmap_mark(bmap, bdescs[i].bd_offset,
+					      bdescs[i].bd_level);
+			if (ret < 0) {
+				BUG_ON(ret == -ENOENT);
+				return ret;
+			}
+		}
+	}
+
+	return nmembs;
+}
+
+static inline int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
+						struct nilfs_argv *argv,
+						int dir)
+{
+	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
+				     nilfs_ioctl_do_mark_blocks_dirty);
+}
+
+static ssize_t
+nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, int index, int flags,
+			     void *buf, size_t size, size_t nmembs)
+{
+	struct nilfs_sb_info *sbi;
+	__u64 *segnums;
+	int ret;
+
+	segnums = (__u64 *)buf;
+
+	sbi = nilfs_get_writer(nilfs);
+	ret = nilfs_segctor_add_segments_to_be_freed(
+		NILFS_SC(sbi), segnums, nmembs);
+	nilfs_put_writer(nilfs);
+
+	if (ret < 0)
+		return ret;
+	return nmembs;
+}
+
+static inline int nilfs_ioctl_free_segments(struct the_nilfs *nilfs,
+					     struct nilfs_argv *argv,
+					     int dir)
+{
+	return nilfs_ioctl_wrap_copy(nilfs, argv, dir,
+				     nilfs_ioctl_do_free_segments);
+}
+
+int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
+				       unsigned long arg)
+{
+	struct nilfs_argv argv[5];
+	int dir, ret;
+
+	if (copy_from_user(argv, (struct nilfs_argv __user *)arg,
+			   sizeof(argv)))
+		return -EFAULT;
+
+	dir = _IOC_WRITE;
+	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], dir);
+	if (ret < 0)
+		goto out_move_blks;
+	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], dir);
+	if (ret < 0)
+		goto out_del_cps;
+	ret = nilfs_ioctl_free_vblocknrs(nilfs, &argv[2], dir);
+	if (ret < 0)
+		goto out_free_vbns;
+	ret = nilfs_ioctl_mark_blocks_dirty(nilfs, &argv[3], dir);
+	if (ret < 0)
+		goto out_free_vbns;
+	ret = nilfs_ioctl_free_segments(nilfs, &argv[4], dir);
+	if (ret < 0)
+		goto out_free_segs;
+
+	/* success */
+	return 0;
+
+	/* error */
+ out_free_segs:
+	/* XXX: not implemented yet */
+	BUG();
+ out_free_vbns:
+	/* XXX: not implemented yet */
+	BUG();
+ out_del_cps:
+	/* XXX: not implemented yet */
+	BUG();
+ out_move_blks:
+	nilfs_remove_all_gcinode(nilfs);
+	return ret;
+}
+
+static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct the_nilfs *nilfs;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = nilfs_clean_segments(inode->i_sb, arg);
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	clear_nilfs_cond_nongc_write(nilfs);
+	return ret;
+}
+
+static int nilfs_ioctl_test_cond(struct the_nilfs *nilfs, int cond)
+{
+	return (cond & NILFS_TIMEDWAIT_SEG_WRITE) &&
+		nilfs_cond_nongc_write(nilfs);
+}
+
+static void nilfs_ioctl_clear_cond(struct the_nilfs *nilfs, int cond)
+{
+	if (cond & NILFS_TIMEDWAIT_SEG_WRITE)
+		clear_nilfs_cond_nongc_write(nilfs);
+}
+
+static int nilfs_ioctl_timedwait(struct inode *inode, struct file *filp,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct the_nilfs *nilfs;
+	struct nilfs_wait_cond wc;
+	long ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	if (copy_from_user(&wc, (struct nilfs_wait_cond __user *)arg,
+			   sizeof(wc)))
+		return -EFAULT;
+
+	unlock_kernel();
+	ret = wc.wc_flags ?
+		wait_event_interruptible_timeout(
+			nilfs->ns_cleanerd_wq,
+			nilfs_ioctl_test_cond(nilfs, wc.wc_cond),
+			timespec_to_jiffies(&wc.wc_timeout)) :
+		wait_event_interruptible(
+			nilfs->ns_cleanerd_wq,
+			nilfs_ioctl_test_cond(nilfs, wc.wc_cond));
+	lock_kernel();
+	nilfs_ioctl_clear_cond(nilfs, wc.wc_cond);
+
+	if (ret > 0) {
+		jiffies_to_timespec(ret, &wc.wc_timeout);
+		if (copy_to_user((struct nilfs_wait_cond __user *)arg, &wc,
+				 sizeof(wc)))
+			return -EFAULT;
+		return 0;
+	} else if (ret == 0) {
+		return wc.wc_flags ? -ETIME : 0;
+	} else {
+		return -EINTR;
+	}
+}
+
+static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
+			    unsigned int cmd, unsigned long arg)
+{
+	__u64 cno;
+	int ret;
+
+	ret = nilfs_construct_segment(inode->i_sb);
+	if (ret < 0)
+		return ret;
+
+	if ((__u64 __user *)arg == NULL)
+		return 0;
+	cno = NILFS_SB(inode->i_sb)->s_nilfs->ns_cno - 1;
+	if (copy_to_user((__u64 __user *)arg, &cno, sizeof(cno)))
+		return -EFAULT;
+	return 0;
+}
+
+int nilfs_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case NILFS_IOCTL_CHANGE_CPMODE:
+		return nilfs_ioctl_change_cpmode(inode, filp, cmd, arg);
+	case NILFS_IOCTL_DELETE_CHECKPOINT:
+		return nilfs_ioctl_delete_checkpoint(inode, filp, cmd, arg);
+	case NILFS_IOCTL_GET_CPINFO:
+		return nilfs_ioctl_get_cpinfo(inode, filp, cmd, arg);
+	case NILFS_IOCTL_GET_CPSTAT:
+		return nilfs_ioctl_get_cpstat(inode, filp, cmd, arg);
+	case NILFS_IOCTL_GET_SUINFO:
+		return nilfs_ioctl_get_suinfo(inode, filp, cmd, arg);
+	case NILFS_IOCTL_GET_SUSTAT:
+		return nilfs_ioctl_get_sustat(inode, filp, cmd, arg);
+	case NILFS_IOCTL_GET_VINFO:
+		/* XXX: rename to ??? */
+		return nilfs_ioctl_get_vinfo(inode, filp, cmd, arg);
+	case NILFS_IOCTL_GET_BDESCS:
+		return nilfs_ioctl_get_bdescs(inode, filp, cmd, arg);
+	case NILFS_IOCTL_CLEAN_SEGMENTS:
+		return nilfs_ioctl_clean_segments(inode, filp, cmd, arg);
+	case NILFS_IOCTL_TIMEDWAIT:
+		return nilfs_ioctl_timedwait(inode, filp, cmd, arg);
+	case NILFS_IOCTL_SYNC:
+		return nilfs_ioctl_sync(inode, filp, cmd, arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+/* compat_ioctl */
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+
+static int nilfs_compat_locked_ioctl(struct inode *inode, struct file *filp,
+				     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = nilfs_ioctl(inode, filp, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
+static int
+nilfs_compat_ioctl_uargv32_to_uargv(struct nilfs_argv32 __user *uargv32,
+				    struct nilfs_argv __user *uargv)
+{
+	compat_uptr_t base;
+	compat_size_t nmembs, size;
+	compat_int_t index, flags;
+
+	if (get_user(base, &uargv32->v_base) ||
+	    put_user(compat_ptr(base), &uargv->v_base) ||
+	    get_user(nmembs, &uargv32->v_nmembs) ||
+	    put_user(nmembs, &uargv->v_nmembs) ||
+	    get_user(size, &uargv32->v_size) ||
+	    put_user(size, &uargv->v_size) ||
+	    get_user(index, &uargv32->v_index) ||
+	    put_user(index, &uargv->v_index) ||
+	    get_user(flags, &uargv32->v_flags) ||
+	    put_user(flags, &uargv->v_flags))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+nilfs_compat_ioctl_uargv_to_uargv32(struct nilfs_argv __user *uargv,
+				    struct nilfs_argv32 __user *uargv32)
+{
+	size_t nmembs;
+
+	if (get_user(nmembs, &uargv->v_nmembs) ||
+	    put_user(nmembs, &uargv32->v_nmembs))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+nilfs_compat_ioctl_get_by_argv(struct inode *inode, struct file *filp,
+			       unsigned int cmd, unsigned long arg)
+{
+	struct nilfs_argv __user *uargv;
+	struct nilfs_argv32 __user *uargv32;
+	int ret;
+
+	uargv = compat_alloc_user_space(sizeof(struct nilfs_argv));
+	uargv32 = compat_ptr(arg);
+	ret = nilfs_compat_ioctl_uargv32_to_uargv(uargv32, uargv);
+	if (ret < 0)
+		return ret;
+
+	ret = nilfs_compat_locked_ioctl(inode, filp, cmd, (unsigned long)uargv);
+	if (ret < 0)
+		return ret;
+
+	return nilfs_compat_ioctl_uargv_to_uargv32(uargv, uargv32);
+}
+
+static int
+nilfs_compat_ioctl_change_cpmode(struct inode *inode, struct file *filp,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct nilfs_cpmode __user *ucpmode;
+	struct nilfs_cpmode32 __user *ucpmode32;
+	int mode;
+
+	ucpmode = compat_alloc_user_space(sizeof(struct nilfs_cpmode));
+	ucpmode32 = compat_ptr(arg);
+	if (copy_in_user(&ucpmode->cm_cno, &ucpmode32->cm_cno,
+			 sizeof(__u64)) ||
+	    get_user(mode, &ucpmode32->cm_mode) ||
+	    put_user(mode, &ucpmode->cm_mode))
+		return -EFAULT;
+
+	return nilfs_compat_locked_ioctl(
+		inode, filp, cmd, (unsigned long)ucpmode);
+}
+
+
+static inline int
+nilfs_compat_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
+				     unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_locked_ioctl(inode, filp, cmd, arg);
+}
+
+static inline int
+nilfs_compat_ioctl_get_cpinfo(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
+}
+
+static inline int
+nilfs_compat_ioctl_get_cpstat(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_locked_ioctl(inode, filp, cmd, arg);
+}
+
+static inline int
+nilfs_compat_ioctl_get_suinfo(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
+}
+
+static int
+nilfs_compat_ioctl_get_sustat(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	struct nilfs_sustat __user *usustat;
+	struct nilfs_sustat32 __user *usustat32;
+	time_t ctime, nongc_ctime;
+	int ret;
+
+	usustat = compat_alloc_user_space(sizeof(struct nilfs_sustat));
+	ret = nilfs_compat_locked_ioctl(inode, filp, cmd,
+					(unsigned long)usustat);
+	if (ret < 0)
+		return ret;
+
+	usustat32 = compat_ptr(arg);
+	if (copy_in_user(&usustat32->ss_nsegs, &usustat->ss_nsegs,
+			 sizeof(__u64)) ||
+	    copy_in_user(&usustat32->ss_ncleansegs, &usustat->ss_ncleansegs,
+			 sizeof(__u64)) ||
+	    copy_in_user(&usustat32->ss_ndirtysegs, &usustat->ss_ndirtysegs,
+			 sizeof(__u64)) ||
+	    get_user(ctime, &usustat->ss_ctime) ||
+	    put_user(ctime, &usustat32->ss_ctime) ||
+	    get_user(nongc_ctime, &usustat->ss_nongc_ctime) ||
+	    put_user(nongc_ctime, &usustat32->ss_nongc_ctime))
+		return -EFAULT;
+	return 0;
+}
+
+static inline int
+nilfs_compat_ioctl_get_vinfo(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
+}
+
+static inline int
+nilfs_compat_ioctl_get_bdescs(struct inode *inode, struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
+}
+
+static int
+nilfs_compat_ioctl_clean_segments(struct inode *inode, struct file *filp,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct nilfs_argv __user *uargv;
+	struct nilfs_argv32 __user *uargv32;
+	int i, ret;
+
+	uargv = compat_alloc_user_space(sizeof(struct nilfs_argv) * 5);
+	uargv32 = compat_ptr(arg);
+	for (i = 0; i < 5; i++) {
+		ret = nilfs_compat_ioctl_uargv32_to_uargv(&uargv32[i],
+							  &uargv[i]);
+		if (ret < 0)
+			return ret;
+	}
+	return nilfs_compat_locked_ioctl(
+		inode, filp, cmd, (unsigned long)uargv);
+}
+
+static int
+nilfs_compat_ioctl_timedwait(struct inode *inode, struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct nilfs_wait_cond __user *uwcond;
+	struct nilfs_wait_cond32 __user *uwcond32;
+	struct timespec ts;
+	int cond, flags, ret;
+
+	uwcond = compat_alloc_user_space(sizeof(struct nilfs_wait_cond));
+	uwcond32 = compat_ptr(arg);
+	if (get_user(cond, &uwcond32->wc_cond) ||
+	    put_user(cond, &uwcond->wc_cond) ||
+	    get_user(flags, &uwcond32->wc_flags) ||
+	    put_user(flags, &uwcond->wc_flags) ||
+	    get_user(ts.tv_sec, &uwcond32->wc_timeout.tv_sec) ||
+	    get_user(ts.tv_nsec, &uwcond32->wc_timeout.tv_nsec) ||
+	    put_user(ts.tv_sec, &uwcond->wc_timeout.tv_sec) ||
+	    put_user(ts.tv_nsec, &uwcond->wc_timeout.tv_nsec))
+		return -EFAULT;
+
+	ret = nilfs_compat_locked_ioctl(inode, filp, cmd,
+					(unsigned long)uwcond);
+	if (ret < 0)
+		return ret;
+
+	if (get_user(ts.tv_sec, &uwcond->wc_timeout.tv_sec) ||
+	    get_user(ts.tv_nsec, &uwcond->wc_timeout.tv_nsec) ||
+	    put_user(ts.tv_sec, &uwcond32->wc_timeout.tv_sec) ||
+	    put_user(ts.tv_nsec, &uwcond32->wc_timeout.tv_nsec))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int nilfs_compat_ioctl_sync(struct inode *inode, struct file *filp,
+				   unsigned int cmd, unsigned long arg)
+{
+	return nilfs_compat_locked_ioctl(inode, filp, cmd, arg);
+}
+
+long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode;
+
+	/* inode = filp->f_path.dentry->d_inode; */
+	inode = filp->f_dentry->d_inode;
+
+	switch (cmd) {
+	case NILFS_IOCTL32_CHANGE_CPMODE:
+		return nilfs_compat_ioctl_change_cpmode(
+			inode, filp, NILFS_IOCTL_CHANGE_CPMODE, arg);
+	case NILFS_IOCTL_DELETE_CHECKPOINT:
+		return nilfs_compat_ioctl_delete_checkpoint(
+			inode, filp, cmd, arg);
+	case NILFS_IOCTL32_GET_CPINFO:
+		return nilfs_compat_ioctl_get_cpinfo(
+			inode, filp, NILFS_IOCTL_GET_CPINFO, arg);
+	case NILFS_IOCTL_GET_CPSTAT:
+		return nilfs_compat_ioctl_get_cpstat(inode, filp, cmd, arg);
+	case NILFS_IOCTL32_GET_SUINFO:
+		return nilfs_compat_ioctl_get_suinfo(
+			inode, filp, NILFS_IOCTL_GET_SUINFO, arg);
+	case NILFS_IOCTL32_GET_SUSTAT:
+		return nilfs_compat_ioctl_get_sustat(
+			inode, filp, NILFS_IOCTL_GET_SUSTAT, arg);
+	case NILFS_IOCTL32_GET_VINFO:
+		return nilfs_compat_ioctl_get_vinfo(
+			inode, filp, NILFS_IOCTL_GET_VINFO, arg);
+	case NILFS_IOCTL32_GET_BDESCS:
+		return nilfs_compat_ioctl_get_bdescs(
+			inode, filp, NILFS_IOCTL_GET_BDESCS, arg);
+	case NILFS_IOCTL32_CLEAN_SEGMENTS:
+		return nilfs_compat_ioctl_clean_segments(
+			inode, filp, NILFS_IOCTL_CLEAN_SEGMENTS, arg);
+	case NILFS_IOCTL32_TIMEDWAIT:
+		return nilfs_compat_ioctl_timedwait(
+			inode, filp, NILFS_IOCTL_TIMEDWAIT, arg);
+	case NILFS_IOCTL_SYNC:
+		return nilfs_compat_ioctl_sync(inode, filp, cmd, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#endif
diff -puN /dev/null fs/nilfs2/mdt.c
--- /dev/null
+++ a/fs/nilfs2/mdt.c
@@ -0,0 +1,673 @@
+/*
+ * mdt.c - meta data file for NILFS (The prefix mdt is provisional)
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/mpage.h>
+#include <linux/mm.h>
+#include <linux/writeback.h>
+#include <linux/backing-dev.h>
+#include <linux/swap.h>
+#include "nilfs.h"
+#include "page.h"
+#include "mdt.h"
+
+
+#define NILFS_MDT_MAX_RA_BLOCKS		(16 - 1)
+
+#define USE_DEFAULT_BDEV_INFO
+#define INIT_UNUSED_INODE_FIELDS
+
+
+#ifndef INIT_UNUSED_INODE_FIELDS
+static struct backing_dev_info nilfs_mdt_bdi = {
+	.ra_pages       = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE,
+	.state          = 0,
+	.capabilities   = BDI_CAP_MAP_COPY,
+	.unplug_io_fn   = default_unplug_io_fn,
+};
+#endif
+
+void nilfs_mdt_mark_buffer_dirty(struct buffer_head *bh)
+{
+	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
+		__set_page_dirty_nobuffers(bh->b_page);
+}
+
+static int
+nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
+			   struct buffer_head *bh,
+			   nilfs_mdt_init_block_t *init_block)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	void *kaddr;
+	int ret;
+
+	/* Caller exclude read accesses using page lock */
+
+	/* set_buffer_new(bh); */
+	bh->b_blocknr = 0;
+
+	ret = nilfs_bmap_insert(ii->i_bmap, block, (unsigned long)bh);
+	if (unlikely(ret))
+		return ret;
+
+	set_buffer_mapped(bh);
+
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	memset(kaddr + bh_offset(bh), 0, 1 << inode->i_blkbits);
+	if (init_block)
+		init_block(inode, bh, kaddr);
+	flush_dcache_page(bh->b_page);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	set_buffer_uptodate(bh);
+	nilfs_mdt_mark_buffer_dirty(bh);
+	nilfs_mdt_mark_dirty(inode);
+	return 0;
+}
+
+static struct buffer_head *
+nilfs_mdt_get_page_block(struct inode *inode, unsigned long blkoff)
+{
+	int blkbits = inode->i_blkbits;
+	pgoff_t index = blkoff >> (PAGE_CACHE_SHIFT - blkbits);
+	struct inode *orig_inode;
+	struct page *page, *opage;
+	struct buffer_head *bh, *obh;
+
+	page = grab_cache_page(inode->i_mapping, index);
+	if (unlikely(!page))
+		return NULL;
+
+	bh = nilfs_get_page_block(page, blkoff, index, blkbits);
+	if (unlikely(!bh)) {
+		unlock_page(page);
+		page_cache_release(page);
+		return NULL;
+	}
+	if (!buffer_uptodate(bh) &&
+	    (orig_inode = NILFS_MDT(inode)->mi_orig_inode) != NULL) {
+		/* check original cache */
+		opage = find_lock_page(orig_inode->i_mapping, index);
+		if (opage) {
+			obh = nilfs_get_page_block(opage, blkoff, index,
+						   blkbits);
+			if (buffer_uptodate(obh)) {
+				nilfs_copy_buffer(obh, bh);
+				if (buffer_dirty(obh)) {
+					/* Since all dirty buffers are copied
+					   in preparation phase, the
+					   followings would be omissible. */
+					nilfs_mdt_mark_buffer_dirty(bh);
+					nilfs_mdt_mark_dirty(inode);
+				}
+			}
+			brelse(obh);
+			unlock_page(opage);
+			page_cache_release(opage);
+		}
+	}
+	return bh;
+}
+
+static void
+nilfs_mdt_put_page_block(struct inode *inode, struct buffer_head *bh)
+{
+	unlock_page(bh->b_page);
+	page_cache_release(bh->b_page);
+	brelse(bh);
+}
+
+/**
+ * nilfs_mdt_create_block - allocate a data block of the meta data file
+ * @inode: inode of the meta data file
+ * @block: block offset
+ * @out_bh: output of a pointer to the buffer_head
+ * @init_block: initializer of newly allocated block
+ *
+ * Return Value: On success, it returns 0.  On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-EEXIST - the specified block already exists.
+ *
+ * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
+ *
+ * %-EROFS - Read only filesystem.
+ */
+int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
+			   struct buffer_head **out_bh,
+			   nilfs_mdt_init_block_t *init_block)
+{
+	struct the_nilfs *nilfs = NILFS_MDT(inode)->mi_nilfs;
+	struct nilfs_sb_info *writer = NULL;
+	struct super_block *sb = inode->i_sb;
+	struct nilfs_transaction_info ti;
+	struct buffer_head *bh;
+	int err;
+
+	if (!sb) {
+		writer = nilfs_get_writer(nilfs);
+		if (!writer) {
+			err = -EROFS;
+			goto out;
+		}
+		sb = writer->s_super;
+	}
+
+	nilfs_transaction_begin(sb, &ti, 0);
+
+	err = -ENOMEM;
+	bh = nilfs_mdt_get_page_block(inode, block);
+	if (unlikely(!bh))
+		goto failed_unlock;
+
+	err = -EEXIST;
+	if (buffer_uptodate(bh) || buffer_mapped(bh))
+		goto failed_bh;
+#if 0
+	/* The uptodate flag is not protected by the page lock, but
+	   the mapped flag is.  Thus, we don't have to wait the buffer. */
+	wait_on_buffer(bh);
+	if (buffer_uptodate(bh))
+		goto failed_bh;
+#endif
+
+	bh->b_bdev = nilfs->ns_bdev;
+	err = nilfs_mdt_insert_new_block(inode, block, bh, init_block);
+	if (likely(!err)) {
+		get_bh(bh);
+		*out_bh = bh;
+	}
+
+ failed_bh:
+	nilfs_mdt_put_page_block(inode, bh);
+
+ failed_unlock:
+	nilfs_transaction_end(sb, !err);
+	if (writer)
+		nilfs_put_writer(nilfs);
+ out:
+	return err;
+}
+
+static int
+nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
+		       int mode, struct buffer_head **out_bh)
+{
+	struct buffer_head *bh;
+	unsigned long blknum = 0;
+	int ret = -ENOMEM;
+
+	bh = nilfs_mdt_get_page_block(inode, blkoff);
+	if (unlikely(!bh))
+		goto failed;
+
+	ret = -EEXIST; /* internal code */
+	if (buffer_uptodate(bh))
+		goto out;
+
+	if (mode == READA) {
+		if (!trylock_buffer(bh)) {
+			ret = -EBUSY;
+			goto failed_bh;
+		}
+	} else {
+		BUG_ON(mode != READ);
+		lock_buffer(bh);
+	}
+
+	if (buffer_uptodate(bh)) {
+		unlock_buffer(bh);
+		goto out;
+	}
+	if (!buffer_mapped(bh)) { /* unused buffer */
+		ret = nilfs_bmap_lookup(NILFS_I(inode)->i_bmap, blkoff,
+					&blknum);
+		if (unlikely(ret)) {
+			unlock_buffer(bh);
+			goto failed_bh;
+		}
+		bh->b_bdev = NILFS_MDT(inode)->mi_nilfs->ns_bdev;
+		bh->b_blocknr = blknum;
+		set_buffer_mapped(bh);
+	}
+
+	bh->b_end_io = end_buffer_read_sync;
+	get_bh(bh);
+	submit_bh(mode, bh);
+	ret = 0;
+ out:
+	get_bh(bh);
+	*out_bh = bh;
+
+ failed_bh:
+	nilfs_mdt_put_page_block(inode, bh);
+ failed:
+	return ret;
+}
+
+
+/**
+ * nilfs_mdt_read_block - read a block on the meta data file.
+ * @inode: inode of the meta data file
+ * @block: block offset
+ * @out_bh: output of a pointer to the buffer_head
+ *
+ * nilfs_mdt_read_block() looks up the specified buffer.
+ * When the block is not mapped on disk, it returns ERR_PTR(-ENOENT).
+ * Since the buffer is taken exclusively by a page and buffer lock, it is
+ * assured to be either existing or formatted through nilfs_mdt_create_block().
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - the specified block does not exist (hole block)
+ *
+ * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
+ */
+int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
+			 struct buffer_head **out_bh)
+{
+	struct buffer_head *first_bh, *bh;
+	unsigned long blkoff;
+	int i, nr_ra_blocks = NILFS_MDT_MAX_RA_BLOCKS;
+	int err;
+
+	err = nilfs_mdt_submit_block(inode, block, READ, &first_bh);
+	if (err == -EEXIST) /* internal code */
+		goto out;
+
+	if (unlikely(err))
+		goto failed;
+
+	blkoff = block + 1;
+	for (i = 0; i < nr_ra_blocks; i++, blkoff++) {
+		err = nilfs_mdt_submit_block(inode, blkoff, READA, &bh);
+		if (likely(!err || err == -EEXIST))
+			brelse(bh);
+		else if (err != -EBUSY)
+			break; /* abort readahead if bmap lookup failed */
+
+		if (!buffer_locked(first_bh))
+			goto out_no_wait;
+	}
+
+	wait_on_buffer(first_bh);
+
+ out_no_wait:
+	err = -EIO;
+	if (!buffer_uptodate(first_bh))
+		goto failed_bh;
+ out:
+	*out_bh = first_bh;
+	return 0;
+
+ failed_bh:
+	brelse(first_bh);
+ failed:
+	return err;
+}
+
+/**
+ * nilfs_mdt_get_block - read or create a block on the meta data file.
+ * @inode: inode of the meta data file
+ * @block: block offset
+ * @create: create flag
+ * @init_block: initializer used for newly allocated block
+ * @out_bh: output of a pointer to the buffer_head
+ *
+ * The returned buffer is assured to be either existing or formatted using
+ * a buffer lock on success. out_bh is substituted only when zero is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - the specified block does not exist
+ *
+ * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
+ */
+int nilfs_mdt_get_block(struct inode *inode, unsigned long block, int create,
+			nilfs_mdt_init_block_t *init_block,
+			struct buffer_head **out_bh)
+{
+	int ret;
+
+	/* Should be rewritten with merging nilfs_mdt_read_block() */
+ retry:
+	ret = nilfs_mdt_read_block(inode, block, out_bh);
+	if (!create || ret != -ENOENT)
+		return ret;
+
+	ret = nilfs_mdt_create_block(inode, block, out_bh, init_block);
+	if (unlikely(ret == -EEXIST)) {
+		/* create = 0; */  /* limit read-create loop retries */
+		goto retry;
+	}
+	return ret;
+}
+
+/**
+ * nilfs_mdt_delete_block - make a hole on the meta data file.
+ * @inode: inode of the meta data file
+ * @block: block offset
+ *
+ * Return Value: On success, zero is returned.
+ * On error, one of the following negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
+ */
+int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	int err;
+
+	err = nilfs_bmap_delete(ii->i_bmap, block);
+	if (likely(!err)) {
+		nilfs_mdt_mark_dirty(inode);
+		nilfs_mdt_forget_block(inode, block);
+	}
+	return err;
+}
+
+/**
+ * nilfs_mdt_forget_block - discard dirty state and try to remove the page
+ * @inode: inode of the meta data file
+ * @block: block offset
+ *
+ * nilfs_mdt_forget_block() clears a dirty flag of the specified buffer, and
+ * tries to release the page including the buffer from a page cache.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error code is returned.
+ *
+ * %-EBUSY - page has an active buffer.
+ *
+ * %-ENOENT - page cache has no page addressed by the offset.
+ */
+int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
+{
+	pgoff_t index = (pgoff_t)block >>
+		(PAGE_CACHE_SHIFT - inode->i_blkbits);
+	struct page *page;
+	unsigned long first_block;
+	int ret = 0;
+	int still_dirty;
+
+	page = find_lock_page(inode->i_mapping, index);
+	if (!page)
+		return -ENOENT;
+
+	wait_on_page_writeback(page);
+
+	first_block = (unsigned long)index <<
+		(PAGE_CACHE_SHIFT - inode->i_blkbits);
+	if (page_has_buffers(page)) {
+		struct buffer_head *bh;
+
+		bh = nilfs_page_get_nth_block(page, block - first_block);
+		lock_buffer(bh);
+		if (test_clear_buffer_dirty(bh) &&
+		    nilfs_page_buffers_clean(page)) {
+			cancel_dirty_page(page, PAGE_CACHE_SIZE);
+		}
+		clear_buffer_uptodate(bh);
+		clear_buffer_mapped(bh);
+		ClearPageUptodate(page);
+		unlock_buffer(bh);
+		brelse(bh);
+	}
+	still_dirty = PageDirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+
+	if (still_dirty ||
+	    invalidate_inode_pages2_range(inode->i_mapping, index, index) != 0)
+		ret = -EBUSY;
+	return ret;
+}
+
+/**
+ * nilfs_mdt_mark_block_dirty - mark a block on the meta data file dirty.
+ * @inode: inode of the meta data file
+ * @block: block offset
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - the specified block does not exist (hole block)
+ *
+ * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
+ */
+int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
+{
+	struct buffer_head *bh;
+	int err;
+
+	err = nilfs_mdt_read_block(inode, block, &bh);
+	if (unlikely(err))
+		return err;
+	nilfs_mdt_mark_buffer_dirty(bh);
+	nilfs_mdt_mark_dirty(inode);
+	brelse(bh);
+	return 0;
+}
+
+int nilfs_mdt_fetch_dirty(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+
+	if (nilfs_bmap_test_and_clear_dirty(ii->i_bmap)) {
+		set_bit(NILFS_I_DIRTY, &ii->i_state);
+		return 1;
+	}
+	return test_bit(NILFS_I_DIRTY, &ii->i_state);
+}
+
+static int
+nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = container_of(page->mapping,
+					   struct inode, i_data);
+	struct super_block *sb = inode->i_sb;
+	struct nilfs_sb_info *writer = NULL;
+	int err = 0;
+
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+
+	if (NILFS_MDT(inode)->mi_orig_inode)
+		return 0; /* Do not request flush for shadow inode */
+	if (!sb) {
+		writer = nilfs_get_writer(NILFS_MDT(inode)->mi_nilfs);
+		if (!writer)
+			return -EROFS;
+		sb = writer->s_super;
+	}
+
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		err = nilfs_construct_segment(sb);
+	else if (wbc->for_reclaim)
+		nilfs_flush_segment(sb, inode->i_ino);
+
+	if (writer)
+		nilfs_put_writer(NILFS_MDT(inode)->mi_nilfs);
+	return err;
+}
+
+
+static struct address_space_operations def_mdt_aops = {
+	.writepage		= nilfs_mdt_write_page,
+};
+
+static struct inode_operations def_mdt_iops;
+static struct file_operations def_mdt_fops;
+
+
+struct inode *
+nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
+		     ino_t ino, gfp_t gfp_mask)
+{
+	struct inode *inode = nilfs_alloc_inode(sb);
+
+	if (!inode)
+		return NULL;
+	else {
+		struct address_space * const mapping = &inode->i_data;
+		struct nilfs_mdt_info *mi = kzalloc(sizeof(*mi), GFP_NOFS);
+
+		if (!mi) {
+			nilfs_destroy_inode(inode);
+			return NULL;
+		}
+		mi->mi_nilfs = nilfs;
+		init_rwsem(&mi->mi_sem);
+
+		inode->i_sb = sb; /* sb may be NULL for some meta data files */
+		inode->i_blkbits = nilfs->ns_blocksize_bits;
+		inode->i_flags = 0;
+		atomic_set(&inode->i_count, 1);
+		inode->i_nlink = 1;
+		inode->i_ino = ino;
+		inode->i_mode = S_IFREG;
+		inode->i_private = mi;
+
+#ifdef INIT_UNUSED_INODE_FIELDS
+		atomic_set(&inode->i_writecount, 0);
+		inode->i_size = 0;
+		inode->i_blocks = 0;
+		inode->i_bytes = 0;
+		inode->i_generation = 0;
+#ifdef CONFIG_QUOTA
+		memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
+#endif
+		inode->i_pipe = NULL;
+		inode->i_bdev = NULL;
+		inode->i_cdev = NULL;
+		inode->i_rdev = 0;
+#ifdef CONFIG_SECURITY
+		inode->i_security = NULL;
+#endif
+		inode->dirtied_when = 0;
+
+		INIT_LIST_HEAD(&inode->i_list);
+		INIT_LIST_HEAD(&inode->i_sb_list);
+		inode->i_state = 0;
+#endif
+
+		spin_lock_init(&inode->i_lock);
+		mutex_init(&inode->i_mutex);
+		init_rwsem(&inode->i_alloc_sem);
+
+		mapping->host = NULL;  /* instead of inode */
+		mapping->flags = 0;
+		mapping_set_gfp_mask(mapping, gfp_mask);
+		mapping->assoc_mapping = NULL;
+#ifdef USE_DEFAULT_BDEV_INFO
+		mapping->backing_dev_info = nilfs->ns_bdi;
+#else
+		mapping->backing_dev_info = &nilfs_mdt_bdi;
+#endif
+
+		inode->i_mapping = mapping;
+	}
+
+	return inode;
+}
+
+struct inode *nilfs_mdt_new(struct the_nilfs *nilfs, struct super_block *sb,
+			    ino_t ino, gfp_t gfp_mask)
+{
+	struct inode *inode = nilfs_mdt_new_common(nilfs, sb, ino, gfp_mask);
+
+	if (!inode)
+		return NULL;
+
+	inode->i_op = &def_mdt_iops;
+	inode->i_fop = &def_mdt_fops;
+	inode->i_mapping->a_ops = &def_mdt_aops;
+	return inode;
+}
+
+
+struct inode *
+nilfs_mdt_new_with_blockgroup(struct the_nilfs *nilfs, struct super_block *sb,
+			      ino_t ino, gfp_t gfp_mask, unsigned entry_size,
+			      unsigned long groups_count)
+{
+	struct inode *inode = nilfs_mdt_new(nilfs, sb, ino, gfp_mask);
+
+	if (inode) {
+		struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+		unsigned long blocksize = 1 << inode->i_blkbits;
+		unsigned long entries_per_group = blocksize * 8 /* CHAR_BIT */;
+
+		mi->mi_bgl = kmalloc(sizeof(*mi->mi_bgl), GFP_NOFS);
+		if (!mi->mi_bgl) {
+			nilfs_mdt_destroy(inode);
+			return NULL;
+		}
+		bgl_lock_init(mi->mi_bgl);
+		mi->mi_entry_size = entry_size;
+		mi->mi_entries_per_block = blocksize / entry_size;
+		mi->mi_blocks_per_group =
+			entries_per_group / mi->mi_entries_per_block + 1;
+		mi->mi_groups_count = groups_count;
+	}
+	return inode;
+}
+
+void nilfs_mdt_clear(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+
+	invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	truncate_inode_pages(inode->i_mapping, 0);
+
+	nilfs_bmap_clear(ii->i_bmap);
+	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+}
+
+void nilfs_mdt_destroy(struct inode *inode)
+{
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
+	kfree(mdi);
+	nilfs_destroy_inode(inode);
+}
diff -puN /dev/null fs/nilfs2/mdt.h
--- /dev/null
+++ a/fs/nilfs2/mdt.h
@@ -0,0 +1,147 @@
+/*
+ * mdt.h - NILFS meta data file (provisional) prototype and definitions
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#ifndef _NILFS_MDT_H
+#define _NILFS_MDT_H
+
+#include <linux/buffer_head.h>
+#include <linux/blockgroup_lock.h>
+#include "nilfs.h"
+
+/**
+ * struct nilfs_mdt_info - on-memory private data of an meta data file
+ * @mi_nilfs: back pointer to the_nilfs struct
+ * @mi_sem: reader/writer semaphore for contents
+ * @mi_bgl: per-blockgroup locking
+ * @mi_orig_inode: original inode (only valid for shadow)
+ * @mi_entry_size: size of an entry
+ * @mi_entries_per_block: number of entries in a block
+ * @mi_blocks_per_group: number of blocks in a group
+ * @mi_groups_count: number of groups
+ */
+struct nilfs_mdt_info {
+	struct the_nilfs       *mi_nilfs;
+	struct rw_semaphore	mi_sem;
+	struct blockgroup_lock *mi_bgl;
+	struct inode	       *mi_orig_inode;
+	unsigned		mi_entry_size;
+	unsigned long		mi_entries_per_block;
+	unsigned long		mi_blocks_per_group;
+	unsigned long		mi_groups_count;
+};
+
+static inline struct nilfs_mdt_info *NILFS_MDT(struct inode *inode)
+{
+	return inode->i_private;
+}
+
+static inline struct the_nilfs *NILFS_I_NILFS(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	return sb ? NILFS_SB(sb)->s_nilfs : NILFS_MDT(inode)->mi_nilfs;
+}
+
+static inline struct inode *NILFS_ORIG_I(struct inode *inode)
+{
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	return (mdi && mdi->mi_orig_inode) ? mdi->mi_orig_inode : NULL;
+}
+
+typedef void (nilfs_mdt_init_block_t)(struct inode *, struct buffer_head *,
+				      void *);
+
+
+/* Default GFP flags using highmem */
+#define NILFS_MDT_GFP      (__GFP_WAIT | __GFP_IO | __GFP_HIGHMEM)
+
+int nilfs_mdt_create_block(struct inode *, unsigned long,
+			   struct buffer_head **, nilfs_mdt_init_block_t *);
+int nilfs_mdt_read_block(struct inode *, unsigned long, struct buffer_head **);
+int nilfs_mdt_get_block(struct inode *, unsigned long, int,
+			nilfs_mdt_init_block_t *, struct buffer_head **);
+int nilfs_mdt_delete_block(struct inode *, unsigned long);
+int nilfs_mdt_forget_block(struct inode *, unsigned long);
+int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
+int nilfs_mdt_fetch_dirty(struct inode *);
+
+struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
+			    gfp_t);
+struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
+				   ino_t, gfp_t);
+void nilfs_mdt_destroy(struct inode *);
+void nilfs_mdt_clear(struct inode *);
+struct inode *nilfs_mdt_new_with_blockgroup(struct the_nilfs *,
+					    struct super_block *, ino_t, gfp_t,
+					    unsigned, unsigned long);
+
+void nilfs_mdt_mark_buffer_dirty(struct buffer_head *bh);
+
+static inline void nilfs_mdt_mark_dirty(struct inode *inode)
+{
+	set_bit(NILFS_I_DIRTY, &NILFS_I(inode)->i_state);
+}
+
+static inline void nilfs_mdt_clear_dirty(struct inode *inode)
+{
+	clear_bit(NILFS_I_DIRTY, &NILFS_I(inode)->i_state);
+}
+
+static inline void
+nilfs_mdt_set_shadow(struct inode *orig, struct inode *shadow)
+{
+	NILFS_MDT(shadow)->mi_orig_inode = orig;
+}
+
+static inline void
+nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size)
+{
+	NILFS_MDT(inode)->mi_entry_size = entry_size;
+}
+
+static inline __u64 nilfs_mdt_cno(struct inode *inode)
+{
+	return NILFS_MDT(inode)->mi_nilfs->ns_cno;
+}
+
+#define nilfs_mdt_bgl_lock(inode, bg) \
+	(&NILFS_MDT(inode)->mi_bgl->locks[(bg) & (NR_BG_LOCKS-1)].lock)
+
+
+static inline int
+nilfs_mdt_read_inode_direct(struct inode *inode, struct buffer_head *bh,
+			    unsigned n)
+{
+	return nilfs_read_inode_common(
+		inode, (struct nilfs_inode *)(bh->b_data + n));
+}
+
+static inline void
+nilfs_mdt_write_inode_direct(struct inode *inode, struct buffer_head *bh,
+			     unsigned n)
+{
+	nilfs_write_inode_common(
+		inode, (struct nilfs_inode *)(bh->b_data + n), 1);
+}
+
+#endif /* _NILFS_MDT_H */
diff -puN /dev/null fs/nilfs2/namei.c
--- /dev/null
+++ a/fs/nilfs2/namei.c
@@ -0,0 +1,452 @@
+/*
+ * namei.c - NILFS pathname lookup operations.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>,
+ *                       Ryusuke Konishi <ryusuke@osrg.net>
+ */
+/*
+ *  linux/fs/ext2/namei.c
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/fs/minix/namei.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  Big-endian to little-endian byte-swapping/bitmaps by
+ *        David S. Miller (davem@caip.rutgers.edu), 1995
+ */
+
+#include <linux/pagemap.h>
+#include "nilfs.h"
+
+
+static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
+{
+	int err = nilfs_add_link(dentry, inode);
+	if (!err) {
+		d_instantiate(dentry, inode);
+		return 0;
+	}
+	inode_dec_link_count(inode);
+	iput(inode);
+	return err;
+}
+
+/*
+ * Methods themselves.
+ */
+
+static struct dentry *
+nilfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode;
+	ino_t ino;
+
+	if (dentry->d_name.len > NILFS_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	ino = nilfs_inode_by_name(dir, dentry);
+	inode = NULL;
+	if (ino) {
+		inode = nilfs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+	}
+	return d_splice_alias(inode, dentry);
+}
+
+struct dentry *nilfs_get_parent(struct dentry *child)
+{
+	unsigned long ino;
+	struct dentry *parent;
+	struct inode *inode;
+	struct dentry dotdot;
+
+	dotdot.d_name.name = "..";
+	dotdot.d_name.len = 2;
+
+	ino = nilfs_inode_by_name(child->d_inode, &dotdot);
+	if (!ino)
+		return ERR_PTR(-ENOENT);
+
+	inode = nilfs_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	parent = d_alloc_anon(inode);
+	if (!parent) {
+		iput(inode);
+		parent = ERR_PTR(-ENOMEM);
+	}
+	return parent;
+}
+
+/*
+ * By the time this is called, we already have created
+ * the directory cache entry for the new file, but it
+ * is so far negative - it has no inode.
+ *
+ * If the create succeeds, we fill in the inode information
+ * with d_instantiate().
+ */
+static int nilfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			struct nameidata *nd)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+	inode = nilfs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		inode->i_op = &nilfs_file_inode_operations;
+		inode->i_fop = &nilfs_file_operations;
+		inode->i_mapping->a_ops = &nilfs_aops;
+		mark_inode_dirty(inode);
+		err = nilfs_add_nondir(dentry, inode);
+	}
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int
+nilfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+	inode = nilfs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		init_special_inode(inode, inode->i_mode, rdev);
+		mark_inode_dirty(inode);
+		err = nilfs_add_nondir(dentry, inode);
+	}
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *symname)
+{
+	struct nilfs_transaction_info ti;
+	struct super_block *sb = dir->i_sb;
+	unsigned l = strlen(symname)+1;
+	struct inode *inode;
+	int err, err2;
+
+	if (l > sb->s_blocksize)
+		return -ENAMETOOLONG;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode = nilfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	/* slow symlink */
+	inode->i_op = &nilfs_symlink_inode_operations;
+	inode->i_mapping->a_ops = &nilfs_aops;
+	err = page_symlink(inode, symname, l);
+	if (err)
+		goto out_fail;
+
+	/* mark_inode_dirty(inode); */
+	/* nilfs_new_inode() and page_symlink() do this */
+
+	err = nilfs_add_nondir(dentry, inode);
+out:
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+
+out_fail:
+	inode_dec_link_count(inode);
+	iput(inode);
+	goto out;
+}
+
+static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
+		      struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	if (inode->i_nlink >= NILFS_LINK_MAX)
+		return -EMLINK;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode->i_ctime = CURRENT_TIME;
+	inode_inc_link_count(inode);
+	atomic_inc(&inode->i_count);
+
+	err = nilfs_add_nondir(dentry, inode);
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	if (dir->i_nlink >= NILFS_LINK_MAX)
+		return -EMLINK;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode_inc_link_count(dir);
+
+	inode = nilfs_new_inode(dir, S_IFDIR | mode);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out_dir;
+
+	inode->i_op = &nilfs_dir_inode_operations;
+	inode->i_fop = &nilfs_dir_operations;
+	inode->i_mapping->a_ops = &nilfs_aops;
+
+	inode_inc_link_count(inode);
+
+	err = nilfs_make_empty(inode, dir);
+	if (err)
+		goto out_fail;
+
+	err = nilfs_add_link(dentry, inode);
+	if (err)
+		goto out_fail;
+
+	d_instantiate(dentry, inode);
+out:
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+
+out_fail:
+	inode_dec_link_count(inode);
+	inode_dec_link_count(inode);
+	iput(inode);
+out_dir:
+	inode_dec_link_count(dir);
+	goto out;
+}
+
+static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode;
+	struct nilfs_dir_entry *de;
+	struct page *page;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
+	if (err)
+		return err;
+
+	err = -ENOENT;
+	de = nilfs_find_entry(dir, dentry, &page);
+	if (!de)
+		goto out;
+
+	inode = dentry->d_inode;
+	err = -EIO;
+	if (le64_to_cpu(de->inode) != inode->i_ino)
+		goto out;
+
+	if (!inode->i_nlink) {
+		nilfs_warning(inode->i_sb, __func__,
+			      "deleting nonexistent file (%lu), %d\n",
+			      inode->i_ino, inode->i_nlink);
+		inode->i_nlink = 1;
+	}
+	err = nilfs_delete_entry(de, page);
+	if (err)
+		goto out;
+
+	inode->i_ctime = dir->i_ctime;
+	inode_dec_link_count(inode);
+	err = 0;
+out:
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
+	if (err)
+		return err;
+
+	err = -ENOTEMPTY;
+	if (nilfs_empty_dir(inode)) {
+		err = nilfs_unlink(dir, dentry);
+		if (!err) {
+			inode->i_size = 0;
+			inode_dec_link_count(inode);
+			inode_dec_link_count(dir);
+		}
+	}
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir,	struct dentry *new_dentry)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *dir_page = NULL;
+	struct nilfs_dir_entry *dir_de = NULL;
+	struct page *old_page;
+	struct nilfs_dir_entry *old_de;
+	struct nilfs_transaction_info ti;
+	int err;
+
+	err = nilfs_transaction_begin(old_dir->i_sb, &ti, 1);
+	if (unlikely(err))
+		return err;
+
+	err = -ENOENT;
+	old_de = nilfs_find_entry(old_dir, old_dentry, &old_page);
+	if (!old_de)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		err = -EIO;
+		dir_de = nilfs_dotdot(old_inode, &dir_page);
+		if (!dir_de)
+			goto out_old;
+	}
+
+	if (new_inode) {
+		struct page *new_page;
+		struct nilfs_dir_entry *new_de;
+
+		err = -ENOTEMPTY;
+		if (dir_de && !nilfs_empty_dir(new_inode))
+			goto out_dir;
+
+		err = -ENOENT;
+		new_de = nilfs_find_entry(new_dir, new_dentry, &new_page);
+		if (!new_de)
+			goto out_dir;
+		inode_inc_link_count(old_inode);
+		nilfs_set_link(new_dir, new_de, new_page, old_inode);
+		new_inode->i_ctime = CURRENT_TIME;
+		if (dir_de)
+			drop_nlink(new_inode);
+		inode_dec_link_count(new_inode);
+	} else {
+		if (dir_de) {
+			err = -EMLINK;
+			if (new_dir->i_nlink >= NILFS_LINK_MAX)
+				goto out_dir;
+		}
+		inode_inc_link_count(old_inode);
+		err = nilfs_add_link(new_dentry, old_inode);
+		if (err) {
+			inode_dec_link_count(old_inode);
+			goto out_dir;
+		}
+		if (dir_de)
+			inode_inc_link_count(new_dir);
+	}
+
+	/*
+	 * Like most other Unix systems, set the ctime for inodes on a
+	 * rename.
+	 * inode_dec_link_count() will mark the inode dirty.
+	 */
+	old_inode->i_ctime = CURRENT_TIME;
+
+	nilfs_delete_entry(old_de, old_page);
+	inode_dec_link_count(old_inode);
+
+	if (dir_de) {
+		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
+		inode_dec_link_count(old_dir);
+	}
+
+	err = nilfs_transaction_end(old_dir->i_sb, 1);
+	return err;
+
+out_dir:
+	if (dir_de) {
+		kunmap(dir_page);
+		page_cache_release(dir_page);
+	}
+out_old:
+	kunmap(old_page);
+	page_cache_release(old_page);
+out:
+	nilfs_transaction_end(old_dir->i_sb, 0);
+	return err;
+}
+
+struct inode_operations nilfs_dir_inode_operations = {
+	.create		= nilfs_create,
+	.lookup		= nilfs_lookup,
+	.link		= nilfs_link,
+	.unlink		= nilfs_unlink,
+	.symlink	= nilfs_symlink,
+	.mkdir		= nilfs_mkdir,
+	.rmdir		= nilfs_rmdir,
+	.mknod		= nilfs_mknod,
+	.rename		= nilfs_rename,
+	.setattr	= nilfs_setattr,
+	.permission	= nilfs_permission,
+};
+
+struct inode_operations nilfs_special_inode_operations = {
+	.setattr	= nilfs_setattr,
+	.permission	= nilfs_permission,
+};
+
+struct inode_operations nilfs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+};
diff -puN /dev/null fs/nilfs2/nilfs.h
--- /dev/null
+++ a/fs/nilfs2/nilfs.h
@@ -0,0 +1,295 @@
+/*
+ * nilfs.h - NILFS local header file.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#ifndef _NILFS_H
+#define _NILFS_H
+
+#include <linux/kernel.h>
+#include <linux/buffer_head.h>
+#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/crc32.h>
+#include <linux/nilfs2_fs.h>
+#include "the_nilfs.h"
+#include "sb.h"
+#include "btnode.h"
+#include "bmap.h"
+#include "bmap_union.h"
+#include "segment.h"
+
+/*
+ * NILFS filesystem version
+ */
+#define NILFS_VERSION		"2.0.4"
+
+/*
+ * nilfs inode data in memory
+ */
+struct nilfs_inode_info {
+	__u32 i_flags;
+	unsigned long  i_state;		/* Dynamic state flags */
+	struct nilfs_bmap *i_bmap;
+	union nilfs_bmap_union i_bmap_union;
+	__u64 i_xattr;	/* sector_t ??? */
+	__u32 i_dtime;
+	__u32 i_dir_start_lookup;
+	__u64 i_cno;		/* check point number for GC inode */
+	struct nilfs_btnode_cache i_btnode_cache;
+	struct list_head i_dirty;	/* List for connecting dirty files */
+
+#ifdef CONFIG_NILFS_XATTR
+	/*
+	 * Extended attributes can be read independently of the main file
+	 * data. Taking i_sem even when reading would cause contention
+	 * between readers of EAs and writers of regular file data, so
+	 * instead we synchronize on xattr_sem when reading or changing
+	 * EAs.
+	 */
+	struct rw_semaphore xattr_sem;
+#endif
+#ifdef CONFIG_NILFS_POSIX_ACL
+	struct posix_acl *i_acl;
+	struct posix_acl *i_default_acl;
+#endif
+	struct buffer_head *i_bh;	/* i_bh contains a new or dirty
+					   disk inode */
+	struct inode vfs_inode;
+};
+
+static inline struct nilfs_inode_info *NILFS_I(const struct inode *inode)
+{
+	return container_of(inode, struct nilfs_inode_info, vfs_inode);
+}
+
+static inline struct nilfs_inode_info *
+NILFS_BMAP_I(const struct nilfs_bmap *bmap)
+{
+	return container_of((union nilfs_bmap_union *)bmap,
+			    struct nilfs_inode_info,
+			    i_bmap_union);
+}
+
+static inline struct inode *NILFS_AS_I(struct address_space *mapping)
+{
+	return (mapping->host) ? :
+		container_of(mapping, struct inode, i_data);
+}
+
+/*
+ * Dynamic state flags of NILFS on-memory inode (i_state)
+ */
+enum {
+	NILFS_I_NEW = 0,		/* Inode is newly created */
+	NILFS_I_DIRTY,			/* The file is dirty */
+	NILFS_I_QUEUED,			/* inode is in dirty_files list */
+	NILFS_I_BUSY,			/* inode is grabbed by a segment
+					   constructor */
+	NILFS_I_COLLECTED,		/* All dirty blocks are collected */
+	NILFS_I_UPDATED,		/* The file has been written back */
+	NILFS_I_INODE_DIRTY,		/* write_inode is requested */
+	NILFS_I_BMAP,			/* has bmap and btnode_cache */
+	NILFS_I_GCINODE,		/* inode for GC, on memory only */
+	NILFS_I_GCDAT,			/* shadow DAT, on memory only */
+};
+
+/*
+ * Macros to check inode numbers
+ */
+#define NILFS_MDT_INO_BITS   \
+  ((unsigned int)(1 << NILFS_DAT_INO | 1 << NILFS_CPFILE_INO |		\
+		  1 << NILFS_SUFILE_INO | 1 << NILFS_IFILE_INO |	\
+		  1 << NILFS_ATIME_INO | 1 << NILFS_SKETCH_INO))
+
+#define NILFS_SYS_INO_BITS   \
+  ((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
+
+#define NILFS_MDT_INODE(sb, ino) \
+  ((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
+#define NILFS_VALID_INODE(sb, ino) \
+  ((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & (1 << (ino))))
+
+/*
+ * Extended buffer state bits
+ */
+enum {
+	BH_NILFS_Allocated = BH_PrivateStart,
+	BH_NILFS_Node,
+	BH_NILFS_Volatile,
+};
+
+BUFFER_FNS(NILFS_Allocated, nilfs_allocated)	/* nilfs private buffers */
+BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
+BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
+
+#define NILFS_BUFFER_INHERENT_BITS  \
+	((1UL << BH_Uptodate) | (1UL << BH_Mapped) | (1UL << BH_NILFS_Node) | \
+	 (1UL << BH_NILFS_Volatile) | (1UL << BH_NILFS_Allocated))
+
+/*
+ * function prototype
+ */
+#ifdef CONFIG_NILFS_POSIX_ACL
+#error "NILFS: not yet supported POSIX ACL"
+extern int nilfs_permission(struct inode *, int, struct nameidata *);
+extern int nilfs_acl_chmod(struct inode *);
+extern int nilfs_init_acl(struct inode *, struct inode *);
+#else
+#define nilfs_permission   NULL
+
+static inline int nilfs_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
+{
+	inode->i_mode &= ~current->fs->umask;
+	return 0;
+}
+#endif
+
+#define NILFS_ATIME_DISABLE
+
+/* dir.c */
+extern int nilfs_add_link(struct dentry *, struct inode *);
+extern ino_t nilfs_inode_by_name(struct inode *, struct dentry *);
+extern int nilfs_make_empty(struct inode *, struct inode *);
+extern struct nilfs_dir_entry *
+nilfs_find_entry(struct inode *, struct dentry *, struct page **);
+extern int nilfs_delete_entry(struct nilfs_dir_entry *, struct page *);
+extern int nilfs_empty_dir(struct inode *);
+extern struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct page **);
+extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
+			   struct page *, struct inode *);
+
+/* file.c */
+extern int nilfs_sync_file(struct file *, struct dentry *, int);
+
+/* ioctl.c */
+int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long nilfs_compat_ioctl(struct file *, unsigned int, unsigned long);
+int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, unsigned long);
+
+/* inode.c */
+extern struct inode *nilfs_new_inode(struct inode *, int);
+extern void nilfs_free_inode(struct inode *);
+extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
+extern void nilfs_set_inode_flags(struct inode *);
+extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
+extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
+extern struct inode *nilfs_iget(struct super_block *, unsigned long);
+extern void nilfs_update_inode(struct inode *, struct buffer_head *);
+extern void nilfs_truncate(struct inode *);
+extern void nilfs_delete_inode(struct inode *);
+extern int nilfs_setattr(struct dentry *, struct iattr *);
+extern int nilfs_load_inode_block(struct nilfs_sb_info *, struct inode *,
+				  struct buffer_head **);
+extern int nilfs_inode_dirty(struct inode *);
+extern int nilfs_set_file_dirty(struct nilfs_sb_info *, struct inode *,
+				unsigned);
+extern int nilfs_mark_inode_dirty(struct inode *);
+extern void nilfs_dirty_inode(struct inode *);
+
+/* namei.c */
+extern struct dentry *nilfs_get_parent(struct dentry *);
+
+/* super.c */
+extern struct inode *nilfs_alloc_inode(struct super_block *);
+extern void nilfs_destroy_inode(struct inode *);
+extern void nilfs_error(struct super_block *, const char *, const char *, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern void nilfs_warning(struct super_block *, const char *, const char *, ...)
+       __attribute__ ((format (printf, 3, 4)));
+extern struct nilfs_super_block *
+nilfs_load_super_block(struct super_block *, struct buffer_head **);
+extern struct nilfs_super_block *
+nilfs_reload_super_block(struct super_block *, struct buffer_head **, int);
+extern int nilfs_store_magic_and_option(struct super_block *,
+					struct nilfs_super_block *, char *);
+extern void nilfs_update_last_segment(struct nilfs_sb_info *, int);
+extern int nilfs_commit_super(struct nilfs_sb_info *);
+extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
+extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
+
+/* gcinode.c */
+int nilfs_gccache_add_data(struct inode *, sector_t, sector_t, __u64);
+int nilfs_gccache_add_node(struct inode *, sector_t, __u64);
+int nilfs_init_gcinode(struct the_nilfs *);
+void nilfs_destroy_gcinode(struct the_nilfs *);
+void nilfs_clear_gcinode(struct inode *);
+struct inode *nilfs_gc_iget(struct the_nilfs *, ino_t, __u64);
+void nilfs_remove_all_gcinode(struct the_nilfs *);
+
+/* gcdat.c */
+int nilfs_init_gcdat_inode(struct the_nilfs *);
+void nilfs_commit_gcdat_inode(struct the_nilfs *);
+void nilfs_clear_gcdat_inode(struct the_nilfs *);
+
+/* super.c */
+static inline int nilfs_doing_gc(void)
+{
+	return nilfs_test_transaction_flag(NILFS_TI_GC);
+}
+
+static inline int nilfs_doing_construction(void)
+{
+	return nilfs_test_transaction_flag(NILFS_TI_WRITER);
+}
+
+static inline struct inode *nilfs_dat_inode(const struct the_nilfs *nilfs)
+{
+	return nilfs_doing_gc() ? nilfs->ns_gc_dat : nilfs->ns_dat;
+}
+
+/*
+ * Inodes and files operations
+ */
+
+/* dir.c */
+extern struct file_operations nilfs_dir_operations;
+
+/* file.c */
+extern struct inode_operations nilfs_file_inode_operations;
+extern struct file_operations nilfs_file_operations;
+
+/* inode.c */
+extern struct address_space_operations nilfs_aops;
+
+/* namei.c */
+extern struct inode_operations nilfs_dir_inode_operations;
+extern struct inode_operations nilfs_special_inode_operations;
+extern struct inode_operations nilfs_symlink_inode_operations;
+
+/*
+ * proc entry
+ */
+extern struct proc_dir_entry *nilfs_proc_root;
+
+
+/*
+ * filesystem type
+ */
+extern struct file_system_type nilfs_fs_type;
+
+
+#endif	/* _NILFS_H */
diff -puN /dev/null fs/nilfs2/page.c
--- /dev/null
+++ a/fs/nilfs2/page.c
@@ -0,0 +1,566 @@
+/*
+ * page.c - buffer/page management specific to NILFS
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>,
+ *            Seiji Kihara <kihara@osrg.net>.
+ */
+
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
+#include <linux/swap.h>
+#include <linux/bitops.h>
+#include <linux/page-flags.h>
+#include <linux/list.h>
+#include "nilfs.h"
+#include "page.h"
+#include "btnode.h"
+
+/* borrow from fs/buffer.c::link_dev_buffers() */
+static void nilfs_link_buffers(struct page *page, struct buffer_head *head)
+{
+	struct buffer_head *bh, *tail;
+
+	bh = head;
+	do {
+		tail = bh;
+		bh = bh->b_this_page;
+	} while (bh);
+	tail->b_this_page = head;
+	attach_page_buffers(page, head);
+}
+
+struct buffer_head *
+nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
+		     int blkbits)
+
+{
+	unsigned long first_block;
+	struct buffer_head *bh;
+
+	BUG_ON(!PageLocked(page));
+
+	if (!page_has_buffers(page)) {
+		struct buffer_head *head;
+
+		head = alloc_page_buffers(page, 1 << blkbits, 1);
+		if (!head)
+			return NULL;
+		nilfs_link_buffers(page, head);
+	}
+
+	first_block = (unsigned long)index << (PAGE_CACHE_SHIFT - blkbits);
+	bh = nilfs_page_get_nth_block(page, block - first_block);
+
+	touch_buffer(bh);
+	wait_on_buffer(bh);
+	return bh;
+}
+
+/*
+ * Low-level nilfs pages, page functions
+ * Reviews should be made to adapt these to the common pagemap and buffer code.
+ */
+static struct nilfs_pages {
+	spinlock_t		lru_lock;
+	struct list_head	active;
+	struct list_head	inactive;
+	unsigned long		nr_active;
+	unsigned long		nr_inactive;
+	struct rw_semaphore	shrink_sem;
+} nilfs_pages;
+
+/*
+ * XXX per-cpu pagevecs may be able to reduce the overhead of list handlings
+ *
+ * static DEFINE_PER_CPU(struct pagevec, nilfs_lru_active) = { 0, };
+ * static DEFINE_PER_CPU(struct pagevec, nilfs_lru_inactive) = { 0, };
+ */
+
+void nilfs_pages_init(void)
+{
+	INIT_LIST_HEAD(&nilfs_pages.active);
+	INIT_LIST_HEAD(&nilfs_pages.inactive);
+	spin_lock_init(&nilfs_pages.lru_lock);
+	init_rwsem(&nilfs_pages.shrink_sem);
+	nilfs_pages.nr_active = 0;
+	nilfs_pages.nr_inactive = 0;
+}
+
+void nilfs_pages_read_counters(unsigned long *counters)
+{
+	spin_lock(&nilfs_pages.lru_lock);
+	counters[0] = nilfs_pages.nr_active;
+	counters[1] = nilfs_pages.nr_inactive;
+	spin_unlock(&nilfs_pages.lru_lock);
+}
+
+void nilfs_pages_disable_shrinker(void)
+{
+	down_read(&nilfs_pages.shrink_sem);
+}
+
+void nilfs_pages_enable_shrinker(void)
+{
+	up_read(&nilfs_pages.shrink_sem);
+}
+
+static void nilfs_free_page(struct page *page)
+{
+	unlock_page(page);
+	__free_page(page);
+}
+
+static int nilfs_try_to_release_page(struct page *page)
+{
+	/* Since the page is allocated through nilfs_alloc_buffer_page(),
+	   it always has buffer heads.  If not so, BUG. */
+	if (buffer_nilfs_node(page_buffers(page)))
+		return nilfs_btnode_invalidate_page(page, 0);
+	return nilfs_page_buffers_busy(page);
+}
+
+static int nilfs_pages_free_lru(int active, int nr, int *nf)
+{
+	struct list_head *lru_list;
+	spinlock_t *lock = &nilfs_pages.lru_lock;
+	int n_freed = 0, n_scanned = 0;
+	unsigned long *nr_lru;
+	struct page *page, *next;
+	LIST_HEAD(l_victim);
+
+	lru_list = active ? &nilfs_pages.active : &nilfs_pages.inactive;
+	nr_lru = active ? &nilfs_pages.nr_active : &nilfs_pages.nr_inactive;
+	spin_lock(lock);
+	if ((*nr_lru < nr) || (nr == 0))
+		nr = *nr_lru;
+	list_for_each_entry_safe(page, next, lru_list, lru) {
+		if (nr == 0)
+			break;
+		nr--;
+		n_scanned++;
+		page_cache_get(page);
+		if (!trylock_page(page))
+			goto keep_in_list;
+
+		if (PageWriteback(page) || PageDirty(page) ||
+		    nilfs_btnode_page_referenced(page, 1)) {
+			unlock_page(page);
+			goto keep_in_list;
+		}
+		list_move_tail(&page->lru, &l_victim);
+		continue;
+keep_in_list:
+		page_cache_release(page);
+	}
+	spin_unlock(lock);
+	list_for_each_entry_safe(page, next, &l_victim, lru) {
+		if (nilfs_try_to_release_page(page))
+			continue;
+
+		list_del_init(&page->lru);
+		n_freed++;
+		page_cache_release(page);
+		__ClearPageActive(page); /* no need for atomic operation */
+		ClearPageReferenced(page);
+		nilfs_free_buffer_page(page);
+	}
+	list_for_each_entry_safe(page, next, &l_victim, lru) {
+		/*
+		 * Although l_victim is a local list, each page in the list
+		 * may be deleted by other task once it is unlocked and
+		 * released.  Therefore we must separate these from the prior
+		 * jobs and must use a safe version of loop macro.
+		 */
+		unlock_page(page);
+		page_cache_release(page);
+		/*
+		 * next->lru.prev might be rewritten by the removal of the
+		 * released page.  But we can barely continue the loop because
+		 * next and next->lru.next is still safe.
+		 */
+	}
+	spin_lock(lock);
+	list_splice(&l_victim, lru_list);
+	*nr_lru -= n_freed;
+	spin_unlock(lock);
+	if (nf)
+		*nf = n_freed;
+	return n_scanned;
+}
+
+void nilfs_pages_destroy(void)
+{
+	nilfs_pages_free_lru(0 /* inactive */, 0, NULL);
+	if (unlikely(nilfs_pages.nr_inactive)) {
+		printk(KERN_WARNING
+		       "NILFS warning: %ld pages remain on inactive list\n",
+		       nilfs_pages.nr_inactive);
+	}
+	nilfs_pages_free_lru(1 /* active */, 0, NULL);
+	if (unlikely(nilfs_pages.nr_active)) {
+		printk(KERN_WARNING
+		       "NILFS warning: %ld pages remain on active list\n",
+		       nilfs_pages.nr_active);
+	}
+}
+
+int nilfs_pages_shrink(int nr, gfp_t gfp_mask)
+{
+	int ns, nfi = 0, nfa = 0;
+	unsigned long nr_pages[2];
+
+	nilfs_pages_read_counters(nr_pages);
+	if (nr) {
+		if (down_write_trylock(&nilfs_pages.shrink_sem)) {
+			ns = nilfs_pages_free_lru(0 /* inactive */, nr, &nfi);
+			nr -= ns;
+			if (nr > 0)
+				ns += nilfs_pages_free_lru(1 /* active */, nr,
+							   &nfa);
+			up_write(&nilfs_pages.shrink_sem);
+			/*
+			 * XXX: must move pages from the active lru to the
+			 * inactive lru for right PFRA.
+			 */
+			/* nilfs_pages_refill_inactive(nr + ns); */
+			nilfs_pages_read_counters(nr_pages);
+		}
+	}
+	return nr_pages[0] + nr_pages[1];
+}
+
+void nilfs_page_add_to_lru(struct page *page, int active)
+{
+	spin_lock(&nilfs_pages.lru_lock);
+	page_cache_get(page);	/* LRU */
+	if (active) {
+		list_add_tail(&page->lru, &nilfs_pages.active);
+		nilfs_pages.nr_active++;
+		SetPageActive(page);
+	} else {
+		list_add_tail(&page->lru, &nilfs_pages.inactive);
+		nilfs_pages.nr_inactive++;
+	}
+	spin_unlock(&nilfs_pages.lru_lock);
+}
+
+void nilfs_page_delete_from_lru(struct page *page)
+{
+	spin_lock(&nilfs_pages.lru_lock);
+	list_del_init(&page->lru);
+	if (PageActive(page)) {
+		__ClearPageActive(page); /* Callers must ensure that no one
+					    refers to this page. Otherwise,
+					    page flags would be destroyed. */
+		nilfs_pages.nr_active--;
+	} else
+		nilfs_pages.nr_inactive--;
+	page_cache_release(page); /* LRU */
+	spin_unlock(&nilfs_pages.lru_lock);
+}
+
+/* borrow from mm/swap.c::mark_page_accessed() and activate_page() */
+void nilfs_page_mark_accessed(struct page *page)
+{
+	if (PageActive(page) && PageReferenced(page))
+		return;
+	lock_page(page);
+	if (list_empty(&page->lru))
+		goto out_unlock;
+	if (!PageReferenced(page)) {
+		SetPageReferenced(page);
+		goto out_unlock;
+	}
+	spin_lock(&nilfs_pages.lru_lock);
+	if (!PageActive(page)) {
+		list_move_tail(&page->lru, &nilfs_pages.active);
+		nilfs_pages.nr_inactive--;
+		nilfs_pages.nr_active++;
+		/* inc_page_state(pgactivate); */
+		SetPageActive(page);
+	}
+	spin_unlock(&nilfs_pages.lru_lock);
+	ClearPageReferenced(page);
+out_unlock:
+	unlock_page(page);
+}
+
+/**
+ * nilfs_alloc_buffer_page - allocate a private page with buffer heads
+ *
+ * Return Value: On success, a pointer to the allocated page is returned.
+ * On error, NULL is returned.
+ */
+struct page *nilfs_alloc_buffer_page(struct block_device *bdev, int size,
+				     unsigned long state)
+{
+	struct buffer_head *bufs, *bh;
+	struct page *page;
+
+	page = alloc_page(GFP_NOFS); /* page_count of the returned page is 1 */
+	if (unlikely(!page))
+		return NULL;
+
+	INIT_LIST_HEAD(&page->lru);
+
+	lock_page(page);
+	bufs = alloc_page_buffers(page, size, 0);
+	if (unlikely(!bufs)) {
+		nilfs_free_page(page);
+		return NULL;
+	}
+	nilfs_link_buffers(page, bufs);
+	bh = bufs;
+	do {
+		bh->b_state = (1UL << BH_NILFS_Allocated) | state;
+		bh->b_bdev = bdev;	/* for a compatibility reason */
+		bh = bh->b_this_page;
+	} while (bh != bufs);
+
+	return page;
+}
+
+/**
+ * nilfs_try_to_free_buffer_page - try to free a private buffer page.
+ * @page: page to be freed
+ *
+ * The page is freed only when it has no active buffers.
+ * In that case, buffer heads attached to the page will be destroyed.
+ */
+void nilfs_free_buffer_page(struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	if (page->mapping)
+		NILFS_PAGE_BUG(page, "freeing page with mapping");
+
+	if (page_has_buffers(page) && !try_to_free_buffers(page))
+		NILFS_PAGE_BUG(page, "failed to free page");
+
+	nilfs_free_page(page);
+}
+
+/**
+ * nilfs_copy_page -- copy page flags and data
+ * @src: source page
+ * @dst: destination page
+ *
+ * nilfs_copy_page() copies page contents and some page flags.
+ * The uptodate flag and the mappedtodisk flag are copied to the @dst page.
+ * The dirty flag must be copied separately by the caller, and the writeback
+ * flag must be cleared.  The caller must lock both pages.
+ */
+static void nilfs_copy_page(struct page *src, struct page *dst)
+{
+	void *kaddr0, *kaddr1;
+
+	kaddr0 = kmap_atomic(src, KM_USER0);
+	kaddr1 = kmap_atomic(dst, KM_USER1);
+	memcpy(kaddr1, kaddr0, PAGE_SIZE);
+	kunmap_atomic(kaddr1, KM_USER1);
+	kunmap_atomic(kaddr0, KM_USER0);
+
+	BUG_ON(PageWriteback(dst));
+	if (PageUptodate(src) && !PageUptodate(dst))
+		SetPageUptodate(dst);
+	else if (!PageUptodate(src) && PageUptodate(dst))
+		ClearPageUptodate(dst);
+	if (PageMappedToDisk(src) && !PageMappedToDisk(dst))
+		SetPageMappedToDisk(dst);
+	else if (!PageMappedToDisk(src) && PageMappedToDisk(dst))
+		ClearPageMappedToDisk(dst);
+}
+
+/**
+ * nilfs_copy_buffer -- copy buffer data and flags
+ * @sbh: source buffer
+ * @dbh: destination buffer
+ */
+void nilfs_copy_buffer(struct buffer_head *sbh, struct buffer_head *dbh)
+{
+	void *kaddr0, *kaddr1;
+	unsigned long bits;
+	struct page *spage = sbh->b_page, *dpage = dbh->b_page;
+	struct buffer_head *bh;
+
+	kaddr0 = kmap_atomic(spage, KM_USER0);
+	kaddr1 = kmap_atomic(dpage, KM_USER1);
+	memcpy(kaddr1 + bh_offset(dbh), kaddr0 + bh_offset(sbh), sbh->b_size);
+	kunmap_atomic(kaddr1, KM_USER1);
+	kunmap_atomic(kaddr0, KM_USER0);
+
+	nilfs_copy_buffer_state(dbh, sbh, NILFS_BUFFER_INHERENT_BITS);
+
+	dbh->b_blocknr = sbh->b_blocknr;
+	dbh->b_bdev = sbh->b_bdev;
+
+	bh = dbh;
+	bits = sbh->b_state & ((1UL << BH_Uptodate) | (1UL << BH_Mapped));
+	while ((bh = bh->b_this_page) != dbh) {
+		lock_buffer(bh);
+		bits &= bh->b_state;
+		unlock_buffer(bh);
+	}
+	if (bits & (1UL << BH_Uptodate))
+		SetPageUptodate(dpage);
+	else
+		ClearPageUptodate(dpage);
+	if (bits & (1UL << BH_Mapped))
+		SetPageMappedToDisk(dpage);
+	else
+		ClearPageMappedToDisk(dpage);
+}
+
+/**
+ * nilfs_copy_buffer_page -- copy the page with buffers
+ * @src: source page
+ * @dst: destination page
+ * @copy_dirty: flag whether to copy dirty states on the page's buffer heads.
+ *
+ * This fuction is for both data pages and btnode pages.  The dirty flag
+ * should be treated by caller.  The page must not be under i/o.
+ * Both src and dst page must be locked
+ */
+void nilfs_copy_buffer_page(struct page *src, struct page *dst, int copy_dirty)
+{
+	struct buffer_head *dbh, *dbufs, *sbh, *sbufs;
+	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
+
+	sbh = sbufs = page_buffers(src);
+	if (!page_has_buffers(dst)) {
+		dbufs = alloc_page_buffers(dst, sbh->b_size, 1);
+		BUG_ON(!dbufs);
+		nilfs_link_buffers(dst, dbufs);
+	}
+
+	if (copy_dirty)
+		mask |= (1UL << BH_Dirty);
+
+	dbh = dbufs = page_buffers(dst);
+	do {
+		lock_buffer(sbh);
+		lock_buffer(dbh);
+		nilfs_copy_buffer_state(dbh, sbh, mask);
+		dbh->b_blocknr = sbh->b_blocknr;
+		/* dbh->b_size = sbh->b_size; */
+		dbh->b_bdev = sbh->b_bdev;
+		sbh = sbh->b_this_page;
+		dbh = dbh->b_this_page;
+	} while (dbh != dbufs);
+
+	nilfs_copy_page(src, dst);
+
+	do {
+		unlock_buffer(sbh);
+		unlock_buffer(dbh);
+		sbh = sbh->b_this_page;
+		dbh = dbh->b_this_page;
+	} while (dbh != dbufs);
+}
+
+/**
+ * nilfs_page_buffers_clean - check if a page has dirty buffers or not.
+ * @page: page to be checked
+ *
+ * nilfs_page_buffers_clean() returns zero if the page has dirty buffers.
+ * Otherwise, it returns non-zero value.
+ */
+int nilfs_page_buffers_clean(struct page *page)
+{
+	struct buffer_head *bh, *head;
+
+	bh = head = page_buffers(page);
+	do {
+		if (buffer_dirty(bh))
+			return 0;
+		bh = bh->b_this_page;
+	} while (bh != head);
+	return 1;
+}
+
+unsigned nilfs_page_count_clean_buffers(struct page *page,
+					unsigned from, unsigned to)
+{
+	unsigned block_start, block_end;
+	struct buffer_head *bh, *head;
+	unsigned nc = 0;
+
+	for (bh = head = page_buffers(page), block_start = 0;
+	     bh != head || !block_start;
+	     block_start = block_end, bh = bh->b_this_page) {
+		block_end = block_start + bh->b_size;
+		if (block_end > from && block_start < to && !buffer_dirty(bh))
+			nc++;
+	}
+	return nc;
+}
+
+void nilfs_page_bug(struct page *page)
+{
+	struct address_space *m;
+	unsigned long ino = 0;
+
+	if (unlikely(!page)) {
+		printk(KERN_CRIT "NILFS_PAGE_BUG(NULL)\n");
+		return;
+	}
+
+	m = page->mapping;
+	if (m) {
+		struct inode *inode = NILFS_AS_I(m);
+		if (inode != NULL)
+			ino = inode->i_ino;
+	}
+	printk(KERN_CRIT "NILFS_PAGE_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
+	       "mapping=%p ino=%lu\n",
+	       page, atomic_read(&page->_count),
+	       (unsigned long long)page->index, page->flags, m, ino);
+
+	if (page_has_buffers(page)) {
+		struct buffer_head *bh, *head;
+		int i = 0;
+
+		bh = head = page_buffers(page);
+		do {
+			printk(KERN_CRIT
+			       " BH[%d] %p: cnt=%d block#=%llu state=0x%lx\n",
+			       i++, bh, atomic_read(&bh->b_count),
+			       (unsigned long long)bh->b_blocknr, bh->b_state);
+			bh = bh->b_this_page;
+		} while (bh != head);
+	}
+}
+
+int __nilfs_clear_page_dirty(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	if (mapping) {
+		spin_lock_irq(&mapping->tree_lock);
+		if (test_bit(PG_dirty, &page->flags)) {
+			radix_tree_tag_clear(&mapping->page_tree,
+					     page_index(page),
+					     PAGECACHE_TAG_DIRTY);
+			spin_unlock_irq(&mapping->tree_lock);
+			return clear_page_dirty_for_io(page);
+		}
+		spin_unlock_irq(&mapping->tree_lock);
+		return 0;
+	}
+	return TestClearPageDirty(page);
+}
diff -puN /dev/null fs/nilfs2/page.h
--- /dev/null
+++ a/fs/nilfs2/page.h
@@ -0,0 +1,127 @@
+/*
+ * page.h - buffer/page management specific to NILFS
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>,
+ *            Seiji Kihara <kihara@osrg.net>.
+ */
+
+#ifndef _NILFS_PAGE_H
+#define _NILFS_PAGE_H
+
+#include "nilfs.h"
+
+extern struct buffer_head *nilfs_get_page_block(struct page *, unsigned long,
+						pgoff_t, int);
+
+extern void nilfs_pages_init(void);
+extern void nilfs_pages_destroy(void);
+extern void nilfs_pages_read_counters(unsigned long *);
+extern void nilfs_pages_disable_shrinker(void);
+extern void nilfs_pages_enable_shrinker(void);
+
+extern int nilfs_pages_shrink(int, gfp_t);
+extern void nilfs_page_add_to_lru(struct page *, int);
+extern void nilfs_page_delete_from_lru(struct page *);
+extern void nilfs_page_mark_accessed(struct page *);
+extern struct page *nilfs_alloc_buffer_page(struct block_device *, int,
+					    unsigned long);
+extern void nilfs_free_buffer_page(struct page *);
+extern void nilfs_copy_buffer_page(struct page *, struct page *, int);
+extern void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
+
+extern int nilfs_page_buffers_clean(struct page *);
+extern unsigned nilfs_page_count_clean_buffers(struct page *, unsigned,
+					       unsigned);
+extern void nilfs_page_bug(struct page *);
+extern int __nilfs_clear_page_dirty(struct page *);
+
+#define NILFS_PAGE_BUG(page, m, a...) \
+	do { nilfs_page_bug(page); BUG(); } while (0)
+
+static inline struct buffer_head *
+nilfs_page_get_nth_block(struct page *page, unsigned int count)
+{
+	struct buffer_head *bh = page_buffers(page);
+
+	while (count-- > 0)
+		bh = bh->b_this_page;
+	get_bh(bh);
+	return bh;
+}
+
+static inline void nilfs_set_page_writeback(struct page *page)
+{
+	if (buffer_nilfs_allocated(page_buffers(page))) {
+		if (!TestSetPageWriteback(page))
+			inc_zone_page_state(page, NR_WRITEBACK);
+	} else
+		set_page_writeback(page);
+}
+
+static inline void nilfs_end_page_writeback(struct page *page)
+{
+	if (buffer_nilfs_allocated(page_buffers(page))) {
+		if (TestClearPageWriteback(page))
+			dec_zone_page_state(page, NR_WRITEBACK);
+	} else
+		end_page_writeback(page);
+}
+
+static inline void nilfs_clear_page_dirty_for_io(struct page *page)
+{
+	/* Page index must be fixed before calling this function. */
+	if (buffer_nilfs_node(page_buffers(page)))
+		nilfs_btnode_page_clear_dirty(page);
+	else
+		clear_page_dirty_for_io(page);
+}
+
+static inline void nilfs_redirty_page(struct page *page)
+{
+	if (buffer_nilfs_node(page_buffers(page)))
+		nilfs_btnode_set_page_dirty(page);
+	else
+		__set_page_dirty_nobuffers(page);
+}
+
+/* buffer_busy copied from fs/buffer.c */
+static inline int nilfs_buffer_busy(struct buffer_head *bh)
+{
+	return atomic_read(&bh->b_count) |
+		(bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
+}
+
+static inline int nilfs_page_buffers_busy(struct page *page)
+{
+	struct buffer_head *head, *bh;
+
+	head = bh = page_buffers(page);
+	do {
+		if (nilfs_buffer_busy(bh))
+			return 1;
+		bh = bh->b_this_page;
+	} while (bh != head);
+	return 0;
+}
+
+#define nilfs_copy_buffer_state(dbh, sbh, mask)  \
+	do { (dbh)->b_state = ((sbh)->b_state & (mask)); } while (0)
+
+
+#endif /* _NILFS_PAGE_H */
diff -puN /dev/null fs/nilfs2/recovery.c
--- /dev/null
+++ a/fs/nilfs2/recovery.c
@@ -0,0 +1,939 @@
+/*
+ * recovery.c - NILFS recovery logic
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/blkdev.h>
+#include <linux/swap.h>
+#include "nilfs.h"
+#include "sufile.h"
+#include "page.h"
+#include "seglist.h"
+
+
+/*
+ * Segment check result
+ */
+enum {
+	NILFS_SEG_VALID,
+	NILFS_SEG_NO_SUPER_ROOT,
+	NILFS_SEG_FAIL_IO,
+	NILFS_SEG_FAIL_MAGIC,
+	NILFS_SEG_FAIL_SEQ,
+	NILFS_SEG_FAIL_CHECKSUM_SEGSUM,
+	NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT,
+	NILFS_SEG_FAIL_CHECKSUM_FULL,
+	NILFS_SEG_FAIL_CONSISTENCY,
+};
+
+/* work structure for recovery */
+struct nilfs_recovery_block {
+	ino_t ino;		/* Inode number of the file that this block
+				   belongs to */
+	sector_t blocknr;	/* block number */
+	__u64 vblocknr;		/* virtual block number */
+	unsigned long blkoff;	/* File offset of the data block (per block) */
+	struct list_head list;
+};
+
+
+static int nilfs_warn_segment_error(int err)
+{
+	switch (err) {
+	case NILFS_SEG_FAIL_IO:
+		printk(KERN_WARNING
+		       "NILFS warning: I/O error on loading last segment\n");
+		return -EIO;
+	case NILFS_SEG_FAIL_MAGIC:
+		printk(KERN_WARNING
+		       "NILFS warning: Segment magic number invalid\n");
+		break;
+	case NILFS_SEG_FAIL_SEQ:
+		printk(KERN_WARNING
+		       "NILFS warning: Sequence number mismatch\n");
+		break;
+	case NILFS_SEG_FAIL_CHECKSUM_SEGSUM:
+		printk(KERN_WARNING
+		       "NILFS warning: Checksum error in segment summary\n");
+		break;
+	case NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT:
+		printk(KERN_WARNING
+		       "NILFS warning: Checksum error in super root\n");
+		break;
+	case NILFS_SEG_FAIL_CHECKSUM_FULL:
+		printk(KERN_WARNING
+		       "NILFS warning: Checksum error in segment payload\n");
+		break;
+	case NILFS_SEG_FAIL_CONSISTENCY:
+		printk(KERN_WARNING
+		       "NILFS warning: Inconsistent segment\n");
+		break;
+	case NILFS_SEG_NO_SUPER_ROOT:
+		printk(KERN_WARNING
+		       "NILFS warning: No super root in the last segment\n");
+		break;
+	case NILFS_SEG_VALID:
+	default:
+		BUG();
+	}
+	return -EINVAL;
+}
+
+static void store_segsum_info(struct nilfs_segsum_info *ssi,
+			      struct nilfs_segment_summary *sum,
+			      unsigned int blocksize)
+{
+	ssi->flags = le16_to_cpu(sum->ss_flags);
+	ssi->seg_seq = le64_to_cpu(sum->ss_seq);
+	ssi->ctime = le64_to_cpu(sum->ss_create);
+	ssi->next = le64_to_cpu(sum->ss_next);
+	ssi->nblocks = le32_to_cpu(sum->ss_nblocks);
+	ssi->nfinfo = le32_to_cpu(sum->ss_nfinfo);
+	ssi->sumbytes = le32_to_cpu(sum->ss_sumbytes);
+
+	ssi->nsumblk = (ssi->sumbytes - 1) / blocksize + 1;
+	ssi->nfileblk = ssi->nblocks - ssi->nsumblk - !!NILFS_SEG_HAS_SR(ssi);
+}
+
+/**
+ * calc_crc_cont - check CRC of blocks continuously
+ * @sbi: nilfs_sb_info
+ * @bhs: buffer head of start block
+ * @sum: place to store result
+ * @offset: offset bytes in the first block
+ * @check_bytes: number of bytes to be checked
+ * @start: DBN of start block
+ * @nblock: number of blocks to be checked
+ */
+static int calc_crc_cont(struct nilfs_sb_info *sbi, struct buffer_head *bhs,
+			 u32 *sum, unsigned long offset, u64 check_bytes,
+			 sector_t start, unsigned long nblock)
+{
+	unsigned long blocksize = sbi->s_super->s_blocksize;
+	unsigned long size;
+	u32 crc;
+
+	BUG_ON(offset >= blocksize);
+	check_bytes -= offset;
+	size = min_t(u64, check_bytes, blocksize - offset);
+	crc = crc32_le(sbi->s_nilfs->ns_crc_seed,
+		       (unsigned char *)bhs->b_data + offset, size);
+	if (--nblock > 0) {
+		do {
+			struct buffer_head *bh
+				= sb_bread(sbi->s_super, ++start);
+			if (!bh)
+				return -EIO;
+			check_bytes -= size;
+			size = min_t(u64, check_bytes, blocksize);
+			crc = crc32_le(crc, bh->b_data, size);
+			brelse(bh);
+		} while (--nblock > 0);
+	}
+	*sum = crc;
+	return 0;
+}
+
+/**
+ * nilfs_read_super_root_block - read super root block
+ * @sb: super_block
+ * @sr_block: disk block number of the super root block
+ * @pbh: address of a buffer_head pointer to return super root buffer
+ * @check: CRC check flag
+ */
+int nilfs_read_super_root_block(struct super_block *sb, sector_t sr_block,
+				struct buffer_head **pbh, int check)
+{
+	struct buffer_head *bh_sr;
+	struct nilfs_super_root *sr;
+	u32 crc;
+	int ret;
+
+	*pbh = NULL;
+	bh_sr = sb_bread(sb, sr_block);
+	if (unlikely(!bh_sr)) {
+		ret = NILFS_SEG_FAIL_IO;
+		goto failed;
+	}
+
+	sr = (struct nilfs_super_root *)bh_sr->b_data;
+	if (check) {
+		unsigned bytes = le16_to_cpu(sr->sr_bytes);
+
+		if (bytes == 0 || bytes > sb->s_blocksize) {
+			ret = NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT;
+			goto failed_bh;
+		}
+		if (calc_crc_cont(NILFS_SB(sb), bh_sr, &crc,
+				  sizeof(sr->sr_sum), bytes, sr_block, 1)) {
+			ret = NILFS_SEG_FAIL_IO;
+			goto failed_bh;
+		}
+		if (crc != le32_to_cpu(sr->sr_sum)) {
+			ret = NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT;
+			goto failed_bh;
+		}
+	}
+	*pbh = bh_sr;
+	return 0;
+
+ failed_bh:
+	brelse(bh_sr);
+
+ failed:
+	return nilfs_warn_segment_error(ret);
+}
+
+/**
+ * load_segment_summary - read segment summary of the specified partial segment
+ * @sbi: nilfs_sb_info
+ * @pseg_start: start disk block number of partial segment
+ * @seg_seq: sequence number requested
+ * @ssi: pointer to nilfs_segsum_info struct to store information
+ * @full_check: full check flag
+ *              (0: only checks segment summary CRC, 1: data CRC)
+ */
+static int
+load_segment_summary(struct nilfs_sb_info *sbi, sector_t pseg_start,
+		     u64 seg_seq, struct nilfs_segsum_info *ssi,
+		     int full_check)
+{
+	struct buffer_head *bh_sum;
+	struct nilfs_segment_summary *sum;
+	unsigned long offset, nblock;
+	u64 check_bytes;
+	u32 crc, crc_sum;
+	int ret = NILFS_SEG_FAIL_IO;
+
+	bh_sum = sb_bread(sbi->s_super, pseg_start);
+	if (!bh_sum)
+		goto out;
+
+	sum = (struct nilfs_segment_summary *)bh_sum->b_data;
+
+	/* Check consistency of segment summary */
+	if (le32_to_cpu(sum->ss_magic) != NILFS_SEGSUM_MAGIC) {
+		ret = NILFS_SEG_FAIL_MAGIC;
+		goto failed;
+	}
+	store_segsum_info(ssi, sum, sbi->s_super->s_blocksize);
+	if (seg_seq != ssi->seg_seq) {
+		ret = NILFS_SEG_FAIL_SEQ;
+		goto failed;
+	}
+	if (full_check) {
+		offset = sizeof(sum->ss_datasum);
+		check_bytes =
+			((u64)ssi->nblocks << sbi->s_super->s_blocksize_bits);
+		nblock = ssi->nblocks;
+		crc_sum = le32_to_cpu(sum->ss_datasum);
+		ret = NILFS_SEG_FAIL_CHECKSUM_FULL;
+	} else { /* only checks segment summary */
+		offset = sizeof(sum->ss_datasum) + sizeof(sum->ss_sumsum);
+		check_bytes = ssi->sumbytes;
+		nblock = ssi->nsumblk;
+		crc_sum = le32_to_cpu(sum->ss_sumsum);
+		ret = NILFS_SEG_FAIL_CHECKSUM_SEGSUM;
+	}
+
+	if (unlikely(nblock == 0 ||
+		     nblock > sbi->s_nilfs->ns_blocks_per_segment)) {
+		/* This limits the number of blocks read in the CRC check */
+		ret = NILFS_SEG_FAIL_CONSISTENCY;
+		goto failed;
+	}
+	if (calc_crc_cont(sbi, bh_sum, &crc, offset, check_bytes,
+			  pseg_start, nblock)) {
+		ret = NILFS_SEG_FAIL_IO;
+		goto failed;
+	}
+	if (crc == crc_sum)
+		ret = 0;
+ failed:
+	brelse(bh_sum);
+ out:
+	return ret;
+}
+
+static void *segsum_get(struct super_block *sb, struct buffer_head **pbh,
+			unsigned int *offset, unsigned int bytes)
+{
+	void *ptr;
+	sector_t blocknr;
+
+	BUG_ON((*pbh)->b_size < *offset);
+	if (bytes > (*pbh)->b_size - *offset) {
+		blocknr = (*pbh)->b_blocknr;
+		brelse(*pbh);
+		*pbh = sb_bread(sb, blocknr + 1);
+		if (unlikely(!*pbh))
+			return NULL;
+		*offset = 0;
+	}
+	ptr = (*pbh)->b_data + *offset;
+	*offset += bytes;
+	return ptr;
+}
+
+static void segsum_skip(struct super_block *sb, struct buffer_head **pbh,
+			unsigned int *offset, unsigned int bytes,
+			unsigned long count)
+{
+	unsigned int rest_item_in_current_block
+		= ((*pbh)->b_size - *offset) / bytes;
+
+	if (count <= rest_item_in_current_block) {
+		*offset += bytes * count;
+	} else {
+		sector_t blocknr = (*pbh)->b_blocknr;
+		unsigned int nitem_per_block = (*pbh)->b_size / bytes;
+		unsigned int bcnt;
+
+		count -= rest_item_in_current_block;
+		bcnt = (count - 1) / nitem_per_block + 1;
+		*offset = bytes * (count - (bcnt - 1) * nitem_per_block);
+
+		brelse(*pbh);
+		*pbh = sb_bread(sb, blocknr + bcnt);
+	}
+}
+
+static int
+collect_blocks_from_segsum(struct nilfs_sb_info *sbi, sector_t sum_blocknr,
+			   struct nilfs_segsum_info *ssi,
+			   struct list_head *head)
+{
+	struct buffer_head *bh;
+	unsigned int offset;
+	unsigned long nfinfo = ssi->nfinfo;
+	sector_t blocknr = sum_blocknr + ssi->nsumblk;
+	ino_t ino;
+	int err = -EIO;
+
+	if (!nfinfo)
+		return 0;
+
+	bh = sb_bread(sbi->s_super, sum_blocknr);
+	if (unlikely(!bh))
+		goto out;
+
+	offset = le16_to_cpu(
+		((struct nilfs_segment_summary *)bh->b_data)->ss_bytes);
+	for (;;) {
+		unsigned long nblocks, ndatablk, nnodeblk;
+		struct nilfs_finfo *finfo;
+
+		finfo = segsum_get(sbi->s_super, &bh, &offset, sizeof(*finfo));
+		if (unlikely(!finfo))
+			goto out;
+
+		ino = le64_to_cpu(finfo->fi_ino);
+		nblocks = le32_to_cpu(finfo->fi_nblocks);
+		ndatablk = le32_to_cpu(finfo->fi_ndatablk);
+		nnodeblk = nblocks - ndatablk;
+
+		while (ndatablk-- > 0) {
+			struct nilfs_recovery_block *rb;
+			struct nilfs_binfo_v *binfo;
+
+			binfo = segsum_get(sbi->s_super, &bh, &offset,
+					   sizeof(*binfo));
+			if (unlikely(!binfo))
+				goto out;
+
+			rb = kmalloc(sizeof(*rb), GFP_NOFS);
+			if (unlikely(!rb)) {
+				err = -ENOMEM;
+				goto out;
+			}
+			rb->ino = ino;
+			rb->blocknr = blocknr++;
+			rb->vblocknr = le64_to_cpu(binfo->bi_vblocknr);
+			rb->blkoff = le64_to_cpu(binfo->bi_blkoff);
+			/* INIT_LIST_HEAD(&rb->list); */
+			list_add_tail(&rb->list, head);
+		}
+		if (--nfinfo == 0)
+			break;
+		blocknr += nnodeblk; /* always 0 for the data sync segments */
+		segsum_skip(sbi->s_super, &bh, &offset, sizeof(__le64),
+			    nnodeblk);
+		if (unlikely(!bh))
+			goto out;
+	}
+	err = 0;
+ out:
+	brelse(bh);   /* brelse(NULL) is just ignored */
+	return err;
+}
+
+static void dispose_recovery_list(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct nilfs_recovery_block *rb
+			= list_entry(head->next,
+				     struct nilfs_recovery_block, list);
+		list_del(&rb->list);
+		kfree(rb);
+	}
+}
+
+void nilfs_dispose_segment_list(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct nilfs_segment_entry *ent
+			= list_entry(head->next,
+				     struct nilfs_segment_entry, list);
+		list_del(&ent->list);
+		nilfs_free_segment_entry(ent);
+	}
+}
+
+static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
+					      struct nilfs_recovery_info *ri)
+{
+	struct list_head *head = &ri->ri_used_segments;
+	struct nilfs_segment_entry *ent, *n;
+	struct inode *sufile = nilfs->ns_sufile;
+	__u64 segnum[4];
+	int err;
+	int i;
+
+	segnum[0] = nilfs->ns_segnum;
+	segnum[1] = nilfs->ns_nextnum;
+	segnum[2] = ri->ri_segnum;
+	segnum[3] = ri->ri_nextnum;
+
+	/*
+	 * Releasing the next segment of the latest super root.
+	 * The next segment is invalidated by this recovery.
+	 */
+	err = nilfs_sufile_free(sufile, segnum[1]);
+	if (unlikely(err))
+		goto failed;
+
+	err = -ENOMEM;
+	for (i = 1; i < 4; i++) {
+		ent = nilfs_alloc_segment_entry(segnum[i]);
+		if (unlikely(!ent))
+			goto failed;
+		list_add_tail(&ent->list, head);
+	}
+
+	/*
+	 * Collecting segments written after the latest super root.
+	 * These are marked volatile active, and won't be reallocated in
+	 * the next construction.
+	 */
+	list_for_each_entry_safe(ent, n, head, list) {
+		if (ent->segnum == segnum[0]) {
+			list_del(&ent->list);
+			nilfs_free_segment_entry(ent);
+			continue;
+		}
+		err = nilfs_open_segment_entry(ent, sufile);
+		if (unlikely(err))
+			goto failed;
+		if (nilfs_segment_usage_clean(ent->raw_su)) {
+			nilfs_segment_usage_set_volatile_active(ent->raw_su);
+			/* Keep it open */
+		} else {
+			/* Removing duplicated entries */
+			list_del(&ent->list);
+			nilfs_close_segment_entry(ent, sufile);
+			nilfs_free_segment_entry(ent);
+		}
+	}
+	list_splice_init(head, nilfs->ns_used_segments.prev);
+
+	/*
+	 * The segment having the latest super root is active, and
+	 * should be deactivated on the next construction for recovery.
+	 */
+	err = -ENOMEM;
+	ent = nilfs_alloc_segment_entry(segnum[0]);
+	if (unlikely(!ent))
+		goto failed;
+	list_add_tail(&ent->list, &ri->ri_used_segments);
+
+	/* Allocate new segments for recovery */
+	err = nilfs_sufile_alloc(sufile, &segnum[0]);
+	if (unlikely(err))
+		goto failed;
+
+	nilfs->ns_pseg_offset = 0;
+	nilfs->ns_seg_seq = ri->ri_seq + 2;
+	nilfs->ns_nextnum = nilfs->ns_segnum = segnum[0];
+	return 0;
+
+ failed:
+	/* No need to recover sufile because it will be destroyed on error */
+	return err;
+}
+
+static int nilfs_recovery_copy_block(struct nilfs_sb_info *sbi,
+				     struct nilfs_recovery_block *rb,
+				     struct page *page)
+{
+	struct buffer_head *bh_org;
+	void *kaddr;
+
+	bh_org = sb_bread(sbi->s_super, rb->blocknr);
+	if (unlikely(!bh_org))
+		return -EIO;
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(bh_org);
+	return 0;
+}
+
+static int recover_dsync_blocks(struct nilfs_sb_info *sbi,
+				struct list_head *head,
+				unsigned long *nr_salvaged_blocks)
+{
+	struct inode *inode;
+	struct nilfs_recovery_block *rb, *n;
+	unsigned blocksize = sbi->s_super->s_blocksize;
+	struct page *page;
+	loff_t pos;
+	int err = 0, err2 = 0;
+
+	list_for_each_entry_safe(rb, n, head, list) {
+		inode = nilfs_iget(sbi->s_super, rb->ino);
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
+			inode = NULL;
+			goto failed_inode;
+		}
+
+		pos = rb->blkoff << inode->i_blkbits;
+		page = NULL;
+		err = block_write_begin(NULL, inode->i_mapping, pos, blocksize,
+					0, &page, NULL, nilfs_get_block);
+		if (unlikely(err))
+			goto failed_inode;
+
+		err = nilfs_recovery_copy_block(sbi, rb, page);
+		if (unlikely(err))
+			goto failed_page;
+
+		err = nilfs_set_file_dirty(sbi, inode, 1);
+		if (unlikely(err))
+			goto failed_page;
+
+		block_write_end(NULL, inode->i_mapping, pos, blocksize,
+				blocksize, page, NULL);
+
+		unlock_page(page);
+		page_cache_release(page);
+
+		(*nr_salvaged_blocks)++;
+		goto next;
+
+ failed_page:
+		unlock_page(page);
+		page_cache_release(page);
+
+ failed_inode:
+		printk(KERN_WARNING
+		       "NILFS warning: error recovering data block "
+		       "(err=%d, ino=%lu, block-offset=%llu)\n",
+		       err, rb->ino, (unsigned long long)rb->blkoff);
+		if (!err2)
+			err2 = err;
+ next:
+		iput(inode); /* iput(NULL) is just ignored */
+		list_del_init(&rb->list);
+		kfree(rb);
+	}
+	return err2;
+}
+
+/**
+ * nilfs_do_roll_forward - salvage logical segments newer than the latest
+ * checkpoint
+ * @sbi: nilfs_sb_info
+ * @nilfs: the_nilfs
+ * @ri: pointer to a nilfs_recovery_info
+ */
+static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
+				 struct nilfs_sb_info *sbi,
+				 struct nilfs_recovery_info *ri)
+{
+	struct nilfs_segsum_info ssi;
+	sector_t pseg_start;
+	sector_t seg_start, seg_end;  /* Starting/ending DBN of full segment */
+	unsigned long nsalvaged_blocks = 0;
+	u64 seg_seq;
+	__u64 segnum, nextnum = 0;
+	int empty_seg = 0;
+	int err = 0, ret;
+	LIST_HEAD(dsync_blocks);  /* list of data blocks to be recovered */
+	enum {
+		RF_INIT_ST,
+		RF_DSYNC_ST,   /* scanning data-sync segments */
+	};
+	int state = RF_INIT_ST;
+
+	nilfs_attach_writer(nilfs, sbi);
+	pseg_start = ri->ri_lsegs_start;
+	seg_seq = ri->ri_lsegs_start_seq;
+	segnum = nilfs_get_segnum_of_block(nilfs, pseg_start);
+	nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
+
+	while (segnum != ri->ri_segnum || pseg_start <= ri->ri_pseg_start) {
+
+		ret = load_segment_summary(sbi, pseg_start, seg_seq, &ssi, 1);
+		if (ret) {
+			if (ret == NILFS_SEG_FAIL_IO) {
+				err = -EIO;
+				goto failed;
+			}
+			goto strayed;
+		}
+		if (unlikely(NILFS_SEG_HAS_SR(&ssi)))
+			goto confused;
+
+		/* Found a valid partial segment; do recovery actions */
+		nextnum = nilfs_get_segnum_of_block(nilfs, ssi.next);
+		empty_seg = 0;
+		nilfs->ns_ctime = ssi.ctime;
+		if (!(ssi.flags & NILFS_SS_GC))
+			nilfs->ns_nongc_ctime = ssi.ctime;
+
+		switch (state) {
+		case RF_INIT_ST:
+			if (!NILFS_SEG_LOGBGN(&ssi) || !NILFS_SEG_DSYNC(&ssi))
+				goto try_next_pseg;
+			state = RF_DSYNC_ST;
+			/* Fall through */
+		case RF_DSYNC_ST:
+			if (!NILFS_SEG_DSYNC(&ssi))
+				goto confused;
+
+			err = collect_blocks_from_segsum(
+				sbi, pseg_start, &ssi, &dsync_blocks);
+			if (unlikely(err))
+				goto failed;
+			if (NILFS_SEG_LOGEND(&ssi)) {
+				err = recover_dsync_blocks(
+					sbi, &dsync_blocks, &nsalvaged_blocks);
+				if (unlikely(err))
+					goto failed;
+				state = RF_INIT_ST;
+			}
+			break; /* Fall through to try_next_pseg */
+		}
+
+ try_next_pseg:
+		if (pseg_start == ri->ri_lsegs_end)
+			break;
+		pseg_start += ssi.nblocks;
+		if (pseg_start < seg_end)
+			continue;
+		goto feed_segment;
+
+ strayed:
+		if (pseg_start == ri->ri_lsegs_end)
+			break;
+
+ feed_segment:
+		/* Looking to the next full segment */
+		if (empty_seg++)
+			break;
+		seg_seq++;
+		segnum = nextnum;
+		nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
+		pseg_start = seg_start;
+	}
+
+	if (nsalvaged_blocks) {
+		printk(KERN_INFO "NILFS (device %s): salvaged %lu blocks\n",
+		       sbi->s_super->s_id, nsalvaged_blocks);
+		ri->ri_need_recovery = NILFS_RECOVERY_ROLLFORWARD_DONE;
+	}
+ out:
+	dispose_recovery_list(&dsync_blocks);
+	nilfs_detach_writer(sbi->s_nilfs, sbi);
+	return err;
+
+ confused:
+	err = -EINVAL;
+ failed:
+	printk(KERN_ERR
+	       "NILFS (device %s): Error roll-forwarding "
+	       "(err=%d, pseg block=%llu). ",
+	       sbi->s_super->s_id, err, (unsigned long long)pseg_start);
+	goto out;
+}
+
+static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
+				      struct nilfs_sb_info *sbi,
+				      struct nilfs_recovery_info *ri)
+{
+	struct buffer_head *bh;
+	int err;
+
+	if (nilfs_get_segnum_of_block(nilfs, ri->ri_lsegs_start) !=
+	    nilfs_get_segnum_of_block(nilfs, ri->ri_super_root))
+		return;
+
+	bh = sb_getblk(sbi->s_super, ri->ri_lsegs_start);
+	BUG_ON(!bh);
+	memset(bh->b_data, 0, bh->b_size);
+	set_buffer_dirty(bh);
+	err = sync_dirty_buffer(bh);
+	if (unlikely(err))
+		printk(KERN_WARNING
+		       "NILFS warning: buffer sync write failed during "
+		       "post-cleaning of recovery.\n");
+	brelse(bh);
+}
+
+/**
+ * nilfs_recover_logical_segments - salvage logical segments written after
+ * the latest super root
+ * @nilfs: the_nilfs
+ * @sbi: nilfs_sb_info
+ * @ri: pointer to a nilfs_recovery_info struct to store search results.
+ *
+ * Return Value: On success, 0 is returned.  On error, one of the following
+ * negative error code is returned.
+ *
+ * %-EINVAL - Inconsistent filesystem state.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOSPC - No space left on device (only in a panic state).
+ *
+ * %-ERESTARTSYS - Interrupted.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_recover_logical_segments(struct the_nilfs *nilfs,
+				   struct nilfs_sb_info *sbi,
+				   struct nilfs_recovery_info *ri)
+{
+	int err;
+
+	if (ri->ri_lsegs_start == 0 || ri->ri_lsegs_end == 0)
+		return 0;
+
+	err = nilfs_attach_checkpoint(sbi, ri->ri_cno);
+	if (unlikely(err)) {
+		printk(KERN_ERR
+		       "NILFS: error loading the latest checkpoint.\n");
+		return err;
+	}
+
+	err = nilfs_do_roll_forward(nilfs, sbi, ri);
+	if (unlikely(err))
+		goto failed;
+
+	if (ri->ri_need_recovery == NILFS_RECOVERY_ROLLFORWARD_DONE) {
+		err = nilfs_prepare_segment_for_recovery(nilfs, ri);
+		if (unlikely(err)) {
+			printk(KERN_ERR "NILFS: Error preparing segments for "
+			       "recovery.\n");
+			goto failed;
+		}
+
+		err = nilfs_attach_segment_constructor(sbi, ri);
+		if (unlikely(err))
+			goto failed;
+
+		set_nilfs_discontinued(nilfs);
+		err = nilfs_construct_segment(sbi->s_super);
+		nilfs_detach_segment_constructor(sbi);
+
+		if (unlikely(err)) {
+			printk(KERN_ERR "NILFS: Oops! recovery failed. "
+			       "(err=%d)\n", err);
+			goto failed;
+		}
+
+		nilfs_finish_roll_forward(nilfs, sbi, ri);
+	}
+
+	nilfs_detach_checkpoint(sbi);
+	return 0;
+
+ failed:
+	nilfs_detach_checkpoint(sbi);
+	nilfs_mdt_clear(nilfs->ns_cpfile);
+	nilfs_mdt_clear(nilfs->ns_sufile);
+	nilfs_mdt_clear(nilfs->ns_dat);
+	return err;
+}
+
+/**
+ * nilfs_search_super_root - search the latest valid super root
+ * @nilfs: the_nilfs
+ * @sbi: nilfs_sb_info
+ * @ri: pointer to a nilfs_recovery_info struct to store search results.
+ *
+ * nilfs_search_super_root() looks for the latest super-root from a partial
+ * segment pointed by the superblock.  It sets up struct the_nilfs through
+ * this search. It fills nilfs_recovery_info (ri) required for recovery.
+ *
+ * Return Value: On success, 0 is returned.  On error, one of the following
+ * negative error code is returned.
+ *
+ * %-EINVAL - No valid segment found
+ *
+ * %-EIO - I/O error
+ */
+int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
+			    struct nilfs_recovery_info *ri)
+{
+	struct nilfs_segsum_info ssi;
+	sector_t pseg_start, pseg_end, sr_pseg_start = 0;
+	sector_t seg_start, seg_end; /* range of full segment (block number) */
+	u64 seg_seq;
+	__u64 segnum, nextnum = 0;
+	__u64 cno;
+	struct nilfs_segment_entry *ent;
+	LIST_HEAD(segments);
+	int empty_seg = 0, scan_newer = 0;
+	int ret;
+
+	pseg_start = nilfs->ns_last_pseg;
+	seg_seq = nilfs->ns_last_seq;
+	cno = nilfs->ns_last_cno;
+	segnum = nilfs_get_segnum_of_block(nilfs, pseg_start);
+
+	/* Calculate range of segment */
+	nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
+
+	for (;;) {
+		/* Load segment summary */
+		ret = load_segment_summary(sbi, pseg_start, seg_seq, &ssi, 1);
+		if (ret) {
+			if (ret == NILFS_SEG_FAIL_IO)
+				goto failed;
+			goto strayed;
+		}
+		pseg_end = pseg_start + ssi.nblocks - 1;
+		if (unlikely(pseg_end > seg_end)) {
+			ret = NILFS_SEG_FAIL_CONSISTENCY;
+			goto strayed;
+		}
+
+		/* A valid partial segment */
+		ri->ri_pseg_start = pseg_start;
+		ri->ri_seq = seg_seq;
+		ri->ri_segnum = segnum;
+		nextnum = nilfs_get_segnum_of_block(nilfs, ssi.next);
+		ri->ri_nextnum = nextnum;
+		empty_seg = 0;
+
+		if (!NILFS_SEG_HAS_SR(&ssi)) {
+			if (!scan_newer) {
+				/* This will never happen because a superblock
+				   (last_segment) always points to a pseg
+				   having a super root. */
+				ret = NILFS_SEG_FAIL_CONSISTENCY;
+				goto failed;
+			}
+			if (!ri->ri_lsegs_start && NILFS_SEG_LOGBGN(&ssi)) {
+				ri->ri_lsegs_start = pseg_start;
+				ri->ri_lsegs_start_seq = seg_seq;
+			}
+			if (NILFS_SEG_LOGEND(&ssi))
+				ri->ri_lsegs_end = pseg_start;
+			goto try_next_pseg;
+		}
+
+		/* A valid super root was found. */
+		ri->ri_cno = cno++;
+		ri->ri_super_root = pseg_end;
+		ri->ri_lsegs_start = ri->ri_lsegs_end = 0;
+
+		nilfs_dispose_segment_list(&segments);
+		nilfs->ns_pseg_offset = (sr_pseg_start = pseg_start)
+			+ ssi.nblocks - seg_start;
+		nilfs->ns_seg_seq = seg_seq;
+		nilfs->ns_segnum = segnum;
+		nilfs->ns_cno = cno;  /* nilfs->ns_cno = ri->ri_cno + 1 */
+		nilfs->ns_ctime = ssi.ctime;
+		nilfs->ns_nextnum = nextnum;
+
+		if (scan_newer)
+			ri->ri_need_recovery = NILFS_RECOVERY_SR_UPDATED;
+		else if (nilfs->ns_mount_state & NILFS_VALID_FS)
+			goto super_root_found;
+
+		scan_newer = 1;
+
+		/* reset region for roll-forward */
+		pseg_start += ssi.nblocks;
+		if (pseg_start < seg_end)
+			continue;
+		goto feed_segment;
+
+ try_next_pseg:
+		/* Standing on a course, or met an inconsistent state */
+		pseg_start += ssi.nblocks;
+		if (pseg_start < seg_end)
+			continue;
+		goto feed_segment;
+
+ strayed:
+		/* Off the trail */
+		if (!scan_newer)
+			/*
+			 * This can happen if a checkpoint was written without
+			 * barriers, or as a result of an I/O failure.
+			 */
+			goto failed;
+
+ feed_segment:
+		/* Looking to the next full segment */
+		if (empty_seg++)
+			goto super_root_found; /* found a valid super root */
+
+		ent = nilfs_alloc_segment_entry(segnum);
+		if (unlikely(!ent)) {
+			ret = -ENOMEM;
+			goto failed;
+		}
+		list_add_tail(&ent->list, &segments);
+
+		seg_seq++;
+		segnum = nextnum;
+		nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
+		pseg_start = seg_start;
+	}
+
+ super_root_found:
+	/* Updating pointers relating to the latest checkpoint */
+	list_splice(&segments, ri->ri_used_segments.prev);
+	nilfs->ns_last_pseg = sr_pseg_start;
+	nilfs->ns_last_seq = nilfs->ns_seg_seq;
+	nilfs->ns_last_cno = ri->ri_cno;
+	return 0;
+
+ failed:
+	nilfs_dispose_segment_list(&segments);
+	return (ret < 0) ? ret : nilfs_warn_segment_error(ret);
+}
diff -puN /dev/null fs/nilfs2/sb.h
--- /dev/null
+++ a/fs/nilfs2/sb.h
@@ -0,0 +1,97 @@
+/*
+ * sb.h - NILFS on-memory super block structure.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#ifndef _NILFS_SB
+#define _NILFS_SB
+
+/*
+ * Mount options
+ */
+struct nilfs_mount_options {
+	unsigned long mount_opt;
+	__u64 snapshot_cno;
+};
+
+/*
+ * NILFS super-block data in memory
+ */
+struct nilfs_sb_info {
+	/* Snapshot status */
+	__u64 s_snapshot_cno;		/* Checkpoint number */
+	atomic_t s_inodes_count;
+	atomic_t s_blocks_count;	/* Reserved (might be deleted) */
+
+	/* Mount options */
+	unsigned long s_mount_opt;
+	uid_t s_resuid;
+	gid_t s_resgid;
+
+	unsigned long s_interval;	/* construction interval */
+	unsigned long s_watermark;	/* threshold of data amount
+					   for the segment construction */
+
+	/* Fundamental members */
+	struct super_block *s_super;	/* reverse pointer to super_block */
+	struct the_nilfs *s_nilfs;
+	struct list_head s_list;	/* list head for nilfs->ns_supers */
+
+	/* Segment constructor */
+	struct list_head s_dirty_files;	/* dirty files list */
+	struct nilfs_sc_info *s_sc_info; /* segment constructor info */
+	spinlock_t s_inode_lock;	/* Lock for the nilfs inode.
+					   It covers s_dirty_files list */
+
+	/* Metadata files */
+	struct inode *s_ifile;		/* index file inode */
+
+	/* Inode allocator */
+	spinlock_t s_next_gen_lock;
+	u32 s_next_generation;
+};
+
+static inline struct nilfs_sb_info *NILFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+
+#define NILFS_BLOCK_SIZE_BITS(s)   ((s)->s_blocksize_bits)
+#define NILFS_BLOCK_SIZE(s)        (NILFS_SB(s)->s_blocksize)
+#define NILFS_INODE_SIZE(s)        (NILFS_SB(s)->s_nilfs->ns_inode_size)
+#define NILFS_FIRST_INO(s)         (NILFS_SB(s)->s_nilfs->ns_first_ino)
+
+/*
+ * Bit operations for the mount option
+ */
+#define nilfs_clear_opt(sbi, opt)  \
+	do { (sbi)->s_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
+#define nilfs_set_opt(sbi, opt)  \
+	do { (sbi)->s_mount_opt |= NILFS_MOUNT_##opt; } while (0)
+#define nilfs_test_opt(sbi, opt)   ((sbi)->s_mount_opt & NILFS_MOUNT_##opt)
+#define nilfs_write_opt(sbi, mask, opt)					\
+	do { (sbi)->s_mount_opt =					\
+		(((sbi)->s_mount_opt & ~NILFS_MOUNT_##mask) |		\
+		 NILFS_MOUNT_##opt);					\
+	} while (0)
+
+#endif /* _NILFS_SB */
diff -puN /dev/null fs/nilfs2/segbuf.c
--- /dev/null
+++ a/fs/nilfs2/segbuf.c
@@ -0,0 +1,439 @@
+/*
+ * segbuf.c - NILFS segment buffer
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/writeback.h>
+#include "page.h"
+#include "segbuf.h"
+#include "seglist.h"
+
+
+static struct kmem_cache *nilfs_segbuf_cachep;
+
+static void nilfs_segbuf_init_once(void *obj)
+{
+	memset(obj, 0, sizeof(struct nilfs_segment_buffer));
+}
+
+int __init nilfs_init_segbuf_cache(void)
+{
+	nilfs_segbuf_cachep =
+		kmem_cache_create("nilfs2_segbuf_cache",
+				  sizeof(struct nilfs_segment_buffer),
+				  0, SLAB_RECLAIM_ACCOUNT,
+				  nilfs_segbuf_init_once);
+
+	return (nilfs_segbuf_cachep == NULL) ? -ENOMEM : 0;
+}
+
+void nilfs_destroy_segbuf_cache(void)
+{
+	kmem_cache_destroy(nilfs_segbuf_cachep);
+}
+
+struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	segbuf = kmem_cache_alloc(nilfs_segbuf_cachep, GFP_NOFS);
+	if (unlikely(!segbuf))
+		return NULL;
+
+	segbuf->sb_super = sb;
+	INIT_LIST_HEAD(&segbuf->sb_list);
+	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
+	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
+	segbuf->sb_segent = NULL;
+	return segbuf;
+}
+
+void nilfs_segbuf_free(struct nilfs_segment_buffer *segbuf)
+{
+	struct nilfs_segment_entry *ent = segbuf->sb_segent;
+
+	if (ent != NULL && list_empty(&ent->list)) {
+		/* free isolated segment list head */
+		nilfs_free_segment_entry(segbuf->sb_segent);
+		segbuf->sb_segent = NULL;
+	}
+	kmem_cache_free(nilfs_segbuf_cachep, segbuf);
+}
+
+int nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
+		     unsigned long offset, struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_entry *ent;
+
+	segbuf->sb_segnum = segnum;
+	nilfs_get_segment_range(nilfs, segnum, &segbuf->sb_fseg_start,
+				&segbuf->sb_fseg_end);
+
+	segbuf->sb_pseg_start = segbuf->sb_fseg_start + offset;
+	segbuf->sb_rest_blocks =
+		segbuf->sb_fseg_end - segbuf->sb_pseg_start + 1;
+
+	/* Attach a segment list head */
+	ent = segbuf->sb_segent;
+	if (ent == NULL) {
+		segbuf->sb_segent = nilfs_alloc_segment_entry(segnum);
+		if (unlikely(!segbuf->sb_segent))
+			return -ENOMEM;
+	} else {
+		BUG_ON(ent->bh_su || !list_empty(&ent->list));
+		ent->segnum = segnum;
+	}
+	return 0;
+}
+
+void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *segbuf,
+				  __u64 nextnum, struct the_nilfs *nilfs)
+{
+	segbuf->sb_nextnum = nextnum;
+	segbuf->sb_sum.next = nilfs_get_segment_start_blocknr(nilfs, nextnum);
+}
+
+int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *segbuf)
+{
+	struct buffer_head *bh;
+
+	bh = sb_getblk(segbuf->sb_super,
+		       segbuf->sb_pseg_start + segbuf->sb_sum.nsumblk);
+	if (unlikely(!bh))
+		return -ENOMEM;
+
+	nilfs_segbuf_add_segsum_buffer(segbuf, bh);
+	return 0;
+}
+
+int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *segbuf,
+				struct buffer_head **bhp)
+{
+	struct buffer_head *bh;
+
+	bh = sb_getblk(segbuf->sb_super,
+		       segbuf->sb_pseg_start + segbuf->sb_sum.nblocks);
+	if (unlikely(!bh))
+		return -ENOMEM;
+
+	nilfs_segbuf_add_payload_buffer(segbuf, bh);
+	*bhp = bh;
+	return 0;
+}
+
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
+		       time_t ctime)
+{
+	int err;
+
+	segbuf->sb_sum.nblocks = segbuf->sb_sum.nsumblk = 0;
+	err = nilfs_segbuf_extend_segsum(segbuf);
+	if (unlikely(err))
+		return err;
+
+	segbuf->sb_sum.flags = flags;
+	segbuf->sb_sum.sumbytes = sizeof(struct nilfs_segment_summary);
+	segbuf->sb_sum.nfinfo = segbuf->sb_sum.nfileblk = 0;
+	segbuf->sb_sum.ctime = ctime;
+
+	segbuf->sb_io_error = 0;
+	return 0;
+}
+
+/*
+ * Setup segument summary
+ */
+void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
+{
+	struct nilfs_segment_summary *raw_sum;
+	struct buffer_head *bh_sum;
+
+	bh_sum = list_entry(segbuf->sb_segsum_buffers.next,
+			    struct buffer_head, b_assoc_buffers);
+	raw_sum = (struct nilfs_segment_summary *)bh_sum->b_data;
+
+	raw_sum->ss_magic    = cpu_to_le32(NILFS_SEGSUM_MAGIC);
+	raw_sum->ss_bytes    = cpu_to_le16(sizeof(*raw_sum));
+	raw_sum->ss_flags    = cpu_to_le16(segbuf->sb_sum.flags);
+	raw_sum->ss_seq      = cpu_to_le64(segbuf->sb_sum.seg_seq);
+	raw_sum->ss_create   = cpu_to_le64(segbuf->sb_sum.ctime);
+	raw_sum->ss_next     = cpu_to_le64(segbuf->sb_sum.next);
+	raw_sum->ss_nblocks  = cpu_to_le32(segbuf->sb_sum.nblocks);
+	raw_sum->ss_nfinfo   = cpu_to_le32(segbuf->sb_sum.nfinfo);
+	raw_sum->ss_sumbytes = cpu_to_le32(segbuf->sb_sum.sumbytes);
+	raw_sum->ss_pad      = 0;
+}
+
+/*
+ * CRC calculation routines
+ */
+void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *segbuf,
+				     u32 seed)
+{
+	struct buffer_head *bh;
+	struct nilfs_segment_summary *raw_sum;
+	unsigned long size, bytes = segbuf->sb_sum.sumbytes;
+	u32 crc;
+
+	bh = list_entry(segbuf->sb_segsum_buffers.next, struct buffer_head,
+			b_assoc_buffers);
+
+	raw_sum = (struct nilfs_segment_summary *)bh->b_data;
+	size = min_t(unsigned long, bytes, bh->b_size);
+	crc = crc32_le(seed,
+		       (unsigned char *)raw_sum +
+		       sizeof(raw_sum->ss_datasum) + sizeof(raw_sum->ss_sumsum),
+		       size - (sizeof(raw_sum->ss_datasum) +
+			       sizeof(raw_sum->ss_sumsum)));
+
+	list_for_each_entry_continue(bh, &segbuf->sb_segsum_buffers,
+				     b_assoc_buffers) {
+		bytes -= size;
+		size = min_t(unsigned long, bytes, bh->b_size);
+		crc = crc32_le(crc, bh->b_data, size);
+	}
+	raw_sum->ss_sumsum = cpu_to_le32(crc);
+}
+
+void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
+				   u32 seed)
+{
+	struct buffer_head *bh;
+	struct nilfs_segment_summary *raw_sum;
+	void *kaddr;
+	u32 crc;
+
+	bh = list_entry(segbuf->sb_segsum_buffers.next, struct buffer_head,
+			b_assoc_buffers);
+	raw_sum = (struct nilfs_segment_summary *)bh->b_data;
+	crc = crc32_le(seed,
+		       (unsigned char *)raw_sum + sizeof(raw_sum->ss_datasum),
+		       bh->b_size - sizeof(raw_sum->ss_datasum));
+
+	list_for_each_entry_continue(bh, &segbuf->sb_segsum_buffers,
+				     b_assoc_buffers) {
+		crc = crc32_le(crc, bh->b_data, bh->b_size);
+	}
+	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
+		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+	raw_sum->ss_datasum = cpu_to_le32(crc);
+}
+
+
+/*
+ * BIO operations
+ */
+static void nilfs_end_bio_write(struct bio *bio, int err)
+{
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct nilfs_write_info *wi = bio->bi_private;
+
+	if (err == -EOPNOTSUPP) {
+		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		bio_put(bio);
+		/* to be detected by submit_seg_bio() */
+	}
+
+	if (!uptodate)
+		atomic_inc(&wi->err);
+
+	bio_put(bio);
+	complete(&wi->bio_event);
+}
+
+static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
+{
+	struct bio *bio = wi->bio;
+	int err;
+
+	if (wi->nbio > 0 && bdi_write_congested(wi->bdi)) {
+		wait_for_completion(&wi->bio_event);
+		wi->nbio--;
+		if (unlikely(atomic_read(&wi->err))) {
+			bio_put(bio);
+			err = -EIO;
+			goto failed;
+		}
+	}
+
+	bio->bi_end_io = nilfs_end_bio_write;
+	bio->bi_private = wi;
+	bio_get(bio);
+	submit_bio(mode, bio);
+	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
+		bio_put(bio);
+		err = -EOPNOTSUPP;
+		goto failed;
+	}
+	wi->nbio++;
+	bio_put(bio);
+
+	wi->bio = NULL;
+	wi->rest_blocks -= wi->end - wi->start;
+	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
+	wi->start = wi->end;
+	return 0;
+
+ failed:
+	wi->bio = NULL;
+	return err;
+}
+
+/**
+ * nilfs_alloc_seg_bio - allocate a bio for writing segment.
+ * @sb: super block
+ * @start: beginning disk block number of this BIO.
+ * @nr_vecs: request size of page vector.
+ *
+ * alloc_seg_bio() allocates a new BIO structure and initialize it.
+ *
+ * Return Value: On success, pointer to the struct bio is returned.
+ * On error, NULL is returned.
+ */
+static struct bio *nilfs_alloc_seg_bio(struct super_block *sb, sector_t start,
+				       int nr_vecs)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+	if (bio == NULL) {
+		while (!bio && (nr_vecs >>= 1))
+			bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+	}
+	if (likely(bio)) {
+		bio->bi_bdev = sb->s_bdev;
+		bio->bi_sector = (sector_t)start << (sb->s_blocksize_bits - 9);
+	}
+	return bio;
+}
+
+void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
+				struct nilfs_write_info *wi)
+{
+	wi->bio = NULL;
+	wi->rest_blocks = segbuf->sb_sum.nblocks;
+	wi->max_pages = bio_get_nr_vecs(wi->sb->s_bdev);
+	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
+	wi->start = wi->end = 0;
+	wi->nbio = 0;
+	wi->blocknr = segbuf->sb_pseg_start;
+
+	atomic_set(&wi->err, 0);
+	init_completion(&wi->bio_event);
+}
+
+static int nilfs_submit_bh(struct nilfs_write_info *wi, struct buffer_head *bh,
+			   int mode)
+{
+	int len, err;
+
+	BUG_ON(wi->nr_vecs <= 0);
+ repeat:
+	if (!wi->bio) {
+		wi->bio = nilfs_alloc_seg_bio(wi->sb, wi->blocknr + wi->end,
+					      wi->nr_vecs);
+		if (unlikely(!wi->bio))
+			return -ENOMEM;
+	}
+
+	len = bio_add_page(wi->bio, bh->b_page, bh->b_size, bh_offset(bh));
+	if (len == bh->b_size) {
+		wi->end++;
+		return 0;
+	}
+	/* bio is FULL */
+	err = nilfs_submit_seg_bio(wi, mode);
+	/* never submit current bh */
+	if (likely(!err))
+		goto repeat;
+	return err;
+}
+
+int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
+		       struct nilfs_write_info *wi)
+{
+	struct buffer_head *bh;
+	int res, rw = WRITE;
+
+	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
+		res = nilfs_submit_bh(wi, bh, rw);
+		if (unlikely(res))
+			goto failed_bio;
+	}
+
+	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
+		res = nilfs_submit_bh(wi, bh, rw);
+		if (unlikely(res))
+			goto failed_bio;
+	}
+
+	if (wi->bio) {
+		/*
+		 * Last BIO is always sent through the following
+		 * submission.
+		 */
+		rw |= (1 << BIO_RW_SYNC);
+		res = nilfs_submit_seg_bio(wi, rw);
+		if (unlikely(res))
+			goto failed_bio;
+	}
+
+	res = 0;
+ out:
+	return res;
+
+ failed_bio:
+	atomic_inc(&wi->err);
+	goto out;
+}
+
+/**
+ * nilfs_segbuf_wait - wait for completion of requested BIOs
+ * @wi: nilfs_write_info
+ *
+ * Return Value: On Success, 0 is returned. On Error, one of the following
+ * negative error code is returned.
+ *
+ * %-EIO - I/O error
+ */
+int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf,
+		      struct nilfs_write_info *wi)
+{
+	int err = 0;
+
+	if (!wi->nbio)
+		return 0;
+
+	do {
+		wait_for_completion(&wi->bio_event);
+	} while (--wi->nbio > 0);
+
+	if (unlikely(atomic_read(&wi->err) > 0)) {
+		printk(KERN_ERR "NILFS: IO error writing segment\n");
+		err = -EIO;
+		segbuf->sb_io_error = 1;
+	}
+	return err;
+}
diff -puN /dev/null fs/nilfs2/segbuf.h
--- /dev/null
+++ a/fs/nilfs2/segbuf.h
@@ -0,0 +1,215 @@
+/*
+ * segbuf.h - NILFS Segment buffer prototypes and definitions
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+#ifndef _NILFS_SEGBUF_H
+#define _NILFS_SEGBUF_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/bio.h>
+#include <linux/completion.h>
+#include <linux/backing-dev.h>
+
+/**
+ * struct nilfs_segsum_info - On-memory segment summary
+ * @flags: Flags
+ * @nfinfo: Number of file information structures
+ * @nblocks: Number of blocks included in the partial segment
+ * @nsumblk: Number of summary blocks
+ * @sumbytes: Byte count of segment summary
+ * @nfileblk: Total number of file blocks
+ * @seg_seq: Segment sequence number
+ * @ctime: Creation time
+ * @next: Block number of the next full segment
+ */
+struct nilfs_segsum_info {
+	unsigned int		flags;
+	unsigned long		nfinfo;
+	unsigned long		nblocks;
+	unsigned long		nsumblk;
+	unsigned long		sumbytes;
+	unsigned long		nfileblk;
+	u64			seg_seq;
+	time_t			ctime;
+	sector_t		next;
+};
+
+/* macro for the flags */
+#define NILFS_SEG_HAS_SR(sum)    ((sum)->flags & NILFS_SS_SR)
+#define NILFS_SEG_LOGBGN(sum)    ((sum)->flags & NILFS_SS_LOGBGN)
+#define NILFS_SEG_LOGEND(sum)    ((sum)->flags & NILFS_SS_LOGEND)
+#define NILFS_SEG_DSYNC(sum)     ((sum)->flags & NILFS_SS_SYNDT)
+#define NILFS_SEG_SIMPLEX(sum) \
+	(((sum)->flags & (NILFS_SS_LOGBGN | NILFS_SS_LOGEND)) == \
+	 (NILFS_SS_LOGBGN | NILFS_SS_LOGEND))
+
+#define NILFS_SEG_EMPTY(sum)	((sum)->nblocks == (sum)->nsumblk)
+
+/**
+ * struct nilfs_segment_buffer - Segment buffer
+ * @sb_super: back pointer to a superblock struct
+ * @sb_list: List head to chain this structure
+ * @sb_segent: Pointer for attaching a segment entry
+ * @sb_sum: On-memory segment summary
+ * @sb_segnum: Index number of the full segment
+ * @sb_nextnum: Index number of the next full segment
+ * @sb_fseg_start: Start block number of the full segment
+ * @sb_fseg_end: End block number of the full segment
+ * @sb_pseg_start: Disk block number of partial segment
+ * @sb_rest_blocks: Number of residual blocks in the current segment
+ * @sb_segsum_buffers: List of buffers for segment summaries
+ * @sb_payload_buffers: List of buffers for segment payload
+ * @sb_io_error: I/O error status
+ */
+struct nilfs_segment_buffer {
+	struct super_block     *sb_super;
+	struct list_head	sb_list;
+	struct nilfs_segment_entry *sb_segent;
+
+	/* Segment information */
+	struct nilfs_segsum_info sb_sum;
+	__u64			sb_segnum;
+	__u64			sb_nextnum;
+	sector_t		sb_fseg_start, sb_fseg_end;
+	sector_t		sb_pseg_start;
+	unsigned		sb_rest_blocks;
+
+	/* Buffers */
+	struct list_head	sb_segsum_buffers;
+	struct list_head	sb_payload_buffers; /* including super root */
+
+	/* io status */
+	int			sb_io_error;
+};
+
+#define NILFS_LIST_SEGBUF(head)  \
+	list_entry((head), struct nilfs_segment_buffer, sb_list)
+#define NILFS_NEXT_SEGBUF(segbuf)  NILFS_LIST_SEGBUF((segbuf)->sb_list.next)
+#define NILFS_PREV_SEGBUF(segbuf)  NILFS_LIST_SEGBUF((segbuf)->sb_list.prev)
+#define NILFS_LAST_SEGBUF(head)    NILFS_LIST_SEGBUF((head)->prev)
+#define NILFS_FIRST_SEGBUF(head)   NILFS_LIST_SEGBUF((head)->next)
+#define NILFS_SEGBUF_IS_LAST(segbuf, head)  ((segbuf)->sb_list.next == (head))
+
+#define nilfs_for_each_segbuf_before(s, t, h) \
+	for ((s) = NILFS_FIRST_SEGBUF(h); (s) != (t); \
+	     (s) = NILFS_NEXT_SEGBUF(s))
+
+struct nilfs_segsum_pointer {
+	struct buffer_head     *bh;
+	unsigned		offset; /* offset in bytes */
+};
+
+#define NILFS_SEGBUF_FIRST_BH(head)  \
+	(list_entry((head)->next, struct buffer_head, b_assoc_buffers))
+#define NILFS_SEGBUF_NEXT_BH(bh)  \
+	(list_entry((bh)->b_assoc_buffers.next, struct buffer_head, \
+		    b_assoc_buffers))
+#define NILFS_SEGBUF_BH_IS_LAST(bh, head)  ((bh)->b_assoc_buffers.next == head)
+
+int __init nilfs_init_segbuf_cache(void);
+void nilfs_destroy_segbuf_cache(void);
+struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *);
+void nilfs_segbuf_free(struct nilfs_segment_buffer *);
+int nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
+		     struct the_nilfs *);
+void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
+				  struct the_nilfs *);
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t);
+int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
+int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
+				struct buffer_head **);
+void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *);
+void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *, u32);
+void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *, u32);
+
+static inline void
+nilfs_segbuf_add_segsum_buffer(struct nilfs_segment_buffer *segbuf,
+			       struct buffer_head *bh)
+{
+	list_add_tail(&bh->b_assoc_buffers, &segbuf->sb_segsum_buffers);
+	segbuf->sb_sum.nblocks++;
+	segbuf->sb_sum.nsumblk++;
+}
+
+static inline void
+nilfs_segbuf_add_payload_buffer(struct nilfs_segment_buffer *segbuf,
+				struct buffer_head *bh)
+{
+	list_add_tail(&bh->b_assoc_buffers, &segbuf->sb_payload_buffers);
+	segbuf->sb_sum.nblocks++;
+}
+
+static inline void
+nilfs_segbuf_add_file_buffer(struct nilfs_segment_buffer *segbuf,
+			     struct buffer_head *bh)
+{
+	get_bh(bh);
+	nilfs_segbuf_add_payload_buffer(segbuf, bh);
+	segbuf->sb_sum.nfileblk++;
+}
+
+static inline void nilfs_release_buffers(struct list_head *list)
+{
+	struct buffer_head *bh, *n;
+
+	list_for_each_entry_safe(bh, n, list, b_assoc_buffers) {
+		list_del_init(&bh->b_assoc_buffers);
+		brelse(bh);
+	}
+}
+
+static inline void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
+{
+	nilfs_release_buffers(&segbuf->sb_segsum_buffers);
+	nilfs_release_buffers(&segbuf->sb_payload_buffers);
+}
+
+struct nilfs_write_info {
+	struct bio	       *bio;
+	int 			start, end; /* The region to be submitted */
+	int			rest_blocks;
+	int			max_pages;
+	int			nr_vecs;
+	sector_t		blocknr;
+
+	int			nbio;
+	atomic_t		err;
+	struct completion	bio_event;
+				/* completion event of segment write */
+
+	/*
+	 * The following fields must be set explicitly
+	 */
+	struct super_block     *sb;
+	struct backing_dev_info *bdi; /* backing dev info */
+	struct buffer_head     *bh_sr;
+};
+
+
+void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *,
+				struct nilfs_write_info *);
+int nilfs_segbuf_write(struct nilfs_segment_buffer *,
+		       struct nilfs_write_info *);
+int nilfs_segbuf_wait(struct nilfs_segment_buffer *,
+		      struct nilfs_write_info *);
+
+#endif /* _NILFS_SEGBUF_H */
diff -puN /dev/null fs/nilfs2/seglist.h
--- /dev/null
+++ a/fs/nilfs2/seglist.h
@@ -0,0 +1,85 @@
+/*
+ * seglist.h - expediential structure and routines to handle list of segments
+ *             (would be removed in a future release)
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+#ifndef _NILFS_SEGLIST_H
+#define _NILFS_SEGLIST_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "sufile.h"
+
+struct nilfs_segment_entry {
+	__u64			segnum;
+
+#define NILFS_SLH_FREED		0x0001	/* The segment was freed provisonally.
+					   It must be cancelled if
+					   construction aborted */
+
+	unsigned		flags;
+	struct list_head	list;
+	struct buffer_head     *bh_su;
+	struct nilfs_segment_usage *raw_su;
+};
+
+
+void nilfs_dispose_segment_list(struct list_head *);
+
+static inline struct nilfs_segment_entry *
+nilfs_alloc_segment_entry(__u64 segnum)
+{
+	struct nilfs_segment_entry *ent = kmalloc(sizeof(*ent), GFP_NOFS);
+
+	if (likely(ent)) {
+		ent->segnum = segnum;
+		ent->flags = 0;
+		ent->bh_su = NULL;
+		ent->raw_su = NULL;
+		INIT_LIST_HEAD(&ent->list);
+	}
+	return ent;
+}
+
+static inline int nilfs_open_segment_entry(struct nilfs_segment_entry *ent,
+					   struct inode *sufile)
+{
+	return nilfs_sufile_get_segment_usage(sufile, ent->segnum,
+					      &ent->raw_su, &ent->bh_su);
+}
+
+static inline void nilfs_close_segment_entry(struct nilfs_segment_entry *ent,
+					     struct inode *sufile)
+{
+	if (!ent->bh_su)
+		return;
+	nilfs_sufile_put_segment_usage(sufile, ent->segnum, ent->bh_su);
+	ent->bh_su = NULL;
+	ent->raw_su = NULL;
+}
+
+static inline void nilfs_free_segment_entry(struct nilfs_segment_entry *ent)
+{
+	kfree(ent);
+}
+
+#endif /* _NILFS_SEGLIST_H */
diff -puN /dev/null fs/nilfs2/segment.c
--- /dev/null
+++ a/fs/nilfs2/segment.c
@@ -0,0 +1,3230 @@
+/*
+ * segment.c - NILFS segment constructor.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#include <linux/pagemap.h>
+#include <linux/buffer_head.h>
+#include <linux/writeback.h>
+#include <linux/bio.h>
+#include <linux/completion.h>
+#include <linux/blkdev.h>
+#include <linux/backing-dev.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/pagevec.h>
+#include "nilfs.h"
+#include "btnode.h"
+#include "page.h"
+#include "segment.h"
+#include "sufile.h"
+#include "cpfile.h"
+#include "ifile.h"
+#include "seglist.h"
+
+
+/*
+ * Segment constructor
+ */
+#define SC_N_PAGEVEC	16   /* Size of locally allocated page vector */
+#define SC_N_INODEVEC	16   /* Size of locally allocated inode vector */
+
+#define SC_MAX_SEGDELTA 64   /* Upper limit of the number of segments
+				appended in collection retry loop */
+
+/* Construction mode */
+enum {
+	SC_LSEG_SR = 1,	/* Make a logical segment having a super root */
+	SC_LSEG_DSYNC,	/* Flush data blocks of a given file and make
+			   a logical segment without a super root */
+	SC_FLUSH_FILE,	/* Flush data files, leads to segment writes without
+			   creating a checkpoint */
+	SC_FLUSH_DAT,	/* Flush DAT file. This also creates segments without
+			   a checkpoint */
+};
+
+/* Stage numbers of dirty block collection */
+enum {
+	NILFS_ST_INIT = 0,
+	NILFS_ST_GC,		/* Collecting dirty blocks for GC */
+	NILFS_ST_FILE,
+	NILFS_ST_SKETCH,
+	NILFS_ST_IFILE,
+	NILFS_ST_CPFILE,
+	NILFS_ST_SUFILE,
+	NILFS_ST_DAT,
+	NILFS_ST_SR,		/* Super root */
+	NILFS_ST_DSYNC,		/* Data sync blocks */
+	NILFS_ST_DONE,
+};
+
+/* State flags of collection */
+#define NILFS_CF_NODE		0x0001	/* Collecting node blocks */
+#define NILFS_CF_IFILE_STARTED	0x0002	/* IFILE stage has started */
+#define NILFS_CF_HISTORY_MASK	(NILFS_CF_IFILE_STARTED)
+
+/* Operations depending on the construction mode and file type */
+struct nilfs_sc_operations {
+	int (*collect_data)(struct nilfs_sc_info *, struct buffer_head *,
+			    struct inode *);
+	int (*collect_node)(struct nilfs_sc_info *, struct buffer_head *,
+			    struct inode *);
+	int (*collect_bmap)(struct nilfs_sc_info *, struct buffer_head *,
+			    struct inode *);
+	void (*write_data_binfo)(struct nilfs_sc_info *,
+				 struct nilfs_segsum_pointer *,
+				 union nilfs_binfo *);
+	void (*write_node_binfo)(struct nilfs_sc_info *,
+				 struct nilfs_segsum_pointer *,
+				 union nilfs_binfo *);
+};
+
+/*
+ * Other definitions
+ */
+static void nilfs_segctor_start_timer(struct nilfs_sc_info *);
+static void nilfs_segctor_do_flush(struct nilfs_sc_info *, int);
+static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *);
+static void nilfs_dispose_list(struct nilfs_sb_info *, struct list_head *,
+			       int);
+
+#define nilfs_cnt32_gt(a, b)   \
+	(typecheck(__u32, a) && typecheck(__u32, b) && \
+	 ((__s32)(b) - (__s32)(a) < 0))
+#define nilfs_cnt32_ge(a, b)   \
+	(typecheck(__u32, a) && typecheck(__u32, b) && \
+	 ((__s32)(a) - (__s32)(b) >= 0))
+#define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
+#define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
+
+/*
+ * Transaction
+ *
+ * We don't need the exclusion control among same task, because
+ * all file operations are serialized through inode->i_mutex(i_sem) including
+ * ones by the same task.
+ */
+static struct kmem_cache *nilfs_transaction_cachep;
+
+/**
+ * nilfs_init_transaction_cache - create a cache for nilfs_transaction_info
+ *
+ * nilfs_init_transaction_cache() creates a slab cache for the struct
+ * nilfs_transaction_info.
+ *
+ * Return Value: On success, it returns 0. On error, one of the following
+ * negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_init_transaction_cache(void)
+{
+	nilfs_transaction_cachep =
+		kmem_cache_create("nilfs2_transaction_cache",
+				  sizeof(struct nilfs_transaction_info),
+				  0, SLAB_RECLAIM_ACCOUNT, NULL);
+	return (nilfs_transaction_cachep == NULL) ? -ENOMEM : 0;
+}
+
+/**
+ * nilfs_detroy_transaction_cache - destroy the cache for transaction info
+ *
+ * nilfs_destroy_transaction_cache() frees the slab cache for the struct
+ * nilfs_transaction_info.
+ */
+void nilfs_destroy_transaction_cache(void)
+{
+	kmem_cache_destroy(nilfs_transaction_cachep);
+}
+
+static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
+{
+	struct nilfs_transaction_info *cur_ti = current->journal_info;
+	void *save = NULL;
+
+	if (cur_ti) {
+		if (cur_ti->ti_magic == NILFS_TI_MAGIC)
+			return ++cur_ti->ti_count;
+		else {
+			/*
+			 * If journal_info field is occupied by other FS,
+			 * we save it and restore on nilfs_transaction_end().
+			 * But this should never happen.
+			 */
+			printk(KERN_WARNING
+			       "NILFS warning: journal info from a different "
+			       "FS\n");
+			save = current->journal_info;
+		}
+	}
+	if (!ti) {
+		ti = kmem_cache_alloc(nilfs_transaction_cachep, GFP_NOFS);
+		if (!ti)
+			return -ENOMEM;
+		ti->ti_flags = NILFS_TI_DYNAMIC_ALLOC;
+	} else {
+		ti->ti_flags = 0;
+	}
+	ti->ti_count = 0;
+	ti->ti_save = save;
+	ti->ti_magic = NILFS_TI_MAGIC;
+	current->journal_info = ti;
+	return 0;
+}
+
+/**
+ * nilfs_transaction_begin - start indivisible file operations.
+ * @sb: super block
+ * @ti: nilfs_transaction_info
+ * @vacancy_check: flags for vacancy rate checks
+ *
+ * nilfs_transaction_begin() acquires a reader/writer semaphore, called
+ * the segment semaphore, to make a segment construction and write tasks
+ * exclusive.  The function is used with nilfs_transaction_end() in pairs.
+ * The region enclosed by these two functions can be nested.  To avoid a
+ * deadlock, the semaphore is only acquired or released in the outermost call.
+ *
+ * This function allocates a nilfs_transaction_info struct to keep context
+ * information on it.  It is initialized and hooked onto the current task in
+ * the outermost call.  If a pre-allocated struct is given to @ti, it is used
+ * instead; othewise a new struct is assigned from a slab.
+ *
+ * When @vacancy_check flag is set, this function will check the amount of
+ * free space, and will wait for the GC to reclaim disk space if low capacity.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-ERESTARTSYS - Interrupted
+ *
+ * %-ENOSPC - No space left on device
+ */
+int nilfs_transaction_begin(struct super_block *sb,
+			    struct nilfs_transaction_info *ti,
+			    int vacancy_check)
+{
+	struct nilfs_sb_info *sbi;
+	struct the_nilfs *nilfs;
+	int ret = nilfs_prepare_segment_lock(ti);
+
+	if (unlikely(ret < 0))
+		return ret;
+	if (ret > 0)
+		return 0;
+
+	sbi = NILFS_SB(sb);
+	nilfs = sbi->s_nilfs;
+	down_read(&nilfs->ns_segctor_sem);
+	if (vacancy_check && nilfs_near_disk_full(nilfs)) {
+		up_read(&nilfs->ns_segctor_sem);
+		ret = -ENOSPC;
+		goto failed;
+	}
+	return 0;
+
+ failed:
+	ti = current->journal_info;
+	current->journal_info = ti->ti_save;
+	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
+		kmem_cache_free(nilfs_transaction_cachep, ti);
+	return ret;
+}
+
+/**
+ * nilfs_transaction_end - end indivisible file operations.
+ * @sb: super block
+ * @commit: commit flag (0 for no change)
+ *
+ * nilfs_transaction_end() releases the read semaphore which is
+ * acquired by nilfs_transaction_begin(). Its releasing is only done
+ * in outermost call of this function. If the nilfs_transaction_info
+ * was allocated dynamically, it is given back to a slab cache.
+ */
+int nilfs_transaction_end(struct super_block *sb, int commit)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+	struct nilfs_sb_info *sbi;
+	struct nilfs_sc_info *sci;
+	int err = 0;
+
+	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
+
+	if (commit)
+		ti->ti_flags |= NILFS_TI_COMMIT;
+	if (ti->ti_count > 0) {
+		ti->ti_count--;
+		return 0;
+	}
+	sbi = NILFS_SB(sb);
+	sci = NILFS_SC(sbi);
+	if (sci != NULL) {
+		if (ti->ti_flags & NILFS_TI_COMMIT)
+			nilfs_segctor_start_timer(sci);
+		if (atomic_read(&sbi->s_nilfs->ns_ndirtyblks) >
+		    sci->sc_watermark)
+			nilfs_segctor_do_flush(sci, 0);
+	}
+	up_read(&sbi->s_nilfs->ns_segctor_sem);
+	current->journal_info = ti->ti_save;
+
+	if (ti->ti_flags & NILFS_TI_SYNC)
+		err = nilfs_construct_segment(sb);
+	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
+		kmem_cache_free(nilfs_transaction_cachep, ti);
+	return err;
+}
+
+void nilfs_relax_pressure_in_lock(struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	if (!sci || !sci->sc_flush_request)
+		return;
+
+	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
+	up_read(&nilfs->ns_segctor_sem);
+
+	down_write(&nilfs->ns_segctor_sem);
+	if (sci->sc_flush_request &&
+	    test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags)) {
+		struct nilfs_transaction_info *ti = current->journal_info;
+
+		ti->ti_flags |= NILFS_TI_WRITER;
+		nilfs_segctor_do_immediate_flush(sci);
+		ti->ti_flags &= ~NILFS_TI_WRITER;
+	}
+	downgrade_write(&nilfs->ns_segctor_sem);
+}
+
+static void nilfs_transaction_lock(struct nilfs_sb_info *sbi,
+				   struct nilfs_transaction_info *ti,
+				   int gcflag)
+{
+	struct nilfs_transaction_info *cur_ti = current->journal_info;
+
+	BUG_ON(cur_ti);
+	BUG_ON(!ti);
+	ti->ti_flags = NILFS_TI_WRITER;
+	ti->ti_count = 0;
+	ti->ti_save = cur_ti;
+	ti->ti_magic = NILFS_TI_MAGIC;
+	INIT_LIST_HEAD(&ti->ti_garbage);
+	current->journal_info = ti;
+
+	for (;;) {
+		down_write(&sbi->s_nilfs->ns_segctor_sem);
+		if (!test_bit(NILFS_SC_PRIOR_FLUSH, &NILFS_SC(sbi)->sc_flags))
+			break;
+
+		nilfs_segctor_do_immediate_flush(NILFS_SC(sbi));
+
+		up_write(&sbi->s_nilfs->ns_segctor_sem);
+		yield();
+	}
+	if (gcflag)
+		ti->ti_flags |= NILFS_TI_GC;
+}
+
+static void nilfs_transaction_unlock(struct nilfs_sb_info *sbi)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+
+	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
+	BUG_ON(ti->ti_count > 0);
+
+	up_write(&sbi->s_nilfs->ns_segctor_sem);
+	current->journal_info = ti->ti_save;
+	if (!list_empty(&ti->ti_garbage))
+		nilfs_dispose_list(sbi, &ti->ti_garbage, 0);
+}
+
+static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
+					    struct nilfs_segsum_pointer *ssp,
+					    unsigned bytes)
+{
+	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
+	unsigned blocksize = sci->sc_super->s_blocksize;
+	void *p;
+
+	if (unlikely(ssp->offset + bytes > blocksize)) {
+		ssp->offset = 0;
+		BUG_ON(NILFS_SEGBUF_BH_IS_LAST(ssp->bh,
+					       &segbuf->sb_segsum_buffers));
+		ssp->bh = NILFS_SEGBUF_NEXT_BH(ssp->bh);
+	}
+	p = ssp->bh->b_data + ssp->offset;
+	ssp->offset += bytes;
+	return p;
+}
+
+/**
+ * nilfs_segctor_reset_segment_buffer - reset the current segment buffer
+ * @sci: nilfs_sc_info
+ */
+static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
+	struct buffer_head *sumbh;
+	unsigned sumbytes;
+	unsigned flags = 0;
+	int err;
+
+	if (nilfs_doing_gc())
+		flags = NILFS_SS_GC;
+	err = nilfs_segbuf_reset(segbuf, flags, sci->sc_seg_ctime);
+	if (unlikely(err))
+		return err;
+
+	sumbh = NILFS_SEGBUF_FIRST_BH(&segbuf->sb_segsum_buffers);
+	sumbytes = segbuf->sb_sum.sumbytes;
+	sci->sc_finfo_ptr.bh = sumbh;  sci->sc_finfo_ptr.offset = sumbytes;
+	sci->sc_binfo_ptr.bh = sumbh;  sci->sc_binfo_ptr.offset = sumbytes;
+	sci->sc_blk_cnt = sci->sc_datablk_cnt = 0;
+	return 0;
+}
+
+static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
+{
+	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
+	if (NILFS_SEGBUF_IS_LAST(sci->sc_curseg, &sci->sc_segbufs))
+		return -E2BIG; /* The current segment is filled up
+				  (internal code) */
+	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
+	return nilfs_segctor_reset_segment_buffer(sci);
+}
+
+static int nilfs_segctor_add_super_root(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
+	int err;
+
+	if (segbuf->sb_sum.nblocks >= segbuf->sb_rest_blocks) {
+		err = nilfs_segctor_feed_segment(sci);
+		if (err)
+			return err;
+		segbuf = sci->sc_curseg;
+	}
+	err = nilfs_segbuf_extend_payload(segbuf, &sci->sc_super_root);
+	if (likely(!err))
+		segbuf->sb_sum.flags |= NILFS_SS_SR;
+	return err;
+}
+
+/*
+ * Functions for making segment summary and payloads
+ */
+static int nilfs_segctor_segsum_block_required(
+	struct nilfs_sc_info *sci, const struct nilfs_segsum_pointer *ssp,
+	unsigned binfo_size)
+{
+	unsigned blocksize = sci->sc_super->s_blocksize;
+	/* Size of finfo and binfo is enough small against blocksize */
+
+	return ssp->offset + binfo_size +
+		(!sci->sc_blk_cnt ? sizeof(struct nilfs_finfo) : 0) >
+		blocksize;
+}
+
+static void nilfs_segctor_begin_finfo(struct nilfs_sc_info *sci,
+				      struct inode *inode)
+{
+	sci->sc_curseg->sb_sum.nfinfo++;
+	sci->sc_binfo_ptr = sci->sc_finfo_ptr;
+	nilfs_segctor_map_segsum_entry(
+		sci, &sci->sc_binfo_ptr, sizeof(struct nilfs_finfo));
+	/* skip finfo */
+}
+
+static void nilfs_segctor_end_finfo(struct nilfs_sc_info *sci,
+				    struct inode *inode)
+{
+	struct nilfs_finfo *finfo;
+	struct nilfs_inode_info *ii;
+	struct nilfs_segment_buffer *segbuf;
+
+	if (sci->sc_blk_cnt == 0)
+		return;
+
+	ii = NILFS_I(inode);
+	finfo = nilfs_segctor_map_segsum_entry(sci, &sci->sc_finfo_ptr,
+						 sizeof(*finfo));
+	finfo->fi_ino = cpu_to_le64(inode->i_ino);
+	finfo->fi_nblocks = cpu_to_le32(sci->sc_blk_cnt);
+	finfo->fi_ndatablk = cpu_to_le32(sci->sc_datablk_cnt);
+	finfo->fi_cno = cpu_to_le64(ii->i_cno);
+
+	segbuf = sci->sc_curseg;
+	segbuf->sb_sum.sumbytes = sci->sc_binfo_ptr.offset +
+		sci->sc_super->s_blocksize * (segbuf->sb_sum.nsumblk - 1);
+	sci->sc_finfo_ptr = sci->sc_binfo_ptr;
+	sci->sc_blk_cnt = sci->sc_datablk_cnt = 0;
+}
+
+static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
+					struct buffer_head *bh,
+					struct inode *inode,
+					unsigned binfo_size)
+{
+	struct nilfs_segment_buffer *segbuf;
+	int required, err = 0;
+
+ retry:
+	segbuf = sci->sc_curseg;
+	required = nilfs_segctor_segsum_block_required(
+		sci, &sci->sc_binfo_ptr, binfo_size);
+	if (segbuf->sb_sum.nblocks + required + 1 > segbuf->sb_rest_blocks) {
+		nilfs_segctor_end_finfo(sci, inode);
+		err = nilfs_segctor_feed_segment(sci);
+		if (err)
+			return err;
+		goto retry;
+	}
+	if (unlikely(required)) {
+		err = nilfs_segbuf_extend_segsum(segbuf);
+		if (unlikely(err))
+			goto failed;
+	}
+	if (sci->sc_blk_cnt == 0)
+		nilfs_segctor_begin_finfo(sci, inode);
+
+	nilfs_segctor_map_segsum_entry(sci, &sci->sc_binfo_ptr, binfo_size);
+	/* Substitution to vblocknr is delayed until update_blocknr() */
+	nilfs_segbuf_add_file_buffer(segbuf, bh);
+	sci->sc_blk_cnt++;
+ failed:
+	return err;
+}
+
+static int nilfs_handle_bmap_error(int err, const char *fname,
+				   struct inode *inode, struct super_block *sb)
+{
+	if (err == -EINVAL) {
+		nilfs_error(sb, fname, "broken bmap (inode=%lu)\n",
+			    inode->i_ino);
+		err = -EIO;
+	}
+	return err;
+}
+
+/*
+ * Callback functions that enumerate, mark, and collect dirty blocks
+ */
+static int nilfs_collect_file_data(struct nilfs_sc_info *sci,
+				   struct buffer_head *bh, struct inode *inode)
+{
+	int err;
+
+	/* BUG_ON(!buffer_dirty(bh)); */
+	/* excluded by scan_dirty_data_buffers() */
+	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
+	if (unlikely(err < 0))
+		return nilfs_handle_bmap_error(err, __func__, inode,
+					       sci->sc_super);
+
+	err = nilfs_segctor_add_file_block(sci, bh, inode,
+					   sizeof(struct nilfs_binfo_v));
+	if (!err)
+		sci->sc_datablk_cnt++;
+	return err;
+}
+
+static int nilfs_collect_file_node(struct nilfs_sc_info *sci,
+				   struct buffer_head *bh,
+				   struct inode *inode)
+{
+	int err;
+
+	/* BUG_ON(!buffer_dirty(bh)); */
+	/* excluded by scan_dirty_node_buffers() */
+	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
+	if (unlikely(err < 0))
+		return nilfs_handle_bmap_error(err, __func__, inode,
+					       sci->sc_super);
+	return 0;
+}
+
+static int nilfs_collect_file_bmap(struct nilfs_sc_info *sci,
+				   struct buffer_head *bh,
+				   struct inode *inode)
+{
+	BUG_ON(!buffer_dirty(bh));
+	return nilfs_segctor_add_file_block(sci, bh, inode, sizeof(__le64));
+}
+
+static void nilfs_write_file_data_binfo(struct nilfs_sc_info *sci,
+					struct nilfs_segsum_pointer *ssp,
+					union nilfs_binfo *binfo)
+{
+	struct nilfs_binfo_v *binfo_v = nilfs_segctor_map_segsum_entry(
+		sci, ssp, sizeof(*binfo_v));
+	*binfo_v = binfo->bi_v;
+}
+
+static void nilfs_write_file_node_binfo(struct nilfs_sc_info *sci,
+					struct nilfs_segsum_pointer *ssp,
+					union nilfs_binfo *binfo)
+{
+	__le64 *vblocknr = nilfs_segctor_map_segsum_entry(
+		sci, ssp, sizeof(*vblocknr));
+	*vblocknr = binfo->bi_v.bi_vblocknr;
+}
+
+struct nilfs_sc_operations nilfs_sc_file_ops = {
+	.collect_data = nilfs_collect_file_data,
+	.collect_node = nilfs_collect_file_node,
+	.collect_bmap = nilfs_collect_file_bmap,
+	.write_data_binfo = nilfs_write_file_data_binfo,
+	.write_node_binfo = nilfs_write_file_node_binfo,
+};
+
+static int nilfs_collect_dat_data(struct nilfs_sc_info *sci,
+				  struct buffer_head *bh, struct inode *inode)
+{
+	int err;
+
+	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
+	if (unlikely(err < 0))
+		return nilfs_handle_bmap_error(err, __func__, inode,
+					       sci->sc_super);
+
+	err = nilfs_segctor_add_file_block(sci, bh, inode, sizeof(__le64));
+	if (!err)
+		sci->sc_datablk_cnt++;
+	return err;
+}
+
+static int nilfs_collect_dat_bmap(struct nilfs_sc_info *sci,
+				  struct buffer_head *bh, struct inode *inode)
+{
+	BUG_ON(!buffer_dirty(bh));
+	return nilfs_segctor_add_file_block(sci, bh, inode,
+					    sizeof(struct nilfs_binfo_dat));
+}
+
+static void nilfs_write_dat_data_binfo(struct nilfs_sc_info *sci,
+				       struct nilfs_segsum_pointer *ssp,
+				       union nilfs_binfo *binfo)
+{
+	__le64 *blkoff = nilfs_segctor_map_segsum_entry(sci, ssp,
+							  sizeof(*blkoff));
+	*blkoff = binfo->bi_dat.bi_blkoff;
+}
+
+static void nilfs_write_dat_node_binfo(struct nilfs_sc_info *sci,
+				       struct nilfs_segsum_pointer *ssp,
+				       union nilfs_binfo *binfo)
+{
+	struct nilfs_binfo_dat *binfo_dat =
+		nilfs_segctor_map_segsum_entry(sci, ssp, sizeof(*binfo_dat));
+	*binfo_dat = binfo->bi_dat;
+}
+
+struct nilfs_sc_operations nilfs_sc_dat_ops = {
+	.collect_data = nilfs_collect_dat_data,
+	.collect_node = nilfs_collect_file_node,
+	.collect_bmap = nilfs_collect_dat_bmap,
+	.write_data_binfo = nilfs_write_dat_data_binfo,
+	.write_node_binfo = nilfs_write_dat_node_binfo,
+};
+
+struct nilfs_sc_operations nilfs_sc_dsync_ops = {
+	.collect_data = nilfs_collect_file_data,
+	.collect_node = NULL,
+	.collect_bmap = NULL,
+	.write_data_binfo = nilfs_write_file_data_binfo,
+	.write_node_binfo = NULL,
+};
+
+static int nilfs_prepare_data_page(struct inode *inode, struct page *page)
+{
+	int err = 0;
+
+	lock_page(page);
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
+
+	if (!PageMappedToDisk(page)) {
+		struct buffer_head *bh, *head;
+		sector_t blkoff
+			= page->index << (PAGE_SHIFT - inode->i_blkbits);
+
+		int non_mapped = 0;
+
+		bh = head = page_buffers(page);
+		do {
+			if (!buffer_mapped(bh)) {
+				if (!buffer_dirty(bh)) {
+					non_mapped++;
+					continue;
+				}
+				err = nilfs_get_block(inode, blkoff, bh, 1);
+				if (unlikely(err))
+					goto out_unlock;
+			}
+		} while (blkoff++, (bh = bh->b_this_page) != head);
+		if (!non_mapped)
+			SetPageMappedToDisk(page);
+	}
+
+ out_unlock:
+	unlock_page(page);
+	return err;
+}
+
+static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
+					   struct list_head *listp,
+					   struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
+	struct address_space *mapping = inode->i_mapping;
+	struct pagevec pvec;
+	unsigned i, ndirties = 0, nlimit;
+	pgoff_t index = 0;
+	int err = 0;
+
+	nlimit = sci->sc_segbuf_nblocks -
+		(sci->sc_nblk_this_inc + segbuf->sb_sum.nblocks);
+	pagevec_init(&pvec, 0);
+ repeat:
+	if (!pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
+				PAGEVEC_SIZE))
+		return 0;
+
+	for (i = 0; i < pagevec_count(&pvec); i++) {
+		struct buffer_head *bh, *head;
+		struct page *page = pvec.pages[i];
+
+		if (mapping->host) {
+			err = nilfs_prepare_data_page(inode, page);
+			if (unlikely(err))
+				break;
+		}
+
+		bh = head = page_buffers(page);
+		do {
+			if (buffer_dirty(bh)) {
+				if (ndirties > nlimit) {
+					err = -E2BIG;
+					break;
+				}
+				get_bh(bh);
+				list_add_tail(&bh->b_assoc_buffers, listp);
+				ndirties++;
+			}
+			bh = bh->b_this_page;
+		} while (bh != head);
+	}
+	pagevec_release(&pvec);
+	cond_resched();
+
+	if (!err)
+		goto repeat;
+	return err;
+}
+
+static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
+					    struct list_head *listp)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct page *pages[SC_N_PAGEVEC];
+	struct buffer_head *bh, *head;
+	unsigned int i, n;
+	pgoff_t index = 0;
+
+ repeat:
+	n = nilfs_btnode_find_get_pages_tag(&ii->i_btnode_cache,
+					    pages, &index, SC_N_PAGEVEC,
+					    PAGECACHE_TAG_DIRTY);
+	if (!n)
+		return;
+
+	for (i = 0; i < n; i++) {
+		bh = head = page_buffers(pages[i]);
+		do {
+			if (buffer_dirty(bh)) {
+				get_bh(bh);
+				list_add_tail(&bh->b_assoc_buffers, listp);
+			}
+			bh = bh->b_this_page;
+		} while (bh != head);
+
+		page_cache_release(pages[i]);
+	}
+	goto repeat;
+}
+
+static void nilfs_dispose_list(struct nilfs_sb_info *sbi,
+			       struct list_head *head, int force)
+{
+	struct nilfs_inode_info *ii, *n;
+	struct nilfs_inode_info *ivec[SC_N_INODEVEC], **pii;
+	unsigned nv = 0;
+
+	while (!list_empty(head)) {
+		spin_lock(&sbi->s_inode_lock);
+		list_for_each_entry_safe(ii, n, head, i_dirty) {
+			list_del_init(&ii->i_dirty);
+			if (force) {
+				if (unlikely(ii->i_bh)) {
+					brelse(ii->i_bh);
+					ii->i_bh = NULL;
+				}
+			} else if (test_bit(NILFS_I_DIRTY, &ii->i_state)) {
+				set_bit(NILFS_I_QUEUED, &ii->i_state);
+				list_add_tail(&ii->i_dirty,
+					      &sbi->s_dirty_files);
+				continue;
+			}
+			ivec[nv++] = ii;
+			if (nv == SC_N_INODEVEC)
+				break;
+		}
+		spin_unlock(&sbi->s_inode_lock);
+
+		for (pii = ivec; nv > 0; pii++, nv--)
+			iput(&(*pii)->vfs_inode);
+	}
+}
+
+static int nilfs_test_metadata_dirty(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int ret = 0;
+
+	if (nilfs_mdt_fetch_dirty(sbi->s_ifile))
+		ret++;
+	if (nilfs_mdt_fetch_dirty(nilfs->ns_cpfile))
+		ret++;
+	if (nilfs_mdt_fetch_dirty(nilfs->ns_sufile))
+		ret++;
+	if (ret || nilfs_doing_gc())
+		if (nilfs_mdt_fetch_dirty(nilfs_dat_inode(nilfs)))
+			ret++;
+	return ret;
+}
+
+static int nilfs_segctor_clean(struct nilfs_sc_info *sci)
+{
+	return list_empty(&sci->sc_dirty_files) &&
+		!test_bit(NILFS_SC_DIRTY, &sci->sc_flags) &&
+		list_empty(&sci->sc_cleaning_segments) &&
+		(!nilfs_doing_gc() || list_empty(&sci->sc_gc_inodes));
+}
+
+static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	int ret = 0;
+
+	if (nilfs_test_metadata_dirty(sbi))
+		set_bit(NILFS_SC_DIRTY, &sci->sc_flags);
+
+	spin_lock(&sbi->s_inode_lock);
+	if (list_empty(&sbi->s_dirty_files) && nilfs_segctor_clean(sci))
+		ret++;
+
+	spin_unlock(&sbi->s_inode_lock);
+	return ret;
+}
+
+static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	nilfs_mdt_clear_dirty(sbi->s_ifile);
+	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
+	nilfs_mdt_clear_dirty(nilfs->ns_sufile);
+	nilfs_mdt_clear_dirty(nilfs_dat_inode(nilfs));
+}
+
+static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
+{
+	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct buffer_head *bh_cp;
+	struct nilfs_checkpoint *raw_cp;
+	int err;
+
+	/* XXX: this interface will be changed */
+	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 1,
+					  &raw_cp, &bh_cp);
+	if (likely(!err)) {
+		/* The following code is duplicated with cpfile.  But, it is
+		   needed to collect the checkpoint even if it was not newly
+		   created */
+		nilfs_mdt_mark_buffer_dirty(bh_cp);
+		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
+		nilfs_cpfile_put_checkpoint(
+			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
+	} else {
+		BUG_ON(err == -EINVAL || err == -ENOENT);
+	}
+	return err;
+}
+
+static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct buffer_head *bh_cp;
+	struct nilfs_checkpoint *raw_cp;
+	int err;
+
+	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
+					  &raw_cp, &bh_cp);
+	if (unlikely(err)) {
+		BUG_ON(err == -EINVAL || err == -ENOENT);
+		goto failed_ibh;
+	}
+	raw_cp->cp_snapshot_list.ssl_next = 0;
+	raw_cp->cp_snapshot_list.ssl_prev = 0;
+	raw_cp->cp_inodes_count =
+		cpu_to_le64(atomic_read(&sbi->s_inodes_count));
+	raw_cp->cp_blocks_count =
+		cpu_to_le64(atomic_read(&sbi->s_blocks_count));
+	raw_cp->cp_nblk_inc =
+		cpu_to_le64(sci->sc_nblk_inc + sci->sc_nblk_this_inc);
+	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
+	raw_cp->cp_cno = cpu_to_le64(nilfs->ns_cno);
+	if (sci->sc_sketch_inode && i_size_read(sci->sc_sketch_inode) > 0)
+		nilfs_checkpoint_set_sketch(raw_cp);
+	nilfs_write_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode, 1);
+	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
+	return 0;
+
+ failed_ibh:
+	return err;
+}
+
+static void nilfs_fill_in_file_bmap(struct inode *ifile,
+				    struct nilfs_inode_info *ii)
+
+{
+	struct buffer_head *ibh;
+	struct nilfs_inode *raw_inode;
+
+	if (test_bit(NILFS_I_BMAP, &ii->i_state)) {
+		ibh = ii->i_bh;
+		BUG_ON(!ibh);
+		raw_inode = nilfs_ifile_map_inode(ifile, ii->vfs_inode.i_ino,
+						  ibh);
+		nilfs_bmap_write(ii->i_bmap, raw_inode);
+		nilfs_ifile_unmap_inode(ifile, ii->vfs_inode.i_ino, ibh);
+	}
+}
+
+static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci,
+					    struct inode *ifile)
+{
+	struct nilfs_inode_info *ii;
+
+	list_for_each_entry(ii, &sci->sc_dirty_files, i_dirty) {
+		nilfs_fill_in_file_bmap(ifile, ii);
+		set_bit(NILFS_I_COLLECTED, &ii->i_state);
+	}
+	if (sci->sc_sketch_inode) {
+		ii = NILFS_I(sci->sc_sketch_inode);
+		if (test_bit(NILFS_I_DIRTY, &ii->i_state))
+			nilfs_fill_in_file_bmap(ifile, ii);
+	}
+}
+
+/*
+ * CRC calculation routines
+ */
+static void nilfs_fill_in_super_root_crc(struct buffer_head *bh_sr, u32 seed)
+{
+	struct nilfs_super_root *raw_sr =
+		(struct nilfs_super_root *)bh_sr->b_data;
+	u32 crc;
+
+	BUG_ON(NILFS_SR_BYTES > bh_sr->b_size);
+	crc = crc32_le(seed,
+		       (unsigned char *)raw_sr + sizeof(raw_sr->sr_sum),
+		       NILFS_SR_BYTES - sizeof(raw_sr->sr_sum));
+	raw_sr->sr_sum = cpu_to_le32(crc);
+}
+
+static void nilfs_segctor_fill_in_checksums(struct nilfs_sc_info *sci,
+					    u32 seed)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	if (sci->sc_super_root)
+		nilfs_fill_in_super_root_crc(sci->sc_super_root, seed);
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		nilfs_segbuf_fill_in_segsum_crc(segbuf, seed);
+		nilfs_segbuf_fill_in_data_crc(segbuf, seed);
+	}
+}
+
+static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
+					     struct the_nilfs *nilfs)
+{
+	struct buffer_head *bh_sr = sci->sc_super_root;
+	struct nilfs_super_root *raw_sr =
+		(struct nilfs_super_root *)bh_sr->b_data;
+	unsigned isz = nilfs->ns_inode_size;
+
+	raw_sr->sr_bytes = cpu_to_le16(NILFS_SR_BYTES);
+	raw_sr->sr_nongc_ctime
+		= cpu_to_le64(nilfs_doing_gc() ?
+			      nilfs->ns_nongc_ctime : sci->sc_seg_ctime);
+	raw_sr->sr_flags = 0;
+
+	nilfs_mdt_write_inode_direct(
+		nilfs_dat_inode(nilfs), bh_sr, NILFS_SR_DAT_OFFSET(isz));
+	nilfs_mdt_write_inode_direct(
+		nilfs->ns_cpfile, bh_sr, NILFS_SR_CPFILE_OFFSET(isz));
+	nilfs_mdt_write_inode_direct(
+		nilfs->ns_sufile, bh_sr, NILFS_SR_SUFILE_OFFSET(isz));
+}
+
+static void nilfs_redirty_inodes(struct list_head *head)
+{
+	struct nilfs_inode_info *ii;
+
+	list_for_each_entry(ii, head, i_dirty) {
+		if (test_bit(NILFS_I_COLLECTED, &ii->i_state))
+			clear_bit(NILFS_I_COLLECTED, &ii->i_state);
+	}
+}
+
+static void nilfs_drop_collected_inodes(struct list_head *head)
+{
+	struct nilfs_inode_info *ii;
+
+	list_for_each_entry(ii, head, i_dirty) {
+		if (!test_and_clear_bit(NILFS_I_COLLECTED, &ii->i_state))
+			continue;
+
+		clear_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
+		set_bit(NILFS_I_UPDATED, &ii->i_state);
+	}
+}
+
+static void nilfs_segctor_cancel_free_segments(struct nilfs_sc_info *sci,
+					       struct inode *sufile)
+
+{
+	struct list_head *head = &sci->sc_cleaning_segments;
+	struct nilfs_segment_entry *ent;
+	int err;
+
+	list_for_each_entry(ent, head, list) {
+		if (!(ent->flags & NILFS_SLH_FREED))
+			break;
+		err = nilfs_sufile_cancel_free(sufile, ent->segnum);
+		BUG_ON(err);
+
+		ent->flags &= ~NILFS_SLH_FREED;
+	}
+}
+
+static int nilfs_segctor_prepare_free_segments(struct nilfs_sc_info *sci,
+					       struct inode *sufile)
+{
+	struct list_head *head = &sci->sc_cleaning_segments;
+	struct nilfs_segment_entry *ent;
+	int err;
+
+	list_for_each_entry(ent, head, list) {
+		err = nilfs_sufile_free(sufile, ent->segnum);
+		if (unlikely(err))
+			return err;
+		ent->flags |= NILFS_SLH_FREED;
+	}
+	return 0;
+}
+
+static void nilfs_segctor_commit_free_segments(struct nilfs_sc_info *sci)
+{
+	nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
+}
+
+static int nilfs_segctor_apply_buffers(struct nilfs_sc_info *sci,
+				       struct inode *inode,
+				       struct list_head *listp,
+				       int (*collect)(struct nilfs_sc_info *,
+						      struct buffer_head *,
+						      struct inode *))
+{
+	struct buffer_head *bh, *n;
+	int err = 0;
+
+	if (collect) {
+		list_for_each_entry_safe(bh, n, listp, b_assoc_buffers) {
+			list_del_init(&bh->b_assoc_buffers);
+			err = collect(sci, bh, inode);
+			brelse(bh);
+			if (unlikely(err))
+				goto dispose_buffers;
+		}
+		return 0;
+	}
+
+ dispose_buffers:
+	while (!list_empty(listp)) {
+		bh = list_entry(listp->next, struct buffer_head,
+				b_assoc_buffers);
+		list_del_init(&bh->b_assoc_buffers);
+		brelse(bh);
+	}
+	return err;
+}
+
+static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
+				   struct inode *inode,
+				   struct nilfs_sc_operations *sc_ops)
+{
+	LIST_HEAD(data_buffers);
+	LIST_HEAD(node_buffers);
+	int err, err2;
+
+	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
+		err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers,
+						      sci);
+		if (err) {
+			err2 = nilfs_segctor_apply_buffers(
+				sci, inode, &data_buffers,
+				err == -E2BIG ? sc_ops->collect_data : NULL);
+			if (err == -E2BIG)
+				err = err2;
+			goto break_or_fail;
+		}
+	}
+	nilfs_lookup_dirty_node_buffers(inode, &node_buffers);
+
+	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
+		err = nilfs_segctor_apply_buffers(
+			sci, inode, &data_buffers, sc_ops->collect_data);
+		if (unlikely(err)) {
+			/* dispose node list */
+			nilfs_segctor_apply_buffers(
+				sci, inode, &node_buffers, NULL);
+			goto break_or_fail;
+		}
+		sci->sc_stage.flags |= NILFS_CF_NODE;
+	}
+	/* Collect node */
+	err = nilfs_segctor_apply_buffers(
+		sci, inode, &node_buffers, sc_ops->collect_node);
+	if (unlikely(err))
+		goto break_or_fail;
+
+	nilfs_bmap_lookup_dirty_buffers(NILFS_I(inode)->i_bmap, &node_buffers);
+	err = nilfs_segctor_apply_buffers(
+		sci, inode, &node_buffers, sc_ops->collect_bmap);
+	if (unlikely(err))
+		goto break_or_fail;
+
+	nilfs_segctor_end_finfo(sci, inode);
+	sci->sc_stage.flags &= ~NILFS_CF_NODE;
+
+ break_or_fail:
+	return err;
+}
+
+static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
+					 struct inode *inode)
+{
+	LIST_HEAD(data_buffers);
+	int err, err2;
+
+	err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, sci);
+	err2 = nilfs_segctor_apply_buffers(sci, inode, &data_buffers,
+					   (!err || err == -E2BIG) ?
+					   nilfs_collect_file_data : NULL);
+	if (err == -E2BIG)
+		err = err2;
+	if (!err)
+		nilfs_segctor_end_finfo(sci, inode);
+	return err;
+}
+
+static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct list_head *head;
+	struct nilfs_inode_info *ii;
+	int err = 0;
+
+	switch (sci->sc_stage.scnt) {
+	case NILFS_ST_INIT:
+		/* Pre-processes */
+		sci->sc_stage.flags = 0;
+
+		if (!test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags)) {
+			sci->sc_nblk_inc = 0;
+			sci->sc_curseg->sb_sum.flags = NILFS_SS_LOGBGN;
+			if (mode == SC_LSEG_DSYNC) {
+				sci->sc_stage.scnt = NILFS_ST_DSYNC;
+				goto dsync_mode;
+			}
+		}
+
+		sci->sc_stage.dirty_file_ptr = NULL;
+		sci->sc_stage.gc_inode_ptr = NULL;
+		if (mode == SC_FLUSH_DAT) {
+			sci->sc_stage.scnt = NILFS_ST_DAT;
+			goto dat_stage;
+		}
+		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_GC:
+		if (nilfs_doing_gc()) {
+			head = &sci->sc_gc_inodes;
+			ii = list_prepare_entry(sci->sc_stage.gc_inode_ptr,
+						head, i_dirty);
+			list_for_each_entry_continue(ii, head, i_dirty) {
+				err = nilfs_segctor_scan_file(
+					sci, &ii->vfs_inode,
+					&nilfs_sc_file_ops);
+				if (unlikely(err)) {
+					sci->sc_stage.gc_inode_ptr = list_entry(
+						ii->i_dirty.prev,
+						struct nilfs_inode_info,
+						i_dirty);
+					goto break_or_fail;
+				}
+				set_bit(NILFS_I_COLLECTED, &ii->i_state);
+			}
+			sci->sc_stage.gc_inode_ptr = NULL;
+		}
+		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_FILE:
+		head = &sci->sc_dirty_files;
+		ii = list_prepare_entry(sci->sc_stage.dirty_file_ptr, head,
+					i_dirty);
+		list_for_each_entry_continue(ii, head, i_dirty) {
+			clear_bit(NILFS_I_DIRTY, &ii->i_state);
+
+			err = nilfs_segctor_scan_file(sci, &ii->vfs_inode,
+						      &nilfs_sc_file_ops);
+			if (unlikely(err)) {
+				sci->sc_stage.dirty_file_ptr =
+					list_entry(ii->i_dirty.prev,
+						   struct nilfs_inode_info,
+						   i_dirty);
+				goto break_or_fail;
+			}
+			/* sci->sc_stage.dirty_file_ptr = NILFS_I(inode); */
+			/* XXX: required ? */
+		}
+		sci->sc_stage.dirty_file_ptr = NULL;
+		if (mode == SC_FLUSH_FILE) {
+			sci->sc_stage.scnt = NILFS_ST_DONE;
+			return 0;
+		}
+		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_SKETCH:
+		if (mode == SC_LSEG_SR && sci->sc_sketch_inode) {
+			ii = NILFS_I(sci->sc_sketch_inode);
+			if (test_bit(NILFS_I_DIRTY, &ii->i_state)) {
+				sci->sc_sketch_inode->i_ctime.tv_sec
+					= sci->sc_seg_ctime;
+				sci->sc_sketch_inode->i_mtime.tv_sec
+					= sci->sc_seg_ctime;
+				err = nilfs_mark_inode_dirty(
+					sci->sc_sketch_inode);
+				if (unlikely(err))
+					goto break_or_fail;
+			}
+			err = nilfs_segctor_scan_file(sci,
+						      sci->sc_sketch_inode,
+						      &nilfs_sc_file_ops);
+			if (unlikely(err))
+				goto break_or_fail;
+		}
+		sci->sc_stage.scnt++;
+		sci->sc_stage.flags |= NILFS_CF_IFILE_STARTED;
+		/* Fall through */
+	case NILFS_ST_IFILE:
+		err = nilfs_segctor_scan_file(sci, sbi->s_ifile,
+					      &nilfs_sc_file_ops);
+		if (unlikely(err))
+			break;
+		sci->sc_stage.scnt++;
+		/* Creating a checkpoint */
+		err = nilfs_segctor_create_checkpoint(sci);
+		if (unlikely(err))
+			break;
+		/* Fall through */
+	case NILFS_ST_CPFILE:
+		err = nilfs_segctor_scan_file(sci, nilfs->ns_cpfile,
+					      &nilfs_sc_file_ops);
+		if (unlikely(err))
+			break;
+		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_SUFILE:
+		err = nilfs_segctor_prepare_free_segments(sci,
+							  nilfs->ns_sufile);
+		if (unlikely(err))
+			break;
+		err = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
+					      &nilfs_sc_file_ops);
+		if (unlikely(err))
+			break;
+		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_DAT:
+ dat_stage:
+		err = nilfs_segctor_scan_file(sci, nilfs_dat_inode(nilfs),
+					      &nilfs_sc_dat_ops);
+		if (unlikely(err))
+			break;
+		if (mode == SC_FLUSH_DAT) {
+			sci->sc_stage.scnt = NILFS_ST_DONE;
+			return 0;
+		}
+		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_SR:
+		if (mode == SC_LSEG_SR) {
+			/* Appending a super root */
+			err = nilfs_segctor_add_super_root(sci);
+			if (unlikely(err))
+				break;
+		}
+		/* End of a logical segment */
+		sci->sc_curseg->sb_sum.flags |= NILFS_SS_LOGEND;
+		sci->sc_stage.scnt = NILFS_ST_DONE;
+		return 0;
+	case NILFS_ST_DSYNC:
+ dsync_mode:
+		sci->sc_curseg->sb_sum.flags |= NILFS_SS_SYNDT;
+		ii = sci->sc_stage.dirty_file_ptr;
+		if (!test_bit(NILFS_I_BUSY, &ii->i_state))
+			break;
+
+		err = nilfs_segctor_scan_file_dsync(sci, &ii->vfs_inode);
+		if (unlikely(err))
+			break;
+		sci->sc_stage.dirty_file_ptr = NULL;
+		sci->sc_curseg->sb_sum.flags |= NILFS_SS_LOGEND;
+		sci->sc_stage.scnt = NILFS_ST_DONE;
+		return 0;
+	case NILFS_ST_DONE:
+		return 0;
+	default:
+		BUG();
+	}
+
+ break_or_fail:
+	return err;
+}
+
+static int nilfs_segctor_terminate_segment(struct nilfs_sc_info *sci,
+					   struct nilfs_segment_buffer *segbuf,
+					   struct inode *sufile)
+{
+	struct nilfs_segment_entry *ent = segbuf->sb_segent;
+	int err;
+
+	err = nilfs_open_segment_entry(ent, sufile);
+	if (unlikely(err))
+		return err;
+	nilfs_mdt_mark_buffer_dirty(ent->bh_su);
+	nilfs_mdt_mark_dirty(sufile);
+	nilfs_close_segment_entry(ent, sufile);
+
+	list_add_tail(&ent->list, &sci->sc_active_segments);
+	segbuf->sb_segent = NULL;
+	return 0;
+}
+
+static int nilfs_touch_segusage(struct inode *sufile, __u64 segnum)
+{
+	struct buffer_head *bh_su;
+	struct nilfs_segment_usage *raw_su;
+	int err;
+
+	err = nilfs_sufile_get_segment_usage(sufile, segnum, &raw_su, &bh_su);
+	if (unlikely(err))
+		return err;
+	nilfs_mdt_mark_buffer_dirty(bh_su);
+	nilfs_mdt_mark_dirty(sufile);
+	nilfs_sufile_put_segment_usage(sufile, segnum, bh_su);
+	return 0;
+}
+
+static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
+					    struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_buffer *segbuf, *n;
+	struct inode *sufile = nilfs->ns_sufile;
+	__u64 nextnum;
+	int err;
+
+	if (list_empty(&sci->sc_segbufs)) {
+		segbuf = nilfs_segbuf_new(sci->sc_super);
+		if (unlikely(!segbuf))
+			return -ENOMEM;
+		list_add(&segbuf->sb_list, &sci->sc_segbufs);
+	} else
+		segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+
+	err = nilfs_segbuf_map(segbuf, nilfs->ns_segnum,
+			       nilfs->ns_pseg_offset, nilfs);
+	if (unlikely(err))
+		return err;
+
+	if (segbuf->sb_rest_blocks < NILFS_PSEG_MIN_BLOCKS) {
+		err = nilfs_segctor_terminate_segment(sci, segbuf, sufile);
+		if (unlikely(err))
+			return err;
+
+		nilfs_shift_to_next_segment(nilfs);
+		err = nilfs_segbuf_map(segbuf, nilfs->ns_segnum, 0, nilfs);
+	}
+	sci->sc_segbuf_nblocks = segbuf->sb_rest_blocks;
+
+	err = nilfs_touch_segusage(sufile, segbuf->sb_segnum);
+	if (unlikely(err))
+		return err;
+
+	if (nilfs->ns_segnum == nilfs->ns_nextnum) {
+		/* Start from the head of a new full segment */
+		err = nilfs_sufile_alloc(sufile, &nextnum);
+		if (unlikely(err))
+			return err;
+	} else
+		nextnum = nilfs->ns_nextnum;
+
+	segbuf->sb_sum.seg_seq = nilfs->ns_seg_seq;
+	nilfs_segbuf_set_next_segnum(segbuf, nextnum, nilfs);
+
+	/* truncating segment buffers */
+	list_for_each_entry_safe_continue(segbuf, n, &sci->sc_segbufs,
+					  sb_list) {
+		list_del_init(&segbuf->sb_list);
+		nilfs_segbuf_free(segbuf);
+	}
+	return err;
+}
+
+static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
+					 struct the_nilfs *nilfs, int nadd)
+{
+	struct nilfs_segment_buffer *segbuf, *prev, *n;
+	struct inode *sufile = nilfs->ns_sufile;
+	__u64 nextnextnum;
+	LIST_HEAD(list);
+	int err, ret, i;
+
+	prev = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
+	/*
+	 * Since the segment specified with nextnum might be allocated during
+	 * the previous construction, the buffer including its segusage may
+	 * not be dirty.  The following call ensures that the buffer is dirty
+	 * and will pin the buffer on memory until the sufile is written.
+	 */
+	err = nilfs_touch_segusage(sufile, prev->sb_nextnum);
+	if (unlikely(err))
+		return err;
+
+	for (i = 0; i < nadd; i++) {
+		/* extend segment info */
+		err = -ENOMEM;
+		segbuf = nilfs_segbuf_new(sci->sc_super);
+		if (unlikely(!segbuf))
+			goto failed;
+
+		/* map this buffer to region of segment on-disk */
+		err = nilfs_segbuf_map(segbuf, prev->sb_nextnum, 0, nilfs);
+		if (unlikely(err))
+			goto failed_segbuf;
+
+		sci->sc_segbuf_nblocks += segbuf->sb_rest_blocks;
+
+		/* allocate the next next full segment */
+		err = nilfs_sufile_alloc(sufile, &nextnextnum);
+		if (unlikely(err))
+			goto failed_segbuf;
+
+		segbuf->sb_sum.seg_seq = prev->sb_sum.seg_seq + 1;
+		nilfs_segbuf_set_next_segnum(segbuf, nextnextnum, nilfs);
+
+		list_add_tail(&segbuf->sb_list, &list);
+		prev = segbuf;
+	}
+	list_splice(&list, sci->sc_segbufs.prev);
+	return 0;
+
+ failed_segbuf:
+	nilfs_segbuf_free(segbuf);
+ failed:
+	list_for_each_entry_safe(segbuf, n, &list, sb_list) {
+		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
+		BUG_ON(ret);
+		list_del_init(&segbuf->sb_list);
+		nilfs_segbuf_free(segbuf);
+	}
+	return err;
+}
+
+static void nilfs_segctor_free_incomplete_segments(struct nilfs_sc_info *sci,
+						   struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_buffer *segbuf;
+	int ret, done = 0;
+
+	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+	if (nilfs->ns_nextnum != segbuf->sb_nextnum) {
+		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
+		BUG_ON(ret);
+	}
+	if (segbuf->sb_io_error) {
+		/* Case 1: The first segment failed */
+		if (segbuf->sb_pseg_start != segbuf->sb_fseg_start)
+			/* Case 1a:  Partial segment appended into an existing
+			   segment */
+			nilfs_terminate_segment(nilfs, segbuf->sb_fseg_start,
+						segbuf->sb_fseg_end);
+		else /* Case 1b:  New full segment */
+			set_nilfs_discontinued(nilfs);
+		done++;
+	}
+
+	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
+		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
+		BUG_ON(ret);
+		if (!done && segbuf->sb_io_error) {
+			if (segbuf->sb_segnum != nilfs->ns_nextnum)
+				/* Case 2: extended segment (!= next) failed */
+				nilfs_sufile_set_error(nilfs->ns_sufile,
+						       segbuf->sb_segnum);
+			done++;
+		}
+	}
+}
+
+static void nilfs_segctor_clear_segment_buffers(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list)
+		nilfs_segbuf_clear(segbuf);
+	sci->sc_super_root = NULL;
+}
+
+static void nilfs_segctor_destroy_segment_buffers(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	while (!list_empty(&sci->sc_segbufs)) {
+		segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+		list_del_init(&segbuf->sb_list);
+		nilfs_segbuf_free(segbuf);
+	}
+	/* sci->sc_curseg = NULL; */
+}
+
+static void nilfs_segctor_end_construction(struct nilfs_sc_info *sci,
+					   struct the_nilfs *nilfs, int err)
+{
+	if (unlikely(err)) {
+		nilfs_segctor_free_incomplete_segments(sci, nilfs);
+		nilfs_segctor_cancel_free_segments(sci, nilfs->ns_sufile);
+	}
+	nilfs_segctor_clear_segment_buffers(sci);
+}
+
+static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
+					  struct inode *sufile)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct buffer_head *bh_su;
+	struct nilfs_segment_usage *raw_su;
+	unsigned long live_blocks;
+	int ret;
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
+						     &raw_su, &bh_su);
+		BUG_ON(ret); /* always succeed because bh_su is dirty */
+		live_blocks = segbuf->sb_sum.nblocks +
+			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
+		raw_su->su_lastmod = cpu_to_le64(sci->sc_seg_ctime);
+		raw_su->su_nblocks = cpu_to_le32(live_blocks);
+		nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum,
+					       bh_su);
+	}
+}
+
+static void nilfs_segctor_cancel_segusage(struct nilfs_sc_info *sci,
+					  struct inode *sufile)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct buffer_head *bh_su;
+	struct nilfs_segment_usage *raw_su;
+	int ret;
+
+	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+	ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
+					     &raw_su, &bh_su);
+	BUG_ON(ret); /* always succeed because bh_su is dirty */
+	raw_su->su_nblocks = cpu_to_le32(segbuf->sb_pseg_start -
+					 segbuf->sb_fseg_start);
+	nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum, bh_su);
+
+	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
+		ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
+						     &raw_su, &bh_su);
+		BUG_ON(ret); /* always succeed */
+		raw_su->su_nblocks = 0;
+		nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum,
+					       bh_su);
+	}
+}
+
+static void nilfs_segctor_truncate_segments(struct nilfs_sc_info *sci,
+					    struct nilfs_segment_buffer *last,
+					    struct inode *sufile)
+{
+	struct nilfs_segment_buffer *segbuf = last, *n;
+	int ret;
+
+	list_for_each_entry_safe_continue(segbuf, n, &sci->sc_segbufs,
+					  sb_list) {
+		list_del_init(&segbuf->sb_list);
+		sci->sc_segbuf_nblocks -= segbuf->sb_rest_blocks;
+		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
+		BUG_ON(ret);
+		nilfs_segbuf_free(segbuf);
+	}
+}
+
+
+static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
+				 struct the_nilfs *nilfs, int mode)
+{
+	struct nilfs_cstage prev_stage = sci->sc_stage;
+	int err, nadd = 1;
+
+	/* Collection retry loop */
+	for (;;) {
+		sci->sc_super_root = NULL;
+		sci->sc_nblk_this_inc = 0;
+		sci->sc_curseg = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
+
+		err = nilfs_segctor_reset_segment_buffer(sci);
+		if (unlikely(err))
+			goto failed;
+
+		err = nilfs_segctor_collect_blocks(sci, mode);
+		sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
+		if (!err)
+			break;
+
+		if (unlikely(err != -E2BIG))
+			goto failed;
+
+		/* The current segment is filled up */
+		if (mode != SC_LSEG_SR || sci->sc_stage.scnt < NILFS_ST_CPFILE)
+			break;
+
+		nilfs_segctor_cancel_free_segments(sci, nilfs->ns_sufile);
+		nilfs_segctor_clear_segment_buffers(sci);
+
+		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
+		if (unlikely(err))
+			return err;
+
+		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
+		sci->sc_stage = prev_stage;
+	}
+	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
+	return 0;
+
+ failed:
+	return err;
+}
+
+static void nilfs_list_replace_buffer(struct buffer_head *old_bh,
+				      struct buffer_head *new_bh)
+{
+	BUG_ON(!list_empty(&new_bh->b_assoc_buffers));
+
+	list_replace_init(&old_bh->b_assoc_buffers, &new_bh->b_assoc_buffers);
+	/* The caller must release old_bh */
+}
+
+static int
+nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
+				     struct nilfs_segment_buffer *segbuf,
+				     int mode)
+{
+	struct inode *inode = NULL;
+	sector_t blocknr;
+	unsigned long nfinfo = segbuf->sb_sum.nfinfo;
+	unsigned long nblocks = 0, ndatablk = 0;
+	struct nilfs_sc_operations *sc_op = NULL;
+	struct nilfs_segsum_pointer ssp;
+	struct nilfs_finfo *finfo = NULL;
+	union nilfs_binfo binfo;
+	struct buffer_head *bh, *bh_org;
+	ino_t ino = 0;
+	int err = 0;
+
+	if (!nfinfo)
+		goto out;
+
+	blocknr = segbuf->sb_pseg_start + segbuf->sb_sum.nsumblk;
+	ssp.bh = NILFS_SEGBUF_FIRST_BH(&segbuf->sb_segsum_buffers);
+	ssp.offset = sizeof(struct nilfs_segment_summary);
+
+	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
+		if (bh == sci->sc_super_root)
+			break;
+		if (!finfo) {
+			finfo =	nilfs_segctor_map_segsum_entry(
+				sci, &ssp, sizeof(*finfo));
+			ino = le64_to_cpu(finfo->fi_ino);
+			nblocks = le32_to_cpu(finfo->fi_nblocks);
+			ndatablk = le32_to_cpu(finfo->fi_ndatablk);
+
+			inode = NILFS_AS_I(bh->b_page->mapping);
+
+			if (mode == SC_LSEG_DSYNC)
+				sc_op = &nilfs_sc_dsync_ops;
+			else if (ino == NILFS_DAT_INO)
+				sc_op = &nilfs_sc_dat_ops;
+			else /* file blocks */
+				sc_op = &nilfs_sc_file_ops;
+		}
+		bh_org = bh;
+		get_bh(bh_org);
+		err = nilfs_bmap_assign(NILFS_I(inode)->i_bmap, &bh, blocknr,
+					&binfo);
+		if (bh != bh_org)
+			nilfs_list_replace_buffer(bh_org, bh);
+		brelse(bh_org);
+		if (unlikely(err))
+			goto failed_bmap;
+
+		if (ndatablk > 0)
+			sc_op->write_data_binfo(sci, &ssp, &binfo);
+		else
+			sc_op->write_node_binfo(sci, &ssp, &binfo);
+
+		blocknr++;
+		if (--nblocks == 0) {
+			finfo = NULL;
+			if (--nfinfo == 0)
+				break;
+		} else if (ndatablk > 0)
+			ndatablk--;
+	}
+ out:
+	return 0;
+
+ failed_bmap:
+	err = nilfs_handle_bmap_error(err, __func__, inode, sci->sc_super);
+	return err;
+}
+
+static int nilfs_segctor_assign(struct nilfs_sc_info *sci, int mode)
+{
+	struct nilfs_segment_buffer *segbuf;
+	int err;
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		err = nilfs_segctor_update_payload_blocknr(sci, segbuf, mode);
+		if (unlikely(err))
+			return err;
+		nilfs_segbuf_fill_in_segsum(segbuf);
+	}
+	return 0;
+}
+
+static int
+nilfs_copy_replace_page_buffers(struct page *page, struct list_head *out)
+{
+	struct page *clone_page;
+	struct buffer_head *bh, *head, *bh2;
+	void *kaddr;
+
+	bh = head = page_buffers(page);
+	clone_page = nilfs_alloc_buffer_page(bh->b_bdev, bh->b_size, 0);
+	if (unlikely(!clone_page))
+		return -ENOMEM;
+
+	bh2 = page_buffers(clone_page);
+	kaddr = kmap_atomic(page, KM_USER0);
+	do {
+		if (list_empty(&bh->b_assoc_buffers))
+			continue;
+		get_bh(bh2);
+		memcpy(bh2->b_data, kaddr + bh_offset(bh), bh2->b_size);
+		/* bh2->b_blocknr = bh->b_blocknr; */
+		list_replace(&bh->b_assoc_buffers, &bh2->b_assoc_buffers);
+		list_add_tail(&bh->b_assoc_buffers, out);
+	} while (bh = bh->b_this_page, bh2 = bh2->b_this_page, bh != head);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_page_add_to_lru(clone_page, 1);
+	nilfs_set_page_writeback(clone_page);
+	unlock_page(clone_page);
+	page_cache_release(clone_page);
+
+	return 0;
+}
+
+static int nilfs_test_page_to_be_frozen(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	if (!mapping || !mapping->host || S_ISDIR(mapping->host->i_mode))
+		return 0;
+
+	if (page_mapped(page)) {
+		ClearPageChecked(page);
+		return 1;
+	}
+	return PageChecked(page);
+}
+
+static int nilfs_begin_page_io(struct page *page, struct list_head *out)
+{
+	if (!page || PageWriteback(page))
+		/* For split b-tree node pages, this function may be called
+		   twice.  We ignore the 2nd or later calls by this check. */
+		return 0;
+
+	lock_page(page);
+	nilfs_clear_page_dirty_for_io(page);
+	nilfs_set_page_writeback(page);
+	unlock_page(page);
+
+	if (nilfs_test_page_to_be_frozen(page)) {
+		int err = nilfs_copy_replace_page_buffers(page, out);
+		if (unlikely(err))
+			return err;
+	}
+	return 0;
+}
+
+static int nilfs_segctor_prepare_write(struct nilfs_sc_info *sci,
+				       struct page **failed_page)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct page *bd_page = NULL, *fs_page = NULL;
+	struct list_head *list = &sci->sc_copied_buffers;
+	int err;
+
+	*failed_page = NULL;
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		struct buffer_head *bh;
+
+		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
+				    b_assoc_buffers) {
+			if (bh->b_page != bd_page) {
+				if (bd_page) {
+					lock_page(bd_page);
+					clear_page_dirty_for_io(bd_page);
+					set_page_writeback(bd_page);
+					unlock_page(bd_page);
+				}
+				bd_page = bh->b_page;
+			}
+		}
+
+		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
+				    b_assoc_buffers) {
+			if (bh == sci->sc_super_root) {
+				if (bh->b_page != bd_page) {
+					lock_page(bd_page);
+					clear_page_dirty_for_io(bd_page);
+					set_page_writeback(bd_page);
+					unlock_page(bd_page);
+					bd_page = bh->b_page;
+				}
+				break;
+			}
+			if (bh->b_page != fs_page) {
+				err = nilfs_begin_page_io(fs_page, list);
+				if (unlikely(err)) {
+					*failed_page = fs_page;
+					goto out;
+				}
+				fs_page = bh->b_page;
+			}
+		}
+	}
+	if (bd_page) {
+		lock_page(bd_page);
+		clear_page_dirty_for_io(bd_page);
+		set_page_writeback(bd_page);
+		unlock_page(bd_page);
+	}
+	err = nilfs_begin_page_io(fs_page, list);
+	if (unlikely(err))
+		*failed_page = fs_page;
+ out:
+	return err;
+}
+
+static int nilfs_segctor_write(struct nilfs_sc_info *sci,
+			       struct backing_dev_info *bdi)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct nilfs_write_info wi;
+	int err, res;
+
+	wi.sb = sci->sc_super;
+	wi.bh_sr = sci->sc_super_root;
+	wi.bdi = bdi;
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		nilfs_segbuf_prepare_write(segbuf, &wi);
+		err = nilfs_segbuf_write(segbuf, &wi);
+
+		res = nilfs_segbuf_wait(segbuf, &wi);
+		err = unlikely(err) ? : res;
+		if (unlikely(err))
+			return err;
+	}
+	return 0;
+}
+
+static int nilfs_page_has_uncleared_buffer(struct page *page)
+{
+	struct buffer_head *head, *bh;
+
+	head = bh = page_buffers(page);
+	do {
+		if (buffer_dirty(bh) && !list_empty(&bh->b_assoc_buffers))
+			return 1;
+		bh = bh->b_this_page;
+	} while (bh != head);
+	return 0;
+}
+
+static void __nilfs_end_page_io(struct page *page, int err)
+{
+	/* BUG_ON(err > 0); */
+	if (!err) {
+		if (!nilfs_page_buffers_clean(page))
+			nilfs_redirty_page(page);
+		ClearPageError(page);
+	} else {
+		nilfs_redirty_page(page);
+		SetPageError(page);
+	}
+	nilfs_end_page_writeback(page);
+}
+
+static void nilfs_end_page_io(struct page *page, int err)
+{
+	if (!page)
+		return;
+
+	if (buffer_nilfs_node(page_buffers(page)) &&
+	    nilfs_page_has_uncleared_buffer(page))
+		/* For b-tree node pages, this function may be called twice
+		   or more because they might be split in a segment.
+		   This check assures that cleanup has been done for all
+		   buffers in a split btnode page. */
+		return;
+
+	__nilfs_end_page_io(page, err);
+}
+
+static void nilfs_clear_copied_buffers(struct list_head *list, int err)
+{
+	struct buffer_head *bh, *head;
+	struct page *page;
+
+	while (!list_empty(list)) {
+		bh = list_entry(list->next, struct buffer_head,
+				b_assoc_buffers);
+		page = bh->b_page;
+		page_cache_get(page);
+		head = bh = page_buffers(page);
+		do {
+			if (!list_empty(&bh->b_assoc_buffers)) {
+				list_del_init(&bh->b_assoc_buffers);
+				if (!err) {
+					set_buffer_uptodate(bh);
+					clear_buffer_dirty(bh);
+					clear_buffer_nilfs_volatile(bh);
+				}
+				brelse(bh); /* for b_assoc_buffers */
+			}
+		} while ((bh = bh->b_this_page) != head);
+
+		__nilfs_end_page_io(page, err);
+		page_cache_release(page);
+	}
+}
+
+static void nilfs_segctor_abort_write(struct nilfs_sc_info *sci,
+				      struct page *failed_page, int err)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct page *bd_page = NULL, *fs_page = NULL;
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		struct buffer_head *bh;
+
+		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
+				    b_assoc_buffers) {
+			if (bh->b_page != bd_page) {
+				if (bd_page)
+					end_page_writeback(bd_page);
+				bd_page = bh->b_page;
+			}
+		}
+
+		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
+				    b_assoc_buffers) {
+			if (bh == sci->sc_super_root) {
+				if (bh->b_page != bd_page) {
+					end_page_writeback(bd_page);
+					bd_page = bh->b_page;
+				}
+				break;
+			}
+			if (bh->b_page != fs_page) {
+				nilfs_end_page_io(fs_page, err);
+				if (unlikely(fs_page == failed_page))
+					goto done;
+				fs_page = bh->b_page;
+			}
+		}
+	}
+	if (bd_page)
+		end_page_writeback(bd_page);
+
+	nilfs_end_page_io(fs_page, err);
+ done:
+	nilfs_clear_copied_buffers(&sci->sc_copied_buffers, err);
+}
+
+static void nilfs_set_next_segment(struct the_nilfs *nilfs,
+				   struct nilfs_segment_buffer *segbuf)
+{
+	nilfs->ns_segnum = segbuf->sb_segnum;
+	nilfs->ns_nextnum = segbuf->sb_nextnum;
+	nilfs->ns_pseg_offset = segbuf->sb_pseg_start - segbuf->sb_fseg_start
+		+ segbuf->sb_sum.nblocks;
+	nilfs->ns_seg_seq = segbuf->sb_sum.seg_seq;
+	nilfs->ns_ctime = segbuf->sb_sum.ctime;
+}
+
+static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct page *bd_page = NULL, *fs_page = NULL;
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int update_sr = (sci->sc_super_root != NULL);
+
+	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
+		struct buffer_head *bh;
+
+		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
+				    b_assoc_buffers) {
+			set_buffer_uptodate(bh);
+			clear_buffer_dirty(bh);
+			if (bh->b_page != bd_page) {
+				if (bd_page)
+					end_page_writeback(bd_page);
+				bd_page = bh->b_page;
+			}
+		}
+		/*
+		 * We assume that the buffers which belong to the same page
+		 * continue over the buffer list.
+		 * Under this assumption, the last BHs of pages is
+		 * identifiable by the discontinuity of bh->b_page
+		 * (page != fs_page).
+		 *
+		 * For B-tree node blocks, however, this assumption is not
+		 * guaranteed.  The cleanup code of B-tree node pages needs
+		 * special care.
+		 */
+		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
+				    b_assoc_buffers) {
+			set_buffer_uptodate(bh);
+			clear_buffer_dirty(bh);
+			clear_buffer_nilfs_volatile(bh);
+			if (bh == sci->sc_super_root) {
+				if (bh->b_page != bd_page) {
+					end_page_writeback(bd_page);
+					bd_page = bh->b_page;
+				}
+				break;
+			}
+			if (bh->b_page != fs_page) {
+				nilfs_end_page_io(fs_page, 0);
+				fs_page = bh->b_page;
+			}
+		}
+
+		if (!NILFS_SEG_SIMPLEX(&segbuf->sb_sum)) {
+			if (NILFS_SEG_LOGBGN(&segbuf->sb_sum)) {
+				set_bit(NILFS_SC_UNCLOSED, &sci->sc_flags);
+				sci->sc_lseg_stime = jiffies;
+			}
+			if (NILFS_SEG_LOGEND(&segbuf->sb_sum))
+				clear_bit(NILFS_SC_UNCLOSED, &sci->sc_flags);
+		}
+	}
+	/*
+	 * Since pages may continue over multiple segment buffers,
+	 * end of the last page must be checked outside of the loop.
+	 */
+	if (bd_page)
+		end_page_writeback(bd_page);
+
+	nilfs_end_page_io(fs_page, 0);
+
+	nilfs_clear_copied_buffers(&sci->sc_copied_buffers, 0);
+
+	nilfs_drop_collected_inodes(&sci->sc_dirty_files);
+
+	if (nilfs_doing_gc()) {
+		nilfs_drop_collected_inodes(&sci->sc_gc_inodes);
+		if (update_sr)
+			nilfs_commit_gcdat_inode(nilfs);
+	} else {
+		nilfs->ns_nongc_ctime = sci->sc_seg_ctime;
+		set_nilfs_cond_nongc_write(nilfs);
+		wake_up(&nilfs->ns_cleanerd_wq);
+	}
+
+	sci->sc_nblk_inc += sci->sc_nblk_this_inc;
+
+	segbuf = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
+	nilfs_set_next_segment(nilfs, segbuf);
+
+	if (update_sr) {
+		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
+				       segbuf->sb_sum.seg_seq, nilfs->ns_cno);
+
+		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
+		set_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
+	} else
+		clear_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
+}
+
+static int nilfs_segctor_check_in_files(struct nilfs_sc_info *sci,
+					struct nilfs_sb_info *sbi)
+{
+	struct nilfs_inode_info *ii, *n;
+	__u64 cno = sbi->s_nilfs->ns_cno;
+
+	spin_lock(&sbi->s_inode_lock);
+ retry:
+	list_for_each_entry_safe(ii, n, &sbi->s_dirty_files, i_dirty) {
+		if (!ii->i_bh) {
+			struct buffer_head *ibh;
+			int err;
+
+			spin_unlock(&sbi->s_inode_lock);
+			err = nilfs_ifile_get_inode_block(
+				sbi->s_ifile, ii->vfs_inode.i_ino, &ibh);
+			if (unlikely(err)) {
+				nilfs_warning(sbi->s_super, __func__,
+					      "failed to get inode block.\n");
+				return err;
+			}
+			nilfs_mdt_mark_buffer_dirty(ibh);
+			nilfs_mdt_mark_dirty(sbi->s_ifile);
+			spin_lock(&sbi->s_inode_lock);
+			if (likely(!ii->i_bh))
+				ii->i_bh = ibh;
+			else
+				brelse(ibh);
+			goto retry;
+		}
+		ii->i_cno = cno;
+
+		clear_bit(NILFS_I_QUEUED, &ii->i_state);
+		set_bit(NILFS_I_BUSY, &ii->i_state);
+		list_del(&ii->i_dirty);
+		list_add_tail(&ii->i_dirty, &sci->sc_dirty_files);
+	}
+	spin_unlock(&sbi->s_inode_lock);
+
+	NILFS_I(sbi->s_ifile)->i_cno = cno;
+
+	return 0;
+}
+
+static void nilfs_segctor_check_out_files(struct nilfs_sc_info *sci,
+					  struct nilfs_sb_info *sbi)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+	struct nilfs_inode_info *ii, *n;
+	__u64 cno = sbi->s_nilfs->ns_cno;
+
+	spin_lock(&sbi->s_inode_lock);
+	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
+		if (!test_and_clear_bit(NILFS_I_UPDATED, &ii->i_state) ||
+		    test_bit(NILFS_I_DIRTY, &ii->i_state)) {
+			/* The current checkpoint number (=nilfs->ns_cno) is
+			   changed between check-in and check-out only if the
+			   super root is written out.  So, we can update i_cno
+			   for the inodes that remain in the dirty list. */
+			ii->i_cno = cno;
+			continue;
+		}
+		clear_bit(NILFS_I_BUSY, &ii->i_state);
+		brelse(ii->i_bh);
+		ii->i_bh = NULL;
+		list_del(&ii->i_dirty);
+		list_add_tail(&ii->i_dirty, &ti->ti_garbage);
+	}
+	spin_unlock(&sbi->s_inode_lock);
+}
+
+/*
+ * Nasty routines to manipulate active flags on sufile.
+ * These would be removed in a future release.
+ */
+static void nilfs_segctor_reactivate_segments(struct nilfs_sc_info *sci,
+					      struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_buffer *segbuf, *last;
+	struct nilfs_segment_entry *ent, *n;
+	struct inode *sufile = nilfs->ns_sufile;
+	struct list_head *head;
+
+	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
+	nilfs_for_each_segbuf_before(segbuf, last, &sci->sc_segbufs) {
+		ent = segbuf->sb_segent;
+		if (!ent)
+			break; /* ignore unmapped segments (should check it?)*/
+		nilfs_segment_usage_set_active(ent->raw_su);
+		nilfs_close_segment_entry(ent, sufile);
+	}
+
+	head = &sci->sc_active_segments;
+	list_for_each_entry_safe(ent, n, head, list) {
+		nilfs_segment_usage_set_active(ent->raw_su);
+		nilfs_close_segment_entry(ent, sufile);
+	}
+
+	down_write(&nilfs->ns_sem);
+	head = &nilfs->ns_used_segments;
+	list_for_each_entry(ent, head, list) {
+		nilfs_segment_usage_set_volatile_active(ent->raw_su);
+	}
+	up_write(&nilfs->ns_sem);
+}
+
+static int nilfs_segctor_deactivate_segments(struct nilfs_sc_info *sci,
+					     struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_buffer *segbuf, *last;
+	struct nilfs_segment_entry *ent;
+	struct inode *sufile = nilfs->ns_sufile;
+	struct list_head *head;
+	int err;
+
+	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
+	nilfs_for_each_segbuf_before(segbuf, last, &sci->sc_segbufs) {
+		/*
+		 * Deactivate ongoing full segments.  The last segment is kept
+		 * active because it is a start point of recovery, and is not
+		 * relocatable until the super block points to a newer
+		 * checkpoint.
+		 */
+		ent = segbuf->sb_segent;
+		if (!ent)
+			break; /* ignore unmapped segments (should check it?)*/
+		err = nilfs_open_segment_entry(ent, sufile);
+		if (unlikely(err))
+			goto failed;
+		nilfs_segment_usage_clear_active(ent->raw_su);
+		BUG_ON(!buffer_dirty(ent->bh_su));
+	}
+
+	head = &sci->sc_active_segments;
+	list_for_each_entry(ent, head, list) {
+		err = nilfs_open_segment_entry(ent, sufile);
+		if (unlikely(err))
+			goto failed;
+		nilfs_segment_usage_clear_active(ent->raw_su);
+		BUG_ON(!buffer_dirty(ent->bh_su));
+	}
+
+	down_write(&nilfs->ns_sem);
+	head = &nilfs->ns_used_segments;
+	list_for_each_entry(ent, head, list) {
+		/* clear volatile active for segments of older generations */
+		nilfs_segment_usage_clear_volatile_active(ent->raw_su);
+	}
+	up_write(&nilfs->ns_sem);
+	return 0;
+
+ failed:
+	nilfs_segctor_reactivate_segments(sci, nilfs);
+	return err;
+}
+
+static void nilfs_segctor_bead_completed_segments(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segment_buffer *segbuf, *last;
+	struct nilfs_segment_entry *ent;
+
+	/* move each segbuf->sb_segent to the list of used active segments */
+	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
+	nilfs_for_each_segbuf_before(segbuf, last, &sci->sc_segbufs) {
+		ent = segbuf->sb_segent;
+		if (!ent)
+			break; /* ignore unmapped segments (should check it?)*/
+		list_add_tail(&ent->list, &sci->sc_active_segments);
+		segbuf->sb_segent = NULL;
+	}
+}
+
+static void
+__nilfs_segctor_commit_deactivate_segments(struct nilfs_sc_info *sci,
+					   struct the_nilfs *nilfs)
+
+{
+	struct nilfs_segment_entry *ent;
+
+	list_splice_init(&sci->sc_active_segments,
+			 nilfs->ns_used_segments.prev);
+
+	list_for_each_entry(ent, &nilfs->ns_used_segments, list) {
+		nilfs_segment_usage_set_volatile_active(ent->raw_su);
+		/* These segments are kept open */
+	}
+}
+
+/*
+ * Main procedure of segment constructor
+ */
+static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct page *failed_page;
+	int err, has_sr = 0;
+
+	sci->sc_stage.scnt = NILFS_ST_INIT;
+
+	err = nilfs_segctor_check_in_files(sci, sbi);
+	if (unlikely(err))
+		goto out;
+
+	if (nilfs_test_metadata_dirty(sbi))
+		set_bit(NILFS_SC_DIRTY, &sci->sc_flags);
+
+	if (nilfs_segctor_clean(sci))
+		goto out;
+
+	do {
+		sci->sc_stage.flags &= ~NILFS_CF_HISTORY_MASK;
+
+		err = nilfs_segctor_begin_construction(sci, nilfs);
+		if (unlikely(err))
+			goto out;
+
+		/* Update time stamp */
+		sci->sc_seg_ctime = get_seconds();
+
+		err = nilfs_segctor_collect(sci, nilfs, mode);
+		if (unlikely(err))
+			goto failed;
+
+		has_sr = (sci->sc_super_root != NULL);
+
+		/* Avoid empty segment */
+		if (sci->sc_stage.scnt == NILFS_ST_DONE &&
+		    NILFS_SEG_EMPTY(&sci->sc_curseg->sb_sum)) {
+			BUG_ON(mode == SC_LSEG_SR);
+			nilfs_segctor_end_construction(sci, nilfs, 1);
+			goto out;
+		}
+
+		err = nilfs_segctor_assign(sci, mode);
+		if (unlikely(err))
+			goto failed;
+
+		if (has_sr) {
+			err = nilfs_segctor_deactivate_segments(sci, nilfs);
+			if (unlikely(err))
+				goto failed;
+		}
+		if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
+			nilfs_segctor_fill_in_file_bmap(sci, sbi->s_ifile);
+
+		if (has_sr) {
+			err = nilfs_segctor_fill_in_checkpoint(sci);
+			if (unlikely(err))
+				goto failed_to_make_up;
+
+			nilfs_segctor_fill_in_super_root(sci, nilfs);
+		}
+		nilfs_segctor_update_segusage(sci, nilfs->ns_sufile);
+
+		/* Write partial segments */
+		err = nilfs_segctor_prepare_write(sci, &failed_page);
+		if (unlikely(err))
+			goto failed_to_write;
+
+		nilfs_segctor_fill_in_checksums(sci, nilfs->ns_crc_seed);
+
+		err = nilfs_segctor_write(sci, nilfs->ns_bdi);
+		if (unlikely(err))
+			goto failed_to_write;
+
+		nilfs_segctor_complete_write(sci);
+
+		/* Commit segments */
+		nilfs_segctor_bead_completed_segments(sci);
+		if (has_sr) {
+			down_write(&nilfs->ns_sem);
+			nilfs_update_last_segment(sbi, 1);
+			__nilfs_segctor_commit_deactivate_segments(sci, nilfs);
+			up_write(&nilfs->ns_sem);
+			nilfs_segctor_commit_free_segments(sci);
+			nilfs_segctor_clear_metadata_dirty(sci);
+		}
+
+		nilfs_segctor_end_construction(sci, nilfs, 0);
+
+	} while (sci->sc_stage.scnt != NILFS_ST_DONE);
+
+	/* Clearing sketch data */
+	if (has_sr && sci->sc_sketch_inode) {
+		if (i_size_read(sci->sc_sketch_inode) == 0)
+			clear_bit(NILFS_I_DIRTY,
+				  &NILFS_I(sci->sc_sketch_inode)->i_state);
+		i_size_write(sci->sc_sketch_inode, 0);
+	}
+ out:
+	nilfs_segctor_destroy_segment_buffers(sci);
+	nilfs_segctor_check_out_files(sci, sbi);
+	return err;
+
+ failed_to_write:
+	nilfs_segctor_abort_write(sci, failed_page, err);
+	nilfs_segctor_cancel_segusage(sci, nilfs->ns_sufile);
+
+ failed_to_make_up:
+	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
+		nilfs_redirty_inodes(&sci->sc_dirty_files);
+	if (has_sr)
+		nilfs_segctor_reactivate_segments(sci, nilfs);
+
+ failed:
+	if (nilfs_doing_gc())
+		nilfs_redirty_inodes(&sci->sc_gc_inodes);
+	nilfs_segctor_end_construction(sci, nilfs, err);
+	goto out;
+}
+
+/**
+ * nilfs_secgtor_start_timer - set timer of background write
+ * @sci: nilfs_sc_info
+ *
+ * If the timer has already been set, it ignores the new request.
+ * This function MUST be called within a section locking the segment
+ * semaphore.
+ */
+static void nilfs_segctor_start_timer(struct nilfs_sc_info *sci)
+{
+	spin_lock(&sci->sc_state_lock);
+	if (sci->sc_timer && !(sci->sc_state & NILFS_SEGCTOR_COMMIT)) {
+		sci->sc_timer->expires = jiffies + sci->sc_interval;
+		add_timer(sci->sc_timer);
+		sci->sc_state |= NILFS_SEGCTOR_COMMIT;
+	}
+	spin_unlock(&sci->sc_state_lock);
+}
+
+static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
+{
+	spin_lock(&sci->sc_state_lock);
+	if (!(sci->sc_flush_request & (1 << bn))) {
+		unsigned long prev_req = sci->sc_flush_request;
+
+		sci->sc_flush_request |= (1 << bn);
+		if (!prev_req)
+			wake_up(&sci->sc_wait_daemon);
+	}
+	spin_unlock(&sci->sc_state_lock);
+}
+
+/**
+ * nilfs_flush_segment - trigger a segment construction for resource control
+ * @sb: super block
+ * @ino: inode number of the file to be flushed out.
+ */
+void nilfs_flush_segment(struct super_block *sb, ino_t ino)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+
+	if (!sci || nilfs_doing_construction())
+		return;
+	nilfs_segctor_do_flush(sci, NILFS_MDT_INODE(sb, ino) ? ino : 0);
+					/* assign bit 0 to data files */
+}
+
+int nilfs_segctor_add_segments_to_be_freed(struct nilfs_sc_info *sci,
+					   __u64 *segnum, size_t nsegs)
+{
+	struct nilfs_segment_entry *ent;
+	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct inode *sufile = nilfs->ns_sufile;
+	LIST_HEAD(list);
+	__u64 *pnum;
+	const char *flag_name;
+	size_t i;
+	int err, err2 = 0;
+
+	for (pnum = segnum, i = 0; i < nsegs; pnum++, i++) {
+		ent = nilfs_alloc_segment_entry(*pnum);
+		if (unlikely(!ent)) {
+			err = -ENOMEM;
+			goto failed;
+		}
+		list_add_tail(&ent->list, &list);
+
+		err = nilfs_open_segment_entry(ent, sufile);
+		if (unlikely(err))
+			goto failed;
+
+		if (unlikely(le32_to_cpu(ent->raw_su->su_flags) !=
+			     (1UL << NILFS_SEGMENT_USAGE_DIRTY))) {
+			if (nilfs_segment_usage_clean(ent->raw_su))
+				flag_name = "clean";
+			else if (nilfs_segment_usage_active(ent->raw_su))
+				flag_name = "active";
+			else if (nilfs_segment_usage_volatile_active(
+					 ent->raw_su))
+				flag_name = "volatile active";
+			else if (!nilfs_segment_usage_dirty(ent->raw_su))
+				flag_name = "non-dirty";
+			else
+				flag_name = "erroneous";
+
+			printk(KERN_ERR
+			       "NILFS: %s segment is requested to be cleaned "
+			       "(segnum=%llu)\n",
+			       flag_name, (unsigned long long)ent->segnum);
+			err2 = -EINVAL;
+		}
+		nilfs_close_segment_entry(ent, sufile);
+	}
+	if (unlikely(err2)) {
+		err = err2;
+		goto failed;
+	}
+	list_splice(&list, sci->sc_cleaning_segments.prev);
+	return 0;
+
+ failed:
+	nilfs_dispose_segment_list(&list);
+	return err;
+}
+
+void nilfs_segctor_clear_segments_to_be_freed(struct nilfs_sc_info *sci)
+{
+	nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
+}
+
+struct nilfs_segctor_wait_request {
+	wait_queue_t	wq;
+	__u32		seq;
+	int		err;
+	atomic_t	done;
+};
+
+static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segctor_wait_request wait_req;
+	int err = 0;
+
+	spin_lock(&sci->sc_state_lock);
+	init_wait(&wait_req.wq);
+	wait_req.err = 0;
+	atomic_set(&wait_req.done, 0);
+	wait_req.seq = ++sci->sc_seq_request;
+	spin_unlock(&sci->sc_state_lock);
+
+	init_waitqueue_entry(&wait_req.wq, current);
+	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
+	set_current_state(TASK_INTERRUPTIBLE);
+	wake_up(&sci->sc_wait_daemon);
+
+	for (;;) {
+		if (atomic_read(&wait_req.done)) {
+			err = wait_req.err;
+			break;
+		}
+		if (!signal_pending(current)) {
+			schedule();
+			continue;
+		}
+		err = -ERESTARTSYS;
+		break;
+	}
+	finish_wait(&sci->sc_wait_request, &wait_req.wq);
+	return err;
+}
+
+static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
+{
+	struct nilfs_segctor_wait_request *wrq, *n;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
+	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.task_list,
+				 wq.task_list) {
+		if (!atomic_read(&wrq->done) &&
+		    nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq)) {
+			wrq->err = err;
+			atomic_set(&wrq->done, 1);
+		}
+		if (atomic_read(&wrq->done)) {
+			wrq->wq.func(&wrq->wq,
+				     TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
+				     0, NULL);
+		}
+	}
+	spin_unlock_irqrestore(&sci->sc_wait_request.lock, flags);
+}
+
+/**
+ * nilfs_construct_segment - construct a logical segment
+ * @sb: super block
+ *
+ * Return Value: On success, 0 is retured. On errors, one of the following
+ * negative error code is returned.
+ *
+ * %-EROFS - Read only filesystem.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOSPC - No space left on device (only in a panic state).
+ *
+ * %-ERESTARTSYS - Interrupted.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_construct_segment(struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct nilfs_transaction_info *ti;
+	int err;
+
+	if (!sci)
+		return -EROFS;
+
+	/* A call inside transactions causes a deadlock. */
+	BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
+
+	err = nilfs_segctor_sync(sci);
+	return err;
+}
+
+/**
+ * nilfs_construct_dsync_segment - construct a data-only logical segment
+ * @sb: super block
+ * @inode: the inode whose data blocks should be written out
+ *
+ * Return Value: On success, 0 is retured. On errors, one of the following
+ * negative error code is returned.
+ *
+ * %-EROFS - Read only filesystem.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOSPC - No space left on device (only in a panic state).
+ *
+ * %-ERESTARTSYS - Interrupted.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_construct_dsync_segment(struct super_block *sb,
+				  struct inode *inode)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct nilfs_inode_info *ii;
+	struct nilfs_transaction_info ti;
+	int err = 0;
+
+	if (!sci)
+		return -EROFS;
+
+	nilfs_transaction_lock(sbi, &ti, 0);
+
+	ii = NILFS_I(inode);
+	if (test_bit(NILFS_I_INODE_DIRTY, &ii->i_state) ||
+	    nilfs_test_opt(sbi, STRICT_ORDER) ||
+	    test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags) ||
+	    nilfs_discontinued(sbi->s_nilfs)) {
+		nilfs_transaction_unlock(sbi);
+		err = nilfs_segctor_sync(sci);
+		return err;
+	}
+
+	spin_lock(&sbi->s_inode_lock);
+	if (!test_bit(NILFS_I_QUEUED, &ii->i_state) &&
+	    !test_bit(NILFS_I_BUSY, &ii->i_state)) {
+		spin_unlock(&sbi->s_inode_lock);
+		nilfs_transaction_unlock(sbi);
+		return 0;
+	}
+	spin_unlock(&sbi->s_inode_lock);
+	sci->sc_stage.dirty_file_ptr = ii;
+
+	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
+
+	nilfs_transaction_unlock(sbi);
+	return err;
+}
+
+struct nilfs_segctor_req {
+	int mode;
+	__u32 seq_accepted;
+	int sc_err;  /* construction failure */
+	int sb_err;  /* super block writeback failure */
+};
+
+#define FLUSH_FILE_BIT	(0x1) /* data file only */
+#define FLUSH_DAT_BIT	(1 << NILFS_DAT_INO) /* DAT only */
+
+static void nilfs_segctor_accept(struct nilfs_sc_info *sci,
+				 struct nilfs_segctor_req *req)
+{
+	BUG_ON(!sci);
+
+	req->sc_err = req->sb_err = 0;
+	spin_lock(&sci->sc_state_lock);
+	req->seq_accepted = sci->sc_seq_request;
+	spin_unlock(&sci->sc_state_lock);
+
+	if (sci->sc_timer)
+		del_timer_sync(sci->sc_timer);
+}
+
+static void nilfs_segctor_notify(struct nilfs_sc_info *sci,
+				 struct nilfs_segctor_req *req)
+{
+	/* Clear requests (even when the construction failed) */
+	spin_lock(&sci->sc_state_lock);
+
+	sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
+
+	if (req->mode == SC_LSEG_SR) {
+		sci->sc_seq_done = req->seq_accepted;
+		nilfs_segctor_wakeup(sci, req->sc_err ? : req->sb_err);
+		sci->sc_flush_request = 0;
+	} else if (req->mode == SC_FLUSH_FILE)
+		sci->sc_flush_request &= ~FLUSH_FILE_BIT;
+	else if (req->mode == SC_FLUSH_DAT)
+		sci->sc_flush_request &= ~FLUSH_DAT_BIT;
+
+	spin_unlock(&sci->sc_state_lock);
+}
+
+static int nilfs_segctor_construct(struct nilfs_sc_info *sci,
+				   struct nilfs_segctor_req *req)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int err = 0;
+
+	if (nilfs_discontinued(nilfs))
+		req->mode = SC_LSEG_SR;
+	if (!nilfs_segctor_confirm(sci)) {
+		err = nilfs_segctor_do_construct(sci, req->mode);
+		req->sc_err = err;
+	}
+	if (likely(!err)) {
+		if (req->mode != SC_FLUSH_DAT)
+			atomic_set(&nilfs->ns_ndirtyblks, 0);
+		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
+		    nilfs_discontinued(nilfs)) {
+			down_write(&nilfs->ns_sem);
+			req->sb_err = nilfs_commit_super(sbi);
+			up_write(&nilfs->ns_sem);
+		}
+	}
+	return err;
+}
+
+static void nilfs_construction_timeout(unsigned long data)
+{
+	struct task_struct *p = (struct task_struct *)data;
+	wake_up_process(p);
+}
+
+static void
+nilfs_dispose_gcinode_list(struct the_nilfs *nilfs, struct list_head *head)
+{
+	struct nilfs_inode_info *ii, *n;
+	struct nilfs_inode_info *ivec[SC_N_INODEVEC], **pii;
+	unsigned nv = 0;
+
+	while (!list_empty(head)) {
+		spin_lock(&nilfs->ns_gc_inode_lock); /* XXX: to be removed? */
+		list_for_each_entry_safe(ii, n, head, i_dirty) {
+			if (!test_and_clear_bit(NILFS_I_UPDATED, &ii->i_state))
+				continue;
+
+			hlist_del_init(&ii->vfs_inode.i_hash);
+			list_del_init(&ii->i_dirty);
+			ivec[nv++] = ii;
+			if (nv == SC_N_INODEVEC)
+				break;
+		}
+		spin_unlock(&nilfs->ns_gc_inode_lock);
+
+		for (pii = ivec; nv > 0; pii++, nv--)
+			nilfs_clear_gcinode(&(*pii)->vfs_inode);
+	}
+}
+
+int nilfs_clean_segments(struct super_block *sb, unsigned long arg)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_sc_info *sci = NILFS_SC(sbi);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_transaction_info ti;
+	struct nilfs_segctor_req req = { .mode = SC_LSEG_SR };
+	int err;
+
+	if (unlikely(!sci))
+		return -EROFS;
+
+	nilfs_transaction_lock(sbi, &ti, 1);
+
+	err = nilfs_init_gcdat_inode(nilfs);
+	if (unlikely(err))
+		goto out_unlock;
+	err = nilfs_ioctl_prepare_clean_segments(nilfs, arg);
+	if (unlikely(err))
+		goto out_unlock;
+
+	spin_lock(&nilfs->ns_gc_inode_lock); /* XXX: shouled be removed? */
+	list_splice_init(&nilfs->ns_gc_inodes, sci->sc_gc_inodes.prev);
+	spin_unlock(&nilfs->ns_gc_inode_lock);
+
+	for (;;) {
+		nilfs_segctor_accept(sci, &req);
+		err = nilfs_segctor_construct(sci, &req);
+		nilfs_dispose_gcinode_list(nilfs, &sci->sc_gc_inodes);
+		nilfs_segctor_notify(sci, &req);
+
+		if (likely(!err))
+			break;
+
+		nilfs_warning(sb, __func__,
+			      "segment construction failed. (err=%d)", err);
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(sci->sc_interval);
+	}
+
+ out_unlock:
+	nilfs_clear_gcdat_inode(nilfs);
+	nilfs_transaction_unlock(sbi);
+	return err;
+}
+
+static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct nilfs_transaction_info ti;
+	struct nilfs_segctor_req req = { .mode = mode };
+
+	nilfs_transaction_lock(sbi, &ti, 0);
+
+	nilfs_segctor_accept(sci, &req);
+	nilfs_segctor_construct(sci, &req);
+	nilfs_segctor_notify(sci, &req);
+
+	/*
+	 * Unclosed segment should be retried.  We do this using sc_timer.
+	 * Timeout of sc_timer will invoke complete construction which leads
+	 * to close the current logical segment.
+	 */
+	if (test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags))
+		nilfs_segctor_start_timer(sci);
+
+	nilfs_transaction_unlock(sbi);
+}
+
+static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
+{
+	int mode = 0;
+	int err;
+
+	spin_lock(&sci->sc_state_lock);
+	mode = (sci->sc_flush_request & FLUSH_DAT_BIT) ?
+		SC_FLUSH_DAT : SC_FLUSH_FILE;
+	spin_unlock(&sci->sc_state_lock);
+
+	if (mode) {
+		err = nilfs_segctor_do_construct(sci, mode);
+
+		spin_lock(&sci->sc_state_lock);
+		sci->sc_flush_request &= (mode == SC_FLUSH_FILE) ?
+			~FLUSH_FILE_BIT : ~FLUSH_DAT_BIT;
+		spin_unlock(&sci->sc_state_lock);
+	}
+	clear_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
+}
+
+static int nilfs_segctor_flush_mode(struct nilfs_sc_info *sci)
+{
+	if (!test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags) ||
+	    time_before(jiffies, sci->sc_lseg_stime + sci->sc_mjcp_freq)) {
+		if (!(sci->sc_flush_request & ~FLUSH_FILE_BIT))
+			return SC_FLUSH_FILE;
+		else if (!(sci->sc_flush_request & ~FLUSH_DAT_BIT))
+			return SC_FLUSH_DAT;
+	}
+	return SC_LSEG_SR;
+}
+
+/**
+ * nilfs_segctor_thread - main loop of the segment constructor thread.
+ * @arg: pointer to a struct nilfs_sc_info.
+ *
+ * nilfs_segctor_thread() initializes a timer and serves as a daemon
+ * to execute segment constructions.
+ */
+static int nilfs_segctor_thread(void *arg)
+{
+	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
+	struct timer_list timer;
+	int timeout = 0;
+
+	init_timer(&timer);
+	timer.data = (unsigned long)current;
+	timer.function = nilfs_construction_timeout;
+	sci->sc_timer = &timer;
+
+	/* start sync. */
+	sci->sc_task = current;
+	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_start_thread() */
+	printk(KERN_INFO
+	       "segctord starting. Construction interval = %lu seconds, "
+	       "CP frequency < %lu seconds\n",
+	       sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
+
+	spin_lock(&sci->sc_state_lock);
+ loop:
+	for (;;) {
+		int mode;
+
+		if (sci->sc_state & NILFS_SEGCTOR_QUIT)
+			goto end_thread;
+
+		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
+			mode = SC_LSEG_SR;
+		else if (!sci->sc_flush_request)
+			break;
+		else
+			mode = nilfs_segctor_flush_mode(sci);
+
+		spin_unlock(&sci->sc_state_lock);
+		nilfs_segctor_thread_construct(sci, mode);
+		spin_lock(&sci->sc_state_lock);
+		timeout = 0;
+	}
+
+
+	if (freezing(current)) {
+		spin_unlock(&sci->sc_state_lock);
+		refrigerator();
+		spin_lock(&sci->sc_state_lock);
+	} else {
+		DEFINE_WAIT(wait);
+		int should_sleep = 1;
+
+		prepare_to_wait(&sci->sc_wait_daemon, &wait,
+				TASK_INTERRUPTIBLE);
+
+		if (sci->sc_seq_request != sci->sc_seq_done)
+			should_sleep = 0;
+		else if (sci->sc_flush_request)
+			should_sleep = 0;
+		else if (sci->sc_state & NILFS_SEGCTOR_COMMIT)
+			should_sleep = time_before(jiffies,
+						   sci->sc_timer->expires);
+
+		if (should_sleep) {
+			spin_unlock(&sci->sc_state_lock);
+			schedule();
+			spin_lock(&sci->sc_state_lock);
+		}
+		finish_wait(&sci->sc_wait_daemon, &wait);
+		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+			   time_after_eq(jiffies, sci->sc_timer->expires));
+	}
+	goto loop;
+
+ end_thread:
+	spin_unlock(&sci->sc_state_lock);
+	del_timer_sync(sci->sc_timer);
+	sci->sc_timer = NULL;
+
+	/* end sync. */
+	sci->sc_task = NULL;
+	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
+	return 0;
+}
+
+static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
+{
+	struct task_struct *t;
+
+	t = kthread_run(nilfs_segctor_thread, sci, "segctord");
+	if (IS_ERR(t)) {
+		int err = PTR_ERR(t);
+
+		printk(KERN_ERR "NILFS: error %d creating segctord thread\n",
+		       err);
+		return err;
+	}
+	wait_event(sci->sc_wait_task, sci->sc_task != NULL);
+	return 0;
+}
+
+static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
+{
+	sci->sc_state |= NILFS_SEGCTOR_QUIT;
+
+	while (sci->sc_task) {
+		wake_up(&sci->sc_wait_daemon);
+		spin_unlock(&sci->sc_state_lock);
+		wait_event(sci->sc_wait_task, sci->sc_task == NULL);
+		spin_lock(&sci->sc_state_lock);
+	}
+}
+
+static int nilfs_segctor_init(struct nilfs_sc_info *sci,
+			      struct nilfs_recovery_info *ri)
+{
+	int err;
+	struct inode *inode = nilfs_iget(sci->sc_super, NILFS_SKETCH_INO);
+
+	sci->sc_sketch_inode = IS_ERR(inode) ? NULL : inode;
+	if (sci->sc_sketch_inode)
+		i_size_write(sci->sc_sketch_inode, 0);
+
+	sci->sc_seq_done = sci->sc_seq_request;
+	if (ri)
+		list_splice_init(&ri->ri_used_segments,
+				 sci->sc_active_segments.prev);
+
+	err = nilfs_segctor_start_thread(sci);
+	if (err) {
+		if (ri)
+			list_splice_init(&sci->sc_active_segments,
+					 ri->ri_used_segments.prev);
+		if (sci->sc_sketch_inode) {
+			iput(sci->sc_sketch_inode);
+			sci->sc_sketch_inode = NULL;
+		}
+	}
+	return err;
+}
+
+/*
+ * Setup & clean-up functions
+ */
+static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi)
+{
+	struct nilfs_sc_info *sci;
+
+	sci = kzalloc(sizeof(*sci), GFP_KERNEL);
+	if (!sci)
+		return NULL;
+
+	sci->sc_sbi = sbi;
+	sci->sc_super = sbi->s_super;
+
+	init_waitqueue_head(&sci->sc_wait_request);
+	init_waitqueue_head(&sci->sc_wait_daemon);
+	init_waitqueue_head(&sci->sc_wait_task);
+	spin_lock_init(&sci->sc_state_lock);
+	INIT_LIST_HEAD(&sci->sc_dirty_files);
+	INIT_LIST_HEAD(&sci->sc_segbufs);
+	INIT_LIST_HEAD(&sci->sc_gc_inodes);
+	INIT_LIST_HEAD(&sci->sc_active_segments);
+	INIT_LIST_HEAD(&sci->sc_cleaning_segments);
+	INIT_LIST_HEAD(&sci->sc_copied_buffers);
+
+	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
+	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
+	sci->sc_watermark = NILFS_SC_DEFAULT_WATERMARK;
+
+	if (sbi->s_interval)
+		sci->sc_interval = sbi->s_interval;
+	if (sbi->s_watermark)
+		sci->sc_watermark = sbi->s_watermark;
+	return sci;
+}
+
+static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
+{
+	int ret, retrycount = NILFS_SC_CLEANUP_RETRY;
+
+	/* The segctord thread was stopped and its timer was removed.
+	   But some tasks remain. */
+	do {
+		struct nilfs_sb_info *sbi = sci->sc_sbi;
+		struct nilfs_transaction_info ti;
+		struct nilfs_segctor_req req = { .mode = SC_LSEG_SR };
+
+		nilfs_transaction_lock(sbi, &ti, 0);
+		nilfs_segctor_accept(sci, &req);
+		ret = nilfs_segctor_construct(sci, &req);
+		nilfs_segctor_notify(sci, &req);
+		nilfs_transaction_unlock(sbi);
+
+	} while (ret && retrycount-- > 0);
+}
+
+/**
+ * nilfs_segctor_destroy - destroy the segment constructor.
+ * @sci: nilfs_sc_info
+ *
+ * nilfs_segctor_destroy() kills the segctord thread and frees
+ * the nilfs_sc_info struct.
+ * Caller must hold the segment semaphore.
+ */
+static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
+{
+	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	int flag;
+
+	up_write(&sbi->s_nilfs->ns_segctor_sem);
+
+	spin_lock(&sci->sc_state_lock);
+	nilfs_segctor_kill_thread(sci);
+	flag = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) || sci->sc_flush_request
+		|| sci->sc_seq_request != sci->sc_seq_done);
+	spin_unlock(&sci->sc_state_lock);
+
+	if (flag || nilfs_segctor_confirm(sci))
+		nilfs_segctor_write_out(sci);
+
+	BUG_ON(!list_empty(&sci->sc_copied_buffers));
+
+	if (!list_empty(&sci->sc_dirty_files)) {
+		nilfs_warning(sbi->s_super, __func__,
+			      "dirty file(s) after the final construction\n");
+		nilfs_dispose_list(sbi, &sci->sc_dirty_files, 1);
+	}
+	if (!list_empty(&sci->sc_active_segments))
+		nilfs_dispose_segment_list(&sci->sc_active_segments);
+
+	if (!list_empty(&sci->sc_cleaning_segments))
+		nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
+
+	BUG_ON(!list_empty(&sci->sc_segbufs));
+
+	if (sci->sc_sketch_inode) {
+		iput(sci->sc_sketch_inode);
+		sci->sc_sketch_inode = NULL;
+	}
+	down_write(&sbi->s_nilfs->ns_segctor_sem);
+
+	kfree(sci);
+}
+
+/**
+ * nilfs_attach_segment_constructor - attach a segment constructor
+ * @sbi: nilfs_sb_info
+ * @ri: nilfs_recovery_info
+ *
+ * nilfs_attach_segment_constructor() allocates a struct nilfs_sc_info,
+ * initilizes it, and starts the segment constructor.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
+				     struct nilfs_recovery_info *ri)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int err;
+
+	/* Each field of nilfs_segctor is cleared through the initialization
+	   of super-block info */
+	sbi->s_sc_info = nilfs_segctor_new(sbi);
+	if (!sbi->s_sc_info)
+		return -ENOMEM;
+
+	nilfs_attach_writer(nilfs, sbi);
+	err = nilfs_segctor_init(NILFS_SC(sbi), ri);
+	if (err) {
+		nilfs_detach_writer(nilfs, sbi);
+		kfree(sbi->s_sc_info);
+		sbi->s_sc_info = NULL;
+	}
+	return err;
+}
+
+/**
+ * nilfs_detach_segment_constructor - destroy the segment constructor
+ * @sbi: nilfs_sb_info
+ *
+ * nilfs_detach_segment_constructor() kills the segment constructor daemon,
+ * frees the struct nilfs_sc_info, and destroy the dirty file list.
+ */
+void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	LIST_HEAD(garbage_list);
+
+	down_write(&nilfs->ns_segctor_sem);
+	if (NILFS_SC(sbi)) {
+		nilfs_segctor_destroy(NILFS_SC(sbi));
+		sbi->s_sc_info = NULL;
+	}
+
+	/* Force to free the list of dirty files */
+	spin_lock(&sbi->s_inode_lock);
+	if (!list_empty(&sbi->s_dirty_files)) {
+		list_splice_init(&sbi->s_dirty_files, &garbage_list);
+		nilfs_warning(sbi->s_super, __func__,
+			      "Non empty dirty list after the last "
+			      "segment construction\n");
+	}
+	spin_unlock(&sbi->s_inode_lock);
+	up_write(&nilfs->ns_segctor_sem);
+
+	nilfs_dispose_list(sbi, &garbage_list, 1);
+	nilfs_detach_writer(nilfs, sbi);
+}
diff -puN /dev/null fs/nilfs2/segment.h
--- /dev/null
+++ a/fs/nilfs2/segment.h
@@ -0,0 +1,294 @@
+/*
+ * segment.h - NILFS Segment constructor prototypes and definitions
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+#ifndef _NILFS_SEGMENT_H
+#define _NILFS_SEGMENT_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "sb.h"
+#include "segbuf.h"
+
+/**
+ * struct nilfs_recovery_info - Recovery infomation
+ * @ri_need_recovery: Recovery status
+ * @ri_super_root: Block number of the last super root
+ * @ri_ri_cno: Number of the last checkpoint
+ * @ri_lsegs_start: Region for roll-forwarding (start block number)
+ * @ri_lsegs_end: Region for roll-forwarding (end block number)
+ * @ri_lseg_start_seq: Sequence value of the segment at ri_lsegs_start
+ * @ri_used_segments: List of segments to be mark active
+ * @ri_pseg_start: Block number of the last partial segment
+ * @ri_seq: Sequence number on the last partial segment
+ * @ri_segnum: Segment number on the last partial segment
+ * @ri_nextnum: Next segment number on the last partial segment
+ */
+struct nilfs_recovery_info {
+	int			ri_need_recovery;
+	sector_t		ri_super_root;
+	__u64			ri_cno;
+
+	sector_t		ri_lsegs_start;
+	sector_t		ri_lsegs_end;
+	u64			ri_lsegs_start_seq;
+	struct list_head	ri_used_segments;
+	sector_t		ri_pseg_start;
+	u64			ri_seq;
+	__u64			ri_segnum;
+	__u64			ri_nextnum;
+};
+
+/* ri_need_recovery */
+#define NILFS_RECOVERY_SR_UPDATED	 1  /* The super root was updated */
+#define NILFS_RECOVERY_ROLLFORWARD_DONE	 2  /* Rollforward was carried out */
+
+/**
+ * struct nilfs_transaction_info: Transaction information
+ * @ti_magic: Magic number
+ * @ti_save: Backup of journal_info field of task_struct
+ * @ti_flags: Flags
+ * @ti_count: Nest level
+ * @ti_garbage:	List of inode to be put when releasing semaphore
+ * @ti_ndirtied: Number of dirtied blocks
+ */
+struct nilfs_transaction_info {
+	u32			ti_magic;
+	void		       *ti_save;
+				/* This should never used. If this happens,
+				   one of other filesystems has a bug. */
+	unsigned short		ti_flags;
+	unsigned short		ti_count;
+	struct list_head	ti_garbage;
+};
+/* ti_magic */
+#define NILFS_TI_MAGIC		0xd9e392fb
+
+/* ti_flags */
+#define NILFS_TI_DYNAMIC_ALLOC	0x0001
+#define NILFS_TI_SYNC		0x0002	/* Force to construct segment at the
+					   end of transaction. */
+#define NILFS_TI_GC		0x0004	/* GC context */
+#define NILFS_TI_COMMIT		0x0008	/* Change happened or not */
+#define NILFS_TI_WRITER		0x0010	/* Constructor context */
+
+/**
+ * struct nilfs_cstage - Context of collection stage
+ * @scnt: Stage count
+ * @flags: State flags
+ * @dirty_file_ptr: Pointer on dirty_files list, or inode of a target file
+ * @gc_inode_ptr: Pointer on the list of gc-inodes
+ */
+struct nilfs_cstage {
+	int			scnt;
+	unsigned 		flags;
+	struct nilfs_inode_info *dirty_file_ptr;
+	struct nilfs_inode_info *gc_inode_ptr;
+};
+
+/**
+ * struct nilfs_sc_info - Segment constructor information
+ * @sc_super: Back pointer to super_block struct
+ * @sc_sbi: Back pointer to nilfs_sb_info struct
+ * @sc_nblk_inc: Block count of current generation
+ * @sc_dirty_files: List of files to be written
+ * @sc_gc_inodes: List of GC inodes having blocks to be written
+ * @sc_active_segments: List of active segments that were already written out
+ * @sc_cleaning_segments: List of segments to be freed through construction
+ * @sc_copied_buffers: List of copied buffers (buffer heads) to freeze data
+ * @sc_segbufs: List of segment buffers
+ * @sc_segbuf_nblocks: Number of available blocks in segment buffers.
+ * @sc_curseg: Current segment buffer
+ * @sc_super_root: Pointer to the super root buffer
+ * @sc_stage: Collection stage
+ * @sc_finfo_ptr: pointer to the current finfo struct in the segment summary
+ * @sc_binfo_ptr: pointer to the current binfo struct in the segment summary
+ * @sc_blk_cnt:	Block count of a file
+ * @sc_datablk_cnt: Data block count of a file
+ * @sc_nblk_this_inc: Number of blocks included in the current logical segment
+ * @sc_seg_ctime: Creation time
+ * @sc_flags: Internal flags
+ * @sc_sketch_inode: Inode of the sketch file
+ * @sc_state_lock: spinlock for sc_state and so on
+ * @sc_state: Segctord state flags
+ * @sc_flush_request: inode bitmap of metadata files to be flushed
+ * @sc_wait_request: Client request queue
+ * @sc_wait_daemon: Daemon wait queue
+ * @sc_wait_task: Start/end wait queue to control segctord task
+ * @sc_seq_request: Request counter
+ * @sc_seq_done: Completion counter
+ * @sc_sync: Request of explicit sync operation
+ * @sc_interval: Timeout value of background construction
+ * @sc_mjcp_freq: Frequency of creating checkpoints
+ * @sc_lseg_stime: Start time of the latest logical segment
+ * @sc_watermark: Watermark for the number of dirty buffers
+ * @sc_timer: Timer for segctord
+ * @sc_task: current thread of segctord
+ */
+struct nilfs_sc_info {
+	struct super_block     *sc_super;
+	struct nilfs_sb_info   *sc_sbi;
+
+	unsigned long		sc_nblk_inc;
+
+	struct list_head	sc_dirty_files;
+	struct list_head	sc_gc_inodes;
+	struct list_head	sc_active_segments;
+	struct list_head	sc_cleaning_segments;
+	struct list_head	sc_copied_buffers;
+
+	/* Segment buffers */
+	struct list_head	sc_segbufs;
+	unsigned long		sc_segbuf_nblocks;
+	struct nilfs_segment_buffer *sc_curseg;
+	struct buffer_head     *sc_super_root;
+
+	struct nilfs_cstage	sc_stage;
+
+	struct nilfs_segsum_pointer sc_finfo_ptr;
+	struct nilfs_segsum_pointer sc_binfo_ptr;
+	unsigned long		sc_blk_cnt;
+	unsigned long		sc_datablk_cnt;
+	unsigned long		sc_nblk_this_inc;
+	time_t			sc_seg_ctime;
+
+	unsigned long		sc_flags;
+
+	/*
+	 * Pointer to an inode of the sketch.
+	 * This pointer is kept only while it contains data.
+	 * We protect it with a semaphore of the segment constructor.
+	 */
+	struct inode	       *sc_sketch_inode;
+
+	spinlock_t		sc_state_lock;
+	unsigned long		sc_state;
+	unsigned long		sc_flush_request;
+
+	wait_queue_head_t	sc_wait_request;
+	wait_queue_head_t	sc_wait_daemon;
+	wait_queue_head_t	sc_wait_task;
+
+	__u32			sc_seq_request;
+	__u32			sc_seq_done;
+
+	int			sc_sync;
+	unsigned long		sc_interval;
+	unsigned long		sc_mjcp_freq;
+	unsigned long		sc_lseg_stime;	/* in 1/HZ seconds */
+	unsigned long		sc_watermark;
+
+	struct timer_list      *sc_timer;
+	struct task_struct     *sc_task;
+};
+
+/* sc_flags */
+enum {
+	NILFS_SC_DIRTY,		/* One or more dirty meta-data blocks exist */
+	NILFS_SC_UNCLOSED,	/* Logical segment is not closed */
+	NILFS_SC_SUPER_ROOT,	/* The latest segment has a super root */
+	NILFS_SC_PRIOR_FLUSH,	/* Requesting immediate flush without making a
+				   checkpoint */
+};
+
+/* sc_state */
+#define NILFS_SEGCTOR_QUIT	    0x0001  /* segctord is being destroyed */
+#define NILFS_SEGCTOR_COMMIT	    0x0004  /* committed transaction exists */
+
+/*
+ * Constant parameters
+ */
+#define NILFS_SC_CLEANUP_RETRY	    3  /* Retry count of construction when
+					  destroying segctord */
+
+/*
+ * Default values of timeout, in seconds.
+ */
+#define NILFS_SC_DEFAULT_TIMEOUT    5   /* Timeout value of dirty blocks.
+					   It triggers construction of a
+					   logical segment with a super root */
+#define NILFS_SC_DEFAULT_SR_FREQ    30  /* Maximum frequency of super root
+					   creation */
+#define NILFS_SC_DEFAULT_SB_FREQ    30  /* Minimum interval of periodical
+					   update of superblock (reserved) */
+
+/*
+ * The default threshold amount of data, in block counts.
+ */
+#define NILFS_SC_DEFAULT_WATERMARK  3600
+
+
+/* segment.c */
+extern int nilfs_init_transaction_cache(void);
+extern void nilfs_destroy_transaction_cache(void);
+extern int nilfs_transaction_begin(struct super_block *,
+				   struct nilfs_transaction_info *, int);
+extern int nilfs_transaction_end(struct super_block *, int);
+extern void nilfs_relax_pressure_in_lock(struct super_block *);
+
+extern int nilfs_construct_segment(struct super_block *);
+extern int nilfs_construct_dsync_segment(struct super_block *,
+					 struct inode *);
+extern void nilfs_flush_segment(struct super_block *, ino_t);
+extern int nilfs_clean_segments(struct super_block *, unsigned long);
+
+extern int nilfs_segctor_add_segments_to_be_freed(struct nilfs_sc_info *,
+						  __u64 *, size_t);
+extern void nilfs_segctor_clear_segments_to_be_freed(struct nilfs_sc_info *);
+
+extern int nilfs_attach_segment_constructor(struct nilfs_sb_info *,
+					    struct nilfs_recovery_info *);
+extern void nilfs_detach_segment_constructor(struct nilfs_sb_info *);
+
+/* recovery.c */
+extern int nilfs_read_super_root_block(struct super_block *, sector_t,
+				       struct buffer_head **, int);
+extern int nilfs_search_super_root(struct the_nilfs *, struct nilfs_sb_info *,
+				   struct nilfs_recovery_info *);
+extern int nilfs_recover_logical_segments(struct the_nilfs *,
+					  struct nilfs_sb_info *,
+					  struct nilfs_recovery_info *);
+
+
+static inline struct nilfs_sc_info *NILFS_SC(struct nilfs_sb_info *sbi)
+{
+	return sbi->s_sc_info;
+}
+
+static inline void nilfs_set_transaction_flag(unsigned int flag)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+
+	BUG_ON(!ti);
+	ti->ti_flags |= flag;
+}
+
+static inline int nilfs_test_transaction_flag(unsigned int flag)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+
+	if (ti == NULL || ti->ti_magic != NILFS_TI_MAGIC)
+		return 0;
+	return !!(ti->ti_flags & flag);
+}
+
+#endif /* _NILFS_SEGMENT_H */
diff -puN /dev/null fs/nilfs2/sufile.c
--- /dev/null
+++ a/fs/nilfs2/sufile.c
@@ -0,0 +1,758 @@
+/*
+ * sufile.c - NILFS segment usage file.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/buffer_head.h>
+#include <linux/errno.h>
+#include <linux/nilfs2_fs.h>
+#include "mdt.h"
+#include "sufile.h"
+
+
+static inline unsigned long
+nilfs_sufile_segment_usages_per_block(const struct inode *sufile)
+{
+	return (1UL << sufile->i_blkbits) / sizeof(struct nilfs_segment_usage);
+}
+
+static inline unsigned long
+nilfs_sufile_get_blkoff(const struct inode *sufile, __u64 segnum)
+{
+	__u64 t;
+
+	t = segnum + NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET;
+	do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
+	return (unsigned long)t;
+}
+
+static inline unsigned long
+nilfs_sufile_get_offset(const struct inode *sufile, __u64 segnum)
+{
+	__u64 t;
+
+	t = segnum + NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET;
+	return do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
+}
+
+static inline unsigned long
+nilfs_sufile_segment_usages_in_block(const struct inode *sufile, __u64 curr,
+				     __u64 max)
+{
+	return min_t(unsigned long,
+		     nilfs_sufile_segment_usages_per_block(sufile) -
+		     nilfs_sufile_get_offset(sufile, curr),
+		     max - curr + 1);
+}
+
+static inline struct nilfs_sufile_header *
+nilfs_sufile_block_get_header(const struct inode *sufile,
+			      struct buffer_head *bh,
+			      void *kaddr)
+{
+	return (struct nilfs_sufile_header *)(kaddr + bh_offset(bh));
+}
+
+static inline struct nilfs_segment_usage *
+nilfs_sufile_block_get_segment_usage(const struct inode *sufile, __u64 segnum,
+				     struct buffer_head *bh, void *kaddr)
+{
+	return (struct nilfs_segment_usage *)(kaddr + bh_offset(bh)) +
+		nilfs_sufile_get_offset(sufile, segnum);
+}
+
+static int nilfs_sufile_get_block(struct inode *sufile, unsigned long blkoff,
+				  int create, struct buffer_head **bhp)
+{
+	struct buffer_head *bh;
+	int ret;
+
+	ret = nilfs_mdt_read_block(sufile, blkoff, &bh);
+	if (ret < 0) {
+		if ((ret != -ENOENT) || !create)
+			return ret;
+		/* first block must be allocated by mkfs.nilfs */
+		BUG_ON(blkoff == 0);
+		ret = nilfs_mdt_create_block(sufile, blkoff, &bh, NULL);
+		if (ret < 0)
+			return ret;
+	}
+
+	BUG_ON(bhp == NULL);
+	*bhp = bh;
+	return ret;
+}
+
+static inline int nilfs_sufile_get_header_block(struct inode *sufile,
+						struct buffer_head **bhp)
+{
+	return nilfs_sufile_get_block(sufile, 0, 0, bhp);
+}
+
+static inline int
+nilfs_sufile_get_segment_usage_block(struct inode *sufile, __u64 segnum,
+				     int create, struct buffer_head **bhp)
+{
+	return nilfs_sufile_get_block(sufile,
+				      nilfs_sufile_get_blkoff(sufile, segnum),
+				      create,
+				      bhp);
+}
+
+/**
+ * nilfs_sufile_alloc - allocate a segment
+ * @sufile: inode of segment usage file
+ * @segnump: pointer to segment number
+ *
+ * Description: nilfs_sufile_alloc() allocates a clean segment.
+ *
+ * Return Value: On success, 0 is returned and the segment number of the
+ * allocated segment is stored in the place pointed by @segnump. On error, one
+ * of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - No clean segment left.
+ */
+int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
+{
+	struct buffer_head *header_bh, *su_bh;
+	struct the_nilfs *nilfs;
+	struct nilfs_sufile_header *header;
+	struct nilfs_segment_usage *su;
+	__u64 segnum, maxsegnum, last_alloc;
+	void *kaddr;
+	unsigned long nsegments, ncleansegs, nsus;
+	int ret, i, j;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	nilfs = NILFS_MDT(sufile)->mi_nilfs;
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	ncleansegs = le64_to_cpu(header->sh_ncleansegs);
+	last_alloc = le64_to_cpu(header->sh_last_alloc);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nsegments = nilfs_sufile_get_nsegments(sufile);
+	segnum = last_alloc + 1;
+	maxsegnum = nsegments - 1;
+	for (i = 0; i < nsegments; i += nsus) {
+		if (segnum >= nsegments) {
+			/* wrap around */
+			segnum = 0;
+			maxsegnum = last_alloc;
+		}
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1,
+							   &su_bh);
+		if (ret < 0)
+			goto out_header;
+		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, segnum, su_bh, kaddr);
+
+		nsus = nilfs_sufile_segment_usages_in_block(
+			sufile, segnum, maxsegnum);
+		for (j = 0; j < nsus; j++, su++, segnum++) {
+			if (nilfs_segment_usage_clean(su)) {
+				/* found a clean segment */
+				nilfs_segment_usage_set_active(su);
+				nilfs_segment_usage_set_dirty(su);
+				kunmap_atomic(kaddr, KM_USER0);
+
+				kaddr = kmap_atomic(header_bh->b_page,
+						    KM_USER0);
+				header = nilfs_sufile_block_get_header(
+					sufile, header_bh, kaddr);
+				header->sh_ncleansegs = cpu_to_le64(
+					le64_to_cpu(header->sh_ncleansegs) - 1);
+				header->sh_ndirtysegs =	cpu_to_le64(
+					le64_to_cpu(header->sh_ndirtysegs) + 1);
+				header->sh_last_alloc = cpu_to_le64(segnum);
+				kunmap_atomic(kaddr, KM_USER0);
+
+				nilfs_mdt_mark_buffer_dirty(header_bh);
+				nilfs_mdt_mark_buffer_dirty(su_bh);
+				nilfs_mdt_mark_dirty(sufile);
+				brelse(su_bh);
+				BUG_ON(segnump == NULL);
+				*segnump = segnum;
+				goto out_header;
+			}
+		}
+
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(su_bh);
+	}
+
+	/* no segments left */
+	ret = -ENOSPC;
+
+ out_header:
+	brelse(header_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_cancel_free -
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_cancel_free(struct inode *sufile, __u64 segnum)
+{
+	struct buffer_head *header_bh, *su_bh;
+	struct the_nilfs *nilfs;
+	struct nilfs_sufile_header *header;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	unsigned long ncleansegs, ndirtysegs;
+	int ret;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	nilfs = NILFS_MDT(sufile)->mi_nilfs;
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+
+	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &su_bh);
+	if (ret < 0)
+		goto out_header;
+
+	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	su = nilfs_sufile_block_get_segment_usage(
+		sufile, segnum, su_bh, kaddr);
+	if (!nilfs_segment_usage_clean(su)) {
+		printk(KERN_CRIT "%s: segment %llu must be clean\n",
+		       __func__, (unsigned long long)segnum);
+		BUG();
+	}
+	nilfs_segment_usage_set_dirty(su);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	ncleansegs = le64_to_cpu(header->sh_ncleansegs) - 1;
+	ndirtysegs = le64_to_cpu(header->sh_ndirtysegs) + 1;
+	header->sh_ncleansegs =	cpu_to_le64(ncleansegs);
+	header->sh_ndirtysegs =	cpu_to_le64(ndirtysegs);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_mdt_mark_buffer_dirty(su_bh);
+	nilfs_mdt_mark_dirty(sufile);
+
+	brelse(su_bh);
+
+ out_header:
+	brelse(header_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_freev - free segments
+ * @sufile: inode of segment usage file
+ * @segnum: array of segment numbers
+ * @nsegs: number of segments
+ *
+ * Description: nilfs_sufile_freev() frees segments specified by @segnum and
+ * @nsegs, which must have been returned by a previous call to
+ * nilfs_sufile_alloc().
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+#define NILFS_SUFILE_FREEV_PREALLOC	16
+int nilfs_sufile_freev(struct inode *sufile, __u64 *segnum, size_t nsegs)
+{
+	struct buffer_head *header_bh, **su_bh,
+		*su_bh_prealloc[NILFS_SUFILE_FREEV_PREALLOC];
+	struct the_nilfs *nilfs;
+	struct nilfs_sufile_header *header;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	unsigned long ncleansegs, ndirtysegs;
+	int ret, i;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	nilfs = NILFS_MDT(sufile)->mi_nilfs;
+
+	/* prepare resources */
+	if (nsegs <= NILFS_SUFILE_FREEV_PREALLOC)
+		su_bh = su_bh_prealloc;
+	else {
+		su_bh = kmalloc(sizeof(*su_bh) * nsegs, GFP_NOFS);
+		if (su_bh == NULL) {
+			ret = -ENOMEM;
+			goto out_sem;
+		}
+	}
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_su_bh;
+	for (i = 0; i < nsegs; i++) {
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum[i],
+							   0, &su_bh[i]);
+		if (ret < 0)
+			goto out_bh;
+	}
+
+	/* free segments */
+	for (i = 0; i < nsegs; i++) {
+		kaddr = kmap_atomic(su_bh[i]->b_page, KM_USER0);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, segnum[i], su_bh[i], kaddr);
+		BUG_ON(nilfs_segment_usage_error(su));
+		nilfs_segment_usage_set_clean(su);
+		kunmap_atomic(kaddr, KM_USER0);
+		nilfs_mdt_mark_buffer_dirty(su_bh[i]);
+	}
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	ncleansegs = le64_to_cpu(header->sh_ncleansegs) + nsegs;
+	ndirtysegs = le64_to_cpu(header->sh_ndirtysegs) - nsegs;
+	header->sh_ncleansegs = cpu_to_le64(ncleansegs);
+	header->sh_ndirtysegs = cpu_to_le64(ndirtysegs);
+	kunmap_atomic(kaddr, KM_USER0);
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_mdt_mark_dirty(sufile);
+
+ out_bh:
+	for (i--; i >= 0; i--)
+		brelse(su_bh[i]);
+	brelse(header_bh);
+
+ out_su_bh:
+	if (su_bh != su_bh_prealloc)
+		kfree(su_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_free -
+ * @sufile:
+ * @segnum:
+ */
+int nilfs_sufile_free(struct inode *sufile, __u64 segnum)
+{
+	return nilfs_sufile_freev(sufile, &segnum, 1);
+}
+
+/**
+ * nilfs_sufile_get_segment_usage - get a segment usage
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ * @sup: pointer to segment usage
+ * @bhp: pointer to buffer head
+ *
+ * Description: nilfs_sufile_get_segment_usage() acquires the segment usage
+ * specified by @segnum.
+ *
+ * Return Value: On success, 0 is returned, and the segment usage and the
+ * buffer head of the buffer on which the segment usage is located are stored
+ * in the place pointed by @sup and @bhp, respectively. On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid segment usage number.
+ */
+int nilfs_sufile_get_segment_usage(struct inode *sufile, __u64 segnum,
+				   struct nilfs_segment_usage **sup,
+				   struct buffer_head **bhp)
+{
+	struct buffer_head *bh;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	int ret;
+
+	/* segnum is 0 origin */
+	BUG_ON(segnum >= nilfs_sufile_get_nsegments(sufile));
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1, &bh);
+	if (ret < 0)
+		goto out_sem;
+	kaddr = kmap(bh->b_page);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+	if (nilfs_segment_usage_error(su)) {
+		kunmap(bh->b_page);
+		brelse(bh);
+		ret = -EINVAL;
+		goto out_sem;
+	}
+
+	if (sup != NULL)
+		*sup = su;
+	BUG_ON(bhp == NULL);
+	*bhp = bh;
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_put_segment_usage - put a segment usage
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ * @bh: buffer head
+ *
+ * Description: nilfs_sufile_put_segment_usage() releases the segment usage
+ * specified by @segnum. @bh must be the buffer head which have been returned
+ * by a previous call to nilfs_sufile_get_segment_usage() with @segnum.
+ */
+void nilfs_sufile_put_segment_usage(struct inode *sufile, __u64 segnum,
+				    struct buffer_head *bh)
+{
+	/* XXX: must check segnum */
+	kunmap(bh->b_page);
+	brelse(bh);
+}
+
+/**
+ * nilfs_sufile_get_stat - get segment usage statistics
+ * @sufile: inode of segment usage file
+ * @stat: pointer to a structure of segment usage statistics
+ *
+ * Description: nilfs_sufile_get_stat() returns information about segment
+ * usage.
+ *
+ * Return Value: On success, 0 is returned, and segment usage information is
+ * stored in the place pointed by @stat. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
+{
+	struct buffer_head *header_bh;
+	struct nilfs_sufile_header *header;
+	void *kaddr;
+	int ret;
+
+	down_read(&NILFS_MDT(sufile)->mi_sem);
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	sustat->ss_nsegs = nilfs_sufile_get_nsegments(sufile);
+	sustat->ss_ncleansegs = le64_to_cpu(header->sh_ncleansegs);
+	sustat->ss_ndirtysegs = le64_to_cpu(header->sh_ndirtysegs);
+	sustat->ss_ctime = NILFS_MDT(sufile)->mi_nilfs->ns_ctime;
+	sustat->ss_nongc_ctime = NILFS_MDT(sufile)->mi_nilfs->ns_nongc_ctime;
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(header_bh);
+
+ out_sem:
+	up_read(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_get_ncleansegs - get the number of clean segments
+ * @sufile: inode of segment usage file
+ * @nsegsp: pointer to the number of clean segments
+ *
+ * Description: nilfs_sufile_get_ncleansegs() acquires the number of clean
+ * segments.
+ *
+ * Return Value: On success, 0 is returned and the number of clean segments is
+ * stored in the place pointed by @nsegsp. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_get_ncleansegs(struct inode *sufile, unsigned long *nsegsp)
+{
+	struct nilfs_sustat sustat;
+	int ret;
+
+	ret = nilfs_sufile_get_stat(sufile, &sustat);
+	if (ret < 0)
+		return ret;
+	BUG_ON(nsegsp == NULL);
+	*nsegsp = sustat.ss_ncleansegs;
+	return 0;
+}
+
+/**
+ * nilfs_sufile_get_ndirtysegs - get the number of dirty segments
+ * @sufile: inode of segment usage file
+ * @nsegsp: pointer to the number of dirty segments
+ *
+ * Description: nilfs_sufile_get_ndirtysegs() acquires the number of dirty
+ * segments.
+ *
+ * Return Value: On success, 0 is returned and the number of dirty segments is
+ * stored in the place pointed by @nsegsp. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_get_ndirtysegs(struct inode *sufile, unsigned long *nsegsp)
+{
+	struct nilfs_sustat sustat;
+	int ret;
+
+	ret = nilfs_sufile_get_stat(sufile, &sustat);
+	if (ret < 0)
+		return ret;
+	BUG_ON(nsegsp == NULL);
+	*nsegsp = sustat.ss_ndirtysegs;
+	return 0;
+}
+
+/**
+ * nilfs_sufile_set_error - mark a segment as erroneous
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ *
+ * Description: nilfs_sufile_set_error() marks the segment specified by
+ * @segnum as erroneous. The error segment will never be used again.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
+{
+	struct buffer_head *header_bh, *su_bh;
+	struct nilfs_segment_usage *su;
+	struct nilfs_sufile_header *header;
+	void *kaddr;
+	int ret;
+
+	BUG_ON(segnum >= nilfs_sufile_get_nsegments(sufile));
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &su_bh);
+	if (ret < 0)
+		goto out_header;
+
+	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
+	if (nilfs_segment_usage_error(su)) {
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(su_bh);
+		goto out_header;
+	}
+
+	nilfs_segment_usage_set_error(su);
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(su_bh);
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	header->sh_ndirtysegs =
+		cpu_to_le64(le64_to_cpu(header->sh_ndirtysegs) - 1);
+	kunmap_atomic(kaddr, KM_USER0);
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_mdt_mark_buffer_dirty(su_bh);
+	nilfs_mdt_mark_dirty(sufile);
+	brelse(su_bh);
+
+ out_header:
+	brelse(header_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_get_segment_usages -
+ * @sufile: inode of segment usage file
+ * @segnum: segment number to start looking
+ * @sus: array of segment usage
+ * @size: size of segment usage array
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned and .... On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+ssize_t nilfs_sufile_get_segment_usages(struct inode *sufile, __u64 segnum,
+					struct nilfs_segment_usage *sus,
+					size_t size)
+{
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	unsigned long nsegs, segusages_per_block;
+	ssize_t n;
+	int ret, i;
+
+	down_read(&NILFS_MDT(sufile)->mi_sem);
+
+	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
+	nsegs = min_t(unsigned long,
+		      nilfs_sufile_get_nsegments(sufile) - segnum,
+		      size);
+	for (i = 0; i < nsegs; i += n, segnum += n) {
+		n = min_t(unsigned long,
+			  segusages_per_block -
+				  nilfs_sufile_get_offset(sufile, segnum),
+			  nsegs - i);
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
+							   &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out;
+			/* hole */
+			memset(&sus[i], 0,
+			       sizeof(struct nilfs_segment_usage) * n);
+			continue;
+		}
+
+		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, segnum, su_bh, kaddr);
+		memcpy(&sus[i], su, sizeof(struct nilfs_segment_usage) * n);
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(su_bh);
+	}
+	ret = nsegs;
+
+ out:
+	up_read(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_get_suinfo -
+ * @sufile: inode of segment usage file
+ * @segnum: segment number to start looking
+ * @si: array of suinfo
+ * @nsi: size of suinfo array
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned and .... On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum,
+				struct nilfs_suinfo *si, size_t nsi)
+{
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	unsigned long nsegs, segusages_per_block;
+	ssize_t n;
+	int ret, i, j;
+
+	down_read(&NILFS_MDT(sufile)->mi_sem);
+
+	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
+	nsegs = min_t(unsigned long,
+		      nilfs_sufile_get_nsegments(sufile) - segnum,
+		      nsi);
+	for (i = 0; i < nsegs; i += n, segnum += n) {
+		n = min_t(unsigned long,
+			  segusages_per_block -
+				  nilfs_sufile_get_offset(sufile, segnum),
+			  nsegs - i);
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
+							   &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out;
+			/* hole */
+			memset(&si[i], 0, sizeof(struct nilfs_suinfo) * n);
+			continue;
+		}
+
+		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, segnum, su_bh, kaddr);
+		for (j = 0; j < n; j++, su++) {
+			si[i + j].sui_lastmod = le64_to_cpu(su->su_lastmod);
+			si[i + j].sui_nblocks = le32_to_cpu(su->su_nblocks);
+			si[i + j].sui_flags = le32_to_cpu(su->su_flags);
+		}
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(su_bh);
+	}
+	ret = nsegs;
+
+ out:
+	up_read(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
diff -puN /dev/null fs/nilfs2/sufile.h
--- /dev/null
+++ a/fs/nilfs2/sufile.h
@@ -0,0 +1,67 @@
+/*
+ * sufile.h - NILFS segment usage file.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_SUFILE_H
+#define _NILFS_SUFILE_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "mdt.h"
+
+#define NILFS_SUFILE_GFP	NILFS_MDT_GFP
+
+static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
+{
+	return NILFS_MDT(sufile)->mi_nilfs->ns_nsegments;
+}
+
+static inline unsigned long nilfs_sufile_get_nrsvsegs(struct inode *sufile)
+{
+	unsigned long nsegments, rsvpercent, nrsvsegs;
+
+	nsegments = NILFS_MDT(sufile)->mi_nilfs->ns_nsegments;
+	rsvpercent = NILFS_MDT(sufile)->mi_nilfs->ns_r_segments_percentage;
+	nrsvsegs = (nsegments * rsvpercent - 1) / 100 + 1;
+	return max_t(unsigned long, nrsvsegs, NILFS_MIN_NRSVSEGS);
+}
+
+int nilfs_sufile_alloc(struct inode *, __u64 *);
+int nilfs_sufile_cancel_free(struct inode *, __u64);
+int nilfs_sufile_freev(struct inode *, __u64 *, size_t);
+int nilfs_sufile_free(struct inode *, __u64);
+int nilfs_sufile_get_segment_usage(struct inode *, __u64,
+				   struct nilfs_segment_usage **,
+				   struct buffer_head **);
+void nilfs_sufile_put_segment_usage(struct inode *, __u64,
+				    struct buffer_head *);
+int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
+int nilfs_sufile_get_ncleansegs(struct inode *, unsigned long *);
+int nilfs_sufile_get_ndirtysegs(struct inode *, unsigned long *);
+int nilfs_sufile_set_error(struct inode *, __u64);
+ssize_t nilfs_sufile_get_segment_usages(struct inode *, __u64,
+					struct nilfs_segment_usage *, size_t);
+ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, struct nilfs_suinfo *,
+				size_t);
+
+
+#endif	/* _NILFS_SUFILE_H */
diff -puN /dev/null fs/nilfs2/super.c
--- /dev/null
+++ a/fs/nilfs2/super.c
@@ -0,0 +1,1377 @@
+/*
+ * super.c - NILFS module and super block management.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ */
+/*
+ *  linux/fs/ext2/super.c
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/fs/minix/inode.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  Big-endian to little-endian byte-swapping/bitmaps by
+ *        David S. Miller (davem@caip.rutgers.edu), 1995
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/parser.h>
+#include <linux/random.h>
+#include <linux/smp_lock.h>
+#include <linux/vfs.h>
+#include <linux/writeback.h>
+#include <linux/kobject.h>
+#include <linux/exportfs.h>
+#include "nilfs.h"
+#include "mdt.h"
+#include "page.h"
+#include "cpfile.h"
+#include "ifile.h"
+#include "dat.h"
+
+MODULE_AUTHOR("NTT Corp.");
+MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
+		   "(NILFS)");
+MODULE_VERSION(NILFS_VERSION);
+MODULE_LICENSE("GPL");
+
+
+static int nilfs_remount(struct super_block *sb, int *flags, char *data);
+static int test_exclusive_mount(struct file_system_type *fs_type,
+				struct block_device *bdev, int flags);
+
+
+/**
+ * nilfs_error() - report failure condition on a filesystem
+ *
+ * nilfs_error() sets an ERROR_FS flag on the superblock as well as
+ * reporting an error message.  It should be called when NILFS detects
+ * incoherences or defects of meta data on disk.  As for sustainable
+ * errors such as a single-shot I/O error, nilfs_warning() or the printk()
+ * function should be used instead.
+ *
+ * The segment constructor must not call this function because it can
+ * kill itself.
+ */
+void
+nilfs_error(struct super_block *sb, const char *function,
+	    const char *fmt, ...)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	va_list args;
+
+	va_start(args, fmt);
+	printk(KERN_CRIT "NILFS error (device %s): %s: ", sb->s_id, function);
+	vprintk(fmt, args);
+	printk("\n");
+	va_end(args);
+
+	if (!(sb->s_flags & MS_RDONLY)) {
+		struct the_nilfs *nilfs = sbi->s_nilfs;
+
+		if (!nilfs_test_opt(sbi, ERRORS_CONT))
+			nilfs_detach_segment_constructor(sbi);
+
+		down_write(&nilfs->ns_sem);
+		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
+			nilfs->ns_mount_state |= NILFS_ERROR_FS;
+			nilfs->ns_sbp->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+			nilfs_commit_super(sbi);
+		}
+		up_write(&nilfs->ns_sem);
+
+		if (nilfs_test_opt(sbi, ERRORS_RO)) {
+			printk(KERN_CRIT "Remounting filesystem read-only\n");
+			sb->s_flags |= MS_RDONLY;
+		}
+	}
+
+	if (nilfs_test_opt(sbi, ERRORS_PANIC))
+		panic("NILFS (device %s): panic forced after error\n",
+		      sb->s_id);
+}
+
+void nilfs_warning(struct super_block *sb, const char *function,
+		   const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	printk(KERN_WARNING "NILFS warning (device %s): %s: ",
+	       sb->s_id, function);
+	vprintk(fmt, args);
+	printk("\n");
+	va_end(args);
+}
+
+static struct kmem_cache *nilfs_inode_cachep;
+
+struct inode *nilfs_alloc_inode(struct super_block *sb)
+{
+	struct nilfs_inode_info *ii;
+
+	ii = kmem_cache_alloc(nilfs_inode_cachep, GFP_NOFS);
+	if (!ii)
+		return NULL;
+	ii->i_bh = NULL;
+	ii->i_state = 0;
+	ii->vfs_inode.i_version = 1;
+	return &ii->vfs_inode;
+}
+
+void nilfs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
+}
+
+static void init_once(void *obj)
+{
+	struct nilfs_inode_info *ii = obj;
+
+	INIT_LIST_HEAD(&ii->i_dirty);
+#ifdef CONFIG_NILFS_XATTR
+	init_rwsem(&ii->xattr_sem);
+#endif
+	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
+	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
+	inode_init_once(&ii->vfs_inode);
+}
+
+static int nilfs_init_inode_cache(void)
+{
+	nilfs_inode_cachep = kmem_cache_create("nilfs2_inode_cache",
+					       sizeof(struct nilfs_inode_info),
+					       0, SLAB_RECLAIM_ACCOUNT,
+					       init_once);
+
+	return (nilfs_inode_cachep == NULL) ? -ENOMEM : 0;
+}
+
+static inline void nilfs_destroy_inode_cache(void)
+{
+	kmem_cache_destroy(nilfs_inode_cachep);
+}
+
+static void nilfs_clear_inode(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct nilfs_transaction_info ti;
+	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
+
+#ifdef CONFIG_NILFS_POSIX_ACL
+	if (ii->i_acl && ii->i_acl != NILFS_ACL_NOT_CACHED) {
+		posix_acl_release(ii->i_acl);
+		ii->i_acl = NILFS_ACL_NOT_CACHED;
+	}
+	if (ii->i_default_acl && ii->i_default_acl != NILFS_ACL_NOT_CACHED) {
+		posix_acl_release(ii->i_default_acl);
+		ii->i_default_acl = NILFS_ACL_NOT_CACHED;
+	}
+#endif
+	/*
+	 * Free resources allocated in nilfs_read_inode(), here.
+	 */
+	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+
+	spin_lock(&sbi->s_inode_lock);
+	if (!list_empty(&ii->i_dirty))
+		list_del_init(&ii->i_dirty);
+	brelse(ii->i_bh);
+	ii->i_bh = NULL;
+	spin_unlock(&sbi->s_inode_lock);
+
+	if (test_bit(NILFS_I_BMAP, &ii->i_state))
+		nilfs_bmap_clear(ii->i_bmap);
+
+	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+
+	nilfs_transaction_end(inode->i_sb, 0);
+}
+
+/**
+ * nilfs_update_last_segment - change pointer to the latest segment
+ * @sbi: nilfs_sb_info
+ * @update_cno: flag whether to update checkpoint number.
+ *
+ * nilfs_update_last_segment() changes information in the super block
+ * after a partial segment is written out successfully. The super
+ * block is marked dirty. It will be written out at the next VFS sync
+ * operations such as sync_supers() and generic_shutdown_super().
+ */
+void nilfs_update_last_segment(struct nilfs_sb_info *sbi, int update_cno)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block *sbp = nilfs->ns_sbp;
+
+	/* nilfs->sem must be locked by the caller. */
+	spin_lock(&nilfs->ns_last_segment_lock);
+	if (update_cno)
+		nilfs->ns_last_cno = nilfs->ns_cno++;
+	sbp->s_last_seq = cpu_to_le64(nilfs->ns_last_seq);
+	sbp->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
+	sbp->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
+	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	sbi->s_super->s_dirt = 1; /* must be set if delaying the call of
+				     nilfs_commit_super() */
+}
+
+static int nilfs_sync_super(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int err;
+	int barrier_done = 0;
+
+	if (nilfs_test_opt(sbi, BARRIER)) {
+		set_buffer_ordered(nilfs->ns_sbh);
+		barrier_done = 1;
+	}
+ retry:
+	set_buffer_dirty(nilfs->ns_sbh);
+	err = sync_dirty_buffer(nilfs->ns_sbh);
+	if (err == -EOPNOTSUPP && barrier_done) {
+		nilfs_warning(sbi->s_super, __func__,
+			      "barrier-based sync failed. "
+			      "disabling barriers\n");
+		nilfs_clear_opt(sbi, BARRIER);
+		barrier_done = 0;
+		clear_buffer_ordered(nilfs->ns_sbh);
+		goto retry;
+	}
+	if (unlikely(err))
+		printk(KERN_ERR
+		       "NILFS: unable to write superblock (err=%d)\n", err);
+	else {
+		nilfs_dispose_used_segments(nilfs);
+		clear_nilfs_discontinued(nilfs);
+	}
+
+	return err;
+}
+
+int nilfs_commit_super(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block *sbp = nilfs->ns_sbp;
+	sector_t nfreeblocks;
+	int err;
+
+	/* nilfs->sem must be locked by the caller. */
+	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: failed to count free blocks\n");
+		return err;
+	}
+	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
+	sbp->s_wtime = cpu_to_le64(get_seconds());
+	sbp->s_sum = 0;
+	sbp->s_sum = crc32_le(nilfs->ns_crc_seed, (unsigned char *)sbp,
+			      le16_to_cpu(sbp->s_bytes));
+
+	sbi->s_super->s_dirt = 0;
+	return nilfs_sync_super(sbi);
+}
+
+static void nilfs_put_super(struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	nilfs_detach_segment_constructor(sbi);
+
+	if (!(sb->s_flags & MS_RDONLY)) {
+		down_write(&nilfs->ns_sem);
+		nilfs->ns_sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
+		nilfs_commit_super(sbi);
+		up_write(&nilfs->ns_sem);
+	}
+
+	nilfs_detach_checkpoint(sbi);
+	put_nilfs(sbi->s_nilfs);
+	sbi->s_super = NULL;
+	sb->s_fs_info = NULL;
+	kfree(sbi);
+}
+
+/**
+ * nilfs_write_super - write super block(s) of NILFS
+ * @sb: super_block
+ *
+ * nilfs_write_super() gets a fs-dependent lock, writes super block(s), and
+ * clears s_dirt.  This function is called in the section protected by
+ * lock_super().
+ *
+ * The s_dirt flag is managed by each filesystem and we protect it by ns_sem
+ * of the struct the_nilfs.  Lock order must be as follows:
+ *
+ *   1. lock_super()
+ *   2.    down_write(&nilfs->ns_sem)
+ *
+ * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
+ * of the super block (nilfs->ns_sbp).
+ *
+ * In most cases, VFS functions call lock_super() before calling these
+ * methods.  So we must be careful not to bring on deadlocks when using
+ * lock_super();  see generic_shutdown_super(), write_super(), and so on.
+ *
+ * Note that order of lock_kernel() and lock_super() depends on contexts
+ * of VFS.  We should also note that lock_kernel() can be used in its
+ * protective section and only the outermost one has an effect.
+ */
+static void nilfs_write_super(struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	down_write(&nilfs->ns_sem);
+	if (!(sb->s_flags & MS_RDONLY))
+		nilfs_commit_super(sbi);
+	sb->s_dirt = 0;
+	up_write(&nilfs->ns_sem);
+}
+
+static int nilfs_sync_fs(struct super_block *sb, int wait)
+{
+	int err = 0;
+
+	/* This function is called when super block should be written back */
+	if (wait)
+		err = nilfs_construct_segment(sb);
+	return err;
+}
+
+int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_checkpoint *raw_cp;
+	struct buffer_head *bh_cp;
+	int err;
+
+	down_write(&nilfs->ns_sem);
+	list_add(&sbi->s_list, &nilfs->ns_supers);
+	up_write(&nilfs->ns_sem);
+
+	BUG_ON(sbi->s_ifile);
+	sbi->s_ifile = nilfs_mdt_new_with_blockgroup(
+		nilfs, sbi->s_super, NILFS_IFILE_INO, NILFS_IFILE_GFP,
+		nilfs->ns_inode_size,
+		NILFS_IFILE_GROUPS_COUNT(nilfs->ns_blocksize_bits));
+	if (!sbi->s_ifile)
+		return -ENOMEM;
+
+	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
+					  &bh_cp);
+	if (unlikely(err)) {
+		if (err == -ENOENT || err == -EINVAL) {
+			printk(KERN_ERR
+			       "NILFS: Invalid checkpoint "
+			       "(checkpoint number=%llu)\n",
+			       (unsigned long long)cno);
+			err = -EINVAL;
+		}
+		goto failed;
+	}
+	err = nilfs_read_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode);
+	if (unlikely(err))
+		goto failed_bh;
+	atomic_set(&sbi->s_inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
+	atomic_set(&sbi->s_blocks_count, le64_to_cpu(raw_cp->cp_blocks_count));
+
+	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
+	return 0;
+
+ failed_bh:
+	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
+ failed:
+	nilfs_mdt_destroy(sbi->s_ifile);
+	sbi->s_ifile = NULL;
+
+	down_write(&nilfs->ns_sem);
+	list_del_init(&sbi->s_list);
+	up_write(&nilfs->ns_sem);
+
+	return err;
+}
+
+void nilfs_detach_checkpoint(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+
+	nilfs_mdt_clear(sbi->s_ifile);
+	nilfs_mdt_destroy(sbi->s_ifile);
+	sbi->s_ifile = NULL;
+	down_write(&nilfs->ns_sem);
+	list_del_init(&sbi->s_list);
+	up_write(&nilfs->ns_sem);
+}
+
+static int nilfs_mark_recovery_complete(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int err = 0;
+
+	down_write(&nilfs->ns_sem);
+	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
+		nilfs->ns_mount_state |= NILFS_VALID_FS;
+		err = nilfs_commit_super(sbi);
+		if (likely(!err))
+			printk(KERN_INFO "NILFS: recovery complete.\n");
+	}
+	up_write(&nilfs->ns_sem);
+	return err;
+}
+
+static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	unsigned long long blocks;
+	unsigned long overhead;
+	unsigned long nrsvblocks;
+	sector_t nfreeblocks;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	int err;
+
+	/*
+	 * Compute all of the segment blocks
+	 *
+	 * The blocks before first segment and after last segment
+	 * are excluded.
+	 */
+	blocks = nilfs->ns_blocks_per_segment * nilfs->ns_nsegments
+		- nilfs->ns_first_data_block;
+	nrsvblocks = nilfs->ns_nrsvsegs * nilfs->ns_blocks_per_segment;
+
+	/*
+	 * Compute the overhead
+	 *
+	 * When distributing meta data blocks outside semgent structure,
+	 * We must count them as the overhead.
+	 */
+	overhead = 0;
+
+	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
+	if (unlikely(err))
+		return err;
+
+	buf->f_type = NILFS_SUPER_MAGIC;
+	buf->f_bsize = sb->s_blocksize;
+	buf->f_blocks = blocks - overhead;
+	buf->f_bfree = nfreeblocks;
+	buf->f_bavail = (buf->f_bfree >= nrsvblocks) ?
+		(buf->f_bfree - nrsvblocks) : 0;
+	buf->f_files = atomic_read(&sbi->s_inodes_count);
+	buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
+	buf->f_namelen = NILFS_NAME_LEN;
+	return 0;
+}
+
+static struct super_operations nilfs_sops = {
+	.alloc_inode    = nilfs_alloc_inode,
+	.destroy_inode  = nilfs_destroy_inode,
+	.dirty_inode    = nilfs_dirty_inode,
+	/* .write_inode    = nilfs_write_inode, */
+	/* .put_inode      = nilfs_put_inode, */
+	/* .drop_inode	  = nilfs_drop_inode, */
+	.delete_inode   = nilfs_delete_inode,
+	.put_super      = nilfs_put_super,
+	.write_super    = nilfs_write_super,
+	.sync_fs        = nilfs_sync_fs,
+	/* .write_super_lockfs */
+	/* .unlockfs */
+	.statfs         = nilfs_statfs,
+	.remount_fs     = nilfs_remount,
+	.clear_inode    = nilfs_clear_inode,
+	/* .umount_begin */
+	/* .show_options */
+};
+
+static struct inode *
+nilfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
+{
+	struct inode *inode;
+
+	if (ino < NILFS_FIRST_INO(sb) && ino != NILFS_ROOT_INO &&
+	    ino != NILFS_SKETCH_INO)
+		return ERR_PTR(-ESTALE);
+
+	inode = nilfs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return inode;
+}
+
+static struct dentry *
+nilfs_fh_to_dentry(struct super_block *sb, struct fid *fid, int fh_len,
+		   int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    nilfs_nfs_get_inode);
+}
+
+static struct dentry *
+nilfs_fh_to_parent(struct super_block *sb, struct fid *fid, int fh_len,
+		   int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    nilfs_nfs_get_inode);
+}
+
+static struct export_operations nilfs_export_ops = {
+	.fh_to_dentry = nilfs_fh_to_dentry,
+	.fh_to_parent = nilfs_fh_to_parent,
+	.get_parent = nilfs_get_parent,
+};
+
+enum {
+	Opt_err_cont, Opt_err_panic, Opt_err_ro,
+	Opt_barrier, Opt_snapshot, Opt_order,
+	Opt_err,
+};
+
+static match_table_t tokens = {
+	{Opt_err_cont, "errors=continue"},
+	{Opt_err_panic, "errors=panic"},
+	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_barrier, "barrier=%s"},
+	{Opt_snapshot, "cp=%u"},
+	{Opt_order, "order=%s"},
+	{Opt_err, NULL}
+};
+
+static int match_bool(substring_t *s, int *result)
+{
+	int len = s->to - s->from;
+
+	if (strncmp(s->from, "on", len) == 0 ||
+	    strncmp(s->from, "true", len) == 0)
+		*result = 1;
+	else if (strncmp(s->from, "off", len) == 0 ||
+		 strncmp(s->from, "false", len) == 0 ||
+		 strncmp(s->from, "none", len) == 0)
+		*result = 0;
+	else
+		return 1;
+	return 0;
+}
+
+static int parse_options(char *options, struct super_block *sb)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+
+	if (!options)
+		return 1;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_barrier:
+			if (match_bool(&args[0], &option))
+				return 0;
+			if (option)
+				nilfs_set_opt(sbi, BARRIER);
+			else
+				nilfs_clear_opt(sbi, BARRIER);
+			break;
+		case Opt_order:
+			if (strcmp(args[0].from, "relaxed") == 0)
+				/* Ordered data semantics */
+				nilfs_clear_opt(sbi, STRICT_ORDER);
+			else if (strcmp(args[0].from, "strict") == 0)
+				/* Strict in-order semantics */
+				nilfs_set_opt(sbi, STRICT_ORDER);
+			else
+				return 0;
+			break;
+		case Opt_err_panic:
+			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_PANIC);
+			break;
+		case Opt_err_ro:
+			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_RO);
+			break;
+		case Opt_err_cont:
+			nilfs_write_opt(sbi, ERROR_MODE, ERRORS_CONT);
+			break;
+		case Opt_snapshot:
+			if (match_int(&args[0], &option) || option <= 0)
+				return 0;
+			if (!(sb->s_flags & MS_RDONLY))
+				return 0;
+			sbi->s_snapshot_cno = option;
+			nilfs_set_opt(sbi, SNAPSHOT);
+			break;
+		default:
+			printk(KERN_ERR
+			       "NILFS: Unrecognized mount option \"%s\"\n", p);
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static inline void
+nilfs_set_default_options(struct nilfs_sb_info *sbi,
+			  struct nilfs_super_block *sbp)
+{
+	sbi->s_mount_opt =
+		NILFS_MOUNT_ERRORS_CONT | NILFS_MOUNT_BARRIER;
+}
+
+static int nilfs_setup_super(struct nilfs_sb_info *sbi)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block *sbp = nilfs->ns_sbp;
+	int max_mnt_count = le16_to_cpu(sbp->s_max_mnt_count);
+	int mnt_count = le16_to_cpu(sbp->s_mnt_count);
+
+	/* nilfs->sem must be locked by the caller. */
+	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
+		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
+	} else if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
+		printk(KERN_WARNING
+		       "NILFS warning: mounting fs with errors\n");
+#if 0
+	} else if (max_mnt_count >= 0 && mnt_count >= max_mnt_count) {
+		printk(KERN_WARNING
+		       "NILFS warning: maximal mount count reached\n");
+#endif
+	}
+	if (!max_mnt_count)
+		sbp->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
+
+	sbp->s_mnt_count = cpu_to_le16(mnt_count + 1);
+	sbp->s_state = cpu_to_le16(le16_to_cpu(sbp->s_state) & ~NILFS_VALID_FS);
+	sbp->s_mtime = cpu_to_le64(get_seconds());
+	return nilfs_commit_super(sbi);
+}
+
+struct nilfs_super_block *
+nilfs_load_super_block(struct super_block *sb, struct buffer_head **pbh)
+{
+	int blocksize;
+	unsigned long offset, sb_index;
+
+	/*
+	 * Adjusting block size
+	 * Blocksize will be enlarged when it is smaller than hardware
+	 * sector size.
+	 * Disk format of superblock does not change.
+	 */
+	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	if (!blocksize) {
+		printk(KERN_ERR
+		       "NILFS: unable to set blocksize of superblock\n");
+		return NULL;
+	}
+	sb_index = NILFS_SB_OFFSET_BYTES / blocksize;
+	offset = NILFS_SB_OFFSET_BYTES % blocksize;
+
+	*pbh = sb_bread(sb, sb_index);
+	if (!*pbh) {
+		printk(KERN_ERR "NILFS: unable to read superblock\n");
+		return NULL;
+	}
+	return (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
+}
+
+struct nilfs_super_block *
+nilfs_reload_super_block(struct super_block *sb, struct buffer_head **pbh,
+			 int blocksize)
+{
+	struct nilfs_super_block *sbp;
+	unsigned long offset, sb_index;
+	int hw_blocksize = bdev_hardsect_size(sb->s_bdev);
+
+	if (blocksize < hw_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: blocksize %d too small for device "
+		       "(sector-size = %d).\n",
+		       blocksize, hw_blocksize);
+		goto failed_sbh;
+	}
+	brelse(*pbh);
+	sb_set_blocksize(sb, blocksize);
+
+	sb_index = NILFS_SB_OFFSET_BYTES / blocksize;
+	offset = NILFS_SB_OFFSET_BYTES % blocksize;
+
+	*pbh = sb_bread(sb, sb_index);
+	if (!*pbh) {
+		printk(KERN_ERR
+		       "NILFS: cannot read superblock on 2nd try.\n");
+		goto failed;
+	}
+
+	sbp = (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
+	if (sbp->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
+		printk(KERN_ERR
+		       "NILFS: !? Magic mismatch on 2nd try.\n");
+		goto failed_sbh;
+	}
+	return sbp;
+
+ failed_sbh:
+	brelse(*pbh);
+
+ failed:
+	return NULL;
+}
+
+int nilfs_store_magic_and_option(struct super_block *sb,
+				 struct nilfs_super_block *sbp,
+				 char *data)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+
+	/* trying to fill super (1st stage) */
+	sb->s_magic = le16_to_cpu(sbp->s_magic);
+
+	/* FS independent flags */
+#ifdef NILFS_ATIME_DISABLE
+	sb->s_flags |= MS_NOATIME;
+#endif
+
+	if (sb->s_magic != NILFS_SUPER_MAGIC) {
+		printk("NILFS: Can't find nilfs on dev %s.\n", sb->s_id);
+		return -EINVAL;
+	}
+
+	nilfs_set_default_options(sbi, sbp);
+
+	sbi->s_resuid = le16_to_cpu(sbp->s_def_resuid);
+	sbi->s_resgid = le16_to_cpu(sbp->s_def_resgid);
+	sbi->s_interval = le32_to_cpu(sbp->s_c_interval);
+	sbi->s_watermark = le32_to_cpu(sbp->s_c_block_max);
+
+	if (!parse_options(data, sb))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * nilfs_fill_super() - initialize a super block instance
+ * @sb: super_block
+ * @data: mount options
+ * @silent: silent mode flag
+ * @nilfs: the_nilfs struct
+ *
+ * This function is called exclusively by bd_mount_mutex.
+ * So, the recovery process is protected from other simultaneous mounts.
+ */
+static int
+nilfs_fill_super(struct super_block *sb, void *data, int silent,
+		 struct the_nilfs *nilfs)
+{
+	struct nilfs_sb_info *sbi;
+	struct inode *root;
+	__u64 cno;
+	int err;
+
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+
+	sb->s_fs_info = sbi;
+
+	get_nilfs(nilfs);
+	sbi->s_nilfs = nilfs;
+	sbi->s_super = sb;
+
+	err = init_nilfs(nilfs, sbi, (char *)data);
+	if (err)
+		goto failed_sbi;
+
+	spin_lock_init(&sbi->s_inode_lock);
+	INIT_LIST_HEAD(&sbi->s_dirty_files);
+	INIT_LIST_HEAD(&sbi->s_list);
+
+	/*
+	 * Following initialization is overlapped because
+	 * nilfs_sb_info structure has been cleared at the beginning.
+	 * But we reserve them to keep our interest and make ready
+	 * for the future change.
+	 */
+	get_random_bytes(&sbi->s_next_generation,
+			 sizeof(sbi->s_next_generation));
+	spin_lock_init(&sbi->s_next_gen_lock);
+
+	sb->s_op = &nilfs_sops;
+	sb->s_export_op = &nilfs_export_ops;
+	sb->s_root = NULL;
+
+	if (!nilfs_loaded(nilfs)) {
+		err = load_nilfs(nilfs, sbi);
+		if (err)
+			goto failed_sbi;
+	}
+	cno = nilfs_last_cno(nilfs);
+
+	if (sb->s_flags & MS_RDONLY) {
+		if (nilfs_test_opt(sbi, SNAPSHOT)) {
+			if (!nilfs_cpfile_is_snapshot(nilfs->ns_cpfile,
+						      sbi->s_snapshot_cno)) {
+				printk(KERN_ERR
+				       "NILFS: The specified checkpoint is "
+				       "not a snapshot "
+				       "(checkpoint number=%llu).\n",
+				       (unsigned long long)sbi->s_snapshot_cno);
+				err = -EINVAL;
+				goto failed_sbi;
+			}
+			cno = sbi->s_snapshot_cno;
+		} else
+			/* Read-only mount */
+			sbi->s_snapshot_cno = cno;
+	}
+
+	err = nilfs_attach_checkpoint(sbi, cno);
+	if (err) {
+		printk(KERN_ERR "NILFS: error loading a checkpoint"
+		       " (checkpoint number=%llu).\n", (unsigned long long)cno);
+		goto failed_sbi;
+	}
+
+	if (!(sb->s_flags & MS_RDONLY)) {
+		err = nilfs_attach_segment_constructor(sbi, NULL);
+		if (err)
+			goto failed_checkpoint;
+	}
+
+	root = nilfs_iget(sb, NILFS_ROOT_INO);
+	if (IS_ERR(root)) {
+		printk(KERN_ERR "NILFS: get root inode failed\n");
+		err = PTR_ERR(root);
+		goto failed_segctor;
+	}
+	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
+		iput(root);
+		printk(KERN_ERR "NILFS: corrupt root inode.\n");
+		err = -EINVAL;
+		goto failed_segctor;
+	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		printk(KERN_ERR "NILFS: get root dentry failed\n");
+		err = -ENOMEM;
+		goto failed_segctor;
+	}
+
+	if (!(sb->s_flags & MS_RDONLY)) {
+		down_write(&nilfs->ns_sem);
+		nilfs_setup_super(sbi);
+		up_write(&nilfs->ns_sem);
+	}
+
+	err = nilfs_mark_recovery_complete(sbi);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: recovery failed.\n");
+		goto failed_root;
+	}
+
+	return 0;
+
+ failed_root:
+	dput(sb->s_root);
+	sb->s_root = NULL;
+
+ failed_segctor:
+	nilfs_detach_segment_constructor(sbi);
+
+ failed_checkpoint:
+	nilfs_detach_checkpoint(sbi);
+
+ failed_sbi:
+	put_nilfs(nilfs);
+	sb->s_fs_info = NULL;
+	kfree(sbi);
+	return err;
+}
+
+static int nilfs_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_super_block *sbp;
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	unsigned long old_sb_flags;
+	struct nilfs_mount_options old_opts;
+	int err;
+
+	old_sb_flags = sb->s_flags;
+	old_opts.mount_opt = sbi->s_mount_opt;
+	old_opts.snapshot_cno = sbi->s_snapshot_cno;
+
+	if (!parse_options(data, sb)) {
+		err = -EINVAL;
+		goto restore_opts;
+	}
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL);
+
+	if ((*flags & MS_RDONLY) &&
+	    sbi->s_snapshot_cno != old_opts.snapshot_cno) {
+		printk(KERN_WARNING "NILFS (device %s): couldn't "
+		       "remount to a different snapshot. \n",
+		       sb->s_id);
+		err = -EINVAL;
+		goto restore_opts;
+	}
+
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+		goto out;
+	if (*flags & MS_RDONLY) {
+		/* Shutting down the segment constructor */
+		nilfs_detach_segment_constructor(sbi);
+		sb->s_flags |= MS_RDONLY;
+
+		sbi->s_snapshot_cno = nilfs_last_cno(nilfs);
+		/* nilfs_set_opt(sbi, SNAPSHOT); */
+
+		/*
+		 * Remounting a valid RW partition RDONLY, so set
+		 * the RDONLY flag and then mark the partition as valid again.
+		 */
+		down_write(&nilfs->ns_sem);
+		sbp = nilfs->ns_sbp;
+		if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
+		    (nilfs->ns_mount_state & NILFS_VALID_FS))
+			sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
+		sbp->s_mtime = cpu_to_le64(get_seconds());
+		nilfs_commit_super(sbi);
+		up_write(&nilfs->ns_sem);
+	} else {
+		/*
+		 * Mounting a RDONLY partition read-write, so reread and
+		 * store the current valid flag.  (It may have been changed
+		 * by fsck since we originally mounted the partition.)
+		 */
+		down(&sb->s_bdev->bd_mount_sem);
+		/* Check existing RW-mount */
+		if (test_exclusive_mount(sb->s_type, sb->s_bdev, 0)) {
+			printk(KERN_WARNING "NILFS (device %s): couldn't "
+			       "remount because a RW-mount exists.\n",
+			       sb->s_id);
+			err = -EBUSY;
+			goto rw_remount_failed;
+		}
+		if (sbi->s_snapshot_cno != nilfs_last_cno(nilfs)) {
+			printk(KERN_WARNING "NILFS (device %s): couldn't "
+			       "remount because the current RO-mount is not "
+			       "the latest one.\n",
+			       sb->s_id);
+			err = -EINVAL;
+			goto rw_remount_failed;
+		}
+		sb->s_flags &= ~MS_RDONLY;
+		nilfs_clear_opt(sbi, SNAPSHOT);
+		sbi->s_snapshot_cno = 0;
+
+		err = nilfs_attach_segment_constructor(sbi, NULL);
+		if (err)
+			goto rw_remount_failed;
+
+		down_write(&nilfs->ns_sem);
+		nilfs_setup_super(sbi);
+		up_write(&nilfs->ns_sem);
+
+		up(&sb->s_bdev->bd_mount_sem);
+	}
+ out:
+	return 0;
+
+ rw_remount_failed:
+	up(&sb->s_bdev->bd_mount_sem);
+ restore_opts:
+	sb->s_flags = old_sb_flags;
+	sbi->s_mount_opt = old_opts.mount_opt;
+	sbi->s_snapshot_cno = old_opts.snapshot_cno;
+	return err;
+}
+
+struct nilfs_super_data {
+	struct block_device *bdev;
+	__u64 cno;
+	int flags;
+};
+
+/**
+ * nilfs_identify - pre-read mount options needed to identify mount instance
+ * @data: mount options
+ * @sd: nilfs_super_data
+ */
+static int nilfs_identify(char *data, struct nilfs_super_data *sd)
+{
+	char *p, *options = data;
+	substring_t args[MAX_OPT_ARGS];
+	int option, token;
+	int ret = 0;
+
+	do {
+		p = strsep(&options, ",");
+		if (p != NULL && *p) {
+			token = match_token(p, tokens, args);
+			if (token == Opt_snapshot) {
+				if (!(sd->flags & MS_RDONLY))
+					ret++;
+				else {
+					ret = match_int(&args[0], &option);
+					if (!ret) {
+						if (option > 0)
+							sd->cno = option;
+						else
+							ret++;
+					}
+				}
+			}
+			if (ret)
+				printk(KERN_ERR
+				       "NILFS: invalid mount option: %s\n", p);
+		}
+		if (!options)
+			break;
+		BUG_ON(options == data);
+		*(options - 1) = ',';
+	} while (!ret);
+	return ret;
+}
+
+static int nilfs_set_bdev_super(struct super_block *s, void *data)
+{
+	struct nilfs_super_data *sd = data;
+
+	s->s_bdev = sd->bdev;
+	s->s_dev = s->s_bdev->bd_dev;
+	return 0;
+}
+
+static int nilfs_test_bdev_super(struct super_block *s, void *data)
+{
+	struct nilfs_super_data *sd = data;
+
+	return s->s_bdev == sd->bdev;
+}
+
+static int nilfs_test_bdev_super2(struct super_block *s, void *data)
+{
+	struct nilfs_super_data *sd = data;
+	int ret;
+
+	if (s->s_bdev != sd->bdev)
+		return 0;
+
+	if (!((s->s_flags | sd->flags) & MS_RDONLY))
+		return 1; /* Reuse an old R/W-mode super_block */
+
+	if (s->s_flags & sd->flags & MS_RDONLY) {
+		if (down_read_trylock(&s->s_umount)) {
+			ret = s->s_root &&
+				(sd->cno == NILFS_SB(s)->s_snapshot_cno);
+			up_read(&s->s_umount);
+			/*
+			 * This path is locked with sb_lock by sget().
+			 * So, drop_super() causes deadlock.
+			 */
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int
+nilfs_get_sb(struct file_system_type *fs_type, int flags,
+	     const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	struct nilfs_super_data sd;
+	struct super_block *s, *s2;
+	struct the_nilfs *nilfs = NULL;
+	int err, need_to_close = 1;
+
+	sd.bdev = open_bdev_excl(dev_name, flags, fs_type);
+	if (IS_ERR(sd.bdev))
+		return PTR_ERR(sd.bdev);
+
+	/*
+	 * To get mount instance using sget() vfs-routine, NILFS needs
+	 * much more information than normal filesystems to identify mount
+	 * instance.  For snapshot mounts, not only a mount type (ro-mount
+	 * or rw-mount) but also a checkpoint number is required.
+	 * The results are passed in sget() using nilfs_super_data.
+	 */
+	sd.cno = 0;
+	sd.flags = flags;
+	if (nilfs_identify((char *)data, &sd)) {
+		err = -EINVAL;
+		goto failed;
+	}
+
+	/*
+	 * once the super is inserted into the list by sget, s_umount
+	 * will protect the lockfs code from trying to start a snapshot
+	 * while we are mounting
+	 */
+	down(&sd.bdev->bd_mount_sem);
+	if (!sd.cno &&
+	    (err = test_exclusive_mount(fs_type, sd.bdev, flags ^ MS_RDONLY))) {
+		err = (err < 0) ? : -EBUSY;
+		goto failed_unlock;
+	}
+
+	/*
+	 * Phase-1: search any existent instance and get the_nilfs
+	 */
+	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, &sd);
+	if (IS_ERR(s))
+		goto error_s;
+
+	if (!s->s_root) {
+		err = -ENOMEM;
+		nilfs = alloc_nilfs(sd.bdev);
+		if (!nilfs)
+			goto cancel_new;
+	} else {
+		struct nilfs_sb_info *sbi = NILFS_SB(s);
+
+		BUG_ON(!sbi || !sbi->s_nilfs);
+		/*
+		 * s_umount protects super_block from unmount process;
+		 * It covers pointers of nilfs_sb_info and the_nilfs.
+		 */
+		nilfs = sbi->s_nilfs;
+		get_nilfs(nilfs);
+		up_write(&s->s_umount);
+
+		/*
+		 * Phase-2: search specified snapshot or R/W mode super_block
+		 */
+		if (!sd.cno)
+			/* trying to get the latest checkpoint.  */
+			sd.cno = nilfs_last_cno(nilfs);
+
+		s2 = sget(fs_type, nilfs_test_bdev_super2,
+			  nilfs_set_bdev_super, &sd);
+		deactivate_super(s);
+		/*
+		 * Although deactivate_super() invokes close_bdev_excl() at
+		 * kill_block_super().  Here, s is an existent mount; we need
+		 * one more close_bdev_excl() call.
+		 */
+		s = s2;
+		if (IS_ERR(s))
+			goto error_s;
+	}
+
+	if (!s->s_root) {
+		char b[BDEVNAME_SIZE];
+
+		s->s_flags = flags;
+		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
+		sb_set_blocksize(s, block_size(sd.bdev));
+
+		err = nilfs_fill_super(s, data, flags & MS_VERBOSE, nilfs);
+		if (err)
+			goto cancel_new;
+
+		s->s_flags |= MS_ACTIVE;
+		need_to_close = 0;
+	} else if (!(s->s_flags & MS_RDONLY)) {
+		err = -EBUSY;
+	}
+
+	up(&sd.bdev->bd_mount_sem);
+	put_nilfs(nilfs);
+	if (need_to_close)
+		close_bdev_excl(sd.bdev);
+	return simple_set_mnt(mnt, s);
+
+ error_s:
+	up(&sd.bdev->bd_mount_sem);
+	if (nilfs)
+		put_nilfs(nilfs);
+	close_bdev_excl(sd.bdev);
+	return PTR_ERR(s);
+
+ failed_unlock:
+	up(&sd.bdev->bd_mount_sem);
+ failed:
+	close_bdev_excl(sd.bdev);
+
+	return err;
+
+ cancel_new:
+	/* Abandoning the newly allocated superblock */
+	up(&sd.bdev->bd_mount_sem);
+	if (nilfs)
+		put_nilfs(nilfs);
+	up_write(&s->s_umount);
+	deactivate_super(s);
+	/*
+	 * deactivate_super() invokes close_bdev_excl().
+	 * We must finish all post-cleaning before this call;
+	 * put_nilfs() and unlocking bd_mount_sem need the block device.
+	 */
+	return err;
+}
+
+static int nilfs_test_bdev_super3(struct super_block *s, void *data)
+{
+	struct nilfs_super_data *sd = data;
+	int ret;
+
+	if (s->s_bdev != sd->bdev)
+		return 0;
+	if (down_read_trylock(&s->s_umount)) {
+		ret = (s->s_flags & MS_RDONLY) && s->s_root &&
+			nilfs_test_opt(NILFS_SB(s), SNAPSHOT);
+		up_read(&s->s_umount);
+		if (ret)
+			return 0; /* ignore snapshot mounts */
+	}
+	return !((sd->flags ^ s->s_flags) & MS_RDONLY);
+}
+
+static int __false_bdev_super(struct super_block *s, void *data)
+{
+#if 0 /* XXX: workaround for lock debug. This is not good idea */
+	up_write(&s->s_umount);
+#endif
+	return -EFAULT;
+}
+
+/**
+ * test_exclusive_mount - check whether an exclusive RW/RO mount exists or not.
+ * fs_type: filesystem type
+ * bdev: block device
+ * flag: 0 (check rw-mount) or MS_RDONLY (check ro-mount)
+ * res: pointer to an integer to store result
+ *
+ * This function must be called within a section protected by bd_mount_mutex.
+ */
+static int test_exclusive_mount(struct file_system_type *fs_type,
+				struct block_device *bdev, int flags)
+{
+	struct super_block *s;
+	struct nilfs_super_data sd = { .flags = flags, .bdev = bdev };
+
+	s = sget(fs_type, nilfs_test_bdev_super3, __false_bdev_super, &sd);
+	if (IS_ERR(s)) {
+		if (PTR_ERR(s) != -EFAULT)
+			return PTR_ERR(s);
+		return 0;  /* Not found */
+	}
+	up_write(&s->s_umount);
+	deactivate_super(s);
+	return 1;  /* Found */
+}
+
+struct file_system_type nilfs_fs_type = {
+	.owner    = THIS_MODULE,
+	.name     = "nilfs2",
+	.get_sb   = nilfs_get_sb,
+	.kill_sb  = kill_block_super,
+	.fs_flags = FS_REQUIRES_DEV,
+};
+
+static struct shrinker nilfs_shrinker = {
+	.shrink = nilfs_pages_shrink,
+	.seeks = DEFAULT_SEEKS,
+};
+
+static int __init init_nilfs_fs(void)
+{
+	int err;
+
+	nilfs_pages_init();
+
+	err = nilfs_init_inode_cache();
+	if (err)
+		goto failed;
+
+	err = nilfs_init_transaction_cache();
+	if (err)
+		goto failed_inode_cache;
+
+	err = nilfs_init_segbuf_cache();
+	if (err)
+		goto failed_transaction_cache;
+
+	register_shrinker(&nilfs_shrinker);
+
+	err = nilfs_btree_path_cache_init();
+	if (err)
+		goto failed_set_shrink;
+
+	err = register_filesystem(&nilfs_fs_type);
+	if (err)
+		goto failed_btree_path_cache;
+
+	return 0;
+
+ failed_btree_path_cache:
+	nilfs_btree_path_cache_destroy();
+
+ failed_set_shrink:
+	nilfs_destroy_segbuf_cache();
+
+ failed_transaction_cache:
+	nilfs_destroy_transaction_cache();
+
+ failed_inode_cache:
+	nilfs_destroy_inode_cache();
+
+ failed:
+	nilfs_pages_destroy();
+	return err;
+}
+
+static void __exit exit_nilfs_fs(void)
+{
+	unregister_shrinker(&nilfs_shrinker);
+	nilfs_destroy_segbuf_cache();
+	nilfs_destroy_transaction_cache();
+	nilfs_destroy_inode_cache();
+	nilfs_pages_destroy();
+	nilfs_btree_path_cache_destroy();
+	unregister_filesystem(&nilfs_fs_type);
+}
+
+module_init(init_nilfs_fs)
+module_exit(exit_nilfs_fs)
diff -puN /dev/null fs/nilfs2/the_nilfs.c
--- /dev/null
+++ a/fs/nilfs2/the_nilfs.c
@@ -0,0 +1,515 @@
+/*
+ * the_nilfs.c - the_nilfs shared structure.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/backing-dev.h>
+#include "nilfs.h"
+#include "segment.h"
+#include "cpfile.h"
+#include "sufile.h"
+#include "seglist.h"
+#include "segbuf.h"
+
+void nilfs_set_last_segment(struct the_nilfs *nilfs,
+			    sector_t start_blocknr, u64 seq, __u64 cno)
+{
+	spin_lock(&nilfs->ns_last_segment_lock);
+	nilfs->ns_last_pseg = start_blocknr;
+	nilfs->ns_last_seq = seq;
+	nilfs->ns_last_cno = cno;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+}
+
+/**
+ * alloc_nilfs - allocate the_nilfs structure
+ * @bdev: block device to which the_nilfs is related
+ *
+ * alloc_nilfs() allocates memory for the_nilfs and
+ * initializes its reference count and locks.
+ *
+ * Return Value: On success, pointer to the_nilfs is returned.
+ * On error, NULL is returned.
+ */
+struct the_nilfs *alloc_nilfs(struct block_device *bdev)
+{
+	struct the_nilfs *nilfs;
+
+	nilfs = kzalloc(sizeof(*nilfs), GFP_KERNEL);
+	if (!nilfs)
+		return NULL;
+
+	nilfs->ns_bdev = bdev;
+	atomic_set(&nilfs->ns_count, 1);
+	atomic_set(&nilfs->ns_writer_refcount, -1);
+	atomic_set(&nilfs->ns_ndirtyblks, 0);
+	init_rwsem(&nilfs->ns_sem);
+	mutex_init(&nilfs->ns_writer_mutex);
+	INIT_LIST_HEAD(&nilfs->ns_supers);
+	spin_lock_init(&nilfs->ns_last_segment_lock);
+	nilfs->ns_gc_inodes_h = NULL;
+	INIT_LIST_HEAD(&nilfs->ns_used_segments);
+	init_rwsem(&nilfs->ns_segctor_sem);
+	init_waitqueue_head(&nilfs->ns_cleanerd_wq);
+
+	return nilfs;
+}
+
+/**
+ * put_nilfs - release a reference to the_nilfs
+ * @nilfs: the_nilfs structure to be released
+ *
+ * put_nilfs() decrements a reference counter of the_nilfs.
+ * If the reference count reaches zero, the_nilfs is freed.
+ */
+void put_nilfs(struct the_nilfs *nilfs)
+{
+	if (!atomic_dec_and_test(&nilfs->ns_count))
+		return;
+	/*
+	 * Increment of ns_count never occur below because the caller
+	 * of get_nilfs() holds at least one reference to the_nilfs.
+	 * Thus its exclusion control is not required here.
+	 */
+	might_sleep();
+	if (nilfs_loaded(nilfs)) {
+		nilfs_dispose_used_segments(nilfs);
+		nilfs_mdt_clear(nilfs->ns_sufile);
+		nilfs_mdt_destroy(nilfs->ns_sufile);
+		nilfs_mdt_clear(nilfs->ns_cpfile);
+		nilfs_mdt_destroy(nilfs->ns_cpfile);
+		nilfs_mdt_clear(nilfs->ns_dat);
+		nilfs_mdt_destroy(nilfs->ns_dat);
+		/* XXX: how and when to clear nilfs->ns_gc_dat? */
+		nilfs_mdt_destroy(nilfs->ns_gc_dat);
+	}
+	if (nilfs_init(nilfs)) {
+		nilfs_destroy_gcinode(nilfs);
+		brelse(nilfs->ns_sbh);
+	}
+	kfree(nilfs);
+}
+
+static int nilfs_load_super_root(struct the_nilfs *nilfs,
+				 struct nilfs_sb_info *sbi, sector_t sr_block)
+{
+	struct buffer_head *bh_sr;
+	struct nilfs_super_root *raw_sr;
+	unsigned dat_entry_size, segment_usage_size, checkpoint_size;
+	unsigned inode_size;
+	int err;
+
+	err = nilfs_read_super_root_block(sbi->s_super, sr_block, &bh_sr, 1);
+	if (unlikely(err))
+		return err;
+
+	down_read(&nilfs->ns_sem);
+	dat_entry_size = le16_to_cpu(nilfs->ns_sbp->s_dat_entry_size);
+	checkpoint_size = le16_to_cpu(nilfs->ns_sbp->s_checkpoint_size);
+	segment_usage_size = le16_to_cpu(nilfs->ns_sbp->s_segment_usage_size);
+	up_read(&nilfs->ns_sem);
+
+	err = -ENOMEM;
+	nilfs->ns_dat = nilfs_mdt_new_with_blockgroup(
+		nilfs, NULL, NILFS_DAT_INO, NILFS_DAT_GFP, dat_entry_size,
+		NILFS_DAT_GROUPS_COUNT(nilfs->ns_blocksize_bits));
+	if (unlikely(!nilfs->ns_dat))
+		goto out;
+
+	nilfs->ns_gc_dat = nilfs_mdt_new_with_blockgroup(
+		nilfs, NULL, NILFS_DAT_INO, NILFS_DAT_GFP, dat_entry_size,
+		NILFS_DAT_GROUPS_COUNT(nilfs->ns_blocksize_bits));
+	if (unlikely(!nilfs->ns_gc_dat))
+		goto failed_dat;
+
+	nilfs_mdt_set_shadow(nilfs->ns_dat, nilfs->ns_gc_dat);
+
+	nilfs->ns_cpfile = nilfs_mdt_new(
+		nilfs, NULL, NILFS_CPFILE_INO, NILFS_CPFILE_GFP);
+	if (unlikely(!nilfs->ns_cpfile))
+		goto failed_gc_dat;
+
+	nilfs->ns_sufile = nilfs_mdt_new(
+		nilfs, NULL, NILFS_SUFILE_INO, NILFS_SUFILE_GFP);
+	if (unlikely(!nilfs->ns_sufile))
+		goto failed_checkpoint;
+
+	nilfs_mdt_set_entry_size(nilfs->ns_cpfile, checkpoint_size);
+	nilfs_mdt_set_entry_size(nilfs->ns_sufile, segment_usage_size);
+
+	inode_size = nilfs->ns_inode_size;
+
+	err = nilfs_mdt_read_inode_direct(
+		nilfs->ns_dat, bh_sr, NILFS_SR_DAT_OFFSET(inode_size));
+	if (unlikely(err))
+		goto failed_su;
+
+	err = nilfs_mdt_read_inode_direct(
+		nilfs->ns_cpfile, bh_sr, NILFS_SR_CPFILE_OFFSET(inode_size));
+	if (unlikely(err))
+		goto failed_su;
+
+	err = nilfs_mdt_read_inode_direct(
+		nilfs->ns_sufile, bh_sr, NILFS_SR_SUFILE_OFFSET(inode_size));
+	if (unlikely(err))
+		goto failed_su;
+
+	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
+	nilfs->ns_nongc_ctime = le64_to_cpu(raw_sr->sr_nongc_ctime);
+
+ out:
+	brelse(bh_sr);
+	return err;
+
+ failed_su:
+	nilfs_mdt_destroy(nilfs->ns_sufile);
+
+ failed_checkpoint:
+	nilfs_mdt_destroy(nilfs->ns_cpfile);
+
+ failed_gc_dat:
+	nilfs_mdt_destroy(nilfs->ns_gc_dat);
+
+ failed_dat:
+	nilfs_mdt_destroy(nilfs->ns_dat);
+	goto out;
+}
+
+static void nilfs_init_recovery_info(struct nilfs_recovery_info *ri)
+{
+	memset(ri, 0, sizeof(*ri));
+	INIT_LIST_HEAD(&ri->ri_used_segments);
+}
+
+static void nilfs_clear_recovery_info(struct nilfs_recovery_info *ri)
+{
+	nilfs_dispose_segment_list(&ri->ri_used_segments);
+}
+
+/**
+ * load_nilfs - load and recover the nilfs
+ * @nilfs: the_nilfs structure to be released
+ * @sbi: nilfs_sb_info used to recover past segment
+ *
+ * load_nilfs() searches and load the latest super root,
+ * attaches the last segment, and does recovery if needed.
+ * The caller must call this exclusively for simultaneous mounts.
+ */
+int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
+{
+	struct nilfs_recovery_info ri;
+	unsigned int s_flags = sbi->s_super->s_flags;
+	int really_read_only = bdev_read_only(nilfs->ns_bdev);
+	unsigned valid_fs;
+	int err = 0;
+
+	nilfs_init_recovery_info(&ri);
+
+	down_write(&nilfs->ns_sem);
+	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
+	up_write(&nilfs->ns_sem);
+
+	if (!valid_fs && (s_flags & MS_RDONLY)) {
+		printk(KERN_INFO "NILFS: INFO: recovery "
+		       "required for readonly filesystem.\n");
+		if (really_read_only) {
+			printk(KERN_ERR "NILFS: write access "
+			       "unavailable, cannot proceed.\n");
+			err = -EROFS;
+			goto failed;
+		}
+		printk(KERN_INFO "NILFS: write access will "
+		       "be enabled during recovery.\n");
+		sbi->s_super->s_flags &= ~MS_RDONLY;
+	}
+
+	err = nilfs_search_super_root(nilfs, sbi, &ri);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: error searching super root.\n");
+		goto failed;
+	}
+
+	err = nilfs_load_super_root(nilfs, sbi, ri.ri_super_root);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: error loading super root.\n");
+		goto failed;
+	}
+
+	if (!valid_fs) {
+		err = nilfs_recover_logical_segments(nilfs, sbi, &ri);
+		if (unlikely(err)) {
+			nilfs_mdt_destroy(nilfs->ns_cpfile);
+			nilfs_mdt_destroy(nilfs->ns_sufile);
+			nilfs_mdt_destroy(nilfs->ns_dat);
+			goto failed;
+		}
+		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED) {
+			down_write(&nilfs->ns_sem);
+			nilfs_update_last_segment(sbi, 0);
+			up_write(&nilfs->ns_sem);
+		}
+	}
+
+	set_nilfs_loaded(nilfs);
+
+ failed:
+	nilfs_clear_recovery_info(&ri);
+	sbi->s_super->s_flags = s_flags;
+	return err;
+}
+
+static unsigned long long nilfs_max_size(unsigned int blkbits)
+{
+	unsigned int max_bits;
+	unsigned long long res = MAX_LFS_FILESIZE; /* page cache limit */
+
+	max_bits = blkbits + NILFS_BMAP_KEY_BIT; /* bmap size limit */
+	if (max_bits < 64)
+		res = min_t(unsigned long long, res, (1ULL << max_bits) - 1);
+	return res;
+}
+
+static int
+nilfs_store_disk_layout(struct the_nilfs *nilfs, struct super_block *sb,
+			struct nilfs_super_block *sbp)
+{
+	if (le32_to_cpu(sbp->s_rev_level) != NILFS_CURRENT_REV) {
+		printk(KERN_ERR "NILFS: revision mismatch "
+		       "(superblock rev.=%d.%d, current rev.=%d.%d). "
+		       "Please check the version of mkfs.nilfs.\n",
+		       le32_to_cpu(sbp->s_rev_level),
+		       le16_to_cpu(sbp->s_minor_rev_level),
+		       NILFS_CURRENT_REV, NILFS_MINOR_REV);
+		return -EINVAL;
+	}
+	nilfs->ns_inode_size = le16_to_cpu(sbp->s_inode_size);
+	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
+
+	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
+	if (nilfs->ns_blocks_per_segment < NILFS_SEG_MIN_BLOCKS) {
+		printk(KERN_ERR "NILFS: too short segment. \n");
+		return -EINVAL;
+	}
+
+	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
+	nilfs->ns_nsegments = le64_to_cpu(sbp->s_nsegments);
+	nilfs->ns_r_segments_percentage =
+		le32_to_cpu(sbp->s_r_segments_percentage);
+	nilfs->ns_nrsvsegs = max_t(unsigned long, NILFS_MIN_NRSVSEGS,
+				   (nilfs->ns_nsegments *
+				    nilfs->ns_r_segments_percentage - 1) /
+				   100 + 1);
+	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
+	return 0;
+}
+
+/**
+ * init_nilfs - initialize a NILFS instance.
+ * @nilfs: the_nilfs structure
+ * @sbi: nilfs_sb_info
+ * @sb: super block
+ * @data: mount options
+ *
+ * init_nilfs() performs common initialization per block device (e.g.
+ * reading the super block, getting disk layout information, initializing
+ * shared fields in the_nilfs). It takes on some portion of the jobs
+ * typically done by a fill_super() routine. This division arises from
+ * the nature that multiple NILFS instances may be simultaneously
+ * mounted on a device.
+ * For multiple mounts on the same device, only the first mount
+ * invokes these tasks.
+ *
+ * Return Value: On success, 0 is returned. On error, a negative error
+ * code is returned.
+ */
+int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
+{
+	struct super_block *sb = sbi->s_super;
+	struct buffer_head *sbh;
+	struct nilfs_super_block *sbp;
+	struct backing_dev_info *bdi;
+	int blocksize;
+	int err = 0;
+
+	down_write(&nilfs->ns_sem);
+	if (nilfs_init(nilfs)) {
+		/* Load values from existing the_nilfs */
+		sbp = nilfs->ns_sbp;
+		err = nilfs_store_magic_and_option(sb, sbp, data);
+		if (err)
+			goto out;
+
+		blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
+		if (sb->s_blocksize != blocksize &&
+		    !sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "NILFS: blocksize %d unfit to device\n",
+			       blocksize);
+			err = -EINVAL;
+		}
+		sb->s_maxbytes = nilfs_max_size(sb->s_blocksize_bits);
+		goto out;
+	}
+
+	sbp = nilfs_load_super_block(sb, &sbh);
+	if (!sbp) {
+		err = -EINVAL;
+		goto out;
+	}
+	err = nilfs_store_magic_and_option(sb, sbp, data);
+	if (err)
+		goto failed_sbh;
+
+	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
+	if (sb->s_blocksize != blocksize) {
+		sbp = nilfs_reload_super_block(sb, &sbh, blocksize);
+		if (!sbp) {
+			err = -EINVAL;
+			goto out;
+			/* not failed_sbh; sbh is released automatically
+			   when reloading fails. */
+		}
+	}
+	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
+
+	err = nilfs_store_disk_layout(nilfs, sb, sbp);
+	if (err)
+		goto failed_sbh;
+
+	sb->s_maxbytes = nilfs_max_size(sb->s_blocksize_bits);
+
+	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
+	nilfs->ns_sbh = sbh;
+	nilfs->ns_sbp = sbp;
+
+	bdi = nilfs->ns_bdev->bd_inode_backing_dev_info;
+	if (!bdi)
+		bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
+	nilfs->ns_bdi = bdi ? : &default_backing_dev_info;
+
+	/* Finding last segment */
+	nilfs->ns_last_pseg = le64_to_cpu(sbp->s_last_pseg);
+	nilfs->ns_last_cno = le64_to_cpu(sbp->s_last_cno);
+	nilfs->ns_last_seq = le64_to_cpu(sbp->s_last_seq);
+
+	nilfs->ns_seg_seq = nilfs->ns_last_seq;
+	nilfs->ns_segnum =
+		nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
+	nilfs->ns_cno = nilfs->ns_last_cno + 1;
+	if (nilfs->ns_segnum >= nilfs->ns_nsegments) {
+		printk(KERN_ERR "NILFS invalid last segment number.\n");
+		err = -EINVAL;
+		goto failed_sbh;
+	}
+	/* Dummy values  */
+	nilfs->ns_free_segments_count =
+		nilfs->ns_nsegments - (nilfs->ns_segnum + 1);
+
+	/* Initialize gcinode cache */
+	err = nilfs_init_gcinode(nilfs);
+	if (err)
+		goto failed_sbh;
+
+	set_nilfs_init(nilfs);
+	err = 0;
+ out:
+	up_write(&nilfs->ns_sem);
+	return err;
+
+ failed_sbh:
+	brelse(sbh);
+	goto out;
+}
+
+int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
+{
+	struct inode *dat = nilfs_dat_inode(nilfs);
+	unsigned long ncleansegs;
+	int err;
+
+	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	err = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile, &ncleansegs);
+	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	if (likely(!err))
+		*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
+	return err;
+}
+
+void nilfs_dispose_used_segments(struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_entry *ent, *n;
+
+	/* nilfs->sem must be locked by the caller. */
+	if (!nilfs_loaded(nilfs))
+		return;
+
+	list_for_each_entry_safe(ent, n, &nilfs->ns_used_segments, list) {
+		list_del_init(&ent->list);
+		nilfs_segment_usage_clear_volatile_active(ent->raw_su);
+		nilfs_close_segment_entry(ent, nilfs->ns_sufile);
+		nilfs_free_segment_entry(ent);
+	}
+}
+
+int nilfs_near_disk_full(struct the_nilfs *nilfs)
+{
+	struct inode *sufile = nilfs->ns_sufile;
+	unsigned long ncleansegs, nincsegs;
+	int ret;
+
+	ret = nilfs_sufile_get_ncleansegs(sufile, &ncleansegs);
+	if (likely(!ret)) {
+		nincsegs = atomic_read(&nilfs->ns_ndirtyblks) /
+			nilfs->ns_blocks_per_segment + 1;
+		if (ncleansegs <= nilfs->ns_nrsvsegs + nincsegs)
+			ret++;
+	}
+	return ret;
+}
+
+int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
+				int snapshot_mount)
+{
+	struct nilfs_sb_info *sbi;
+	int ret = 0;
+
+	down_read(&nilfs->ns_sem);
+	if (cno == 0 || cno > nilfs->ns_cno)
+		goto out_unlock;
+
+	list_for_each_entry(sbi, &nilfs->ns_supers, s_list) {
+		if (sbi->s_snapshot_cno == cno &&
+		    (!snapshot_mount || nilfs_test_opt(sbi, SNAPSHOT))) {
+					/* exclude read-only mounts */
+			ret++;
+			break;
+		}
+	}
+	/* for protecting recent checkpoints */
+	if (cno >= nilfs_last_cno(nilfs))
+		ret++;
+
+ out_unlock:
+	up_read(&nilfs->ns_sem);
+	return ret;
+}
diff -puN /dev/null fs/nilfs2/the_nilfs.h
--- /dev/null
+++ a/fs/nilfs2/the_nilfs.h
@@ -0,0 +1,286 @@
+/*
+ * the_nilfs.h - the_nilfs shared structure.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#ifndef _THE_NILFS_H
+#define _THE_NILFS_H
+
+/* the_nilfs struct */
+enum {
+	THE_NILFS_INIT = 0,     /* Information from super_block is set */
+	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
+				   the latest checkpoint was loaded */
+	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
+	THE_NILFS_COND_NONGC_WRITE,	/* Condition to wake up cleanerd */
+};
+
+/**
+ * struct the_nilfs - struct to supervise multiple nilfs mount points
+ * @ns_flags: flags
+ * @ns_count: reference count
+ * @ns_bdev: block device
+ * @ns_bdi: backing dev info
+ * @ns_writer: back pointer to writable nilfs_sb_info
+ * @ns_sem: semaphore for shared states
+ * @ns_writer_mutex: mutex protecting ns_writer attach/detach
+ * @ns_writer_refcount: number of referrers on ns_writer
+ * @ns_sbh: buffer head of the on-disk super block
+ * @ns_sbp: pointer to the super block data
+ * @ns_used_segments: list of full segments in volatile active state
+ * @ns_supers: list of nilfs super block structs
+ * @ns_seg_seq: segment sequence counter
+ * @ns_segnum: index number of the latest full segment.
+ * @ns_nextnum: index number of the full segment index to be used next
+ * @ns_pseg_offset: offset of next partial segment in the current full segment
+ * @ns_cno: next checkpoint number
+ * @ns_ctime: write time of the last segment
+ * @ns_nongc_ctime: write time of the last segment not for cleaner operation
+ * @ns_ndirtyblks: Number of dirty data blocks
+ * @ns_last_segment_lock: lock protecting fields for the latest segment
+ * @ns_last_pseg: start block number of the latest segment
+ * @ns_last_seq: sequence value of the latest segment
+ * @ns_last_cno: checkpoint number of the latest segment
+ * @ns_free_segments_count: counter of free segments
+ * @ns_segctor_sem: segment constructor semaphore
+ * @ns_dat: DAT file inode
+ * @ns_cpfile: checkpoint file inode
+ * @ns_sufile: segusage file inode
+ * @ns_gc_dat: shadow inode of the DAT file inode for GC
+ * @ns_gc_inode_lock: lock for gc inode list/hlist operations
+ * @ns_gc_inodes: dummy inodes to keep live blocks
+ * @ns_gc_inodes_h: hash list to keep dummy inode holding live blocks
+ * @ns_cleanerd_wq: wait queue for cleanerd
+ * @ns_blocksize_bits: bit length of block size
+ * @ns_nsegments: number of segments in filesystem
+ * @ns_blocks_per_segment: number of blocks per segment
+ * @ns_r_segments_percentage: reserved segments percentage
+ * @ns_nrsvsegs: number of reserved segments
+ * @ns_first_data_block: block number of first data block
+ * @ns_inode_size: size of on-disk inode
+ * @ns_first_ino: first not-special inode number
+ * @ns_crc_seed: seed value of CRC32 calculation
+ */
+struct the_nilfs {
+	unsigned long		ns_flags;
+	atomic_t		ns_count;
+
+	struct block_device    *ns_bdev;
+	struct backing_dev_info *ns_bdi;
+	struct nilfs_sb_info   *ns_writer;
+	struct rw_semaphore	ns_sem;
+	struct mutex		ns_writer_mutex;
+	atomic_t		ns_writer_refcount;
+
+	/*
+	 * used for
+	 * - loading the latest checkpoint exclusively.
+	 * - allocating a new full segment.
+	 * - protecting s_dirt in the super_block struct
+	 *   (see nilfs_write_super) and the following fields.
+	 */
+	struct buffer_head     *ns_sbh;
+	struct nilfs_super_block *ns_sbp;
+	struct list_head	ns_used_segments;
+	unsigned		ns_mount_state;
+	struct list_head	ns_supers;
+
+	/*
+	 * Following fields are dedicated to a writable FS-instance.
+	 * Except for the period seeking checkpoint, code outside the segment
+	 * constructor must lock a segment semaphore with transaction_begin()
+	 * and transaction_end(), when accessing these fields.
+	 * The writable FS-instance is sole during a lifetime of the_nilfs.
+	 */
+	u64			ns_seg_seq;
+	__u64			ns_segnum;
+	__u64			ns_nextnum;
+	unsigned long		ns_pseg_offset;
+	__u64			ns_cno;
+	time_t			ns_ctime;
+	time_t			ns_nongc_ctime;
+	atomic_t		ns_ndirtyblks;
+
+	/*
+	 * The following fields hold information on the latest partial segment
+	 * written to disk with a super root.  These fields are protected by
+	 * ns_last_segment_lock.
+	 */
+	spinlock_t		ns_last_segment_lock;
+	sector_t		ns_last_pseg;
+	u64			ns_last_seq;
+	__u64			ns_last_cno;
+	unsigned long		ns_free_segments_count;
+
+	struct rw_semaphore	ns_segctor_sem;
+
+	/*
+	 * Following fields are lock free except for the period before
+	 * the_nilfs is initialized.
+	 */
+	struct inode	       *ns_dat;
+	struct inode	       *ns_cpfile;
+	struct inode	       *ns_sufile;
+	struct inode	       *ns_gc_dat;
+
+	/* GC inode list and hash table head */
+	spinlock_t		ns_gc_inode_lock;
+	struct list_head	ns_gc_inodes;
+	struct hlist_head      *ns_gc_inodes_h;
+
+	/* cleanerd */
+	wait_queue_head_t	ns_cleanerd_wq;
+
+	/* Disk layout information (static) */
+	unsigned int		ns_blocksize_bits;
+	unsigned long		ns_nsegments;
+	unsigned long		ns_blocks_per_segment;
+	unsigned long		ns_r_segments_percentage;
+	unsigned long		ns_nrsvsegs;
+	unsigned long		ns_first_data_block;
+	int			ns_inode_size;
+	int			ns_first_ino;
+	u32			ns_crc_seed;
+};
+
+#define NILFS_GCINODE_HASH_BITS		8
+#define NILFS_GCINODE_HASH_SIZE		(1<<NILFS_GCINODE_HASH_BITS)
+
+
+#define THE_NILFS_FNS(bit, name)					\
+static inline void set_nilfs_##name(struct the_nilfs *nilfs)		\
+{									\
+	set_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);			\
+}									\
+static inline void clear_nilfs_##name(struct the_nilfs *nilfs)		\
+{									\
+	clear_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);			\
+}									\
+static inline int nilfs_##name(struct the_nilfs *nilfs)			\
+{									\
+	return test_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);		\
+}
+
+THE_NILFS_FNS(INIT, init)
+THE_NILFS_FNS(LOADED, loaded)
+THE_NILFS_FNS(DISCONTINUED, discontinued)
+THE_NILFS_FNS(COND_NONGC_WRITE, cond_nongc_write)
+
+void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
+struct the_nilfs *alloc_nilfs(struct block_device *);
+void put_nilfs(struct the_nilfs *);
+int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
+int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
+int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
+void nilfs_dispose_used_segments(struct the_nilfs *);
+int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
+int nilfs_near_disk_full(struct the_nilfs *);
+
+
+static inline void get_nilfs(struct the_nilfs *nilfs)
+{
+	/* Caller must have at least one reference of the_nilfs. */
+	atomic_inc(&nilfs->ns_count);
+}
+
+static inline struct nilfs_sb_info *nilfs_get_writer(struct the_nilfs *nilfs)
+{
+	if (atomic_inc_and_test(&nilfs->ns_writer_refcount))
+		mutex_lock(&nilfs->ns_writer_mutex);
+	return nilfs->ns_writer;
+}
+
+static inline void nilfs_put_writer(struct the_nilfs *nilfs)
+{
+	if (atomic_add_negative(-1, &nilfs->ns_writer_refcount))
+		mutex_unlock(&nilfs->ns_writer_mutex);
+}
+
+static inline void
+nilfs_attach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
+{
+	mutex_lock(&nilfs->ns_writer_mutex);
+	nilfs->ns_writer = sbi;
+	mutex_unlock(&nilfs->ns_writer_mutex);
+}
+
+static inline void
+nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
+{
+	mutex_lock(&nilfs->ns_writer_mutex);
+	if (sbi == nilfs->ns_writer)
+		nilfs->ns_writer = NULL;
+	mutex_unlock(&nilfs->ns_writer_mutex);
+}
+
+static inline void
+nilfs_get_segment_range(struct the_nilfs *nilfs, __u64 segnum,
+			sector_t *seg_start, sector_t *seg_end)
+{
+	*seg_start = (sector_t)nilfs->ns_blocks_per_segment * segnum;
+	*seg_end = *seg_start + nilfs->ns_blocks_per_segment - 1;
+	if (segnum == 0)
+		*seg_start = nilfs->ns_first_data_block;
+}
+
+static inline sector_t
+nilfs_get_segment_start_blocknr(struct the_nilfs *nilfs, __u64 segnum)
+{
+	return (segnum == 0) ? nilfs->ns_first_data_block :
+		(sector_t)nilfs->ns_blocks_per_segment * segnum;
+}
+
+static inline __u64
+nilfs_get_segnum_of_block(struct the_nilfs *nilfs, sector_t blocknr)
+{
+	sector_t segnum = blocknr;
+
+	sector_div(segnum, nilfs->ns_blocks_per_segment);
+	return segnum;
+}
+
+static inline void
+nilfs_terminate_segment(struct the_nilfs *nilfs, sector_t seg_start,
+			sector_t seg_end)
+{
+	/* terminate the current full segment (used in case of I/O-error) */
+	nilfs->ns_pseg_offset = seg_end - seg_start + 1;
+}
+
+static inline void nilfs_shift_to_next_segment(struct the_nilfs *nilfs)
+{
+	/* move forward with a full segment */
+	nilfs->ns_segnum = nilfs->ns_nextnum;
+	nilfs->ns_pseg_offset = 0;
+	nilfs->ns_seg_seq++;
+}
+
+static inline __u64 nilfs_last_cno(struct the_nilfs *nilfs)
+{
+	__u64 cno;
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	cno = nilfs->ns_last_cno;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+	return cno;
+}
+
+#endif /* _THE_NILFS_H */
diff -puN /dev/null include/linux/nilfs2_fs.h
--- /dev/null
+++ a/include/linux/nilfs2_fs.h
@@ -0,0 +1,867 @@
+/*
+ * nilfs2_fs.h - NILFS2 on-disk structures and common declarations.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+/*
+ *  linux/include/linux/ext2_fs.h
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/include/linux/minix_fs.h
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ */
+
+#ifndef _LINUX_NILFS_FS_H
+#define _LINUX_NILFS_FS_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/*
+ * Inode flags stored in nilfs_inode and on-memory nilfs inode
+ *
+ * We define these flags based on ext2-fs because of the
+ * compatibility reason; to avoid problems in chattr(1)
+ */
+#define NILFS_SECRM_FL		0x00000001 /* Secure deletion */
+#define NILFS_UNRM_FL		0x00000002 /* Undelete */
+#define NILFS_SYNC_FL		0x00000008 /* Synchronous updates */
+#define NILFS_IMMUTABLE_FL	0x00000010 /* Immutable file */
+#define NILFS_APPEND_FL		0x00000020 /* writes to file may only append */
+#define NILFS_NODUMP_FL		0x00000040 /* do not dump file */
+#define NILFS_NOATIME_FL	0x00000080 /* do not update atime */
+/* Reserved for compression usage... */
+#define NILFS_NOTAIL_FL		0x00008000 /* file tail should not be merged */
+#define NILFS_DIRSYNC_FL	0x00010000 /* dirsync behaviour */
+
+#define NILFS_FL_USER_VISIBLE	0x0003DFFF /* User visible flags */
+#define NILFS_FL_USER_MODIFIABLE	0x000380FF /* User modifiable flags */
+
+/* Flags for inode allocators */
+#define NILFS_INODE_NEW		0x10000000 /* i_mode has free link chain */
+#define NILFS_INODE_UNUSED	0x20000000 /* i_mode has free link chain */
+
+
+#define NILFS_INODE_BMAP_SIZE	7
+/**
+ * struct nilfs_inode - structure of an inode on disk
+ * @i_blocks: blocks count
+ * @i_size: size in bytes
+ * @i_ctime: creation time
+ * @i_mtime: modification time
+ * @i_dtime: deletion time
+ * @i_uid: user id
+ * @i_gid: group id
+ * @i_mode: file mode
+ * @i_links_count: links count
+ * @i_flags: file flags
+ * @i_bmap: block mapping
+ * @i_xattr: extended attributes
+ * @i_generation: file generation (for NFS)
+ * @i_pad:	padding
+ */
+struct nilfs_inode {
+	__le64	i_blocks;
+	__le64	i_size;
+	__le64	i_ctime;
+	__le64	i_mtime;
+	__le64	i_dtime;
+	__le32	i_uid;
+	__le32	i_gid;
+	__le16	i_mode;
+	__le16	i_links_count;
+	__le32	i_flags;
+	__le64	i_bmap[NILFS_INODE_BMAP_SIZE];
+#define i_device_code	i_bmap[0]
+	__le64	i_xattr;
+	__le32	i_generation;
+	__le32	i_pad;
+};
+
+/**
+ * struct nilfs_super_root - structure of super root
+ * @sr_sum: check sum
+ * @sr_bytes: byte count of the structure
+ * @sr_flags: flags (reserved)
+ * @sr_nongc_ctime: write time of the last segment not for cleaner operation
+ * @sr_dat: DAT file inode
+ * @sr_cpfile: checkpoint file inode
+ * @sr_sufile: segment usage file inode
+ */
+struct nilfs_super_root {
+	__le32 sr_sum;
+	__le16 sr_bytes;
+	__le16 sr_flags;
+	__le64 sr_nongc_ctime;
+	struct nilfs_inode sr_dat;
+	struct nilfs_inode sr_cpfile;
+	struct nilfs_inode sr_sufile;
+};
+
+#define NILFS_SR_MDT_OFFSET(inode_size, i)  \
+	((unsigned long)&((struct nilfs_super_root *)0)->sr_dat + \
+			(inode_size) * (i))
+#define NILFS_SR_DAT_OFFSET(inode_size)     NILFS_SR_MDT_OFFSET(inode_size, 0)
+#define NILFS_SR_CPFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 1)
+#define NILFS_SR_SUFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 2)
+#define NILFS_SR_BYTES                  (sizeof(struct nilfs_super_root))
+
+/*
+ * Maximal mount counts
+ */
+#define NILFS_DFL_MAX_MNT_COUNT		50      /* 50 mounts */
+
+/*
+ * Retry count for IO errors
+ *
+ * Basically retry for the same block is entrusted to device drivers.
+ * Recovery process gives up any further attempts to find a last valid
+ * segment when IO errors repeatedly occur.
+ */
+#define NILFS_EIO_RETRY_COUNT		4
+
+/*
+ * File system states (sbp->s_state, nilfs->ns_mount_state)
+ */
+#define NILFS_VALID_FS			0x0001  /* Unmounted cleanly */
+#define NILFS_ERROR_FS			0x0002  /* Errors detected */
+#define NILFS_RESIZE_FS			0x0004	/* Resize required */
+
+/*
+ * Mount flags (sbi->s_mount_opt)
+ */
+#define NILFS_MOUNT_ERROR_MODE		0x0070  /* Error mode mask */
+#define NILFS_MOUNT_ERRORS_CONT		0x0010  /* Continue on errors */
+#define NILFS_MOUNT_ERRORS_RO		0x0020  /* Remount fs ro on errors */
+#define NILFS_MOUNT_ERRORS_PANIC	0x0040  /* Panic on errors */
+#define NILFS_MOUNT_SNAPSHOT		0x0080  /* Snapshot flag */
+#define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
+#define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
+						   semantics also for data */
+
+
+/**
+ * struct nilfs_super_block - structure of super block on disk
+ */
+struct nilfs_super_block {
+	__le32	s_rev_level;		/* Revision level */
+	__le16	s_minor_rev_level;	/* minor revision level */
+	__le16	s_magic;		/* Magic signature */
+
+	__le16  s_bytes;		/* Bytes count of CRC calculation
+					   for this structure. s_reserved
+					   is excluded. */
+	__le16  s_flags;		/* flags */
+	__le32  s_crc_seed;		/* Seed value of CRC calculation */
+	__le32	s_sum;			/* Check sum of super block */
+
+	__le32	s_log_block_size;	/* Block size represented as follows
+					   blocksize =
+					       1 << (s_log_block_size + 10) */
+	__le64  s_nsegments;		/* Number of segments in filesystem */
+	__le64  s_dev_size;		/* block device size in bytes */
+	__le64	s_first_data_block;	/* 1st seg disk block number */
+	__le32  s_blocks_per_segment;   /* number of blocks per full segment */
+	__le32	s_r_segments_percentage; /* Reserved segments percentage */
+
+	__le64  s_last_cno;		/* Last checkpoint number */
+	__le64  s_last_pseg;		/* disk block addr pseg written last */
+	__le64  s_last_seq;             /* seq. number of seg written last */
+	__le64	s_free_blocks_count;	/* Free blocks count */
+
+	__le64	s_ctime;		/* Creation time (execution time of
+					   newfs) */
+	__le64	s_mtime;		/* Mount time */
+	__le64	s_wtime;		/* Write time */
+	__le16	s_mnt_count;		/* Mount count */
+	__le16	s_max_mnt_count;	/* Maximal mount count */
+	__le16	s_state;		/* File system state */
+	__le16	s_errors;		/* Behaviour when detecting errors */
+	__le64	s_lastcheck;		/* time of last check */
+
+	__le32	s_checkinterval;	/* max. time between checks */
+	__le32	s_creator_os;		/* OS */
+	__le16	s_def_resuid;		/* Default uid for reserved blocks */
+	__le16	s_def_resgid;		/* Default gid for reserved blocks */
+	__le32	s_first_ino; 		/* First non-reserved inode */
+
+	__le16  s_inode_size; 		/* Size of an inode */
+	__le16  s_dat_entry_size;       /* Size of a dat entry */
+	__le16  s_checkpoint_size;      /* Size of a checkpoint */
+	__le16	s_segment_usage_size;	/* Size of a segment usage */
+
+	__u8	s_uuid[16];		/* 128-bit uuid for volume */
+	char	s_volume_name[16]; 	/* volume name */
+	char	s_last_mounted[64]; 	/* directory where last mounted */
+
+	__le32  s_c_interval;           /* Commit interval of segment */
+	__le32  s_c_block_max;          /* Threshold of data amount for
+					   the segment construction */
+	__u32	s_reserved[192];	/* padding to the end of the block */
+};
+
+/*
+ * Codes for operating systems
+ */
+#define NILFS_OS_LINUX		0
+/* Codes from 1 to 4 are reserved to keep compatibility with ext2 creator-OS */
+
+/*
+ * Revision levels
+ */
+#define NILFS_CURRENT_REV	2	/* current major revision */
+#define NILFS_MINOR_REV		0	/* minor revision */
+
+/*
+ * Bytes count of super_block for CRC-calculation
+ */
+#define NILFS_SB_BYTES  \
+	((long)&((struct nilfs_super_block *)0)->s_reserved)
+
+/*
+ * Special inode number
+ */
+#define NILFS_ROOT_INO		2	/* Root file inode */
+#define NILFS_DAT_INO		3	/* DAT file */
+#define NILFS_CPFILE_INO	4	/* checkpoint file */
+#define NILFS_SUFILE_INO	5	/* segment usage file */
+#define NILFS_IFILE_INO		6	/* ifile */
+#define NILFS_ATIME_INO		7	/* Atime file (reserved) */
+#define NILFS_XATTR_INO		8	/* Xattribute file (reserved) */
+#define NILFS_SKETCH_INO	10	/* Sketch file */
+#define NILFS_USER_INO		11	/* Fisrt user's file inode number */
+
+#define NILFS_SB_OFFSET_BYTES	1024	/* byte offset of nilfs superblock */
+#define NILFS_SUPER_MAGIC	0x3434	/* NILFS filesystem  magic number */
+
+#define NILFS_SEG_MIN_BLOCKS	16	/* Minimum number of blocks in
+					   a full segment */
+#define NILFS_PSEG_MIN_BLOCKS	2	/* Minimum number of blocks in
+					   a partial segment */
+#define NILFS_MIN_NRSVSEGS	8	/* Minimum number of reserved
+					   segments */
+
+
+/*
+ * Maximal count of links to a file
+ */
+#define NILFS_LINK_MAX		32000
+
+/*
+ * Structure of a directory entry
+ *  (Same as ext2)
+ */
+
+#define NILFS_NAME_LEN 255
+
+/*
+ * The new version of the directory entry.  Since V0 structures are
+ * stored in intel byte order, and the name_len field could never be
+ * bigger than 255 chars, it's safe to reclaim the extra byte for the
+ * file_type field.
+ */
+struct nilfs_dir_entry {
+	__le64	inode;			/* Inode number */
+	__le16	rec_len;		/* Directory entry length */
+	__u8	name_len;		/* Name length */
+	__u8	file_type;
+	char	name[NILFS_NAME_LEN];	/* File name */
+	char    pad;
+};
+
+/*
+ * NILFS directory file types.  Only the low 3 bits are used.  The
+ * other bits are reserved for now.
+ */
+enum {
+	NILFS_FT_UNKNOWN,
+	NILFS_FT_REG_FILE,
+	NILFS_FT_DIR,
+	NILFS_FT_CHRDEV,
+	NILFS_FT_BLKDEV,
+	NILFS_FT_FIFO,
+	NILFS_FT_SOCK,
+	NILFS_FT_SYMLINK,
+	NILFS_FT_MAX
+};
+
+/*
+ * NILFS_DIR_PAD defines the directory entries boundaries
+ *
+ * NOTE: It must be a multiple of 8
+ */
+#define NILFS_DIR_PAD			8
+#define NILFS_DIR_ROUND			(NILFS_DIR_PAD - 1)
+#define NILFS_DIR_REC_LEN(name_len)	(((name_len) + 12 + NILFS_DIR_ROUND) & \
+					~NILFS_DIR_ROUND)
+
+
+/**
+ * struct nilfs_finfo - file information
+ * @fi_ino: inode number
+ * @fi_cno: checkpoint number
+ * @fi_nblocks: number of blocks (including intermediate blocks)
+ * @fi_ndatablk: number of file data blocks
+ */
+struct nilfs_finfo {
+	__le64 fi_ino;
+	__le64 fi_cno;
+	__le32 fi_nblocks;
+	__le32 fi_ndatablk;
+	/* array of virtual block numbers */
+};
+
+/**
+ * struct nilfs_binfo_v - information for the block to which a virtual block number is assigned
+ * @bi_vblocknr: virtual block number
+ * @bi_blkoff: block offset
+ */
+struct nilfs_binfo_v {
+	__le64 bi_vblocknr;
+	__le64 bi_blkoff;
+};
+
+/**
+ * struct nilfs_binfo_dat - information for the block which belongs to the DAT file
+ * @bi_blkoff: block offset
+ * @bi_level: level
+ * @bi_pad: padding
+ */
+struct nilfs_binfo_dat {
+	__le64 bi_blkoff;
+	__u8 bi_level;
+	__u8 bi_pad[7];
+};
+
+/**
+ * union nilfs_binfo: block information
+ * @bi_v: nilfs_binfo_v structure
+ * @bi_dat: nilfs_binfo_dat structure
+ */
+union nilfs_binfo {
+	struct nilfs_binfo_v bi_v;
+	struct nilfs_binfo_dat bi_dat;
+};
+
+/**
+ * struct nilfs_segment_summary - segment summary
+ * @ss_datasum: checksum of data
+ * @ss_sumsum: checksum of segment summary
+ * @ss_magic: magic number
+ * @ss_bytes: size of this structure in bytes
+ * @ss_flags: flags
+ * @ss_seq: sequence number
+ * @ss_create: creation timestamp
+ * @ss_next: next segment
+ * @ss_nblocks: number of blocks
+ * @ss_nfinfo: number of finfo structures
+ * @ss_sumbytes: total size of segment summary in bytes
+ * @ss_pad: padding
+ */
+struct nilfs_segment_summary {
+	__le32 ss_datasum;
+	__le32 ss_sumsum;
+	__le32 ss_magic;
+	__le16 ss_bytes;
+	__le16 ss_flags;
+	__le64 ss_seq;
+	__le64 ss_create;
+	__le64 ss_next;
+	__le32 ss_nblocks;
+	__le32 ss_nfinfo;
+	__le32 ss_sumbytes;
+	__le32 ss_pad;
+	/* array of finfo structures */
+};
+
+#define NILFS_SEGSUM_MAGIC	0x1eaffa11  /* segment summary magic number */
+
+/*
+ * Segment summary flags
+ */
+#define NILFS_SS_LOGBGN 0x0001  /* begins a logical segment */
+#define NILFS_SS_LOGEND 0x0002  /* ends a logical segment */
+#define NILFS_SS_SR     0x0004  /* has super root */
+#define NILFS_SS_SYNDT  0x0008  /* includes data only updates */
+#define NILFS_SS_GC     0x0010  /* segment written for cleaner operation */
+
+/**
+ * struct nilfs_persistent_group_desc - block group descriptor
+ * @pg_nfrees: number of free entries in block group
+ */
+struct nilfs_persistent_group_desc {
+	__le32 pg_nfrees;
+};
+
+/**
+ * struct nilfs_dat_entry - disk address translation entry
+ * @dt_blocknr: block number
+ * @dt_start: start checkpoint number
+ * @dt_end: end checkpoint number
+ * @dt_rsv: reserved for future use
+ */
+struct nilfs_dat_entry {
+	__le64 de_blocknr;
+	__le64 de_start;
+	__le64 de_end;
+	__le64 de_rsv;
+};
+
+/**
+ * struct nilfs_dat_group_desc - block group descriptor
+ * @dg_nfrees: number of free virtual block numbers in block group
+ */
+struct nilfs_dat_group_desc {
+	__le32 dg_nfrees;
+};
+
+
+/**
+ * struct nilfs_snapshot_list - snapshot list
+ * @ssl_next: next checkpoint number on snapshot list
+ * @ssl_prev: previous checkpoint number on snapshot list
+ */
+struct nilfs_snapshot_list {
+	__le64 ssl_next;
+	__le64 ssl_prev;
+};
+
+/**
+ * struct nilfs_checkpoint - checkpoint structure
+ * @cp_flags: flags
+ * @cp_checkpoints_count: checkpoints count in a block
+ * @cp_snapshot_list: snapshot list
+ * @cp_cno: checkpoint number
+ * @cp_create: creation timestamp
+ * @cp_nblk_inc: number of blocks incremented by this checkpoint
+ * @cp_inodes_count: inodes count
+ * @cp_blocks_count: blocks count
+ * @cp_ifile_inode: inode of ifile
+ */
+struct nilfs_checkpoint {
+	__le32 cp_flags;
+	__le32 cp_checkpoints_count;
+	struct nilfs_snapshot_list cp_snapshot_list;
+	__le64 cp_cno;
+	__le64 cp_create;
+	__le64 cp_nblk_inc;
+	__le64 cp_inodes_count;
+	__le64 cp_blocks_count;		/* Reserved (might be deleted) */
+
+	/* Do not change the byte offset of ifile inode.
+	   To keep the compatibility of the disk format,
+	   additional fields should be added behind cp_ifile_inode. */
+	struct nilfs_inode cp_ifile_inode;
+};
+
+/* checkpoint flags */
+enum {
+	NILFS_CHECKPOINT_SNAPSHOT,
+	NILFS_CHECKPOINT_INVALID,
+	NILFS_CHECKPOINT_SKETCH,
+};
+
+#define NILFS_CHECKPOINT_FNS(flag, name)				\
+static inline void							\
+nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
+{									\
+	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
+				   (1UL << NILFS_CHECKPOINT_##flag));	\
+}									\
+static inline void							\
+nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
+{									\
+	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
+				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
+}									\
+static inline int							\
+nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
+{									\
+	return !!(le32_to_cpu(cp->cp_flags) &				\
+		  (1UL << NILFS_CHECKPOINT_##flag));			\
+}
+
+NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
+NILFS_CHECKPOINT_FNS(INVALID, invalid)
+NILFS_CHECKPOINT_FNS(SKETCH, sketch)
+
+/**
+ * struct nilfs_cpinfo - checkpoint information
+ * @ci_flags: flags
+ * @ci_cno: checkpoint number
+ * @ci_create: creation timestamp
+ * @ci_nblk_inc: number of blocks incremented by this checkpoint
+ * @ci_inodes_count: inodes count
+ * @ci_blocks_count: blocks count
+ * @ci_next: next checkpoint number in snapshot list
+ */
+struct nilfs_cpinfo {
+	__u32 ci_flags;
+	__u64 ci_cno;
+	__u64 ci_create;
+	__u64 ci_nblk_inc;
+	__u64 ci_inodes_count;
+	__u64 ci_blocks_count;
+	__u64 ci_next;
+};
+
+#define NILFS_CPINFO_FNS(flag, name)					\
+static inline int							\
+nilfs_cpinfo_##name(const struct nilfs_cpinfo *cpinfo)			\
+{									\
+	return !!(cpinfo->ci_flags & (1UL << NILFS_CHECKPOINT_##flag));	\
+}
+
+NILFS_CPINFO_FNS(SNAPSHOT, snapshot)
+NILFS_CPINFO_FNS(INVALID, invalid)
+NILFS_CPINFO_FNS(SKETCH, sketch)
+
+
+/**
+ * struct nilfs_cpfile_header - checkpoint file header
+ * @ch_ncheckpoints: number of checkpoints
+ * @ch_nsnapshots: number of snapshots
+ * @ch_snapshot_list: snapshot list
+ */
+struct nilfs_cpfile_header {
+	__le64 ch_ncheckpoints;
+	__le64 ch_nsnapshots;
+	struct nilfs_snapshot_list ch_snapshot_list;
+};
+
+#define NILFS_CPFILE_FIRST_CHECKPOINT_OFFSET	\
+	((sizeof(struct nilfs_cpfile_header) +				\
+	  sizeof(struct nilfs_checkpoint) - 1) /			\
+			sizeof(struct nilfs_checkpoint))
+
+/**
+ * struct nilfs_segment_usage - segment usage
+ * @su_lastmod: last modified timestamp
+ * @su_nblocks: number of blocks in segment
+ * @su_flags: flags
+ */
+struct nilfs_segment_usage {
+	__le64 su_lastmod;
+	__le32 su_nblocks;
+	__le32 su_flags;
+};
+
+/* segment usage flag */
+enum {
+	NILFS_SEGMENT_USAGE_ACTIVE,
+	NILFS_SEGMENT_USAGE_DIRTY,
+	NILFS_SEGMENT_USAGE_ERROR,
+
+	/* on-memory only */
+	NILFS_SEGMENT_USAGE_VOLATILE_ACTIVE,
+	/* ... */
+};
+
+#define NILFS_SEGMENT_USAGE_FNS(flag, name)				\
+static inline void							\
+nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
+{									\
+	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
+				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
+}									\
+static inline void							\
+nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
+{									\
+	su->su_flags =							\
+		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
+			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
+}									\
+static inline int							\
+nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
+{									\
+	return !!(le32_to_cpu(su->su_flags) &				\
+		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
+}
+
+NILFS_SEGMENT_USAGE_FNS(ACTIVE, active)
+NILFS_SEGMENT_USAGE_FNS(DIRTY, dirty)
+NILFS_SEGMENT_USAGE_FNS(ERROR, error)
+NILFS_SEGMENT_USAGE_FNS(VOLATILE_ACTIVE, volatile_active)
+
+static inline void
+nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
+{
+	su->su_lastmod = cpu_to_le64(0);
+	su->su_nblocks = cpu_to_le32(0);
+	su->su_flags = cpu_to_le32(0);
+}
+
+static inline int
+nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
+{
+	return !le32_to_cpu(su->su_flags);
+}
+
+/**
+ * struct nilfs_sufile_header - segment usage file header
+ * @sh_ncleansegs: number of clean segments
+ * @sh_ndirtysegs: number of dirty segments
+ * @sh_last_alloc: last allocated segment number
+ */
+struct nilfs_sufile_header {
+	__le64 sh_ncleansegs;
+	__le64 sh_ndirtysegs;
+	__le64 sh_last_alloc;
+	/* ... */
+};
+
+#define NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET	\
+	((sizeof(struct nilfs_sufile_header) +				\
+	  sizeof(struct nilfs_segment_usage) - 1) /			\
+			 sizeof(struct nilfs_segment_usage))
+
+/**
+ * nilfs_suinfo - segment usage information
+ * @sui_lastmod:
+ * @sui_nblocks:
+ * @sui_flags:
+ */
+struct nilfs_suinfo {
+	__u64 sui_lastmod;
+	__u32 sui_nblocks;
+	__u32 sui_flags;
+};
+
+#define NILFS_SUINFO_FNS(flag, name)					\
+static inline int							\
+nilfs_suinfo_##name(const struct nilfs_suinfo *si)			\
+{									\
+	return si->sui_flags & (1UL << NILFS_SEGMENT_USAGE_##flag);	\
+}
+
+NILFS_SUINFO_FNS(ACTIVE, active)
+NILFS_SUINFO_FNS(DIRTY, dirty)
+NILFS_SUINFO_FNS(ERROR, error)
+NILFS_SUINFO_FNS(VOLATILE_ACTIVE, volatile_active)
+
+static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
+{
+	return !si->sui_flags;
+}
+
+/* ioctl */
+enum {
+	NILFS_CHECKPOINT,
+	NILFS_SNAPSHOT,
+};
+
+/**
+ * struct nilfs_cpmode -
+ * @cc_cno:
+ * @cc_mode:
+ */
+struct nilfs_cpmode {
+	__u64 cm_cno;
+	int cm_mode;
+};
+
+/**
+ * struct nilfs_argv - argument vector
+ * @v_base:
+ * @v_nmembs:
+ * @v_size:
+ * @v_index:
+ * @v_flags:
+ */
+struct nilfs_argv {
+	void *v_base;
+	size_t v_nmembs;	/* number of members */
+	size_t v_size;		/* size of members */
+	int v_index;
+	int v_flags;
+};
+
+/**
+ * struct nilfs_period -
+ * @p_start:
+ * @p_end:
+ */
+struct nilfs_period {
+	__u64 p_start;
+	__u64 p_end;
+};
+
+/**
+ * struct nilfs_cpstat -
+ * @cs_cno: checkpoint number
+ * @cs_ncps: number of checkpoints
+ * @cs_nsss: number of snapshots
+ */
+struct nilfs_cpstat {
+	__u64 cs_cno;
+	__u64 cs_ncps;
+	__u64 cs_nsss;
+};
+
+/**
+ * struct nilfs_sustat -
+ * @ss_nsegs: number of segments
+ * @ss_ncleansegs: number of clean segments
+ * @ss_ndirtysegs: number of dirty segments
+ * @ss_ctime:
+ * @ss_nongc_ctime:
+ */
+struct nilfs_sustat {
+	__u64 ss_nsegs;
+	__u64 ss_ncleansegs;
+	__u64 ss_ndirtysegs;
+	time_t ss_ctime;
+	time_t ss_nongc_ctime;
+};
+
+/**
+ * struct nilfs_vinfo - virtual block number information
+ * @vi_vblocknr:
+ * @vi_start:
+ * @vi_end:
+ * @vi_blocknr:
+ */
+struct nilfs_vinfo {
+	__u64 vi_vblocknr;
+	__u64 vi_start;
+	__u64 vi_end;
+	__u64 vi_blocknr;
+};
+
+/**
+ * struct nilfs_vdesc -
+ */
+struct nilfs_vdesc {
+	__u64 vd_ino;
+	__u64 vd_cno;
+	__u64 vd_vblocknr;
+	struct nilfs_period vd_period;
+	__u64 vd_blocknr;
+	__u64 vd_offset;
+	__u32 vd_flags;
+};
+
+/**
+ * struct nilfs_bdesc -
+ */
+struct nilfs_bdesc {
+	__u64 bd_ino;
+	__u64 bd_oblocknr;
+	__u64 bd_blocknr;
+	__u64 bd_offset;
+	__u32 bd_level;
+};
+
+#define	NILFS_TIMEDWAIT_WRITE_LOCKED	0x1
+#define	NILFS_TIMEDWAIT_SEG_WRITE	0x2
+
+/**
+ * struct nilfs_wait_cond -
+ */
+struct nilfs_wait_cond {
+	int wc_cond;
+	int wc_flags;
+	struct timespec wc_timeout;
+};
+
+#define NILFS_IOCTL_IDENT		'n'
+
+#define NILFS_IOCTL_CHANGE_CPMODE  \
+	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode)
+#define NILFS_IOCTL_DELETE_CHECKPOINT  \
+	_IOW(NILFS_IOCTL_IDENT, 0x81, __u64)
+#define NILFS_IOCTL_GET_CPINFO  \
+	_IOR(NILFS_IOCTL_IDENT, 0x82, struct nilfs_argv)
+#define NILFS_IOCTL_GET_CPSTAT  \
+	_IOR(NILFS_IOCTL_IDENT, 0x83, struct nilfs_cpstat)
+#define NILFS_IOCTL_GET_SUINFO  \
+	_IOR(NILFS_IOCTL_IDENT, 0x84, struct nilfs_argv)
+#define NILFS_IOCTL_GET_SUSTAT  \
+	_IOR(NILFS_IOCTL_IDENT, 0x85, struct nilfs_sustat)
+#define NILFS_IOCTL_GET_VINFO  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x86, struct nilfs_argv)
+#define NILFS_IOCTL_GET_BDESCS  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv)
+#define NILFS_IOCTL_CLEAN_SEGMENTS  \
+	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv[5])
+#define NILFS_IOCTL_TIMEDWAIT  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x89, struct nilfs_wait_cond)
+#define NILFS_IOCTL_SYNC  \
+	_IOR(NILFS_IOCTL_IDENT, 0x8A, __u64)
+#define NILFS_IOCTL_RESIZE  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
+
+/* compat_ioctl */
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+
+struct nilfs_cpmode32 {
+	__u64 cm_cno;
+	compat_int_t cm_mode;
+};
+
+struct nilfs_argv32 {
+	compat_caddr_t v_base;
+	compat_size_t v_nmembs;
+	compat_size_t v_size;
+	compat_int_t v_index;
+	compat_int_t v_flags;
+};
+
+struct nilfs_sustat32 {
+	__u64 ss_nsegs;
+	__u64 ss_ncleansegs;
+	__u64 ss_ndirtysegs;
+	compat_time_t ss_ctime;
+	compat_time_t ss_nongc_ctime;
+};
+
+struct nilfs_wait_cond32 {
+	compat_int_t wc_cond;
+	compat_int_t wc_flags;
+	struct compat_timespec wc_timeout;
+};
+
+#define NILFS_IOCTL32_CHANGE_CPMODE  \
+	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode32)
+#define NILFS_IOCTL32_GET_CPINFO  \
+	_IOR(NILFS_IOCTL_IDENT, 0x82, struct nilfs_argv32)
+#define NILFS_IOCTL32_GET_SUINFO  \
+	_IOR(NILFS_IOCTL_IDENT, 0x84, struct nilfs_argv32)
+#define NILFS_IOCTL32_GET_SUSTAT  \
+	_IOR(NILFS_IOCTL_IDENT, 0x85, struct nilfs_sustat32)
+#define NILFS_IOCTL32_GET_VINFO  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x86, struct nilfs_argv32)
+#define NILFS_IOCTL32_GET_BDESCS  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv32)
+#define NILFS_IOCTL32_CLEAN_SEGMENTS  \
+	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv32[5])
+#define NILFS_IOCTL32_TIMEDWAIT  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x89, struct nilfs_wait_cond32)
+#endif	/* CONFIG_COMPAT */
+
+#endif	/* _LINUX_NILFS_FS_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-continuous-snapshotting-file-system.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch

