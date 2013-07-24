From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff.patch removed
 from -mm tree
Date: Wed, 24 Jul 2013 12:42:32 -0700
Message-ID: <51f02e28.ndQJlJs44glr8nJk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXTmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 15:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, ccross@android.com, oleg@redhat.com

Subject: [to-be-updated] mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff.patch removed from -mm tree
To: oleg@redhat.com,ccross@android.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 12:42:32 -0700


The patch titled
     Subject: mm: shift VM_GROWS* check from mmap_region() to do_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: shift VM_GROWS* check from mmap_region() to do_mmap_pgoff()

mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set. 
In particular this means that mmap_region()->vma_merge(file, vm_flags)
must always fail if vm_flags & VM_GROWS.  So it does not make sense to
check VM_GROWS* after we already allocated the new vma, the only caller,
do_mmap_pgoff(), which can pass this flag can do the check itself.

And this looks a bit more correct, mmap_region() already unmapped the old
mapping at this stage.  But if mmap() is going to fail, it should avoid
do_munmap() if possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@android.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff mm/mmap.c
--- a/mm/mmap.c~mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff
+++ a/mm/mmap.c
@@ -1327,6 +1327,9 @@ unsigned long do_mmap_pgoff(struct file
 		}
 	}
 
+	/* Only MAP_PRIVATE|MAP_ANONYMOUS can use MAP_GROWS */
+	if ((vm_flags & VM_MAYSHARE) && (vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
+		return -EINVAL;
 	/*
 	 * Set 'VM_NORESERVE' if we should not account for the
 	 * memory use of this mapping.
@@ -1544,11 +1547,7 @@ munmap_back:
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
@@ -1573,8 +1572,6 @@ munmap_back:
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
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
linux-next.patch

