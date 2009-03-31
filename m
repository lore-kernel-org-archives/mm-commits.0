From: akpm@linux-foundation.org
Subject: + page-owner-tracking.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:21:09 -0700
Message-ID: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764631AbZCaX0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com, apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitu.com, mel@csn.ul.ie


The patch titled
     page-owner tracking
has been added to the -mm tree.  Its filename is
     page-owner-tracking.patch

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
Subject: page-owner tracking
From: Alexander Nyberg <alexn@dsv.su.se>

> On Fri, 20 Mar 2009 15:27:00 +0000 Mel Gorman <mel@csn.ul.ie> wrote:

Here is a rebased reversion. Appears to work as advertised based on a
quick test with qemu and builds without CONFIG_PROC_PAGEOWNER



Introduces CONFIG_PROC_PAGEOWNER that keeps track of the call chain
under which a page was allocated.  Includes a user-space helper in
Documentation/page_owner.c to sort the enormous amount of output that this
may give (thanks tridge).

Information available through /proc/page_owner

x86_64 introduces some stack noise in certain call chains so for exact
output use of x86 && CONFIG_FRAME_POINTER is suggested.  Tested on x86,
x86 && CONFIG_FRAME_POINTER, x86_64

Output looks like:

4819 times:
Page allocated via order 0, mask 0x50
[0xc012b7b9] find_lock_page+25
[0xc012b8c8] find_or_create_page+152
[0xc0147d74] grow_dev_page+36
[0xc0148164] __find_get_block+84
[0xc0147ebc] __getblk_slow+124
[0xc0148164] __find_get_block+84
[0xc01481e7] __getblk+55
[0xc0185d14] do_readahead+100

We use a custom stack unwinder because using __builtin_return_address([0-7])
causes gcc to generate code that might try to unwind the stack looking for
function return addresses and "fall off" causing early panics if the call
chain is not deep enough.  So in that case we could have had a depth of
around 3 functions in all traces (I experimented a bit with this).


	make page_owner handle non-contiguous page ranges


I've cleaned up the __alloc_pages() part to a simple set_page_owner() call.

Signed-off-by: Alexander Nyberg <alexn@dsv.su.se>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitu.com>
DESC
Update page->order at an appropriate time when tracking PAGE_OWNER
EDESC

PAGE_OWNER tracks free pages by setting page->order to -1.  However, it is
set during __free_pages() which is not the only free path as
__pagevec_free() and free_compound_page() do not go through __free_pages().
 This leads to a situation where free pages are visible in /proc/page_owner
which is confusing and might be interpreted as a memory leak.

This patch sets page->owner when PageBuddy is set.  It also prints a
warning to the kernel log if a free page is found that does not appear free
to PAGE_OWNER.  This should be considered a fix to
page-owner-tracking-leak-detector.patch.

This only applies to -mm as PAGE_OWNER is not in mainline.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
DESC
Print out PAGE_OWNER statistics in relation to fragmentation avoidance
EDESC

When PAGE_OWNER is set, more information is available of relevance to
fragmentation avoidance.  A second line is added to /proc/page_owner showing
the PFN, the pageblock number, the mobility type of the page based on its
allocation flags, whether the allocation is improperly placed and the flags.
A sample entry looks like

Page allocated via order 0, mask 0x1280d2
PFN 7355 Block 7 type 3 Fallback Flags      LA
[0xc01528c6] __handle_mm_fault+598
[0xc0320427] do_page_fault+279
[0xc031ed9a] error_code+114

This information can be used to identify pages that are improperly placed.
As the format of PAGE_OWNER data is now different, the comment at the top
of Documentation/page_owner.c is updated with new instructions.

As PAGE_OWNER tracks the GFP flags used to allocate the pages,
/proc/pagetypeinfo is enhanced to contain how many mixed blocks exist.
The additional output looks like

Number of mixed blocks    Unmovable  Reclaimable      Movable      Reserve
Node 0, zone      DMA            0            1            2            1
Node 0, zone   Normal            2           11           33            0

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
DESC
Allow PAGE_OWNER to be set on any architecture
EDESC

Currently PAGE_OWNER depends on CONFIG_X86.  This appears to be due to
pfn_to_page() being called in an inappropriate for many memory models
and the presense of memory holes.  This patch ensures that pfn_valid()
and pfn_valid_within() is called at the appropriate places and the offsets
correctly updated so that PAGE_OWNER is safe on any architecture.

In situations where CONFIG_HOLES_IN_ZONES is set (IA64 with VIRTUAL_MEM_MAP),
there may be cases where pages allocated within a MAX_ORDER_NR_PAGES block
of pages may not be displayed in /proc/page_owner if the hole is at the
start of the block.  Addressing this would be quite complex, perform slowly
and is of no clear benefit.

Once PAGE_OWNER is allowed on all architectures, the statistics for grouping
pages by mobility that declare how many pageblocks contain mixed page types
becomes optionally available on all arches.

This patch was tested successfully on x86, x86_64, ppc64 and IA64 machines.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
DESC
allow-page_owner-to-be-set-on-any-architecture-fix
EDESC

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
DESC
allow-page_owner-to-be-set-on-any-architecture-fix fix
EDESC

Page-owner-tracking stores the a backtrace of an allocation in the
struct page.  How the stack trace is generated depends on whether
CONFIG_FRAME_POINTER is set or not.  If CONFIG_FRAME_POINTER is set,
the frame pointer must be read using some inline assembler which is not
available for all architectures.

This patch uses the frame pointer where it is available but has a fallback
where it is not.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


Rebase on top of procfs changes

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

new file mode 100644
index 0000000..9081bd6
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |  144 +++++++++++++++++++++++++++++++++++
 fs/proc/Makefile           |    1 
 include/linux/mm_types.h   |    6 +
 lib/Kconfig.debug          |   10 ++
 mm/page_alloc.c            |   66 ++++++++++++++++
 mm/vmstat.c                |   93 ++++++++++++++++++++++
 6 files changed, 320 insertions(+)

diff -puN /dev/null Documentation/page_owner.c
--- /dev/null
+++ a/Documentation/page_owner.c
@@ -0,0 +1,144 @@
+/*
+ * User-space helper to sort the output of /proc/page_owner
+ *
+ * Example use:
+ * cat /proc/page_owner > page_owner_full.txt
+ * grep -v ^PFN page_owner_full.txt > page_owner.txt
+ * ./sort page_owner.txt sorted_page_owner.txt
+*/
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+
+struct block_list {
+	char *txt;
+	int len;
+	int num;
+};
+
+
+static struct block_list *list;
+static int list_size;
+static int max_size;
+
+struct block_list *block_head;
+
+int read_block(char *buf, FILE *fin)
+{
+	int ret = 0;
+	int hit = 0;
+	char *curr = buf;
+
+	for (;;) {
+		*curr = getc(fin);
+		if (*curr == EOF) return -1;
+
+		ret++;
+		if (*curr == '\n' && hit == 1)
+			return ret - 1;
+		else if (*curr == '\n')
+			hit = 1;
+		else
+			hit = 0;
+		curr++;
+	}
+}
+
+static int compare_txt(const void *d1, const void *d2)
+{
+	struct block_list *l1 = (struct block_list *)d1;
+	struct block_list *l2 = (struct block_list *)d2;
+	return strcmp(l1->txt, l2->txt);
+}
+
+static int compare_num(const void *d1, const void *d2)
+{
+	struct block_list *l1 = (struct block_list *)d1;
+	struct block_list *l2 = (struct block_list *)d2;
+	return l2->num - l1->num;
+}
+
+static void add_list(char *buf, int len)
+{
+	if (list_size != 0 &&
+	    len == list[list_size-1].len &&
+	    memcmp(buf, list[list_size-1].txt, len) == 0) {
+		list[list_size-1].num++;
+		return;
+	}
+	if (list_size == max_size) {
+		printf("max_size too small??\n");
+		exit(1);
+	}
+	list[list_size].txt = malloc(len+1);
+	list[list_size].len = len;
+	list[list_size].num = 1;
+	memcpy(list[list_size].txt, buf, len);
+	list[list_size].txt[len] = 0;
+	list_size++;
+	if (list_size % 1000 == 0) {
+		printf("loaded %d\r", list_size);
+		fflush(stdout);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	FILE *fin, *fout;
+	char buf[1024];
+	int ret, i, count;
+	struct block_list *list2;
+	struct stat st;
+
+	fin = fopen(argv[1], "r");
+	fout = fopen(argv[2], "w");
+	if (!fin || !fout) {
+		printf("Usage: ./program <input> <output>\n");
+		perror("open: ");
+		exit(2);
+	}
+
+	fstat(fileno(fin), &st);
+	max_size = st.st_size / 100; /* hack ... */
+
+	list = malloc(max_size * sizeof(*list));
+
+	for(;;) {
+		ret = read_block(buf, fin);
+		if (ret < 0)
+			break;
+
+		buf[ret] = '\0';
+		add_list(buf, ret);
+	}
+
+	printf("loaded %d\n", list_size);
+
+	printf("sorting ....\n");
+
+	qsort(list, list_size, sizeof(list[0]), compare_txt);
+
+	list2 = malloc(sizeof(*list) * list_size);
+
+	printf("culling\n");
+
+	for (i=count=0;i<list_size;i++) {
+		if (count == 0 ||
+		    strcmp(list2[count-1].txt, list[i].txt) != 0)
+			list2[count++] = list[i];
+		else
+			list2[count-1].num += list[i].num;
+	}
+
+	qsort(list2, count, sizeof(list[0]), compare_num);
+
+	for (i=0;i<count;i++) {
+		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
+	}
+	return 0;
+}
diff -puN fs/proc/Makefile~page-owner-tracking fs/proc/Makefile
--- a/fs/proc/Makefile~page-owner-tracking
+++ a/fs/proc/Makefile
@@ -24,6 +24,7 @@ proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysct
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
+proc-$(CONFIG_PROC_PAGEOWNER)	+= pageowner.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
diff -puN include/linux/mm_types.h~page-owner-tracking include/linux/mm_types.h
--- a/include/linux/mm_types.h~page-owner-tracking
+++ a/include/linux/mm_types.h
@@ -95,6 +95,12 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
+
+#ifdef CONFIG_PROC_PAGEOWNER
+	int order;
+	unsigned int gfp_mask;
+	unsigned long trace[8];
+#endif
 };
 
 /*
diff -puN lib/Kconfig.debug~page-owner-tracking lib/Kconfig.debug
--- a/lib/Kconfig.debug~page-owner-tracking
+++ a/lib/Kconfig.debug
@@ -66,6 +66,16 @@ config UNUSED_SYMBOLS
 	  you really need it, and what the merge plan to the mainline kernel for
 	  your module is.
 
+config PROC_PAGEOWNER
+	bool "Track page owner"
+	depends on DEBUG_KERNEL
+	help
+	  This keeps track of what call chain is the owner of a page, may
+	  help to find bare alloc_page(s) leaks. Eats a fair amount of memory.
+	  See Documentation/page_owner.c for user-space helper.
+
+	  If unsure, say N.
+
 config DEBUG_FS
 	bool "Debug Filesystem"
 	depends on SYSFS
diff -puN mm/page_alloc.c~page-owner-tracking mm/page_alloc.c
--- a/mm/page_alloc.c~page-owner-tracking
+++ a/mm/page_alloc.c
@@ -359,6 +359,9 @@ static inline void set_page_order(struct
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
+#ifdef CONFIG_PROC_PAGEOWNER
+		page->order = -1;
+#endif
 }
 
 static inline void rmv_page_order(struct page *page)
@@ -1458,6 +1461,62 @@ try_next_zone:
 	return page;
 }
 
+#ifdef CONFIG_PROC_PAGEOWNER
+static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
+{
+	return	p > (void *)tinfo &&
+		p < (void *)tinfo + THREAD_SIZE - 3;
+}
+
+static inline void __stack_trace(struct page *page, unsigned long *stack,
+			unsigned long bp)
+{
+	int i = 0;
+	unsigned long addr;
+	struct thread_info *tinfo = (struct thread_info *)
+		((unsigned long)stack & (~(THREAD_SIZE - 1)));
+
+	memset(page->trace, 0, sizeof(long) * 8);
+
+#ifdef CONFIG_FRAME_POINTER
+	if (bp) {
+		while (valid_stack_ptr(tinfo, (void *)bp)) {
+			addr = *(unsigned long *)(bp + sizeof(long));
+			page->trace[i] = addr;
+			if (++i >= 8)
+				break;
+			bp = *(unsigned long *)bp;
+		}
+		return;
+	}
+#endif /* CONFIG_FRAME_POINTER */
+	while (valid_stack_ptr(tinfo, stack)) {
+		addr = *stack++;
+		if (__kernel_text_address(addr)) {
+			page->trace[i] = addr;
+			if (++i >= 8)
+				break;
+		}
+	}
+}
+
+static void set_page_owner(struct page *page, unsigned int order,
+			unsigned int gfp_mask)
+{
+	unsigned long address;
+	unsigned long bp = 0;
+#ifdef CONFIG_X86_64
+	asm ("movq %%rbp, %0" : "=r" (bp) : );
+#endif
+#ifdef CONFIG_X86_32
+	asm ("movl %%ebp, %0" : "=r" (bp) : );
+#endif
+	page->order = (int) order;
+	page->gfp_mask = gfp_mask;
+	__stack_trace(page, &address, bp);
+}
+#endif /* CONFIG_PROC_PAGEOWNER */
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
@@ -1672,6 +1731,10 @@ nopage:
 		show_mem();
 	}
 got_pg:
+#ifdef CONFIG_PROC_PAGEOWNER
+	if (page)
+		set_page_owner(page, order, gfp_mask);
+#endif
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_internal);
@@ -2663,6 +2726,9 @@ void __meminit memmap_init_zone(unsigned
 		if (!is_highmem_idx(zone))
 			set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+#ifdef CONFIG_PROC_PAGEOWNER
+		page->order = -1;
+#endif
 	}
 }
 
diff -puN mm/vmstat.c~page-owner-tracking mm/vmstat.c
--- a/mm/vmstat.c~page-owner-tracking
+++ a/mm/vmstat.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
+#include "internal.h"
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -553,6 +554,97 @@ static int pagetypeinfo_showblockcount(s
 	return 0;
 }
 
+#ifdef CONFIG_PROC_PAGEOWNER
+static void pagetypeinfo_showmixedcount_print(struct seq_file *m,
+							pg_data_t *pgdat,
+							struct zone *zone)
+{
+	int mtype, pagetype;
+	unsigned long pfn;
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = start_pfn + zone->spanned_pages;
+	unsigned long count[MIGRATE_TYPES] = { 0, };
+
+	/* Align PFNs to pageblock_nr_pages boundary */
+	pfn = start_pfn & ~(pageblock_nr_pages-1);
+
+	/*
+	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
+	 * a zone boundary, it will be double counted between zones. This does
+	 * not matter as the mixed block count will still be correct
+	 */
+	for (; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+		unsigned long offset = 0;
+
+		/* Do not read before the zone start, use a valid page */
+		if (pfn < start_pfn)
+			offset = start_pfn - pfn;
+
+		if (!pfn_valid(pfn + offset))
+			continue;
+
+		page = pfn_to_page(pfn + offset);
+		mtype = get_pageblock_migratetype(page);
+
+		/* Check the block for bad migrate types */
+		for (; offset < pageblock_nr_pages; offset++) {
+			/* Do not past the end of the zone */
+			if (pfn + offset >= end_pfn)
+				break;
+
+			if (!pfn_valid_within(pfn + offset))
+				continue;
+
+			page = pfn_to_page(pfn + offset);
+
+			/* Skip free pages */
+			if (PageBuddy(page)) {
+				offset += (1UL << page_order(page)) - 1UL;
+				continue;
+			}
+			if (page->order < 0)
+				continue;
+
+			pagetype = allocflags_to_migratetype(page->gfp_mask);
+			if (pagetype != mtype) {
+				count[mtype]++;
+				break;
+			}
+
+			/* Move to end of this allocation */
+			offset += (1 << page->order) - 1;
+		}
+	}
+
+	/* Print counts */
+	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+		seq_printf(m, "%12lu ", count[mtype]);
+	seq_putc(m, '\n');
+}
+#endif /* CONFIG_PROC_PAGEOWNER */
+
+/*
+ * Print out the number of pageblocks for each migratetype that contain pages
+ * of other types. This gives an indication of how well fallbacks are being
+ * contained by rmqueue_fallback(). It requires information from PAGE_OWNER
+ * to determine what is going on
+ */
+static void pagetypeinfo_showmixedcount(struct seq_file *m, pg_data_t *pgdat)
+{
+#ifdef CONFIG_PROC_PAGEOWNER
+	int mtype;
+
+	seq_printf(m, "\n%-23s", "Number of mixed blocks ");
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+		seq_printf(m, "%12s ", migratetype_names[mtype]);
+	seq_putc(m, '\n');
+
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showmixedcount_print);
+#endif /* CONFIG_PROC_PAGEOWNER */
+}
+
 /*
  * This prints out statistics in relation to grouping pages by mobility.
  * It is expensive to collect so do not constantly read the file.
@@ -570,6 +662,7 @@ static int pagetypeinfo_show(struct seq_
 	seq_putc(m, '\n');
 	pagetypeinfo_showfree(m, pgdat);
 	pagetypeinfo_showblockcount(m, pgdat);
+	pagetypeinfo_showmixedcount(m, pgdat);
 
 	return 0;
 }
_

Patches currently in -mm which might be from alexn@dsv.su.se are

page-owner-tracking.patch

