Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08015143878
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996442; cv=none; b=mUNtaWEJ439z7k/i4Fz1CAvmmETgCJga6E0e6LHTB1wg22/As4uyskihCDK7E0PDA22T4qNhlSXJmGNFjwHBESK5XdHIDBvLVB+zE3A+oav0K773PmbnI/reVYcw8a2tC+JBwiCpBqg8h1l+1OvCvhxRWCBGyc6UoettMcgdU0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996442; c=relaxed/simple;
	bh=1a7wXaKZSMY2A5barhiY/qweWDBtjlG/yqybWecvo2A=;
	h=Date:To:From:Subject:Message-Id; b=YISOLr4fwUSfSsWN2Rucf7I2npV4+A58U5tj2unA896xRda0ZlHaW5ANfrBtbVQzMeDLZ82d6LJfuW9cHqwc6iBcsWhRkxdkI/9ZdcjSgoIlKfkDBdYeqjV4Ql4wL5AUBYbWnrT63jQU4De17vTrFzI60Bc+y8PQdOeY2KDTA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfWSIxFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfWSIxFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA49C113CD;
	Wed, 24 Apr 2024 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713996441;
	bh=1a7wXaKZSMY2A5barhiY/qweWDBtjlG/yqybWecvo2A=;
	h=Date:To:From:Subject:From;
	b=hfWSIxFz6W6Wtw7Jy4tlTB8Q6Z9Ko7vuF3czGg9WhE1p5nvohAdQ6BArz5xXZeKbK
	 VQaCGrTdH/ZVtxvzAOzlRCm4mrIpmNfF+FxfRmq29OqWunXxGsCoj5hk3HntQW0lQ+
	 9YGlls/izp1KRff0X3KSF2nZyeMyRJrBL1iUAKGQ=
Date: Wed, 24 Apr 2024 15:07:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,sj@kernel.org,sfr@canb.auug.org.au,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch added to mm-unstable branch
Message-Id: <20240424220721.6CA49C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: collect stats of all wb of bdi in bdi_debug_stats_show
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: collect stats of all wb of bdi in bdi_debug_stats_show
Date: Tue, 23 Apr 2024 11:46:39 +0800

Patch series "Improve visibility of writeback", v5.

This series tries to improve visilibity of writeback.  Patch 1 make
/sys/kernel/debug/bdi/xxx/stats show writeback info of whole bdi instead
of only writeback info in root cgroup.  Patch 2 add a new debug file
/sys/kernel/debug/bdi/xxx/wb_stats to show per wb writeback info.  Patch 3
add wb_monitor.py to monitor basic writeback info of running system, more
info could be added on demand.  Patch 4 is a random cleanup.  More details
can be found in respective patches.

Following domain hierarchy is tested:
                global domain (320G)
                /                 \
        cgroup domain1(10G)     cgroup domain2(10G)
                |                 |
bdi            wb1               wb2

/* all writeback info of bdi is successfully collected */
cat stats
BdiWriteback:             4704 kB
BdiReclaimable:        1294496 kB
BdiDirtyThresh:      204208088 kB
DirtyThresh:         195259944 kB
BackgroundThresh:     32503588 kB
BdiDirtied:           48519296 kB
BdiWritten:           47225696 kB
BdiWriteBandwidth:     1173892 kBps
b_dirty:                     1
b_io:                        0
b_more_io:                   1
b_dirty_time:                0
bdi_list:                    1
state:                       1

/* per wb writeback info of bdi is collected */
cat /sys/kernel/debug/bdi/252:16/wb_stats
WbCgIno:                    1
WbWriteback:                0 kB
WbReclaimable:              0 kB
WbDirtyThresh:              0 kB
WbDirtied:                  0 kB
WbWritten:                  0 kB
WbWriteBandwidth:      102400 kBps
b_dirty:                    0
b_io:                       0
b_more_io:                  0
b_dirty_time:               0
state:                      1

WbCgIno:                 4208
WbWriteback:            59808 kB
WbReclaimable:         676480 kB
WbDirtyThresh:        6004624 kB
WbDirtied:           23348192 kB
WbWritten:           22614592 kB
WbWriteBandwidth:      593204 kBps
b_dirty:                    1
b_io:                       1
b_more_io:                  0
b_dirty_time:               0
state:                      7

WbCgIno:                 4249
WbWriteback:           144256 kB
WbReclaimable:         432096 kB
WbDirtyThresh:        6004344 kB
WbDirtied:           25727744 kB
WbWritten:           25154752 kB
WbWriteBandwidth:      577904 kBps
b_dirty:                    0
b_io:                       1
b_more_io:                  0
b_dirty_time:               0
state:                      7

The wb_monitor.py script output is as following:
./wb_monitor.py 252:16 -c
                  writeback  reclaimable   dirtied   written    avg_bw
252:16_1                  0            0         0         0    102400
252:16_4284             672       820064   9230368   8410304    685612
252:16_4325             896       819840  10491264   9671648    652348
252:16                 1568      1639904  19721632  18081952   1440360

                  writeback  reclaimable   dirtied   written    avg_bw
252:16_1                  0            0         0         0    102400
252:16_4284             672       820064   9230368   8410304    685612
252:16_4325             896       819840  10491264   9671648    652348
252:16                 1568      1639904  19721632  18081952   1440360
...


This patch (of 5):

/sys/kernel/debug/bdi/xxx/stats is supposed to show writeback information
of whole bdi, but only writeback information of bdi in root cgroup is
collected.  So writeback information in non-root cgroup are missing now. 
To be more specific, considering following case:

/* create writeback cgroup */
cd /sys/fs/cgroup
echo "+memory +io" > cgroup.subtree_control
mkdir group1
cd group1
echo $$ > cgroup.procs
/* do writeback in cgroup */
fio -name test -filename=/dev/vdb ...
/* get writeback info of bdi */
cat /sys/kernel/debug/bdi/xxx/stats
The cat result unexpectedly implies that there is no writeback on target
bdi.

Fix this by collecting stats of all wb in bdi instead of only wb in
root cgroup.

Following domain hierarchy is tested:
                global domain (320G)
                /                 \
        cgroup domain1(10G)     cgroup domain2(10G)
                |                 |
bdi            wb1               wb2

/* all writeback info of bdi is successfully collected */
cat stats
BdiWriteback:             2912 kB
BdiReclaimable:        1598464 kB
BdiDirtyThresh:      167479028 kB
DirtyThresh:         195038532 kB
BackgroundThresh:     32466728 kB
BdiDirtied:           19141696 kB
BdiWritten:           17543456 kB
BdiWriteBandwidth:     1136172 kBps
b_dirty:                     2
b_io:                        0
b_more_io:                   1
b_dirty_time:                0
bdi_list:                    1
state:                       1

Link: https://lkml.kernel.org/r/20240423034643.141219-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20240423034643.141219-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   96 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 23 deletions(-)

--- a/mm/backing-dev.c~writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show
+++ a/mm/backing-dev.c
@@ -39,6 +39,19 @@ struct workqueue_struct *bdi_wq;
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
+struct wb_stats {
+	unsigned long nr_dirty;
+	unsigned long nr_io;
+	unsigned long nr_more_io;
+	unsigned long nr_dirty_time;
+	unsigned long nr_writeback;
+	unsigned long nr_reclaimable;
+	unsigned long nr_dirtied;
+	unsigned long nr_written;
+	unsigned long dirty_thresh;
+	unsigned long wb_thresh;
+};
+
 static struct dentry *bdi_debug_root;
 
 static void bdi_debug_init(void)
@@ -46,31 +59,68 @@ static void bdi_debug_init(void)
 	bdi_debug_root = debugfs_create_dir("bdi", NULL);
 }
 
-static int bdi_debug_stats_show(struct seq_file *m, void *v)
+static void collect_wb_stats(struct wb_stats *stats,
+			     struct bdi_writeback *wb)
 {
-	struct backing_dev_info *bdi = m->private;
-	struct bdi_writeback *wb = &bdi->wb;
-	unsigned long background_thresh;
-	unsigned long dirty_thresh;
-	unsigned long wb_thresh;
-	unsigned long nr_dirty, nr_io, nr_more_io, nr_dirty_time;
 	struct inode *inode;
 
-	nr_dirty = nr_io = nr_more_io = nr_dirty_time = 0;
 	spin_lock(&wb->list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_io_list)
-		nr_dirty++;
+		stats->nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_io_list)
-		nr_io++;
+		stats->nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_io_list)
-		nr_more_io++;
+		stats->nr_more_io++;
 	list_for_each_entry(inode, &wb->b_dirty_time, i_io_list)
 		if (inode->i_state & I_DIRTY_TIME)
-			nr_dirty_time++;
+			stats->nr_dirty_time++;
 	spin_unlock(&wb->list_lock);
 
+	stats->nr_writeback += wb_stat(wb, WB_WRITEBACK);
+	stats->nr_reclaimable += wb_stat(wb, WB_RECLAIMABLE);
+	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
+	stats->nr_written += wb_stat(wb, WB_WRITTEN);
+	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
+}
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+static void bdi_collect_stats(struct backing_dev_info *bdi,
+			      struct wb_stats *stats)
+{
+	struct bdi_writeback *wb;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node) {
+		if (!wb_tryget(wb))
+			continue;
+
+		collect_wb_stats(stats, wb);
+		wb_put(wb);
+	}
+	rcu_read_unlock();
+}
+#else
+static void bdi_collect_stats(struct backing_dev_info *bdi,
+			      struct wb_stats *stats)
+{
+	collect_wb_stats(stats, &bdi->wb);
+}
+#endif
+
+static int bdi_debug_stats_show(struct seq_file *m, void *v)
+{
+	struct backing_dev_info *bdi = m->private;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	struct wb_stats stats;
+	unsigned long tot_bw;
+
 	global_dirty_limits(&background_thresh, &dirty_thresh);
-	wb_thresh = wb_calc_thresh(wb, dirty_thresh);
+
+	memset(&stats, 0, sizeof(stats));
+	stats.dirty_thresh = dirty_thresh;
+	bdi_collect_stats(bdi, &stats);
+	tot_bw = atomic_long_read(&bdi->tot_write_bandwidth);
 
 	seq_printf(m,
 		   "BdiWriteback:       %10lu kB\n"
@@ -87,18 +137,18 @@ static int bdi_debug_stats_show(struct s
 		   "b_dirty_time:       %10lu\n"
 		   "bdi_list:           %10u\n"
 		   "state:              %10lx\n",
-		   (unsigned long) K(wb_stat(wb, WB_WRITEBACK)),
-		   (unsigned long) K(wb_stat(wb, WB_RECLAIMABLE)),
-		   K(wb_thresh),
+		   K(stats.nr_writeback),
+		   K(stats.nr_reclaimable),
+		   K(stats.wb_thresh),
 		   K(dirty_thresh),
 		   K(background_thresh),
-		   (unsigned long) K(wb_stat(wb, WB_DIRTIED)),
-		   (unsigned long) K(wb_stat(wb, WB_WRITTEN)),
-		   (unsigned long) K(wb->write_bandwidth),
-		   nr_dirty,
-		   nr_io,
-		   nr_more_io,
-		   nr_dirty_time,
+		   K(stats.nr_dirtied),
+		   K(stats.nr_written),
+		   K(tot_bw),
+		   stats.nr_dirty,
+		   stats.nr_io,
+		   stats.nr_more_io,
+		   stats.nr_dirty_time,
 		   !list_empty(&bdi->bdi_list), bdi->wb.state);
 
 	return 0;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

