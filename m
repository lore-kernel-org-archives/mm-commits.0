From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-selftest-headers-fixup.patch removed from
 -mm tree
Date: Mon, 28 Sep 2015 11:15:43 -0700
Message-ID: <560983cf.CP/uyyfLKyWx0C5X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbbI1SPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: headers fixup
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-headers-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: headers fixup

Depend on "make headers_install" to create proper headers to include
and provide syscall numbers.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile      |    7 +++++--
 tools/testing/selftests/vm/userfaultfd.c |   10 ----------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~userfaultfd-selftest-headers-fixup tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~userfaultfd-selftest-headers-fixup
+++ a/tools/testing/selftests/vm/Makefile
@@ -12,8 +12,11 @@ BINARIES += userfaultfd
 all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^ -lrt
-userfaultfd: userfaultfd.c
-	$(CC) $(CFLAGS) -O2 -o $@ $^ -lpthread
+userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
+	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
+
+../../../../usr/include/linux/kernel.h:
+	make -C ../../../.. headers_install
 
 TEST_PROGS := run_vmtests
 TEST_FILES := $(BINARIES)
diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-headers-fixup tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-headers-fixup
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -67,18 +67,8 @@
 #include <linux/userfaultfd.h>
 
 #ifndef __NR_userfaultfd
-#ifdef __x86_64__
-#define __NR_userfaultfd 323
-#elif defined(__i386__)
-#define __NR_userfaultfd 374
-#elif defined(__powewrpc__)
-#define __NR_userfaultfd 364
-#elif defined(__s390__)
-#define __NR_userfaultfd 355
-#else
 #error "missing __NR_userfaultfd definition"
 #endif
-#endif
 
 static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are


