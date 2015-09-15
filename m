From: akpm@linux-foundation.org
Subject: + userfaultfd-register-uapi-generic-syscall-aarch64.patch added
 to -mm tree
Date: Tue, 15 Sep 2015 13:04:45 -0700
Message-ID: <55f879dd.958vE6mUfw1rx2rW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbIOUEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 16:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgilbert@redhat.com, aarcange@redhat.com, mathieu.desnoyers@efficios.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: register uapi generic syscall (aarch64)
has been added to the -mm tree.  Its filename is
     userfaultfd-register-uapi-generic-syscall-aarch64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-register-uapi-generic-syscall-aarch64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-register-uapi-generic-syscall-aarch64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd-register-uapi-generic-syscall-aarch64.patch

