Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D332E7AD77
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjJCRME (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjJCRL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:11:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7901595
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:11:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB2C433CA;
        Tue,  3 Oct 2023 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696353114;
        bh=kuz8PRYT82Ux1xIGSHB+wDAjY2EDvCQiCb5kvD3QNgw=;
        h=Date:To:From:Subject:From;
        b=DpLHup0wIRotLfrKAkR+ZbNOfuHsfBKy+C87AXCJfAnp3dz0ZbsCKPQLxvr9Qwhp8
         UgBtxtKlyP2TDvBy1aXS9Xb8JGtqlyyOzA4jMCFeJ80Ig8fNc3ksZdtZwKqGTGsQqN
         FhpWUk+ZYENpqNdf/O/mDJB3XTGrtNEhRa6mbO3s=
Date:   Tue, 03 Oct 2023 10:11:53 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        riel@surriel.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        fvdl@google.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch added to mm-unstable branch
Message-Id: <20231003171154.13EB2C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a selftest to verify hugetlb usage in memcg
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: add a selftest to verify hugetlb usage in memcg
Date: Mon, 2 Oct 2023 17:18:28 -0700

Add a new kselftest to demonstrate and verify the new hugetlb memcg
accounting behavior.

Link: https://lkml.kernel.org/r/20231003001828.2554080-4-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                                         |    2 
 tools/testing/selftests/cgroup/.gitignore           |    1 
 tools/testing/selftests/cgroup/Makefile             |    2 
 tools/testing/selftests/cgroup/test_hugetlb_memcg.c |  234 ++++++++++
 4 files changed, 239 insertions(+)

--- a/MAINTAINERS~selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg
+++ a/MAINTAINERS
@@ -5269,6 +5269,7 @@ S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
 F:	tools/testing/selftests/cgroup/memcg_protection.m
+F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
 F:	tools/testing/selftests/cgroup/test_kmem.c
 F:	tools/testing/selftests/cgroup/test_memcontrol.c
 
@@ -9652,6 +9653,7 @@ F:	include/linux/hugetlb.h
 F:	mm/hugetlb.c
 F:	mm/hugetlb_vmemmap.c
 F:	mm/hugetlb_vmemmap.h
+F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
 
 HVA ST MEDIA DRIVER
 M:	Jean-Christophe Trotin <jean-christophe.trotin@foss.st.com>
--- a/tools/testing/selftests/cgroup/.gitignore~selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg
+++ a/tools/testing/selftests/cgroup/.gitignore
@@ -7,4 +7,5 @@ test_kill
 test_cpu
 test_cpuset
 test_zswap
+test_hugetlb_memcg
 wait_inotify
--- a/tools/testing/selftests/cgroup/Makefile~selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg
+++ a/tools/testing/selftests/cgroup/Makefile
@@ -14,6 +14,7 @@ TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_cpu
 TEST_GEN_PROGS += test_cpuset
 TEST_GEN_PROGS += test_zswap
+TEST_GEN_PROGS += test_hugetlb_memcg
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
@@ -27,3 +28,4 @@ $(OUTPUT)/test_kill: cgroup_util.c
 $(OUTPUT)/test_cpu: cgroup_util.c
 $(OUTPUT)/test_cpuset: cgroup_util.c
 $(OUTPUT)/test_zswap: cgroup_util.c
+$(OUTPUT)/test_hugetlb_memcg: cgroup_util.c
--- /dev/null
+++ a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <sys/mman.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+#define ADDR ((void *)(0x0UL))
+#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
+/* mapping 8 MBs == 4 hugepages */
+#define LENGTH (8UL*1024*1024)
+#define PROTECTION (PROT_READ | PROT_WRITE)
+
+/* borrowed from mm/hmm-tests.c */
+static long get_hugepage_size(void)
+{
+	int fd;
+	char buf[2048];
+	int len;
+	char *p, *q, *path = "/proc/meminfo", *tag = "Hugepagesize:";
+	long val;
+
+	fd = open(path, O_RDONLY);
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
+static int set_file(const char *path, long value)
+{
+	FILE *file;
+	int ret;
+
+	file = fopen(path, "w");
+	if (!file)
+		return -1;
+	ret = fprintf(file, "%ld\n", value);
+	fclose(file);
+	return ret;
+}
+
+static int set_nr_hugepages(long value)
+{
+	return set_file("/proc/sys/vm/nr_hugepages", value);
+}
+
+static unsigned int check_first(char *addr)
+{
+	return *(unsigned int *)addr;
+}
+
+static void write_data(char *addr)
+{
+	unsigned long i;
+
+	for (i = 0; i < LENGTH; i++)
+		*(addr + i) = (char)i;
+}
+
+static int hugetlb_test_program(const char *cgroup, void *arg)
+{
+	char *test_group = (char *)arg;
+	void *addr;
+	long old_current, expected_current, current;
+	int ret = EXIT_FAILURE;
+
+	old_current = cg_read_long(test_group, "memory.current");
+	set_nr_hugepages(20);
+	current = cg_read_long(test_group, "memory.current");
+	if (current - old_current >= MB(2)) {
+		ksft_print_msg(
+			"setting nr_hugepages should not increase hugepage usage.\n");
+		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
+		return EXIT_FAILURE;
+	}
+
+	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
+	if (addr == MAP_FAILED) {
+		ksft_print_msg("fail to mmap.\n");
+		return EXIT_FAILURE;
+	}
+	current = cg_read_long(test_group, "memory.current");
+	if (current - old_current >= MB(2)) {
+		ksft_print_msg("mmap should not increase hugepage usage.\n");
+		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
+		goto out_failed_munmap;
+	}
+	old_current = current;
+
+	/* read the first page */
+	check_first(addr);
+	expected_current = old_current + MB(2);
+	current = cg_read_long(test_group, "memory.current");
+	if (!values_close(expected_current, current, 5)) {
+		ksft_print_msg("memory usage should increase by around 2MB.\n");
+		ksft_print_msg(
+			"expected memory: %ld, actual memory: %ld\n",
+			expected_current, current);
+		goto out_failed_munmap;
+	}
+
+	/* write to the whole range */
+	write_data(addr);
+	current = cg_read_long(test_group, "memory.current");
+	expected_current = old_current + MB(8);
+	if (!values_close(expected_current, current, 5)) {
+		ksft_print_msg("memory usage should increase by around 8MB.\n");
+		ksft_print_msg(
+			"expected memory: %ld, actual memory: %ld\n",
+			expected_current, current);
+		goto out_failed_munmap;
+	}
+
+	/* unmap the whole range */
+	munmap(addr, LENGTH);
+	current = cg_read_long(test_group, "memory.current");
+	expected_current = old_current;
+	if (!values_close(expected_current, current, 5)) {
+		ksft_print_msg("memory usage should go back down.\n");
+		ksft_print_msg(
+			"expected memory: %ld, actual memory: %ld\n",
+			expected_current, current);
+		return ret;
+	}
+
+	ret = EXIT_SUCCESS;
+	return ret;
+
+out_failed_munmap:
+	munmap(addr, LENGTH);
+	return ret;
+}
+
+static int test_hugetlb_memcg(char *root)
+{
+	int ret = KSFT_FAIL;
+	char *test_group;
+
+	test_group = cg_name(root, "hugetlb_memcg_test");
+	if (!test_group || cg_create(test_group)) {
+		ksft_print_msg("fail to create cgroup.\n");
+		goto out;
+	}
+
+	if (cg_write(test_group, "memory.max", "100M")) {
+		ksft_print_msg("fail to set cgroup memory limit.\n");
+		goto out;
+	}
+
+	/* disable swap */
+	if (cg_write(test_group, "memory.swap.max", "0")) {
+		ksft_print_msg("fail to disable swap.\n");
+		goto out;
+	}
+
+	if (!cg_run(test_group, hugetlb_test_program, (void *)test_group))
+		ret = KSFT_PASS;
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
+
+	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
+	if (has_memory_hugetlb_acc < 0)
+		ksft_exit_skip("Failed to query cgroup mount option\n");
+	else if (!has_memory_hugetlb_acc)
+		ksft_exit_skip("memory hugetlb accounting is disabled\n");
+
+	/* Unit is kB! */
+	if (get_hugepage_size() != 2048) {
+		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
+		ksft_test_result_skip("test_hugetlb_memcg\n");
+		return ret;
+	}
+
+	if (cg_find_unified_root(root, sizeof(root)))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	switch (test_hugetlb_memcg(root)) {
+	case KSFT_PASS:
+		ksft_test_result_pass("test_hugetlb_memcg\n");
+		break;
+	case KSFT_SKIP:
+		ksft_test_result_skip("test_hugetlb_memcg\n");
+		break;
+	default:
+		ret = EXIT_FAILURE;
+		ksft_test_result_fail("test_hugetlb_memcg\n");
+		break;
+	}
+
+	return ret;
+}
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-change-zswaps-default-allocator-to-zsmalloc.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch
selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

