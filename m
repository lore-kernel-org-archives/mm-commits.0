From: akpm@linux-foundation.org
Subject: [merged]
 writeback-change-of-dirty_writeback_interval-takes-effect-immediately.patch
 removed from -mm tree
Date: Fri, 13 Oct 2017 13:28:35 -0700
Message-ID: <20171013202835.vfj9N5Q2O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbdJMU2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 16:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, jack@suse.cz, laoar.shao@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: make changes of dirty_writeback_centisecs take effect immediately
has been removed from the -mm tree.  Its filename was
     writeback-change-of-dirty_writeback_interval-takes-effect-immediately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/page-writeback.c: make changes of dirty_writeback_centisecs take effect immediately

Two problems with /proc/sys/vm/dirty_writeback_centisecs:

- When the tunable is set to 0 (disable), writing a non-zero value
  doesn't restart the flushing operations until the dirty background limit
  is reached or sys_sync is executed or not enough free memory is
  available or vmscan is triggered.

- When the tunable was set to one hour and is reset to one second, the
  new setting will not take effect for up to one hour.

Kicking the flusher threads immediately fixes these issues.

Link: http://lkml.kernel.org/r/1507746016-15344-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-change-of-dirty_writeback_interval-takes-effect-immediately mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-change-of-dirty_writeback_interval-takes-effect-immediately
+++ a/mm/page-writeback.c
@@ -1974,8 +1974,19 @@ bool wb_over_bg_thresh(struct bdi_writeb
 int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
-	return 0;
+	int ret = proc_dointvec(table, write, buffer, length, ppos);
+
+	/*
+	 * Writing 0 to dirty_writeback_interval will disable periodic writeback
+	 * and a different non-zero value will wakeup the writeback threads.
+	 * wb_wakeup_delayed() would be more appropriate, but it's a pain to
+	 * iterate over all bdis and wbs.
+	 * The reason we do this is to make the change take effect immediately.
+	 */
+	if (!ret && write && dirty_writeback_interval &&
+			dirty_writeback_interval != old_interval)
+		wakeup_flusher_threads(WB_REASON_PERIODIC);
+	return ret;
 }
 
 #ifdef CONFIG_BLOCK
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical.patch

