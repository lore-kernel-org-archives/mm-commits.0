From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-double-mmap_sem-unlock-on-mmf_unstable-enforced-sigbus.patch removed
 from -mm tree
Date: Mon, 21 Aug 2017 11:30:13 -0700
Message-ID: <20170821183013.T8LWdWllv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbdHUSaO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 14:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@kernel.org, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, stable@vger.kernel.org, wenwei.tww@alibaba-inc.com


The patch titled
     Subject: mm: fix double mmap_sem unlock on MMF_UNSTABLE enforced SIGBUS
has been removed from the -mm tree.  Its filename was
     mm-fix-double-mmap_sem-unlock-on-mmf_unstable-enforced-sigbus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: fix double mmap_sem unlock on MMF_UNSTABLE enforced SIGBUS

Tetsuo Handa has noticed that MMF_UNSTABLE SIGBUS path in
handle_mm_fault causes a lockdep splat
[   58.539455] Out of memory: Kill process 1056 (a.out) score 603 or sacrifice child
[   58.543943] Killed process 1056 (a.out) total-vm:4268108kB, anon-rss:2246048kB, file-rss:0kB, shmem-rss:0kB
[   58.544245] a.out (1169) used greatest stack depth: 11664 bytes left
[   58.557471] DEBUG_LOCKS_WARN_ON(depth <= 0)
[   58.557480] ------------[ cut here ]------------
[   58.564407] WARNING: CPU: 6 PID: 1339 at kernel/locking/lockdep.c:3617 lock_release+0x172/0x1e0
[   58.599401] CPU: 6 PID: 1339 Comm: a.out Not tainted 4.13.0-rc3-next-20170803+ #142
[   58.604126] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   58.609790] task: ffff9d90df888040 task.stack: ffffa07084854000
[   58.613944] RIP: 0010:lock_release+0x172/0x1e0
[   58.617622] RSP: 0000:ffffa07084857e58 EFLAGS: 00010082
[   58.621533] RAX: 000000000000001f RBX: ffff9d90df888040 RCX: 0000000000000000
[   58.626074] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa30d4ba4
[   58.630572] RBP: ffffa07084857e98 R08: 0000000000000000 R09: 0000000000000001
[   58.635016] R10: 0000000000000000 R11: 000000000000001f R12: ffffa07084857f58
[   58.639694] R13: ffff9d90f60d6cd0 R14: 0000000000000000 R15: ffffffffa305cb6e
[   58.644200] FS:  00007fb932730740(0000) GS:ffff9d90f9f80000(0000) knlGS:0000000000000000
[   58.648989] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   58.652903] CR2: 000000000040092f CR3: 0000000135229000 CR4: 00000000000606e0
[   58.657280] Call Trace:
[   58.659989]  up_read+0x1a/0x40
[   58.662825]  __do_page_fault+0x28e/0x4c0
[   58.665946]  do_page_fault+0x30/0x80
[   58.668911]  page_fault+0x28/0x30

The reason is that the page fault path might have dropped the mmap_sem and
returned with VM_FAULT_RETRY.  MMF_UNSTABLE check however rewrites the
error path to VM_FAULT_SIGBUS and we always expect mmap_sem taken in that
path.  Fix this by taking mmap_sem when VM_FAULT_RETRY is held in the
MMF_UNSTABLE path.  We cannot simply add VM_FAULT_SIGBUS to the existing
error code because all arch specific page fault handlers and g-u-p would
have to learn a new error code combination.

Link: http://lkml.kernel.org/r/20170807113839.16695-2-mhocko@kernel.org
Fixes: 3f70dc38cec2 ("mm: make sure that kthreads will not refault oom reaped memory")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Wenwei Tao <wenwei.tww@alibaba-inc.com>
Cc: <stable@vger.kernel.org>	[4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-fix-double-mmap_sem-unlock-on-mmf_unstable-enforced-sigbus mm/memory.c
--- a/mm/memory.c~mm-fix-double-mmap_sem-unlock-on-mmf_unstable-enforced-sigbus
+++ a/mm/memory.c
@@ -3910,8 +3910,18 @@ int handle_mm_fault(struct vm_area_struc
 	 * further.
 	 */
 	if (unlikely((current->flags & PF_KTHREAD) && !(ret & VM_FAULT_ERROR)
-				&& test_bit(MMF_UNSTABLE, &vma->vm_mm->flags)))
+				&& test_bit(MMF_UNSTABLE, &vma->vm_mm->flags))) {
+
+		/*
+		 * We are going to enforce SIGBUS but the PF path might have
+		 * dropped the mmap_sem already so take it again so that
+		 * we do not break expectations of all arch specific PF paths
+		 * and g-u-p
+		 */
+		if (ret & VM_FAULT_RETRY)
+			down_read(&vma->vm_mm->mmap_sem);
 		ret = VM_FAULT_SIGBUS;
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
mm-oom-do-not-rely-on-tif_memdie-for-memory-reserves-access.patch
mm-replace-tif_memdie-checks-by-tsk_is_oom_victim.patch
mm-memory_hotplug-introduce-add_pages.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

