From: akpm@linux-foundation.org
Subject: [merged] vmalloc-unmap-vmalloc-area-after-hiding-it.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:41 -0700
Message-ID: <200909222040.n8MKefMS006041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbZIVUlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmalloc: unmap vmalloc area after hiding it
has been removed from the -mm tree.  Its filename was
     vmalloc-unmap-vmalloc-area-after-hiding-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: unmap vmalloc area after hiding it
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

vmap area should be purged after vm_struct is removed from the list
because vread/vwrite etc...believes the range is valid while it's on
vm_struct list.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-unmap-vmalloc-area-after-hiding-it mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-unmap-vmalloc-area-after-hiding-it
+++ a/mm/vmalloc.c
@@ -1270,17 +1270,21 @@ struct vm_struct *remove_vm_area(const v
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->private;
 		struct vm_struct *tmp, **p;
-
-		vmap_debug_free_range(va->va_start, va->va_end);
-		free_unmap_vmap_area(va);
-		vm->size -= PAGE_SIZE;
-
+		/*
+		 * remove from list and disallow access to this vm_struct
+		 * before unmap. (address range confliction is maintained by
+		 * vmap.)
+		 */
 		write_lock(&vmlist_lock);
 		for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
 			;
 		*p = tmp->next;
 		write_unlock(&vmlist_lock);
 
+		vmap_debug_free_range(va->va_start, va->va_end);
+		free_unmap_vmap_area(va);
+		vm->size -= PAGE_SIZE;
+
 		return vm;
 	}
 	return NULL;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
walk-system-ram-range-fix-2.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
kcore-more-fixes-for-init.patch
proc-kcore-fix-statst_size.patch
proc-kcore-update-statst_size-after-memory-hotplug.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

