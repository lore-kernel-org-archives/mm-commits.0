From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Fri, 06 Jan 2017 12:53:44 -0800
Message-ID: <587003d8.pF4IOummhhCJKVAX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031014AbdAFUwY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 15:52:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |   52 ++++++++++----------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~linux-next-rejects tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~linux-next-rejects
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,41 +1,29 @@
 # Makefile for vm selftests
 
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
-BINARIES = compaction_test
-BINARIES += hugepage-mmap
-BINARIES += hugepage-shm
-BINARIES += map_hugetlb
-BINARIES += mlock2-tests
-BINARIES += on-fault-limit
-BINARIES += thuge-gen
-BINARIES += transhuge-stress
-BINARIES += userfaultfd
-BINARIES += userfaultfd_hugetlb
-BINARIES += userfaultfd_shmem
-BINARIES += mlock-random-test
-
-all: $(BINARIES)
-%: %.c
-	$(CC) $(CFLAGS) -o $@ $^ -lrt
-userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
-	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
-userfaultfd_hugetlb: userfaultfd.c ../../../../usr/include/linux/kernel.h
-	$(CC) $(CFLAGS) -DHUGETLB_TEST -O2 -o $@ $< -lpthread
-
-userfaultfd_shmem: userfaultfd.c ../../../../usr/include/linux/kernel.h
-	$(CC) $(CFLAGS) -DSHMEM_TEST -O2 -o $@ $< -lpthread
-
-mlock-random-test: mlock-random-test.c
-	$(CC) $(CFLAGS) -o $@ $< -lcap
-
-../../../../usr/include/linux/kernel.h:
-	make -C ../../../.. headers_install
+LDLIBS = -lrt
+TEST_GEN_FILES = compaction_test
+TEST_GEN_FILES += hugepage-mmap
+TEST_GEN_FILES += hugepage-shm
+TEST_GEN_FILES += map_hugetlb
+TEST_GEN_FILES += mlock2-tests
+TEST_GEN_FILES += on-fault-limit
+TEST_GEN_FILES += thuge-gen
+TEST_GEN_FILES += transhuge-stress
+TEST_GEN_FILES += userfaultfd
+TEST_GEN_FILES += userfaultfd_hugetlb
+TEST_GEN_FILES += userfaultfd_shmem
+TEST_GEN_FILES += mlock-random-test
 
 TEST_PROGS := run_vmtests
-TEST_FILES := $(BINARIES)
 
 include ../lib.mk
 
-clean:
-	$(RM) $(BINARIES)
+$(OUTPUT)/userfaultfd: LDLIBS += -lpthread ../../../../usr/include/linux/kernel.h
+$(OUTPUT)/userfaultfd_hugetlb: LDLIBS += -lpthread ../../../../usr/include/linux/kernel.h
+$(OUTPUT)/userfaultfd_shmem: LDLIBS += -lpthread ../../../../usr/include/linux/kernel.h
+$(OUTPUT)/mlock-random-test: LDLIBS += -lcap
+
+../../../../usr/include/linux/kernel.h:
+	make -C ../../../.. headers_install
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

