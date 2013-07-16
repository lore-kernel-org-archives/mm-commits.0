From: akpm@linux-foundation.org
Subject: +
 mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch added to -mm tree
Date: Tue, 16 Jul 2013 14:43:31 -0700
Message-ID: <51e5be83.EgV68kZ0NNW2hAVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab3GPVnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 17:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, ccross@android.com, oleg@redhat.com

Subject: + mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch added to -mm tree
To: oleg@redhat.com,ccross@android.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 14:43:31 -0700


The patch titled
     Subject: mm: mmap_region: kill correct_wcount/inode, use allow_write_access()
has been added to the -mm tree.  Its filename is
     mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch

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
Subject: mm: mmap_region: kill correct_wcount/inode, use allow_write_access()

correct_wcount and inode in mmap_region() just complicate the code.  This
boolean was needed previously, when deny_write_access() was called before
vma_merge(), now we can simply check VM_DENYWRITE and do
allow_write_access() if it is set.

allow_write_access() checks file != NULL, so this is safe even if it was
possible to use VM_DENYWRITE && !file.  Just we need to ensure we use the
same file which was deny_write_access()'ed, so the patch also moves "file
= vma->vm_file" down after allow_write_access().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@android.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access mm/mmap.c
--- a/mm/mmap.c~mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access
+++ a/mm/mmap.c
@@ -1478,11 +1478,9 @@ unsigned long mmap_region(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
-	int correct_wcount = 0;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
-	struct inode *inode =  file ? file_inode(file) : NULL;
 
 	/* Check against address space limit. */
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
@@ -1551,7 +1549,6 @@ munmap_back:
 			error = deny_write_access(file);
 			if (error)
 				goto free_vma;
-			correct_wcount = 1;
 		}
 		vma->vm_file = get_file(file);
 		error = file->f_op->mmap(file, vma);
@@ -1592,11 +1589,10 @@ munmap_back:
 	}
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
-	file = vma->vm_file;
-
 	/* Once vma denies write, undo our temporary denial count */
-	if (correct_wcount)
-		atomic_inc(&inode->i_writecount);
+	if (vm_flags & VM_DENYWRITE)
+		allow_write_access(file);
+	file = vma->vm_file;
 out:
 	perf_event_mmap(vma);
 
@@ -1615,8 +1611,8 @@ out:
 	return addr;
 
 unmap_and_free_vma:
-	if (correct_wcount)
-		atomic_inc(&inode->i_writecount);
+	if (vm_flags & VM_DENYWRITE)
+		allow_write_access(file);
 	vma->vm_file = NULL;
 	fput(file);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

