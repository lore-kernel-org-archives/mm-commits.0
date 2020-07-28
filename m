Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E89C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46DF42070A
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595974161;
	bh=7fv4lGQwgMy/ibFBTiw3/96cL0Q8dyeIcqMS+rYmCTI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ijcem6QM6Y1T35g3zfNdrtK6GQMNX/NY3kC3mBYK73C8U6RyJkhFcEZwUVO/URv/3
	 PIv6zUeudsWnglqgx4a3zm9eO+m1vPP3JzonLUHPMemQwKboVpFE+4aLBKQUhAJCr3
	 3cOk1wimSf1gvMoYQYYesxtfmnyIk5JhdVd8pzso=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgG1WJV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 18:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgG1WJU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 18:09:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA0F20672;
        Tue, 28 Jul 2020 22:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595974159;
        bh=7fv4lGQwgMy/ibFBTiw3/96cL0Q8dyeIcqMS+rYmCTI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M4bAL1bz3aBCSMI9JoFsUrMSI+smiqbO6XeViXaUMGlMgtfExa5I0f5s39eEV1Mrl
         ieATrNn/nCopZ+kMOicKqnYDI3P10EZqqMZCduGLRs/F7LGiGZ7GSFLTwQJpItJHG6
         S/CjF1S9PH1Gt4DFVEu4QXVeXBaRinpwptU+jdZs=
Date:   Tue, 28 Jul 2020 15:09:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, ricardo.canuelo@collabora.com
Subject:  + selftests-add-mincore-tests.patch added to -mm tree
Message-ID: <20200728220919.K7lT8z4-3%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add mincore() tests
has been added to the -mm tree.  Its filename is
     selftests-add-mincore-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-add-mincore-tests.pa=
tch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-mincore-tests.pa=
tch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ricardo Ca=C3=B1uelo <ricardo.canuelo@collabora.com>
Subject: selftests: add mincore() tests

Add a test suite for the mincore() syscall.  It tests most of its use
cases as well as its interface.

Tests implemented:

  - basic interface test
  - behavior on anonymous mappings
  - behavior on anonymous mappings with huge tlb pages
  - file-backed mapping with a regular file
  - file-backed mapping with a tmpfs file

Link: http://lkml.kernel.org/r/20200728100450.4065-1-ricardo.canuelo@collab=
ora.com
Signed-off-by: Ricardo Ca=C3=B1uelo <ricardo.canuelo@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                   |    1=20
 tools/testing/selftests/mincore/.gitignore         |    2=20
 tools/testing/selftests/mincore/Makefile           |    6=20
 tools/testing/selftests/mincore/mincore_selftest.c |  361 +++++++++++
 4 files changed, 370 insertions(+)

--- a/tools/testing/selftests/Makefile~selftests-add-mincore-tests
+++ a/tools/testing/selftests/Makefile
@@ -30,6 +30,7 @@ TARGETS +=3D lkdtm
 TARGETS +=3D membarrier
 TARGETS +=3D memfd
 TARGETS +=3D memory-hotplug
+TARGETS +=3D mincore
 TARGETS +=3D mount
 TARGETS +=3D mqueue
 TARGETS +=3D net
--- /dev/null
+++ a/tools/testing/selftests/mincore/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0+
+mincore_selftest
--- /dev/null
+++ a/tools/testing/selftests/mincore/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0+
+
+CFLAGS +=3D -Wall
+
+TEST_GEN_PROGS :=3D mincore_selftest
+include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/mincore/mincore_selftest.c
@@ -0,0 +1,361 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * kselftest suite for mincore().
+ *
+ * Copyright (C) 2020 Collabora, Ltd.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <string.h>
+#include <fcntl.h>
+#include <string.h>
+
+#include "../kselftest.h"
+#include "../kselftest_harness.h"
+
+/* Default test file size: 4MB */
+#define MB (1UL << 20)
+#define FILE_SIZE (4 * MB)
+
+
+/*
+ * Tests the user interface. This test triggers most of the documented
+ * error conditions in mincore().
+ */
+TEST(basic_interface)
+{
+	int retval;
+	int page_size;
+	unsigned char vec[1];
+	char *addr;
+
+	page_size =3D sysconf(_SC_PAGESIZE);
+
+	/* Query a 0 byte sized range */
+	retval =3D mincore(0, 0, vec);
+	EXPECT_EQ(0, retval);
+
+	/* Addresses in the specified range are invalid or unmapped */
+	errno =3D 0;
+	retval =3D mincore(NULL, page_size, vec);
+	EXPECT_EQ(-1, retval);
+	EXPECT_EQ(ENOMEM, errno);
+
+	errno =3D 0;
+	addr =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, addr) {
+		TH_LOG("mmap error: %s", strerror(errno));
+	}
+
+	/* <addr> argument is not page-aligned */
+	errno =3D 0;
+	retval =3D mincore(addr + 1, page_size, vec);
+	EXPECT_EQ(-1, retval);
+	EXPECT_EQ(EINVAL, errno);
+
+	/* <length> argument is too large */
+	errno =3D 0;
+	retval =3D mincore(addr, -1, vec);
+	EXPECT_EQ(-1, retval);
+	EXPECT_EQ(ENOMEM, errno);
+
+	/* <vec> argument points to an illegal address */
+	errno =3D 0;
+	retval =3D mincore(addr, page_size, NULL);
+	EXPECT_EQ(-1, retval);
+	EXPECT_EQ(EFAULT, errno);
+	munmap(addr, page_size);
+}
+
+
+/*
+ * Test mincore() behavior on a private anonymous page mapping.
+ * Check that the page is not loaded into memory right after the mapping
+ * but after accessing it (on-demand allocation).
+ * Then free the page and check that it's not memory-resident.
+ */
+TEST(check_anonymous_locked_pages)
+{
+	unsigned char vec[1];
+	char *addr;
+	int retval;
+	int page_size;
+
+	page_size =3D sysconf(_SC_PAGESIZE);
+
+	/* Map one page and check it's not memory-resident */
+	errno =3D 0;
+	addr =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, addr) {
+		TH_LOG("mmap error: %s", strerror(errno));
+	}
+	retval =3D mincore(addr, page_size, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(0, vec[0]) {
+		TH_LOG("Page found in memory before use");
+	}
+
+	/* Touch the page and check again. It should now be in memory */
+	addr[0] =3D 1;
+	mlock(addr, page_size);
+	retval =3D mincore(addr, page_size, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(1, vec[0]) {
+		TH_LOG("Page not found in memory after use");
+	}
+
+	/*
+	 * It shouldn't be memory-resident after unlocking it and
+	 * marking it as unneeded.
+	 */
+	munlock(addr, page_size);
+	madvise(addr, page_size, MADV_DONTNEED);
+	retval =3D mincore(addr, page_size, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(0, vec[0]) {
+		TH_LOG("Page in memory after being zapped");
+	}
+	munmap(addr, page_size);
+}
+
+
+/*
+ * Check mincore() behavior on huge pages.
+ * This test will be skipped if the mapping fails (ie. if there are no
+ * huge pages available).
+ *
+ * Make sure the system has at least one free huge page, check
+ * "HugePages_Free" in /proc/meminfo.
+ * Increment /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages if
+ * needed.
+ */
+TEST(check_huge_pages)
+{
+	unsigned char vec[1];
+	char *addr;
+	int retval;
+	int page_size;
+
+	page_size =3D sysconf(_SC_PAGESIZE);
+
+	errno =3D 0;
+	addr =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+		-1, 0);
+	if (addr =3D=3D MAP_FAILED) {
+		if (errno =3D=3D ENOMEM)
+			SKIP(return, "No huge pages available.");
+		else
+			TH_LOG("mmap error: %s", strerror(errno));
+	}
+	retval =3D mincore(addr, page_size, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(0, vec[0]) {
+		TH_LOG("Page found in memory before use");
+	}
+
+	addr[0] =3D 1;
+	mlock(addr, page_size);
+	retval =3D mincore(addr, page_size, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(1, vec[0]) {
+		TH_LOG("Page not found in memory after use");
+	}
+
+	munlock(addr, page_size);
+	munmap(addr, page_size);
+}
+
+
+/*
+ * Test mincore() behavior on a file-backed page.
+ * No pages should be loaded into memory right after the mapping. Then,
+ * accessing any address in the mapping range should load the page
+ * containing the address and a number of subsequent pages (readahead).
+ *
+ * The actual readahead settings depend on the test environment, so we
+ * can't make a lot of assumptions about that. This test covers the most
+ * general cases.
+ */
+TEST(check_file_mmap)
+{
+	unsigned char *vec;
+	int vec_size;
+	char *addr;
+	int retval;
+	int page_size;
+	int fd;
+	int i;
+	int ra_pages =3D 0;
+
+	page_size =3D sysconf(_SC_PAGESIZE);
+	vec_size =3D FILE_SIZE / page_size;
+	if (FILE_SIZE % page_size)
+		vec_size++;
+
+	vec =3D calloc(vec_size, sizeof(unsigned char));
+	ASSERT_NE(NULL, vec) {
+		TH_LOG("Can't allocate array");
+	}
+
+	errno =3D 0;
+	fd =3D open(".", O_TMPFILE | O_RDWR, 0600);
+	ASSERT_NE(-1, fd) {
+		TH_LOG("Can't create temporary file: %s",
+			strerror(errno));
+	}
+	errno =3D 0;
+	retval =3D fallocate(fd, 0, 0, FILE_SIZE);
+	ASSERT_EQ(0, retval) {
+		TH_LOG("Error allocating space for the temporary file: %s",
+			strerror(errno));
+	}
+
+	/*
+	 * Map the whole file, the pages shouldn't be fetched yet.
+	 */
+	errno =3D 0;
+	addr =3D mmap(NULL, FILE_SIZE, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	ASSERT_NE(MAP_FAILED, addr) {
+		TH_LOG("mmap error: %s", strerror(errno));
+	}
+	retval =3D mincore(addr, FILE_SIZE, vec);
+	ASSERT_EQ(0, retval);
+	for (i =3D 0; i < vec_size; i++) {
+		ASSERT_EQ(0, vec[i]) {
+			TH_LOG("Unexpected page in memory");
+		}
+	}
+
+	/*
+	 * Touch a page in the middle of the mapping. We expect the next
+	 * few pages (the readahead window) to be populated too.
+	 */
+	addr[FILE_SIZE / 2] =3D 1;
+	retval =3D mincore(addr, FILE_SIZE, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(1, vec[FILE_SIZE / 2 / page_size]) {
+		TH_LOG("Page not found in memory after use");
+	}
+
+	i =3D FILE_SIZE / 2 / page_size + 1;
+	while (i < vec_size && vec[i]) {
+		ra_pages++;
+		i++;
+	}
+	EXPECT_GT(ra_pages, 0) {
+		TH_LOG("No read-ahead pages found in memory");
+	}
+
+	EXPECT_LT(i, vec_size) {
+		TH_LOG("Read-ahead pages reached the end of the file");
+	}
+	/*
+	 * End of the readahead window. The rest of the pages shouldn't
+	 * be in memory.
+	 */
+	if (i < vec_size) {
+		while (i < vec_size && !vec[i])
+			i++;
+		EXPECT_EQ(vec_size, i) {
+			TH_LOG("Unexpected page in memory beyond readahead window");
+		}
+	}
+
+	munmap(addr, FILE_SIZE);
+	close(fd);
+	free(vec);
+}
+
+
+/*
+ * Test mincore() behavior on a page backed by a tmpfs file.  This test
+ * performs the same steps as the previous one. However, we don't expect
+ * any readahead in this case.
+ */
+TEST(check_tmpfs_mmap)
+{
+	unsigned char *vec;
+	int vec_size;
+	char *addr;
+	int retval;
+	int page_size;
+	int fd;
+	int i;
+	int ra_pages =3D 0;
+
+	page_size =3D sysconf(_SC_PAGESIZE);
+	vec_size =3D FILE_SIZE / page_size;
+	if (FILE_SIZE % page_size)
+		vec_size++;
+
+	vec =3D calloc(vec_size, sizeof(unsigned char));
+	ASSERT_NE(NULL, vec) {
+		TH_LOG("Can't allocate array");
+	}
+
+	errno =3D 0;
+	fd =3D open("/dev/shm", O_TMPFILE | O_RDWR, 0600);
+	ASSERT_NE(-1, fd) {
+		TH_LOG("Can't create temporary file: %s",
+			strerror(errno));
+	}
+	errno =3D 0;
+	retval =3D fallocate(fd, 0, 0, FILE_SIZE);
+	ASSERT_EQ(0, retval) {
+		TH_LOG("Error allocating space for the temporary file: %s",
+			strerror(errno));
+	}
+
+	/*
+	 * Map the whole file, the pages shouldn't be fetched yet.
+	 */
+	errno =3D 0;
+	addr =3D mmap(NULL, FILE_SIZE, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	ASSERT_NE(MAP_FAILED, addr) {
+		TH_LOG("mmap error: %s", strerror(errno));
+	}
+	retval =3D mincore(addr, FILE_SIZE, vec);
+	ASSERT_EQ(0, retval);
+	for (i =3D 0; i < vec_size; i++) {
+		ASSERT_EQ(0, vec[i]) {
+			TH_LOG("Unexpected page in memory");
+		}
+	}
+
+	/*
+	 * Touch a page in the middle of the mapping. We expect only
+	 * that page to be fetched into memory.
+	 */
+	addr[FILE_SIZE / 2] =3D 1;
+	retval =3D mincore(addr, FILE_SIZE, vec);
+	ASSERT_EQ(0, retval);
+	ASSERT_EQ(1, vec[FILE_SIZE / 2 / page_size]) {
+		TH_LOG("Page not found in memory after use");
+	}
+
+	i =3D FILE_SIZE / 2 / page_size + 1;
+	while (i < vec_size && vec[i]) {
+		ra_pages++;
+		i++;
+	}
+	ASSERT_EQ(ra_pages, 0) {
+		TH_LOG("Read-ahead pages found in memory");
+	}
+
+	munmap(addr, FILE_SIZE);
+	close(fd);
+	free(vec);
+}
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from ricardo.canuelo@collabora.com =
are

selftests-add-mincore-tests.patch

