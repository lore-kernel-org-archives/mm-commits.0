From: akpm@linux-foundation.org
Subject: [merged] reverted-selftests-add-hugetlbfstest.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:47:22 -0700
Message-ID: <55f08cca.HAXkf3qVFQQpI4+c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbbIITrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, joern@logfs.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "selftests: add hugetlbfstest"
has been removed from the -mm tree.  Its filename was
     reverted-selftests-add-hugetlbfstest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Revert "selftests: add hugetlbfstest"

This manually reverts 7e50533d4b842 ("selftests: add hugetlbfstest").

The hugetlbfstest test depends on hugetlb pages being counted in a task's
rss.  This functionality is not in the kernel, so the test will always
fail.  Remove test to avoid confusion.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile        |    1 
 tools/testing/selftests/vm/hugetlbfstest.c |   86 -------------------
 tools/testing/selftests/vm/run_vmtests     |   11 --
 3 files changed, 98 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~reverted-selftests-add-hugetlbfstest tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~reverted-selftests-add-hugetlbfstest
+++ a/tools/testing/selftests/vm/Makefile
@@ -4,7 +4,6 @@ CFLAGS = -Wall
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
-BINARIES += hugetlbfstest
 BINARIES += map_hugetlb
 BINARIES += thuge-gen
 BINARIES += transhuge-stress
diff -puN tools/testing/selftests/vm/hugetlbfstest.c~reverted-selftests-add-hugetlbfstest /dev/null
--- a/tools/testing/selftests/vm/hugetlbfstest.c
+++ /dev/null
@@ -1,86 +0,0 @@
-#define _GNU_SOURCE
-#include <assert.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <unistd.h>
-
-typedef unsigned long long u64;
-
-static size_t length = 1 << 24;
-
-static u64 read_rss(void)
-{
-	char buf[4096], *s = buf;
-	int i, fd;
-	u64 rss;
-
-	fd = open("/proc/self/statm", O_RDONLY);
-	assert(fd > 2);
-	memset(buf, 0, sizeof(buf));
-	read(fd, buf, sizeof(buf) - 1);
-	for (i = 0; i < 1; i++)
-		s = strchr(s, ' ') + 1;
-	rss = strtoull(s, NULL, 10);
-	return rss << 12; /* assumes 4k pagesize */
-}
-
-static void do_mmap(int fd, int extra_flags, int unmap)
-{
-	int *p;
-	int flags = MAP_PRIVATE | MAP_POPULATE | extra_flags;
-	u64 before, after;
-	int ret;
-
-	before = read_rss();
-	p = mmap(NULL, length, PROT_READ | PROT_WRITE, flags, fd, 0);
-	assert(p != MAP_FAILED ||
-			!"mmap returned an unexpected error");
-	after = read_rss();
-	assert(llabs(after - before - length) < 0x40000 ||
-			!"rss didn't grow as expected");
-	if (!unmap)
-		return;
-	ret = munmap(p, length);
-	assert(!ret || !"munmap returned an unexpected error");
-	after = read_rss();
-	assert(llabs(after - before) < 0x40000 ||
-			!"rss didn't shrink as expected");
-}
-
-static int open_file(const char *path)
-{
-	int fd, err;
-
-	unlink(path);
-	fd = open(path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL
-			| O_LARGEFILE | O_CLOEXEC, 0600);
-	assert(fd > 2);
-	unlink(path);
-	err = ftruncate(fd, length);
-	assert(!err);
-	return fd;
-}
-
-int main(void)
-{
-	int hugefd, fd;
-
-	fd = open_file("/dev/shm/hugetlbhog");
-	hugefd = open_file("/hugepages/hugetlbhog");
-
-	system("echo 100 > /proc/sys/vm/nr_hugepages");
-	do_mmap(-1, MAP_ANONYMOUS, 1);
-	do_mmap(fd, 0, 1);
-	do_mmap(-1, MAP_ANONYMOUS | MAP_HUGETLB, 1);
-	do_mmap(hugefd, 0, 1);
-	do_mmap(hugefd, MAP_HUGETLB, 1);
-	/* Leak the last one to test do_exit() */
-	do_mmap(-1, MAP_ANONYMOUS | MAP_HUGETLB, 0);
-	printf("oll korrekt.\n");
-	return 0;
-}
diff -puN tools/testing/selftests/vm/run_vmtests~reverted-selftests-add-hugetlbfstest tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~reverted-selftests-add-hugetlbfstest
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -76,17 +76,6 @@ else
 fi
 
 echo "--------------------"
-echo "running hugetlbfstest"
-echo "--------------------"
-./hugetlbfstest
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
