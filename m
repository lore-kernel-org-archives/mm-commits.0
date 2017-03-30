From: akpm@linux-foundation.org
Subject: + mm-get-rid-of-zone_is_initialized.patch added to -mm tree
Date: Thu, 30 Mar 2017 14:42:08 -0700
Message-ID: <58dd7bb0.yhB47Si8N8As5Y0r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934076AbdC3VmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 17:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, benh@kernel.crashing.org, cmetcalf@mellanox.com, dan.j.williams@gmail.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, hpa@zytor.com, imammedo@redhat.com, js1304@gmail.com, laijs@cn.fujitsu.com, mgorman@suse.de, mingo@elte.hu, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, slaoub@gmail.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: get rid of zone_is_initialized
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-zone_is_initialized.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-get-rid-of-zone_is_initialized.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-get-rid-of-zone_is_initialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: get rid of zone_is_initialized

Motivation: Movable onlining is a real hack with many downsides - mainly
reintroduction of lowmem/highmem issues we used to have on 32b systems -
but it is the only way to make the memory hotremove more reliable which is
something that people are asking for.

The current semantic of memory movable onlinening is really cumbersome,
however.  The main reason for this is that the udev driven approach is
basically unusable because udev races with the memory probing while only
the last memory block or the one adjacent to the existing zone_movable are
allowed to be onlined movable.  In short the criterion for the successful
online_movable changes under udev's feet.  A reliable udev approach would
require a 2 phase approach where the first successful movable online would
have to check all the previous blocks and online them in descending order.
This is hard to be considered sane.

This patchset aims at making the onlining semantic more usable.  First of
all it allows to online memory movable as long as it doesn't clash with
the existing ZONE_NORMAL.  That means that ZONE_NORMAL and ZONE_MOVABLE
cannot overlap.  Currently I preserve the original ordering semantic so
the zone always precedes the movable zone but I have plans to remove this
restriction in future because it is not really necessary.

The series consists of 4 cleanup patches which should be ready to be
merged right away (unless I have missed something subtle of course).

Patch 5 is the core of the change.  In order to make it easier to review I
have tried it to be as minimalistic as possible and the large code removal
is moved to patch 6.

I have tested the patches in kvm:
# qemu-system-x86_64 -enable-kvm -monitor pty -m 2G,slots=4,maxmem=4G -numa node,mem=1G -numa node,mem=1G ...

and then probed the additional memory by
(qemu) object_add memory-backend-ram,id=mem1,size=1G
(qemu) device_add pc-dimm,id=dimm1,memdev=mem1

Then I have used this simple script to probe the memory block by hand
# cat probe_memblock.sh
#!/bin/sh

BLOCK_NR=$1

echo $((0x100000000+$BLOCK_NR*(128<<20))) > /sys/devices/system/memory/probe

# for i in $(seq 10); do sh probe_memblock.sh $i; done
# grep . /sys/devices/system/memory/memory3?/valid_zones 2>/dev/null 
/sys/devices/system/memory/memory33/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory34/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory35/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory36/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory37/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory38/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory39/valid_zones:Normal Movable

The main difference to the original implementation is that all new
memblocks can be both online_kernel and online_movable initially
because there is no clash obviously. For the comparison the original
implementation would have

/sys/devices/system/memory/memory33/valid_zones:Normal                                                                                                                                                     
/sys/devices/system/memory/memory34/valid_zones:Normal                                                                                                                                                     
/sys/devices/system/memory/memory35/valid_zones:Normal                                                                                                                                                     
/sys/devices/system/memory/memory36/valid_zones:Normal                                                                                                                                                     
/sys/devices/system/memory/memory37/valid_zones:Normal                                                                                                                                                     
/sys/devices/system/memory/memory38/valid_zones:Normal                                                                                                                                                     
/sys/devices/system/memory/memory39/valid_zones:Normal Movable

Now
# echo online_movable > /sys/devices/system/memory/memory34/state                                                                                                                                      
# grep . /sys/devices/system/memory/memory3?/valid_zones 2>/dev/null                                                                                                                                   
/sys/devices/system/memory/memory33/valid_zones:Normal Movable                                                                                                                                                     
/sys/devices/system/memory/memory34/valid_zones:Movable                                                                                                                                                            
/sys/devices/system/memory/memory35/valid_zones:Movable                                                                                                                                                            
/sys/devices/system/memory/memory36/valid_zones:Movable                                                                                                                                                            
/sys/devices/system/memory/memory37/valid_zones:Movable                                                                                                                                                            
/sys/devices/system/memory/memory38/valid_zones:Movable
/sys/devices/system/memory/memory39/valid_zones:Movable

Block 33 can still be online both kernel and movable while all
the remaining can be only movable.
/proc/zonelist says
Node 0, zone   Normal
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
--
Node 0, zone  Movable
  pages free     32753
        min      85
        low      117
        high     149
        spanned  32768
        present  32768

A new memblock at a lower address will result in a new memblock (32) which
will still allow both Normal and Movable.

# sh probe_memblock.sh 0
# grep . /sys/devices/system/memory/memory3[2-5]/valid_zones 2>/dev/null
/sys/devices/system/memory/memory32/valid_zones:Normal Movable
/sys/devices/system/memory/memory33/valid_zones:Normal Movable
/sys/devices/system/memory/memory34/valid_zones:Movable
/sys/devices/system/memory/memory35/valid_zones:Movable

and online_kernel will convert it to the zone normal properly
while 33 can be still onlined both ways.
# echo online_kernel > /sys/devices/system/memory/memory32/state
# grep . /sys/devices/system/memory/memory3[2-5]/valid_zones 2>/dev/null
/sys/devices/system/memory/memory32/valid_zones:Normal
/sys/devices/system/memory/memory33/valid_zones:Normal Movable
/sys/devices/system/memory/memory34/valid_zones:Movable
/sys/devices/system/memory/memory35/valid_zones:Movable

/proc/zoneinfo will now tell
Node 0, zone   Normal
  pages free     65441
        min      165
        low      230
        high     295
        spanned  65536
        present  65536
--
Node 0, zone  Movable
  pages free     32740
        min      82
        low      114
        high     146
        spanned  32768
        present  32768

so both zones have one memblock spanned and present.

Onlining 39 should associate this block to the movable zone
# echo online > /sys/devices/system/memory/memory39/state

/proc/zoneinfo will now tell
Node 0, zone   Normal
  pages free     32765
        min      80
        low      112
        high     144
        spanned  32768
        present  32768
--
Node 0, zone  Movable
  pages free     65501
        min      160
        low      225
        high     290
        spanned  196608
        present  65536

so we will have a movable zone which spans 6 memblocks, 2 present and 4
representing a hole.

Offlining both movable blocks will lead to the zone with no present pages
which is the expected behavior I believe.

# echo offline > /sys/devices/system/memory/memory39/state
# echo offline > /sys/devices/system/memory/memory34/state
# grep -A6 "Movable\|Normal" /proc/zoneinfo 
Node 0, zone   Normal
  pages free     32735
        min      90
        low      122
        high     154
        spanned  32768
        present  32768
--
Node 0, zone  Movable
  pages free     0
        min      0
        low      0
        high     0
        spanned  196608
        present  0

As a bonus we will get a nice cleanup in the memory hotplug codebase



This patch (of 5):

There shouldn't be any reason to add initialized when we can tell the same
thing from checking whether there are any pages spanned to the zone. 
Remove zone_is_initialized() and replace it by zone_is_empty which can be
used for the same set of tests.

This shouldn't have any visible effect.

Link: http://lkml.kernel.org/r/20170330115454.32154-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <slaoub@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++------
 mm/memory_hotplug.c    |    6 +++---
 mm/page_alloc.c        |    5 +----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff -puN include/linux/mmzone.h~mm-get-rid-of-zone_is_initialized include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-get-rid-of-zone_is_initialized
+++ a/include/linux/mmzone.h
@@ -442,8 +442,6 @@ struct zone {
 	seqlock_t		span_seqlock;
 #endif
 
-	int initialized;
-
 	/* Write-intensive fields used from the page allocator */
 	ZONE_PADDING(_pad1_)
 
@@ -520,14 +518,15 @@ static inline bool zone_spans_pfn(const
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
-static inline bool zone_is_initialized(struct zone *zone)
+static inline bool zone_is_empty(struct zone *zone)
 {
-	return zone->initialized;
+	return zone->spanned_pages == 0;
 }
 
-static inline bool zone_is_empty(struct zone *zone)
+static inline bool zone_spans_range(const struct zone *zone, unsigned long start_pfn,
+		unsigned long nr_pages)
 {
-	return zone->spanned_pages == 0;
+	return zone->zone_start_pfn <= start_pfn && start_pfn + nr_pages < zone_end_pfn(zone);
 }
 
 /*
diff -puN mm/memory_hotplug.c~mm-get-rid-of-zone_is_initialized mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-get-rid-of-zone_is_initialized
+++ a/mm/memory_hotplug.c
@@ -353,7 +353,7 @@ static void fix_zone_id(struct zone *zon
 static int __ref ensure_zone_is_initialized(struct zone *zone,
 			unsigned long start_pfn, unsigned long num_pages)
 {
-	if (!zone_is_initialized(zone))
+	if (zone_is_empty(zone))
 		return init_currently_empty_zone(zone, start_pfn, num_pages);
 
 	return 0;
@@ -1056,7 +1056,7 @@ bool zone_can_shift(unsigned long pfn, u
 
 		/* no zones in use between current zone and target */
 		for (i = idx + 1; i < target; i++)
-			if (zone_is_initialized(zone - idx + i))
+			if (!zone_is_empty(zone - idx + i))
 				return false;
 	}
 
@@ -1067,7 +1067,7 @@ bool zone_can_shift(unsigned long pfn, u
 
 		/* no zones in use between current zone and target */
 		for (i = target + 1; i < idx; i++)
-			if (zone_is_initialized(zone - idx + i))
+			if (!zone_is_empty(zone - idx + i))
 				return false;
 	}
 
diff -puN mm/page_alloc.c~mm-get-rid-of-zone_is_initialized mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-zone_is_initialized
+++ a/mm/page_alloc.c
@@ -796,7 +796,7 @@ static inline void __free_one_page(struc
 
 	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 
-	VM_BUG_ON(!zone_is_initialized(zone));
+	VM_BUG_ON(zone_is_empty(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
 
 	VM_BUG_ON(migratetype == -1);
@@ -5534,9 +5534,6 @@ int __meminit init_currently_empty_zone(
 			zone_start_pfn, (zone_start_pfn + size));
 
 	zone_init_free_lists(zone);
-	zone->initialized = 1;
-
-	return 0;
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-move-mm_percpu_wq-initialization-earlier.patch
lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-move-pcp-and-lru-pcp-drainging-into-single-wq.patch
mm-get-rid-of-zone_is_initialized.patch
mm-tile-drop-arch_addremove_memory.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch

