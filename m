From: akpm@linux-foundation.org
Subject: +
 vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs.patch added to
 -mm tree
Date: Tue, 28 Apr 2020 16:49:39 -0700
Message-ID: <20200428234939.tIPIjiK9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgD1Xtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Apr 2020 19:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andres@anarazel.de, david@fromorbit.com, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, jlayton@kernel.org, jlayton@redhat.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: vfs: track per-sb writeback errors and report them to syncfs
has been added to the -mm tree.  Its filename is
     vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: vfs: track per-sb writeback errors and report them to syncfs

Patch series "vfs: have syncfs() return error when there are writeback
errors", v6.

Currently, syncfs does not return errors when one of the inodes fails to
be written back. It will return errors based on the legacy AS_EIO and
AS_ENOSPC flags when syncing out the block device fails, but that's not
particularly helpful for filesystems that aren't backed by a blockdev.
It's also possible for a stray sync to lose those errors.

The basic idea is to track writeback errors at the superblock level,
so that we can quickly and easily check whether something bad happened
without having to fsync each file individually. syncfs is then changed
to reliably report writeback errors, and a new ioctl is added to allow
userland to get at the current errseq_t value w/o having to sync out
anything.


This patch (of 2):

Usually we suggest that applications call fsync when they want to ensure
that all data written to the file has made it to the backing store, but
that can be inefficient when there are a lot of open files.

Calling syncfs on the filesystem can be more efficient in some situations,
but the error reporting doesn't currently work the way most people expect.
If a single inode on a filesystem reports a writeback error, syncfs won't
necessarily return an error.  syncfs only returns an error if
__sync_blockdev fails, and on some filesystems that's a no-op.

It would be better if syncfs reported an error if there were any writeback
failures.  Then applications could call syncfs to see if there are any
errors on any open files, and could then call fsync on all of the other
descriptors to figure out which one failed.

This patch adds a new errseq_t to struct super_block, and has
mapping_set_error also record writeback errors there.

To report those errors, we also need to keep an errseq_t in struct file to
act as a cursor.  This patch adds a dedicated field for that purpose,
which slots nicely into 4 bytes of padding at the end of struct file on
x86_64.

An earlier version of this patch used an O_PATH file descriptor to cue the
kernel that the open file should track the superblock error and not the
inode's writeback error.

I think that API is just too weird though.  This is simpler and should
make syncfs error reporting "just work" even if someone is multiplexing
fsync and syncfs on the same fds.

Link: http://lkml.kernel.org/r/20200428135155.19223-1-jlayton@kernel.org
Link: http://lkml.kernel.org/r/20200428135155.19223-2-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c    |    1 +
 fs/file_table.c         |    1 +
 fs/open.c               |    3 +--
 fs/sync.c               |    6 ++++--
 include/linux/fs.h      |   16 ++++++++++++++++
 include/linux/pagemap.h |    5 ++++-
 6 files changed, 27 insertions(+), 5 deletions(-)

--- a/drivers/dax/device.c~vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs
+++ a/drivers/dax/device.c
@@ -377,6 +377,7 @@ static int dax_open(struct inode *inode,
 	inode->i_mapping->a_ops = &dev_dax_aops;
 	filp->f_mapping = inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
+	filp->f_sb_err = file_sample_sb_err(filp);
 	filp->private_data = dev_dax;
 	inode->i_flags = S_DAX;
 
--- a/fs/file_table.c~vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs
+++ a/fs/file_table.c
@@ -198,6 +198,7 @@ static struct file *alloc_file(const str
 	file->f_inode = path->dentry->d_inode;
 	file->f_mapping = path->dentry->d_inode->i_mapping;
 	file->f_wb_err = filemap_sample_wb_err(file->f_mapping);
+	file->f_sb_err = file_sample_sb_err(file);
 	if ((file->f_mode & FMODE_READ) &&
 	     likely(fop->read || fop->read_iter))
 		file->f_mode |= FMODE_CAN_READ;
--- a/fs/open.c~vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs
+++ a/fs/open.c
@@ -743,9 +743,8 @@ static int do_dentry_open(struct file *f
 	path_get(&f->f_path);
 	f->f_inode = inode;
 	f->f_mapping = inode->i_mapping;
-
-	/* Ensure that we skip any errors that predate opening of the file */
 	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
+	f->f_sb_err = file_sample_sb_err(f);
 
 	if (unlikely(f->f_flags & O_PATH)) {
 		f->f_mode = FMODE_PATH | FMODE_OPENED;
--- a/fs/sync.c~vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs
+++ a/fs/sync.c
@@ -161,7 +161,7 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 {
 	struct fd f = fdget(fd);
 	struct super_block *sb;
-	int ret;
+	int ret, ret2;
 
 	if (!f.file)
 		return -EBADF;
@@ -171,8 +171,10 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 	ret = sync_filesystem(sb);
 	up_read(&sb->s_umount);
 
+	ret2 = errseq_check_and_advance(&sb->s_wb_err, &f.file->f_sb_err);
+
 	fdput(f);
-	return ret;
+	return ret ? ret : ret2;
 }
 
 /**
--- a/include/linux/fs.h~vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs
+++ a/include/linux/fs.h
@@ -976,6 +976,7 @@ struct file {
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
 	errseq_t		f_wb_err;
+	errseq_t		f_sb_err; /* for syncfs */
 } __randomize_layout
   __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
@@ -1520,6 +1521,9 @@ struct super_block {
 	/* Being remounted read-only */
 	int s_readonly_remount;
 
+	/* per-sb errseq_t for reporting writeback errors via syncfs */
+	errseq_t s_wb_err;
+
 	/* AIO completions deferred from interrupt context */
 	struct workqueue_struct *s_dio_done_wq;
 	struct hlist_head s_pins;
@@ -2827,6 +2831,18 @@ static inline errseq_t filemap_sample_wb
 	return errseq_sample(&mapping->wb_err);
 }
 
+/**
+ * file_sample_sb_err - sample the current errseq_t to test for later errors
+ * @mapping: mapping to be sampled
+ *
+ * Grab the most current superblock-level errseq_t value for the given
+ * struct file.
+ */
+static inline errseq_t file_sample_sb_err(struct file *file)
+{
+	return errseq_sample(&file->f_path.dentry->d_sb->s_wb_err);
+}
+
 static inline int filemap_nr_thps(struct address_space *mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
--- a/include/linux/pagemap.h~vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs
+++ a/include/linux/pagemap.h
@@ -51,7 +51,10 @@ static inline void mapping_set_error(str
 		return;
 
 	/* Record in wb_err for checkers using errseq_t based tracking */
-	filemap_set_wb_err(mapping, error);
+	__filemap_set_wb_err(mapping, error);
+
+	/* Record it in superblock */
+	errseq_set(&mapping->host->i_sb->s_wb_err, error);
 
 	/* Record it in flags for now, for legacy callers */
 	if (error == -ENOSPC)
_

Patches currently in -mm which might be from jlayton@redhat.com are

vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs.patch
buffer-record-blockdev-write-errors-in-super_block-that-it-backs.patch
