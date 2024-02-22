Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D7A1C05
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560162; cv=none; b=Q4JJbwY8uObMxC+mu6PETeB1kjDVouVY7Vrss93XJHrawDPhJspscPZR0Y6n1UP/JXFuIWyyImZ/6A+Xjkr+a2cT6JN/V0Kis4Svcoqf0O7mJFfvTSYayY612rATEIocKvk01foaeO2hjTj6cnGIqz/rKzHFqpjXboMUdRiyrMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560162; c=relaxed/simple;
	bh=poDQJvMAlOg4/eN4yGQdDe90Cb+FwDtlfmmkn8E1BQk=;
	h=Date:To:From:Subject:Message-Id; b=kLxPOnZ++Td17an8f6a/ZOowDSk0UD2LmBUtTnZ1BjwElWiXwoJ8IIgri7D3iI5IiXKzXnj8IO3u+CaO3vasZvE2zYHXGjOnqOG58IcV2VINZXsts4zFea1J6BaEv5sJZVPYnRExBepudQ9DfgTyEAAdKof9MoJhzEVnti5tc9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0tw96FhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0tw96FhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C048C433C7;
	Thu, 22 Feb 2024 00:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560162;
	bh=poDQJvMAlOg4/eN4yGQdDe90Cb+FwDtlfmmkn8E1BQk=;
	h=Date:To:From:Subject:From;
	b=0tw96FhU2UmIYvpkbiKSlPOYMzRUK1MiArDncGLGPH0Sk/yI1Q1o9ADNAzZYCKRzq
	 y/QhPNsiTNvQua05IfAXmC8ULOZlstyEOXi73iPz7VBxWB4+K4S/ovZ/40x6sMuCGE
	 Dy7wH5nb44l2ic96eU7t75Q+JWNKxv2K2c2Jod3M=
Date: Wed, 21 Feb 2024 16:02:41 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-virtual_address_range-conform-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000242.1C048C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: conform to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-conform-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: virtual_address_range: conform to TAP format output
Date: Fri, 2 Feb 2024 16:31:19 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-13-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   44 +++++------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -12,6 +12,7 @@
 #include <errno.h>
 #include <sys/mman.h>
 #include <sys/time.h>
+#include "../kselftest.h"
 
 /*
  * Maximum address range mapped with a single mmap()
@@ -68,23 +69,15 @@ static char *hind_addr(void)
 	return (char *) (1UL << bits);
 }
 
-static int validate_addr(char *ptr, int high_addr)
+static void validate_addr(char *ptr, int high_addr)
 {
 	unsigned long addr = (unsigned long) ptr;
 
-	if (high_addr) {
-		if (addr < HIGH_ADDR_MARK) {
-			printf("Bad address %lx\n", addr);
-			return 1;
-		}
-		return 0;
-	}
+	if (high_addr && addr < HIGH_ADDR_MARK)
+		ksft_exit_fail_msg("Bad address %lx\n", addr);
 
-	if (addr > HIGH_ADDR_MARK) {
-		printf("Bad address %lx\n", addr);
-		return 1;
-	}
-	return 0;
+	if (addr > HIGH_ADDR_MARK)
+		ksft_exit_fail_msg("Bad address %lx\n", addr);
 }
 
 static int validate_lower_address_hint(void)
@@ -107,23 +100,29 @@ int main(int argc, char *argv[])
 	char *hint;
 	unsigned long i, lchunks, hchunks;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	for (i = 0; i < NR_CHUNKS_LOW; i++) {
 		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
 					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (ptr[i] == MAP_FAILED) {
-			if (validate_lower_address_hint())
-				return 1;
+			if (validate_lower_address_hint()) {
+				ksft_test_result_skip("Memory constraint not fulfilled\n");
+				ksft_finished();
+			}
 			break;
 		}
 
-		if (validate_addr(ptr[i], 0))
-			return 1;
+		validate_addr(ptr[i], 0);
 	}
 	lchunks = i;
 	hptr = (char **) calloc(NR_CHUNKS_HIGH, sizeof(char *));
-	if (hptr == NULL)
-		return 1;
+	if (hptr == NULL) {
+		ksft_test_result_skip("Memory constraint not fulfilled\n");
+		ksft_finished();
+	}
 
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hind_addr();
@@ -133,8 +132,7 @@ int main(int argc, char *argv[])
 		if (hptr[i] == MAP_FAILED)
 			break;
 
-		if (validate_addr(hptr[i], 1))
-			return 1;
+		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
 
@@ -145,5 +143,7 @@ int main(int argc, char *argv[])
 		munmap(hptr[i], MAP_CHUNK_SIZE);
 
 	free(hptr);
-	return 0;
+
+	ksft_test_result_pass("Test\n");
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

