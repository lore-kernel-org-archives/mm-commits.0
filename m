From: akpm@linux-foundation.org
Subject: [merged] samples-seccomp-be-less-stupid-about-cross-compiling.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:36 -0800
Message-ID: <20130205202036.C49B631C1CE@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:46053 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3BEUUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:38 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so77380qah.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, heiko.carstens@de.ibm.com, james.l.morris@oracle.com, keescook@chromium.org, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/seccomp: be less stupid about cross compiling
has been removed from the -mm tree.  Its filename was
     samples-seccomp-be-less-stupid-about-cross-compiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: samples/seccomp: be less stupid about cross compiling

The seccomp filters are currently built for the build host, not for the
machine that they are going to run on, but they are also built for with
the -m32 flag if the kernel is built for a 32 bit machine, both of which
seems rather odd.

It broke allyesconfig on my machine, which is x86-64, but
building for 32 bit ARM, with this error message:

In file included from /usr/include/stdio.h:28:0,
                 from samples/seccomp/bpf-fancy.c:15:
/usr/include/features.h:324:26: fatal error: bits/predefs.h: No such file or directory

because there are no 32 bit libc headers installed on this machine.  We
should really be building all the samples for the target machine rather
than the build host, but since the infrastructure for that appears to be
missing right now, let's be a little bit smarter and not pass the '-m32'
flag to the HOSTCC when cross- compiling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Morris <james.l.morris@oracle.com>
Acked-by: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/seccomp/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff -puN samples/seccomp/Makefile~samples-seccomp-be-less-stupid-about-cross-compiling samples/seccomp/Makefile
--- a/samples/seccomp/Makefile~samples-seccomp-be-less-stupid-about-cross-compiling
+++ a/samples/seccomp/Makefile
@@ -19,6 +19,7 @@ bpf-direct-objs := bpf-direct.o
 
 # Try to match the kernel target.
 ifndef CONFIG_64BIT
+ifndef CROSS_COMPILE
 
 # s390 has -m31 flag to build 31 bit binaries
 ifndef CONFIG_S390
@@ -35,6 +36,7 @@ HOSTLOADLIBES_bpf-direct += $(MFLAG)
 HOSTLOADLIBES_bpf-fancy += $(MFLAG)
 HOSTLOADLIBES_dropper += $(MFLAG)
 endif
+endif
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch

