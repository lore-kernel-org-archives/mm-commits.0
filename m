From: akpm@linux-foundation.org
Subject: - mm-remove-lru_add_drain_all-from-the-munlock-path.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:53 -0800
Message-ID: <200811132126.mADLQr5n027541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbYKMVgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:36:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, heiko.carstens@de.ibm.com, hugh@veritas.com, kamalesh@linux.vnet.ibm.com, nickpiggin@yahoo.com.au, pe


The patch titled
     mm: remove lru_add_drain_all() from the munlock path
has been removed from the -mm tree.  Its filename was
     mm-remove-lru_add_drain_all-from-the-munlock-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove lru_add_drain_all() from the munlock path
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

lockdep warns about following message at boot time on one of my test machine.
Then, schedule_on_each_cpu() sholdn't be called when the task have mmap_sem.

Actually, lru_add_drain_all() exist to prevent the unevictalble pages stay on reclaimable lru list.
but currenct unevictable code can rescue unevictable pages although it stay on reclaimable list.

So removing is better.

In addition, this patch add lru_add_drain_all() to sys_mlock() and
sys_mlockall().  it isn't must.  but it reduce the failure of moving to
unevictable list.  its failure can rescue in vmscan later.  but reducing
is better.

Note, if above rescuing happend, the Mlocked and the Unevictable field
mismatching happend in /proc/meminfo.  but it doesn't cause any real
trouble.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.28-rc2-mm1 #2
-------------------------------------------------------
lvm/1103 is trying to acquire lock:
 (&cpu_hotplug.lock){--..}, at: [<c0130789>] get_online_cpus+0x29/0x50

but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<c01878ae>] sys_mlockall+0x4e/0xb0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_sem){----}:
       [<c0153da2>] check_noncircular+0x82/0x110
       [<c0185e6a>] might_fault+0x4a/0xa0
       [<c0156161>] validate_chain+0xb11/0x1070
       [<c0185e6a>] might_fault+0x4a/0xa0
       [<c0156923>] __lock_acquire+0x263/0xa10
       [<c015714c>] lock_acquire+0x7c/0xb0			(*) grab mmap_sem
       [<c0185e6a>] might_fault+0x4a/0xa0
       [<c0185e9b>] might_fault+0x7b/0xa0
       [<c0185e6a>] might_fault+0x4a/0xa0
       [<c0294dd0>] copy_to_user+0x30/0x60
       [<c01ae3ec>] filldir+0x7c/0xd0
       [<c01e3a6a>] sysfs_readdir+0x11a/0x1f0			(*) grab sysfs_mutex
       [<c01ae370>] filldir+0x0/0xd0
       [<c01ae370>] filldir+0x0/0xd0
       [<c01ae4c6>] vfs_readdir+0x86/0xa0			(*) grab i_mutex
       [<c01ae75b>] sys_getdents+0x6b/0xc0
       [<c010355a>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #2 (sysfs_mutex){--..}:
       [<c0153da2>] check_noncircular+0x82/0x110
       [<c01e3d2c>] sysfs_addrm_start+0x2c/0xc0
       [<c0156161>] validate_chain+0xb11/0x1070
       [<c01e3d2c>] sysfs_addrm_start+0x2c/0xc0
       [<c0156923>] __lock_acquire+0x263/0xa10
       [<c015714c>] lock_acquire+0x7c/0xb0			(*) grab sysfs_mutex
       [<c01e3d2c>] sysfs_addrm_start+0x2c/0xc0
       [<c04f8b55>] mutex_lock_nested+0xa5/0x2f0
       [<c01e3d2c>] sysfs_addrm_start+0x2c/0xc0
       [<c01e3d2c>] sysfs_addrm_start+0x2c/0xc0
       [<c01e3d2c>] sysfs_addrm_start+0x2c/0xc0
       [<c01e422f>] create_dir+0x3f/0x90
       [<c01e42a9>] sysfs_create_dir+0x29/0x50
       [<c04faaf5>] _spin_unlock+0x25/0x40
       [<c028f21d>] kobject_add_internal+0xcd/0x1a0
       [<c028f37a>] kobject_set_name_vargs+0x3a/0x50
       [<c028f41d>] kobject_init_and_add+0x2d/0x40
       [<c019d4d2>] sysfs_slab_add+0xd2/0x180
       [<c019d580>] sysfs_add_func+0x0/0x70
       [<c019d5dc>] sysfs_add_func+0x5c/0x70			(*) grab slub_lock
       [<c01400f2>] run_workqueue+0x172/0x200
       [<c014008f>] run_workqueue+0x10f/0x200
       [<c0140bd0>] worker_thread+0x0/0xf0
       [<c0140c6c>] worker_thread+0x9c/0xf0
       [<c0143c80>] autoremove_wake_function+0x0/0x50
       [<c0140bd0>] worker_thread+0x0/0xf0
       [<c0143972>] kthread+0x42/0x70
       [<c0143930>] kthread+0x0/0x70
       [<c01042db>] kernel_thread_helper+0x7/0x1c
       [<ffffffff>] 0xffffffff

-> #1 (slub_lock){----}:
       [<c0153d2d>] check_noncircular+0xd/0x110
       [<c04f650f>] slab_cpuup_callback+0x11f/0x1d0
       [<c0156161>] validate_chain+0xb11/0x1070
       [<c04f650f>] slab_cpuup_callback+0x11f/0x1d0
       [<c015433d>] mark_lock+0x35d/0xd00
       [<c0156923>] __lock_acquire+0x263/0xa10
       [<c015714c>] lock_acquire+0x7c/0xb0
       [<c04f650f>] slab_cpuup_callback+0x11f/0x1d0
       [<c04f93a3>] down_read+0x43/0x80
       [<c04f650f>] slab_cpuup_callback+0x11f/0x1d0		(*) grab slub_lock
       [<c04f650f>] slab_cpuup_callback+0x11f/0x1d0
       [<c04fd9ac>] notifier_call_chain+0x3c/0x70
       [<c04f5454>] _cpu_up+0x84/0x110
       [<c04f552b>] cpu_up+0x4b/0x70				(*) grab cpu_hotplug.lock
       [<c06d1530>] kernel_init+0x0/0x170
       [<c06d15e5>] kernel_init+0xb5/0x170
       [<c06d1530>] kernel_init+0x0/0x170
       [<c01042db>] kernel_thread_helper+0x7/0x1c
       [<ffffffff>] 0xffffffff

-> #0 (&cpu_hotplug.lock){--..}:
       [<c0155bff>] validate_chain+0x5af/0x1070
       [<c040f7e0>] dev_status+0x0/0x50
       [<c0156923>] __lock_acquire+0x263/0xa10
       [<c015714c>] lock_acquire+0x7c/0xb0
       [<c0130789>] get_online_cpus+0x29/0x50
       [<c04f8b55>] mutex_lock_nested+0xa5/0x2f0
       [<c0130789>] get_online_cpus+0x29/0x50
       [<c0130789>] get_online_cpus+0x29/0x50
       [<c017bc30>] lru_add_drain_per_cpu+0x0/0x10
       [<c0130789>] get_online_cpus+0x29/0x50			(*) grab cpu_hotplug.lock
       [<c0140cf2>] schedule_on_each_cpu+0x32/0xe0
       [<c0187095>] __mlock_vma_pages_range+0x85/0x2c0
       [<c0156945>] __lock_acquire+0x285/0xa10
       [<c0188f09>] vma_merge+0xa9/0x1d0
       [<c0187450>] mlock_fixup+0x180/0x200
       [<c0187548>] do_mlockall+0x78/0x90			(*) grab mmap_sem
       [<c01878e1>] sys_mlockall+0x81/0xb0
       [<c010355a>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by lvm/1103:
 #0:  (&mm->mmap_sem){----}, at: [<c01878ae>] sys_mlockall+0x4e/0xb0

stack backtrace:
Pid: 1103, comm: lvm Not tainted 2.6.28-rc2-mm1 #2
Call Trace:
 [<c01555fc>] print_circular_bug_tail+0x7c/0xd0
 [<c0155bff>] validate_chain+0x5af/0x1070
 [<c040f7e0>] dev_status+0x0/0x50
 [<c0156923>] __lock_acquire+0x263/0xa10
 [<c015714c>] lock_acquire+0x7c/0xb0
 [<c0130789>] get_online_cpus+0x29/0x50
 [<c04f8b55>] mutex_lock_nested+0xa5/0x2f0
 [<c0130789>] get_online_cpus+0x29/0x50
 [<c0130789>] get_online_cpus+0x29/0x50
 [<c017bc30>] lru_add_drain_per_cpu+0x0/0x10
 [<c0130789>] get_online_cpus+0x29/0x50
 [<c0140cf2>] schedule_on_each_cpu+0x32/0xe0
 [<c0187095>] __mlock_vma_pages_range+0x85/0x2c0
 [<c0156945>] __lock_acquire+0x285/0xa10
 [<c0188f09>] vma_merge+0xa9/0x1d0
 [<c0187450>] mlock_fixup+0x180/0x200
 [<c0187548>] do_mlockall+0x78/0x90
 [<c01878e1>] sys_mlockall+0x81/0xb0
 [<c010355a>] syscall_call+0x7/0xb

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN mm/mlock.c~mm-remove-lru_add_drain_all-from-the-munlock-path mm/mlock.c
--- a/mm/mlock.c~mm-remove-lru_add_drain_all-from-the-munlock-path
+++ a/mm/mlock.c
@@ -66,14 +66,10 @@ void __clear_page_mlock(struct page *pag
 		putback_lru_page(page);
 	} else {
 		/*
-		 * Page not on the LRU yet.  Flush all pagevecs and retry.
+		 * We lost the race. the page already moved to evictable list.
 		 */
-		lru_add_drain_all();
-		if (!isolate_lru_page(page))
-			putback_lru_page(page);
-		else if (PageUnevictable(page))
+		if (PageUnevictable(page))
 			count_vm_event(UNEVICTABLE_PGSTRANDED);
-
 	}
 }
 
@@ -187,8 +183,6 @@ static long __mlock_vma_pages_range(stru
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= GUP_FLAGS_WRITE;
 
-	lru_add_drain_all();	/* push cached pages to LRU */
-
 	while (nr_pages > 0) {
 		int i;
 
@@ -251,8 +245,6 @@ static long __mlock_vma_pages_range(stru
 		ret = 0;
 	}
 
-	lru_add_drain_all();	/* to update stats */
-
 	return ret;	/* count entire vma as locked_vm */
 }
 
@@ -546,6 +538,8 @@ asmlinkage long sys_mlock(unsigned long 
 	if (!can_do_mlock())
 		return -EPERM;
 
+	lru_add_drain_all();	/* flush pagevec */
+
 	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
@@ -612,6 +606,8 @@ asmlinkage long sys_mlockall(int flags)
 	if (!can_do_mlock())
 		goto out;
 
+	lru_add_drain_all();	/* flush pagevec */
+
 	down_write(&current->mm->mmap_sem);
 
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

