From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-register-uapi-generic-syscall-aarch64.patch
 removed from -mm tree
Date: Mon, 28 Sep 2015 11:15:54 -0700
Message-ID: <560983da.UCq7Bsk2WOou3OFn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgilbert@redhat.com, aarcange@redhat.com, mathieu.desnoyers@efficios.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: register uapi generic syscall (aarch64)
has been removed from the -mm tree.  Its filename was
     userfaultfd-register-uapi-generic-syscall-aarch64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: userfaultfd: register uapi generic syscall (aarch64)

Add the userfaultfd syscalls to uapi asm-generic, it was tested with
postcopy live migration on aarch64 with both 4k and 64k pagesize kernels.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/unistd.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/uapi/asm-generic/unistd.h~userfaultfd-register-uapi-generic-syscall-aarch64 include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~userfaultfd-register-uapi-generic-syscall-aarch64
+++ a/include/uapi/asm-generic/unistd.h
@@ -709,17 +709,19 @@ __SYSCALL(__NR_memfd_create, sys_memfd_c
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
-#define __NR_membarrier 282
+#define __NR_userfaultfd 282
+__SYSCALL(__NR_userfaultfd, sys_userfaultfd)
+#define __NR_membarrier 283
 __SYSCALL(__NR_membarrier, sys_membarrier)
 
 #undef __NR_syscalls
-#define __NR_syscalls 283
+#define __NR_syscalls 284
 
 /*
  * All syscalls below here should go away really,
  * these are provided for both review and as a porting
  * help for the C library version.
-*
+ *
  * Last chance: are any of these important enough to
  * enable by default?
  */
_

Patches currently in -mm which might be from dgilbert@redhat.com are


