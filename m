Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F68BC77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDLUCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLUC1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ACE4217
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A647362E18
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2B7C433D2;
        Wed, 12 Apr 2023 20:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329744;
        bh=wPVqha6DbIwymuYi2MQjVJk1HGJIKEH37MthRtWbB8Y=;
        h=Date:To:From:Subject:From;
        b=SiZ1d3Le0t1Y6oMI1Bk5eO2yzwxjL86xsYHm26EVUHNJ2TcF7S5JW+Fm0zBxqC3B1
         lTahsYDGgbuZcf2Ev413WycTUycE8B/PBi1XMhMFEgq+aZf5RdUo47ez/jPtkYJ+xx
         LjjCXyfITr9A+BB0Hi6o0oRXbidY03PYMVX/PWAk=
Date:   Wed, 12 Apr 2023 13:02:23 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-merge-utilh-into-vm_utilh.patch added to mm-unstable branch
Message-Id: <20230412200224.0D2B7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: merge util.h into vm_util.h
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-merge-utilh-into-vm_utilh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-merge-utilh-into-vm_utilh.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: merge util.h into vm_util.h
Date: Wed, 12 Apr 2023 12:41:20 -0400

There're two util headers under mm/ kselftest.  Merge one with another. 
It turns out util.h is the easy one to move.

When merging, drop PAGE_SIZE / PAGE_SHIFT because they're unnecessary
wrappers to page_size() / page_shift(), meanwhile rename them to psize()
and pshift() so as to not conflict with some existing definitions in some
test files that includes vm_util.h.

Link: https://lkml.kernel.org/r/20230412164120.327731-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile           |    4 
 tools/testing/selftests/mm/gup_test.c         |    5 -
 tools/testing/selftests/mm/ksm_tests.c        |    2 
 tools/testing/selftests/mm/mrelease_test.c    |   11 +-
 tools/testing/selftests/mm/transhuge-stress.c |   12 +-
 tools/testing/selftests/mm/util.h             |   69 ----------------
 tools/testing/selftests/mm/vm_util.c          |   31 +++++++
 tools/testing/selftests/mm/vm_util.h          |   31 +++++++
 8 files changed, 80 insertions(+), 85 deletions(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -12,8 +12,7 @@
 #include <assert.h>
 #include <mm/gup_test.h>
 #include "../kselftest.h"
-
-#include "util.h"
+#include "vm_util.h"
 
 #define MB (1UL << 20)
 
@@ -251,7 +250,7 @@ int main(int argc, char **argv)
 	if (touch) {
 		gup.gup_flags |= FOLL_TOUCH;
 	} else {
-		for (; (unsigned long)p < gup.addr + size; p += PAGE_SIZE)
+		for (; (unsigned long)p < gup.addr + size; p += psize())
 			p[0] = 0;
 	}
 
--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -12,7 +12,7 @@
 
 #include "../kselftest.h"
 #include <include/vdso/time64.h>
-#include "util.h"
+#include "vm_util.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/Makefile
@@ -113,6 +113,10 @@ $(OUTPUT)/mkdirty: vm_util.c
 $(OUTPUT)/soft-dirty: vm_util.c
 $(OUTPUT)/split_huge_page_test: vm_util.c
 $(OUTPUT)/userfaultfd: vm_util.c
+$(OUTPUT)/gup_test: vm_util.c
+$(OUTPUT)/mrelease_test: vm_util.c
+$(OUTPUT)/transhuge-stress: vm_util.c
+$(OUTPUT)/ksm_tests: vm_util.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
--- a/tools/testing/selftests/mm/mrelease_test.c~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/mrelease_test.c
@@ -9,8 +9,7 @@
 #include <stdlib.h>
 #include <sys/wait.h>
 #include <unistd.h>
-
-#include "util.h"
+#include "vm_util.h"
 
 #include "../kselftest.h"
 
@@ -32,7 +31,7 @@ static int alloc_noexit(unsigned long nr
 	unsigned long i;
 	char *buf;
 
-	buf = (char *)mmap(NULL, nr_pages * PAGE_SIZE, PROT_READ | PROT_WRITE,
+	buf = (char *)mmap(NULL, nr_pages * psize(), PROT_READ | PROT_WRITE,
 			   MAP_PRIVATE | MAP_ANON, 0, 0);
 	if (buf == MAP_FAILED) {
 		perror("mmap failed, halting the test");
@@ -40,7 +39,7 @@ static int alloc_noexit(unsigned long nr
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		*((unsigned long *)(buf + (i * PAGE_SIZE))) = i;
+		*((unsigned long *)(buf + (i * psize()))) = i;
 
 	/* Signal the parent that the child is ready */
 	if (write(pipefd, "", 1) < 0) {
@@ -54,7 +53,7 @@ static int alloc_noexit(unsigned long nr
 		timeout--;
 	}
 
-	munmap(buf, nr_pages * PAGE_SIZE);
+	munmap(buf, nr_pages * psize());
 
 	return (timeout > 0) ? KSFT_PASS : KSFT_FAIL;
 }
@@ -87,7 +86,7 @@ static int child_main(int pipefd[], size
 
 	/* Allocate and fault-in memory and wait to be killed */
 	close(pipefd[0]);
-	res = alloc_noexit(MB(size) / PAGE_SIZE, pipefd[1]);
+	res = alloc_noexit(MB(size) / psize(), pipefd[1]);
 	close(pipefd[1]);
 	return res;
 }
--- a/tools/testing/selftests/mm/transhuge-stress.c~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -15,7 +15,7 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/mman.h>
-#include "util.h"
+#include "vm_util.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
@@ -34,10 +34,10 @@ int main(int argc, char **argv)
 	int pagemap_fd;
 
 	ram = sysconf(_SC_PHYS_PAGES);
-	if (ram > SIZE_MAX / sysconf(_SC_PAGESIZE) / 4)
+	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
 	else
-		ram *= sysconf(_SC_PAGESIZE);
+		ram *= psize();
 	len = ram;
 
 	while (++i < argc) {
@@ -58,7 +58,7 @@ int main(int argc, char **argv)
 
 	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
 	      " and %zd MiB of ram", len >> HPAGE_SHIFT, len >> 20,
-	      ram >> (20 + HPAGE_SHIFT - PAGE_SHIFT - 1));
+	      ram >> (20 + HPAGE_SHIFT - pshift() - 1));
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
@@ -92,7 +92,7 @@ int main(int argc, char **argv)
 			if (pfn < 0) {
 				nr_failed++;
 			} else {
-				size_t idx = pfn >> (HPAGE_SHIFT - PAGE_SHIFT);
+				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
 
 				nr_succeed++;
 				if (idx >= map_len) {
@@ -108,7 +108,7 @@ int main(int argc, char **argv)
 			}
 
 			/* split transhuge page, keep last page */
-			if (madvise(p, HPAGE_SIZE - PAGE_SIZE, MADV_DONTNEED))
+			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
 				err(2, "MADV_DONTNEED");
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
--- a/tools/testing/selftests/mm/util.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#ifndef __KSELFTEST_VM_UTIL_H
-#define __KSELFTEST_VM_UTIL_H
-
-#include <stdint.h>
-#include <sys/mman.h>
-#include <err.h>
-#include <string.h> /* ffsl() */
-#include <unistd.h> /* _SC_PAGESIZE */
-
-static unsigned int __page_size;
-static unsigned int __page_shift;
-
-static inline unsigned int page_size(void)
-{
-	if (!__page_size)
-		__page_size = sysconf(_SC_PAGESIZE);
-	return __page_size;
-}
-
-static inline unsigned int page_shift(void)
-{
-	if (!__page_shift)
-		__page_shift = (ffsl(page_size()) - 1);
-	return __page_shift;
-}
-
-#define PAGE_SHIFT	(page_shift())
-#define PAGE_SIZE	(page_size())
-/*
- * On ppc64 this will only work with radix 2M hugepage size
- */
-#define HPAGE_SHIFT 21
-#define HPAGE_SIZE (1 << HPAGE_SHIFT)
-
-#define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
-#define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
-
-
-static inline int64_t allocate_transhuge(void *ptr, int pagemap_fd)
-{
-	uint64_t ent[2];
-
-	/* drop pmd */
-	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
-		 MAP_FIXED | MAP_ANONYMOUS |
-		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
-		errx(2, "mmap transhuge");
-
-	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
-		err(2, "MADV_HUGEPAGE");
-
-	/* allocate transparent huge page */
-	*(volatile void **)ptr = ptr;
-
-	if (pread(pagemap_fd, ent, sizeof(ent),
-		  (uintptr_t)ptr >> (PAGE_SHIFT - 3)) != sizeof(ent))
-		err(2, "read pagemap");
-
-	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
-	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - PAGE_SHIFT)) - 1)))
-		return PAGEMAP_PFN(ent[0]);
-
-	return -1;
-}
-
-#endif
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -8,6 +8,9 @@
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define MAX_LINE_LENGTH 500
 
+unsigned int __page_size;
+unsigned int __page_shift;
+
 uint64_t pagemap_get_entry(int fd, char *start)
 {
 	const unsigned long pfn = (unsigned long)start / getpagesize();
@@ -149,3 +152,31 @@ bool check_huge_shmem(void *addr, int nr
 {
 	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
 }
+
+int64_t allocate_transhuge(void *ptr, int pagemap_fd)
+{
+	uint64_t ent[2];
+
+	/* drop pmd */
+	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
+		 MAP_FIXED | MAP_ANONYMOUS |
+		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
+		errx(2, "mmap transhuge");
+
+	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
+		err(2, "MADV_HUGEPAGE");
+
+	/* allocate transparent huge page */
+	*(volatile void **)ptr = ptr;
+
+	if (pread(pagemap_fd, ent, sizeof(ent),
+		  (uintptr_t)ptr >> (pshift() - 3)) != sizeof(ent))
+		err(2, "read pagemap");
+
+	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
+	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
+		return PAGEMAP_PFN(ent[0]);
+
+	return -1;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-merge-utilh-into-vm_utilh
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -1,6 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/mman.h>
+#include <err.h>
+#include <string.h> /* ffsl() */
+#include <unistd.h> /* _SC_PAGESIZE */
+
+extern unsigned int __page_size;
+extern unsigned int __page_shift;
+
+static inline unsigned int psize(void)
+{
+	if (!__page_size)
+		__page_size = sysconf(_SC_PAGESIZE);
+	return __page_size;
+}
+
+static inline unsigned int pshift(void)
+{
+	if (!__page_shift)
+		__page_shift = (ffsl(psize()) - 1);
+	return __page_shift;
+}
 
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
@@ -13,3 +34,13 @@ uint64_t read_pmd_pagesize(void);
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
+int64_t allocate_transhuge(void *ptr, int pagemap_fd);
+
+/*
+ * On ppc64 this will only work with radix 2M hugepage size
+ */
+#define HPAGE_SHIFT 21
+#define HPAGE_SIZE (1 << HPAGE_SHIFT)
+
+#define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
+#define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch

