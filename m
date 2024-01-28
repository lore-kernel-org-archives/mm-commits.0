Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC938BE0
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430768; cv=none; b=E85WbiRGi9DYi/bJTAEaYJpXQ5H+YB9bhXkPoDb59hjvlqnkfcRma8+lhkr2PVdF4PhOOUhItp4ss0GtJ+emewy/cQadUhcn8KjF+ZIoJHqiI1G0KIMy/5Z7PTQmujSp5PwVzCvqvWAM4Og95EvLTLmHBAdTX78qPb3ghMxows0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430768; c=relaxed/simple;
	bh=PWfolJZz9PuXnY7UeJlwVlZ2dHi0GdFA2sRP1jeUH+E=;
	h=Date:To:From:Subject:Message-Id; b=lm1H5HrgRYelZvLFWr9ni+Coxv3NStLWzy573JprvzrVJXf5SfS67SEJ3uYrEWYrGLyGTsaGHedmnMyfa8KktTJPvBZWa2OKJpygEwOMIE7BzmFA9I22wPPUBQEE8gDyZ5Qoeu0pQQpPVskYZfgjIv/wKsjxQyjQxInP241scs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyMNzk3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyMNzk3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE78C433F1;
	Sun, 28 Jan 2024 08:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430768;
	bh=PWfolJZz9PuXnY7UeJlwVlZ2dHi0GdFA2sRP1jeUH+E=;
	h=Date:To:From:Subject:From;
	b=gyMNzk3/2D44B67EsHOAxn9vURP9a0nVDtE9+RSJk5jFsHUm1V5c3hG36nX3mp3wh
	 Eg66cjRJZJ0tnYdM7IJ+iYkYZgXO6TmqQzNZLYsKSkmCcbtZbb94T44xobfVxofO/7
	 pXeNO8Q8eTN0H0dGb4StnXtFdJi06doFF8imT5aQ=
Date: Sun, 28 Jan 2024 00:32:44 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,jiaqiyan@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch added to mm-nonmm-unstable branch
Message-Id: <20240128083247.7CE78C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugepage-vmemmap: conform test to TAP format output
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: selftests/mm: hugepage-vmemmap: conform test to TAP format output
Date: Fri, 26 Jan 2024 16:21:21 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240126112129.1480265-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-vmemmap.c |   39 ++++++----------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-vmemmap.c~selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -11,6 +11,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
 #define PAGE_COMPOUND_TAIL	(1UL << 16)
@@ -77,7 +78,7 @@ static int check_page_flags(unsigned lon
 	read(fd, &pageflags, sizeof(pageflags));
 	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
 		close(fd);
-		printf("Head page flags (%lx) is invalid\n", pageflags);
+		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
 		return -1;
 	}
 
@@ -91,7 +92,7 @@ static int check_page_flags(unsigned lon
 		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
 		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
 			close(fd);
-			printf("Tail page flags (%lx) is invalid\n", pageflags);
+			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
 			return -1;
 		}
 	}
@@ -106,18 +107,17 @@ int main(int argc, char **argv)
 	void *addr;
 	unsigned long pfn;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	pagesize  = psize();
 	maplength = default_huge_page_size();
-	if (!maplength) {
-		printf("Unable to determine huge page size\n");
-		exit(1);
-	}
+	if (!maplength)
+		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
 	addr = mmap(MAP_ADDR, maplength, PROT_READ | PROT_WRITE, MAP_FLAGS, -1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
 	/* Trigger allocation of HugeTLB page. */
 	write_bytes(addr, maplength);
@@ -125,23 +125,16 @@ int main(int argc, char **argv)
 	pfn = virt_to_pfn(addr);
 	if (pfn == -1UL) {
 		munmap(addr, maplength);
-		perror("virt_to_pfn");
-		exit(1);
+		ksft_exit_fail_msg("virt_to_pfn: %s\n", strerror(errno));
 	}
 
-	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
+	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
 
-	if (check_page_flags(pfn) < 0) {
-		munmap(addr, maplength);
-		perror("check_page_flags");
-		exit(1);
-	}
+	ksft_test_result(!check_page_flags(pfn), "check_page_flags\n");
 
 	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, maplength)) {
-		perror("munmap");
-		exit(1);
-	}
+	if (munmap(addr, maplength))
+		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
 
-	return 0;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-ksm_tests-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

