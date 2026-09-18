Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8482E5B2A
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 19:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761115; cv=none; b=oigDT50LVaNbJKGixUX9S4bxMA6rmpi55a0cA7Ui7+h6hxBOwjfjrkOCmNDUEDkoy1mP6V/y1ONSdA9KnfLD+rEXTiZu3oLy3jw7dpb2Haqp3kYEYXTTnkWkwnv9Z4yvK4OhRpcA+japXyYEyp8cN+d+F0D8p2Ahml5lwrB3zqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761115; c=relaxed/simple;
	bh=4Bs68Xxol9m6Jb1H6dDzEtwqdsS+p4RmdEHq3CEc+Tw=;
	h=Date:To:From:Subject:Message-Id; b=AJ2MHknys5P3nROzmLnYnerQNagEnF/ut9orjZ7gJyJ44Y/OB99QBAIg/kBSX1HU/Btclz3PDQT0bEZaW4PGZ2UHlyAckYuXPwtod7jLHk9/ETbOivL4pt1XP+goFjoFNHsHNy2H7sIdQ0eckvoYiY6AWD2dii2K72c74PRZuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wA5jnyXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wA5jnyXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAC21F000FF;
	Fri, 18 Sep 2026 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789761113;
	bh=WAue+rCOkwU+HiPt8M3s0lF5ZB5YcfKJMfOF9iSyNZc=;
	h=Date:To:From:Subject;
	b=wA5jnyXxP1X/jTFy6IWxNGUJHz42lD3bPzU7Hn9+6KNxWkUGLr53tJ+EIAp6tcgnV
	 anGWY49hzwcb2eGWAB8ezj/pAD252HuMBJBl3pxP4qX8Sr2BB54D9+FRVdGHvGrXth
	 7/mGtAuso1fIkMp2W30gAC6qeYKwrzussan1Gdu0=
Date: Fri, 18 Sep 2026 12:51:52 -0700
To: mm-commits@vger.kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-gup-selftest.patch added to mm-new branch
Message-Id: <20260918195153.0EAC21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add a GUP selftest
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-a-gup-selftest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-gup-selftest.patch

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
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: selftests/mm: add a GUP selftest
Date: Fri, 18 Sep 2026 16:52:34 +0530

Add a new GUP selftest which uses kselftest_harness.h.  Cover 12 mapping
configurations: THP enabled, THP disabled and HugeTLB, each across
private/shared mappings and with/without FOLL_WRITE.  Run 5 test cases for
every variant: get_user_pages, get_user_pages_fast, pin_user_pages,
pin_user_pages_fast and pin_user_pages_longterm.

Use two default hugeTLB pages and derive the mapping size from their size.
This exercises GUP both within a single HugeTLB page and across a HugeTLB
boundary, without reserving an excessive number of pages.

Sweep four nr_pages_per_call values for each test: 1, 512, 123 and all
pages.  This preserves the coverage previously provided by
run_gup_matrix(): 12 mapping combinations x 5 GUP/PUP operations x 4 batch
sizes.  In total the selftest reports 60 TAP cases and issues 240 ioctls.

Do not carry DUMP_USER_PAGES_TEST into the new selftest because its output
is written to the kernel log and the selftest does not verify that output.

Add the new gup binary to the selftests/mm build, run_vmtests.sh and
MAINTAINERS.  Update mm/Kconfig to describe the benchmark and selftest
split.

Link: https://lore.kernel.org/20260918112234.195857-7-sarthak.sharma@arm.com
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 MAINTAINERS                               |    1 
 mm/Kconfig                                |   19 -
 tools/testing/selftests/mm/Makefile       |    1 
 tools/testing/selftests/mm/gup.c          |  262 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |    1 
 5 files changed, 272 insertions(+), 12 deletions(-)

--- a/MAINTAINERS~selftests-mm-add-a-gup-selftest
+++ a/MAINTAINERS
@@ -17188,6 +17188,7 @@ F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
 F:	tools/mm/gup_bench.c
+F:	tools/testing/selftests/mm/gup.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
--- a/mm/Kconfig~selftests-mm-add-a-gup-selftest
+++ a/mm/Kconfig
@@ -1292,24 +1292,19 @@ config PERCPU_STATS
 	  be used to help understand percpu memory usage.
 
 config GUP_TEST
-	bool "Enable infrastructure for get_user_pages()-related unit tests"
+	bool "Enable infrastructure for get_user_pages()-related unit tests and benchmarks"
 	depends on DEBUG_FS
 	help
 	  Provides /sys/kernel/debug/gup_test, which in turn provides a way
-	  to make ioctl calls that can launch kernel-based unit tests for
-	  the get_user_pages*() and pin_user_pages*() family of API calls.
+	  to make ioctl calls that can launch kernel-based unit tests and
+	  benchmarks for the get_user_pages*() and pin_user_pages*() families
+	  of API calls.
 
-	  These tests include benchmark testing of the _fast variants of
-	  get_user_pages*() and pin_user_pages*(), as well as smoke tests of
+	  These include benchmark testing of the _fast variants of
+	  get_user_pages*() and pin_user_pages*(), as well as tests of
 	  the non-_fast variants.
 
-	  There is also a sub-test that allows running dump_page() on any
-	  of up to eight pages (selected by command line args) within the
-	  range of user-space addresses. These pages are either pinned via
-	  pin_user_pages*(), or pinned via get_user_pages*(), as specified
-	  by other command line arguments.
-
-	  See tools/testing/selftests/mm/gup_test.c
+	  See tools/testing/selftests/mm/gup.c and tools/mm/gup_bench.c.
 
 comment "GUP_TEST needs to have DEBUG_FS enabled"
 	depends on !GUP_TEST && !DEBUG_FS
diff --git a/tools/testing/selftests/mm/gup.c a/tools/testing/selftests/mm/gup.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/gup.c
@@ -0,0 +1,262 @@
+// SPDX-License-Identifier: GPL-2.0
+#define __SANE_USERSPACE_TYPES__ // Use ll64
+#include <fcntl.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <dirent.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <mm/gup_test.h>
+#include "vm_util.h"
+#include "kselftest_harness.h"
+
+#define MB (1UL << 20)
+
+/* Just the flags we need, copied from the kernel internals. */
+#define FOLL_WRITE	0x01	/* check pte is writable */
+
+/* Page counts exercising single, THP-batch, partial, and full-mapping GUP. */
+static const int nr_pages_list[] = { 1, 512, 123, -1 };
+
+#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
+#define NR_HUGETLB_PAGES 2
+
+static unsigned long hp_size;
+
+FIXTURE(gup_test)
+{
+	int gup_fd;
+	char *addr;
+	unsigned long size;
+};
+
+FIXTURE_VARIANT(gup_test)
+{
+	bool thp;
+	bool hugetlb;
+	bool write;
+	bool shared;
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = true,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_read)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = false,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = true,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_read_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = false,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = true,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_read_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = false,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_write)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_read)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_write_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_read_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_write_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_read_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_SETUP(gup_test)
+{
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	char *p;
+
+	self->size = 128 * MB;
+
+	if (variant->hugetlb) {
+		if (!hp_size)
+			SKIP(return, "HugeTLB not available\n");
+
+		if (hugetlb_free_default_pages() < NR_HUGETLB_PAGES)
+			SKIP(return, "Not enough huge pages\n");
+
+		self->size = NR_HUGETLB_PAGES * hp_size;
+		mmap_flags |= MAP_HUGETLB;
+	}
+
+	if (variant->shared)
+		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
+
+	/* gup_fd has to be >= 0. Already checked in main() */
+	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	ASSERT_GE(self->gup_fd, 0);
+
+	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
+			  mmap_flags, -1, 0);
+
+	ASSERT_NE(self->addr, MAP_FAILED) {
+		int err = errno;
+
+		close(self->gup_fd);
+		TH_LOG("mmap failed: %s", strerror(err));
+	}
+
+	if (variant->thp)
+		madvise(self->addr, self->size, MADV_HUGEPAGE);
+	else if (!variant->hugetlb)
+		madvise(self->addr, self->size, MADV_NOHUGEPAGE);
+
+	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
+			+ self->size; p += psize())
+		p[0] = 0;
+}
+
+FIXTURE_TEARDOWN(gup_test)
+{
+	munmap(self->addr, self->size);
+	close(self->gup_fd);
+}
+
+static void run_gup_cmd(struct __test_metadata *_metadata,
+		FIXTURE_DATA(gup_test) *self,
+		const FIXTURE_VARIANT(gup_test) *variant,
+		unsigned long command)
+{
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = {
+			.addr = (unsigned long)self->addr,
+			.size = self->size,
+			.nr_pages_per_call = nr_pages_list[i] < 0 ?
+				self->size / psize() : nr_pages_list[i],
+			.gup_flags = variant->write ? FOLL_WRITE : 0,
+		};
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, command, &gup), 0);
+		ASSERT_EQ(gup.size, self->size);
+	}
+}
+
+TEST_F(gup_test, get_user_pages)
+{
+	run_gup_cmd(_metadata, self, variant, GUP_BASIC_TEST);
+}
+
+TEST_F(gup_test, pin_user_pages)
+{
+	run_gup_cmd(_metadata, self, variant, PIN_BASIC_TEST);
+}
+
+TEST_F(gup_test, get_user_pages_fast)
+{
+	run_gup_cmd(_metadata, self, variant, GUP_FAST_BENCHMARK);
+}
+
+TEST_F(gup_test, pin_user_pages_fast)
+{
+	run_gup_cmd(_metadata, self, variant, PIN_FAST_BENCHMARK);
+}
+
+TEST_F(gup_test, pin_user_pages_longterm)
+{
+	run_gup_cmd(_metadata, self, variant, PIN_LONGTERM_BENCHMARK);
+}
+
+int main(int argc, char **argv)
+{
+	const int fd = open(GUP_TEST_FILE, O_RDWR);
+
+	if (fd == -1) {
+		ksft_print_header();
+		if (errno == EACCES)
+			ksft_exit_skip("Please run this test as root\n");
+		if (errno == ENOENT) {
+			DIR *debugfs = opendir("/sys/kernel/debug");
+
+			if (!debugfs)
+				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
+			closedir(debugfs);
+			ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
+		}
+		ksft_exit_fail_msg("Failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
+	}
+	close(fd);
+
+	hp_size = default_huge_page_size();
+	if (hp_size)
+		hugetlb_setup_default(NR_HUGETLB_PAGES);
+
+	return test_harness_run(argc, argv);
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-a-gup-selftest
+++ a/tools/testing/selftests/mm/Makefile
@@ -58,6 +58,7 @@ endif
 
 TEST_GEN_FILES = cow
 TEST_GEN_FILES += compaction_test
+TEST_GEN_FILES += gup
 TEST_GEN_FILES += gup_longterm
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-a-gup-selftest
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -269,6 +269,7 @@ fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
 
+CATEGORY="gup_test" run_test ./gup
 CATEGORY="gup_test" run_test ./gup_longterm
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

mm-gup_test-report-actual-pinned-bytes.patch
mm-gup_test-safely-calculate-gup-batch-size.patch
selftests-mm-make-file-helpers-return-errors.patch
selftests-mm-make-file-helpers-return-errors-fix.patch
tools-lib-mm-add-shared-file-helpers.patch
tools-lib-mm-move-hugepage_settings-out-of-selftests.patch
tools-mm-move-gup_test-from-selftests-mm-to-tools-mm.patch
tools-mm-make-gup_bench-a-benchmark-only-tool.patch
selftests-mm-add-a-gup-selftest.patch

