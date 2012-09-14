From: akpm@linux-foundation.org
Subject: + coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch added to -mm tree
Date: Fri, 14 Sep 2012 12:31:32 -0700
Message-ID: <20120914193133.0DAE65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47976 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2INTbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 15:31:35 -0400
Received: by weyr1 with SMTP id r1so277851wey.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 12:31:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com


The patch titled
     Subject: coredump: use SUID_DUMPABLE_ENABLED rather than hardcoded 1
has been added to the -mm tree.  Its filename is
     coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: use SUID_DUMPABLE_ENABLED rather than hardcoded 1

Cosmetic. Change setup_new_exec() and task_dumpable() to use
SUID_DUMPABLE_ENABLED for /bin/grep.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c      |    2 +-
 fs/proc/base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1 fs/exec.c
--- a/fs/exec.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1
+++ a/fs/exec.c
@@ -1125,7 +1125,7 @@ void setup_new_exec(struct linux_binprm 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, 1);
+		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
diff -puN fs/proc/base.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1 fs/proc/base.c
--- a/fs/proc/base.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1
+++ a/fs/proc/base.c
@@ -1398,7 +1398,7 @@ static int task_dumpable(struct task_str
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable == 1)
+	if(dumpable == SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid.patch
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
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch

