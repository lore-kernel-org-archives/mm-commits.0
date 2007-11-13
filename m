From: akpm@linux-foundation.org
Subject: + nfsd-fix-wrong-mnt_writer-count-in-rename.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:34:37 -0800
Message-ID: <200711130134.lAD1Ybbu020104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbXKMBfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, haveblue@us.ibm.com, hch@infradead.org


The patch titled
     NFSD: fix wrong mnt_writer count in rename
has been added to the -mm tree.  Its filename is
     nfsd-fix-wrong-mnt_writer-count-in-rename.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFSD: fix wrong mnt_writer count in rename
From: Erez Zadok <ezk@cs.sunysb.edu>

NFSD forgets to call mnt_drop_write after a successful rename.  Here's a
fix.  (Ah, the curse of a stackable file system developer: you have to
debug everyone else's too.  :-)

One thing I wasn't sure is whether I could move the mnt_drop_write line a
little above, just after the call to vfs_rename.  If we can drop the ref
earlier, it could improve scalability/performance just a bit, no?  (i.e.,
what are the ramifications of holding on to this mnt writer ref longer than
needed?)

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nfsd/vfs.c~nfsd-fix-wrong-mnt_writer-count-in-rename fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-fix-wrong-mnt_writer-count-in-rename
+++ a/fs/nfsd/vfs.c
@@ -1688,6 +1688,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		if (!host_err)
 			host_err = nfsd_sync_dir(fdentry);
 	}
+	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
 
  out_dput_new:
 	dput(ndentry);
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

hugetlb-follow_hugetlb_page-for-write-access-fix.patch
git-unionfs.patch
unionfs-clear-partial-read.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
x86-early_quirks-fix-build.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
read_current_time-cleanups-build-fix.patch
nfsd-fix-wrong-mnt_writer-count-in-rename.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
