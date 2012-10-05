From: akpm@linux-foundation.org
Subject: [merged] coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:32 -0700
Message-ID: <20121005201932.9E77E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37882 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:33 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so236864vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: use SUID_DUMPABLE_ENABLED rather than hardcoded 1
has been removed from the -mm tree.  Its filename was
     coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: use SUID_DUMPABLE_ENABLED rather than hardcoded 1

Cosmetic. Change setup_new_exec() and task_dumpable() to use
SUID_DUMPABLE_ENABLED for /bin/grep.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 +-
 fs/proc/internal.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1 fs/exec.c
--- a/fs/exec.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1
+++ a/fs/exec.c
@@ -1097,7 +1097,7 @@ void setup_new_exec(struct linux_binprm 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, 1);
+		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
diff -puN fs/proc/internal.h~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1 fs/proc/internal.h
--- a/fs/proc/internal.h~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1
+++ a/fs/proc/internal.h
@@ -103,7 +103,7 @@ static inline int task_dumpable(struct t
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable == 1)
+	if (dumpable == SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

