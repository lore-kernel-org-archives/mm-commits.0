From: akpm@linux-foundation.org
Subject: + vfs-implement-posix-o_sync-and-o_dsync-semantics.patch added to -mm tree
Date: Thu, 24 Sep 2009 16:41:56 -0700
Message-ID: <200909242341.n8ONfu8D003816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbZIXXnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 19:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, Trond.Myklebust@netapp.com, adilger@sun.com, davem@davemloft.net, drepper@redhat.com, grundler@parisc-linux.org, hpa@zytor.com, ink@jurassic.park.msu.ru, jack@suse.cz, kyle@mcmartin.ca, mingo@elte.hu, rth@twiddle.net, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: implement posix O_SYNC and O_DSYNC semantics
has been added to the -mm tree.  Its filename is
     vfs-implement-posix-o_sync-and-o_dsync-semantics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: implement posix O_SYNC and O_DSYNC semantics
From: Christoph Hellwig <hch@lst.de>

While Linux provided an O_SYNC flag basically since day 1, it took until
Linux 2.4.0-test12pre2 to actually get it implemented for filesystems,
since that day we had generic_osync_around with only minor changes and the
great "For now, when the user asks for O_SYNC, we'll actually give
O_DSYNC" comment.  This patch intends to actually give us real O_SYNC
semantics in addition to the O_DSYNC semantics.  After Jan's O_SYNC
patches which are required before this patch it's actually surprisingly
simple, we just need to figure out when to set the datasync flag to
vfs_fsync_range and when not.

This patch renames the existing O_SYNC flag to O_DSYNC while keeping it's
numerical value to keep binary compatibility, and adds a new real O_SYNC
flag.  To guarantee backwards compatiblity it is defined as expanding to
both the O_DSYNC and the new additional binary flag (__O_SYNC) to make
sure we are backwards-compatible when compiled against the new headers.

This also means that all places that don't care about the differences can
just check O_DSYNC and get the right behaviour for O_SYNC, too - only
places that actuall care need to check __O_SYNC in addition.  Drivers and
network filesystems have been updated in a fail safe way to always do the
full sync magic if O_DSYNC is set.  The few places setting O_SYNC for
lower layers are kept that way for now to stay failsafe.

We enforce that O_DSYNC is set when __O_SYNC is set early in the open path
to make sure we always get these sane options.

Note that parisc really screwed up their headers as they already define a
O_DSYNC that has always been a no-op.  We try to repair it by using it for
the new O_DSYNC and redefinining O_SYNC to send both the traditional
O_SYNC numerical value _and_ the O_DSYNC one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Ulrich Drepper <drepper@redhat.com>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/fcntl.h    |   19 ++++++++++++++++---
 arch/blackfin/include/asm/fcntl.h |    2 --
 arch/mips/include/asm/fcntl.h     |   17 ++++++++++++++++-
 arch/mips/kernel/kspd.c           |    1 +
 arch/mips/loongson/common/mem.c   |    2 +-
 arch/mips/mm/cache.c              |    2 +-
 arch/parisc/include/asm/fcntl.h   |    5 ++---
 arch/sparc/include/asm/fcntl.h    |   19 ++++++++++++++++---
 arch/x86/mm/pat.c                 |    2 +-
 drivers/char/mem.c                |    6 +++---
 drivers/usb/gadget/file_storage.c |    2 +-
 fs/afs/write.c                    |    5 +++--
 fs/btrfs/file.c                   |    4 ++--
 fs/cifs/dir.c                     |    3 ++-
 fs/cifs/file.c                    |    6 ++++--
 fs/namei.c                        |    9 +++++++++
 fs/nfs/file.c                     |    4 ++--
 fs/nfs/write.c                    |    2 +-
 fs/ocfs2/file.c                   |    2 +-
 fs/sync.c                         |    5 +++--
 fs/ubifs/file.c                   |    2 +-
 fs/xfs/linux-2.6/xfs_lrw.c        |    2 +-
 include/asm-generic/fcntl.h       |   25 +++++++++++++++++++++----
 sound/core/rawmidi.c              |    2 +-
 24 files changed, 109 insertions(+), 39 deletions(-)

diff -puN arch/alpha/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/alpha/include/asm/fcntl.h
--- a/arch/alpha/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/alpha/include/asm/fcntl.h
@@ -1,8 +1,6 @@
 #ifndef _ALPHA_FCNTL_H
 #define _ALPHA_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_CREAT		 01000	/* not fcntl */
 #define O_TRUNC		 02000	/* not fcntl */
 #define O_EXCL		 04000	/* not fcntl */
@@ -10,13 +8,28 @@
 
 #define O_NONBLOCK	 00004
 #define O_APPEND	 00010
-#define O_SYNC		040000
+#define O_DSYNC		040000	/* used to be O_SYNC, see below */
 #define O_DIRECTORY	0100000	/* must be a directory */
 #define O_NOFOLLOW	0200000 /* don't follow links */
 #define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
 #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
 #define O_NOATIME	04000000
 #define O_CLOEXEC	010000000 /* set close_on_exec */
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#define __O_SYNC	020000000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 
 #define F_GETLK		7
 #define F_SETLK		8
diff -puN arch/blackfin/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/blackfin/include/asm/fcntl.h
--- a/arch/blackfin/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/blackfin/include/asm/fcntl.h
@@ -1,8 +1,6 @@
 #ifndef _BFIN_FCNTL_H
 #define _BFIN_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_DIRECTORY	 040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
 #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
diff -puN arch/mips/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/mips/include/asm/fcntl.h
--- a/arch/mips/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/mips/include/asm/fcntl.h
@@ -10,7 +10,7 @@
 
 
 #define O_APPEND	0x0008
-#define O_SYNC		0x0010
+#define O_DSYNC		0x0010	/* used to be O_SYNC, see below */
 #define O_NONBLOCK	0x0080
 #define O_CREAT         0x0100	/* not fcntl */
 #define O_TRUNC		0x0200	/* not fcntl */
@@ -18,6 +18,21 @@
 #define O_NOCTTY	0x0800	/* not fcntl */
 #define FASYNC		0x1000	/* fcntl, for BSD compatibility */
 #define O_LARGEFILE	0x2000	/* allow large file opens */
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#define __O_SYNC	0x4000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 #define O_DIRECT	0x8000	/* direct disk access hint */
 
 #define F_GETLK		14
diff -puN arch/mips/kernel/kspd.c~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/mips/kernel/kspd.c
--- a/arch/mips/kernel/kspd.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/mips/kernel/kspd.c
@@ -82,6 +82,7 @@ static int sp_stopping;
 #define MTSP_O_SHLOCK		0x0010
 #define MTSP_O_EXLOCK		0x0020
 #define MTSP_O_ASYNC		0x0040
+/* XXX: check which of these is actually O_SYNC vs O_DSYNC */
 #define MTSP_O_FSYNC		O_SYNC
 #define MTSP_O_NOFOLLOW		0x0100
 #define MTSP_O_SYNC		0x0080
diff -puN arch/mips/loongson/common/mem.c~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/mips/loongson/common/mem.c
--- a/arch/mips/loongson/common/mem.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/mips/loongson/common/mem.c
@@ -26,7 +26,7 @@ void __init prom_init_memory(void)
 /* override of arch/mips/mm/cache.c: __uncached_access */
 int __uncached_access(struct file *file, unsigned long addr)
 {
-	if (file->f_flags & O_SYNC)
+	if (file->f_flags & O_DSYNC)
 		return 1;
 
 	return addr >= __pa(high_memory) ||
diff -puN arch/mips/mm/cache.c~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/mips/mm/cache.c
@@ -194,7 +194,7 @@ void __devinit cpu_cache_init(void)
 
 int __weak __uncached_access(struct file *file, unsigned long addr)
 {
-	if (file->f_flags & O_SYNC)
+	if (file->f_flags & O_DSYNC)
 		return 1;
 
 	return addr >= __pa(high_memory);
diff -puN arch/parisc/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/parisc/include/asm/fcntl.h
--- a/arch/parisc/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/parisc/include/asm/fcntl.h
@@ -1,14 +1,13 @@
 #ifndef _PARISC_FCNTL_H
 #define _PARISC_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_APPEND	000000010
 #define O_BLKSEEK	000000100 /* HPUX only */
 #define O_CREAT		000000400 /* not fcntl */
 #define O_EXCL		000002000 /* not fcntl */
 #define O_LARGEFILE	000004000
-#define O_SYNC		000100000
+#define __O_SYNC	000100000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 #define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */
 #define O_NOCTTY	000400000 /* not fcntl */
 #define O_DSYNC		001000000 /* HPUX only */
diff -puN arch/sparc/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/sparc/include/asm/fcntl.h
--- a/arch/sparc/include/asm/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/sparc/include/asm/fcntl.h
@@ -1,14 +1,12 @@
 #ifndef _SPARC_FCNTL_H
 #define _SPARC_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_APPEND	0x0008
 #define FASYNC		0x0040	/* fcntl, for BSD compatibility */
 #define O_CREAT		0x0200	/* not fcntl */
 #define O_TRUNC		0x0400	/* not fcntl */
 #define O_EXCL		0x0800	/* not fcntl */
-#define O_SYNC		0x2000
+#define O_DSYNC		0x2000	/* used to be O_SYNC, see below */
 #define O_NONBLOCK	0x4000
 #if defined(__sparc__) && defined(__arch64__)
 #define O_NDELAY	0x0004
@@ -20,6 +18,21 @@
 #define O_DIRECT        0x100000 /* direct disk access hint */
 #define O_NOATIME	0x200000
 #define O_CLOEXEC	0x400000
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#define __O_SYNC	0x800000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
diff -puN arch/x86/mm/pat.c~vfs-implement-posix-o_sync-and-o_dsync-semantics arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/arch/x86/mm/pat.c
@@ -705,7 +705,7 @@ int phys_mem_access_prot_allowed(struct 
 	if (!range_is_allowed(pfn, size))
 		return 0;
 
-	if (file->f_flags & O_SYNC) {
+	if (file->f_flags & O_DSYNC) {
 		flags = _PAGE_CACHE_UC_MINUS;
 	}
 
diff -puN drivers/char/mem.c~vfs-implement-posix-o_sync-and-o_dsync-semantics drivers/char/mem.c
--- a/drivers/char/mem.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/drivers/char/mem.c
@@ -44,7 +44,7 @@ static inline int uncached_access(struct
 {
 #if defined(CONFIG_IA64)
 	/*
-	 * On ia64, we ignore O_SYNC because we cannot tolerate memory attribute aliases.
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory attribute aliases.
 	 */
 	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
 #elif defined(CONFIG_MIPS)
@@ -57,9 +57,9 @@ static inline int uncached_access(struct
 #else
 	/*
 	 * Accessing memory above the top the kernel knows about or through a file pointer
-	 * that was marked O_SYNC will be done non-cached.
+	 * that was marked O_DSYNC will be done non-cached.
 	 */
-	if (file->f_flags & O_SYNC)
+	if (file->f_flags & O_DSYNC)
 		return 1;
 	return addr >= __pa(high_memory);
 #endif
diff -puN drivers/usb/gadget/file_storage.c~vfs-implement-posix-o_sync-and-o_dsync-semantics drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/drivers/usb/gadget/file_storage.c
@@ -1713,7 +1713,7 @@ static int do_write(struct fsg_dev *fsg)
 		}
 		if (fsg->cmnd[1] & 0x08) {	// FUA
 			spin_lock(&curlun->filp->f_lock);
-			curlun->filp->f_flags |= O_SYNC;
+			curlun->filp->f_flags |= O_DSYNC;
 			spin_unlock(&curlun->filp->f_lock);
 		}
 	}
diff -puN fs/afs/write.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/afs/write.c
--- a/fs/afs/write.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/afs/write.c
@@ -692,8 +692,9 @@ ssize_t afs_file_write(struct kiocb *ioc
 	}
 
 	/* return error values for O_SYNC and IS_SYNC() */
-	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_SYNC) {
-		ret = afs_fsync(iocb->ki_filp, dentry, 1);
+	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_DSYNC) {
+		ret = afs_fsync(iocb->ki_filp, dentry,
+				(iocb->ki_filp->f_flags & __O_SYNC) ? 0 : 1);
 		if (ret < 0)
 			result = ret;
 	}
diff -puN fs/btrfs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/btrfs/file.c
--- a/fs/btrfs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/btrfs/file.c
@@ -905,7 +905,7 @@ static ssize_t btrfs_file_write(struct f
 	unsigned long last_index;
 	int will_write;
 
-	will_write = ((file->f_flags & O_SYNC) || IS_SYNC(inode) ||
+	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));
 
 	nrptrs = min((count + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE,
@@ -1058,7 +1058,7 @@ out_nolock:
 		if (err)
 			num_written = err;
 
-		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 1);
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
diff -puN fs/cifs/dir.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/cifs/dir.c
--- a/fs/cifs/dir.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/cifs/dir.c
@@ -213,7 +213,8 @@ int cifs_posix_open(char *full_path, str
 		posix_flags |= SMB_O_TRUNC;
 	if (oflags & O_APPEND)
 		posix_flags |= SMB_O_APPEND;
-	if (oflags & O_SYNC)
+	/* be safe and imply O_SYNC for O_DSYNC */
+	if (oflags & O_DSYNC)
 		posix_flags |= SMB_O_SYNC;
 	if (oflags & O_DIRECTORY)
 		posix_flags |= SMB_O_DIRECTORY;
diff -puN fs/cifs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/cifs/file.c
--- a/fs/cifs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/cifs/file.c
@@ -96,8 +96,10 @@ static inline fmode_t cifs_posix_convert
 	   reopening a file.  They had their effect on the original open */
 	if (flags & O_APPEND)
 		posix_flags |= (fmode_t)O_APPEND;
-	if (flags & O_SYNC)
-		posix_flags |= (fmode_t)O_SYNC;
+	if (flags & O_DSYNC)
+		posix_flags |= (fmode_t)O_DSYNC;
+	if (flags & __O_SYNC)
+		posix_flags |= (fmode_t)__O_SYNC;
 	if (flags & O_DIRECTORY)
 		posix_flags |= (fmode_t)O_DIRECTORY;
 	if (flags & O_NOFOLLOW)
diff -puN fs/namei.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/namei.c
--- a/fs/namei.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/namei.c
@@ -1678,6 +1678,15 @@ struct file *do_filp_open(int dfd, const
 	int will_write;
 	int flag = open_to_namei_flags(open_flag);
 
+	/*
+	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
+	 * check for O_DSYNC if the need any syncing at all we enforce it's
+	 * always set instead of having to deal with possibly weird behaviour
+	 * for malicious applications setting only __O_SYNC.
+	 */
+	if (open_flag & __O_SYNC)
+		open_flag |= O_DSYNC;
+
 	if (!acc_mode)
 		acc_mode = MAY_OPEN | ACC_MODE(flag);
 
diff -puN fs/nfs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/nfs/file.c
--- a/fs/nfs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/nfs/file.c
@@ -581,7 +581,7 @@ static int nfs_need_sync_write(struct fi
 {
 	struct nfs_open_context *ctx;
 
-	if (IS_SYNC(inode) || (filp->f_flags & O_SYNC))
+	if (IS_SYNC(inode) || (filp->f_flags & O_DSYNC))
 		return 1;
 	ctx = nfs_file_open_context(filp);
 	if (test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags))
@@ -622,7 +622,7 @@ static ssize_t nfs_file_write(struct kio
 
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, count);
 	result = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	/* Return error values for O_SYNC and IS_SYNC() */
+	/* Return error values for O_DSYNC and IS_SYNC() */
 	if (result >= 0 && nfs_need_sync_write(iocb->ki_filp, inode)) {
 		int err = nfs_do_fsync(nfs_file_open_context(iocb->ki_filp), inode);
 		if (err < 0)
diff -puN fs/nfs/write.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/nfs/write.c
--- a/fs/nfs/write.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/nfs/write.c
@@ -774,7 +774,7 @@ int nfs_updatepage(struct file *file, st
 	 */
 	if (nfs_write_pageuptodate(page, inode) &&
 			inode->i_flock == NULL &&
-			!(file->f_flags & O_SYNC)) {
+			!(file->f_flags & O_DSYNC)) {
 		count = max(count + offset, nfs_page_length(page));
 		offset = 0;
 	}
diff -puN fs/ocfs2/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/ocfs2/file.c
@@ -2005,7 +2005,7 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
-	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
+	if ((file->f_flags & O_DSYNC && !direct_io) || IS_SYNC(inode)) {
 		ret = filemap_fdatawrite_range(file->f_mapping, pos,
 					       pos + count - 1);
 		if (ret < 0)
diff -puN fs/sync.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/sync.c
--- a/fs/sync.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/sync.c
@@ -295,10 +295,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int,
  */
 int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
-	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
+	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
 		return 0;
 	return vfs_fsync_range(file, file->f_path.dentry, pos,
-			       pos + count - 1, 1);
+			       pos + count - 1,
+			       (file->f_flags & __O_SYNC) ? 0 : 1);
 }
 EXPORT_SYMBOL(generic_write_sync);
 
diff -puN fs/ubifs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/ubifs/file.c
--- a/fs/ubifs/file.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/ubifs/file.c
@@ -1401,7 +1401,7 @@ static ssize_t ubifs_aio_write(struct ki
 	if (ret < 0)
 		return ret;
 
-	if (ret > 0 && (IS_SYNC(inode) || iocb->ki_filp->f_flags & O_SYNC)) {
+	if (ret > 0 && (IS_SYNC(inode) || iocb->ki_filp->f_flags & O_DSYNC)) {
 		err = ubifs_sync_wbufs_by_inode(c, inode);
 		if (err)
 			return err;
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~vfs-implement-posix-o_sync-and-o_dsync-semantics fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -811,7 +811,7 @@ write_retry:
 	XFS_STATS_ADD(xs_write_bytes, ret);
 
 	/* Handle various SYNC-type writes */
-	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
 		int error2;
 
diff -puN include/asm-generic/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/include/asm-generic/fcntl.h
@@ -3,8 +3,6 @@
 
 #include <linux/types.h>
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_ACCMODE	00000003
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
@@ -27,8 +25,8 @@
 #ifndef O_NONBLOCK
 #define O_NONBLOCK	00004000
 #endif
-#ifndef O_SYNC
-#define O_SYNC		00010000
+#ifndef O_DSYNC
+#define O_DSYNC		00010000	/* used to be O_SYNC, see below */
 #endif
 #ifndef FASYNC
 #define FASYNC		00020000	/* fcntl, for BSD compatibility */
@@ -51,6 +49,25 @@
 #ifndef O_CLOEXEC
 #define O_CLOEXEC	02000000	/* set close_on_exec */
 #endif
+
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#ifndef O_SYNC
+#define __O_SYNC	04000000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
diff -puN sound/core/rawmidi.c~vfs-implement-posix-o_sync-and-o_dsync-semantics sound/core/rawmidi.c
--- a/sound/core/rawmidi.c~vfs-implement-posix-o_sync-and-o_dsync-semantics
+++ a/sound/core/rawmidi.c
@@ -1258,7 +1258,7 @@ static ssize_t snd_rawmidi_write(struct 
 			break;
 		count -= count1;
 	}
-	if (file->f_flags & O_SYNC) {
+	if (file->f_flags & O_DSYNC) {
 		spin_lock_irq(&runtime->lock);
 		while (runtime->avail != runtime->buffer_size) {
 			wait_queue_t wait;
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics.patch
xtensa-convert-to-asm-generic-hardirqh.patch

