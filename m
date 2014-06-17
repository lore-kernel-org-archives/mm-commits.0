From: akpm@linux-foundation.org
Subject: + shmem-fix-faulting-into-a-hole-while-its-punched.patch added to -mm tree
Date: Tue, 17 Jun 2014 13:37:32 -0700
Message-ID: <53a0a70c.3Gp5lI+tZ+aP1wo6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964977AbaFQUhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 16:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, davej@redhat.com, hughd@google.com


The patch titled
     Subject: shmem: fix faulting into a hole while it's punched
has been added to the -mm tree.  Its filename is
     shmem-fix-faulting-into-a-hole-while-its-punched.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-faulting-into-a-hole-while-its-punched.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-faulting-into-a-hole-while-its-punched.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix faulting into a hole while it's punched

Trinity finds that mmap access to a hole while it's punched from shmem can
prevent the madvise(MADV_REMOVE) or fallocate(FALLOC_FL_PUNCH_HOLE) from
completing, until the reader chooses to stop; with the puncher's hold on
i_mutex locking out all other writers until it can complete.

It appears that the tmpfs fault path is too light in comparison with its
hole-punching path, lacking an i_data_sem to obstruct it; but we don't
want to slow down the common case.

Extend shmem_fallocate()'s existing range notification mechanism, so
shmem_fault() can refrain from faulting pages into the hole while it's
punched, waiting instead on i_mutex (when safe to sleep; or repeatedly
faulting when not).

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

diff -puN mm/shmem.c~shmem-fix-faulting-into-a-hole-while-its-punched mm/shmem.c
--- a/mm/shmem.c~shmem-fix-faulting-into-a-hole-while-its-punched
+++ a/mm/shmem.c
@@ -80,11 +80,12 @@ static struct vfsmount *shm_mnt;
 #define SHORT_SYMLINK_LEN 128
 
 /*
- * shmem_fallocate and shmem_writepage communicate via inode->i_private
- * (with i_mutex making sure that it has only one user at a time):
- * we would prefer not to enlarge the shmem inode just for that.
+ * shmem_fallocate communicates with shmem_fault or shmem_writepage via
+ * inode->i_private (with i_mutex making sure that it has only one user at
+ * a time): we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
+	int	mode;		/* FALLOC_FL mode currently operating */
 	pgoff_t start;		/* start of range currently being fallocated */
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
@@ -759,6 +760,7 @@ static int shmem_writepage(struct page *
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
 			if (shmem_falloc &&
+			    !shmem_falloc->mode &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
 				shmem_falloc->nr_unswapped++;
@@ -1233,6 +1235,43 @@ static int shmem_fault(struct vm_area_st
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
+	/*
+	 * Trinity finds that probing a hole which tmpfs is punching can
+	 * prevent the hole-punch from ever completing: which in turn
+	 * locks writers out with its hold on i_mutex.  So refrain from
+	 * faulting pages into the hole while it's being punched, and
+	 * wait on i_mutex to be released if vmf->flags permits, 
+	 */
+	if (unlikely(inode->i_private)) {
+		struct shmem_falloc *shmem_falloc;
+		spin_lock(&inode->i_lock);
+		shmem_falloc = inode->i_private;
+		if (!shmem_falloc ||
+		    shmem_falloc->mode != FALLOC_FL_PUNCH_HOLE ||
+		    vmf->pgoff < shmem_falloc->start ||
+		    vmf->pgoff >= shmem_falloc->next)
+			shmem_falloc = NULL;
+		spin_unlock(&inode->i_lock);
+		/*
+		 * i_lock has protected us from taking shmem_falloc seriously
+		 * once return from shmem_fallocate() went back up that stack.
+		 * i_lock does not serialize with i_mutex at all, but it does
+		 * not matter if sometimes we wait unnecessarily, or sometimes
+		 * miss out on waiting: we just need to make those cases rare.
+		 */
+		if (shmem_falloc) {
+			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
+			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
+				up_read(&vma->vm_mm->mmap_sem);
+				mutex_lock(&inode->i_mutex);
+				mutex_unlock(&inode->i_mutex);
+				return VM_FAULT_RETRY;
+			}
+			/* cond_resched? Leave that to GUP or return to user */
+			return VM_FAULT_NOPAGE;
+		}
+	}
+
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
@@ -1729,18 +1768,26 @@ static long shmem_fallocate(struct file
 
 	mutex_lock(&inode->i_mutex);
 
+	shmem_falloc.mode = mode & ~FALLOC_FL_KEEP_SIZE;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
 
+		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
+		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
+		spin_lock(&inode->i_lock);
+		inode->i_private = &shmem_falloc;
+		spin_unlock(&inode->i_lock);
+
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 		error = 0;
-		goto out;
+		goto undone;
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-zero_range-and-collapse_range-not-currently-supported.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch
shmem-fix-faulting-into-a-hole-while-its-punched.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

