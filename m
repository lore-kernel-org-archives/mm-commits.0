From: akpm@linux-foundation.org
Subject: [merged] revert-selftest-add-simple-test-for-soft-dirty-bit.patch removed from -mm tree
Date: Tue, 28 May 2013 12:37:01 -0700
Message-ID: <51a5075d.IDxXxqG3IMMEivhL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab3E1ThC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, akpm@linux-foundation.org

Subject: [merged] revert-selftest-add-simple-test-for-soft-dirty-bit.patch removed from -mm tree
To: akpm@linux-foundation.org,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:01 -0700


The patch titled
     Subject: revert "selftest: add simple test for soft-dirty bit"
has been removed from the -mm tree.  Its filename was
     revert-selftest-add-simple-test-for-soft-dirty-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "selftest: add simple test for soft-dirty bit"

Revert 58c7be84fec8 ("selftest: add simple test for soft-dirty bit"). 
This is the self test for Pavel's pagemap2 patches which didn't actually
get merged.

Reported-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                |    1 
 tools/testing/selftests/soft-dirty/Makefile     |   10 -
 tools/testing/selftests/soft-dirty/soft-dirty.c |  114 --------------
 3 files changed, 125 deletions(-)

diff -puN tools/testing/selftests/Makefile~revert-selftest-add-simple-test-for-soft-dirty-bit tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~revert-selftest-add-simple-test-for-soft-dirty-bit
+++ a/tools/testing/selftests/Makefile
@@ -6,7 +6,6 @@ TARGETS += memory-hotplug
 TARGETS += mqueue
 TARGETS += net
 TARGETS += ptrace
-TARGETS += soft-dirty
 TARGETS += vm
 
 all:
diff -puN tools/testing/selftests/soft-dirty/Makefile~revert-selftest-add-simple-test-for-soft-dirty-bit /dev/null
--- a/tools/testing/selftests/soft-dirty/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-CFLAGS += -iquote../../../../include/uapi -Wall
-soft-dirty: soft-dirty.c
-
-all: soft-dirty
-
-clean:
-	rm -f soft-dirty
-
-run_tests: all
-	@./soft-dirty || echo "soft-dirty selftests: [FAIL]"
diff -puN tools/testing/selftests/soft-dirty/soft-dirty.c~revert-selftest-add-simple-test-for-soft-dirty-bit /dev/null
--- a/tools/testing/selftests/soft-dirty/soft-dirty.c
+++ /dev/null
@@ -1,114 +0,0 @@
-#include <stdlib.h>
-#include <stdio.h>
-#include <sys/mman.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/types.h>
-
-typedef unsigned long long u64;
-
-#define PME_PRESENT	(1ULL << 63)
-#define PME_SOFT_DIRTY	(1Ull << 55)
-
-#define PAGES_TO_TEST	3
-#ifndef PAGE_SIZE
-#define PAGE_SIZE	4096
-#endif
-
-static void get_pagemap2(char *mem, u64 *map)
-{
-	int fd;
-
-	fd = open("/proc/self/pagemap2", O_RDONLY);
-	if (fd < 0) {
-		perror("Can't open pagemap2");
-		exit(1);
-	}
-
-	lseek(fd, (unsigned long)mem / PAGE_SIZE * sizeof(u64), SEEK_SET);
-	read(fd, map, sizeof(u64) * PAGES_TO_TEST);
-	close(fd);
-}
-
-static inline char map_p(u64 map)
-{
-	return map & PME_PRESENT ? 'p' : '-';
-}
-
-static inline char map_sd(u64 map)
-{
-	return map & PME_SOFT_DIRTY ? 'd' : '-';
-}
-
-static int check_pte(int step, int page, u64 *map, u64 want)
-{
-	if ((map[page] & want) != want) {
-		printf("Step %d Page %d has %c%c, want %c%c\n",
-				step, page,
-				map_p(map[page]), map_sd(map[page]),
-				map_p(want), map_sd(want));
-		return 1;
-	}
-
-	return 0;
-}
-
-static void clear_refs(void)
-{
-	int fd;
-	char *v = "4";
-
-	fd = open("/proc/self/clear_refs", O_WRONLY);
-	if (write(fd, v, 3) < 3) {
-		perror("Can't clear soft-dirty bit");
-		exit(1);
-	}
-	close(fd);
-}
-
-int main(void)
-{
-	char *mem, x;
-	u64 map[PAGES_TO_TEST];
-
-	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
-			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, 0, 0);
-
-	x = mem[0];
-	mem[2 * PAGE_SIZE] = 'c';
-	get_pagemap2(mem, map);
-
-	if (check_pte(1, 0, map, PME_PRESENT))
-		return 1;
-	if (check_pte(1, 1, map, 0))
-		return 1;
-	if (check_pte(1, 2, map, PME_PRESENT | PME_SOFT_DIRTY))
-		return 1;
-
-	clear_refs();
-	get_pagemap2(mem, map);
-
-	if (check_pte(2, 0, map, PME_PRESENT))
-		return 1;
-	if (check_pte(2, 1, map, 0))
-		return 1;
-	if (check_pte(2, 2, map, PME_PRESENT))
-		return 1;
-
-	mem[0] = 'a';
-	mem[PAGE_SIZE] = 'b';
-	x = mem[2 * PAGE_SIZE];
-	get_pagemap2(mem, map);
-
-	if (check_pte(3, 0, map, PME_PRESENT | PME_SOFT_DIRTY))
-		return 1;
-	if (check_pte(3, 1, map, PME_PRESENT | PME_SOFT_DIRTY))
-		return 1;
-	if (check_pte(3, 2, map, PME_PRESENT))
-		return 1;
-
-	(void)x; /* gcc warn */
-
-	printf("PASS\n");
-	return 0;
-}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

