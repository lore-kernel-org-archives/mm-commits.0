From: akpm@linux-foundation.org
Subject: + mm-introduce-external-memory-hinting-api-fix.patch
 added to -mm tree
Date: Tue, 03 Mar 2020 16:19:10 -0800
Message-ID: <20200304001910.Tt4YNzHFp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgCDATL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 19:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fix process_madvise build break for arm64
has been added to the -mm tree.  Its filename is
     mm-introduce-external-memory-hinting-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-external-memory-hinting-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-external-memory-hinting-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: fix process_madvise build break for arm64

0-day reported build break from process_madvise on ARM64.

   aarch64-linux-ld: arch/arm64/kernel/head.o: relocation R_AARCH64_ABS32 against `_kernel_offset_le_lo32' can not be used when making a shared object
   aarch64-linux-ld: arch/arm64/kernel/efi-entry.stub.o: relocation R_AARCH64_ABS32 against `__efistub_stext_offset' can not be used when making a shared object
   arch/arm64/kernel/head.o: In function `kimage_vaddr':
   (.idmap.text+0x0): dangerous relocation: unsupported relocation
   arch/arm64/kernel/head.o: In function `__primary_switch':
   (.idmap.text+0x378): dangerous relocation: unsupported relocation
   (.idmap.text+0x380): dangerous relocation: unsupported relocation
>> arch/arm64/kernel/sys32.o:(.rodata+0xdb8): undefined reference to `__arm64_process_madvise'

This patch should fix it.

Link: http://lkml.kernel.org/r/20200303145756.GA219683@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/unistd32.h~mm-introduce-external-memory-hinting-api-fix
+++ a/arch/arm64/include/asm/unistd32.h
@@ -884,7 +884,7 @@ __SYSCALL(__NR_openat2, sys_openat2)
 #define __NR_pidfd_getfd 438
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_process_madvise 439
-__SYSCALL(__NR_process_madvise, process_madvise)
+__SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 /*
  * Please add new compat syscalls above this comment and update
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-introduce-external-memory-hinting-api-fix.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
