From: akpm@linux-foundation.org
Subject: - remove-bkl-from-remote_llseek-v2.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:48:04 -0700
Message-ID: <200807020748.m627m4sP005701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963AbYGBHtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, VANDROVE@vc.cvut.cz, ak@linux.intel.com, ak@suse.de, corbet@lwn.net, hch@lst.de, sfrench@us.ibm.com, swhiteho@redhat.com, trond.myklebust@fys.uio.no, mm-commits@v


The patch titled
     Remove BKL from remote_llseek
has been removed from the -mm tree.  Its filename was
     remove-bkl-from-remote_llseek-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove BKL from remote_llseek
From: Andi Kleen <andi@firstfloor.org>

- Replace remote_llseek with generic_file_llseek_unlocked (to force
  compilation failures in all users)

- Change all users to either use generic_file_llseek_unlocked directly
  or take the BKL around.  I changed the file systems who don't use the
  BKL for anything (CIFS, GFS) to call it directly.  NCPFS and SMBFS and
  NFS take the BKL, but explicitely in their own source now.

I moved them all over in a single patch to avoid unbisectable sections.

Open problem: 32bit kernels can corrupt fpos because its modification is
not atomic, but they can do that anyways because there's other paths who
modify it without BKL.

Do we need a special lock for the pos/f_version = 0 checks?

Trond says the NFS BKL is likely not needed, but keep it for now
until his full audit.

v2: Use generic_file_llseek_unlocked instead of remote_llseek_unlocked
    and factor duplicated code (suggested by hch)

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c   |    2 +-
 fs/gfs2/ops_file.c |    4 ++--
 fs/ncpfs/file.c    |   12 +++++++++++-
 fs/nfs/file.c      |    5 ++++-
 fs/read_write.c    |   38 +++++++++++---------------------------
 fs/smbfs/file.c    |   11 ++++++++++-
 include/linux/fs.h |    3 ++-
 7 files changed, 41 insertions(+), 34 deletions(-)

diff -puN fs/cifs/cifsfs.c~remove-bkl-from-remote_llseek-v2 fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~remove-bkl-from-remote_llseek-v2
+++ a/fs/cifs/cifsfs.c
@@ -639,7 +639,7 @@ static loff_t cifs_llseek(struct file *f
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return remote_llseek(file, offset, origin);
+	return generic_file_llseek_unlocked(file, offset, origin);
 }
 
 struct file_system_type cifs_fs_type = {
diff -puN fs/gfs2/ops_file.c~remove-bkl-from-remote_llseek-v2 fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~remove-bkl-from-remote_llseek-v2
+++ a/fs/gfs2/ops_file.c
@@ -62,11 +62,11 @@ static loff_t gfs2_llseek(struct file *f
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
-			error = remote_llseek(file, offset, origin);
+			error = generic_file_llseek_unlocked(file, offset, origin);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 	} else
-		error = remote_llseek(file, offset, origin);
+		error = generic_file_llseek_unlocked(file, offset, origin);
 
 	return error;
 }
diff -puN fs/ncpfs/file.c~remove-bkl-from-remote_llseek-v2 fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~remove-bkl-from-remote_llseek-v2
+++ a/fs/ncpfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
 #include "ncplib_kernel.h"
@@ -281,9 +282,18 @@ static int ncp_release(struct inode *ino
 	return 0;
 }
 
+static loff_t ncp_remote_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t ret;
+	lock_kernel();
+	ret = generic_file_llseek_unlocked(file, offset, origin);
+	unlock_kernel();
+	return ret;
+}
+
 const struct file_operations ncp_file_operations =
 {
-	.llseek		= remote_llseek,
+	.llseek 	= ncp_remote_llseek,
 	.read		= ncp_file_read,
 	.write		= ncp_file_write,
 	.ioctl		= ncp_ioctl,
diff -puN fs/nfs/file.c~remove-bkl-from-remote_llseek-v2 fs/nfs/file.c
--- a/fs/nfs/file.c~remove-bkl-from-remote_llseek-v2
+++ a/fs/nfs/file.c
@@ -192,7 +192,10 @@ static loff_t nfs_file_llseek(struct fil
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return remote_llseek(filp, offset, origin);
+	lock_kernel();	/* BKL needed? */
+	loff = generic_file_llseek_unlocked(filp, offset, origin);
+	unlock_kernel();
+	return loff;
 }
 
 /*
diff -puN fs/read_write.c~remove-bkl-from-remote_llseek-v2 fs/read_write.c
--- a/fs/read_write.c~remove-bkl-from-remote_llseek-v2
+++ a/fs/read_write.c
@@ -31,12 +31,12 @@ const struct file_operations generic_ro_
 
 EXPORT_SYMBOL(generic_ro_fops);
 
-loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
+loff_t
+generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
 	struct inode *inode = file->f_mapping->host;
 
-	mutex_lock(&inode->i_mutex);
 	switch (origin) {
 		case SEEK_END:
 			offset += inode->i_size;
@@ -46,42 +46,26 @@ loff_t generic_file_llseek(struct file *
 	}
 	retval = -EINVAL;
 	if (offset>=0 && offset<=inode->i_sb->s_maxbytes) {
+		/* Special lock needed here? */
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 			file->f_version = 0;
 		}
 		retval = offset;
 	}
-	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
+EXPORT_SYMBOL(generic_file_llseek_unlocked);
 
-EXPORT_SYMBOL(generic_file_llseek);
-
-loff_t remote_llseek(struct file *file, loff_t offset, int origin)
+loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
-	loff_t retval;
-
-	lock_kernel();
-	switch (origin) {
-		case SEEK_END:
-			offset += i_size_read(file->f_path.dentry->d_inode);
-			break;
-		case SEEK_CUR:
-			offset += file->f_pos;
-	}
-	retval = -EINVAL;
-	if (offset>=0 && offset<=file->f_path.dentry->d_inode->i_sb->s_maxbytes) {
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
-			file->f_version = 0;
-		}
-		retval = offset;
-	}
-	unlock_kernel();
-	return retval;
+	loff_t n;
+	mutex_lock(&file->f_dentry->d_inode->i_mutex);
+	n = generic_file_llseek_unlocked(file, offset, origin);
+	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	return n;
 }
-EXPORT_SYMBOL(remote_llseek);
+EXPORT_SYMBOL(generic_file_llseek);
 
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
 {
diff -puN fs/smbfs/file.c~remove-bkl-from-remote_llseek-v2 fs/smbfs/file.c
--- a/fs/smbfs/file.c~remove-bkl-from-remote_llseek-v2
+++ a/fs/smbfs/file.c
@@ -422,9 +422,18 @@ smb_file_permission(struct inode *inode,
 	return error;
 }
 
+static loff_t smb_remote_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t ret;
+	lock_kernel();
+	ret = generic_file_llseek_unlocked(file, offset, origin);
+	unlock_kernel();
+	return ret;
+}
+
 const struct file_operations smb_file_operations =
 {
-	.llseek		= remote_llseek,
+	.llseek 	= smb_remote_llseek,
 	.read		= do_sync_read,
 	.aio_read	= smb_file_aio_read,
 	.write		= do_sync_write,
diff -puN include/linux/fs.h~remove-bkl-from-remote_llseek-v2 include/linux/fs.h
--- a/include/linux/fs.h~remove-bkl-from-remote_llseek-v2
+++ a/include/linux/fs.h
@@ -1884,7 +1884,8 @@ extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
-extern loff_t remote_llseek(struct file *file, loff_t offset, int origin);
+extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
+			int origin);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
acpi-add-the-abity-to-reset-the-system-using-reset_reg-in-fadt-table.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
mm-add-alloc_pages_exact-and-free_pages_exact.patch
call_usermodehelper-increase-reliability.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
profile-likely-unlikely-macros.patch

