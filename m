Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFC214198B
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876017; cv=none; b=egB9z3bHV1I32DDNZwyxZe0tApq5AXEFskevOPt/LOVv1YIePzlVQ0AXTMgJQoGIGdIwKUP+7D3wUlH1i4XNjuVa2kjL7wd/Nei9QJb0awPanRdyeqb4YTAU1OkH+QP3uyd6R+vyFa0X+0ztmXfxnO7h4NwLL45iR1IUq48xjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876017; c=relaxed/simple;
	bh=UwaC9uWWTgiR+5BNyITOEUvfA0FiAoQOMI3cYNyj1LI=;
	h=Date:To:From:Subject:Message-Id; b=IRjZLuj9NXkup3TcnC07IVYWzz9F8oJNJd/+HWTGS2SX4mSNXWguR1+7z7qlb8AARzx5aCgwPkP4UoYc6oPF4pJXNxVOczx8MNh4Bu181i07OcKfJsqSrcAKvPVvJwqIuC8e2+PPGzRozRw4LqC/Yzcij4rjWGNi0fanuKJ324U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vUo641U0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vUo641U0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86090C433F1;
	Fri,  2 Feb 2024 12:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876016;
	bh=UwaC9uWWTgiR+5BNyITOEUvfA0FiAoQOMI3cYNyj1LI=;
	h=Date:To:From:Subject:From;
	b=vUo641U06rsRSjGsprgHprkACRiLRlC5OUxs6eDmsDC8hd3Zh0C+JvFKlO5uCsB1L
	 LGAEXT1fwLz9vOpQFN6+Ag1I9sqmsApZQxMUDi6kd48d7zhevTe+Hg7gMRWULgvUy9
	 S4Ho3O08geZB8tegTUR6vd8SZGysKlTweAmX8NDM=
Date: Fri, 02 Feb 2024 04:13:34 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-conform-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240202121336.86090C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: conform to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-conform-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-conform-to-tap-format-output.patch

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
Subject: selftests/mm: virtual_address_range: conform to TAP format output
Date: Wed, 31 Jan 2024 19:05:22 +0500

Conform the layout, informational and status messages to TAP. No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240131140528.320252-12-usama.anjum@collabora.com
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
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

