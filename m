From: akpm@linux-foundation.org
Subject: + revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch
 added to -mm tree
Date: Wed, 02 Jul 2014 12:25:14 -0700
Message-ID: <53b45c9a.uCwnZ5HhKp3LMECT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:47993 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaGBTZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 15:25:16 -0400
Received: by mail-ve0-f201.google.com with SMTP id jz11so1329836veb.2
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 12:25:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: revert "shmem: fix faulting into a hole while it's punched"
has been added to the -mm tree.  Its filename is
     revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch

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
Subject: shmem: revert "shmem: fix faulting into a hole while it's punched"

This reverts f00cdc6df7d7.

(a) It was buggy: Sasha sent a lockdep report to remind us that
    grabbing i_mutex in the fault path is a no-no (write syscall may
    already hold i_mutex while faulting user buffer), no matter that the
    patch took care to drop mmap_sem first.

(b) It may be thought too elaborate: see the diffstat.

(c) Vlastimil proposed a preferred approach, better for backporting to
    v3.1..v3.4, which had madvise hole-punch support before the fallocate
    infrastructure used in that commit - backporting being required once
    the issue fixed was tagged with CVE-2014-4171.

(d) Hugh noticed a further pessimization fix needed in the same area.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   56 +++------------------------------------------------
 1 file changed, 4 insertions(+), 52 deletions(-)

diff -puN mm/shmem.c~revert-shmem-fix-faulting-into-a-hole-while-its-punched mm/shmem.c
--- a/mm/shmem.c~revert-shmem-fix-faulting-into-a-hole-while-its-punched
+++ a/mm/shmem.c
@@ -80,12 +80,11 @@ static struct vfsmount *shm_mnt;
 #define SHORT_SYMLINK_LEN 128
 
 /*
- * shmem_fallocate communicates with shmem_fault or shmem_writepage via
- * inode->i_private (with i_mutex making sure that it has only one user at
- * a time): we would prefer not to enlarge the shmem inode just for that.
+ * shmem_fallocate and shmem_writepage communicate via inode->i_private
+ * (with i_mutex making sure that it has only one user at a time):
+ * we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
-	int	mode;		/* FALLOC_FL mode currently operating */
 	pgoff_t start;		/* start of range currently being fallocated */
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
@@ -760,7 +759,6 @@ static int shmem_writepage(struct page *
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
 			if (shmem_falloc &&
-			    !shmem_falloc->mode &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
 				shmem_falloc->nr_unswapped++;
@@ -1244,44 +1242,6 @@ static int shmem_fault(struct vm_area_st
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
-	/*
-	 * Trinity finds that probing a hole which tmpfs is punching can
-	 * prevent the hole-punch from ever completing: which in turn
-	 * locks writers out with its hold on i_mutex.  So refrain from
-	 * faulting pages into the hole while it's being punched, and
-	 * wait on i_mutex to be released if vmf->flags permits.
-	 */
-	if (unlikely(inode->i_private)) {
-		struct shmem_falloc *shmem_falloc;
-
-		spin_lock(&inode->i_lock);
-		shmem_falloc = inode->i_private;
-		if (!shmem_falloc ||
-		    shmem_falloc->mode != FALLOC_FL_PUNCH_HOLE ||
-		    vmf->pgoff < shmem_falloc->start ||
-		    vmf->pgoff >= shmem_falloc->next)
-			shmem_falloc = NULL;
-		spin_unlock(&inode->i_lock);
-		/*
-		 * i_lock has protected us from taking shmem_falloc seriously
-		 * once return from shmem_fallocate() went back up that stack.
-		 * i_lock does not serialize with i_mutex at all, but it does
-		 * not matter if sometimes we wait unnecessarily, or sometimes
-		 * miss out on waiting: we just need to make those cases rare.
-		 */
-		if (shmem_falloc) {
-			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
-			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
-				up_read(&vma->vm_mm->mmap_sem);
-				mutex_lock(&inode->i_mutex);
-				mutex_unlock(&inode->i_mutex);
-				return VM_FAULT_RETRY;
-			}
-			/* cond_resched? Leave that to GUP or return to user */
-			return VM_FAULT_NOPAGE;
-		}
-	}
-
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
@@ -1774,26 +1734,18 @@ static long shmem_fallocate(struct file
 
 	mutex_lock(&inode->i_mutex);
 
-	shmem_falloc.mode = mode & ~FALLOC_FL_KEEP_SIZE;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
 
-		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
-		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
-		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
-		spin_unlock(&inode->i_lock);
-
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 		error = 0;
-		goto undone;
+		goto out;
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
_

Patches currently in -mm which might be from hughd@google.com are

shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch
revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch
shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

