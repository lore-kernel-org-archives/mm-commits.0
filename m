Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06B0C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66546619D7
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhCaFbP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCaFbG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F61619D8;
        Wed, 31 Mar 2021 05:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617168666;
        bh=RTrJgVCa2TyHXoNK9znxEP6ezcFnywntKrnZOA4z9Us=;
        h=Date:From:To:Subject:From;
        b=evpIxv3n+ySZh0oUAljPrHe/0Dfq/ZMwM5iNX9YFx+fgZQ0k6qhhnrSWXfL7P68Js
         bGmOKu0RMeib+D1XBprCi/T48hK1meU5zRBclGaxk3I2O0Vcg6yMKpK/gheItp5y4M
         ov37KvJpVueL7koKGwoYXzclQrtOiyjEQXhHnwMM=
Date:   Tue, 30 Mar 2021 22:31:05 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mika.penttila@nextfour.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        sandipan@linux.ibm.com, shuah@kernel.org, shy828301@gmail.com,
        ziy@nvidia.com
Subject:  [to-be-updated]
 mm-huge_memory-debugfs-for-file-backed-thp-split.patch removed from -mm
 tree
Message-ID: <20210331053105.kaUF9mDB1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: debugfs for file-backed THP split.
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-debugfs-for-file-backed-thp-split.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: huge_memory: debugfs for file-backed THP split.

Further extend <debugfs>/split_huge_pages to accept
"<path>,<off_start>,<off_end>" for file-backed THP split tests since tmpfs
may have file backed by THP that mapped nowhere.

Update selftest program to test file-backed THP split too.

Link: https://lkml.kernel.org/r/20210319005219.13595-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mika Penttila <mika.penttila@nextfour.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/split_huge_page_test.c |   79 +++++++++++-
 1 file changed, 74 insertions(+), 5 deletions(-)

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
@@ -300,6 +309,65 @@ void split_pte_mapped_thp(void)
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
@@ -313,6 +381,7 @@ int main(int argc, char **argv)
 
 	split_pmd_thp();
 	split_pte_mapped_thp();
+	split_file_backed_thp();
 
 	return 0;
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are


