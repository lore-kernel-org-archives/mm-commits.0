From: akpm@linux-foundation.org
Subject: + userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers.patch added to -mm tree
Date: Tue, 15 Sep 2015 13:04:33 -0700
Message-ID: <55f879d1.AyCdRCU5jacaXtla%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIOUEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 16:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftests: vm: pick up sanitized kernel headers
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: userfaultfd: selftests: vm: pick up sanitized kernel headers

Add the usr/include subdirectory of the top-level tree to the include
path, and make sure to include headers without relative paths to make sure
the sanitized headers get picked up.  Otherwise the compiler will not be
able to find the linux/compiler.h header included by the non- sanitized
include/uapi/linux/userfaultfd.h.

While at it, make sure to only hardcode the syscall numbers on x86 and
PowerPC if they haven't been properly picked up from the headers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile      |    2 +-
 tools/testing/selftests/vm/userfaultfd.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,6 @@
 # Makefile for vm selftests
 
-CFLAGS = -Wall
+CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -64,8 +64,9 @@
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <pthread.h>
-#include "../../../../include/uapi/linux/userfaultfd.h"
+#include <linux/userfaultfd.h>
 
+#ifndef __NR_userfaultfd
 #ifdef __x86_64__
 #define __NR_userfaultfd 323
 #elif defined(__i386__)
@@ -75,6 +76,7 @@
 #else
 #error "missing __NR_userfaultfd definition"
 #endif
+#endif
 
 static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 
_

Patches currently in -mm which might be from treding@nvidia.com are

userfaultfd-selftests-vm-pick-up-sanitized-kernel-headers.patch

