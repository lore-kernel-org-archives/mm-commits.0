Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F25C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51D4619DA
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhCaFdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233620AbhCaFdQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE527619D3;
        Wed, 31 Mar 2021 05:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617168796;
        bh=SxMvcrPgQiQkO3Z8yKRpLKRovRbWHARgmMCFj8IbK/A=;
        h=Date:From:To:Subject:From;
        b=vVmapCC1uFc5ML/icgjz1TB0QY+uPR5UDiqWszzzZnKSqgDkApEEt4MGfJe/C0I2p
         nuQtKbulwutn04q57yc+bXcbIQy7Dl4XvK9ZUZtayUNg6xlfhtYQ9eEJTObQoI9zYb
         NeTOkgBhNx3Jgu5tNBG+J87T2saHUyIjB6Fsq2gQ=
Date:   Tue, 30 Mar 2021 22:33:15 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mika.penttila@nextfour.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        sandipan@linux.ibm.com, shuah@kernel.org, shy828301@gmail.com,
        ziy@nvidia.com
Subject:  + mm-huge_memory-debugfs-for-file-backed-thp-split.patch
 added to -mm tree
Message-ID: <20210331053315.N3M8ugDQx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: debugfs for file-backed THP split
has been added to the -mm tree.  Its filename is
     mm-huge_memory-debugfs-for-file-backed-thp-split.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-debugfs-for-file-backed-thp-split.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-debugfs-for-file-backed-thp-split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: huge_memory: debugfs for file-backed THP split

Further extend <debugfs>/split_huge_pages to accept
"<path>,<off_start>,<off_end>" for file-backed THP split tests since tmpfs
may have file backed by THP that mapped nowhere.

Update selftest program to test file-backed THP split too.

Link: https://lkml.kernel.org/r/20210329153932.134510-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mika Penttila <mika.penttila@nextfour.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c                                  |   91 +++++++++++-
 tools/testing/selftests/vm/split_huge_page_test.c |   81 ++++++++++
 2 files changed, 166 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-debugfs-for-file-backed-thp-split
+++ a/mm/huge_memory.c
@@ -3062,6 +3062,66 @@ out:
 	return ret;
 }
 
+static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
+				pgoff_t off_end)
+{
+	struct filename *file;
+	struct file *candidate;
+	struct address_space *mapping;
+	int ret = -EINVAL;
+	pgoff_t off_cur;
+	unsigned long total = 0, split = 0;
+
+	file = getname_kernel(file_path);
+	if (IS_ERR(file))
+		return ret;
+
+	candidate = file_open_name(file, O_RDONLY, 0);
+	if (IS_ERR(candidate))
+		goto out;
+
+	pr_debug("split file-backed THPs in file: %s, offset: [0x%lx - 0x%lx]\n",
+		 file_path, off_start, off_end);
+
+	mapping = candidate->f_mapping;
+
+	for (off_cur = off_start; off_cur < off_end;) {
+		struct page *fpage = pagecache_get_page(mapping, off_cur,
+						FGP_ENTRY | FGP_HEAD, 0);
+
+		if (xa_is_value(fpage) || !fpage) {
+			off_cur += PAGE_SIZE;
+			continue;
+		}
+
+		if (!is_transparent_hugepage(fpage)) {
+			off_cur += PAGE_SIZE;
+			goto next;
+		}
+		total++;
+		off_cur = fpage->index + thp_size(fpage);
+
+		if (!trylock_page(fpage))
+			goto next;
+
+		if (!split_huge_page(fpage))
+			split++;
+
+		unlock_page(fpage);
+next:
+		put_page(fpage);
+		cond_resched();
+	}
+
+	filp_close(candidate, NULL);
+	ret = 0;
+
+	pr_debug("%lu of %lu file-backed THP split\n", split, total);
+out:
+	putname(file);
+	return ret;
+}
+
 #define MAX_INPUT_BUF_SZ 255
 
 static ssize_t split_huge_pages_write(struct file *file, const char __user *buf,
@@ -3069,7 +3129,8 @@ static ssize_t split_huge_pages_write(st
 {
 	static DEFINE_MUTEX(split_debug_mutex);
 	ssize_t ret;
-	char input_buf[MAX_INPUT_BUF_SZ]; /* hold pid, start_vaddr, end_vaddr */
+	/* hold pid, start_vaddr, end_vaddr or file_path, off_start, off_end */
+	char input_buf[MAX_INPUT_BUF_SZ];
 	int pid;
 	unsigned long vaddr_start, vaddr_end;
 
@@ -3084,6 +3145,34 @@ static ssize_t split_huge_pages_write(st
 		goto out;
 
 	input_buf[MAX_INPUT_BUF_SZ - 1] = '\0';
+
+	if (input_buf[0] == '/') {
+		char *tok;
+		char *buf = input_buf;
+		char file_path[MAX_INPUT_BUF_SZ];
+		pgoff_t off_start = 0, off_end = 0;
+		size_t input_len = strlen(input_buf);
+
+		tok = strsep(&buf, ",");
+		if (tok) {
+			strncpy(file_path, tok, MAX_INPUT_BUF_SZ);
+		} else {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = sscanf(buf, "0x%lx,0x%lx", &off_start, &off_end);
+		if (ret != 2) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = split_huge_pages_in_file(file_path, off_start, off_end);
+		if (!ret)
+			ret = input_len;
+
+		goto out;
+	}
+
 	ret = sscanf(input_buf, "%d,0x%lx,0x%lx", &pid, &vaddr_start, &vaddr_end);
 	if (ret == 1 && pid == 1) {
 		split_huge_pages_all();
--- a/tools/testing/selftests/vm/split_huge_page_test.c~mm-huge_memory-debugfs-for-file-backed-thp-split
+++ a/tools/testing/selftests/vm/split_huge_page_test.c
@@ -7,11 +7,13 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include <unistd.h>
 #include <inttypes.h>
 #include <string.h>
 #include <fcntl.h>
 #include <sys/mman.h>
+#include <sys/mount.h>
 #include <malloc.h>
 #include <stdbool.h>
 
@@ -24,6 +26,9 @@ uint64_t pmd_pagesize;
 #define SMAP_PATH "/proc/self/smaps"
 #define INPUT_MAX 80
 
+#define PID_FMT "%d,0x%lx,0x%lx"
+#define PATH_FMT "%s,0x%lx,0x%lx"
+
 #define PFN_MASK     ((1UL<<55)-1)
 #define KPF_THP      (1UL<<22)
 
@@ -87,13 +92,16 @@ static int write_file(const char *path,
 	return (unsigned int) numwritten;
 }
 
-static void write_debugfs(int pid, uint64_t vaddr_start, uint64_t vaddr_end)
+static void write_debugfs(const char *fmt, ...)
 {
 	char input[INPUT_MAX];
 	int ret;
+	va_list argp;
+
+	va_start(argp, fmt);
+	ret = vsnprintf(input, INPUT_MAX, fmt, argp);
+	va_end(argp);
 
-	ret = snprintf(input, INPUT_MAX, "%d,0x%lx,0x%lx", pid, vaddr_start,
-			vaddr_end);
 	if (ret >= INPUT_MAX) {
 		printf("%s: Debugfs input is too long\n", __func__);
 		exit(EXIT_FAILURE);
@@ -183,7 +191,8 @@ void split_pmd_thp(void)
 	}
 
 	/* split all THPs */
-	write_debugfs(getpid(), (uint64_t)one_page, (uint64_t)one_page + len);
+	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
+		(uint64_t)one_page + len);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)i) {
@@ -274,7 +283,7 @@ void split_pte_mapped_thp(void)
 	}
 
 	/* split all remapped THPs */
-	write_debugfs(getpid(), (uint64_t)pte_mapped,
+	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
 		      (uint64_t)pte_mapped + pagesize * 4);
 
 	/* smap does not show THPs after mremap, use kpageflags instead */
@@ -300,6 +309,67 @@ void split_pte_mapped_thp(void)
 	close(kpageflags_fd);
 }
 
+void split_file_backed_thp(void)
+{
+	int status;
+	int fd;
+	ssize_t num_written;
+	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
+	const char *tmpfs_loc = mkdtemp(tmpfs_template);
+	char testfile[INPUT_MAX];
+
+	printf("Please enable pr_debug in split_huge_pages_in_file() if you need more info.\n");
+
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+
+	if (status) {
+		printf("Unable to create a tmpfs for testing\n");
+		exit(EXIT_FAILURE);
+	}
+
+	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
+	if (status >= INPUT_MAX) {
+		printf("Fail to create file-backed THP split testing file\n");
+		goto cleanup;
+	}
+
+	fd = open(testfile, O_CREAT|O_WRONLY);
+	if (fd == -1) {
+		perror("Cannot open testing file\n");
+		goto cleanup;
+	}
+
+	/* write something to the file, so a file-backed THP can be allocated */
+	num_written = write(fd, tmpfs_loc, sizeof(tmpfs_loc));
+	close(fd);
+
+	if (num_written < 1) {
+		printf("Fail to write data to testing file\n");
+		goto cleanup;
+	}
+
+	/* split the file-backed THP */
+	write_debugfs(PATH_FMT, testfile, 0, 1024);
+
+	status = unlink(testfile);
+	if (status)
+		perror("Cannot remove testing file\n");
+
+cleanup:
+	status = umount(tmpfs_loc);
+	if (status) {
+		printf("Unable to umount %s\n", tmpfs_loc);
+		exit(EXIT_FAILURE);
+	}
+	status = rmdir(tmpfs_loc);
+	if (status) {
+		perror("cannot remove tmp dir");
+		exit(EXIT_FAILURE);
+	}
+
+	printf("file-backed THP split test done, please check dmesg for more information\n");
+}
+
 int main(int argc, char **argv)
 {
 	if (geteuid() != 0) {
@@ -313,6 +383,7 @@ int main(int argc, char **argv)
 
 	split_pmd_thp();
 	split_pte_mapped_thp();
+	split_file_backed_thp();
 
 	return 0;
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-a-new-debugfs-interface-for-splitting-thp-tests.patch
mm-huge_memory-debugfs-for-file-backed-thp-split.patch

