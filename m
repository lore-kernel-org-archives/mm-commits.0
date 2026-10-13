Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB6F48595D
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866034; cv=none; b=PwxzarhfXnqLror8q9j8+H5MGBxg3mYeVuaizKaY48Zcupwq8vSRJm6XnKgZ1Bqb01gltp6xpB0rXdXMeS45jdaA4wNM5US18HNOyZp5sGwy9wUx2cyf9YUSJCOkbmol/gdcLzRp3R4N51J6AiZRkUrjk1l0DG8cOZd21Bj/NOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866034; c=relaxed/simple;
	bh=sCdLT2dqzjVIwz7nWSVDs6TbXNg9V5EARIinsVcrqZI=;
	h=Date:To:From:Subject:Message-Id; b=YU+PCLspzHx7i/s6W3B3IJWLNmOWDBnONCOVjZ2VniOh2fbSMdihosCe9EB7GoymdntATURiWW3zQKtJU/cd7CpKmnjHGmotVXbnDOf/Hftqg14KCRMEvNN3/SN5K/w0pG9B+HTIDAXaz0aGIDVasHVGjwPAggCAdVYsBYeRw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZ3u7cXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZ3u7cXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBAD1F0089B;
	Tue, 13 Oct 2026 04:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866026;
	bh=kaTnhhKBiirbM+VyR4HT8OKEAetg4uBu0tYFZl/Fcow=;
	h=Date:To:From:Subject;
	b=eZ3u7cXWW7L7Sa4Id/kuJk/1/o+PYEuAds4Oa96HkpTNj1XcOTuBpjVnHWH9Frkzo
	 TWhg/x3mQ+kl7ZxvSMZeYscnslsbypGyfIyShiYtxsV2N8j3cQtMMxmip9mSniiuoS
	 M8kl/0i09NpQiS0JsIuUPepofg8W/z81qCGRnX2U=
Date: Mon, 12 Oct 2026 21:33:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-folio-order-detection-self-check.patch removed from -mm tree
Message-Id: <20261013043346.5BBAD1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add folio-order detection self-check
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-folio-order-detection-self-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260919002451.496763-10-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
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

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

