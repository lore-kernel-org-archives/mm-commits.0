From: akpm@linux-foundation.org
Subject: + prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix.patch added to -mm tree
Date: Wed, 26 Sep 2012 13:06:06 -0700
Message-ID: <20120926200607.48DD5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:60544 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2IZUGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:06:08 -0400
Received: by ghbz15 with SMTP id z15so119649ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:06:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, fengguang.wu@intel.com


The patch titled
     Subject: prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix
has been added to the -mm tree.  Its filename is
     prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix

prctl: prctl_set_mm - Cast type of @addr

The sparse tool warns about type casting

 >   kernel/sys.c:1048:38: sparse: incorrect type in argument 2 (different modifiers)

Fix it with explicit type convention.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix kernel/sys.c
--- a/kernel/sys.c~prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix
+++ a/kernel/sys.c
@@ -1865,7 +1865,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (!access_ok(VERIFY_READ, addr, sizeof(addr)) || addr < mmap_min_addr)
+	if (!access_ok(VERIFY_READ, (void *)addr, sizeof(addr)) || addr < mmap_min_addr)
 		return -EINVAL;
 
 	error = -EINVAL;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch
prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix.patch
prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix-fix.patch
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

