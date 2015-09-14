From: akpm@linux-foundation.org
Subject: [to-be-updated] userfaultfd-selftest-fix.patch removed from -mm
 tree
Date: Mon, 14 Sep 2015 10:45:15 -0700
Message-ID: <55f707ab.X9OtqBuEtCZyqHas%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbINRpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, aarcange@redhat.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: pick up sanitized kernel headers
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: selftests: vm: pick up sanitized kernel headers

Add the usr/include subdirectory of the top-level tree to the include
path, and make sure to include headers without relative paths to make sure
the sanitized headers get picked up.  Otherwise the compiler will not be
able to find the linux/compiler.h header included by the non- sanitized
include/uapi/linux/userfaultfd.h.

While at it, make sure to only hardcode the syscall numbers on x86 and
PowerPC if they haven't been properly picked up from the headers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile      |    2 +-
 tools/testing/selftests/vm/userfaultfd.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~userfaultfd-selftest-fix tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~userfaultfd-selftest-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,6 @@
 # Makefile for vm selftests
 
-CFLAGS = -Wall
+CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-fix tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-fix
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


