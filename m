From: akpm@linux-foundation.org
Subject: [alternative-merged] debugging-keep-track-of-page-owners.patch
 removed from -mm tree
Date: Tue, 25 Nov 2014 12:28:05 -0800
Message-ID: <5474e655.TPXNYH1CytqD8wav%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaKYU2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 15:28:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexn@dsv.su.se, akpm@linux-foundation.org, apw@shadowen.org, cl@linux-foundation.org, dave@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, lauraa@codeaurora.org, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org, mingo@elte.hu, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: debugging: keep track of page owners
has been removed from the -mm tree.  Its filename was
     debugging-keep-track-of-page-owners.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Alexander Nyberg <alexn@dsv.su.se>
Subject: debugging: keep track of page owners

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
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: debugging-keep-track-of-page-owners-fix

Updated 12/4/2012 - should apply to 3.7 kernels.  I did a quick
sniff-test to make sure that this boots and produces some sane
output, but it's not been exhaustively tested.

 * Moved file over to debugfs (no reason to keep polluting /proc)
 * Now using generic stack tracking infrastructure
 * Added check for MIGRATE_CMA pages to explicitly count them
   as movable.

The new snprint_stack_trace() probably belongs in its own patch
if this were to get merged, but it won't kill anyone as it stands.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Laura Abbott <lauraa@codeaurora.org>
From: Minchan Kim <minchan@kernel.org>
Subject: Fix wrong EOF compare

The C standards allows the character type char to be singed or unsinged,
depending on the platform and compiler. Most of systems uses signed char,
but those based on PowerPC and ARM processors typically use unsigned char.
This can lead to unexpected results when the variable is used to compare
with EOF(-1). It happens my ARM system and this patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debugging-keep-track-of-page-owners-fix-2-fix

Reduce scope of `val', fix coding style

Cc: Minchan Kim <minchan@kernel.org>
From: Minchan Kim <minchan@kernel.org>
Subject: Enhance read_block of page_owner.c

The read_block reads char one by one until meeting two newline.
It's not good for the performance and current code isn't good shape
for readability.

This patch enhances speed and clean up.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support-fix

stomp sparse gfp_t warnings

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: PAGE_OWNER now depends on STACKTRACE_SUPPORT

One of the enhancements I made to the PAGE_OWNER code was to make
it use the generic stack trace support.  However, there are some
architectures that do not support it, like m68k.  So, make
PAGE_OWNER also depend on having STACKTRACE_SUPPORT.

This isn't ideal since it restricts the number of places
PAGE_OWNER runs now, but it at least hits all the major
architectures.

tree:   git://git.cmpxchg.org/linux-mmotm.git master
head:   83b324c5ff5cca85bbeb2ba913d465f108afe472
commit: 2a561c9d47c295ed91984c2b916a4dd450ee0279 [484/499] debugging-keep-track-of-page-owners-fix
config: make ARCH=m68k allmodconfig

All warnings:

warning: (PAGE_OWNER && STACK_TRACER && BLK_DEV_IO_TRACE && KMEMCHECK) selects STACKTRACE which has unmet direct dependencies (STACKTRACE_SUPPORT)

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |  134 ++++++++++++++++++++++++++++
 include/linux/mm_types.h   |    7 +
 include/linux/stacktrace.h |    3 
 kernel/stacktrace.c        |   23 ++++
 lib/Kconfig.debug          |   12 ++
 mm/Makefile                |    1 
 mm/page_alloc.c            |   29 ++++++
 mm/pageowner.c             |  163 +++++++++++++++++++++++++++++++++++
 mm/vmstat.c                |   95 ++++++++++++++++++++
 9 files changed, 467 insertions(+)

diff -puN /dev/null Documentation/page_owner.c
--- /dev/null
+++ a/Documentation/page_owner.c
@@ -0,0 +1,134 @@
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
+int read_block(char *buf, int buf_size, FILE *fin)
+{
+	char *curr = buf, *const buf_end = buf + buf_size;
+
+	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
+		if (*curr == '\n') /* empty line */
+			return curr - buf;
+		curr += strlen(curr);
+	}
+
+	return -1; /* EOF or no space left in buf. */
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
+#define BUF_SIZE	1024
+
+int main(int argc, char **argv)
+{
+	FILE *fin, *fout;
+	char buf[BUF_SIZE];
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
+		ret = read_block(buf, BUF_SIZE, fin);
+		if (ret < 0)
+			break;
+
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
@@ -8,6 +8,7 @@
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
+#include <linux/stacktrace.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
@@ -201,6 +202,12 @@ struct page {
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 	int _last_cpupid;
 #endif
+#ifdef CONFIG_PAGE_OWNER
+	int order;
+	gfp_t gfp_mask;
+	struct stack_trace trace;
+	unsigned long trace_entries[8];
+#endif
 }
 /*
  * The struct page can be forced to be double word aligned so that atomic ops
diff -puN include/linux/stacktrace.h~debugging-keep-track-of-page-owners include/linux/stacktrace.h
--- a/include/linux/stacktrace.h~debugging-keep-track-of-page-owners
+++ a/include/linux/stacktrace.h
@@ -20,6 +20,8 @@ extern void save_stack_trace_tsk(struct
 				struct stack_trace *trace);
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
+extern int  snprint_stack_trace(char *buf, int buf_len,
+				struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
@@ -32,6 +34,7 @@ extern void save_stack_trace_user(struct
 # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
 # define save_stack_trace_user(trace)			do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
+# define snprint_stack_trace(buf, len, trace, spaces)	do { } while (0)
 #endif
 
 #endif
diff -puN kernel/stacktrace.c~debugging-keep-track-of-page-owners kernel/stacktrace.c
--- a/kernel/stacktrace.c~debugging-keep-track-of-page-owners
+++ a/kernel/stacktrace.c
@@ -11,6 +11,29 @@
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 
+int snprint_stack_trace(char *buf, int buf_len, struct stack_trace *trace,
+			int spaces)
+{
+	int ret = 0;
+	int i;
+
+	if (WARN_ON(!trace->entries))
+		return 0;
+
+	for (i = 0; i < trace->nr_entries; i++) {
+		unsigned long ip = trace->entries[i];
+		int printed = snprintf(buf, buf_len, "%*c[<%p>] %pS\n",
+				1 + spaces, ' ',
+				(void *) ip, (void *) ip);
+		buf_len -= printed;
+		ret += printed;
+		buf += printed;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snprint_stack_trace);
+
 void print_stack_trace(struct stack_trace *trace, int spaces)
 {
 	int i;
diff -puN lib/Kconfig.debug~debugging-keep-track-of-page-owners lib/Kconfig.debug
--- a/lib/Kconfig.debug~debugging-keep-track-of-page-owners
+++ a/lib/Kconfig.debug
@@ -227,6 +227,18 @@ config UNUSED_SYMBOLS
 	  you really need it, and what the merge plan to the mainline kernel for
 	  your module is.
 
+config PAGE_OWNER
+	bool "Track page owner"
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
+	select DEBUG_FS
+	select STACKTRACE
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
@@ -63,6 +63,7 @@ obj-$(CONFIG_MEMORY_FAILURE) += memory-f
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_PAGE_OWNER) += pageowner.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
 obj-$(CONFIG_ZPOOL)	+= zpool.o
diff -puN mm/page_alloc.c~debugging-keep-track-of-page-owners mm/page_alloc.c
--- a/mm/page_alloc.c~debugging-keep-track-of-page-owners
+++ a/mm/page_alloc.c
@@ -469,6 +469,9 @@ static inline void set_page_order(struct
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
+#ifdef CONFIG_PAGE_OWNER
+	page->order = -1;
+#endif
 }
 
 static inline void rmv_page_order(struct page *page)
@@ -2428,6 +2431,22 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 	return progress;
 }
 
+static void
+set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
+{
+#ifdef CONFIG_PAGE_OWNER
+	struct stack_trace *trace = &page->trace;
+	trace->nr_entries = 0;
+	trace->max_entries = ARRAY_SIZE(page->trace_entries);
+	trace->entries = &page->trace_entries[0];
+	trace->skip = 3;
+	save_stack_trace(&page->trace);
+
+	page->order = (int) order;
+	page->gfp_mask = gfp_mask;
+#endif /* CONFIG_PAGE_OWNER */
+}
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -2464,6 +2483,8 @@ retry:
 		goto retry;
 	}
 
+	if (page)
+		set_page_owner(page, order, gfp_mask);
 	return page;
 }
 
@@ -2795,6 +2816,8 @@ nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
 	return page;
 got_pg:
+	if (page)
+		set_page_owner(page, order, gfp_mask);
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
 
@@ -2877,6 +2900,9 @@ out:
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
+	if (page)
+		set_page_owner(page, order, gfp_mask);
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -4169,6 +4195,9 @@ void __meminit memmap_init_zone(unsigned
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
@@ -0,0 +1,163 @@
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
+	char *kbuf;
+	int ret = 0;
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
+		if (page->order >= 0 && page->trace.nr_entries) {
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
+	ret = snprint_stack_trace(kbuf + num_written, count - num_written,
+				  &page->trace, 0);
+	if (ret >= count - num_written) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	num_written += ret;
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
@@ -1018,6 +1018,100 @@ static int pagetypeinfo_showblockcount(s
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
+				if (is_migrate_cma(pagetype))
+					count[MIGRATE_MOVABLE]++;
+				else
+					count[mtype]++;
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
@@ -1035,6 +1129,7 @@ static int pagetypeinfo_show(struct seq_
 	seq_putc(m, '\n');
 	pagetypeinfo_showfree(m, pgdat);
 	pagetypeinfo_showblockcount(m, pgdat);
+	pagetypeinfo_showmixedcount(m, pgdat);
 
 	return 0;
 }
_

Patches currently in -mm which might be from alexn@dsv.su.se are

mm-page_owner-keep-track-of-page-owners.patch

