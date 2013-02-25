From: akpm@linux-foundation.org
Subject: [merged] block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:14 -0800
Message-ID: <20130225205214.ED98F5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:42559 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694Ab3BYUwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:16 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159028yen.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.lei@canonical.com, axboe@kernel.dk, davem@davemloft.net, david.decotigny@google.com, eric.dumazet@gmail.com, greg@kroah.com, jiri.kosina@suse.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan@kernel.org, mingo@elte.hu, mingo@redhat.com, oneukum@suse.de, peterz@infradead.org, rjw@sisk.pl, stern@rowland.harvard.edu, therbert@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block/genhd.c: apply pm_runtime_set_memalloc_noio on block devices
has been removed from the -mm tree.  Its filename was
     block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: block/genhd.c: apply pm_runtime_set_memalloc_noio on block devices

Apply the introduced pm_runtime_set_memalloc_noio on block device so that
PM core will teach mm to not allocate memory with GFP_IOFS when calling
the runtime_resume and runtime_suspend callback for block devices and its
ancestors.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <david.decotigny@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN block/genhd.c~block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices block/genhd.c
--- a/block/genhd.c~block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices
+++ a/block/genhd.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
+#include <linux/pm_runtime.h>
 
 #include "blk.h"
 
@@ -534,6 +535,14 @@ static void register_disk(struct gendisk
 			return;
 		}
 	}
+
+	/*
+	 * avoid probable deadlock caused by allocating memory with
+	 * GFP_KERNEL in runtime_resume callback of its all ancestor
+	 * devices
+	 */
+	pm_runtime_set_memalloc_noio(ddev, true);
+
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
@@ -663,6 +672,7 @@ void del_gendisk(struct gendisk *disk)
 	disk->driverfs_dev = NULL;
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
+	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 }
 EXPORT_SYMBOL(del_gendisk);
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch
block-partitions-mac-obey-the-state-limit-constraint.patch
block-partitions-optimize-memory-allocation-in-check_partition.patch

