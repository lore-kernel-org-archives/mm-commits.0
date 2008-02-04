From: akpm@linux-foundation.org
Subject: - add-64-bit-capability-support-to-the-kernel-fix-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:55:54 -0800
Message-ID: <200802040355.m143tZva012706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbYBDD4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:56:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel/capability.c get_task_comm compile error (MMOTM)
has been removed from the -mm tree.  Its filename was
     add-64-bit-capability-support-to-the-kernel-fix-fix.patch

This patch was dropped because it was folded into add-64-bit-capability-support-to-the-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
read_current_time-cleanups-build-fix.patch
read_current_time-cleanups-build-fix-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
