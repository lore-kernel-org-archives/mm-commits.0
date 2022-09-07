Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A47C6FA89
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiIGWU0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiIGWUX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3772A43F
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091A261ACE
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C5BC433C1;
        Wed,  7 Sep 2022 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662589210;
        bh=FbA8W5PzGa1oEXgUgc0OmesoyF7a18YFIsDDF32K7kU=;
        h=Date:To:From:Subject:From;
        b=oW9QL+Sr7wvUkb6bj2R8KJJ9GIkyQYy5tlCOLi/GBb1m9EIOt5fgjZhNy5IoqRJxD
         JX+T2+uAhGf+hzp6IwT+1wLnroRGmhYUOYoaWP3LJjyiU0nbCwkMEU1b0qyYJwSjsl
         rya1gw1K+KVrsadtek8VisyDbbcr+dlOZGVg60/w=
Date:   Wed, 07 Sep 2022 15:20:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch added to mm-unstable branch
Message-Id: <20220907222010.52C5BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add thp collapse file and tmpfs testing
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: add thp collapse file and tmpfs testing
Date: Wed, 7 Sep 2022 07:45:18 -0700

Add memory operations for file-backed and tmpfs memory.  Call existing
tests with these new memory operations to test collapse functionality of
khugepaged and MADV_COLLAPSE on file-backed and tmpfs memory.  Not all
tests are reusable; for example, collapse_swapin_single_pte() which checks
swap usage.

Refactor test arguments.  Usage is now:

Usage: ./khugepaged <test type> [dir]

        <test type>     : <context>:<mem_type>
        <context>       : [all|khugepaged|madvise]
        <mem_type>      : [all|anon|file]

        "file,all" mem_type requires [dir] argument

        "file,all" mem_type requires kernel built with
        CONFIG_READ_ONLY_THP_FOR_FS=y

        if [dir] is a (sub)directory of a tmpfs mount, tmpfs must be
        mounted with huge=madvise option for khugepaged tests to work

Refactor calling tests to make it clear what collapse context / memory
operations they support, but only invoke tests requested by user.  Also
log what test is being ran, and with what context / memory, to make test
logs more human readable.

A new test file is created and deleted for every test to ensure no pages
remain in the page cache between tests (tests also may attempt to collapse
different amount of memory).

For file-backed memory where the file is stored on a block device, disable
/sys/block/<device>/queue/read_ahead_kb so that pages don't find their way
into the page cache without the tests faulting them in.

Add file and shmem wrappers to vm_utils check for file and shmem hugepages
in smaps.

Link: https://lkml.kernel.org/r/20220907144521.3115321-8-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |  473 +++++++++++++++++++---
 tools/testing/selftests/vm/vm_util.c    |   10 
 tools/testing/selftests/vm/vm_util.h    |    2 
 3 files changed, 429 insertions(+), 56 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-add-thp-collapse-file-and-tmpfs-testing
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -1,6 +1,8 @@
 #define _GNU_SOURCE
+#include <ctype.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <dirent.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -10,12 +12,21 @@
 
 #include <sys/mman.h>
 #include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <sys/vfs.h>
+
+#include "linux/magic.h"
 
 #include "vm_util.h"
 
 #ifndef MADV_PAGEOUT
 #define MADV_PAGEOUT 21
 #endif
+#ifndef MADV_POPULATE_READ
+#define MADV_POPULATE_READ 22
+#endif
 #ifndef MADV_COLLAPSE
 #define MADV_COLLAPSE 25
 #endif
@@ -27,20 +38,47 @@ static int hpage_pmd_nr;
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
 #define PID_SMAPS "/proc/self/smaps"
+#define TEST_FILE "collapse_test_file"
+
+#define MAX_LINE_LENGTH 500
+
+enum vma_type {
+	VMA_ANON,
+	VMA_FILE,
+	VMA_SHMEM,
+};
 
 struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
 	void (*fault)(void *p, unsigned long start, unsigned long end);
 	bool (*check_huge)(void *addr, int nr_hpages);
+	const char *name;
 };
 
+static struct mem_ops *file_ops;
+static struct mem_ops *anon_ops;
+
 struct collapse_context {
 	void (*collapse)(const char *msg, char *p, int nr_hpages,
 			 struct mem_ops *ops, bool expect);
 	bool enforce_pte_scan_limits;
+	const char *name;
+};
+
+static struct collapse_context *khugepaged_context;
+static struct collapse_context *madvise_context;
+
+struct file_info {
+	const char *dir;
+	char path[PATH_MAX];
+	enum vma_type type;
+	int fd;
+	char dev_queue_read_ahead_path[PATH_MAX];
 };
 
+static struct file_info finfo;
+
 enum thp_enabled {
 	THP_ALWAYS,
 	THP_MADVISE,
@@ -106,6 +144,7 @@ struct settings {
 	enum shmem_enabled shmem_enabled;
 	bool use_zero_page;
 	struct khugepaged_settings khugepaged;
+	unsigned long read_ahead_kb;
 };
 
 static struct settings saved_settings;
@@ -124,6 +163,11 @@ static void fail(const char *msg)
 	exit_status++;
 }
 
+static void skip(const char *msg)
+{
+	printf(" \e[33m%s\e[0m\n", msg);
+}
+
 static int read_file(const char *path, char *buf, size_t buflen)
 {
 	int fd;
@@ -151,13 +195,19 @@ static int write_file(const char *path,
 	ssize_t numwritten;
 
 	fd = open(path, O_WRONLY);
-	if (fd == -1)
+	if (fd == -1) {
+		printf("open(%s)\n", path);
+		exit(EXIT_FAILURE);
 		return 0;
+	}
 
 	numwritten = write(fd, buf, buflen - 1);
 	close(fd);
-	if (numwritten < 1)
+	if (numwritten < 1) {
+		printf("write(%s)\n", buf);
+		exit(EXIT_FAILURE);
 		return 0;
+	}
 
 	return (unsigned int) numwritten;
 }
@@ -224,20 +274,11 @@ static void write_string(const char *nam
 	}
 }
 
-static const unsigned long read_num(const char *name)
+static const unsigned long _read_num(const char *path)
 {
-	char path[PATH_MAX];
 	char buf[21];
-	int ret;
-
-	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
 
-	ret = read_file(path, buf, sizeof(buf));
-	if (ret < 0) {
+	if (read_file(path, buf, sizeof(buf)) < 0) {
 		perror("read_file(read_num)");
 		exit(EXIT_FAILURE);
 	}
@@ -245,10 +286,9 @@ static const unsigned long read_num(cons
 	return strtoul(buf, NULL, 10);
 }
 
-static void write_num(const char *name, unsigned long num)
+static const unsigned long read_num(const char *name)
 {
 	char path[PATH_MAX];
-	char buf[21];
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
@@ -256,6 +296,12 @@ static void write_num(const char *name,
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
+	return _read_num(path);
+}
+
+static void _write_num(const char *path, unsigned long num)
+{
+	char buf[21];
 
 	sprintf(buf, "%ld", num);
 	if (!write_file(path, buf, strlen(buf) + 1)) {
@@ -264,6 +310,19 @@ static void write_num(const char *name,
 	}
 }
 
+static void write_num(const char *name, unsigned long num)
+{
+	char path[PATH_MAX];
+	int ret;
+
+	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
+	if (ret >= PATH_MAX) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	_write_num(path, num);
+}
+
 static void write_settings(struct settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
@@ -283,6 +342,10 @@ static void write_settings(struct settin
 	write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
 	write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
 	write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
+
+	if (file_ops && finfo.type == VMA_FILE)
+		_write_num(finfo.dev_queue_read_ahead_path,
+			   settings->read_ahead_kb);
 }
 
 #define MAX_SETTINGS_DEPTH 4
@@ -353,6 +416,10 @@ static void save_settings(void)
 		.max_ptes_shared = read_num("khugepaged/max_ptes_shared"),
 		.pages_to_scan = read_num("khugepaged/pages_to_scan"),
 	};
+	if (file_ops && finfo.type == VMA_FILE)
+		saved_settings.read_ahead_kb =
+				_read_num(finfo.dev_queue_read_ahead_path);
+
 	success("OK");
 
 	signal(SIGTERM, restore_settings);
@@ -361,7 +428,88 @@ static void save_settings(void)
 	signal(SIGQUIT, restore_settings);
 }
 
-#define MAX_LINE_LENGTH 500
+static void get_finfo(const char *dir)
+{
+	struct stat path_stat;
+	struct statfs fs;
+	char buf[1 << 10];
+	char path[PATH_MAX];
+	char *str, *end;
+
+	finfo.dir = dir;
+	stat(finfo.dir, &path_stat);
+	if (!S_ISDIR(path_stat.st_mode)) {
+		printf("%s: Not a directory (%s)\n", __func__, finfo.dir);
+		exit(EXIT_FAILURE);
+	}
+	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
+		     finfo.dir) >= sizeof(finfo.path)) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	if (statfs(finfo.dir, &fs)) {
+		perror("statfs()");
+		exit(EXIT_FAILURE);
+	}
+	finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
+
+	/* Find owning device's queue/read_ahead_kb control */
+	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
+		     major(path_stat.st_dev), minor(path_stat.st_dev))
+	    >= sizeof(path)) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	if (read_file(path, buf, sizeof(buf)) < 0) {
+		perror("read_file(read_num)");
+		exit(EXIT_FAILURE);
+	}
+	if (strstr(buf, "DEVTYPE=disk")) {
+		/* Found it */
+		if (snprintf(finfo.dev_queue_read_ahead_path,
+			     sizeof(finfo.dev_queue_read_ahead_path),
+			     "/sys/dev/block/%d:%d/queue/read_ahead_kb",
+			     major(path_stat.st_dev), minor(path_stat.st_dev))
+		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
+			printf("%s: Pathname is too long\n", __func__);
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+	if (!strstr(buf, "DEVTYPE=partition")) {
+		printf("%s: Unknown device type: %s\n", __func__, path);
+		exit(EXIT_FAILURE);
+	}
+	/*
+	 * Partition of block device - need to find actual device.
+	 * Using naming convention that devnameN is partition of
+	 * device devname.
+	 */
+	str = strstr(buf, "DEVNAME=");
+	if (!str) {
+		printf("%s: Could not read: %s", __func__, path);
+		exit(EXIT_FAILURE);
+	}
+	str += 8;
+	end = str;
+	while (*end) {
+		if (isdigit(*end)) {
+			*end = '\0';
+			if (snprintf(finfo.dev_queue_read_ahead_path,
+				     sizeof(finfo.dev_queue_read_ahead_path),
+				     "/sys/block/%s/queue/read_ahead_kb",
+				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
+				printf("%s: Pathname is too long\n", __func__);
+				exit(EXIT_FAILURE);
+			}
+			return;
+		}
+		++end;
+	}
+	printf("%s: Could not read: %s\n", __func__, path);
+	exit(EXIT_FAILURE);
+}
+
 static bool check_swap(void *addr, unsigned long size)
 {
 	bool swap = false;
@@ -489,11 +637,91 @@ static bool anon_check_huge(void *addr,
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static struct mem_ops anon_ops = {
+static void *file_setup_area(int nr_hpages)
+{
+	int fd;
+	void *p;
+	unsigned long size;
+
+	unlink(finfo.path);  /* Cleanup from previous failed tests */
+	printf("Creating %s for collapse%s...", finfo.path,
+	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
+	fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
+		  777);
+	if (fd < 0) {
+		perror("open()");
+		exit(EXIT_FAILURE);
+	}
+
+	size = nr_hpages * hpage_pmd_size;
+	p = alloc_mapping(nr_hpages);
+	fill_memory(p, 0, size);
+	write(fd, p, size);
+	close(fd);
+	munmap(p, size);
+	success("OK");
+
+	printf("Opening %s read only for collapse...", finfo.path);
+	finfo.fd = open(finfo.path, O_RDONLY, 777);
+	if (finfo.fd < 0) {
+		perror("open()");
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
+		 MAP_PRIVATE, finfo.fd, 0);
+	if (p == MAP_FAILED || p != BASE_ADDR) {
+		perror("mmap()");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Drop page cache */
+	write_file("/proc/sys/vm/drop_caches", "3", 2);
+	success("OK");
+	return p;
+}
+
+static void file_cleanup_area(void *p, unsigned long size)
+{
+	munmap(p, size);
+	close(finfo.fd);
+	unlink(finfo.path);
+}
+
+static void file_fault(void *p, unsigned long start, unsigned long end)
+{
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
+		perror("madvise(MADV_POPULATE_READ");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static bool file_check_huge(void *addr, int nr_hpages)
+{
+	switch (finfo.type) {
+	case VMA_FILE:
+		return check_huge_file(addr, nr_hpages, hpage_pmd_size);
+	case VMA_SHMEM:
+		return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
+	default:
+		exit(EXIT_FAILURE);
+		return false;
+	}
+}
+
+static struct mem_ops __anon_ops = {
 	.setup_area = &anon_setup_area,
 	.cleanup_area = &anon_cleanup_area,
 	.fault = &anon_fault,
 	.check_huge = &anon_check_huge,
+	.name = "anon",
+};
+
+static struct mem_ops __file_ops = {
+	.setup_area = &file_setup_area,
+	.cleanup_area = &file_cleanup_area,
+	.fault = &file_fault,
+	.check_huge = &file_check_huge,
+	.name = "file",
 };
 
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
@@ -509,6 +737,7 @@ static void __madvise_collapse(const cha
 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
 	 */
 	settings.thp_enabled = THP_NEVER;
+	settings.shmem_enabled = SHMEM_NEVER;
 	push_settings(&settings);
 
 	/* Clear VM_NOHUGEPAGE */
@@ -580,12 +809,37 @@ static void khugepaged_collapse(const ch
 		return;
 	}
 
+	/*
+	 * For file and shmem memory, khugepaged only retracts pte entries after
+	 * putting the new hugepage in the page cache. The hugepage must be
+	 * subsequently refaulted to install the pmd mapping for the mm.
+	 */
+	if (ops != &__anon_ops)
+		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
+
 	if (ops->check_huge(p, expect ? nr_hpages : 0))
 		success("OK");
 	else
 		fail("Fail");
 }
 
+static struct collapse_context __khugepaged_context = {
+	.collapse = &khugepaged_collapse,
+	.enforce_pte_scan_limits = true,
+	.name = "khugepaged",
+};
+
+static struct collapse_context __madvise_context = {
+	.collapse = &madvise_collapse,
+	.enforce_pte_scan_limits = false,
+	.name = "madvise",
+};
+
+static bool is_tmpfs(struct mem_ops *ops)
+{
+	return ops == &__file_ops && finfo.type == VMA_SHMEM;
+}
+
 static void alloc_at_fault(void)
 {
 	struct settings settings = *current_settings();
@@ -658,6 +912,13 @@ static void collapse_max_ptes_none(struc
 
 	p = ops->setup_area(1);
 
+	if (is_tmpfs(ops)) {
+		/* shmem pages always in the page cache */
+		printf("tmpfs...");
+		skip("Skip");
+		goto skip;
+	}
+
 	ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
 	c->collapse("Maybe collapse with max_ptes_none exceeded", p, 1,
 		    ops, !c->enforce_pte_scan_limits);
@@ -670,6 +931,7 @@ static void collapse_max_ptes_none(struc
 		validate_memory(p, 0,
 				(hpage_pmd_nr - max_ptes_none) * page_size);
 	}
+skip:
 	ops->cleanup_area(p, hpage_pmd_size);
 	pop_settings();
 }
@@ -753,6 +1015,13 @@ static void collapse_single_pte_entry_co
 
 	p = alloc_hpage(ops);
 
+	if (is_tmpfs(ops)) {
+		/* MADV_DONTNEED won't evict tmpfs pages */
+		printf("tmpfs...");
+		skip("Skip");
+		goto skip;
+	}
+
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	printf("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
@@ -764,6 +1033,7 @@ static void collapse_single_pte_entry_co
 	c->collapse("Collapse PTE table with single PTE mapping compound page",
 		    p, 1, ops, true);
 	validate_memory(p, 0, page_size);
+skip:
 	ops->cleanup_area(p, hpage_pmd_size);
 }
 
@@ -1010,9 +1280,70 @@ static void madvise_collapse_existing_th
 	ops->cleanup_area(p, hpage_pmd_size);
 }
 
+static void usage(void)
+{
+	fprintf(stderr, "\nUsage: ./khugepaged <test type> [dir]\n\n");
+	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
+	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
+	fprintf(stderr, "\t<mem_type>\t: [all|anon|file]\n");
+	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
+	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
+	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
+	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
+	fprintf(stderr,	"\tmounted with huge=madvise option for khugepaged tests to work\n");
+	exit(1);
+}
+
+static void parse_test_type(int argc, const char **argv)
+{
+	char *buf;
+	const char *token;
+
+	if (argc == 1) {
+		/* Backwards compatibility */
+		khugepaged_context =  &__khugepaged_context;
+		madvise_context =  &__madvise_context;
+		anon_ops = &__anon_ops;
+		return;
+	}
+
+	buf = strdup(argv[1]);
+	token = strsep(&buf, ":");
+
+	if (!strcmp(token, "all")) {
+		khugepaged_context =  &__khugepaged_context;
+		madvise_context =  &__madvise_context;
+	} else if (!strcmp(token, "khugepaged")) {
+		khugepaged_context =  &__khugepaged_context;
+	} else if (!strcmp(token, "madvise")) {
+		madvise_context =  &__madvise_context;
+	} else {
+		usage();
+	}
+
+	if (!buf)
+		usage();
+
+	if (!strcmp(buf, "all")) {
+		file_ops =  &__file_ops;
+		anon_ops = &__anon_ops;
+	} else if (!strcmp(buf, "anon")) {
+		anon_ops = &__anon_ops;
+	} else if (!strcmp(buf, "file")) {
+		file_ops =  &__file_ops;
+	} else {
+		usage();
+	}
+
+	if (!file_ops)
+		return;
+
+	if (argc != 3)
+		usage();
+}
+
 int main(int argc, const char **argv)
 {
-	struct collapse_context c;
 	struct settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1023,8 +1354,20 @@ int main(int argc, const char **argv)
 			.alloc_sleep_millisecs = 10,
 			.scan_sleep_millisecs = 10,
 		},
+		/*
+		 * When testing file-backed memory, the collapse path
+		 * looks at how many pages are found in the page cache, not
+		 * what pages are mapped. Disable read ahead optimization so
+		 * pages don't find their way into the page cache unless
+		 * we mem_ops->fault() them in.
+		 */
+		.read_ahead_kb = 0,
 	};
-	const char *tests = argc == 1 ? "all" : argv[1];
+
+	parse_test_type(argc, argv);
+
+	if (file_ops)
+		get_finfo(argv[2]);
 
 	setbuf(stdout, NULL);
 
@@ -1042,43 +1385,61 @@ int main(int argc, const char **argv)
 
 	alloc_at_fault();
 
-	if (!strcmp(tests, "khugepaged") || !strcmp(tests, "all")) {
-		printf("\n*** Testing context: khugepaged ***\n");
-		c.collapse = &khugepaged_collapse;
-		c.enforce_pte_scan_limits = true;
-
-		collapse_full(&c, &anon_ops);
-		collapse_empty(&c, &anon_ops);
-		collapse_single_pte_entry(&c, &anon_ops);
-		collapse_max_ptes_none(&c, &anon_ops);
-		collapse_swapin_single_pte(&c, &anon_ops);
-		collapse_max_ptes_swap(&c, &anon_ops);
-		collapse_single_pte_entry_compound(&c, &anon_ops);
-		collapse_full_of_compound(&c, &anon_ops);
-		collapse_compound_extreme(&c, &anon_ops);
-		collapse_fork(&c, &anon_ops);
-		collapse_fork_compound(&c, &anon_ops);
-		collapse_max_ptes_shared(&c, &anon_ops);
-	}
-	if (!strcmp(tests, "madvise") || !strcmp(tests, "all")) {
-		printf("\n*** Testing context: madvise ***\n");
-		c.collapse = &madvise_collapse;
-		c.enforce_pte_scan_limits = false;
-
-		collapse_full(&c, &anon_ops);
-		collapse_empty(&c, &anon_ops);
-		collapse_single_pte_entry(&c, &anon_ops);
-		collapse_max_ptes_none(&c, &anon_ops);
-		collapse_swapin_single_pte(&c, &anon_ops);
-		collapse_max_ptes_swap(&c, &anon_ops);
-		collapse_single_pte_entry_compound(&c, &anon_ops);
-		collapse_full_of_compound(&c, &anon_ops);
-		collapse_compound_extreme(&c, &anon_ops);
-		collapse_fork(&c, &anon_ops);
-		collapse_fork_compound(&c, &anon_ops);
-		collapse_max_ptes_shared(&c, &anon_ops);
-		madvise_collapse_existing_thps(&c, &anon_ops);
-	}
+#define TEST(t, c, o) do { \
+	if (c && o) { \
+		printf("\nRun test: " #t " (%s:%s)\n", c->name, o->name); \
+		t(c, o); \
+	} \
+	} while (0)
+
+	TEST(collapse_full, khugepaged_context, anon_ops);
+	TEST(collapse_full, khugepaged_context, file_ops);
+	TEST(collapse_full, madvise_context, anon_ops);
+	TEST(collapse_full, madvise_context, file_ops);
+
+	TEST(collapse_empty, khugepaged_context, anon_ops);
+	TEST(collapse_empty, madvise_context, anon_ops);
+
+	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
+	TEST(collapse_single_pte_entry, madvise_context, file_ops);
+
+	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, file_ops);
+	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
+	TEST(collapse_max_ptes_none, madvise_context, file_ops);
+
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
+
+	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
+	TEST(collapse_full_of_compound, madvise_context, anon_ops);
+	TEST(collapse_full_of_compound, madvise_context, file_ops);
+
+	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
+	TEST(collapse_compound_extreme, madvise_context, anon_ops);
+
+	TEST(collapse_swapin_single_pte, khugepaged_context, anon_ops);
+	TEST(collapse_swapin_single_pte, madvise_context, anon_ops);
+
+	TEST(collapse_max_ptes_swap, khugepaged_context, anon_ops);
+	TEST(collapse_max_ptes_swap, madvise_context, anon_ops);
+
+	TEST(collapse_fork, khugepaged_context, anon_ops);
+	TEST(collapse_fork, madvise_context, anon_ops);
+
+	TEST(collapse_fork_compound, khugepaged_context, anon_ops);
+	TEST(collapse_fork_compound, madvise_context, anon_ops);
+
+	TEST(collapse_max_ptes_shared, khugepaged_context, anon_ops);
+	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
+
+	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
 
 	restore_settings(0);
 }
--- a/tools/testing/selftests/vm/vm_util.c~selftests-vm-add-thp-collapse-file-and-tmpfs-testing
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -114,3 +114,13 @@ bool check_huge_anon(void *addr, int nr_
 {
 	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
 }
+
+bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+}
+
+bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+}
--- a/tools/testing/selftests/vm/vm_util.h~selftests-vm-add-thp-collapse-file-and-tmpfs-testing
+++ a/tools/testing/selftests/vm/vm_util.h
@@ -8,3 +8,5 @@ void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
+bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
+bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

