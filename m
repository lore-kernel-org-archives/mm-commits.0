Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE547C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377855AbiATV0w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377862AbiATV0s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED97C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BE160A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E9BC340E0;
        Thu, 20 Jan 2022 21:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714006;
        bh=S1yLIZbgXDPdDfgpOGzFft2SWOABIqHS8fIeoAfMY+Y=;
        h=Date:From:To:Subject:From;
        b=oDrXpqYN3vQ93jKSZdWUGynVNar0MV6uiaDJxG7s3RJ7avhEQxf94a/Zkr5emx3FZ
         nD/JKjRxTZTmSjt45tJp+VQz2C+fRTu07DasQfcBPIWQU6CC+qK2pxpFccasUGRb5s
         b8JUm/JbHtnLYmW1QZYrobhLIQv8EmNhPFhkVTwA=
Date:   Thu, 20 Jan 2022 13:26:46 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shuah@kernel.org, yosryahmed@google.com
Subject:  [merged]
 mm-hugepages-make-memory-size-variable-in-hugepage-mremap-selftest.patch
 removed from -mm tree
Message-ID: <20220120212646.fP6ZQFiJH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugepages: make memory size variable in hugepage-mremap selftest
has been removed from the -mm tree.  Its filename was
     mm-hugepages-make-memory-size-variable-in-hugepage-mremap-selftest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm, hugepages: make memory size variable in hugepage-mremap selftest

The hugetlb vma mremap() test currently maps 1GB of memory to trigger pmd
sharing and make sure that 'unshare' path in mremap code works.  The test
originally only mapped 10MB of memory (as specified by the header comment)
but was later modified to 1GB to tackle this case.

However, not all machines will have 1GB of memory to spare for this test. 
Adding a mapping size arg will allow run_vmtest.sh to pass an adequate
mapping size, while allowing users to run the test independently with
arbitrary size mappings.

Link: https://lkml.kernel.org/r/20211124203805.3700355-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |   46 +++++++++++------
 tools/testing/selftests/vm/run_vmtests.sh    |    2 
 2 files changed, 31 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-hugepages-make-memory-size-variable-in-hugepage-mremap-selftest
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -4,7 +4,11 @@
  *
  * Example of remapping huge page memory in a user application using the
  * mremap system call.  Code assumes a hugetlbfs filesystem is mounted
- * at './huge'.  The code will use 10MB worth of huge pages.
+ * at './huge'.  The amount of memory used by this test is decided by a command
+ * line argument in MBs. If missing, the default amount is 10MB.
+ *
+ * To make sure the test triggers pmd sharing and goes through the 'unshare'
+ * path in the mremap code use 1GB (1024) or more.
  */
 
 #define _GNU_SOURCE
@@ -18,8 +22,10 @@
 #include <linux/userfaultfd.h>
 #include <sys/ioctl.h>
 
-#define LENGTH (1UL * 1024 * 1024 * 1024)
+#define DEFAULT_LENGTH_MB 10UL
+#define MB_TO_BYTES(x) (x * 1024 * 1024)
 
+#define FILE_NAME "huge/hugepagefile"
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
 #define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
 
@@ -28,20 +34,20 @@ static void check_bytes(char *addr)
 	printf("First hex is %x\n", *((unsigned int *)addr));
 }
 
-static void write_bytes(char *addr)
+static void write_bytes(char *addr, size_t len)
 {
 	unsigned long i;
 
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < len; i++)
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr)
+static int read_bytes(char *addr, size_t len)
 {
 	unsigned long i;
 
 	check_bytes(addr);
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < len; i++)
 		if (*(addr + i) != (char)i) {
 			printf("Mismatch at %lu\n", i);
 			return 1;
@@ -99,11 +105,19 @@ static void register_region_with_uffd(ch
 	}
 }
 
-int main(void)
+int main(int argc, char *argv[])
 {
+	/* Read memory length as the first arg if valid, otherwise fallback to
+	 * the default length. Any additional args are ignored.
+	 */
+	size_t length = argc > 1 ? (size_t)atoi(argv[1]) : 0UL;
+
+	length = length > 0 ? length : DEFAULT_LENGTH_MB;
+	length = MB_TO_BYTES(length);
+
 	int ret = 0;
 
-	int fd = open("/huge/test", O_CREAT | O_RDWR, 0755);
+	int fd = open(FILE_NAME, O_CREAT | O_RDWR, 0755);
 
 	if (fd < 0) {
 		perror("Open failed");
@@ -112,7 +126,7 @@ int main(void)
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, LENGTH, PROTECTION,
+	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
 			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
 	printf("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED) {
@@ -122,7 +136,7 @@ int main(void)
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, LENGTH, PROTECTION,
+	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
 			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
 	printf("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED) {
@@ -132,16 +146,16 @@ int main(void)
 
 	suggested_addr = 0x7faa40000000;
 	void *vaddr =
-		mmap((void *)suggested_addr, LENGTH, PROTECTION, FLAGS, -1, 0);
+		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
 	printf("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED) {
 		perror("mmap2");
 		exit(1);
 	}
 
-	register_region_with_uffd(haddr, LENGTH);
+	register_region_with_uffd(haddr, length);
 
-	void *addr = mremap(haddr, LENGTH, LENGTH,
+	void *addr = mremap(haddr, length, length,
 			    MREMAP_MAYMOVE | MREMAP_FIXED, vaddr);
 	if (addr == MAP_FAILED) {
 		perror("mremap");
@@ -150,10 +164,10 @@ int main(void)
 
 	printf("Mremap: Returned address is %p\n", addr);
 	check_bytes(addr);
-	write_bytes(addr);
-	ret = read_bytes(addr);
+	write_bytes(addr, length);
+	ret = read_bytes(addr, length);
 
-	munmap(addr, LENGTH);
+	munmap(addr, length);
 
 	return ret;
 }
--- a/tools/testing/selftests/vm/run_vmtests.sh~mm-hugepages-make-memory-size-variable-in-hugepage-mremap-selftest
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -111,7 +111,7 @@ fi
 echo "-----------------------"
 echo "running hugepage-mremap"
 echo "-----------------------"
-./hugepage-mremap
+./hugepage-mremap 256
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=1
_

Patches currently in -mm which might be from yosryahmed@google.com are


