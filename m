From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-dont-include-aioh-in-schedh.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:28:58 -0700
Message-ID: <20130321222858.A51A15A42CB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:65066 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3CUW3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:00 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so310231ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: don't include aio.h in sched.h
has been removed from the -mm tree.  Its filename was
     aio-dont-include-aioh-in-schedh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: don't include aio.h in sched.h

Faster kernel compiles by way of fewer unnecessary includes.

[akpm@linux-foundation.org: fix fallout]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/hypfs/inode.c                      |    1 +
 block/scsi_ioctl.c                           |    1 +
 drivers/char/mem.c                           |    1 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     |    2 +-
 drivers/scsi/sg.c                            |    1 +
 drivers/staging/android/logger.c             |    1 +
 fs/9p/vfs_addr.c                             |    1 +
 fs/afs/write.c                               |    1 +
 fs/block_dev.c                               |    1 +
 fs/btrfs/file.c                              |    1 +
 fs/btrfs/inode.c                             |    1 +
 fs/ceph/file.c                               |    1 +
 fs/compat.c                                  |    1 +
 fs/direct-io.c                               |    1 +
 fs/ecryptfs/file.c                           |    1 +
 fs/ext2/inode.c                              |    1 +
 fs/ext3/inode.c                              |    1 +
 fs/ext4/file.c                               |    1 +
 fs/ext4/indirect.c                           |    1 +
 fs/ext4/inode.c                              |    1 +
 fs/ext4/page-io.c                            |    1 +
 fs/f2fs/data.c                               |    1 +
 fs/fat/inode.c                               |    1 +
 fs/fuse/cuse.c                               |    1 +
 fs/fuse/dev.c                                |    1 +
 fs/fuse/file.c                               |    1 +
 fs/gfs2/aops.c                               |    1 +
 fs/gfs2/file.c                               |    1 +
 fs/hfs/inode.c                               |    1 +
 fs/hfsplus/inode.c                           |    1 +
 fs/jfs/inode.c                               |    1 +
 fs/nilfs2/inode.c                            |    2 +-
 fs/ntfs/file.c                               |    1 +
 fs/ntfs/inode.c                              |    1 +
 fs/ocfs2/aops.h                              |    2 ++
 fs/ocfs2/inode.h                             |    2 ++
 fs/pipe.c                                    |    1 +
 fs/read_write.c                              |    1 +
 fs/reiserfs/inode.c                          |    1 +
 fs/ubifs/file.c                              |    1 +
 fs/udf/inode.c                               |    1 +
 fs/xfs/xfs_aops.c                            |    1 +
 fs/xfs/xfs_file.c                            |    1 +
 include/linux/cgroup.h                       |    1 +
 include/linux/pid_namespace.h                |    1 +
 include/linux/sched.h                        |    2 --
 include/linux/writeback.h                    |    1 +
 kernel/fork.c                                |    1 +
 kernel/printk.c                              |    1 +
 kernel/ptrace.c                              |    1 +
 mm/page_io.c                                 |    1 +
 mm/shmem.c                                   |    1 +
 mm/swap.c                                    |    1 +
 security/keys/internal.h                     |    2 ++
 security/keys/keyctl.c                       |    1 +
 sound/core/pcm_native.c                      |    2 +-
 57 files changed, 59 insertions(+), 5 deletions(-)

diff -puN arch/s390/hypfs/inode.c~aio-dont-include-aioh-in-schedh arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~aio-dont-include-aioh-in-schedh
+++ a/arch/s390/hypfs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/aio.h>
 #include <asm/ebcdic.h>
 #include "hypfs.h"
 
diff -puN block/scsi_ioctl.c~aio-dont-include-aioh-in-schedh block/scsi_ioctl.c
--- a/block/scsi_ioctl.c~aio-dont-include-aioh-in-schedh
+++ a/block/scsi_ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/times.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
diff -puN drivers/char/mem.c~aio-dont-include-aioh-in-schedh drivers/char/mem.c
--- a/drivers/char/mem.c~aio-dont-include-aioh-in-schedh
+++ a/drivers/char/mem.c
@@ -28,6 +28,7 @@
 #include <linux/pfn.h>
 #include <linux/export.h>
 #include <linux/io.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~aio-dont-include-aioh-in-schedh drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~aio-dont-include-aioh-in-schedh
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/aio.h>
 #include <linux/jiffies.h>
 #include <linux/cpu.h>
 #include <asm/pgtable.h>
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~aio-dont-include-aioh-in-schedh drivers/infiniband/hw/qib/qib_file_ops.c
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~aio-dont-include-aioh-in-schedh
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -39,7 +39,7 @@
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/jiffies.h>
 #include <asm/pgtable.h>
 #include <linux/delay.h>
diff -puN drivers/scsi/sg.c~aio-dont-include-aioh-in-schedh drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~aio-dont-include-aioh-in-schedh
+++ a/drivers/scsi/sg.c
@@ -35,6 +35,7 @@ static int sg_version_num = 30534;	/* 2
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/aio.h>
 #include <linux/errno.h>
 #include <linux/mtio.h>
 #include <linux/ioctl.h>
diff -puN drivers/staging/android/logger.c~aio-dont-include-aioh-in-schedh drivers/staging/android/logger.c
--- a/drivers/staging/android/logger.c~aio-dont-include-aioh-in-schedh
+++ a/drivers/staging/android/logger.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <linux/aio.h>
 #include "logger.h"
 
 #include <asm/ioctls.h>
diff -puN fs/9p/vfs_addr.c~aio-dont-include-aioh-in-schedh fs/9p/vfs_addr.c
--- a/fs/9p/vfs_addr.c~aio-dont-include-aioh-in-schedh
+++ a/fs/9p/vfs_addr.c
@@ -33,6 +33,7 @@
 #include <linux/pagemap.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff -puN fs/afs/write.c~aio-dont-include-aioh-in-schedh fs/afs/write.c
--- a/fs/afs/write.c~aio-dont-include-aioh-in-schedh
+++ a/fs/afs/write.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/aio.h>
 #include "internal.h"
 
 static int afs_write_back_from_locked_page(struct afs_writeback *wb,
diff -puN fs/block_dev.c~aio-dont-include-aioh-in-schedh fs/block_dev.c
--- a/fs/block_dev.c~aio-dont-include-aioh-in-schedh
+++ a/fs/block_dev.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/aio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff -puN fs/btrfs/file.c~aio-dont-include-aioh-in-schedh fs/btrfs/file.c
--- a/fs/btrfs/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/btrfs/file.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 #include <linux/falloc.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
diff -puN fs/btrfs/inode.c~aio-dont-include-aioh-in-schedh fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/btrfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/writeback.h>
 #include <linux/statfs.h>
 #include <linux/compat.h>
+#include <linux/aio.h>
 #include <linux/bit_spinlock.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
diff -puN fs/ceph/file.c~aio-dont-include-aioh-in-schedh fs/ceph/file.c
--- a/fs/ceph/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ceph/file.c
@@ -7,6 +7,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 
 #include "super.h"
 #include "mds_client.h"
diff -puN fs/compat.c~aio-dont-include-aioh-in-schedh fs/compat.c
--- a/fs/compat.c~aio-dont-include-aioh-in-schedh
+++ a/fs/compat.c
@@ -47,6 +47,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff -puN fs/direct-io.c~aio-dont-include-aioh-in-schedh fs/direct-io.c
--- a/fs/direct-io.c~aio-dont-include-aioh-in-schedh
+++ a/fs/direct-io.c
@@ -37,6 +37,7 @@
 #include <linux/uio.h>
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
+#include <linux/aio.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
diff -puN fs/ecryptfs/file.c~aio-dont-include-aioh-in-schedh fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ecryptfs/file.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
+#include <linux/aio.h>
 #include "ecryptfs_kernel.h"
 
 /**
diff -puN fs/ext2/inode.c~aio-dont-include-aioh-in-schedh fs/ext2/inode.c
--- a/fs/ext2/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ext2/inode.c
@@ -31,6 +31,7 @@
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
diff -puN fs/ext3/inode.c~aio-dont-include-aioh-in-schedh fs/ext3/inode.c
--- a/fs/ext3/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ext3/inode.c
@@ -27,6 +27,7 @@
 #include <linux/writeback.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include "ext3.h"
 #include "xattr.h"
 #include "acl.h"
diff -puN fs/ext4/file.c~aio-dont-include-aioh-in-schedh fs/ext4/file.c
--- a/fs/ext4/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ext4/file.c
@@ -23,6 +23,7 @@
 #include <linux/jbd2.h>
 #include <linux/mount.h>
 #include <linux/path.h>
+#include <linux/aio.h>
 #include <linux/quotaops.h>
 #include <linux/pagevec.h>
 #include "ext4.h"
diff -puN fs/ext4/indirect.c~aio-dont-include-aioh-in-schedh fs/ext4/indirect.c
--- a/fs/ext4/indirect.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ext4/indirect.c
@@ -20,6 +20,7 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
+#include <linux/aio.h>
 #include "ext4_jbd2.h"
 #include "truncate.h"
 #include "ext4_extents.h"	/* Needed for EXT_MAX_BLOCKS */
diff -puN fs/ext4/inode.c~aio-dont-include-aioh-in-schedh fs/ext4/inode.c
--- a/fs/ext4/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ext4/inode.c
@@ -37,6 +37,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/aio.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
diff -puN fs/ext4/page-io.c~aio-dont-include-aioh-in-schedh fs/ext4/page-io.c
--- a/fs/ext4/page-io.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ext4/page-io.c
@@ -18,6 +18,7 @@
 #include <linux/pagevec.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
 #include <linux/workqueue.h>
diff -puN fs/f2fs/data.c~aio-dont-include-aioh-in-schedh fs/f2fs/data.c
--- a/fs/f2fs/data.c~aio-dont-include-aioh-in-schedh
+++ a/fs/f2fs/data.c
@@ -12,6 +12,7 @@
 #include <linux/f2fs_fs.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
diff -puN fs/fat/inode.c~aio-dont-include-aioh-in-schedh fs/fat/inode.c
--- a/fs/fat/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/fat/inode.c
@@ -19,6 +19,7 @@
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
 #include <linux/mount.h>
+#include <linux/aio.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/uio.h>
diff -puN fs/fuse/cuse.c~aio-dont-include-aioh-in-schedh fs/fuse/cuse.c
--- a/fs/fuse/cuse.c~aio-dont-include-aioh-in-schedh
+++ a/fs/fuse/cuse.c
@@ -38,6 +38,7 @@
 #include <linux/device.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/aio.h>
 #include <linux/kdev_t.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
diff -puN fs/fuse/dev.c~aio-dont-include-aioh-in-schedh fs/fuse/dev.c
--- a/fs/fuse/dev.c~aio-dont-include-aioh-in-schedh
+++ a/fs/fuse/dev.c
@@ -19,6 +19,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/swap.h>
 #include <linux/splice.h>
+#include <linux/aio.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
diff -puN fs/fuse/file.c~aio-dont-include-aioh-in-schedh fs/fuse/file.c
--- a/fs/fuse/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/fuse/file.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/compat.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
diff -puN fs/gfs2/aops.c~aio-dont-include-aioh-in-schedh fs/gfs2/aops.c
--- a/fs/gfs2/aops.c~aio-dont-include-aioh-in-schedh
+++ a/fs/gfs2/aops.c
@@ -20,6 +20,7 @@
 #include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/backing-dev.h>
+#include <linux/aio.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff -puN fs/gfs2/file.c~aio-dont-include-aioh-in-schedh fs/gfs2/file.c
--- a/fs/gfs2/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/gfs2/file.c
@@ -25,6 +25,7 @@
 #include <asm/uaccess.h>
 #include <linux/dlm.h>
 #include <linux/dlm_plock.h>
+#include <linux/aio.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff -puN fs/hfs/inode.c~aio-dont-include-aioh-in-schedh fs/hfs/inode.c
--- a/fs/hfs/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/hfs/inode.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
diff -puN fs/hfsplus/inode.c~aio-dont-include-aioh-in-schedh fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/hfsplus/inode.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
diff -puN fs/jfs/inode.c~aio-dont-include-aioh-in-schedh fs/jfs/inode.c
--- a/fs/jfs/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/jfs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
 #include "jfs_filsys.h"
diff -puN fs/nilfs2/inode.c~aio-dont-include-aioh-in-schedh fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/nilfs2/inode.c
@@ -25,7 +25,7 @@
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include "nilfs.h"
 #include "btnode.h"
 #include "segment.h"
diff -puN fs/ntfs/file.c~aio-dont-include-aioh-in-schedh fs/ntfs/file.c
--- a/fs/ntfs/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ntfs/file.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
diff -puN fs/ntfs/inode.c~aio-dont-include-aioh-in-schedh fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ntfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/aio.h>
 
 #include "aops.h"
 #include "attrib.h"
diff -puN fs/ocfs2/aops.h~aio-dont-include-aioh-in-schedh fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~aio-dont-include-aioh-in-schedh
+++ a/fs/ocfs2/aops.h
@@ -22,6 +22,8 @@
 #ifndef OCFS2_AOPS_H
 #define OCFS2_AOPS_H
 
+#include <linux/aio.h>
+
 handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 							 struct page *page,
 							 unsigned from,
diff -puN fs/ocfs2/inode.h~aio-dont-include-aioh-in-schedh fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~aio-dont-include-aioh-in-schedh
+++ a/fs/ocfs2/inode.h
@@ -28,6 +28,8 @@
 
 #include "extent_map.h"
 
+struct iocb;
+
 /* OCFS2 Inode Private Data */
 struct ocfs2_inode_info
 {
diff -puN fs/pipe.c~aio-dont-include-aioh-in-schedh fs/pipe.c
--- a/fs/pipe.c~aio-dont-include-aioh-in-schedh
+++ a/fs/pipe.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
diff -puN fs/read_write.c~aio-dont-include-aioh-in-schedh fs/read_write.c
--- a/fs/read_write.c~aio-dont-include-aioh-in-schedh
+++ a/fs/read_write.c
@@ -9,6 +9,7 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
 #include <linux/export.h>
diff -puN fs/reiserfs/inode.c~aio-dont-include-aioh-in-schedh fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/reiserfs/inode.c
@@ -18,6 +18,7 @@
 #include <linux/writeback.h>
 #include <linux/quotaops.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 int reiserfs_commit_write(struct file *f, struct page *page,
 			  unsigned from, unsigned to);
diff -puN fs/ubifs/file.c~aio-dont-include-aioh-in-schedh fs/ubifs/file.c
--- a/fs/ubifs/file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/ubifs/file.c
@@ -50,6 +50,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/aio.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
diff -puN fs/udf/inode.c~aio-dont-include-aioh-in-schedh fs/udf/inode.c
--- a/fs/udf/inode.c~aio-dont-include-aioh-in-schedh
+++ a/fs/udf/inode.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/crc-itu-t.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
diff -puN fs/xfs/xfs_aops.c~aio-dont-include-aioh-in-schedh fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~aio-dont-include-aioh-in-schedh
+++ a/fs/xfs/xfs_aops.c
@@ -31,6 +31,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
diff -puN fs/xfs/xfs_file.c~aio-dont-include-aioh-in-schedh fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~aio-dont-include-aioh-in-schedh
+++ a/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
+#include <linux/aio.h>
 #include <linux/dcache.h>
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
diff -puN include/linux/cgroup.h~aio-dont-include-aioh-in-schedh include/linux/cgroup.h
--- a/include/linux/cgroup.h~aio-dont-include-aioh-in-schedh
+++ a/include/linux/cgroup.h
@@ -27,6 +27,7 @@ struct cgroup_subsys;
 struct inode;
 struct cgroup;
 struct css_id;
+struct eventfd_ctx;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
diff -puN include/linux/pid_namespace.h~aio-dont-include-aioh-in-schedh include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~aio-dont-include-aioh-in-schedh
+++ a/include/linux/pid_namespace.h
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/workqueue.h>
 #include <linux/threads.h>
 #include <linux/nsproxy.h>
 #include <linux/kref.h>
diff -puN include/linux/sched.h~aio-dont-include-aioh-in-schedh include/linux/sched.h
--- a/include/linux/sched.h~aio-dont-include-aioh-in-schedh
+++ a/include/linux/sched.h
@@ -313,8 +313,6 @@ extern int mutex_spin_on_owner(struct mu
 struct nsproxy;
 struct user_namespace;
 
-#include <linux/aio.h>
-
 #ifdef CONFIG_MMU
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
diff -puN include/linux/writeback.h~aio-dont-include-aioh-in-schedh include/linux/writeback.h
--- a/include/linux/writeback.h~aio-dont-include-aioh-in-schedh
+++ a/include/linux/writeback.h
@@ -5,6 +5,7 @@
 #define WRITEBACK_H
 
 #include <linux/sched.h>
+#include <linux/workqueue.h>
 #include <linux/fs.h>
 
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
diff -puN kernel/fork.c~aio-dont-include-aioh-in-schedh kernel/fork.c
--- a/kernel/fork.c~aio-dont-include-aioh-in-schedh
+++ a/kernel/fork.c
@@ -70,6 +70,7 @@
 #include <linux/khugepaged.h>
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
+#include <linux/aio.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff -puN kernel/printk.c~aio-dont-include-aioh-in-schedh kernel/printk.c
--- a/kernel/printk.c~aio-dont-include-aioh-in-schedh
+++ a/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
+#include <linux/aio.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
 #include <linux/kdb.h>
diff -puN kernel/ptrace.c~aio-dont-include-aioh-in-schedh kernel/ptrace.c
--- a/kernel/ptrace.c~aio-dont-include-aioh-in-schedh
+++ a/kernel/ptrace.c
@@ -17,6 +17,7 @@
 #include <linux/ptrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
+#include <linux/uio.h>
 #include <linux/audit.h>
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
diff -puN mm/page_io.c~aio-dont-include-aioh-in-schedh mm/page_io.c
--- a/mm/page_io.c~aio-dont-include-aioh-in-schedh
+++ a/mm/page_io.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
+#include <linux/aio.h>
 #include <asm/pgtable.h>
 
 static struct bio *get_swap_bio(gfp_t gfp_flags,
diff -puN mm/shmem.c~aio-dont-include-aioh-in-schedh mm/shmem.c
--- a/mm/shmem.c~aio-dont-include-aioh-in-schedh
+++ a/mm/shmem.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 static struct vfsmount *shm_mnt;
 
diff -puN mm/swap.c~aio-dont-include-aioh-in-schedh mm/swap.c
--- a/mm/swap.c~aio-dont-include-aioh-in-schedh
+++ a/mm/swap.c
@@ -30,6 +30,7 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
+#include <linux/uio.h>
 
 #include "internal.h"
 
diff -puN security/keys/internal.h~aio-dont-include-aioh-in-schedh security/keys/internal.h
--- a/security/keys/internal.h~aio-dont-include-aioh-in-schedh
+++ a/security/keys/internal.h
@@ -16,6 +16,8 @@
 #include <linux/key-type.h>
 #include <linux/task_work.h>
 
+struct iovec;
+
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
diff -puN security/keys/keyctl.c~aio-dont-include-aioh-in-schedh security/keys/keyctl.c
--- a/security/keys/keyctl.c~aio-dont-include-aioh-in-schedh
+++ a/security/keys/keyctl.c
@@ -22,6 +22,7 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff -puN sound/core/pcm_native.c~aio-dont-include-aioh-in-schedh sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~aio-dont-include-aioh-in-schedh
+++ a/sound/core/pcm_native.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/pm_qos.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/dma-mapping.h>
 #include <sound/core.h>
 #include <sound/control.h>
_

Patches currently in -mm which might be from koverstreet@google.com are

aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

