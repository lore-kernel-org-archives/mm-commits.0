From: akpm@linux-foundation.org
Subject: - readahead-events-accounting.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:44 -0700
Message-ID: <200705080813.l488DiKY018930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934618AbXEHIOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: events accounting
has been removed from the -mm tree.  Its filename was
     readahead-events-accounting.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: events accounting
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

A debugfs file named `readahead/events' is created according to advises from
Joern Engel, Andrew Morton and Ingo Oeser.

It reveals various read-ahead activities/events, and is vital to the testing.

If you are experiencing performance problems, or want to help improve the
read-ahead logic, please send me the debug data. Thanks.

- Preparations

## First compile kernel with CONFIG_DEBUG_READAHEAD
mkdir /debug
mount -t debug none /debug

- For each session with distinct access pattern

echo > /debug/readahead/events # reset the counters
# echo > /var/log/kern.log # you may want to backup it first
# echo 3 > /debug/readahead/debug_level # show verbose printk traces
## do one benchmark/task
# echo 1 > /debug/readahead/debug_level # revert to normal value
cp /debug/readahead/events readahead-events-`date +'%F_%R'`
# bzip2 -c /var/log/kern.log > kern.log-`date +'%F_%R'`.bz2

The commented out commands can uncover more detailed file accesses,
which are useful sometimes. Note that the log file can grow huge!

[bunk@stusta.de: make readahead_debug_level static]
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |  280 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 279 insertions(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-events-accounting mm/readahead.c
--- a/mm/readahead.c~readahead-events-accounting
+++ a/mm/readahead.c
@@ -31,6 +31,66 @@ EXPORT_SYMBOL(default_unplug_io_fn);
 #define MAX_RA_PAGES	(VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
 #define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
 
+/*
+ * Detailed classification of read-ahead behaviors.
+ */
+#define RA_CLASS_SHIFT 4
+#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
+enum ra_class {
+	RA_CLASS_ALL,
+	RA_CLASS_INITIAL,
+	RA_CLASS_STATE,
+	RA_CLASS_CONTEXT,
+	RA_CLASS_CONTEXT_AGGRESSIVE,
+	RA_CLASS_BACKWARD,
+	RA_CLASS_THRASHING,
+	RA_CLASS_NONE,
+	RA_CLASS_COUNT
+};
+
+/* Read-ahead events to be accounted. */
+enum ra_event {
+	RA_EVENT_CACHE_MISS,		/* read cache misses */
+	RA_EVENT_RANDOM_READ,		/* random reads */
+	RA_EVENT_IO_CONGESTION,		/* i/o congestion */
+	RA_EVENT_IO_CACHE_HIT,		/* canceled i/o due to cache hit */
+	RA_EVENT_IO_BLOCK,		/* wait for i/o completion */
+
+	RA_EVENT_READAHEAD,		/* read-ahead issued */
+	RA_EVENT_READAHEAD_HIT,		/* read-ahead page hit */
+	RA_EVENT_LOOKAHEAD,		/* look-ahead issued */
+	RA_EVENT_LOOKAHEAD_HIT,		/* look-ahead mark hit */
+	RA_EVENT_LOOKAHEAD_NOACTION,	/* look-ahead mark ignored */
+	RA_EVENT_READAHEAD_MMAP,	/* read-ahead for mmap access */
+	RA_EVENT_READAHEAD_EOF,		/* read-ahead reaches EOF */
+	RA_EVENT_READAHEAD_SHRINK,	/* ra_size falls under previous la_size */
+	RA_EVENT_READAHEAD_THRASHING,	/* read-ahead thrashing happened */
+	RA_EVENT_READAHEAD_MUTILATE,	/* read-ahead mutilated by imbalanced aging */
+	RA_EVENT_READAHEAD_RESCUE,	/* read-ahead rescued */
+
+	RA_EVENT_READAHEAD_CUBE,
+	RA_EVENT_COUNT
+};
+
+#ifdef CONFIG_DEBUG_READAHEAD
+static u32 readahead_debug_level = 1;
+static u32 disable_stateful_method;
+static const char * const ra_class_name[];
+static void ra_account(struct file_ra_state *ra, enum ra_event e, int pages);
+#  define debug_inc(var)		do { var++; } while (0)
+#  define debug_option(o)		(o)
+#else
+#  define ra_account(ra, e, pages)	do { } while (0)
+#  define debug_inc(var)		do { } while (0)
+#  define debug_option(o)		(0)
+#  define readahead_debug_level 	(0)
+#endif /* CONFIG_DEBUG_READAHEAD */
+
+#define dprintk(args...) \
+	do { if (readahead_debug_level >= 2) printk(KERN_DEBUG args); } while(0)
+#define ddprintk(args...) \
+	do { if (readahead_debug_level >= 3) printk(KERN_DEBUG args); } while(0)
+
 struct backing_dev_info default_backing_dev_info = {
 	.ra_pages	= MAX_RA_PAGES,
 	.state		= 0,
@@ -364,6 +424,9 @@ int force_page_cache_readahead(struct ad
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
 	}
+
+	ra_account(NULL, RA_EVENT_READAHEAD, ret);
+
 	return ret;
 }
 
@@ -399,10 +462,16 @@ static inline int check_ra_success(struc
 int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read)
 {
+	unsigned long ret;
+
 	if (bdi_read_congested(mapping->backing_dev_info))
 		return -1;
 
-	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
+	ret = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
+
+	ra_account(NULL, RA_EVENT_READAHEAD, ret);
+
+	return ret;
 }
 
 /*
@@ -424,6 +493,10 @@ blockable_page_cache_readahead(struct ad
 
 	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
+	ra_account(NULL, RA_EVENT_READAHEAD, actual);
+	dprintk("blockable-readahead(ino=%lu, ra=%lu+%lu) = %d\n",
+			mapping->host->i_ino, offset, nr_to_read, actual);
+
 	return check_ra_success(ra, nr_to_read, actual);
 }
 
@@ -599,3 +672,208 @@ unsigned long max_sane_readahead(unsigne
 	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
+
+/*
+ * Read-ahead events accounting.
+ */
+#ifdef CONFIG_DEBUG_READAHEAD
+
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static const char * const ra_class_name[] = {
+	"total",
+	"initial",
+	"state",
+	"context",
+	"contexta",
+	"backward",
+	"onthrash",
+	"none"
+};
+
+static const char * const ra_event_name[] = {
+	"cache_miss",
+	"random_read",
+	"io_congestion",
+	"io_cache_hit",
+	"io_block",
+	"readahead",
+	"readahead_hit",
+	"lookahead",
+	"lookahead_hit",
+	"lookahead_ignore",
+	"readahead_mmap",
+	"readahead_eof",
+	"readahead_shrink",
+	"readahead_thrash",
+	"readahead_mutilt",
+	"readahead_rescue"
+};
+
+static unsigned long ra_events[RA_CLASS_COUNT][RA_EVENT_COUNT][2];
+
+static void ra_account(struct file_ra_state *ra, enum ra_event e, int pages)
+{
+	enum ra_class c;
+
+	if (!readahead_debug_level)
+		return;
+
+	if (e == RA_EVENT_READAHEAD_HIT && pages < 0) {
+		c = (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
+		pages = -pages;
+	} else if (ra)
+		c = ra->flags & RA_CLASS_MASK;
+	else
+		c = RA_CLASS_NONE;
+
+	if (!c)
+		c = RA_CLASS_NONE;
+
+	ra_events[c][e][0] += 1;
+	ra_events[c][e][1] += pages;
+
+	if (e == RA_EVENT_READAHEAD)
+		ra_events[c][RA_EVENT_READAHEAD_CUBE][1] += pages * pages;
+}
+
+static int ra_events_show(struct seq_file *s, void *_)
+{
+	int i;
+	int c;
+	int e;
+	static const char event_fmt[] = "%-16s";
+	static const char class_fmt[] = "%10s";
+	static const char item_fmt[] = "%10lu";
+	static const char percent_format[] = "%9lu%%";
+	static const char * const table_name[] = {
+		"[table requests]",
+		"[table pages]",
+		"[table summary]"};
+
+	for (i = 0; i <= 1; i++) {
+		for (e = 0; e < RA_EVENT_COUNT; e++) {
+			ra_events[RA_CLASS_ALL][e][i] = 0;
+			for (c = RA_CLASS_INITIAL; c < RA_CLASS_NONE; c++)
+				ra_events[RA_CLASS_ALL][e][i] += ra_events[c][e][i];
+		}
+
+		seq_printf(s, event_fmt, table_name[i]);
+		for (c = 0; c < RA_CLASS_COUNT; c++)
+			seq_printf(s, class_fmt, ra_class_name[c]);
+		seq_puts(s, "\n");
+
+		for (e = 0; e < RA_EVENT_COUNT; e++) {
+			if (e == RA_EVENT_READAHEAD_CUBE)
+				continue;
+			if (e == RA_EVENT_READAHEAD_HIT && i == 0)
+				continue;
+			if (e == RA_EVENT_IO_BLOCK && i == 1)
+				continue;
+
+			seq_printf(s, event_fmt, ra_event_name[e]);
+			for (c = 0; c < RA_CLASS_COUNT; c++)
+				seq_printf(s, item_fmt, ra_events[c][e][i]);
+			seq_puts(s, "\n");
+		}
+		seq_puts(s, "\n");
+	}
+
+	seq_printf(s, event_fmt, table_name[2]);
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, class_fmt, ra_class_name[c]);
+	seq_puts(s, "\n");
+
+	seq_printf(s, event_fmt, "random_rate");
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, percent_format,
+			(ra_events[c][RA_EVENT_RANDOM_READ][0] * 100) /
+			((ra_events[c][RA_EVENT_RANDOM_READ][0] +
+			  ra_events[c][RA_EVENT_READAHEAD][0]) | 1));
+	seq_puts(s, "\n");
+
+	seq_printf(s, event_fmt, "ra_hit_rate");
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, percent_format,
+			(ra_events[c][RA_EVENT_READAHEAD_HIT][1] * 100) /
+			(ra_events[c][RA_EVENT_READAHEAD][1] | 1));
+	seq_puts(s, "\n");
+
+	seq_printf(s, event_fmt, "la_hit_rate");
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, percent_format,
+			(ra_events[c][RA_EVENT_LOOKAHEAD_HIT][0] * 100) /
+			(ra_events[c][RA_EVENT_LOOKAHEAD][0] | 1));
+	seq_puts(s, "\n");
+
+	seq_printf(s, event_fmt, "var_ra_size");
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, item_fmt,
+			(ra_events[c][RA_EVENT_READAHEAD_CUBE][1] -
+			 ra_events[c][RA_EVENT_READAHEAD][1] *
+			(ra_events[c][RA_EVENT_READAHEAD][1] /
+			(ra_events[c][RA_EVENT_READAHEAD][0] | 1))) /
+			(ra_events[c][RA_EVENT_READAHEAD][0] | 1));
+	seq_puts(s, "\n");
+
+	seq_printf(s, event_fmt, "avg_ra_size");
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, item_fmt,
+			(ra_events[c][RA_EVENT_READAHEAD][1] +
+			 ra_events[c][RA_EVENT_READAHEAD][0] / 2) /
+			(ra_events[c][RA_EVENT_READAHEAD][0] | 1));
+	seq_puts(s, "\n");
+
+	seq_printf(s, event_fmt, "avg_la_size");
+	for (c = 0; c < RA_CLASS_COUNT; c++)
+		seq_printf(s, item_fmt,
+			(ra_events[c][RA_EVENT_LOOKAHEAD][1] +
+			 ra_events[c][RA_EVENT_LOOKAHEAD][0] / 2) /
+			(ra_events[c][RA_EVENT_LOOKAHEAD][0] | 1));
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+static int ra_events_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ra_events_show, NULL);
+}
+
+static ssize_t ra_events_write(struct file *file, const char __user *buf,
+						size_t size, loff_t *offset)
+{
+	memset(ra_events, 0, sizeof(ra_events));
+	return 1;
+}
+
+static struct file_operations ra_events_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ra_events_open,
+	.write		= ra_events_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init readahead_init(void)
+{
+	struct dentry *root;
+
+	root = debugfs_create_dir("readahead", NULL);
+
+	debugfs_create_file("events", 0644, root, NULL, &ra_events_fops);
+
+	debugfs_create_u32("debug_level", 0644, root, &readahead_debug_level);
+	debugfs_create_bool("disable_stateful_method", 0644, root,
+			    &disable_stateful_method);
+
+	return 0;
+}
+
+module_init(readahead_init)
+
+#endif /* CONFIG_DEBUG_READAHEAD */
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
