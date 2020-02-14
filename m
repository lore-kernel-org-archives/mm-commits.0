From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] include-remove-highmemh-from-pagemaph.patch
 removed from -mm tree
Date: Thu, 13 Feb 2020 21:41:21 -0800
Message-ID: <20200214054121.hylBZpQCo%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgBNFlW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:41:22 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: include: Remove highmem.h from pagemap.h
has been removed from the -mm tree.  Its filename was
     include-remove-highmemh-from-pagemaph.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include: Remove highmem.h from pagemap.h

pagemap.h doesn't need highmem.h itself.  Only two dozen users were
relying on pagemap to pull in highmem (usually for kmap), so fix them all
up and we can remove this header file dependency.

Link: http://lkml.kernel.org/r/20200213195643.31587-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/virtio_console.c                                      |    1 +
 drivers/media/pci/ivtv/ivtv-driver.h                               |    1 +
 drivers/media/v4l2-core/videobuf-dma-sg.c                          |    1 +
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    1 +
 fs/affs/affs.h                                                     |    1 +
 fs/ext2/namei.c                                                    |    1 +
 fs/freevxfs/vxfs_immed.c                                           |    1 +
 fs/freevxfs/vxfs_subr.c                                            |    1 +
 fs/hfs/btree.c                                                     |    1 +
 fs/jffs2/gc.c                                                      |    1 +
 fs/minix/minix.h                                                   |    1 +
 fs/ocfs2/symlink.c                                                 |    1 +
 fs/qnx6/qnx6.h                                                     |    1 +
 fs/read_write.c                                                    |    1 +
 fs/reiserfs/ioctl.c                                                |    1 +
 fs/reiserfs/tail_conversion.c                                      |    1 +
 fs/reiserfs/xattr.c                                                |    3 ++-
 fs/squashfs/file.c                                                 |    1 +
 fs/squashfs/symlink.c                                              |    1 +
 fs/sysv/namei.c                                                    |    1 +
 fs/udf/file.c                                                      |    1 +
 fs/ufs/ufs_fs.h                                                    |    1 +
 include/linux/pagemap.h                                            |    1 -
 kernel/bpf/stackmap.c                                              |    1 +
 lib/iov_iter.c                                                     |    1 +
 net/sunrpc/auth_gss/gss_krb5_wrap.c                                |    1 +
 net/sunrpc/cache.c                                                 |    1 +
 27 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/char/virtio_console.c~include-remove-highmemh-from-pagemaph
+++ a/drivers/char/virtio_console.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/splice.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/poll.h>
--- a/drivers/media/pci/ivtv/ivtv-driver.h~include-remove-highmemh-from-pagemaph
+++ a/drivers/media/pci/ivtv/ivtv-driver.h
@@ -50,6 +50,7 @@
 #include <linux/list.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/scatterlist.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~include-remove-highmemh-from-pagemaph
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c~include-remove-highmemh-from-pagemaph
+++ a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
--- a/fs/affs/affs.h~include-remove-highmemh-from-pagemaph
+++ a/fs/affs/affs.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/highmem.h>
 #include "amigaffs.h"
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
--- a/fs/ext2/namei.c~include-remove-highmemh-from-pagemaph
+++ a/fs/ext2/namei.c
@@ -31,6 +31,7 @@
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
 
+#include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include "ext2.h"
--- a/fs/freevxfs/vxfs_immed.c~include-remove-highmemh-from-pagemaph
+++ a/fs/freevxfs/vxfs_immed.c
@@ -32,6 +32,7 @@
  */
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 
 #include "vxfs.h"
 #include "vxfs_extern.h"
--- a/fs/freevxfs/vxfs_subr.c~include-remove-highmemh-from-pagemaph
+++ a/fs/freevxfs/vxfs_subr.c
@@ -34,6 +34,7 @@
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 
 #include "vxfs_extern.h"
 
--- a/fs/hfs/btree.c~include-remove-highmemh-from-pagemaph
+++ a/fs/hfs/btree.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
 
--- a/fs/jffs2/gc.c~include-remove-highmemh-from-pagemaph
+++ a/fs/jffs2/gc.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/crc32.h>
 #include <linux/compiler.h>
 #include <linux/stat.h>
--- a/fs/minix/minix.h~include-remove-highmemh-from-pagemaph
+++ a/fs/minix/minix.h
@@ -4,6 +4,7 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/minix_fs.h>
 
 #define INODE_VERSION(inode)	minix_sb(inode->i_sb)->s_version
--- a/fs/ocfs2/symlink.c~include-remove-highmemh-from-pagemaph
+++ a/fs/ocfs2/symlink.c
@@ -38,6 +38,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/namei.h>
 
 #include <cluster/masklog.h>
--- a/fs/qnx6/qnx6.h~include-remove-highmemh-from-pagemaph
+++ a/fs/qnx6/qnx6.h
@@ -19,6 +19,7 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 
 typedef __u16 __bitwise __fs16;
 typedef __u32 __bitwise __fs32;
--- a/fs/read_write.c~include-remove-highmemh-from-pagemaph
+++ a/fs/read_write.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/splice.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
--- a/fs/reiserfs/ioctl.c~include-remove-highmemh-from-pagemaph
+++ a/fs/reiserfs/ioctl.c
@@ -9,6 +9,7 @@
 #include <linux/time.h>
 #include <linux/uaccess.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/compat.h>
 
 /*
--- a/fs/reiserfs/tail_conversion.c~include-remove-highmemh-from-pagemaph
+++ a/fs/reiserfs/tail_conversion.c
@@ -6,6 +6,7 @@
 
 #include <linux/time.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/buffer_head.h>
 #include "reiserfs.h"
 
--- a/fs/reiserfs/xattr.c~include-remove-highmemh-from-pagemaph
+++ a/fs/reiserfs/xattr.c
@@ -37,11 +37,12 @@
 #include "reiserfs.h"
 #include <linux/capability.h>
 #include <linux/dcache.h>
-#include <linux/namei.h>
 #include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/highmem.h>
+#include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "xattr.h"
--- a/fs/squashfs/file.c~include-remove-highmemh-from-pagemaph
+++ a/fs/squashfs/file.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/mutex.h>
 
 #include "squashfs_fs.h"
--- a/fs/squashfs/symlink.c~include-remove-highmemh-from-pagemaph
+++ a/fs/squashfs/symlink.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/xattr.h>
 
 #include "squashfs_fs.h"
--- a/fs/sysv/namei.c~include-remove-highmemh-from-pagemaph
+++ a/fs/sysv/namei.c
@@ -13,6 +13,7 @@
  *  Copyright (C) 1997, 1998  Krzysztof G. Baranowski
  */
 
+#include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include "sysv.h"
 
--- a/fs/udf/file.c~include-remove-highmemh-from-pagemaph
+++ a/fs/udf/file.c
@@ -33,6 +33,7 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/uio.h>
 
 #include "udf_i.h"
--- a/fs/ufs/ufs_fs.h~include-remove-highmemh-from-pagemaph
+++ a/fs/ufs/ufs_fs.h
@@ -35,6 +35,7 @@
 #include <linux/kernel.h>
 #include <linux/stat.h>
 #include <linux/fs.h>
+#include <linux/highmem.h>
 #include <linux/workqueue.h>
 
 #include <asm/div64.h>
--- a/include/linux/pagemap.h~include-remove-highmemh-from-pagemaph
+++ a/include/linux/pagemap.h
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/list.h>
-#include <linux/highmem.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
 #include <linux/gfp.h>
--- a/kernel/bpf/stackmap.c~include-remove-highmemh-from-pagemaph
+++ a/kernel/bpf/stackmap.c
@@ -8,6 +8,7 @@
 #include <linux/perf_event.h>
 #include <linux/elf.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/irq_work.h>
 #include "percpu_freelist.h"
 
--- a/lib/iov_iter.c~include-remove-highmemh-from-pagemaph
+++ a/lib/iov_iter.c
@@ -3,6 +3,7 @@
 #include <linux/bvec.h>
 #include <linux/uio.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/splice.h>
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c~include-remove-highmemh-from-pagemaph
+++ a/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -34,6 +34,7 @@
 #include <linux/sunrpc/gss_krb5.h>
 #include <linux/random.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 # define RPCDBG_FACILITY	RPCDBG_AUTH
--- a/net/sunrpc/cache.c~include-remove-highmemh-from-pagemaph
+++ a/net/sunrpc/cache.c
@@ -27,6 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <asm/ioctls.h>
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/cache.h>
_

Patches currently in -mm which might be from willy@infradead.org are

mm-improve-dump_page-for-compound-pages.patch
