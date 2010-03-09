From: akpm@linux-foundation.org
Subject: [merged] vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:54 -0800
Message-ID: <201003091903.o29J3su8031003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832Ab0CITE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com, hch@infradead.org, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: take f_lock on modifying f_mode after open time
has been removed from the -mm tree.  Its filename was
     vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: take f_lock on modifying f_mode after open time
From: Wu Fengguang <fengguang.wu@intel.com>

We'll introduce FMODE_RANDOM which will be runtime modified.  So protect
all runtime modification to f_mode with f_lock to avoid races.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@kernel.org>			[2.6.33.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c     |    2 ++
 fs/nfsd/nfs4state.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN fs/file_table.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time fs/file_table.c
--- a/fs/file_table.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time
+++ a/fs/file_table.c
@@ -393,7 +393,9 @@ retry:
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
+		spin_lock(&f->f_lock);
 		f->f_mode &= ~FMODE_WRITE;
+		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
 		file_release_write(f);
diff -puN fs/nfsd/nfs4state.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time
+++ a/fs/nfsd/nfs4state.c
@@ -1998,7 +1998,9 @@ nfs4_file_downgrade(struct file *filp, u
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
 		drop_file_write_access(filp);
+		spin_lock(&filp->f_lock);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
+		spin_unlock(&filp->f_lock);
 	}
 }
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-improve-writeback_inodes_wb.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch
vfs-add-super-operation-writeback_inodes.patch

