From: akpm@linux-foundation.org
Subject: [merged] nfsd-dont-hold-unrefcounted-creds-over-call-to-nfsd_setuser.patch removed from -mm tree
Date: Sun, 05 Jul 2009 11:35:56 -0700
Message-ID: <200907051835.n65IZupA004846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZGESgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jul 2009 14:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bfields@fieldses.org, jmorris@namei.org, neilb@suse.de, rasmus@msconsult.dk, steved@redhat.com, mm-commits@vger.kernel.org


The patch titled
     nfsd: don't hold unrefcounted creds over call to nfsd_setuser()
has been removed from the -mm tree.  Its filename was
     nfsd-dont-hold-unrefcounted-creds-over-call-to-nfsd_setuser.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfsd: don't hold unrefcounted creds over call to nfsd_setuser()
From: David Howells <dhowells@redhat.com>

nfsd_open() gets an unrefcounted pointer to the current process's
effective credentials at the top of the function, then calls
nfsd_setuser() via fh_verify() - which may replace and destroy the current
process's effective credentials - and then passes the unrefcounted pointer
to dentry_open() - but the credentials may have been destroyed by this
point.

Instead, the value from current_cred() should be passed directly to
dentry_open() as one of its arguments, rather than being cached in a
variable.

Possibly fh_verify() should return the creds to use.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-and-Verified-By: Steve Dickson <steved@redhat.com>
Cc: <rasmus@msconsult.dk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/nfsd/vfs.c~nfsd-dont-hold-unrefcounted-creds-over-call-to-nfsd_setuser fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-dont-hold-unrefcounted-creds-over-call-to-nfsd_setuser
+++ a/fs/nfsd/vfs.c
@@ -678,7 +678,6 @@ __be32
 nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 			int access, struct file **filp)
 {
-	const struct cred *cred = current_cred();
 	struct dentry	*dentry;
 	struct inode	*inode;
 	int		flags = O_RDONLY|O_LARGEFILE;
@@ -733,7 +732,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 		vfs_dq_init(inode);
 	}
 	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt),
-			    flags, cred);
+			    flags, current_cred());
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
 	else
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
elf-fix-multithreaded-program-core-dumping-on-arm.patch
flat-fix-uninitialized-ptr-with-shared-libs.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
frv-duplicate-output_buffer-of-e03.patch
rework-fix-is_single_threaded.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch
flat-use-is_err_value-helper-macro.patch
mutex-subsystem-synchro-test-module.patch

