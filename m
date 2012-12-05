From: akpm@linux-foundation.org
Subject: + debugging-keep-track-of-page-owners.patch added to -mm tree
Date: Wed, 05 Dec 2012 14:45:14 -0800
Message-ID: <20121205224514.C16F0820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55423 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LEWpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2012 17:45:16 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so569315vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Dec 2012 14:45:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexn@dsv.su.se, apw@shadowen.org, cl@linux-foundation.org, lauraa@codeaurora.org, mel@csn.ul.ie, mingo@elte.hu


The patch titled
     Subject: debugging: meep track of page owners
has been added to the -mm tree.  Its filename is
     debugging-keep-track-of-page-owners.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Nyberg <alexn@dsv.su.se>
Subject: debugging: meep track of page owners

akpm: Alex's ancient page-owner tracking code, resurrected yet
      again.  Someone(tm) should mainline this.  Please see Ingo's
      thoughts at https://lkml.org/lkml/2009/4/1/137.

PAGE_OWNER tracks free pages by setting page->order to -1.  However, it is
set during __free_pages() which is not the only free path as
__pagevec_free() and free_compound_page() do not go through __free_pages().
 This leads to a situation where free pages are visible in page_owner
which is confusing and might be interpreted as a memory leak.

This patch sets page->owner when PageBuddy is set.  It also prints a
warning to the kernel log if a free page is found that does not appear free
to PAGE_OWNER.  This should be considered a fix to
page-owner-tracking-leak-detector.patch.

This only applies to -mm as PAGE_OWNER is not in mainline.

[mel@csn.ul.ie: print out PAGE_OWNER statistics in relation to fragmentation avoidance]
[mel.ul.ie: allow PAGE_OWNER to be set on any architecture]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |  141 ++++++++++++++++++++++++++++
 include/linux/mm_types.h   |    5 +
 lib/Kconfig.debug          |   11 ++
 mm/Makefile                |    1 
 mm/page_alloc.c            |   76 +++++++++++++++
 mm/pageowner.c             |  174 +++++++++++++++++++++++++++++++++++
 mm/vmstat.c                |   93 ++++++++++++++++++
 7 files changed, 501 insertions(+)

diff -puN /dev/null Documentation/page_owner.c
--- /dev/null
+++ a/Documentation/page_owner.c
@@ -0,0 +1,141 @@
+/*
+ * User-space helper to sort the output of /sys/kernel/debug/page_owner
+ *
+ * Example use:
+ * cat /sys/kernel/debug/page_owner > page_owner_full.txt
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
+static int compare_txt(struct block_list *l1, struct block_list *l2)
+{
+	return strcmp(l1->txt, l2->txt);
+}
+
+static int compare_num(struct block_list *l1, struct block_list *l2)
+{
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
+		    strcmp(list2[count-1].txt, list[i].txt) != 0) {
+			list2[count++] = list[i];
+		} else {
+			list2[count-1].num += list[i].num;
+		}
+	}
+
+	qsort(list2, count, sizeof(list[0]), compare_num);
+
+	for (i=0;i<count;i++) {
+		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
+	}
+	return 0;
+}
diff -puN include/linux/mm_types.h~debugging-keep-track-of-page-owners include/linux/mm_types.h
--- a/include/linux/mm_types.h~debugging-keep-track-of-page-owners
+++ a/include/linux/mm_types.h
@@ -177,6 +177,11 @@ struct page {
 #ifdef LAST_CPU_NOT_IN_PAGE_FLAGS
 	int _last_cpu;
 #endif
+#ifdef CONFIG_PAGE_OWNER
+	int order;
+	unsigned int gfp_mask;
+	unsigned long trace[8];
+#endif
 }
 /*
  * The struct page can be forced to be double word aligned so that atomic ops
diff -puN lib/Kconfig.debug~debugging-keep-track-of-page-owners lib/Kconfig.debug
--- a/lib/Kconfig.debug~debugging-keep-track-of-page-owners
+++ a/lib/Kconfig.debug
@@ -99,6 +99,17 @@ config UNUSED_SYMBOLS
 	  you really need it, and what the merge plan to the mainline kernel for
 	  your module is.
 
+config PAGE_OWNER
+	bool "Track page owner"
+	depends on DEBUG_KERNEL
+	select DEBUG_FS
+	help
+	  This keeps track of what call chain is the owner of a page, may
+	  help to find bare alloc_page(s) leaks. Eats a fair amount of memory.
+	  See Documentation/page_owner.c for user-space helper.
+
+	  If unsure, say N.
+
 config DEBUG_FS
 	bool "Debug Filesystem"
 	help
diff -puN mm/Makefile~debugging-keep-track-of-page-owners mm/Makefile
--- a/mm/Makefile~debugging-keep-track-of-page-owners
+++ a/mm/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
+obj-$(CONFIG_PAGE_OWNER) += pageowner.o
diff -puN mm/page_alloc.c~debugging-keep-track-of-page-owners mm/page_alloc.c
--- a/mm/page_alloc.c~debugging-keep-track-of-page-owners
+++ a/mm/page_alloc.c
@@ -439,6 +439,9 @@ static inline void set_page_order(struct
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
+#ifdef CONFIG_PAGE_OWNER
+	page->order = -1;
+#endif
 }
 
 static inline void rmv_page_order(struct page *page)
@@ -2264,6 +2267,63 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 	return progress;
 }
 
+#ifdef CONFIG_PAGE_OWNER
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
+#endif /* CONFIG_PAGE_OWNER */
+
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -2299,6 +2359,10 @@ retry:
 		goto retry;
 	}
 
+#ifdef CONFIG_PAGE_OWNER
+	if (page)
+		set_page_owner(page, order, gfp_mask);
+#endif
 	return page;
 }
 
@@ -2608,6 +2672,10 @@ nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
 	return page;
 got_pg:
+#ifdef CONFIG_PAGE_OWNER
+	if (page)
+		set_page_owner(page, order, gfp_mask);
+#endif
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
 
@@ -2690,6 +2758,11 @@ out:
 
 	memcg_kmem_commit_charge(page, memcg, order);
 
+#ifdef CONFIG_PAGE_OWNER
+	if (page)
+		set_page_owner(page, order, gfp_mask);
+#endif
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -3962,6 +4035,9 @@ void __meminit memmap_init_zone(unsigned
 		if (!is_highmem_idx(zone))
 			set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+#ifdef CONFIG_PAGE_OWNER
+		page->order = -1;
+#endif
 	}
 }
 
diff -puN /dev/null mm/pageowner.c
--- /dev/null
+++ a/mm/pageowner.c
@@ -0,0 +1,174 @@
+#include <linux/debugfs.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/huge_mm.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
+#include <linux/highmem.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/mempolicy.h>
+#include <linux/rmap.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+
+#include <asm/elf.h>
+#include <asm/uaccess.h>
+#include <asm/tlbflush.h>
+#include "internal.h"
+
+#include <linux/bootmem.h>
+#include <linux/kallsyms.h>
+
+static ssize_t
+read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned long pfn;
+	struct page *page;
+	char *kbuf, *modname;
+	const char *symname;
+	int ret = 0;
+	char namebuf[128];
+	unsigned long offset = 0, symsize;
+	int i;
+	ssize_t num_written = 0;
+	int blocktype = 0, pagetype = 0;
+
+	page = NULL;
+	pfn = min_low_pfn + *ppos;
+
+	/* Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area */
+	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
+		pfn++;
+
+	//printk("pfn: %ld max_pfn: %ld\n", pfn, max_pfn);
+	/* Find an allocated page */
+	for (; pfn < max_pfn; pfn++) {
+		/*
+		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
+		 * validate the area as existing, skip it if not
+		 */
+		if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0 && !pfn_valid(pfn)) {
+			pfn += MAX_ORDER_NR_PAGES - 1;
+			continue;
+		}
+
+		/* Check for holes within a MAX_ORDER area */
+		if (!pfn_valid_within(pfn))
+			continue;
+
+		page = pfn_to_page(pfn);
+
+		/* Catch situations where free pages have a bad ->order  */
+		if (page->order >= 0 && PageBuddy(page))
+			printk(KERN_WARNING
+				"PageOwner info inaccurate for PFN %lu\n",
+				pfn);
+
+		/* Stop search if page is allocated and has trace info */
+		if (page->order >= 0 && page->trace[0]) {
+			//intk("stopped search at pfn: %ld\n", pfn);
+			break;
+		}
+	}
+
+	if (!pfn_valid(pfn))
+		return 0;
+	/*
+	 * If memory does not end at a SECTION_SIZE boundary, then
+	 * we might have a pfn_valid() above max_pfn
+	 */
+	if (pfn >= max_pfn)
+		return 0;
+
+	/* Record the next PFN to read in the file offset */
+	*ppos = (pfn - min_low_pfn) + 1;
+
+	kbuf = kmalloc(count, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	//printk("page: %p\n", page);
+	ret = snprintf(kbuf, count, "Page allocated via order %d, mask 0x%x\n",
+			page->order, page->gfp_mask);
+	if (ret >= count) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Print information relevant to grouping pages by mobility */
+	blocktype = get_pageblock_migratetype(page);
+	pagetype  = allocflags_to_migratetype(page->gfp_mask);
+	ret += snprintf(kbuf+ret, count-ret,
+			"PFN %lu Block %lu type %d %s "
+			"Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
+			pfn,
+			pfn >> pageblock_order,
+			blocktype,
+			blocktype != pagetype ? "Fallback" : "        ",
+			PageLocked(page)	? "K" : " ",
+			PageError(page)		? "E" : " ",
+			PageReferenced(page)	? "R" : " ",
+			PageUptodate(page)	? "U" : " ",
+			PageDirty(page)		? "D" : " ",
+			PageLRU(page)		? "L" : " ",
+			PageActive(page)	? "A" : " ",
+			PageSlab(page)		? "S" : " ",
+			PageWriteback(page)	? "W" : " ",
+			PageCompound(page)	? "C" : " ",
+			PageSwapCache(page)	? "B" : " ",
+			PageMappedToDisk(page)	? "M" : " ");
+	if (ret >= count) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	num_written = ret;
+
+	for (i = 0; i < 8; i++) {
+		if (!page->trace[i])
+			break;
+		symname = kallsyms_lookup(page->trace[i], &symsize, &offset,
+					&modname, namebuf);
+		ret = snprintf(kbuf + num_written, count - num_written,
+				"[0x%lx] %s+%lu\n",
+				page->trace[i], namebuf, offset);
+		if (ret >= count - num_written) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		num_written += ret;
+	}
+
+	ret = snprintf(kbuf + num_written, count - num_written, "\n");
+	if (ret >= count - num_written) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	num_written += ret;
+	ret = num_written;
+
+	if (copy_to_user(buf, kbuf, ret))
+		ret = -EFAULT;
+out:
+	kfree(kbuf);
+	return ret;
+}
+
+static struct file_operations proc_page_owner_operations = {
+	.read		= read_page_owner,
+};
+
+static int __init pageowner_init(void)
+{
+	struct dentry *dentry;
+
+	dentry = debugfs_create_file("page_owner", S_IRUSR, NULL,
+			NULL, &proc_page_owner_operations);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	return 0;
+}
+module_init(pageowner_init)
diff -puN mm/vmstat.c~debugging-keep-track-of-page-owners mm/vmstat.c
--- a/mm/vmstat.c~debugging-keep-track-of-page-owners
+++ a/mm/vmstat.c
@@ -19,6 +19,7 @@
 #include <linux/math64.h>
 #include <linux/writeback.h>
 #include <linux/compaction.h>
+#include "internal.h"
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -930,6 +931,97 @@ static int pagetypeinfo_showblockcount(s
 	return 0;
 }
 
+#ifdef CONFIG_PAGE_OWNER
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
+#endif /* CONFIG_PAGE_OWNER */
+
+/*
+ * Print out the number of pageblocks for each migratetype that contain pages
+ * of other types. This gives an indication of how well fallbacks are being
+ * contained by rmqueue_fallback(). It requires information from PAGE_OWNER
+ * to determine what is going on
+ */
+static void pagetypeinfo_showmixedcount(struct seq_file *m, pg_data_t *pgdat)
+{
+#ifdef CONFIG_PAGE_OWNER
+	int mtype;
+
+	seq_printf(m, "\n%-23s", "Number of mixed blocks ");
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+		seq_printf(m, "%12s ", migratetype_names[mtype]);
+	seq_putc(m, '\n');
+
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showmixedcount_print);
+#endif /* CONFIG_PAGE_OWNER */
+}
+
 /*
  * This prints out statistics in relation to grouping pages by mobility.
  * It is expensive to collect so do not constantly read the file.
@@ -947,6 +1039,7 @@ static int pagetypeinfo_show(struct seq_
 	seq_putc(m, '\n');
 	pagetypeinfo_showfree(m, pgdat);
 	pagetypeinfo_showblockcount(m, pgdat);
+	pagetypeinfo_showmixedcount(m, pgdat);
 
 	return 0;
 }
_

Patches currently in -mm which might be from alexn@dsv.su.se are

debugging-keep-track-of-page-owners.patch

