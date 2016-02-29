From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-add-freeable-column-to-pool-stat.patch added to -mm tree
Date: Mon, 29 Feb 2016 15:12:24 -0800
Message-ID: <56d4d058.oW1ncOPbIYcKSMjB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbcB2XMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 18:12:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add `freeable' column to pool stat
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-add-freeable-column-to-pool-stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-add-freeable-column-to-pool-stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-add-freeable-column-to-pool-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm/zsmalloc: add `freeable' column to pool stat

Add a new column to pool stats, which will tell how many pages ideally can
be freed by class compaction, so it will be easier to analyze zsmalloc
fragmentation.

At the moment, we have only numbers of FULL and ALMOST_EMPTY classes, but
they don't tell us how badly the class is fragmented internally.

The new /sys/kernel/debug/zsmalloc/zramX/classes output look as follows:

 class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
[..]
    12   224           0            2           146          5          8                4        4
    13   240           0            0             0          0          0                1        0
    14   256           1           13          1840       1672        115                1       10
    15   272           0            0             0          0          0                1        0
[..]
    49   816           0            3           745        735        149                1        2
    51   848           3            4           361        306         76                4        8
    52   864          12           14           378        268         81                3       21
    54   896           1           12           117         57         26                2       12
    57   944           0            0             0          0          0                3        0
[..]
 Total                26          131         12709      10994       1071                       134

For example, from this particular output we can easily conclude that
class-896 is heavily fragmented -- it occupies 26 pages, 12 can be freed
by compaction.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-add-freeable-column-to-pool-stat mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-freeable-column-to-pool-stat
+++ a/mm/zsmalloc.c
@@ -494,6 +494,8 @@ static void __exit zs_stat_exit(void)
 	debugfs_remove_recursive(zs_stat_root);
 }
 
+static unsigned long zs_can_compact(struct size_class *class);
+
 static int zs_stats_size_show(struct seq_file *s, void *v)
 {
 	int i;
@@ -501,14 +503,15 @@ static int zs_stats_size_show(struct seq
 	struct size_class *class;
 	int objs_per_zspage;
 	unsigned long class_almost_full, class_almost_empty;
-	unsigned long obj_allocated, obj_used, pages_used;
+	unsigned long obj_allocated, obj_used, pages_used, freeable;
 	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
 	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
+	unsigned long total_freeable = 0;
 
-	seq_printf(s, " %5s %5s %11s %12s %13s %10s %10s %16s\n",
+	seq_printf(s, " %5s %5s %11s %12s %13s %10s %10s %16s %8s\n",
 			"class", "size", "almost_full", "almost_empty",
 			"obj_allocated", "obj_used", "pages_used",
-			"pages_per_zspage");
+			"pages_per_zspage", "freeable");
 
 	for (i = 0; i < zs_size_classes; i++) {
 		class = pool->size_class[i];
@@ -521,6 +524,7 @@ static int zs_stats_size_show(struct seq
 		class_almost_empty = zs_stat_get(class, CLASS_ALMOST_EMPTY);
 		obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
 		obj_used = zs_stat_get(class, OBJ_USED);
+		freeable = zs_can_compact(class);
 		spin_unlock(&class->lock);
 
 		objs_per_zspage = get_maxobj_per_zspage(class->size,
@@ -528,23 +532,25 @@ static int zs_stats_size_show(struct seq
 		pages_used = obj_allocated / objs_per_zspage *
 				class->pages_per_zspage;
 
-		seq_printf(s, " %5u %5u %11lu %12lu %13lu %10lu %10lu %16d\n",
+		seq_printf(s, " %5u %5u %11lu %12lu %13lu"
+				" %10lu %10lu %16d %8lu\n",
 			i, class->size, class_almost_full, class_almost_empty,
 			obj_allocated, obj_used, pages_used,
-			class->pages_per_zspage);
+			class->pages_per_zspage, freeable);
 
 		total_class_almost_full += class_almost_full;
 		total_class_almost_empty += class_almost_empty;
 		total_objs += obj_allocated;
 		total_used_objs += obj_used;
 		total_pages += pages_used;
+		total_freeable += freeable;
 	}
 
 	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu\n",
+	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu %16s %7lu\n",
 			"Total", "", total_class_almost_full,
 			total_class_almost_empty, total_objs,
-			total_used_objs, total_pages);
+			total_used_objs, total_pages, "", total_freeable);
 
 	return 0;
 }
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-workingset-per-cgroup-cache-thrash-detection-fix.patch
zram-export-the-number-of-available-comp-streams.patch
mm-zsmalloc-add-freeable-column-to-pool-stat.patch
printk-move-can_use_console-out-of-console_trylock_for_printk.patch
printk-set-may_schedule-for-some-of-console_trylock-callers.patch
printk-check-con_enabled-in-have_callable_console.patch

