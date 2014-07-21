From: akpm@linux-foundation.org
Subject: +
 memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch added to -mm tree
Date: Mon, 21 Jul 2014 14:54:22 -0700
Message-ID: <53cd8c0e.7Cxt//VY7HHrzWv3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:59979 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaGUVyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 17:54:24 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so422487igd.2
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 14:54:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, akpm@linux-foundation.org, benh@kernel.crashing.org, cmetcalf@tilera.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: x86_32: suitable memory should go to ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch

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
Subject: memory-hotplug: x86_32: suitable memory should go to ZONE_MOVABLE

This patch introduces zone_for_memory() to arch_add_memory() on x86_32 to
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

 arch/x86/mm/init_32.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/init_32.c~memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable
+++ a/arch/x86/mm/init_32.c
@@ -825,7 +825,8 @@ void __init mem_init(void)
 int arch_add_memory(int nid, u64 start, u64 size)
 {
 	struct pglist_data *pgdata = NODE_DATA(nid);
-	struct zone *zone = pgdata->node_zones + ZONE_HIGHMEM;
+	struct zone *zone = pgdata->node_zones +
+		zone_for_memory(nid, start, size, ZONE_HIGHMEM);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
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

