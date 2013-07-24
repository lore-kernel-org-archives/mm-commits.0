From: akpm@linux-foundation.org
Subject: +
 mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch added to -mm tree
Date: Wed, 24 Jul 2013 12:43:28 -0700
Message-ID: <51f02e60.9rV0LrRp1RDV66C5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3GXTn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 15:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, oleg@redhat.com

Subject: + mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch added to -mm tree
To: oleg@redhat.com,hughd@google.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 12:43:28 -0700


The patch titled
     Subject: mm: shift VM_GROWS* check from mmap_region() to do_mmap_pgoff()
has been added to the -mm tree.  Its filename is
     mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
linux-next.patch

