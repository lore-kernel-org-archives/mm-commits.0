Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFFE3D1702
	for <mm-commits@vger.kernel.org>; Sun, 20 Sep 2026 23:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789948515; cv=none; b=AZ0U3L19mHTZ8EQMc7Rjtp2O285wIs8/Y3cbB2IAmytz9eEr/mb1MzkInPteUXIABR5LmMtMxU0FwLnYvtLUWXukep9lEEq0CSuBip8jFu2Igybjbbp7nvObSqh4QbQvatVRuGL5WxwPLfTvdnGkJTH5FpuD2fLAqpmp7bQ3x2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789948515; c=relaxed/simple;
	bh=J5MHCvvYZkDxr7J9wsPhC4geX23z+JkrN4calUkunfA=;
	h=Date:To:From:Subject:Message-Id; b=De1y8HY/3Y60rZ+zFoqDGoH38jbxQGD6tDJRs04HJMtf5orB4soYffBl4h94IWzXE4/Z4rjn9W3rc/ITfX71LPH2MXy5c+ybF2HL1wiYJn7QOvHEV2fNoPFV69/mA0JppFsq4mwCQMb0WrmNb6jT7KqmQH4Qe/RHfJSqgE9WbnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KZXN7Gyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KZXN7Gyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F4D1F000FF;
	Sun, 20 Sep 2026 23:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789948513;
	bh=4yt9NGAXWDjooGOVI4NLwyL8Bm5Ga62dh/+QkMH4h2E=;
	h=Date:To:From:Subject;
	b=KZXN7Gyb9BDl4jMPIzM9VIUcL31+M89LSuVRv3a1vJiPgNb1VifeSqfhcK46O3Do1
	 4MlIdIMGp/veqBBHxZRckNgp2PSChUpoHHOlfn7moC9XNWd+Qv9AwtAoXLoUiKnkgA
	 tyKu8p758SVym3ZRNiCPmW7uj7si0uAd8YUXwDDk=
Date: Sun, 20 Sep 2026 16:55:13 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-folio-order-detection-self-check.patch added to mm-new branch
Message-Id: <20260920235513.D0F4D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add folio-order detection self-check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-folio-order-detection-self-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-folio-order-detection-self-check.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: add folio-order detection self-check
Date: Sat, 19 Sep 2026 01:24:39 +0100

The khugepaged mTHP tests detect collapse results with the vm_util
folio-order helpers rather than smaps AnonHugePages, which only sees PMD
mappings.  If those helpers are wrong, every case built on them is wrong
the same way, and nothing says so.

Check them directly.  For every anon THP order the kernel supports, fault
memory in with only that order enabled.  Require the helpers to classify
the backing as exactly that order: not the order below it, and base-page
memory as order 0.

Run it in the thp category, ahead of ./khugepaged, so a broken helper is
reported as itself rather than as a collapse failure.  Verified on x86-64
4K (orders 0, 2-9) and arm64 64K (orders 0, 2-13).

The test needs ALIGN(), which hmm-tests.c and migration.c each defined
privately.  Move it to vm_util.h and drop both copies.

Assisted-by: LLM
Link: https://lore.kernel.org/20260919002451.496763-10-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/Makefile            |    1 
 tools/testing/selftests/mm/folio_order_check.c |  122 +++++++++++++++
 tools/testing/selftests/mm/hmm-tests.c         |    1 
 tools/testing/selftests/mm/migration.c         |    1 
 tools/testing/selftests/mm/run_vmtests.sh      |    2 
 tools/testing/selftests/mm/vm_util.h           |    2 
 6 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_order_check.c a/tools/testing/selftests/mm/folio_order_check.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/folio_order_check.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Self-check for the vm_util folio-order helpers, is_backed_by_folio() and
+ * is_range_backed_by_order(), which the khugepaged mTHP cases use to detect
+ * collapse results.  For every anon THP order the kernel supports, fault
+ * memory in with only that order enabled and require the helpers to report
+ * exactly that order.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include <mm/hugepage_settings.h>
+
+static int pagemap_fd;
+static int kpageflags_fd;
+
+static char *alloc_aligned(size_t size)
+{
+	size_t len = size * 2;
+	char *p, *aligned;
+
+	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_perror("mmap()");
+
+	aligned = (char *)ALIGN((uintptr_t)p, size);
+	if (aligned != p)
+		munmap(p, aligned - p);
+	if (aligned + size != p + len)
+		munmap(aligned + size, p + len - aligned - size);
+
+	return aligned;
+}
+
+static void check_order(int order)
+{
+	struct thp_settings settings = *thp_current_settings();
+	size_t size = psize() << order;
+	bool ok = true;
+	char *p;
+	int i;
+
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	if (order)
+		settings.hugepages[order].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+
+	p = alloc_aligned(size);
+	*p = 1;
+
+	if (!is_range_backed_by_order(p, size, order, pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d not detected after fault\n", order);
+		ok = false;
+	}
+
+	/* A lower order must be rejected: the folio is larger */
+	if (order && is_range_backed_by_order(p, size, order - 1,
+					      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order %d\n",
+			       order, order - 1);
+		ok = false;
+	}
+
+	/* A large folio must not pass as order 0 */
+	if (order && is_range_backed_by_order(p, size, 0,
+					      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order 0\n", order);
+		ok = false;
+	}
+
+	munmap(p, size);
+	thp_pop_settings();
+
+	ksft_test_result(ok, "order %d classified\n", order);
+}
+
+int main(void)
+{
+	struct thp_settings settings;
+	unsigned long orders;
+	int order;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open(/proc/self/pagemap)");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
+
+	orders = thp_supported_orders();
+	if (!orders)
+		ksft_exit_skip("No supported THP orders\n");
+
+	ksft_set_plan(__builtin_popcountl(orders) + 1);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	/* Base of the settings stack; the bottom entry is never popped */
+	thp_push_settings(&settings);
+
+	check_order(0);
+	for (order = 1; order < NR_ORDERS; order++) {
+		if (!(orders & (1UL << order)))
+			continue;
+		check_order(order);
+	}
+
+	ksft_finished();
+}
--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-add-folio-order-detection-self-check
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -65,7 +65,6 @@ enum {
 #define HMM_PATH_MAX    64
 #define NTIMES		10
 
-#define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 /* Just the flags we need, copied from mm.h: */
 
 #ifndef FOLL_WRITE
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-folio-order-detection-self-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
--- a/tools/testing/selftests/mm/migration.c~selftests-mm-add-folio-order-detection-self-check
+++ a/tools/testing/selftests/mm/migration.c
@@ -20,7 +20,6 @@
 
 #define TWOMEG		(2<<20)
 #define RUNTIME		(20)
-#define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-folio-order-detection-self-check
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -382,6 +382,8 @@ CATEGORY="pfnmap" run_test ./pfnmap
 # COW tests
 CATEGORY="cow" run_test ./cow
 
+CATEGORY="thp" run_test ./folio_order_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-folio-order-detection-self-check
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -12,6 +12,8 @@
 #include <mm/hugepage_settings.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
+#define ALIGN(x, a)                   (((x) + (a) - 1) & ~((a) - 1))
+
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
 #define PM_UFFD_WP                    BIT_ULL(57)
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

