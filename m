Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B0122089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957114; cv=none; b=cTq9fny3OSCJMdOzGBm09cKMsCU9+0POzP3fDk9sspIt7f7693ZpxNGkcCosWPkt9OskGjCPOx/bIDLG5OdgpFL5ZHcs+q5z/yXm/QmawbtFMI3GYMpIAyJFomxubB4sdyU+cCex1/OYyrIhnN9iHYIAgelA0cvGGMh++v6pKow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957114; c=relaxed/simple;
	bh=QKkWyGLH0QScoNc0oOl43H9yH5x/XlaCMOApdZ9xwVs=;
	h=Date:To:From:Subject:Message-Id; b=dVmMQ9OA2eE4YO9/QcAx6MnEcycRHdHWIdyJ+JVd1uxed8jf/NkGE/TF1x42d0WErYDfnblvAuy5eEZl5zKFPNl19rA0ZHnc1DGwG3qjwvRSPcB3ZOS+7DlZOkXfe5HWyFZbSdAwNapHoYsqRQagPGpsNFlClP3Sd82IRBYIHyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kR3YzPGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kR3YzPGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F78CC113CC;
	Mon,  6 May 2024 00:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957114;
	bh=QKkWyGLH0QScoNc0oOl43H9yH5x/XlaCMOApdZ9xwVs=;
	h=Date:To:From:Subject:From;
	b=kR3YzPGP2jr6K+8sCNk1oLIwRRezG8KyH98SPybAYveG+b/2pYSwyTXbewKAzuAyq
	 5yfkOfsDlvX6w5MwnIuWgSmBXVxUhi00dNxZUKtgosUKr4lyPYfgDT5iaF+O9svBP2
	 Irbga2vT7OcQsL9vnFT0tpAhGi9WKosBF5uZu5UM=
Date: Sun, 05 May 2024 17:58:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,sj@kernel.org,sfr@canb.auug.org.au,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch removed from -mm tree
Message-Id: <20240506005834.1F78CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: support retrieving per group debug writeback stats of bdi
has been removed from the -mm tree.  Its filename was
     writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: support retrieving per group debug writeback stats of bdi
Date: Tue, 23 Apr 2024 11:46:40 +0800

Add /sys/kernel/debug/bdi/xxx/wb_stats to show per group writeback stats
of bdi.

Following domain hierarchy is tested:
                global domain (320G)
                /                 \
        cgroup domain1(10G)     cgroup domain2(10G)
                |                 |
bdi            wb1               wb2

/* per wb writeback info of bdi is collected */
cat wb_stats
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

WbCgIno:                 4091
WbWriteback:             1792 kB
WbReclaimable:         820512 kB
WbDirtyThresh:        6004692 kB
WbDirtied:            1820448 kB
WbWritten:             999488 kB
WbWriteBandwidth:      169020 kBps
b_dirty:                    0
b_io:                       0
b_more_io:                  1
b_dirty_time:               0
state:                      5

WbCgIno:                 4131
WbWriteback:             1120 kB
WbReclaimable:         820064 kB
WbDirtyThresh:        6004728 kB
WbDirtied:            1822688 kB
WbWritten:            1002400 kB
WbWriteBandwidth:      153520 kBps
b_dirty:                    0
b_io:                       0
b_more_io:                  1
b_dirty_time:               0
state:                      5

[shikemeng@huaweicloud.com: fix build problems]
  Link: https://lkml.kernel.org/r/20240423034643.141219-4-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20240423034643.141219-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    1 
 mm/backing-dev.c          |   81 +++++++++++++++++++++++++++++++++++-
 mm/page-writeback.c       |   19 ++++++++
 3 files changed, 99 insertions(+), 2 deletions(-)

--- a/include/linux/writeback.h~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi
+++ a/include/linux/writeback.h
@@ -355,6 +355,7 @@ int dirtytime_interval_handler(struct ct
 
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
+unsigned long cgwb_calc_thresh(struct bdi_writeback *wb);
 
 void wb_update_bandwidth(struct bdi_writeback *wb);
 
--- a/mm/backing-dev.c~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi
+++ a/mm/backing-dev.c
@@ -155,19 +155,96 @@ static int bdi_debug_stats_show(struct s
 }
 DEFINE_SHOW_ATTRIBUTE(bdi_debug_stats);
 
+static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
+			  struct wb_stats *stats)
+{
+
+	seq_printf(m,
+		   "WbCgIno:           %10lu\n"
+		   "WbWriteback:       %10lu kB\n"
+		   "WbReclaimable:     %10lu kB\n"
+		   "WbDirtyThresh:     %10lu kB\n"
+		   "WbDirtied:         %10lu kB\n"
+		   "WbWritten:         %10lu kB\n"
+		   "WbWriteBandwidth:  %10lu kBps\n"
+		   "b_dirty:           %10lu\n"
+		   "b_io:              %10lu\n"
+		   "b_more_io:         %10lu\n"
+		   "b_dirty_time:      %10lu\n"
+		   "state:             %10lx\n\n",
+#ifdef CONFIG_CGROUP_WRITEBACK
+		   cgroup_ino(wb->memcg_css->cgroup),
+#else
+		   1ul,
+#endif
+		   K(stats->nr_writeback),
+		   K(stats->nr_reclaimable),
+		   K(stats->wb_thresh),
+		   K(stats->nr_dirtied),
+		   K(stats->nr_written),
+		   K(wb->avg_write_bandwidth),
+		   stats->nr_dirty,
+		   stats->nr_io,
+		   stats->nr_more_io,
+		   stats->nr_dirty_time,
+		   wb->state);
+}
+
+static int cgwb_debug_stats_show(struct seq_file *m, void *v)
+{
+	struct backing_dev_info *bdi = m->private;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	struct bdi_writeback *wb;
+
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node) {
+		struct wb_stats stats = { .dirty_thresh = dirty_thresh };
+
+		if (!wb_tryget(wb))
+			continue;
+
+		collect_wb_stats(&stats, wb);
+
+		/*
+		 * Calculate thresh of wb in writeback cgroup which is min of
+		 * thresh in global domain and thresh in cgroup domain. Drop
+		 * rcu lock because cgwb_calc_thresh may sleep in
+		 * cgroup_rstat_flush. We can do so here because we have a ref.
+		 */
+		if (mem_cgroup_wb_domain(wb)) {
+			rcu_read_unlock();
+			stats.wb_thresh = min(stats.wb_thresh, cgwb_calc_thresh(wb));
+			rcu_read_lock();
+		}
+
+		wb_stats_show(m, wb, &stats);
+
+		wb_put(wb);
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(cgwb_debug_stats);
+
 static void bdi_debug_register(struct backing_dev_info *bdi, const char *name)
 {
 	bdi->debug_dir = debugfs_create_dir(name, bdi_debug_root);
 
 	debugfs_create_file("stats", 0444, bdi->debug_dir, bdi,
 			    &bdi_debug_stats_fops);
+	debugfs_create_file("wb_stats", 0444, bdi->debug_dir, bdi,
+			    &cgwb_debug_stats_fops);
 }
 
 static void bdi_debug_unregister(struct backing_dev_info *bdi)
 {
 	debugfs_remove_recursive(bdi->debug_dir);
 }
-#else
+#else /* CONFIG_DEBUG_FS */
 static inline void bdi_debug_init(void)
 {
 }
@@ -178,7 +255,7 @@ static inline void bdi_debug_register(st
 static inline void bdi_debug_unregister(struct backing_dev_info *bdi)
 {
 }
-#endif
+#endif /* CONFIG_DEBUG_FS */
 
 static ssize_t read_ahead_kb_store(struct device *dev,
 				  struct device_attribute *attr,
--- a/mm/page-writeback.c~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi
+++ a/mm/page-writeback.c
@@ -892,6 +892,25 @@ unsigned long wb_calc_thresh(struct bdi_
 	return __wb_calc_thresh(&gdtc);
 }
 
+unsigned long cgwb_calc_thresh(struct bdi_writeback *wb)
+{
+	struct dirty_throttle_control gdtc = { GDTC_INIT_NO_WB };
+	struct dirty_throttle_control mdtc = { MDTC_INIT(wb, &gdtc) };
+	unsigned long filepages = 0, headroom = 0, writeback = 0;
+
+	gdtc.avail = global_dirtyable_memory();
+	gdtc.dirty = global_node_page_state(NR_FILE_DIRTY) +
+		     global_node_page_state(NR_WRITEBACK);
+
+	mem_cgroup_wb_stats(wb, &filepages, &headroom,
+			    &mdtc.dirty, &writeback);
+	mdtc.dirty += writeback;
+	mdtc_calc_avail(&mdtc, filepages, headroom);
+	domain_dirty_limits(&mdtc);
+
+	return __wb_calc_thresh(&mdtc);
+}
+
 /*
  *                           setpoint - dirty 3
  *        f(dirty) := 1.0 + (----------------)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


