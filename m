Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BBEB656
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713208846; cv=none; b=ukze0YkrLSjVE7p07SKx7i3vsLXVnDulWkX8M4rQpINL2VgCirjBqCpr34HOVf4UKvJRZIkowl4ySRmdp2OKJ3N6XFHWmTILhNLEB9RDXzIIVo0J/Y6jUBijHJtr/QGqL8EPiTKTA09hTdH5iKewP8ymGk+sTQurnyeUhBEAp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713208846; c=relaxed/simple;
	bh=msS4z3kUrd7W6T0ZXXemVTYiz0embZjxR2bW+D7Xz2g=;
	h=Date:To:From:Subject:Message-Id; b=pfEhQ4uD6ls0CeK/DilQKtTHRuvK800J+fCj3Ccmaf6ziu1hRsjyiJ+4aBYN1vZiHoFqCHL19ykIFAF71IGuWA5C5pa8qhS7/cf+R9wUS/U5AEfnneNINAQkfFeTD8f1Ggzlqd6l9eSvCmbmEmwfLGjWTGmwoguMpofTbCBxS1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jsCCNdsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsCCNdsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F91C2BD11;
	Mon, 15 Apr 2024 19:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713208846;
	bh=msS4z3kUrd7W6T0ZXXemVTYiz0embZjxR2bW+D7Xz2g=;
	h=Date:To:From:Subject:From;
	b=jsCCNdskEEMYvMShRm3mBVX+FoCnX/H4QXgZZHXiTiI3BvP18U+WpvE3YahVxCliv
	 /vvagHF/P8a9Tbu/+NYU2Lew0BWRymI3mKbD9vTs/DB0fkHGePhiJmke9OyAJlbdwK
	 YfFMxmWISQ8otbN2k6+jpzTxQZBwTS71F4ofCh5A=
Date: Mon, 15 Apr 2024 12:20:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,torvalds@linux-foundation.org,surenb@google.com,sroettger@google.com,pedro.falcato@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jorgelo@chromium.org,jeffxu@google.com,jannh@google.com,groeck@chromium.org,gregkh@linuxfoundation.org,dave.hansen@intel.com,corbet@lwn.net,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-mseal-read-only-elf-memory-segment.patch added to mm-unstable branch
Message-Id: <20240415192046.22F91C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest mm/mseal read-only elf memory segment
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-mseal-read-only-elf-memory-segment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-mseal-read-only-elf-memory-segment.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest mm/mseal read-only elf memory segment
Date: Mon, 15 Apr 2024 16:35:24 +0000

Sealing read-only of elf mapping so it can't be changed by mprotect.

Link: https://lkml.kernel.org/r/20240415163527.626541-6-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 
 tools/testing/selftests/mm/Makefile   |    1 
 tools/testing/selftests/mm/seal_elf.c |  183 ++++++++++++++++++++++++
 3 files changed, 185 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftest-mm-mseal-read-only-elf-memory-segment
+++ a/tools/testing/selftests/mm/.gitignore
@@ -48,3 +48,4 @@ va_high_addr_switch
 hugetlb_fault_after_madv
 hugetlb_madv_vs_map
 mseal_test
+seal_elf
--- a/tools/testing/selftests/mm/Makefile~selftest-mm-mseal-read-only-elf-memory-segment
+++ a/tools/testing/selftests/mm/Makefile
@@ -60,6 +60,7 @@ TEST_GEN_FILES += mrelease_test
 TEST_GEN_FILES += mremap_dontunmap
 TEST_GEN_FILES += mremap_test
 TEST_GEN_FILES += mseal_test
+TEST_GEN_FILES += seal_elf
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += thuge-gen
--- /dev/null
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <sys/mman.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <stdbool.h>
+#include "../kselftest.h"
+#include <syscall.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <fcntl.h>
+#include <assert.h>
+#include <sys/ioctl.h>
+#include <sys/vfs.h>
+#include <sys/stat.h>
+
+/*
+ * need those definition for manually build using gcc.
+ * gcc -I ../../../../usr/include   -DDEBUG -O3  -DDEBUG -O3 seal_elf.c -o seal_elf
+ */
+#define FAIL_TEST_IF_FALSE(c) do {\
+		if (!(c)) {\
+			ksft_test_result_fail("%s, line:%d\n", __func__, __LINE__);\
+			goto test_end;\
+		} \
+	} \
+	while (0)
+
+#define SKIP_TEST_IF_FALSE(c) do {\
+		if (!(c)) {\
+			ksft_test_result_skip("%s, line:%d\n", __func__, __LINE__);\
+			goto test_end;\
+		} \
+	} \
+	while (0)
+
+
+#define TEST_END_CHECK() {\
+		ksft_test_result_pass("%s\n", __func__);\
+		return;\
+test_end:\
+		return;\
+}
+
+#ifndef u64
+#define u64 unsigned long long
+#endif
+
+/*
+ * define sys_xyx to call syscall directly.
+ */
+static int sys_mseal(void *start, size_t len)
+{
+	int sret;
+
+	errno = 0;
+	sret = syscall(__NR_mseal, start, len, 0);
+	return sret;
+}
+
+static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
+	unsigned long flags, unsigned long fd, unsigned long offset)
+{
+	void *sret;
+
+	errno = 0;
+	sret = (void *) syscall(__NR_mmap, addr, len, prot,
+		flags, fd, offset);
+	return sret;
+}
+
+inline int sys_mprotect(void *ptr, size_t size, unsigned long prot)
+{
+	int sret;
+
+	errno = 0;
+	sret = syscall(__NR_mprotect, ptr, size, prot);
+	return sret;
+}
+
+static bool seal_support(void)
+{
+	int ret;
+	void *ptr;
+	unsigned long page_size = getpagesize();
+
+	ptr = sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (ptr == (void *) -1)
+		return false;
+
+	ret = sys_mseal(ptr, page_size);
+	if (ret < 0)
+		return false;
+
+	return true;
+}
+
+const char somestr[4096] = {"READONLY"};
+
+static void test_seal_elf(void)
+{
+	int ret;
+	FILE *maps;
+	char line[512];
+	int size = 0;
+	uintptr_t  addr_start, addr_end;
+	char prot[5];
+	char filename[256];
+	unsigned long page_size = getpagesize();
+	unsigned long long ptr = (unsigned long long) somestr;
+	char *somestr2 = (char *)somestr;
+
+	/*
+	 * Modify the protection of readonly somestr
+	 */
+	if (((unsigned long long)ptr % page_size) != 0)
+		ptr = (unsigned long long)ptr & ~(page_size - 1);
+
+	ksft_print_msg("somestr = %s\n", somestr);
+	ksft_print_msg("change protection to rw\n");
+	ret = sys_mprotect((void *)ptr, page_size, PROT_READ|PROT_WRITE);
+	FAIL_TEST_IF_FALSE(!ret);
+	*somestr2 = 'A';
+	ksft_print_msg("somestr is modified to: %s\n", somestr);
+	ret = sys_mprotect((void *)ptr, page_size, PROT_READ);
+	FAIL_TEST_IF_FALSE(!ret);
+
+	maps = fopen("/proc/self/maps", "r");
+	FAIL_TEST_IF_FALSE(maps);
+
+	/*
+	 * apply sealing to elf binary
+	 */
+	while (fgets(line, sizeof(line), maps)) {
+		if (sscanf(line, "%lx-%lx %4s %*x %*x:%*x %*u %255[^\n]",
+			&addr_start, &addr_end, &prot, &filename) == 4) {
+			if (strlen(filename)) {
+				/*
+				 * seal the mapping if read only.
+				 */
+				if (strstr(prot, "r-")) {
+					ret = sys_mseal((void *)addr_start, addr_end - addr_start);
+					FAIL_TEST_IF_FALSE(!ret);
+					ksft_print_msg("sealed: %lx-%lx %s %s\n",
+						addr_start, addr_end, prot, filename);
+					if ((uintptr_t) somestr >= addr_start &&
+						(uintptr_t) somestr <= addr_end)
+						ksft_print_msg("mapping for somestr found\n");
+				}
+			}
+		}
+	}
+	fclose(maps);
+
+	ret = sys_mprotect((void *)ptr, page_size, PROT_READ | PROT_WRITE);
+	FAIL_TEST_IF_FALSE(ret < 0);
+	ksft_print_msg("somestr is sealed, mprotect is rejected\n");
+
+	TEST_END_CHECK();
+}
+
+int main(int argc, char **argv)
+{
+	bool test_seal = seal_support();
+
+	ksft_print_header();
+	ksft_print_msg("pid=%d\n", getpid());
+
+	if (!test_seal)
+		ksft_exit_skip("sealing not supported, check CONFIG_64BIT\n");
+
+	ksft_set_plan(1);
+
+	test_seal_elf();
+
+	ksft_finished();
+	return 0;
+}
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-wire-up-mseal-syscall.patch
mseal-add-mseal-syscall.patch
selftest-mm-mseal-memory-sealing.patch
mseal-add-documentation.patch
selftest-mm-mseal-read-only-elf-memory-segment.patch

