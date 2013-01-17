From: akpm@linux-foundation.org
Subject: + net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch added to -mm tree
Date: Thu, 17 Jan 2013 13:57:55 -0800
Message-ID: <20130117215755.8FE6231C252@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:39885 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3AQWGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 17:06:11 -0500
Received: by mail-oa0-f74.google.com with SMTP id k14so799017oag.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 14:06:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.lei@canonical.com, axboe@kernel.dk, davem@davemloft.net, david.decotigny@google.com, eric.dumazet@gmail.com, greg@kroah.com, jiri.kosina@suse.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan@kernel.org, mingo@elte.hu, mingo@redhat.com, oneukum@suse.de, peterz@infradead.org, rjw@sisk.pl, stern@rowland.harvard.edu, therbert@google.com


The patch titled
     Subject: net/core: apply pm_runtime_set_memalloc_noio on network devices
has been added to the -mm tree.  Its filename is
     net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: net/core: apply pm_runtime_set_memalloc_noio on network devices

Deadlock might be caused by allocating memory with GFP_KERNEL in
runtime_resume and runtime_suspend callback of network devices in iSCSI
situation, so mark network devices and its ancestor as 'memalloc_noio'
with the introduced pm_runtime_set_memalloc_noio().

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

 net/core/net-sysfs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN net/core/net-sysfs.c~net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices net/core/net-sysfs.c
--- a/net/core/net-sysfs.c~net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices
+++ a/net/core/net-sysfs.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/export.h>
 #include <linux/jiffies.h>
+#include <linux/pm_runtime.h>
 
 #include "net-sysfs.h"
 
@@ -1257,6 +1258,8 @@ void netdev_unregister_kobject(struct ne
 
 	remove_queue_kobjects(net);
 
+	pm_runtime_set_memalloc_noio(dev, false);
+
 	device_del(dev);
 }
 
@@ -1301,6 +1304,8 @@ int netdev_register_kobject(struct net_d
 		return error;
 	}
 
+	pm_runtime_set_memalloc_noio(dev, true);
+
 	return error;
 }
 
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch
linux-next.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch

