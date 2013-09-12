From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:23 -0700
Message-ID: <5232191f.ynwJEYfQgJuCH2Hp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3ILTmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, ccross@android.com, oleg@redhat.com

Subject: [merged] mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch removed from -mm tree
To: oleg@redhat.com,ccross@android.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:23 -0700


The patch titled
     Subject: mm: mmap_region: kill correct_wcount/inode, use allow_write_access()
has been removed from the -mm tree.  Its filename was
     mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1479,11 +1479,9 @@ unsigned long mmap_region(struct file *f
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
@@ -1552,7 +1550,6 @@ munmap_back:
 			error = deny_write_access(file);
 			if (error)
 				goto free_vma;
-			correct_wcount = 1;
 		}
 		vma->vm_file = get_file(file);
 		error = file->f_op->mmap(file, vma);
@@ -1593,11 +1590,10 @@ munmap_back:
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
 
@@ -1616,8 +1612,8 @@ out:
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

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

