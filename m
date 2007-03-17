From: akpm@linux-foundation.org
Subject: - xfs-use-xfs_get_buf_noaddr-for-iclogs.patch removed from -mm tree
Date: Fri, 16 Mar 2007 17:48:28 -0700
Message-ID: <200703170050.l2H0oL4D025729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45168 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992478AbXCQAu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 20:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     xfs: use xfs_get_buf_noaddr for iclogs
has been removed from the -mm tree.  Its filename was
     xfs-use-xfs_get_buf_noaddr-for-iclogs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: xfs: use xfs_get_buf_noaddr for iclogs
From: Christoph Hellwig <hch@lst.de>

Many block drivers (aoe, iscsi) really want refcountable pages in bios, which
is what almost everyone send down.  XFS unfortunately has a few places where
it sends down buffers that may come from kmalloc, which breaks them.  The
patches in this series fix this issue up.

This patch:

Currently xlog_alloc allocates memory for the iclogs first, then allocates a
buffer using xfs_buf_get_empty and finally assigns the memory to the buffer. 
We don't really want to do this, but rather allocate a buffer with memory
attached to it using xfs_buf_get_noaddr.  There's a subtile change because
xfs_buf_get_empty returns the buffer locked, but xfs_buf_get_noaddr returns it
unlocked.  From my auditing and testing nothing in the log I/O code cares
about this distincition, but I'd be happy if someone could try to prove this
independently.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_log.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/xfs/xfs_log.c~xfs-use-xfs_get_buf_noaddr-for-iclogs fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-use-xfs_get_buf_noaddr-for-iclogs
+++ a/fs/xfs/xfs_log.c
@@ -1199,11 +1199,16 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		*iclogp = (xlog_in_core_t *)
 			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
 		iclog = *iclogp;
-		iclog->hic_data = (xlog_in_core_2_t *)
-			  kmem_zalloc(iclogsize, KM_SLEEP | KM_LARGE);
-
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
+
+		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
+		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
+		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
+		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
+		iclog->ic_bp = bp;
+		iclog->hic_data = bp->b_addr;
+
 		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
 
 		head = &iclog->ic_header;
@@ -1216,11 +1221,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		INT_SET(head->h_fmt, ARCH_CONVERT, XLOG_FMT);
 		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
 
-		bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
-		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
-		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
-		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
-		iclog->ic_bp = bp;
 
 		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
@@ -1229,7 +1229,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
-		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
 		sv_init(&iclog->ic_forcesema, SV_DEFAULT, "iclog-force");
 		sv_init(&iclog->ic_writesema, SV_DEFAULT, "iclog-write");
 
@@ -1528,7 +1527,6 @@ xlog_dealloc_log(xlog_t *log)
 		}
 #endif
 		next_iclog = iclog->ic_next;
-		kmem_free(iclog->hic_data, log->l_iclog_size);
 		kmem_free(iclog, sizeof(xlog_in_core_t));
 		iclog = next_iclog;
 	}
_

Patches currently in -mm which might be from hch@lst.de are

ufs2-tindirect-truncate-fix.patch
cifs-remove-unneeded-checks.patch
xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
