From: akpm@linux-foundation.org
Subject: [to-be-updated] syscalls-make-kcmp-syscall-available-for-all-architectures.patch removed from -mm tree
Date: Mon, 24 Sep 2012 13:47:06 -0700
Message-ID: <20120924204707.6C830100047__39082.3102243759$1348519640$gmane$org@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62433 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2IXUrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 16:47:11 -0400
Received: by vbis24 with SMTP id s24so811106vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 13:47:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, gorcunov@openvz.org, hpa@linux.intel.com, linux-arch@vger.kernel.org, mmarek@suse.cz, ralf@linux-mips.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls: make kcmp syscall available for all architectures
has been removed from the -mm tree.  Its filename was
     syscalls-make-kcmp-syscall-available-for-all-architectures.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: syscalls: make kcmp syscall available for all architectures

Remove the x86 dependency, since the system call is not architecture
dependent.

Also add a ptrace.h include, so it compiles at least also on s390.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    4 +---
 kernel/kcmp.c   |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/Makefile~syscalls-make-kcmp-syscall-available-for-all-architectures kernel/Makefile
--- a/kernel/Makefile~syscalls-make-kcmp-syscall-available-for-all-architectures
+++ a/kernel/Makefile
@@ -25,9 +25,7 @@ endif
 obj-y += sched/
 obj-y += power/
 
-ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
-obj-$(CONFIG_X86) += kcmp.o
-endif
+obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff -puN kernel/kcmp.c~syscalls-make-kcmp-syscall-available-for-all-architectures kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-make-kcmp-syscall-available-for-all-architectures
+++ a/kernel/kcmp.c
@@ -4,6 +4,7 @@
 #include <linux/string.h>
 #include <linux/random.h>
 #include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/cache.h>
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

checksyscalls-fix-here-document-handling.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390-fix.patch

