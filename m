Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC0FC43462
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1684613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhEHWsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhEHWsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5966100C;
        Sat,  8 May 2021 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514038;
        bh=c8D8a4rGopFh0yVl+1XzQfImbUCD5DoVJOR4oyR7J8c=;
        h=Date:From:To:Subject:From;
        b=nS86EOc3rhaQp1YpElxZ9o8nv438HV6j2U/HRXH+SolGUEbUXDiVHo/eO9Gd6NDxu
         ZGtJ7oo65oD3CvawrhB0F6Mf9kfiYUFJ+nKK+xEhJa2sCEHTQYfl4l9v8kYyizdHB0
         QAnM3YwHocYv6rjsOIGZz63AKzTQOpDp17NkEL/c=
Date:   Sat, 08 May 2021 15:47:18 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mika.penttila@nextfour.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        sandipan@linux.ibm.com, shuah@kernel.org, shy828301@gmail.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-huge_memory-debugfs-for-file-backed-thp-split.patch removed from -mm
 tree
Message-ID: <20210508224718.Wl1VTxWKv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: debugfs for file-backed THP split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-debugfs-for-file-backed-thp-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: huge_memory: debugfs for file-backed THP split

Further extend <debugfs>/split_huge_pages to accept
"<path>,<pgoff_start>,<pgoff_end>" for file-backed THP split tests since
tmpfs may have file backed by THP that mapped nowhere.

Update selftest program to test file-backed THP split too.

Link: https://lkml.kernel.org/r/20210331235309.332292-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mika Penttila <mika.penttila@nextfour.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c                                  |   90 +++++++++++-
 tools/testing/selftests/vm/split_huge_page_test.c |   82 ++++++++++
 2 files changed, 166 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-debugfs-for-file-backed-thp-split
+++ a/mm/huge_memory.c
@@ -3050,6 +3050,65 @@ out:
 	return ret;
 }
 
+static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
+				pgoff_t off_end)
+{
+	struct filename *file;
+	struct file *candidate;
+	struct address_space *mapping;
+	int ret = -EINVAL;
+	pgoff_t index;
+	int nr_pages = 1;
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
+	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
+		 file_path, off_start, off_end);
+
+	mapping = candidate->f_mapping;
+
+	for (index = off_start; index < off_end; index += nr_pages) {
+		struct page *fpage = pagecache_get_page(mapping, index,
+						FGP_ENTRY | FGP_HEAD, 0);
+
+		nr_pages = 1;
+		if (xa_is_value(fpage) || !fpage)
+			continue;
+
+		if (!is_transparent_hugepage(fpage))
+			goto next;
+
+		total++;
+		nr_pages = thp_nr_pages(fpage);
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
@@ -3057,7 +3116,8 @@ static ssize_t split_huge_pages_write(st
 {
 	static DEFINE_MUTEX(split_debug_mutex);
 	ssize_t ret;
-	char input_buf[MAX_INPUT_BUF_SZ]; /* hold pid, start_vaddr, end_vaddr */
+	/* hold pid, start_vaddr, end_vaddr or file_path, off_start, off_end */
+	char input_buf[MAX_INPUT_BUF_SZ];
 	int pid;
 	unsigned long vaddr_start, vaddr_end;
 
@@ -3072,6 +3132,34 @@ static ssize_t split_huge_pages_write(st
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
@@ -300,6 +309,68 @@ void split_pte_mapped_thp(void)
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
+	uint64_t pgoff_start = 0, pgoff_end = 1024;
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
+	write_debugfs(PATH_FMT, testfile, pgoff_start, pgoff_end);
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
@@ -313,6 +384,7 @@ int main(int argc, char **argv)
 
 	split_pmd_thp();
 	split_pte_mapped_thp();
+	split_file_backed_thp();
 
 	return 0;
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are


