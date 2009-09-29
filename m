From: akpm@linux-foundation.org
Subject: + page-types-make-voffset-local-variables.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:46:18 -0700
Message-ID: <200909292146.n8TLkIxS013109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbZI2VqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org


The patch titled
     page-types: make voffset local variables
has been added to the -mm tree.  Its filename is
     page-types-make-voffset-local-variables.patch

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
Subject: page-types: make voffset local variables
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |   39 +++++++++++++++++---------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN Documentation/vm/page-types.c~page-types-make-voffset-local-variables Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-make-voffset-local-variables
+++ a/Documentation/vm/page-types.c
@@ -159,7 +159,6 @@ static unsigned long	opt_size[MAX_ADDR_R
 static int		nr_vmas;
 static unsigned long	pg_start[MAX_VMAS];
 static unsigned long	pg_end[MAX_VMAS];
-static unsigned long	voffset;
 
 #define MAX_BIT_FILTERS	64
 static int		nr_bit_filters;
@@ -328,7 +327,8 @@ static char *page_flag_longname(uint64_t
  * page list and summary
  */
 
-static void show_page_range(unsigned long offset, uint64_t flags)
+static void show_page_range(unsigned long voffset,
+			    unsigned long offset, uint64_t flags)
 {
 	static uint64_t      flags0;
 	static unsigned long voff;
@@ -354,7 +354,8 @@ static void show_page_range(unsigned lon
 	count  = 1;
 }
 
-static void show_page(unsigned long offset, uint64_t flags)
+static void show_page(unsigned long voffset,
+		      unsigned long offset, uint64_t flags)
 {
 	if (opt_pid)
 		printf("%lx\t", voffset);
@@ -435,7 +436,6 @@ static uint64_t well_known_flags(uint64_
 	return flags;
 }
 
-
 /*
  * page frame walker
  */
@@ -467,7 +467,8 @@ static int hash_slot(uint64_t flags)
 	exit(EXIT_FAILURE);
 }
 
-static void add_page(unsigned long offset, uint64_t flags)
+static void add_page(unsigned long voffset,
+		     unsigned long offset, uint64_t flags)
 {
 	flags = expand_overloaded_flags(flags);
 
@@ -478,16 +479,18 @@ static void add_page(unsigned long offse
 		return;
 
 	if (opt_list == 1)
-		show_page_range(offset, flags);
+		show_page_range(voffset, offset, flags);
 	else if (opt_list == 2)
-		show_page(offset, flags);
+		show_page(voffset, offset, flags);
 
 	nr_pages[hash_slot(flags)]++;
 	total_pages++;
 }
 
 #define KPAGEFLAGS_BATCH	(64 << 10)	/* 64k pages */
-static void walk_pfn(unsigned long index, unsigned long count)
+static void walk_pfn(unsigned long voffset,
+		     unsigned long index,
+		     unsigned long count)
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
@@ -501,7 +504,7 @@ static void walk_pfn(unsigned long index
 			break;
 
 		for (i = 0; i < pages; i++)
-			add_page(index + i, buf[i]);
+			add_page(voffset + i, index + i, buf[i]);
 
 		index += pages;
 		count -= pages;
@@ -525,9 +528,8 @@ static void walk_vma(unsigned long index
 
 		for (i = 0; i < pages; i++) {
 			pfn = pagemap_pfn(buf[i]);
-			voffset = index + i;
 			if (pfn)
-				walk_pfn(pfn, 1);
+				walk_pfn(index + i, pfn, 1);
 		}
 
 		index += pages;
@@ -537,8 +539,9 @@ static void walk_vma(unsigned long index
 
 static void walk_task(unsigned long index, unsigned long count)
 {
-	int i = 0;
 	const unsigned long end = index + count;
+	unsigned long start;
+	int i = 0;
 
 	while (index < end) {
 
@@ -548,11 +551,11 @@ static void walk_task(unsigned long inde
 		if (pg_start[i] >= end)
 			return;
 
-		voffset = max_t(unsigned long, pg_start[i], index);
-		index   = min_t(unsigned long, pg_end[i], end);
+		start = max_t(unsigned long, pg_start[i], index);
+		index = min_t(unsigned long, pg_end[i], end);
 
-		assert(voffset < index);
-		walk_vma(voffset, index - voffset);
+		assert(start < index);
+		walk_vma(start, index - start);
 	}
 }
 
@@ -577,7 +580,7 @@ static void walk_addr_ranges(void)
 
 	for (i = 0; i < nr_addr_ranges; i++)
 		if (!opt_pid)
-			walk_pfn(opt_offset[i], opt_size[i]);
+			walk_pfn(0, opt_offset[i], opt_size[i]);
 		else
 			walk_task(opt_offset[i], opt_size[i]);
 
@@ -879,7 +882,7 @@ int main(int argc, char *argv[])
 	walk_addr_ranges();
 
 	if (opt_list == 1)
-		show_page_range(0, 0);  /* drain the buffer */
+		show_page_range(0, 0, 0);  /* drain the buffer */
 
 	if (opt_no_summary)
 		return 0;
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

