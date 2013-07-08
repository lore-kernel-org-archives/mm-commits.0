From: akpm@linux-foundation.org
Subject: [merged] selftests-add-hugetlbfstest.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:26 -0700
Message-ID: <51db14f6.zmw6WHT7+wQcbYjL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3GHTh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joern@logfs.org

Subject: [merged] selftests-add-hugetlbfstest.patch removed from -mm tree
To: joern@logfs.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:26 -0700


The patch titled
     Subject: selftests: add hugetlbfstest
has been removed from the -mm tree.  Its filename was
     selftests-add-hugetlbfstest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joern Engel <joern@logfs.org>
Subject: selftests: add hugetlbfstest

As the confusing naming indicates, this test has some overlap with
pre-existing tests.  Would be nice to merge them eventually.  But since it
is only test code, cleanliness is much less important than mere existence.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile        |    2 
 tools/testing/selftests/vm/hugetlbfstest.c |   84 +++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests     |   11 ++
 3 files changed, 96 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/Makefile~selftests-add-hugetlbfstest tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-add-hugetlbfstest
+++ a/tools/testing/selftests/vm/Makefile
@@ -2,7 +2,7 @@
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
-BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen
+BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
 
 all: $(BINARIES)
 %: %.c
diff -puN /dev/null tools/testing/selftests/vm/hugetlbfstest.c
--- /dev/null
+++ a/tools/testing/selftests/vm/hugetlbfstest.c
@@ -0,0 +1,84 @@
+#define _GNU_SOURCE
+#include <assert.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+typedef unsigned long long u64;
+
+static size_t length = 1 << 24;
+
+static u64 read_rss(void)
+{
+	char buf[4096], *s = buf;
+	int i, fd;
+	u64 rss;
+
+	fd = open("/proc/self/statm", O_RDONLY);
+	assert(fd > 2);
+	memset(buf, 0, sizeof(buf));
+	read(fd, buf, sizeof(buf) - 1);
+	for (i = 0; i < 1; i++)
+		s = strchr(s, ' ') + 1;
+	rss = strtoull(s, NULL, 10);
+	return rss << 12; /* assumes 4k pagesize */
+}
+
+static void do_mmap(int fd, int extra_flags, int unmap)
+{
+	int *p;
+	int flags = MAP_PRIVATE | MAP_POPULATE | extra_flags;
+	u64 before, after;
+
+	before = read_rss();
+	p = mmap(NULL, length, PROT_READ | PROT_WRITE, flags, fd, 0);
+	assert(p != MAP_FAILED ||
+			!"mmap returned an unexpected error");
+	after = read_rss();
+	assert(llabs(after - before - length) < 0x40000 ||
+			!"rss didn't grow as expected");
+	if (!unmap)
+		return;
+	munmap(p, length);
+	after = read_rss();
+	assert(llabs(after - before) < 0x40000 ||
+			!"rss didn't shrink as expected");
+}
+
+static int open_file(const char *path)
+{
+	int fd, err;
+
+	unlink(path);
+	fd = open(path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL
+			| O_LARGEFILE | O_CLOEXEC, 0600);
+	assert(fd > 2);
+	unlink(path);
+	err = ftruncate(fd, length);
+	assert(!err);
+	return fd;
+}
+
+int main(void)
+{
+	int hugefd, fd;
+
+	fd = open_file("/dev/shm/hugetlbhog");
+	hugefd = open_file("/hugepages/hugetlbhog");
+
+	system("echo 100 > /proc/sys/vm/nr_hugepages");
+	do_mmap(-1, MAP_ANONYMOUS, 1);
+	do_mmap(fd, 0, 1);
+	do_mmap(-1, MAP_ANONYMOUS | MAP_HUGETLB, 1);
+	do_mmap(hugefd, 0, 1);
+	do_mmap(hugefd, MAP_HUGETLB, 1);
+	/* Leak the last one to test do_exit() */
+	do_mmap(-1, MAP_ANONYMOUS | MAP_HUGETLB, 0);
+	printf("oll korrekt.\n");
+	return 0;
+}
diff -puN tools/testing/selftests/vm/run_vmtests~selftests-add-hugetlbfstest tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~selftests-add-hugetlbfstest
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -75,6 +75,17 @@ else
 	echo "[PASS]"
 fi
 
+echo "--------------------"
+echo "running hugetlbfstest"
+echo "--------------------"
+./hugetlbfstest
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 #cleanup
 umount $mnt
 rm -rf $mnt
_

Patches currently in -mm which might be from joern@logfs.org are

origin.patch
linux-next.patch
mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch

