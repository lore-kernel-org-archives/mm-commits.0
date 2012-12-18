From: akpm@linux-foundation.org
Subject: [merged] vm-selftests-print-failure-status-instead-of-cause-make-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:01 -0800
Message-ID: <20121218201202.B04C9200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:49409 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2LRUMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:05 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so63478wib.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vm selftests: print failure status instead of cause make error
has been removed from the -mm tree.  Its filename was
     vm-selftests-print-failure-status-instead-of-cause-make-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: vm selftests: print failure status instead of cause make error

  bash-4.1$ make -C vm run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'
  /bin/sh ./run_vmtests
  ./run_vmtests: line 24: /proc/sys/vm/nr_hugepages: Permission denied
  Please run this test as root
  make: *** [run_tests] Error 1
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'

After applying the patch:
  bash-4.1$ make -C vm run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'
  ./run_vmtests: line 24: /proc/sys/vm/nr_hugepages: Permission denied
  Please run this test as root
  vmtests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/Makefile~vm-selftests-print-failure-status-instead-of-cause-make-error tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~vm-selftests-print-failure-status-instead-of-cause-make-error
+++ a/tools/testing/selftests/vm/Makefile
@@ -8,7 +8,7 @@ all: hugepage-mmap hugepage-shm  map_hug
 	$(CC) $(CFLAGS) -o $@ $^
 
 run_tests: all
-	/bin/sh ./run_vmtests
+	@/bin/sh ./run_vmtests || echo "vmtests: [FAIL]"
 
 clean:
 	$(RM) hugepage-mmap hugepage-shm  map_hugetlb
_

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch

