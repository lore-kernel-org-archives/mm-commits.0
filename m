From: akpm@linux-foundation.org
Subject: + mm-memory_hotplugc-fix-return-value-of-online_pages.patch added to -mm tree
Date: Mon, 08 Jul 2013 13:56:33 -0700
Message-ID: <51db2781.p/dNQZdqlo7Pb4rq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3GHU4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 16:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, toshi.kani@hp.com

Subject: + mm-memory_hotplugc-fix-return-value-of-online_pages.patch added to -mm tree
To: toshi.kani@hp.com,isimatu.yasuaki@jp.fujitsu.com,tangchen@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 13:56:33 -0700


The patch titled
     Subject: mm/memory_hotplug.c: fix return value of online_pages()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-fix-return-value-of-online_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplugc-fix-return-value-of-online_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplugc-fix-return-value-of-online_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch
mm-memory_hotplugc-fix-return-value-of-online_pages.patch

