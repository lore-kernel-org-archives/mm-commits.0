From: akpm@linux-foundation.org
Subject: + writeback-add-sys-devices-system-node-node-vmstat-update.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:10:42 -0700
Message-ID: <201009151910.o8FJAgGB010263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab0IOTK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:10:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrubin@google.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     writeback-add-sys-devices-system-node-node-vmstat-update
has been added to the -mm tree.  Its filename is
     writeback-add-sys-devices-system-node-node-vmstat-update.patch

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
Subject: writeback-add-sys-devices-system-node-node-vmstat-update
From: Michael Rubin <mrubin@google.com>

For NUMA node systems it is important to have visibility in memory
characteristics. Two of the /proc/vmstat values "nr_written" and
"nr_dirtied" are added here.

	# cat /sys/devices/system/node/node20/vmstat
	nr_written 0
	nr_dirtied 0

Signed-off-by: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/node.c~writeback-add-sys-devices-system-node-node-vmstat-update drivers/base/node.c
--- a/drivers/base/node.c~writeback-add-sys-devices-system-node-node-vmstat-update
+++ a/drivers/base/node.c
@@ -168,7 +168,7 @@ static ssize_t node_read_vmstat(struct s
 		"nr_written %lu\n"
 		"nr_dirtied %lu\n",
 		node_page_state(nid, NR_WRITTEN),
-		node_page_state(nid, NR_FILE_DIRTIED));
+		node_page_state(nid, NR_DIRTIED));
 }
 static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
 
_

Patches currently in -mm which might be from mrubin@google.com are

vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-export-account_page_dirty.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch

