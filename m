From: akpm@linux-foundation.org
Subject: - git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state.patch removed from -mm tree
Date: Tue, 25 Sep 2007 10:22:35 -0700
Message-ID: <200709251722.l8PHMZr5028458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbXIYRWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, galak@gate.crashing.org, reuben-linuxkernel@reub.net, mm-commits@vger.kernel.org


The patch titled
     git-nfsd: fix Memory shortage can result in inconsistent flocks state"
has been removed from the -mm tree.  Its filename was
     git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-nfsd: fix Memory shortage can result in inconsistent flocks state"
From: "J. Bruce Fields" <bfields@fieldses.org>

On Mon, Sep 24, 2007 at 09:59:29AM -0700, Andrew Morton wrote:
> On Tue, 25 Sep 2007 00:52:30 +1000 Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
>
> >
> >
> > On 24/09/2007 7:17 PM, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> > >
> > > - New git tree git-powerpc-galak.patch added to the -mm lineup: ppc32
> > >   things, mainly (Kumar Gala <galak@gate.crashing.org>)
> >
> > I'm observing a problem with this kernel (as well as 2.6.23-rc6-mm1) which
> > manifests itself only in my Postfix/application mail.logs:
> >
> > Sep 25 00:25:40 tornado postfix/smtp[12520]: fatal: select lock: Cannot allocate
> > memory
> > Sep 25 00:25:41 tornado postfix/master[8002]: warning: process
> > /usr/lib64/postfix/smtp pid 12520 exit status 1
> >
> > This is happening frequently with processes started via 'master' (smtp, smtpd
> > and cleanup), but it does not appear to have any noticeable operational impact
> > apart from logging a lot of copies of this message.
> >
> > The corresponding code in Postfix which triggers this is (choice of 3 files in
> > src/master are all possibilities which all have much the same code)

Oog.  Looks like it's the "Memory shortage can result in inconsistent
flocks state" patch--the error variable is being set in some cases when
it shouldn't be.  Does the following fix it?

That's in my git tree, not in mainline.  I'll fix up my copy.

And I'll spend some time today figuring out what to do about regression
testing for the posix lock, flock, and lease code.

Thanks for the bug report!


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/locks.c~git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state fs/locks.c
--- a/fs/locks.c~git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state
+++ a/fs/locks.c
@@ -740,6 +740,7 @@ static int flock_lock_file(struct file *
 		new_fl = locks_alloc_lock();
 		if (new_fl == NULL)
 			goto out;
+		error = 0;
 	}
 
 	for_each_lock(inode, before) {
_

Patches currently in -mm which might be from bfields@fieldses.org are

git-nfs.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state.patch
fix-potential-oops-in-generic_setlease.patch
fix-potential-oops-in-generic_setlease-fix.patch
nfs-remove-congestion_end.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
dcache-trivial-comment-fix.patch
fs-nfsd-exportc-make-3-functions-static.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
cleanup-macros-for-distinguishing-mandatory-locks.patch
nfs-cleanup-explicit-check-for-mandatory-locks.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
