From: akpm@linux-foundation.org
Subject: +
 memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch
 added to -mm tree
Date: Mon, 21 Jul 2014 14:54:18 -0700
Message-ID: <53cd8c0a.BE3Sd28VWV7gSWbn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:53062 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaGUVyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 17:54:20 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1643682oah.2
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 14:54:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, akpm@linux-foundation.org, benh@kernel.crashing.org, cmetcalf@tilera.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: add zone_for_memory() for selecting zone for new memory
has been added to the -mm tree.  Its filename is
     memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch

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
Subject: memory-hotplug: add zone_for_memory() for selecting zone for new memory


This series of patches fixes a problem when adding memory in bad manner. 
For example: for a x86_64 machine booted with "mem=400M" and with 2GiB
memory installed, following commands cause problem:

  # echo 0x40000000 > /sys/devices/system/memory/probe
 [   28.613895] init_memory_mapping: [mem 0x40000000-0x47ffffff]
  # echo 0x48000000 > /sys/devices/system/memory/probe
 [   28.693675] init_memory_mapping: [mem 0x48000000-0x4fffffff]
  # echo online_movable > /sys/devices/system/memory/memory9/state
  # echo 0x50000000 > /sys/devices/system/memory/probe 
 [   29.084090] init_memory_mapping: [mem 0x50000000-0x57ffffff]
  # echo 0x58000000 > /sys/devices/system/memory/probe 
 [   29.151880] init_memory_mapping: [mem 0x58000000-0x5fffffff]
  # echo online_movable > /sys/devices/system/memory/memory11/state
  # echo online> /sys/devices/system/memory/memory8/state
  # echo online> /sys/devices/system/memory/memory10/state
  # echo offline> /sys/devices/system/memory/memory9/state
 [   30.558819] Offlined Pages 32768
  # free
              total       used       free     shared    buffers     cached
 Mem:        780588 18014398509432020     830552          0          0      51180
 -/+ buffers/cache: 18014398509380840     881732
 Swap:            0          0          0

This is because the above commands probe higher memory after online a
section with online_movable, which causes ZONE_HIGHMEM (or ZONE_NORMAL for
systems without ZONE_HIGHMEM) overlaps ZONE_MOVABLE.

After the second online_movable, the problem can be observed from
zoneinfo:

 # cat /proc/zoneinfo
...
Node 0, zone  Movable
  pages free     65491
        min      250
        low      312
        high     375
        scanned  0
        spanned  18446744073709518848
        present  65536
        managed  65536
...

This series of patches solve the problem by checking ZONE_MOVABLE when
choosing zone for new memory. If new memory is inside or higher than
ZONE_MOVABLE, makes it go there instead.

After applying this series of patches, following are free and zoneinfo
result (after offlining memory9):

bash-4.2# free
              total       used       free     shared    buffers     cached
 Mem:        780956      80112     700844          0          0      51180
 -/+ buffers/cache:      28932     752024
 Swap:            0          0          0

bash-4.2# cat /proc/zoneinfo

Node 0, zone      DMA
  pages free     3389
        min      14
        low      17
        high     21
        scanned  0
        spanned  4095
        present  3998
        managed  3977
    nr_free_pages 3389
...
  start_pfn:         1
  inactive_ratio:    1
Node 0, zone    DMA32
  pages free     73724
        min      341
        low      426
        high     511
        scanned  0
        spanned  98304
        present  98304
        managed  92958
    nr_free_pages 73724
...
  start_pfn:         4096
  inactive_ratio:    1
Node 0, zone   Normal
  pages free     32630
        min      120
        low      150
        high     180
        scanned  0
        spanned  32768
        present  32768
        managed  32768
    nr_free_pages 32630
...
  start_pfn:         262144
  inactive_ratio:    1
Node 0, zone  Movable
  pages free     65476
        min      241
        low      301
        high     361
        scanned  0
        spanned  98304
        present  65536
        managed  65536
    nr_free_pages 65476
...
  start_pfn:         294912
  inactive_ratio:    1




This patch (of 7):

Introduce zone_for_memory() in arch independent code for arch_add_memory()
use.

Many arch_add_memory() function simply selects ZONE_HIGHMEM or ZONE_NORMAL
and add new memory into it.  However, with the existance of ZONE_MOVABLE,
the selection method should be carefully considered: if new, higher memory
is added after ZONE_MOVABLE is setup, the default zone and ZONE_MOVABLE
may overlap each other.

should_add_memory_movable() checks the status of ZONE_MOVABLE.  If it has
already contain memory, compare the address of new memory and movable
memory.  If new memory is higher than movable, it should be added into
ZONE_MOVABLE instead of default zone.

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

 include/linux/memory_hotplug.h |    1 +
 mm/memory_hotplug.c            |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory
+++ a/include/linux/memory_hotplug.h
@@ -259,6 +259,7 @@ static inline void remove_memory(int nid
 extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
 		void *arg, int (*func)(struct memory_block *, void *));
 extern int add_memory(int nid, u64 start, u64 size);
+extern int zone_for_memory(int nid, u64 start, u64 size, int zone_default);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
diff -puN mm/memory_hotplug.c~memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory
+++ a/mm/memory_hotplug.c
@@ -1159,6 +1159,34 @@ static int check_hotplug_memory_range(u6
 	return 0;
 }
 
+/*
+ * If movable zone has already been setup, newly added memory should be check.
+ * If its address is higher than movable zone, it should be added as movable.
+ * Without this check, movable zone may overlap with other zone.
+ */
+static int should_add_memory_movable(int nid, u64 start, u64 size)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	pg_data_t *pgdat = NODE_DATA(nid);
+	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
+
+	if (zone_is_empty(movable_zone))
+		return 0;
+
+	if (movable_zone->zone_start_pfn <= start_pfn)
+		return 1;
+
+	return 0;
+}
+
+int zone_for_memory(int nid, u64 start, u64 size, int zone_default)
+{
+	if (should_add_memory_movable(nid, start, size))
+		return ZONE_MOVABLE;
+
+	return zone_default;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 int __ref add_memory(int nid, u64 start, u64 size)
 {
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

