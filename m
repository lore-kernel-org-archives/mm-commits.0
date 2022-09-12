Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8849ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiILDa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiILD24 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2462613F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF2526117A
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F411C433D7;
        Mon, 12 Sep 2022 03:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953333;
        bh=xTDvNUJY+CKfsEfBjR/IGcu+nP8DHvwY5eQvVI7pXgw=;
        h=Date:To:From:Subject:From;
        b=11ZX7FJr76nqcZPW6295OPW1hfoonMbePF5pEBn2ppSk0xxt2aSniHxu4oez41fx3
         6j8wr0t72/O8YKjZQA3pplSZytbksTJFfLMeqkDObZVG0kavwIdSB9jKCgMymWRaVg
         y0jL/uej40tEPywV6YAqwlYvzgUgIPFwj/doYNVs=
Date:   Sun, 11 Sep 2022 20:28:52 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        vaibhav@linux.ibm.com, shuah@kernel.org, sbhat@linux.ibm.com,
        jglisse@redhat.com, axelrasmussen@google.com,
        aneesh.kumar@linux.ibm.com, tsahu@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftests-removing-support-of-libhugetlbfs-from-kselftests.patch removed from -mm tree
Message-Id: <20220912032853.1F411C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Kselftests: remove support of libhugetlbfs from kselftests
has been removed from the -mm tree.  Its filename was
     kselftests-removing-support-of-libhugetlbfs-from-kselftests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tarun Sahu <tsahu@linux.ibm.com>
Subject: Kselftests: remove support of libhugetlbfs from kselftests
Date: Mon, 1 Aug 2022 12:32:31 +0530

libhugetlbfs, the user side utitlity to work with hugepages, does not have
any active support.  There are only 2 selftests which are part of in
vm/hmm_test.c that depends on libhugetlbfs.

This patch modifies the tests so that they will not require libhugetlb
library.

[axelrasmussen@google.com: : remove orphaned references to local_config.{h,mk}]
  Link: https://lkml.kernel.org/r/20220831211526.2743216-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20220801070231.13831-1-tsahu@linux.ibm.com
Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Tested-by: Zach O'Keefe <zokeefe@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile        |   21 ---
 tools/testing/selftests/vm/check_config.sh |   31 -----
 tools/testing/selftests/vm/hmm-tests.c     |  108 ++++++++++++-------
 3 files changed, 74 insertions(+), 86 deletions(-)

--- a/tools/testing/selftests/vm/check_config.sh
+++ /dev/null
@@ -1,31 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-#
-# Probe for libraries and create header files to record the results. Both C
-# header files and Makefile include fragments are created.
-
-OUTPUT_H_FILE=local_config.h
-OUTPUT_MKFILE=local_config.mk
-
-# libhugetlbfs
-tmpname=$(mktemp)
-tmpfile_c=${tmpname}.c
-tmpfile_o=${tmpname}.o
-
-echo "#include <sys/types.h>"        > $tmpfile_c
-echo "#include <hugetlbfs.h>"       >> $tmpfile_c
-echo "int func(void) { return 0; }" >> $tmpfile_c
-
-CC=${1:?"Usage: $0 <compiler> # example compiler: gcc"}
-$CC -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
-
-if [ -f $tmpfile_o ]; then
-    echo "#define LOCAL_CONFIG_HAVE_LIBHUGETLBFS 1" > $OUTPUT_H_FILE
-    echo "HMM_EXTRA_LIBS = -lhugetlbfs"             > $OUTPUT_MKFILE
-else
-    echo "// No libhugetlbfs support found"      > $OUTPUT_H_FILE
-    echo "# No libhugetlbfs support found, so:"  > $OUTPUT_MKFILE
-    echo "HMM_EXTRA_LIBS = "                    >> $OUTPUT_MKFILE
-fi
-
-rm ${tmpname}.*
--- a/tools/testing/selftests/vm/hmm-tests.c~kselftests-removing-support-of-libhugetlbfs-from-kselftests
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -26,10 +26,6 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 
-#include "./local_config.h"
-#ifdef LOCAL_CONFIG_HAVE_LIBHUGETLBFS
-#include <hugetlbfs.h>
-#endif
 
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
@@ -733,7 +729,54 @@ TEST_F(hmm, anon_write_huge)
 	hmm_buffer_free(buffer);
 }
 
-#ifdef LOCAL_CONFIG_HAVE_LIBHUGETLBFS
+/*
+ * Read numeric data from raw and tagged kernel status files.  Used to read
+ * /proc and /sys data (without a tag) and from /proc/meminfo (with a tag).
+ */
+static long file_read_ulong(char *file, const char *tag)
+{
+	int fd;
+	char buf[2048];
+	int len;
+	char *p, *q;
+	long val;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		/* Error opening the file */
+		return -1;
+	}
+
+	len = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (len < 0) {
+		/* Error in reading the file */
+		return -1;
+	}
+	if (len == sizeof(buf)) {
+		/* Error file is too large */
+		return -1;
+	}
+	buf[len] = '\0';
+
+	/* Search for a tag if provided */
+	if (tag) {
+		p = strstr(buf, tag);
+		if (!p)
+			return -1; /* looks like the line we want isn't there */
+		p += strlen(tag);
+	} else
+		p = buf;
+
+	val = strtol(p, &q, 0);
+	if (*q != ' ') {
+		/* Error parsing the file */
+		return -1;
+	}
+
+	return val;
+}
+
 /*
  * Write huge TLBFS page.
  */
@@ -742,29 +785,27 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size;
+	unsigned long default_hsize;
 	unsigned long i;
 	int *ptr;
 	int ret;
-	long pagesizes[4];
-	int n, idx;
-
-	/* Skip test if we can't allocate a hugetlbfs page. */
 
-	n = gethugepagesizes(pagesizes, 4);
-	if (n <= 0)
+	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
+	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
 		SKIP(return, "Huge page size could not be determined");
-	for (idx = 0; --n > 0; ) {
-		if (pagesizes[n] < pagesizes[idx])
-			idx = n;
-	}
-	size = ALIGN(TWOMEG, pagesizes[idx]);
+	default_hsize = default_hsize*1024; /* KB to B */
+
+	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
 
-	buffer->ptr = get_hugepage_region(size, GHR_STRICT);
-	if (buffer->ptr == NULL) {
+	buffer->ptr = mmap(NULL, size,
+				   PROT_READ | PROT_WRITE,
+				   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+				   -1, 0);
+	if (buffer->ptr == MAP_FAILED) {
 		free(buffer);
 		SKIP(return, "Huge page could not be allocated");
 	}
@@ -788,11 +829,10 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
-	free_hugepage_region(buffer->ptr);
+	munmap(buffer->ptr, buffer->size);
 	buffer->ptr = NULL;
 	hmm_buffer_free(buffer);
 }
-#endif /* LOCAL_CONFIG_HAVE_LIBHUGETLBFS */
 
 /*
  * Read mmap'ed file memory.
@@ -1467,7 +1507,6 @@ TEST_F(hmm2, snapshot)
 	hmm_buffer_free(buffer);
 }
 
-#ifdef LOCAL_CONFIG_HAVE_LIBHUGETLBFS
 /*
  * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
  * should be mapped by a large page table entry.
@@ -1477,30 +1516,30 @@ TEST_F(hmm, compound)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size;
+	unsigned long default_hsize;
 	int *ptr;
 	unsigned char *m;
 	int ret;
-	long pagesizes[4];
-	int n, idx;
 	unsigned long i;
 
 	/* Skip test if we can't allocate a hugetlbfs page. */
 
-	n = gethugepagesizes(pagesizes, 4);
-	if (n <= 0)
-		return;
-	for (idx = 0; --n > 0; ) {
-		if (pagesizes[n] < pagesizes[idx])
-			idx = n;
-	}
-	size = ALIGN(TWOMEG, pagesizes[idx]);
+	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
+	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+		SKIP(return, "Huge page size could not be determined");
+	default_hsize = default_hsize*1024; /* KB to B */
+
+	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
 
-	buffer->ptr = get_hugepage_region(size, GHR_STRICT);
-	if (buffer->ptr == NULL) {
+	buffer->ptr = mmap(NULL, size,
+				   PROT_READ | PROT_WRITE,
+				   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+				   -1, 0);
+	if (buffer->ptr == MAP_FAILED) {
 		free(buffer);
 		return;
 	}
@@ -1539,11 +1578,10 @@ TEST_F(hmm, compound)
 		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_READ |
 				HMM_DMIRROR_PROT_PMD);
 
-	free_hugepage_region(buffer->ptr);
+	munmap(buffer->ptr, buffer->size);
 	buffer->ptr = NULL;
 	hmm_buffer_free(buffer);
 }
-#endif /* LOCAL_CONFIG_HAVE_LIBHUGETLBFS */
 
 /*
  * Test two devices reading the same memory (double mapped).
--- a/tools/testing/selftests/vm/Makefile~kselftests-removing-support-of-libhugetlbfs-from-kselftests
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,9 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 
-LOCAL_HDRS += $(selfdir)/vm/local_config.h $(top_srcdir)/mm/gup_test.h
-
-include local_config.mk
+LOCAL_HDRS += $(top_srcdir)/mm/gup_test.h
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
@@ -152,23 +150,6 @@ endif
 
 $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
-# HMM_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
-$(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
-
 $(OUTPUT)/ksm_tests: LDLIBS += -lnuma
 
 $(OUTPUT)/migration: LDLIBS += -lnuma
-
-local_config.mk local_config.h: check_config.sh
-	/bin/sh ./check_config.sh $(CC)
-
-EXTRA_CLEAN += local_config.mk local_config.h
-
-ifeq ($(HMM_EXTRA_LIBS),)
-all: warn_missing_hugelibs
-
-warn_missing_hugelibs:
-	@echo ; \
-	echo "Warning: missing libhugetlbfs support. Some HMM tests will be skipped." ; \
-	echo
-endif
_

Patches currently in -mm which might be from tsahu@linux.ibm.com are


