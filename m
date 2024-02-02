Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB6C123
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876020; cv=none; b=K50xWJLWvqScrkxmFR8o9ou22L/pSAAvtLD32b/YT2ziJqm6EIFyZ8CqIW/8UYHcggTi0y8Z1XsLGETCsWeOBb+Z5E/Voy7ZyErfx1ilGrAZLBvPQXv8nHHq4u6ocgo2yTpDLnyrgwM4mXkvw5TPKosUGYHGbIGwI5PODvZEgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876020; c=relaxed/simple;
	bh=HaTL5s6wlUgl/AlHi9JEb8PrgBGnl2SnFXGPW7SYzpQ=;
	h=Date:To:From:Subject:Message-Id; b=gcuVyEZaN2Mr8obNzAVf82HOLCZmfgbHfgHiJ1FUsZxbQK+PvF5AT1kZWW4UnQ0XZp7vZYrogmuZU3kdM5mQxwnb9wi465qIEqkAna7smXStWytGy7rG98l9PxQc0F6srqGpXVqtV+CgqJ1H+Jc3gyYwzhkqN63zhac/rH4D1jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xYr+MgbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xYr+MgbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F25C433F1;
	Fri,  2 Feb 2024 12:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876019;
	bh=HaTL5s6wlUgl/AlHi9JEb8PrgBGnl2SnFXGPW7SYzpQ=;
	h=Date:To:From:Subject:From;
	b=xYr+MgbT+7NP6ak/eoQW1ZC2HuLNzh2Fq4MHUCrKvwesEEAKf3dRjQ51KnCQxLHri
	 dDMf7+9ROQb0PMWayemgw+Hzf9p5n9qrExQU8y3LkB41YNgu1EGJ+eqrG4dxjMdkAg
	 PsYbMWm3fAUIeSwuOPuAmG4KZKiYBF/pklDPj3tM=
Date: Fri, 02 Feb 2024 04:13:37 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-transhuge-stress-conform-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240202121339.73F25C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: transhuge-stress: conform to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-transhuge-stress-conform-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-transhuge-stress-conform-to-tap-format-output.patch

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
Subject: selftests/mm: transhuge-stress: conform to TAP format output
Date: Wed, 31 Jan 2024 19:05:21 +0500

Conform the layout, informational and status messages to TAP. No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240131140528.320252-11-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/transhuge-stress.c |   38 +++++++++-------
 tools/testing/selftests/mm/vm_util.c          |    6 +-
 2 files changed, 26 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/transhuge-stress.c~selftests-mm-transhuge-stress-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -16,6 +16,7 @@
 #include <string.h>
 #include <sys/mman.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
@@ -34,6 +35,8 @@ int main(int argc, char **argv)
 	int pagemap_fd;
 	int duration = 0;
 
+	ksft_print_header();
+
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
@@ -43,7 +46,8 @@ int main(int argc, char **argv)
 
 	while (++i < argc) {
 		if (!strcmp(argv[i], "-h"))
-			errx(1, "usage: %s [-f <filename>] [-d <duration>] [size in MiB]", argv[0]);
+			ksft_exit_fail_msg("usage: %s [-f <filename>] [-d <duration>] [size in MiB]\n",
+					   argv[0]);
 		else if (!strcmp(argv[i], "-f"))
 			name = argv[++i];
 		else if (!strcmp(argv[i], "-d"))
@@ -52,10 +56,12 @@ int main(int argc, char **argv)
 			len = atoll(argv[i]) << 20;
 	}
 
+	ksft_set_plan(1);
+
 	if (name) {
 		backing_fd = open(name, O_RDWR);
 		if (backing_fd == -1)
-			errx(2, "open %s", name);
+			ksft_exit_fail_msg("open %s\n", name);
 		mmap_flags = MAP_SHARED;
 	}
 
@@ -65,21 +71,21 @@ int main(int argc, char **argv)
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
-		err(2, "open pagemap");
+		ksft_exit_fail_msg("open pagemap\n");
 
 	len -= len % HPAGE_SIZE;
 	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
 	if (ptr == MAP_FAILED)
-		err(2, "initial mmap");
+		ksft_exit_fail_msg("initial mmap");
 	ptr += HPAGE_SIZE - (uintptr_t)ptr % HPAGE_SIZE;
 
 	if (madvise(ptr, len, MADV_HUGEPAGE))
-		err(2, "MADV_HUGEPAGE");
+		ksft_exit_fail_msg("MADV_HUGEPAGE");
 
 	map_len = ram >> (HPAGE_SHIFT - 1);
 	map = malloc(map_len);
 	if (!map)
-		errx(2, "map malloc");
+		ksft_exit_fail_msg("map malloc\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
@@ -103,7 +109,7 @@ int main(int argc, char **argv)
 				if (idx >= map_len) {
 					map = realloc(map, idx + 1);
 					if (!map)
-						errx(2, "map realloc");
+						ksft_exit_fail_msg("map realloc\n");
 					memset(map + map_len, 0, idx + 1 - map_len);
 					map_len = idx + 1;
 				}
@@ -114,17 +120,19 @@ int main(int argc, char **argv)
 
 			/* split transhuge page, keep last page */
 			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
-				err(2, "MADV_DONTNEED");
+				ksft_exit_fail_msg("MADV_DONTNEED");
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
 		s = b.tv_sec - a.tv_sec + (b.tv_nsec - a.tv_nsec) / 1000000000.;
 
-		warnx("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
-		      "%4d succeed, %4d failed, %4d different pages",
-		      s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
-		      nr_succeed, nr_failed, nr_pages);
-
-		if (duration > 0 && b.tv_sec - start.tv_sec >= duration)
-			return 0;
+		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
+			       "%4d succeed, %4d failed, %4d different pages\n",
+			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
+			       nr_succeed, nr_failed, nr_pages);
+
+		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
+			ksft_test_result_pass("Completed\n");
+			ksft_finished();
+		}
 	}
 }
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-transhuge-stress-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -232,17 +232,17 @@ int64_t allocate_transhuge(void *ptr, in
 	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
 		 MAP_FIXED | MAP_ANONYMOUS |
 		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
-		errx(2, "mmap transhuge");
+		ksft_exit_fail_msg("mmap transhuge\n");
 
 	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
-		err(2, "MADV_HUGEPAGE");
+		ksft_exit_fail_msg("MADV_HUGEPAGE\n");
 
 	/* allocate transparent huge page */
 	*(volatile void **)ptr = ptr;
 
 	if (pread(pagemap_fd, ent, sizeof(ent),
 		  (uintptr_t)ptr >> (pshift() - 3)) != sizeof(ent))
-		err(2, "read pagemap");
+		ksft_exit_fail_msg("read pagemap\n");
 
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
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

