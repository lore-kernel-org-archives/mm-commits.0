From: akpm@linux-foundation.org
Subject: + page-types-add-feature-for-walking-process-address-space.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:01:48 -0700
Message-ID: <200909092101.n89L1mSv022856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbZIIVCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org


The patch titled
     page-types: add feature for walking process address space
has been added to the -mm tree.  Its filename is
     page-types-add-feature-for-walking-process-address-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: add feature for walking process address space
From: Wu Fengguang <fengguang.wu@intel.com>

Introduce "-p|--pid <pid>" for walking the process address space.  The
default action is to walk raw memory PFNs.

Both the virtual address and physhcal address of each present pages will be listed:

	# ./tools/vm/page-types -lp $$ | head -3
	voffset offset  len     flags
	400     11bebe  1       __RU_lA____M______________________
	402     11bebc  1       __RU_lA____M______________________

Note that voffset/offset/len are now showed as hex numbers.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |  200 ++++++++++++++++++++++++++++----
 1 file changed, 180 insertions(+), 20 deletions(-)

diff -puN Documentation/vm/page-types.c~page-types-add-feature-for-walking-process-address-space Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-add-feature-for-walking-process-address-space
+++ a/Documentation/vm/page-types.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2009 Wu Fengguang <fengguang.wu@intel.com>
  */
 
+#define _LARGEFILE64_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -13,12 +14,33 @@
 #include <string.h>
 #include <getopt.h>
 #include <limits.h>
+#include <assert.h>
 #include <sys/types.h>
 #include <sys/errno.h>
 #include <sys/fcntl.h>
 
 
 /*
+ * pagemap kernel ABI bits
+ */
+
+#define PM_ENTRY_BYTES      sizeof(uint64_t)
+#define PM_STATUS_BITS      3
+#define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
+#define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
+#define PM_STATUS(nr)       (((nr) << PM_STATUS_OFFSET) & PM_STATUS_MASK)
+#define PM_PSHIFT_BITS      6
+#define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
+#define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
+#define PM_PSHIFT(x)        (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
+#define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
+#define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
+
+#define PM_PRESENT          PM_STATUS(4LL)
+#define PM_SWAP             PM_STATUS(2LL)
+
+
+/*
  * kernel page flags
  */
 
@@ -126,6 +148,14 @@ static int		nr_addr_ranges;
 static unsigned long	opt_offset[MAX_ADDR_RANGES];
 static unsigned long	opt_size[MAX_ADDR_RANGES];
 
+#define MAX_VMAS	10240
+static int		nr_vmas;
+static unsigned long	pg_start[MAX_VMAS];
+static unsigned long	pg_end[MAX_VMAS];
+static unsigned long	voffset;
+
+static int		pagemap_fd;
+
 #define MAX_BIT_FILTERS	64
 static int		nr_bit_filters;
 static uint64_t		opt_mask[MAX_BIT_FILTERS];
@@ -135,7 +165,6 @@ static int		page_size;
 
 #define PAGES_BATCH	(64 << 10)	/* 64k pages */
 static int		kpageflags_fd;
-static uint64_t		kpageflags_buf[KPF_BYTES * PAGES_BATCH];
 
 #define HASH_SHIFT	13
 #define HASH_SIZE	(1 << HASH_SHIFT)
@@ -158,6 +187,11 @@ static uint64_t 	page_flags[HASH_SIZE];
 	type __min2 = (y);			\
 	__min1 < __min2 ? __min1 : __min2; })
 
+#define max_t(type, x, y) ({			\
+	type __max1 = (x);			\
+	type __max2 = (y);			\
+	__max1 > __max2 ? __max1: __max2; })
+
 static unsigned long pages2mb(unsigned long pages)
 {
 	return (pages * page_size) >> 20;
@@ -224,26 +258,34 @@ static char *page_flag_longname(uint64_t
 static void show_page_range(unsigned long offset, uint64_t flags)
 {
 	static uint64_t      flags0;
+	static unsigned long voff;
 	static unsigned long index;
 	static unsigned long count;
 
-	if (flags == flags0 && offset == index + count) {
+	if (flags == flags0 && offset == index + count &&
+	    (!opt_pid || voffset == voff + count)) {
 		count++;
 		return;
 	}
 
-	if (count)
-		printf("%lu\t%lu\t%s\n",
+	if (count) {
+		if (opt_pid)
+			printf("%lx\t", voff);
+		printf("%lx\t%lx\t%s\n",
 				index, count, page_flag_name(flags0));
+	}
 
 	flags0 = flags;
 	index  = offset;
+	voff   = voffset;
 	count  = 1;
 }
 
 static void show_page(unsigned long offset, uint64_t flags)
 {
-	printf("%lu\t%s\n", offset, page_flag_name(flags));
+	if (opt_pid)
+		printf("%lx\t", voffset);
+	printf("%lx\t%s\n", offset, page_flag_name(flags));
 }
 
 static void show_summary(void)
@@ -383,6 +425,8 @@ static void walk_pfn(unsigned long index
 	lseek(kpageflags_fd, index * KPF_BYTES, SEEK_SET);
 
 	while (count) {
+		uint64_t kpageflags_buf[KPF_BYTES * PAGES_BATCH];
+
 		batch = min_t(unsigned long, count, PAGES_BATCH);
 		n = read(kpageflags_fd, kpageflags_buf, batch * KPF_BYTES);
 		if (n == 0)
@@ -404,6 +448,81 @@ static void walk_pfn(unsigned long index
 	}
 }
 
+
+#define PAGEMAP_BATCH	4096
+static unsigned long task_pfn(unsigned long pgoff)
+{
+	static uint64_t buf[PAGEMAP_BATCH];
+	static unsigned long start;
+	static long count;
+	uint64_t pfn;
+
+	if (pgoff < start || pgoff >= start + count) {
+		if (lseek64(pagemap_fd,
+			    (uint64_t)pgoff * PM_ENTRY_BYTES,
+			    SEEK_SET) < 0) {
+			perror("pagemap seek");
+			exit(EXIT_FAILURE);
+		}
+		count = read(pagemap_fd, buf, sizeof(buf));
+		if (count == 0)
+			return 0;
+		if (count < 0) {
+			perror("pagemap read");
+			exit(EXIT_FAILURE);
+		}
+		if (count % PM_ENTRY_BYTES) {
+			fatal("pagemap read not aligned.\n");
+			exit(EXIT_FAILURE);
+		}
+		count /= PM_ENTRY_BYTES;
+		start = pgoff;
+	}
+
+	pfn = buf[pgoff - start];
+	if (pfn & PM_PRESENT)
+		pfn = PM_PFRAME(pfn);
+	else
+		pfn = 0;
+
+	return pfn;
+}
+
+static void walk_task(unsigned long index, unsigned long count)
+{
+	int i = 0;
+	const unsigned long end = index + count;
+
+	while (index < end) {
+
+		while (pg_end[i] <= index)
+			if (++i >= nr_vmas)
+				return;
+		if (pg_start[i] >= end)
+			return;
+
+		voffset = max_t(unsigned long, pg_start[i], index);
+		index   = min_t(unsigned long, pg_end[i], end);
+
+		assert(voffset < index);
+		for (; voffset < index; voffset++) {
+			unsigned long pfn = task_pfn(voffset);
+			if (pfn)
+				walk_pfn(pfn, 1);
+		}
+	}
+}
+
+static void add_addr_range(unsigned long offset, unsigned long size)
+{
+	if (nr_addr_ranges >= MAX_ADDR_RANGES)
+		fatal("too many addr ranges\n");
+
+	opt_offset[nr_addr_ranges] = offset;
+	opt_size[nr_addr_ranges] = min_t(unsigned long, size, ULONG_MAX-offset);
+	nr_addr_ranges++;
+}
+
 static void walk_addr_ranges(void)
 {
 	int i;
@@ -415,10 +534,13 @@ static void walk_addr_ranges(void)
 	}
 
 	if (!nr_addr_ranges)
-		walk_pfn(0, ULONG_MAX);
+		add_addr_range(0, ULONG_MAX);
 
 	for (i = 0; i < nr_addr_ranges; i++)
-		walk_pfn(opt_offset[i], opt_size[i]);
+		if (!opt_pid)
+			walk_pfn(opt_offset[i], opt_size[i]);
+		else
+			walk_task(opt_offset[i], opt_size[i]);
 
 	close(kpageflags_fd);
 }
@@ -446,8 +568,8 @@ static void usage(void)
 "            -r|--raw                  Raw mode, for kernel developers\n"
 "            -a|--addr    addr-spec    Walk a range of pages\n"
 "            -b|--bits    bits-spec    Walk pages with specified bits\n"
-#if 0 /* planned features */
 "            -p|--pid     pid          Walk process address space\n"
+#if 0 /* planned features */
 "            -f|--file    filename     Walk file address space\n"
 #endif
 "            -l|--list                 Show page details in ranges\n"
@@ -459,7 +581,7 @@ static void usage(void)
 "            N+M                       pages range from N to N+M-1\n"
 "            N,M                       pages range from N to M-1\n"
 "            N,                        pages range from N to end\n"
-"            ,M                        pages range from 0 to M\n"
+"            ,M                        pages range from 0 to M-1\n"
 "bits-spec:\n"
 "            bit1,bit2                 (flags & (bit1|bit2)) != 0\n"
 "            bit1,bit2=bit1            (flags & (bit1|bit2)) == bit1\n"
@@ -496,21 +618,57 @@ static unsigned long long parse_number(c
 
 static void parse_pid(const char *str)
 {
+	FILE *file;
+	char buf[5000];
+
 	opt_pid = parse_number(str);
-}
 
-static void parse_file(const char *name)
-{
+	sprintf(buf, "/proc/%d/pagemap", opt_pid);
+	pagemap_fd = open(buf, O_RDONLY);
+	if (pagemap_fd < 0) {
+		perror(buf);
+		exit(EXIT_FAILURE);
+	}
+
+	sprintf(buf, "/proc/%d/maps", opt_pid);
+	file = fopen(buf, "r");
+	if (!file) {
+		perror(buf);
+		exit(EXIT_FAILURE);
+	}
+
+	while (fgets(buf, sizeof(buf), file) != NULL) {
+		unsigned long vm_start;
+		unsigned long vm_end;
+		unsigned long long pgoff;
+		int major, minor;
+		char r, w, x, s;
+		unsigned long ino;
+		int n;
+
+		n = sscanf(buf, "%lx-%lx %c%c%c%c %llx %x:%x %lu",
+			   &vm_start,
+			   &vm_end,
+			   &r, &w, &x, &s,
+			   &pgoff,
+			   &major, &minor,
+			   &ino);
+		if (n < 10) {
+			fprintf(stderr, "unexpected line: %s\n", buf);
+			continue;
+		}
+		pg_start[nr_vmas] = vm_start / page_size;
+		pg_end[nr_vmas] = vm_end / page_size;
+		if (++nr_vmas >= MAX_VMAS) {
+			fprintf(stderr, "too many VMAs\n");
+			break;
+		}
+	}
+	fclose(file);
 }
 
-static void add_addr_range(unsigned long offset, unsigned long size)
+static void parse_file(const char *name)
 {
-	if (nr_addr_ranges >= MAX_ADDR_RANGES)
-		fatal("too much addr ranges\n");
-
-	opt_offset[nr_addr_ranges] = offset;
-	opt_size[nr_addr_ranges] = size;
-	nr_addr_ranges++;
 }
 
 static void parse_addr_range(const char *optarg)
@@ -676,8 +834,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (opt_list && opt_pid)
+		printf("voffset\t");
 	if (opt_list == 1)
-		printf("offset\tcount\tflags\n");
+		printf("offset\tlen\tflags\n");
 	if (opt_list == 2)
 		printf("offset\tflags\n");
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-do-batched-scans-for-mem_cgroup.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
documentation-vm-gitignore-add-page-types.patch
page-types-add-feature-for-walking-process-address-space.patch

