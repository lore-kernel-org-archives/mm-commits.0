From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:23 -0800
Message-ID: <52e2b80b.oT2J1juXHT9aht9G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, travis@sgi.com, tangchen@cn.fujitsu.com, rafael.j.wysocki@intel.com, kamezawa.hiroyu@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hedi@sgi.com, nzimmer@sgi.com

Subject: [merged] mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch removed from -mm tree
To: nzimmer@sgi.com,hedi@sgi.com,isimatu.yasuaki@jp.fujitsu.com,kamezawa.hiroyu@jp.fujitsu.com,rafael.j.wysocki@intel.com,tangchen@cn.fujitsu.com,travis@sgi.com,wency@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:23 -0800


The patch titled
     Subject: mm/memory_hotplug.c: move register_memory_resource out of the lock_memory_hotplug
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: mm/memory_hotplug.c: move register_memory_resource out of the lock_memory_hotplug

We don't need to do register_memory_resource() under lock_memory_hotplug()
since it has its own lock and doesn't make any callbacks.

Also register_memory_resource return NULL on failure so we don't have
anything to cleanup at this point.

The reason for this rfc is I was doing some experiments with hotplugging
of memory on some of our larger systems.  While it seems to work, it can
be quite slow.  With some preliminary digging I found that
lock_memory_hotplug is clearly ripe for breakup.

It could be broken up per nid or something but it also covers the
online_page_callback.  The online_page_callback shouldn't be very hard to
break out.

Also there is the issue of various structures(wmarks come to mind) that are
only updated under the lock_memory_hotplug that would need to be dealt with.

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hedi <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug
+++ a/mm/memory_hotplug.c
@@ -1107,17 +1107,18 @@ int __ref add_memory(int nid, u64 start,
 	if (ret)
 		return ret;
 
-	lock_memory_hotplug();
