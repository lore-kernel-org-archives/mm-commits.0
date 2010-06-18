From: akpm@linux-foundation.org
Subject: + gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:33 -0700
Message-ID: <201006182331.o5INVXxR029547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab0FRXbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     gcc-4.6: nfsd: fix initialized but not read warnings
has been added to the -mm tree.  Its filename is
     gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch

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
Subject: gcc-4.6: nfsd: fix initialized but not read warnings
From: Andi Kleen <andi@firstfloor.org>

Fixes at least one real minor bug: the nfs4 recovery dir sysctl
would not return its status properly.

Also I finished Al's 1e41568d7378d ("Take ima_path_check() in nfsd
past dentry_open() in nfsd_open()") commit, it moved the IMA
code, but left the old path initializer in there.

The rest is just dead code removed I think, although I was not
fully sure about the "is_borc" stuff. Some more review
would be still good.

Found by gcc 4.6's new warnings.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    2 --
 fs/nfsd/nfsctl.c    |    2 ++
 fs/nfsd/nfsproc.c   |    2 --
 fs/nfsd/vfs.c       |   11 +----------
 4 files changed, 3 insertions(+), 14 deletions(-)

diff -puN fs/nfsd/nfs4state.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings
+++ a/fs/nfsd/nfs4state.c
@@ -3354,11 +3354,9 @@ static inline void
 nfs4_set_lock_denied(struct file_lock *fl, struct nfsd4_lock_denied *deny)
 {
 	struct nfs4_stateowner *sop;
-	unsigned int hval;
 
 	if (fl->fl_lmops == &nfsd_posix_mng_ops) {
 		sop = (struct nfs4_stateowner *) fl->fl_owner;
-		hval = lockownerid_hashval(sop->so_id);
 		kref_get(&sop->so_ref);
 		deny->ld_sop = sop;
 		deny->ld_clientid = sop->so_client->cl_clientid;
diff -puN fs/nfsd/nfsctl.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings
+++ a/fs/nfsd/nfsctl.c
@@ -1310,6 +1310,8 @@ static ssize_t __write_recoverydir(struc
 			return -EINVAL;
 
 		status = nfs4_reset_recoverydir(recdir);
+		if (status)
+			return status;
 	}
 
 	return scnprintf(buf, SIMPLE_TRANSACTION_LIMIT, "%s\n",
diff -puN fs/nfsd/nfsproc.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings fs/nfsd/nfsproc.c
--- a/fs/nfsd/nfsproc.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings
+++ a/fs/nfsd/nfsproc.c
@@ -290,7 +290,6 @@ nfsd_proc_create(struct svc_rqst *rqstp,
 	 * gospel of sun micro
 	 */
 	if (type != S_IFREG) {
-		int	is_borc = 0;
 		if (type != S_IFBLK && type != S_IFCHR) {
 			rdev = 0;
 		} else if (type == S_IFCHR && !(attr->ia_valid & ATTR_SIZE)) {
@@ -298,7 +297,6 @@ nfsd_proc_create(struct svc_rqst *rqstp,
 			type = S_IFIFO;
 		} else {
 			/* Okay, char or block special */
-			is_borc = 1;
 			if (!rdev)
 				rdev = wanted;
 		}
diff -puN fs/nfsd/vfs.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~gcc-46-nfsd-fix-initialized-but-not-read-warnings
+++ a/fs/nfsd/vfs.c
@@ -1631,7 +1631,7 @@ nfsd_link(struct svc_rqst *rqstp, struct
 				char *name, int len, struct svc_fh *tfhp)
 {
 	struct dentry	*ddir, *dnew, *dold;
-	struct inode	*dirp, *dest;
+	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
 
@@ -1659,7 +1659,6 @@ nfsd_link(struct svc_rqst *rqstp, struct
 		goto out_nfserr;
 
 	dold = tfhp->fh_dentry;
-	dest = dold->d_inode;
 
 	host_err = mnt_want_write(tfhp->fh_export->ex_path.mnt);
 	if (host_err) {
@@ -2111,15 +2110,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
 		err = inode_permission(inode, MAY_EXEC);
-	if (err)
-		goto nfsd_out;
 
-	/* Do integrity (permission) checking now, but defer incrementing
-	 * IMA counts to the actual file open.
-	 */
-	path.mnt = exp->ex_path.mnt;
-	path.dentry = dentry;
-nfsd_out:
 	return err? nfserrno(err) : 0;
 }
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

