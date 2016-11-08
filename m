From: akpm@linux-foundation.org
Subject: + ipc-fixed-warnings.patch added to -mm tree
Date: Tue, 08 Nov 2016 14:36:06 -0800
Message-ID: <58225356.5MtOxJ6hIbid3R62%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbcKHWgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 17:36:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: p.shailesh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: coding style fixes
has been added to the -mm tree.  Its filename is
     ipc-fixed-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-fixed-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-fixed-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shailesh Pandey <p.shailesh@samsung.com>
Subject: ipc/shm.c: coding style fixes

This patch fixes below warnings
WARNING: Missing a blank line after declarations
WARNING: Block comments use a trailing */ on a separate line
ERROR: spaces required around that '=' (ctx:WxV)

Above warnings were reported by checkpatch.pl

Link: http://lkml.kernel.org/r/1478604980-18062-1-git-send-email-p.shailesh@samsung.com
Signed-off-by: Shailesh Pandey <p.shailesh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN ipc/shm.c~ipc-fixed-warnings ipc/shm.c
--- a/ipc/shm.c~ipc-fixed-warnings
+++ a/ipc/shm.c
@@ -89,6 +89,7 @@ void shm_init_ns(struct ipc_namespace *n
 static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
 	struct shmid_kernel *shp;
+
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
 	if (shp->shm_nattch) {
@@ -387,6 +388,7 @@ static int shm_set_policy(struct vm_area
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 	int err = 0;
+
 	if (sfd->vm_ops->set_policy)
 		err = sfd->vm_ops->set_policy(vma, new);
 	return err;
@@ -417,7 +419,7 @@ static int shm_mmap(struct file *file, s
 	 * In case of remap_file_pages() emulation, the file can represent
 	 * removed IPC ID: propogate shm_lock() error to caller.
 	 */
-	ret =__shm_open(vma);
+	ret = __shm_open(vma);
 	if (ret)
 		return ret;
 
@@ -468,6 +470,7 @@ static unsigned long shm_get_unmapped_ar
 	unsigned long flags)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
+
 	return sfd->file->f_op->get_unmapped_area(sfd->file, addr, len,
 						pgoff, flags);
 }
@@ -766,6 +769,7 @@ static void shm_add_rss_swap(struct shmi
 	} else {
 #ifdef CONFIG_SHMEM
 		struct shmem_inode_info *info = SHMEM_I(inode);
+
 		spin_lock_irq(&info->lock);
 		*rss_add += inode->i_mapping->nrpages;
 		*swp_add += info->swapped;
@@ -1028,6 +1032,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
+
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
 			    !uid_eq(euid, shp->shm_perm.cuid)) {
 				err = -EPERM;
@@ -1045,6 +1050,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 
 		if (cmd == SHM_LOCK) {
 			struct user_struct *user = current_user();
+
 			err = shmem_lock(shm_file, 1, user);
 			if (!err && !(shp->shm_perm.mode & SHM_LOCKED)) {
 				shp->shm_perm.mode |= SHM_LOCKED;
@@ -1354,9 +1360,10 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 		vma = next;
 	}
 
-#else /* CONFIG_MMU */
+#else	/* CONFIG_MMU */
 	/* under NOMMU conditions, the exact address to be destroyed must be
-	 * given */
+	 * given
+	 */
 	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
 		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 		retval = 0;
_

Patches currently in -mm which might be from p.shailesh@samsung.com are

ipc-fixed-warnings.patch

