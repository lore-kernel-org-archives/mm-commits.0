From: akpm@linux-foundation.org
Subject: - cpusets-update_cpumask-revision-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:29:28 -0800
Message-ID: <200802070329.m173T9kH013881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759237AbYBGD3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets-update_cpumask-revision-fix
has been removed from the -mm tree.  Its filename was
     cpusets-update_cpumask-revision-fix.patch

This patch was dropped because it was folded into cpusets-update_cpumask-revision.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets-update_cpumask-revision-fix
From: Andrew Morton <akpm@linux-foundation.org>

On Wed, 9 Jan 2008 22:49:51 -0800 "Paul Menage" <menage@google.com> wrote:

> On Jan 3, 2008 6:08 AM, Cliff Wickman <cpw@sgi.com> wrote:
> > -                * but it avoids having to take callback_mutex in the
> > -                * fork path
> > -                */
> > -               goto again;
> > -       }
> > -       heap_free(&heap);
> > +       scan.cg = cs->css.cgroup;
> > +       scan.test_task = cpuset_test_cpumask;
> > +       scan.process_task = cpuset_change_cpumask;
> > +       scan.heap = &heap;
> > +       cgroup_scan_tasks(&scan);
> > +
> 
> I just noticed that we should leave the heap_free() call in, after the
> call to cgroup_scan_tasks().

Cc: Cliff Wickman <cpw@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/cpuset.c~cpusets-update_cpumask-revision-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-update_cpumask-revision-fix
+++ a/kernel/cpuset.c
@@ -831,6 +831,7 @@ static int update_cpumask(struct cpuset 
 	scan.process_task = cpuset_change_cpumask;
 	scan.heap = &heap;
 	cgroup_scan_tasks(&scan);
+	heap_free(&heap);
 
 	if (is_load_balanced)
 		rebuild_sched_domains();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
cgroup-simplify-space-stripping.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
