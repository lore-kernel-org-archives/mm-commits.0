From: akpm@linux-foundation.org
Subject: [merged] pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:22 -0800
Message-ID: <20130225205223.17F7231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:42609 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab3BYUwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:25 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70441qea.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.lei@canonical.com, axboe@kernel.dk, davem@davemloft.net, david.decotigny@google.com, eric.dumazet@gmail.com, greg@kroah.com, jiri.kosina@suse.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan@kernel.org, mingo@elte.hu, mingo@redhat.com, oneukum@suse.de, peterz@infradead.org, rjw@sisk.pl, stern@rowland.harvard.edu, therbert@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pm / runtime: force memory allocation with no I/O during Runtime PM callbcack
has been removed from the -mm tree.  Its filename was
     pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: pm / runtime: force memory allocation with no I/O during Runtime PM callbcack

Apply the introduced memalloc_noio_save() and memalloc_noio_restore() to
force memory allocation with no I/O during runtime_resume/runtime_suspend
callback on device with the flag of 'memalloc_noio' set.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <david.decotigny@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Jiri Kosina <jiri.kosina@suse.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/runtime.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/base/power/runtime.c~pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack drivers/base/power/runtime.c
--- a/drivers/base/power/runtime.c~pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack
+++ a/drivers/base/power/runtime.c
@@ -348,7 +348,24 @@ static int rpm_callback(int (*cb)(struct
 	if (!cb)
 		return -ENOSYS;
 
-	retval = __rpm_callback(cb, dev);
+	if (dev->power.memalloc_noio) {
+		unsigned int noio_flag;
+
+		/*
+		 * Deadlock might be caused if memory allocation with
+		 * GFP_KERNEL happens inside runtime_suspend and
+		 * runtime_resume callbacks of one block device's
+		 * ancestor or the block device itself. Network
+		 * device might be thought as part of iSCSI block
+		 * device, so network device and its ancestor should
+		 * be marked as memalloc_noio too.
+		 */
+		noio_flag = memalloc_noio_save();
+		retval = __rpm_callback(cb, dev);
+		memalloc_noio_restore(noio_flag);
+	} else {
+		retval = __rpm_callback(cb, dev);
+	}
 
 	dev->power.runtime_error = retval;
 	return retval != -EACCES ? retval : -EIO;
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch
block-partitions-mac-obey-the-state-limit-constraint.patch
block-partitions-optimize-memory-allocation-in-check_partition.patch

