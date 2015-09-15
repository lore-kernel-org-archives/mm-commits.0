From: akpm@linux-foundation.org
Subject: + userfaultfd-selftest-headers-fixup.patch added to -mm tree
Date: Tue, 15 Sep 2015 13:04:35 -0700
Message-ID: <55f879d3.gMCJbTiRoCDLp2kj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbIOUEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 16:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: headers fixup
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-headers-fixup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-headers-fixup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-headers-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 tools/testing/selftests/vm/userfaultfd.c |    8 --------
 2 files changed, 5 insertions(+), 10 deletions(-)

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
@@ -67,16 +67,8 @@
 #include <linux/userfaultfd.h>
 
 #ifndef __NR_userfaultfd
-#ifdef __x86_64__
-#define __NR_userfaultfd 323
-#elif defined(__i386__)
-#define __NR_userfaultfd 374
-#elif defined(__powewrpc__)
-#define __NR_userfaultfd 364
-#else
 #error "missing __NR_userfaultfd definition"
 #endif
-#endif
 
 static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-selftest-headers-fixup.patch
userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc.patch
userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch
userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch

