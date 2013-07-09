From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplugc-fix-return-value-of-online_pages.patch removed from -mm
 tree
Date: Tue, 09 Jul 2013 16:20:53 -0700
Message-ID: <51dc9ad5.3SGLLbaT4+160eGd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3GIXUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, toshi.kani@hp.com

Subject: [merged] mm-memory_hotplugc-fix-return-value-of-online_pages.patch removed from -mm tree
To: toshi.kani@hp.com,isimatu.yasuaki@jp.fujitsu.com,tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:53 -0700


The patch titled
     Subject: mm/memory_hotplug.c: fix return value of online_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-fix-return-value-of-online_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm/memory_hotplug.c: fix return value of online_pages()

online_pages() is called from memory_block_action() when a user requests
to online a memory block via sysfs.  This function needs to return a
proper error value in case of error.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-fix-return-value-of-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-fix-return-value-of-online_pages
+++ a/mm/memory_hotplug.c
@@ -914,19 +914,19 @@ int __ref online_pages(unsigned long pfn
 	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
 	    !can_online_high_movable(zone)) {
 		unlock_memory_hotplug();
-		return -1;
+		return -EINVAL;
 	}
 
 	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
 		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages)) {
 			unlock_memory_hotplug();
-			return -1;
+			return -EINVAL;
 		}
 	}
 	if (online_type == ONLINE_MOVABLE && zone_idx(zone) == ZONE_MOVABLE - 1) {
 		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages)) {
 			unlock_memory_hotplug();
-			return -1;
+			return -EINVAL;
 		}
 	}
 
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch

