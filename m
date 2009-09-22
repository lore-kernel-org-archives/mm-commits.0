From: akpm@linux-foundation.org
Subject: [merged] kcore-proc-kcore-should-use-vread.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:50 -0700
Message-ID: <200909222040.n8MKeoYk006335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZIVUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: /proc/kcore should use vread
has been removed from the -mm tree.  Its filename was
     kcore-proc-kcore-should-use-vread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: /proc/kcore should use vread
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/kcore has its own routine to access vmallc area.  It can be replaced
with vread().  And by this, /proc/kcore can do safe access to vmalloc
area.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff -puN fs/proc/kcore.c~kcore-proc-kcore-should-use-vread fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-proc-kcore-should-use-vread
+++ a/fs/proc/kcore.c
@@ -328,43 +328,12 @@ read_kcore(struct file *file, char __use
 				return -EFAULT;
 		} else if (is_vmalloc_addr((void *)start)) {
 			char * elf_buf;
-			struct vm_struct *m;
-			unsigned long curstart = start;
-			unsigned long cursize = tsz;
 
 			elf_buf = kzalloc(tsz, GFP_KERNEL);
 			if (!elf_buf)
 				return -ENOMEM;
-
-			read_lock(&vmlist_lock);
-			for (m=vmlist; m && cursize; m=m->next) {
-				unsigned long vmstart;
-				unsigned long vmsize;
-				unsigned long msize = m->size - PAGE_SIZE;
-
-				if (((unsigned long)m->addr + msize) < 
-								curstart)
-					continue;
-				if ((unsigned long)m->addr > (curstart + 
-								cursize))
-					break;
-				vmstart = (curstart < (unsigned long)m->addr ? 
-					(unsigned long)m->addr : curstart);
-				if (((unsigned long)m->addr + msize) > 
-							(curstart + cursize))
-					vmsize = curstart + cursize - vmstart;
-				else
-					vmsize = (unsigned long)m->addr + 
-							msize - vmstart;
-				curstart = vmstart + vmsize;
-				cursize -= vmsize;
-				/* don't dump ioremap'd stuff! (TA) */
-				if (m->flags & VM_IOREMAP)
-					continue;
-				memcpy(elf_buf + (vmstart - start),
-					(char *)vmstart, vmsize);
-			}
-			read_unlock(&vmlist_lock);
+			vread(elf_buf, (char *)start, tsz);
+			/* we have to zero-fill user buffer even if no read */
 			if (copy_to_user(buffer, elf_buf, tsz)) {
 				kfree(elf_buf);
 				return -EFAULT;
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

