From: akpm@linux-foundation.org
Subject: + syscalls-make-kcmp-syscall-available-for-all-architectures.patch added to -mm tree
Date: Thu, 13 Sep 2012 15:00:13 -0700
Message-ID: <20120913220014.0E0B45C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63183 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab2IMWAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 18:00:17 -0400
Received: by lbbge1 with SMTP id ge1so220136lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 15:00:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, gorcunov@openvz.org, hpa@linux.intel.com, mmarek@suse.cz


The patch titled
     Subject: syscalls: make kcmp syscall available for all architectures
has been added to the -mm tree.  Its filename is
     syscalls-make-kcmp-syscall-available-for-all-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: syscalls: make kcmp syscall available for all architectures

Remove the x86 dependency, since the system call is not architecture
dependent.

Also add a ptrace.h include, so it compiles at least also on s390.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
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

linux-next.patch
checksyscalls-fix-here-document-handling.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390-fix.patch
syscalls-make-kcmp-syscall-available-for-all-architectures.patch

