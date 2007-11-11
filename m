From: akpm@linux-foundation.org
Subject: + add-64-bit-capability-support-to-the-kernel-fix-fix.patch added to -mm tree
Date: Sat, 10 Nov 2007 18:21:19 -0800
Message-ID: <200711110221.lAB2LJPh015993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbXKKCWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Nov 2007 21:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     kernel/capability.c get_task_comm compile error (MMOTM)
has been added to the -mm tree.  Its filename is
     add-64-bit-capability-support-to-the-kernel-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/capability.c get_task_comm compile error (MMOTM)
From: Erez Zadok <ezk@cs.sunysb.edu>

Using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
22:46".

$ make
  CC      kernel/capability.o
kernel/capability.c: In function 'sys_capset':
kernel/capability.c:231: warning: passing argument 1 of 'get_task_comm' from incompatible pointer type
kernel/capability.c:231: error: too few arguments to function 'get_task_comm'
make[1]: *** [kernel/capability.o] Error 1
make[1]: Target `__build' not remade because of errors.
make: *** [kernel] Error 2

Small patch below fixes compile error.

Erez.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/capability.c~add-64-bit-capability-support-to-the-kernel-fix-fix kernel/capability.c
--- a/kernel/capability.c~add-64-bit-capability-support-to-the-kernel-fix-fix
+++ a/kernel/capability.c
@@ -225,10 +225,11 @@ asmlinkage long sys_capset(cap_user_head
 	switch (version) {
 	case _LINUX_CAPABILITY_VERSION_1:
 		if (warned < 5) {
+			char name[sizeof(current->comm)];
 			warned++;
 			printk(KERN_INFO
 			       "warning: process `%s' sets w/ old libcap\n",
-			       get_task_comm(current));
+			       get_task_comm(name, current));
 		}
 		tocopy = _LINUX_CAPABILITY_U32S_1;
 		break;
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

hugetlb-follow_hugetlb_page-for-write-access-fix.patch
git-unionfs.patch
unionfs-clear-partial-read.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
