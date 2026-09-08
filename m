Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9BD396B9D
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897042; cv=none; b=tVJfgWrtGSjr/nxjrFKumDgUdpYYX+xcNrdDC+e7U+HUL2IbWnhhvlOt7Os0B78RCzx0nP5smANzgUwfy4gYri/vrRmqbJXdpCU9Zw4NFyQOeE/acAOeEdr07wkPWutexILXIOyxkoMqWTbbuJ2m4niaR2b24tFeoZ0JGCGpQ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897042; c=relaxed/simple;
	bh=mrd1RSRc3fh3ihaCFkuSiAFBQu0YubRP2oXqyIXKi54=;
	h=Date:To:From:Subject:Message-Id; b=W58QsiuKGneeVeHxrD0zyPQtiDpKLSzCIyzHP9xoXXt1i2KTSIG0ugP5cWCgrh/lrQIGO0MZ55ZqP/fI2o+ZiH6gZaXiBCWgy0H+356aPsBFNpCn5/UjLSOngkc56Koxuyuq5vKsqEqRnG9IYjcJzVEQJ1mtvoPUJ94ZG/9zlB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=awD6a93w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="awD6a93w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6651F00A3A;
	Tue,  8 Sep 2026 19:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897040;
	bh=1RqUc5bnfHV6XI1A2N8u6OULtIAleEF6mVNg/pTuJYo=;
	h=Date:To:From:Subject;
	b=awD6a93wGN2rtAv3L7VjUtggVjd+sZDcX6VK3lKGUD0z462PUrdq6IcPuRy7f5kiV
	 zSaHvANvoWK40/XAblEm54nxyJ+jzl3jwW3sic3AgwskQOA9nMKST4r8SpKXAELOAs
	 dn3qvyEsKlFRJxheUCUtv8uq0yw+BYEhiksQjbGI=
Date: Tue, 08 Sep 2026 12:50:39 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch added to mm-new branch
Message-Id: <20260908195040.2A6651F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check that one khugepaged pass collapses one window
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch

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
Subject: selftests/mm: check that one khugepaged pass collapses one window
Date: Tue, 8 Sep 2026 13:51:01 +0100

khugepaged_full_pass() drives the daemon through sysfs: a store to
scan_sleep_millisecs wakes it, and full_scans advancing by two marks one
pass that started after setup.  Every mTHP collapse result in the suite
rests on that pair, and nothing checks it.

Add khugepaged_sync_check.  Each step:

  - prepare one aligned window
  - record its source PFNs from pagemap
  - run one khugepaged_full_pass() barrier
  - require the window came out collapsed, with exactly one collapse
    attempt attributed to it

The anon events carry no virtual address, so an attempt is matched by the
source folio PFN and order that the mm_collapse_huge_page_isolate
tracepoint reports.

Reading the trace buffer takes four small helpers in vm_util: open an
event subsystem's enable file, flip it, clear the buffer, and open it for
reading.

scan_sleep_millisecs is set to a minute, so a step that took a sleep
instead of a wake would blow the budget.

Passes 5/5 on x86-64 4K and arm64 64K.

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-16-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                |    1 
 tools/testing/selftests/mm/khugepaged_sync_check.c |  179 +++++++++++
 tools/testing/selftests/mm/run_vmtests.sh          |    2 
 tools/testing/selftests/mm/vm_util.c               |   38 ++
 tools/testing/selftests/mm/vm_util.h               |    4 
 5 files changed, 224 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c a/tools/testing/selftests/mm/khugepaged_sync_check.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check that khugepaged_full_pass() drives khugepaged in step: one barrier
+ * over one prepared window must collapse it with exactly one collapse
+ * attempt attributed to its source pages, step after step.
+ *
+ * scan_sleep_millisecs is a minute so that a step which slept instead of
+ * being woken blows the budget.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+
+#define BASE_ADDR ((void *)(1UL << 30))
+/* Smallest order khugepaged considers */
+#define TARGET_ORDER 2
+#define NR_ITERATIONS 5
+#define PASS_TIMEOUT_S 30
+
+static int pagemap_fd;
+static int kpageflags_fd;
+static int trace_events_fd = -1;
+static unsigned long hpage_pmd_size;
+
+/*
+ * The events are system-wide: switch them off however the test ends,
+ * including from inside a helper that gives up.
+ */
+static void trace_events_off(void)
+{
+	if (trace_events_fd >= 0)
+		tracing_events_enable(trace_events_fd, false);
+}
+
+/* Count the isolate events whose scan_pfn is one of the window's source PFNs */
+static int count_attributed(unsigned long *pfns, int nr_pfns,
+			    unsigned int order)
+{
+	char line[1024];
+	int count = 0;
+	FILE *fp;
+
+	fp = tracing_open_trace();
+	if (!fp)
+		ksft_exit_fail_msg("Cannot open trace buffer\n");
+
+	while (fgets(line, sizeof(line), fp)) {
+		unsigned long val;
+		unsigned int ord;
+		char *s, *o;
+		int i;
+
+		s = strstr(line, "mm_collapse_huge_page_isolate:");
+		if (!s)
+			continue;
+		if (sscanf(s, "mm_collapse_huge_page_isolate: scan_pfn=0x%lx",
+			   &val) != 1)
+			continue;
+		o = strstr(s, "order=");
+		if (!o || sscanf(o, "order=%u", &ord) != 1 || ord != order)
+			continue;
+		for (i = 0; i < nr_pfns; i++) {
+			if (val == pfns[i]) {
+				count++;
+				break;
+			}
+		}
+	}
+	fclose(fp);
+	return count;
+}
+
+static void one_step(int iteration)
+{
+	const size_t window = getpagesize() << TARGET_ORDER;
+	const int nr_pages = 1 << TARGET_ORDER;
+	unsigned long pfns[1 << TARGET_ORDER];
+	bool collapsed, passed;
+	int attributed;
+	char *p;
+	int i;
+
+	p = mmap(BASE_ADDR, hpage_pmd_size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap() window");
+
+	for (i = 0; i < nr_pages; i++) {
+		p[i * getpagesize()] = i + 1;
+		pfns[i] = pagemap_get_pfn(pagemap_fd, p + i * getpagesize());
+		if (pfns[i] == -1UL)
+			ksft_exit_fail_msg("Source page not present\n");
+	}
+
+	/* Clear before enabling so the buffer holds only this step's events */
+	if (tracing_clear_trace())
+		ksft_exit_fail_msg("Cannot clear the trace buffer\n");
+	if (tracing_events_enable(trace_events_fd, true))
+		ksft_exit_fail_msg("Cannot enable huge_memory events\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	passed = khugepaged_full_pass(PASS_TIMEOUT_S);
+
+	/* Off before anything that can give up: the events are system-wide */
+	if (tracing_events_enable(trace_events_fd, false))
+		ksft_exit_fail_msg("Cannot disable huge_memory events\n");
+	if (!passed)
+		ksft_exit_fail_msg("khugepaged did not complete a full pass\n");
+
+	collapsed = is_range_backed_by_order(p, window, TARGET_ORDER,
+					     pagemap_fd, kpageflags_fd);
+	attributed = count_attributed(pfns, nr_pages, TARGET_ORDER);
+
+	ksft_test_result(collapsed && attributed == 1,
+			 "step %d: window collapsed, %d attributed result(s)\n",
+			 iteration, attributed);
+
+	munmap(p, hpage_pmd_size);
+}
+
+int main(void)
+{
+	struct thp_settings settings;
+	int i;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+	if (!(thp_supported_orders() & (1UL << TARGET_ORDER)))
+		ksft_exit_skip("Order %d is not a supported anon THP order\n",
+			       TARGET_ORDER);
+
+	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open(/proc/self/pagemap)");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
+	trace_events_fd = tracing_events_open("huge_memory");
+	if (trace_events_fd < 0)
+		ksft_exit_skip("huge_memory events require tracefs and root\n");
+	atexit(trace_events_off);
+
+	ksft_set_plan(NR_ITERATIONS);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	settings.thp_enabled = THP_MADVISE;
+	settings.thp_defrag = THP_DEFRAG_ALWAYS;
+	settings.khugepaged.defrag = 1;
+	settings.khugepaged.scan_sleep_millisecs = 60 * 1000;
+	settings.khugepaged.alloc_sleep_millisecs = 60 * 1000;
+	settings.khugepaged.max_ptes_none = (hpage_pmd_size / getpagesize()) - 1;
+	/* One wake must complete one full pass; see khugepaged_full_pass() */
+	settings.khugepaged.pages_to_scan = 1UL << 24;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[TARGET_ORDER].enabled = THP_INHERIT;
+	/* Base of the settings stack; the bottom entry is never popped */
+	thp_push_settings(&settings);
+
+	for (i = 0; i < NR_ITERATIONS; i++)
+		one_step(i);
+
+	ksft_finished();
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-check-that-one-khugepaged-pass-collapses-one-window
+++ a/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
+TEST_GEN_FILES += khugepaged_sync_check
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-check-that-one-khugepaged-pass-collapses-one-window
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -369,6 +369,8 @@ CATEGORY="cow" run_test ./cow
 
 CATEGORY="thp" run_test ./folio_order_check
 
+CATEGORY="thp" run_test ./khugepaged_sync_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-one-khugepaged-pass-collapses-one-window
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -599,6 +599,44 @@ bool is_range_backed_by_order(char *star
 	return true;
 }
 
+#define TRACEFS_ROOT "/sys/kernel/tracing"
+
+/*
+ * Returns -1 without tracefs or the subsystem.  The events are system-wide:
+ * whoever switches them on has to switch them off again, on every exit path.
+ */
+int tracing_events_open(const char *subsys)
+{
+	char path[256];
+
+	snprintf(path, sizeof(path), TRACEFS_ROOT "/events/%s/enable",
+		 subsys);
+	return open(path, O_WRONLY);
+}
+
+int tracing_events_enable(int fd, bool enable)
+{
+	if (pwrite(fd, enable ? "1" : "0", 1, 0) != 1)
+		return -1;
+	return 0;
+}
+
+/* Drop what the trace buffer holds so far */
+int tracing_clear_trace(void)
+{
+	int fd = open(TRACEFS_ROOT "/trace", O_WRONLY | O_TRUNC);
+
+	if (fd < 0)
+		return -1;
+	close(fd);
+	return 0;
+}
+
+FILE *tracing_open_trace(void)
+{
+	return fopen(TRACEFS_ROOT "/trace", "r");
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-check-that-one-khugepaged-pass-collapses-one-window
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -121,6 +121,10 @@ int close_procmap(struct procmap_fd *pro
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
 bool softdirty_supported(void);
+int tracing_events_open(const char *subsys);
+int tracing_events_enable(int fd, bool enable);
+int tracing_clear_trace(void);
+FILE *tracing_open_trace(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
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

