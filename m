From: akpm@linux-foundation.org
Subject: +
 samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips.patch added to -mm tree
Date: Wed, 12 Mar 2014 12:59:37 -0700
Message-ID: <5320bca9.H+DDlYYrD3zm6tKJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaCLT7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 15:59:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, paul.gortmaker@windriver.com, markos.chandras@imgtec.com

Subject: + samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips.patch added to -mm tree
To: markos.chandras@imgtec.com,paul.gortmaker@windriver.com,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 12:59:37 -0700


The patch titled
     Subject: samples/seccomp/Makefile: do not build tests if cross-compiling for MIPS
has been added to the -mm tree.  Its filename is
     samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markos Chandras <markos.chandras@imgtec.com>
Subject: samples/seccomp/Makefile: do not build tests if cross-compiling for MIPS

The Makefile is designed to use the host toolchain so it may be unsafe to
build the tests if the kernel has been configured and built for another
architecture.  This fixes a build problem when the kernel has been
configured and built for the MIPS architecture but the host is not MIPS
(cross-compiled).  The MIPS syscalls are only defined if one of the
following is true:

1) _MIPS_SIM == _MIPS_SIM_ABI64
2) _MIPS_SIM == _MIPS_SIM_ABI32
3) _MIPS_SIM == _MIPS_SIM_NABI32

Of course, none of these make sense on a non-MIPS toolchain and the
following build problem occurs when building on a non-MIPS host.

linux/usr/include/linux/kexec.h:50:
userspace cannot reference function or variable defined in the kernel
samples/seccomp/bpf-direct.c: In function `emulator':
samples/seccomp/bpf-direct.c:76:17: error:
`__NR_write' undeclared (first use in this function)

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/seccomp/Makefile |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN samples/seccomp/Makefile~samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips samples/seccomp/Makefile
--- a/samples/seccomp/Makefile~samples-seccomp-makefile-do-not-build-tests-if-cross-compiling-for-mips
+++ a/samples/seccomp/Makefile
@@ -18,8 +18,8 @@ HOSTCFLAGS_bpf-direct.o += -idirafter $(
 bpf-direct-objs := bpf-direct.o
 
 # Try to match the kernel target.
-ifndef CONFIG_64BIT
 ifndef CROSS_COMPILE
+ifndef CONFIG_64BIT
 
 # s390 has -m31 flag to build 31 bit binaries
 ifndef CONFIG_S390
@@ -36,7 +36,13 @@ HOSTLOADLIBES_bpf-direct += $(MFLAG)
 HOSTLOADLIBES_bpf-fancy += $(MFLAG)
 HOSTLOADLIBES_dropper += $(MFLAG)
 endif
-endif
