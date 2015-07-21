From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-3.patch
 removed from -mm tree
Date: Tue, 21 Jul 2015 13:44:17 -0700
Message-ID: <55aeaf21.DGAlPErXBPHKgd/w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbbGUUoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 16:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: fix for add new mlock, munlock, and munlockall system calls
has been removed from the -mm tree.  Its filename was
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-3.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: mlock: fix for add new mlock, munlock, and munlockall system calls

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/unistd.h |    2 +-
 arch/arm/kernel/calls.S       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-3 arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-3
+++ a/arch/arm/include/asm/unistd.h
@@ -19,7 +19,7 @@
  * This may need to be greater than __NR_last_syscall+1 in order to
  * account for the padding in the syscall table
  */
-#define __NR_syscalls  (388)
+#define __NR_syscalls  (392)
 
 /*
  * *NOTE*: This is a ghost syscall private to the kernel.  Only the
diff -puN arch/arm/kernel/calls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-3 arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-3
+++ a/arch/arm/kernel/calls.S
@@ -399,7 +399,7 @@
 		CALL(sys_execveat)
 		CALL(sys_mlock2)
 		CALL(sys_munlock2)
-/* 400 */	CALL(sys_munlockall2)
+/* 390 */	CALL(sys_munlockall2)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-activate-syscall-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

