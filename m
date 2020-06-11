From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-external-memory-hinting-api-fix.patch removed from -mm tree
Date: Wed, 10 Jun 2020 18:22:35 -0700
Message-ID: <20200611012235.0KrTWBiye%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fix process_madvise build break for arm64
has been removed from the -mm tree.  Its filename was
     mm-introduce-external-memory-hinting-api-fix.patch

This patch was dropped because it was folded into mm-introduce-external-memory-hinting-api.patch

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
@@ -886,7 +886,7 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_process_madvise 440
-__SYSCALL(__NR_process_madvise, process_madvise)
+__SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 /*
  * Please add new compat syscalls above this comment and update
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-introduce-external-memory-hinting-api-fix-2.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
mm-use-only-pidfd-for-process_madvise-syscall.patch
mm-use-only-pidfd-for-process_madvise-syscall-fix.patch
