From: akpm@linux-foundation.org
Subject: - use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch removed from -mm tree
Date: Thu, 14 Feb 2008 15:27:16 -0800
Message-ID: <200802142327.m1ENRGCv008557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757462AbYBNX2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 18:28:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     NFSD: fix wrong mnt_writer count in rename
has been removed from the -mm tree.  Its filename was
     use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch

This patch was dropped because it was folded into use-struct-path-in-struct-svc_export.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

diff -puN fs/nfsd/vfs.c~use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename
+++ a/fs/nfsd/vfs.c
@@ -1702,6 +1702,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		if (!host_err)
 			host_err = nfsd_sync_dir(fdentry);
 	}
+	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
 
  out_dput_new:
 	dput(ndentry);
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

git-unionfs.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
