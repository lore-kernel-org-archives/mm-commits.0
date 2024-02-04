Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7D4B66F
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031248; cv=none; b=ZOP4w5q2ZNSsKVephCsrF/gSjp1sWZZtHqQbFQ8uQUHUKVimzgydBGmVwTRJjFjy1ZSJFJOIKJ4T1rvnU8WtcH7dzIorPjn7wCv4zq5rz5l3o0MYRdx1lQYXkopaL6zguSJcJlJYndxliEQh8TrYh9khkEijSggWe3ohduNF548=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031248; c=relaxed/simple;
	bh=s+rg6etT6dogcNMuXhRFvFq6Vn1goA/10N9Ggz2dSzU=;
	h=Date:To:From:Subject:Message-Id; b=jRXuKsqQ8Xn1ao3pqxJ9/r5r4nCt4YCdEic73uWAm4ZrbYLhjW+1F7UHAPTBxAkWMFHSi1Takqku8C2UYstK/jM+23iOC7kLCY8DQ2pJ8DvCACplXzP5NopmQjPmJfjeaZFDa8TIKYmrfhllcBtaVOjEt2U8ejGEDmazERD7xNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hsrruuhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hsrruuhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5253BC433F1;
	Sun,  4 Feb 2024 07:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031248;
	bh=s+rg6etT6dogcNMuXhRFvFq6Vn1goA/10N9Ggz2dSzU=;
	h=Date:To:From:Subject:From;
	b=hsrruuhxf3tDnjcnFp6PAhwzMdODnPH9p2naGJ9oM8Er59+DeQCP4bvn9U916+B+s
	 RE69R3xC5JabDEy4nAvcyaXq7G3m+cjSxdHG6zyXWTYtbUWCWgOfUtzzJo7yy9k1Yx
	 ssjM3eqPKDvkUTeKx1JMkSj0vg7e6NgtXQ9db0zo=
Date: Sat, 03 Feb 2024 23:20:47 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240204072048.5253BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: map_hugetlb: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: map_hugetlb: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:09 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_hugetlb.c |   42 ++++++++++-----------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/map_hugetlb.c~selftests-mm-map_hugetlb-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/map_hugetlb.c
@@ -16,6 +16,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -31,7 +32,7 @@
 
 static void check_bytes(char *addr)
 {
-	printf("First hex is %x\n", *((unsigned int *)addr));
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
 static void write_bytes(char *addr, size_t length)
@@ -42,23 +43,21 @@ static void write_bytes(char *addr, size
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr, size_t length)
+static void read_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
 	check_bytes(addr);
 	for (i = 0; i < length; i++)
-		if (*(addr + i) != (char)i) {
-			printf("Mismatch at %lu\n", i);
-			return 1;
-		}
-	return 0;
+		if (*(addr + i) != (char)i)
+			ksft_exit_fail_msg("Mismatch at %lu\n", i);
+
+	ksft_test_result_pass("Read correct data\n");
 }
 
 int main(int argc, char **argv)
 {
 	void *addr;
-	int ret;
 	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
@@ -69,6 +68,9 @@ int main(int argc, char **argv)
 	if (hugepage_size > length)
 		length = hugepage_size;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {
@@ -78,27 +80,23 @@ int main(int argc, char **argv)
 	}
 
 	if (shift)
-		printf("%u kB hugepages\n", 1 << (shift - 10));
+		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
 	else
-		printf("Default size hugepages\n");
-	printf("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
+		ksft_print_msg("Default size hugepages\n");
+	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	addr = mmap(ADDR, length, PROTECTION, flags, -1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
-	printf("Returned address is %p\n", addr);
+	ksft_print_msg("Returned address is %p\n", addr);
 	check_bytes(addr);
 	write_bytes(addr, length);
-	ret = read_bytes(addr, length);
+	read_bytes(addr, length);
 
 	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, length)) {
-		perror("munmap");
-		exit(1);
-	}
+	if (munmap(addr, length))
+		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
 
-	return ret;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

