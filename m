From: akpm@linux-foundation.org
Subject: [merged] self-test-fix-make-clean.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:24 -0700
Message-ID: <51db14f4.GVIzrco4MtQC7NDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3GHThY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joern@logfs.org

Subject: [merged] self-test-fix-make-clean.patch removed from -mm tree
To: joern@logfs.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:24 -0700


The patch titled
     Subject: self-test: fix make clean
has been removed from the -mm tree.  Its filename was
     self-test-fix-make-clean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch

