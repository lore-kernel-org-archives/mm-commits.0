From: akpm@linux-foundation.org
Subject: [patch 091/119] memfd-test: move common code to a shared
 unit
Date: Wed, 31 Jan 2018 16:19:40 -0800
Message-ID: <20180201001940.lXbMRxaum%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755813AbeBAATm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: memfd-test: move common code to a shared unit

The memfd & fuse tests will share more common code in the following
commits to test hugetlb support.

Link: http://lkml.kernel.org/r/20171107122800.25517-9-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/Makefile     |    5 ++
 tools/testing/selftests/memfd/common.c     |   46 +++++++++++++++++++
 tools/testing/selftests/memfd/common.h     |    9 +++
 tools/testing/selftests/memfd/fuse_test.c  |    8 ---
 tools/testing/selftests/memfd/memfd_test.c |   36 --------------
 5 files changed, 64 insertions(+), 40 deletions(-)

diff -puN /dev/null tools/testing/selftests/memfd/common.c
--- /dev/null
+++ a/tools/testing/selftests/memfd/common.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#define __EXPORTED_HEADERS__
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <linux/fcntl.h>
+#include <linux/memfd.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+#include "common.h"
+
+int hugetlbfs_test = 0;
+
+/*
+ * Copied from mlock2-tests.c
+ */
+unsigned long default_huge_page_size(void)
+{
+	unsigned long hps = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
+
+int sys_memfd_create(const char *name, unsigned int flags)
+{
+	if (hugetlbfs_test)
+		flags |= MFD_HUGETLB;
+
+	return syscall(__NR_memfd_create, name, flags);
+}
diff -puN /dev/null tools/testing/selftests/memfd/common.h
--- /dev/null
+++ a/tools/testing/selftests/memfd/common.h
@@ -0,0 +1,9 @@
+#ifndef COMMON_H_
+#define COMMON_H_
+
+extern int hugetlbfs_test;
+
+unsigned long default_huge_page_size(void);
+int sys_memfd_create(const char *name, unsigned int flags);
+
+#endif
diff -puN tools/testing/selftests/memfd/fuse_test.c~memfd-test-move-common-code-to-a-shared-unit tools/testing/selftests/memfd/fuse_test.c
--- a/tools/testing/selftests/memfd/fuse_test.c~memfd-test-move-common-code-to-a-shared-unit
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -33,15 +33,11 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
+#include "common.h"
+
 #define MFD_DEF_SIZE 8192
 #define STACK_SIZE 65536
 
-static int sys_memfd_create(const char *name,
-			    unsigned int flags)
-{
-	return syscall(__NR_memfd_create, name, flags);
-}
-
 static int mfd_assert_new(const char *name, loff_t sz, unsigned int flags)
 {
 	int r, fd;
diff -puN tools/testing/selftests/memfd/Makefile~memfd-test-move-common-code-to-a-shared-unit tools/testing/selftests/memfd/Makefile
--- a/tools/testing/selftests/memfd/Makefile~memfd-test-move-common-code-to-a-shared-unit
+++ a/tools/testing/selftests/memfd/Makefile
@@ -12,3 +12,8 @@ fuse_mnt.o: CFLAGS += $(shell pkg-config
 include ../lib.mk
 
 $(OUTPUT)/fuse_mnt: LDLIBS += $(shell pkg-config fuse --libs)
+
+$(OUTPUT)/memfd_test: memfd_test.c common.o
+$(OUTPUT)/fuse_test: fuse_test.c common.o
+
+EXTRA_CLEAN = common.o
diff -puN tools/testing/selftests/memfd/memfd_test.c~memfd-test-move-common-code-to-a-shared-unit tools/testing/selftests/memfd/memfd_test.c
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd-test-move-common-code-to-a-shared-unit
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -19,6 +19,8 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
+#include "common.h"
+
 #define MEMFD_STR	"memfd:"
 #define MEMFD_HUGE_STR	"memfd-hugetlb:"
 #define SHARED_FT_STR	"(shared file-table)"
@@ -29,43 +31,9 @@
 /*
  * Default is not to test hugetlbfs
  */
-static int hugetlbfs_test;
 static size_t mfd_def_size = MFD_DEF_SIZE;
 static const char *memfd_str = MEMFD_STR;
 
-/*
- * Copied from mlock2-tests.c
- */
-static unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-
-	free(line);
-	fclose(f);
-	return hps;
-}
-
-static int sys_memfd_create(const char *name,
-			    unsigned int flags)
-{
-	if (hugetlbfs_test)
-		flags |= MFD_HUGETLB;
-
-	return syscall(__NR_memfd_create, name, flags);
-}
