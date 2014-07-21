From: akpm@linux-foundation.org
Subject: +
 memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch added to
 -mm tree
Date: Mon, 21 Jul 2014 14:54:28 -0700
Message-ID: <53cd8c14.fxwajJI/s77ydQYX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:41125 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaGUVy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 17:54:29 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2004625pde.5
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 14:54:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, akpm@linux-foundation.org, benh@kernel.crashing.org, cmetcalf@tilera.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE

This patch introduces zone_for_memory() to arch_add_memory() on sh to
ensure new, higher memory added into ZONE_MOVABLE if movable zone has
already setup.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Mel Gorman" <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Dave Hansen" <dave.hansen@intel.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/sh/mm/init.c~memory-hotplug-sh-suitable-memory-should-go-to-zone_movable arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~memory-hotplug-sh-suitable-memory-should-go-to-zone_movable
+++ a/arch/sh/mm/init.c
@@ -495,8 +495,9 @@ int arch_add_memory(int nid, u64 start,
 	pgdat = NODE_DATA(nid);
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(nid, pgdat->node_zones + ZONE_NORMAL,
-				start_pfn, nr_pages);
+	ret = __add_pages(nid, pgdat->node_zones +
+			zone_for_memory(nid, start, size, ZONE_NORMAL),
+			start_pfn, nr_pages);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
_

Patches currently in -mm which might be from wangnan0@huawei.com are

mem-hotplug-improve-zone_movable_is_highmem-logic.patch
memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch
memory-hotplug-x86_64-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-ppc-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-tile-suitable-memory-should-go-to-zone_movable.patch
linux-next.patch

