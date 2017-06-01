From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-fix-mmop_online_keep-behavior.patch added to
 -mm tree
Date: Thu, 01 Jun 2017 15:12:44 -0700
Message-ID: <5930915c.jaqvSDOaFurxLD3g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAWMp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, arbab@linux.vnet.ibm.com, dan.j.williams@intel.com, heiko.carstens@de.ibm.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: fix MMOP_ONLINE_KEEP behavior
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-mmop_online_keep-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-mmop_online_keep-behavior.patch

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
Subject: mm, memory_hotplug: fix MMOP_ONLINE_KEEP behavior

Heiko Carstens has noticed that the MMOP_ONLINE_KEEP is broken currently
$ grep . memory3?/valid_zones
memory34/valid_zones:Normal Movable
memory35/valid_zones:Normal Movable
memory36/valid_zones:Normal Movable
memory37/valid_zones:Normal Movable

$ echo online_movable > memory34/state
$ grep . memory3?/valid_zones
memory34/valid_zones:Movable
memory35/valid_zones:Movable
memory36/valid_zones:Movable
memory37/valid_zones:Movable

$ echo online > memory36/state
$ grep . memory3?/valid_zones
memory34/valid_zones:Movable
memory36/valid_zones:Normal
memory37/valid_zones:Movable

so we have effectivelly punched a hole into the movable zone.  The problem
is that move_pfn_range() check for MMOP_ONLINE_KEEP is wrong.  It only
checks whether the given range is already part of the movable zone which
is not the case here as only memory34 is in the zone.  Fix this by using
allow_online_pfn_range(..., MMOP_ONLINE_KERNEL) if that is false then we
can be sure that movable onlining is the right thing to do.

Fixes: "mm, memory_hotplug: do not associate hotadded memory to zones until online"
Link: http://lkml.kernel.org/r/20170601083746.4924-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-fix-mmop_online_keep-behavior mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-mmop_online_keep-behavior
+++ a/mm/memory_hotplug.c
@@ -1124,11 +1124,12 @@ static struct zone * __meminit move_pfn_
 	if (online_type == MMOP_ONLINE_KEEP) {
 		struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
 		/*
-		 * MMOP_ONLINE_KEEP inherits the current zone which is
-		 * ZONE_NORMAL by default but we might be within ZONE_MOVABLE
-		 * already.
+		 * MMOP_ONLINE_KEEP defaults to MMOP_ONLINE_KERNEL but use
+		 * movable zone if that is not possible (e.g. we are within
+		 * or past the existing movable zone)
 		 */
-		if (zone_intersects(movable_zone, start_pfn, nr_pages))
+		if (!allow_online_pfn_range(nid, start_pfn, nr_pages,
+					MMOP_ONLINE_KERNEL))
 			zone = movable_zone;
 	} else if (online_type == MMOP_ONLINE_MOVABLE) {
 		zone = &pgdat->node_zones[ZONE_MOVABLE];
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
mm-consider-memblock-reservations-for-deferred-memory-initialization-sizing.patch
fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

