From: akpm@linux-foundation.org
Subject: + vm-selftests-print-failure-status-instead-of-cause-make-error.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:41:45 -0800
Message-ID: <20121127204145.D112B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:49044 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2K0Uls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:41:48 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so890190lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:41:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, penberg@kernel.org


The patch titled
     Subject: vm selftests: print failure status instead of cause make error
has been added to the -mm tree.  Its filename is
     vm-selftests-print-failure-status-instead-of-cause-make-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vm-selftests-print-failure-status-instead-of-cause-make-error.patch
mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch
cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
breakpoint-selftests-print-failure-status-instead-of-cause-make-error.patch

