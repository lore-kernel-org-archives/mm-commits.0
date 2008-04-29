From: akpm@linux-foundation.org
Subject: - procfs-task-exe-symlink-fix-3.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:56:03 -0700
Message-ID: <200804290556.m3T5u30c004092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbYD2F4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamamoto@valinux.co.jp, matthltc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     a fix for procfs-task-exe-symlink.patch
has been removed from the -mm tree.  Its filename was
     procfs-task-exe-symlink-fix-3.patch

This patch was dropped because it was folded into procfs-task-exe-symlink.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: a fix for procfs-task-exe-symlink.patch
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)

It seems that procfs-task-exe-symlink.patch broke the case of dup_mmap
failure.  ie.  mm->exe_file is copied by memcpy from oldmm and then be fput'ed
by mmput/set_mm_exe_file.

Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~procfs-task-exe-symlink-fix-3 kernel/fork.c
--- a/kernel/fork.c~procfs-task-exe-symlink-fix-3
+++ a/kernel/fork.c
@@ -521,11 +521,12 @@ static struct mm_struct *dup_mm(struct t
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
+	dup_mm_exe_file(oldmm, mm);
+
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
 
-	dup_mm_exe_file(oldmm, mm);
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
 
_

Patches currently in -mm which might be from yamamoto@valinux.co.jp are

cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix-3.patch

