Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E624B3B6C00
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535231; cv=none; b=kCasKkKZbF8gaobnv8Y8AzgoObYkpjZ7wDbotFrNVTCtV0o7zn3WgCRZZoIOQJchVbEZczZtX6ym9GpclRSvGEOzje3RT/4MxroeHcftWN4KckkUY9Yfon4Bs/r0ooD/aXurrTgWmu7AU6xdQ6HY+3WFvrCJZWtSRiNhzVHZ5Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535231; c=relaxed/simple;
	bh=LNo19WKvHCcPpvOQ20Jrlg7SRJgNewXHkrb/YTDAGdE=;
	h=Date:To:From:Subject:Message-Id; b=YRtNte/eMFCjPNyb6IZm0MiytFYOMzoOePxhhAeCxdaTYChDt0RHBxWrUtEZusp5bQ88lsRpl47wV7eLAkk08O4zcyOQc9xhffi0S2JO+AEdzDqT4mA+ZZQOqmhGYy1d54ROgLUlLK6JQZ1D07TJrJ5ClbMi5qAjVvSCkxvyo1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yxHo1Qsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yxHo1Qsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C9EC2BCB0;
	Mon, 11 May 2026 21:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535230;
	bh=LNo19WKvHCcPpvOQ20Jrlg7SRJgNewXHkrb/YTDAGdE=;
	h=Date:To:From:Subject:From;
	b=yxHo1QsqMsAvK5oL37cKG4ppS+Wzi5OA2z8wc4aWX91/dCAFcqW5WmRBeqxFc5/45
	 67YAmNHB1K7PA05mL7aBr8sIEGpyvga2l9V9RlmbB9EIuldl5qYqT6G1jDkudFJBz+
	 xyZY9jftdrGbxQzz65lXDqmb/yf/I+jZI8cK6ypI=
Date: Mon, 11 May 2026 14:33:50 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch added to mm-new branch
Message-Id: <20260511213350.84C9EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: merge map_hugetlb into hugepage-mmap
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: merge map_hugetlb into hugepage-mmap
Date: Mon, 11 May 2026 19:27:50 +0300

Both tests create a hugettlb mapping, fill it with data and verify the
data, the only difference is that one uses file-backed memory and another
one uses anonymous memory.

Merge both tests into a single file.

Link: https://lore.kernel.org/20260511162840.375890-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |    7 -
 tools/testing/selftests/mm/Makefile          |    1 
 tools/testing/selftests/mm/hugepage-mmap.c   |  107 +++++++++++++----
 tools/testing/selftests/mm/map_hugetlb.c     |   88 -------------
 tools/testing/selftests/mm/run_vmtests.sh    |    1 
 5 files changed, 84 insertions(+), 120 deletions(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~selftests-mm-merge-map_hugetlb-into-hugepage-mmap
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -455,7 +455,7 @@ used to change the file attributes on hu
 Also, it is important to note that no such mount command is required if
 applications are going to use only shmat/shmget system calls or mmap with
 MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
-:ref:`map_hugetlb <map_hugetlb>` below.
+:ref:`examples <examples>` below.
 
 Users who wish to use hugetlb memory via shared memory segment should be
 members of a supplementary group and system admin needs to configure that gid
@@ -473,10 +473,7 @@ a hugetlb page and the length is smaller
 Examples
 ========
 
-.. _map_hugetlb:
-
-``map_hugetlb``
-	see tools/testing/selftests/mm/map_hugetlb.c
+.. _examples:
 
 ``hugepage-shm``
 	see tools/testing/selftests/mm/hugepage-shm.c
--- a/tools/testing/selftests/mm/hugepage-mmap.c~selftests-mm-merge-map_hugetlb-into-hugepage-mmap
+++ a/tools/testing/selftests/mm/hugepage-mmap.c
@@ -15,6 +15,8 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include <linux/memfd.h>
+#include "vm_util.h"
 #include "kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
@@ -25,54 +27,109 @@ static void check_bytes(char *addr)
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
-static void write_bytes(char *addr)
+static void write_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr)
+static bool verify_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
 	check_bytes(addr);
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		if (*(addr + i) != (char)i) {
-			ksft_print_msg("Error: Mismatch at %lu\n", i);
-			return 1;
+			ksft_print_msg("Error: Mismatch at %lu(%p)\n", i, addr);
+			return false;
 		}
-	return 0;
+
+	return true;
 }
 
-int main(void)
+static void test_mmap(size_t length, int mmap_flags, int fd,
+		      const char *test_name)
 {
+	bool passed = true;
 	void *addr;
-	int fd, ret;
 
-	ksft_print_header();
-	ksft_set_plan(1);
+	addr = mmap(NULL, length, PROTECTION, mmap_flags, fd, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+
+	ksft_print_msg("Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr, length);
+	if (!verify_bytes(addr, length))
+		passed = false;
+
+	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
+	if (munmap(addr, length))
+		ksft_exit_fail_perror("munmap");
+
+	ksft_test_result(passed, "%s\n", test_name);
+}
 
-	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
+static void test_anon_mmap(size_t length, int shift)
+{
+	const char *test_name = "hugetlb anonymous mmap";
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+
+	if (shift)
+		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
+
+	test_mmap(length, mmap_flags, -1, test_name);
+}
+
+static void test_file_mmap(size_t length, int shift)
+{
+	const char *test_name = "hugetlb file mmap";
+	int mfd_flags = MFD_HUGETLB;
+	int fd;
+
+	if (shift)
+		mfd_flags |= (shift & MFD_HUGE_MASK) << MFD_HUGE_SHIFT;
+
+	fd = memfd_create("hugetlb-mmap", mfd_flags);
 	if (fd < 0)
-		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
+		ksft_exit_fail_perror("memfd_create");
+
+	test_mmap(length, MAP_SHARED, fd, test_name);
+	close(fd);
+}
+
+int main(int argc, char **argv)
+{
+	size_t hugepage_size;
+	size_t length = LENGTH;
+	int shift = 0;
+
+	ksft_print_header();
+	ksft_set_plan(2);
 
-	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED) {
-		close(fd);
-		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
+	if (argc > 1)
+		length = atol(argv[1]) << 20;
+	if (argc > 2)
+		shift = atoi(argv[2]);
+
+	if (shift) {
+		hugepage_size = (1UL << shift);
+		ksft_print_msg("%lu kB hugepages\n", 1UL << (shift - 10));
+	} else {
+		hugepage_size = default_huge_page_size();
+		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
 	}
 
-	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr);
-	ret = read_bytes(addr);
+	/* munmap will fail if the length is not page aligned */
+	if (hugepage_size > length)
+		length = hugepage_size;
 
-	munmap(addr, LENGTH);
-	close(fd);
+	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
-	ksft_test_result(!ret, "Read same data\n");
+	test_anon_mmap(length, shift);
+	test_file_mmap(length, shift);
 
-	ksft_exit(!ret);
+	ksft_finished();
 }
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-merge-map_hugetlb-into-hugepage-mmap
+++ a/tools/testing/selftests/mm/Makefile
@@ -70,7 +70,6 @@ TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
-TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
 ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
 TEST_GEN_FILES += memfd_secret
diff --git a/tools/testing/selftests/mm/map_hugetlb.c a/tools/testing/selftests/mm/map_hugetlb.c
deleted file mode 100644
--- a/tools/testing/selftests/mm/map_hugetlb.c
+++ /dev/null
@@ -1,88 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Example of using hugepage memory in a user application using the mmap
- * system call with MAP_HUGETLB flag.  Before running this program make
- * sure the administrator has allocated enough default sized huge pages
- * to cover the 256 MB allocation.
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-#include "vm_util.h"
-#include "kselftest.h"
-
-#define LENGTH (256UL*1024*1024)
-#define PROTECTION (PROT_READ | PROT_WRITE)
-
-static void check_bytes(char *addr)
-{
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-}
-
-static void write_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	for (i = 0; i < length; i++)
-		*(addr + i) = (char)i;
-}
-
-static void read_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	check_bytes(addr);
-	for (i = 0; i < length; i++)
-		if (*(addr + i) != (char)i)
-			ksft_exit_fail_msg("Mismatch at %lu\n", i);
-
-	ksft_test_result_pass("Read correct data\n");
-}
-
-int main(int argc, char **argv)
-{
-	void *addr;
-	size_t hugepage_size;
-	size_t length = LENGTH;
-	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
-	int shift = 0;
-
-	hugepage_size = default_huge_page_size();
-	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
-
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (argc > 1)
-		length = atol(argv[1]) << 20;
-	if (argc > 2) {
-		shift = atoi(argv[2]);
-		if (shift)
-			flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
-	}
-
-	if (shift)
-		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
-	else
-		ksft_print_msg("Default size hugepages\n");
-	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
-
-	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr, length);
-	read_bytes(addr, length);
-
-	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, length))
-		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
-
-	ksft_finished();
-}
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-merge-map_hugetlb-into-hugepage-mmap
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -292,7 +292,6 @@ CATEGORY="hugetlb" run_test ./hugepage-s
 echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
-CATEGORY="hugetlb" run_test ./map_hugetlb
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

