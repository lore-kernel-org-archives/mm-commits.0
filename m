From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-vm-allow-to-build-in-vm-directory.patch removed from
 -mm tree
Date: Fri, 10 Mar 2017 13:43:18 -0800
Message-ID: <58c31df6.5fOhWkb5knjENvm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVnU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: vm: allow to build in vm/ directory
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-vm-allow-to-build-in-vm-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: vm: allow to build in vm/ directory

linux/tools/testing/selftests/vm $ make
gcc -Wall -I ../../../../usr/include     compaction_test.c -lrt -o /compaction_test
/usr/lib/gcc/x86_64-pc-linux-gnu/4.9.4/../../../../x86_64-pc-linux-gnu/bin/ld:
cannot open output file /compaction_test: Permission denied
collect2: error: ld returned 1 exit status
make: *** [../lib.mk:54: /compaction_test] Error 1

Since commit a8ba798bc8ec ("selftests: enable O and KBUILD_OUTPUT")
selftests/vm build fails if run from the "selftests/vm" directory, but it
works in the selftests/ directory.  It's quicker to be able to do a local
vm-only build after a tree wipe and this patch allows for it again.

Link: http://lkml.kernel.org/r/20170302173738.18994-4-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN tools/testing/selftests/vm/Makefile~userfaultfd-selftest-vm-allow-to-build-in-vm-directory tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~userfaultfd-selftest-vm-allow-to-build-in-vm-directory
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,5 +1,9 @@
 # Makefile for vm selftests
 
+ifndef OUTPUT
+  OUTPUT := $(shell pwd)
+endif
+
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 LDLIBS = -lrt
 TEST_GEN_FILES = compaction_test
_

Patches currently in -mm which might be from aarcange@redhat.com are


