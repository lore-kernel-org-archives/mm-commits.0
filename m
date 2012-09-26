From: akpm@linux-foundation.org
Subject: [nacked] prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch removed from -mm tree
Date: Wed, 26 Sep 2012 14:17:57 -0700
Message-ID: <20120926211757.9A83D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62369 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2IZVR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 17:17:58 -0400
Received: by yenr11 with SMTP id r11so130172yen.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 14:17:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, ebiederm@xmission.com, keescook@chromium.org, msalter@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: use access_ok() instead of TASK_SIZE in prctl_set_mm()
has been removed from the -mm tree.  Its filename was
     prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch

This patch was dropped because it was nacked

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

 kernel/sys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sys.c~prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm kernel/sys.c
--- a/kernel/sys.c~prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm
+++ a/kernel/sys.c
@@ -1865,7 +1865,8 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (addr >= TASK_SIZE || addr < mmap_min_addr)
+	if (!access_ok(VERIFY_READ, (void __user *)addr, sizeof(addr)) ||
+			addr < mmap_min_addr)
 		return -EINVAL;
 
 	error = -EINVAL;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

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

