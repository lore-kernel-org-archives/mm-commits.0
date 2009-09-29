From: akpm@linux-foundation.org
Subject: + page-types-make-standalone-pagemap-kpageflags-read-routines.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:46:16 -0700
Message-ID: <200909292146.n8TLkG3H013013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZI2VqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org


The patch titled
     page-types: make standalone pagemap/kpageflags read routines
has been added to the -mm tree.  Its filename is
     page-types-make-standalone-pagemap-kpageflags-read-routines.patch

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
Subject: page-types: make standalone pagemap/kpageflags read routines
From: Wu Fengguang <fengguang.wu@intel.com>

Refactor the code to be more modular and easier to reuse.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |  156 ++++++++++++++++++--------------
 1 file changed, 90 insertions(+), 66 deletions(-)

diff -puN Documentation/vm/page-types.c~page-types-make-standalone-pagemap-kpageflags-read-routines Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-make-standalone-pagemap-kpageflags-read-routines
+++ a/Documentation/vm/page-types.c
@@ -161,8 +161,6 @@ static unsigned long	pg_start[MAX_VMAS];
 static unsigned long	pg_end[MAX_VMAS];
 static unsigned long	voffset;
 
-static int		pagemap_fd;
-
 #define MAX_BIT_FILTERS	64
 static int		nr_bit_filters;
 static uint64_t		opt_mask[MAX_BIT_FILTERS];
@@ -170,7 +168,7 @@ static uint64_t		opt_bits[MAX_BIT_FILTER
 
 static int		page_size;
 
-#define PAGES_BATCH	(64 << 10)	/* 64k pages */
+static int		pagemap_fd;
 static int		kpageflags_fd;
 
 #define HASH_SHIFT	13
@@ -226,6 +224,62 @@ int checked_open(const char *pathname, i
 	return fd;
 }
 
+/*
+ * pagemap/kpageflags routines
+ */
+
+static unsigned long do_u64_read(int fd, char *name,
+				 uint64_t *buf,
+				 unsigned long index,
+				 unsigned long count)
+{
+	long bytes;
+
+	if (index > ULONG_MAX / 8)
+		fatal("index overflow: %lu\n", index);
+
+	if (lseek(fd, index * 8, SEEK_SET) < 0) {
+		perror(name);
+		exit(EXIT_FAILURE);
+	}
+
+	bytes = read(fd, buf, count * 8);
+	if (bytes < 0) {
+		perror(name);
+		exit(EXIT_FAILURE);
+	}
+	if (bytes % 8)
+		fatal("partial read: %lu bytes\n", bytes);
+
+	return bytes / 8;
+}
+
+static unsigned long kpageflags_read(uint64_t *buf,
+				     unsigned long index,
+				     unsigned long pages)
+{
+	return do_u64_read(kpageflags_fd, PROC_KPAGEFLAGS, buf, index, pages);
+}
+
+static unsigned long pagemap_read(uint64_t *buf,
+				  unsigned long index,
+				  unsigned long pages)
+{
+	return do_u64_read(pagemap_fd, "/proc/pid/pagemap", buf, index, pages);
+}
+
+static unsigned long pagemap_pfn(uint64_t val)
+{
+	unsigned long pfn;
+
+	if (val & PM_PRESENT)
+		pfn = PM_PFRAME(val);
+	else
+		pfn = 0;
+
+	return pfn;
+}
+
 
 /*
  * page flag names
@@ -432,79 +486,53 @@ static void add_page(unsigned long offse
 	total_pages++;
 }
 
+#define KPAGEFLAGS_BATCH	(64 << 10)	/* 64k pages */
 static void walk_pfn(unsigned long index, unsigned long count)
 {
+	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
-	unsigned long n;
+	unsigned long pages;
 	unsigned long i;
 
-	if (index > ULONG_MAX / KPF_BYTES)
-		fatal("index overflow: %lu\n", index);
-
-	lseek(kpageflags_fd, index * KPF_BYTES, SEEK_SET);
-
 	while (count) {
-		uint64_t kpageflags_buf[KPF_BYTES * PAGES_BATCH];
-
-		batch = min_t(unsigned long, count, PAGES_BATCH);
-		n = read(kpageflags_fd, kpageflags_buf, batch * KPF_BYTES);
-		if (n == 0)
-			break;
-		if (n < 0) {
-			perror(PROC_KPAGEFLAGS);
-			exit(EXIT_FAILURE);
-		}
-
-		if (n % KPF_BYTES != 0)
-			fatal("partial read: %lu bytes\n", n);
-		n = n / KPF_BYTES;
+		batch = min_t(unsigned long, count, KPAGEFLAGS_BATCH);
+		pages = kpageflags_read(buf, index, batch);
+		if (pages == 0)
+			break;
 
-		for (i = 0; i < n; i++)
-			add_page(index + i, kpageflags_buf[i]);
+		for (i = 0; i < pages; i++)
+			add_page(index + i, buf[i]);
 
-		index += batch;
-		count -= batch;
+		index += pages;
+		count -= pages;
 	}
 }
 
-
-#define PAGEMAP_BATCH	4096
-static unsigned long task_pfn(unsigned long pgoff)
+#define PAGEMAP_BATCH	(64 << 10)
+static void walk_vma(unsigned long index, unsigned long count)
 {
-	static uint64_t buf[PAGEMAP_BATCH];
-	static unsigned long start;
-	static long count;
-	uint64_t pfn;
+	uint64_t buf[PAGEMAP_BATCH];
+	unsigned long batch;
+	unsigned long pages;
+	unsigned long pfn;
+	unsigned long i;
 
-	if (pgoff < start || pgoff >= start + count) {
-		if (lseek64(pagemap_fd,
-			    (uint64_t)pgoff * PM_ENTRY_BYTES,
-			    SEEK_SET) < 0) {
-			perror("pagemap seek");
-			exit(EXIT_FAILURE);
-		}
-		count = read(pagemap_fd, buf, sizeof(buf));
-		if (count == 0)
-			return 0;
-		if (count < 0) {
-			perror("pagemap read");
-			exit(EXIT_FAILURE);
-		}
-		if (count % PM_ENTRY_BYTES) {
-			fatal("pagemap read not aligned.\n");
-			exit(EXIT_FAILURE);
-		}
-		count /= PM_ENTRY_BYTES;
-		start = pgoff;
-	}
+	while (count) {
+		batch = min_t(unsigned long, count, PAGEMAP_BATCH);
+		pages = pagemap_read(buf, index, batch);
+		if (pages == 0)
+			break;
 
-	pfn = buf[pgoff - start];
-	if (pfn & PM_PRESENT)
-		pfn = PM_PFRAME(pfn);
-	else
-		pfn = 0;
+		for (i = 0; i < pages; i++) {
+			pfn = pagemap_pfn(buf[i]);
+			voffset = index + i;
+			if (pfn)
+				walk_pfn(pfn, 1);
+		}
 
-	return pfn;
+		index += pages;
+		count -= pages;
+	}
 }
 
 static void walk_task(unsigned long index, unsigned long count)
@@ -524,11 +552,7 @@ static void walk_task(unsigned long inde
 		index   = min_t(unsigned long, pg_end[i], end);
 
 		assert(voffset < index);
-		for (; voffset < index; voffset++) {
-			unsigned long pfn = task_pfn(voffset);
-			if (pfn)
-				walk_pfn(pfn, 1);
-		}
+		walk_vma(voffset, index - voffset);
 	}
 }
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
pagemap-export-kpf_hwpoison.patch
pagemap-document-kpf_ksm-and-show-it-in-page-types.patch
page-types-add-gpl-note.patch
page-types-introduce-checked_open.patch
page-types-make-standalone-pagemap-kpageflags-read-routines.patch
page-types-make-voffset-local-variables.patch
page-types-introduce-kpageflags_flags.patch
page-types-add-hwpoison-unpoison-feature.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

