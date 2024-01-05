Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808BC3588D
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03KujQex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1844C433C7;
	Fri,  5 Jan 2024 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478731;
	bh=PY9U5VzL2mLTYmaJGQ/WOmPRWoonFHwU6GrmNsbQgio=;
	h=Date:To:From:Subject:From;
	b=03KujQex8Oawfm2G9eBFjIofz8n73ps1L+rwvRwfk0sP71E2U0AeIiq7LrkqHeQ+v
	 hZuSjIes6l65YIPrgsaWAzU9Rec8EapvffeoPGhQ9S2Ij0uyFIhe2neGhwyb/oPMvc
	 dQxvWGROPi5lF0AT9tiLSBzMsqlWWlqS8tXi4Xso=
Date: Fri, 05 Jan 2024 10:18:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-selftests-hugepage-mremap-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240105181850.E1844C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/selftests: hugepage-mremap: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     mm-selftests-hugepage-mremap-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: mm/selftests: hugepage-mremap: conform test to TAP format output
Date: Tue, 2 Jan 2024 13:19:18 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240102081919.2325570-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mremap.c |   87 ++++++-----------
 1 file changed, 35 insertions(+), 52 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~mm-selftests-hugepage-mremap-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -24,6 +24,7 @@
 #include <sys/ioctl.h>
 #include <string.h>
 #include <stdbool.h>
+#include "../kselftest.h"
 #include "vm_util.h"
 
 #define DEFAULT_LENGTH_MB 10UL
@@ -34,7 +35,7 @@
 
 static void check_bytes(char *addr)
 {
-	printf("First hex is %x\n", *((unsigned int *)addr));
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
 static void write_bytes(char *addr, size_t len)
@@ -52,7 +53,7 @@ static int read_bytes(char *addr, size_t
 	check_bytes(addr);
 	for (i = 0; i < len; i++)
 		if (*(addr + i) != (char)i) {
-			printf("Mismatch at %lu\n", i);
+			ksft_print_msg("Mismatch at %lu\n", i);
 			return 1;
 		}
 	return 0;
@@ -66,17 +67,13 @@ static void register_region_with_uffd(ch
 	/* Create and enable userfaultfd object. */
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	if (uffd == -1) {
-		perror("userfaultfd");
-		exit(1);
-	}
+	if (uffd == -1)
+		ksft_exit_fail_msg("userfaultfd: %s\n", strerror(errno));
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = 0;
-	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1) {
-		perror("ioctl-UFFDIO_API");
-		exit(1);
-	}
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
+		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
 
 	/* Create a private anonymous mapping. The memory will be
 	 * demand-zero paged--that is, not yet allocated. When we
@@ -86,21 +83,17 @@ static void register_region_with_uffd(ch
 
 	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
 		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
-	printf("Address returned by mmap() = %p\n", addr);
+	ksft_print_msg("Address returned by mmap() = %p\n", addr);
 
 	/* Register the memory range of the mapping we just created for
 	 * handling by the userfaultfd object. In mode, we request to track
 	 * missing pages (i.e., pages that have not yet been faulted in).
 	 */
-	if (uffd_register(uffd, addr, len, true, false, false)) {
-		perror("ioctl-UFFDIO_REGISTER");
-		exit(1);
-	}
+	if (uffd_register(uffd, addr, len, true, false, false))
+		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
 }
 
 int main(int argc, char *argv[])
@@ -108,10 +101,11 @@ int main(int argc, char *argv[])
 	size_t length = 0;
 	int ret = 0, fd;
 
-	if (argc >= 2 && !strcmp(argv[1], "-h")) {
-		printf("Usage: %s [length_in_MB]\n", argv[0]);
-		exit(1);
-	}
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	if (argc >= 2 && !strcmp(argv[1], "-h"))
+		ksft_exit_fail_msg("Usage: %s [length_in_MB]\n", argv[0]);
 
 	/* Read memory length as the first arg if valid, otherwise fallback to
 	 * the default length.
@@ -123,50 +117,40 @@ int main(int argc, char *argv[])
 
 	length = MB_TO_BYTES(length);
 	fd = memfd_create(argv[0], MFD_HUGETLB);
-	if (fd < 0) {
-		perror("Open failed");
-		exit(1);
-	}
+	if (fd < 0)
+		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
 	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
 			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
-	printf("Map haddr: Returned address is %p\n", haddr);
-	if (haddr == MAP_FAILED) {
-		perror("mmap1");
-		exit(1);
-	}
+	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
+	if (haddr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
 	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
 			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
-	printf("Map daddr: Returned address is %p\n", daddr);
-	if (daddr == MAP_FAILED) {
-		perror("mmap3");
-		exit(1);
-	}
+	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
+	if (daddr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
 	void *vaddr =
 		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
-	printf("Map vaddr: Returned address is %p\n", vaddr);
-	if (vaddr == MAP_FAILED) {
-		perror("mmap2");
-		exit(1);
-	}
+	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
+	if (vaddr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
 
 	register_region_with_uffd(haddr, length);
 
 	void *addr = mremap(haddr, length, length,
 			    MREMAP_MAYMOVE | MREMAP_FIXED, vaddr);
-	if (addr == MAP_FAILED) {
-		perror("mremap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mremap: %s\n", strerror(errno));
 
-	printf("Mremap: Returned address is %p\n", addr);
+	ksft_print_msg("Mremap: Returned address is %p\n", addr);
 	check_bytes(addr);
 	write_bytes(addr, length);
 	ret = read_bytes(addr, length);
@@ -174,12 +158,11 @@ int main(int argc, char *argv[])
 	munmap(addr, length);
 
 	addr = mremap(addr, length, length, 0);
-	if (addr != MAP_FAILED) {
-		printf("mremap: Expected failure, but call succeeded\n");
-		exit(1);
-	}
+	if (addr != MAP_FAILED)
+		ksft_exit_fail_msg("mremap: Expected failure, but call succeeded\n");
 
 	close(fd);
 
-	return ret;
+	ksft_test_result(!ret, "Read same data\n");
+	ksft_exit(!ret);
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


