From: akpm@linux-foundation.org
Subject: + prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:31:37 -0700
Message-ID: <20120925193137.AE9581E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59399 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2IYTbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:31:38 -0400
Received: by yhl10 with SMTP id 10so5264yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:31:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, ebiederm@xmission.com, keescook@chromium.org, msalter@redhat.com, xemul@parallels.com


The patch titled
     Subject: prctl: use access_ok() instead of TASK_SIZE in prctl_set_mm()
has been added to the -mm tree.  Its filename is
     prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch

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
Subject: prctl: use access_ok() instead of TASK_SIZE in prctl_set_mm()

Eric pointed that better to use access_ok instead of TASK_SIZE for testing
if address is allowed for use.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm kernel/sys.c
--- a/kernel/sys.c~prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm
+++ a/kernel/sys.c
@@ -1865,7 +1865,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (addr >= TASK_SIZE || addr < mmap_min_addr)
+	if (!access_ok(VERIFY_READ, addr, sizeof(addr)) || addr < mmap_min_addr)
 		return -EINVAL;
 
 	error = -EINVAL;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

checksyscalls-fix-here-document-handling.patch
c-r-prctl-fix-build-error-for-no-mmu-case.patch
linux-next.patch
prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch
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

