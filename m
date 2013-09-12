From: akpm@linux-foundation.org
Subject: [merged]
 mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:42:19 -0700
Message-ID: <5232191b.fVMQ+LftgiM5monP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3ILTmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, oleg@redhat.com

Subject: [merged] mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch removed from -mm tree
To: oleg@redhat.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:19 -0700


The patch titled
     Subject: mm: shift VM_GROWS* check from mmap_region() to do_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: shift VM_GROWS* check from mmap_region() to do_mmap_pgoff()

mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set.
In particular this means that mmap_region()->vma_merge(file, vm_flags)
must always fail if "vm_flags & VM_GROWS" is set incorrectly.

So it does not make sense to check VM_GROWS* after we already allocated
the new vma, the only caller, do_mmap_pgoff(), which can pass this flag
can do the check itself.

And this looks a bit more correct, mmap_region() already unmapped the
old mapping at this stage. But if mmap() is going to fail, it should
avoid do_munmap() if possible.

Note: we check VM_GROWS at the end to ensure that do_mmap_pgoff() won't
return EINVAL in the case when it currently returns another error code.

Many thanks to Hugh who nacked the buggy v1.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2 mm/mmap.c
--- a/mm/mmap.c~mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2
+++ a/mm/mmap.c
@@ -1302,6 +1302,8 @@ unsigned long do_mmap_pgoff(struct file
 
 			if (!file->f_op || !file->f_op->mmap)
 				return -ENODEV;
+			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
+				return -EINVAL;
 			break;
 
 		default:
@@ -1310,6 +1312,8 @@ unsigned long do_mmap_pgoff(struct file
 	} else {
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
+			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
+				return -EINVAL;
 			/*
 			 * Ignore pgoff.
 			 */
@@ -1544,11 +1548,7 @@ munmap_back:
 	vma->vm_pgoff = pgoff;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
-	error = -EINVAL;	/* when rejecting VM_GROWSDOWN|VM_GROWSUP */
-
 	if (file) {
-		if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
-			goto free_vma;
 		if (vm_flags & VM_DENYWRITE) {
 			error = deny_write_access(file);
 			if (error)
@@ -1573,8 +1573,6 @@ munmap_back:
 		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
-		if (unlikely(vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
-			goto free_vma;
 		error = shmem_zero_setup(vma);
 		if (error)
 			goto free_vma;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

