From: akpm@linux-foundation.org
Subject: + procfs-task-exe-symlink-fix-3.patch added to -mm tree
Date: Mon, 17 Mar 2008 20:53:23 -0700
Message-ID: <200803180353.m2I3rN5F012862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbYCRDxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 23:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yamamoto@valinux.co.jp, matthltc@us.ibm.com


The patch titled
     a fix for procfs-task-exe-symlink.patch
has been added to the -mm tree.  Its filename is
     procfs-task-exe-symlink-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -523,11 +523,12 @@ static struct mm_struct *dup_mm(struct t
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
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
procfs-task-exe-symlink-fix-3.patch

