From: akpm@linux-foundation.org
Subject: + self-test-fix-make-clean.patch added to -mm tree
Date: Fri, 28 Jun 2013 14:58:04 -0700
Message-ID: <51ce06ec.LJpwYVeeucCj86zf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3F1V6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 17:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joern@logfs.org

Subject: + self-test-fix-make-clean.patch added to -mm tree
To: joern@logfs.org
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 14:58:04 -0700


The patch titled
     Subject: self-test: fix make clean
has been added to the -mm tree.  Its filename is
     self-test-fix-make-clean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joern Engel <joern@logfs.org>
Subject: self-test: fix make clean

thuge-gen was forgotten.  Fix it by removing the duplication, so we don't
get too many repeats.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~self-test-fix-make-clean tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~self-test-fix-make-clean
+++ a/tools/testing/selftests/vm/Makefile
@@ -2,8 +2,9 @@
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
+BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen
 
-all: hugepage-mmap hugepage-shm  map_hugetlb thuge-gen
+all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
@@ -11,4 +12,4 @@ run_tests: all
 	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
 
 clean:
-	$(RM) hugepage-mmap hugepage-shm  map_hugetlb
+	$(RM) $(BINARIES)
_

Patches currently in -mm which might be from joern@logfs.org are

linux-next.patch
nilfs2-implement-calculation-of-free-inodes-count.patch
nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch
selftests-exit-1-on-failure.patch
self-test-fix-make-clean.patch
selftests-add-hugetlbfstest.patch

