From: akpm@linux-foundation.org
Subject: - iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:36:24 -0800
Message-ID: <200802070336.m173a56g014131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbYBGDgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:36:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-procfs-from-using-iget-and-read_inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#88: FILE: fs/proc/inode.c:427:
+							&proc_reg_file_ops_no_compat;

WARNING: line over 80 characters
#92: FILE: fs/proc/inode.c:430:
+						inode->i_fop = &proc_reg_file_ops;

ERROR: else should follow close brace '}'
#94: FILE: fs/proc/inode.c:432:
+				}
+				else

total: 1 errors, 2 warnings, 85 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/inode.c~iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes fs/proc/inode.c
--- a/fs/proc/inode.c~iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/fs/proc/inode.c
@@ -423,9 +423,9 @@ struct inode *proc_get_inode(struct supe
 					else
 #endif
 						inode->i_fop = &proc_reg_file_ops;
-				}
-				else
+				} else {
 					inode->i_fop = de->proc_fops;
+				}
 			}
 		}
 		unlock_new_inode(inode);
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
drivers-edac-add-marvell-mv64x60-driver.patch
introduce-flags-for-reserve_bootmem.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
