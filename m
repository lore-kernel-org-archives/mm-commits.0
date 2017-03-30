From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch added to -mm tree
Date: Thu, 30 Mar 2017 14:42:19 -0700
Message-ID: <58dd7bbb.V0D6f4ObkZPDnAjI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935056AbdC3Vm1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 17:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, benh@kernel.crashing.org, cmetcalf@mellanox.com, dan.j.williams@gmail.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, hpa@zytor.com, imammedo@redhat.com, js1304@gmail.com, laijs@cn.fujitsu.com, mgorman@suse.de, mingo@elte.hu, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, slaoub@gmail.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: use node instead of zone in can_online_high_movable
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch

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
Subject: mm, memory_hotplug: use node instead of zone in can_online_high_movable

The primary purpose of this helper is to query the node state so use the
node id directly.  This is a preparatory patch for later changes.

Link: http://lkml.kernel.org/r/20170330115454.32154-5-mhocko@kernel.org
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

 mm/memory_hotplug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable
+++ a/mm/memory_hotplug.c
@@ -941,15 +941,15 @@ static int online_pages_range(unsigned l
  * When CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
  * normal memory.
  */
-static bool can_online_high_movable(struct zone *zone)
+static bool can_online_high_movable(int nid)
 {
 	return true;
 }
 #else /* CONFIG_MOVABLE_NODE */
 /* ensure every online node has NORMAL memory */
-static bool can_online_high_movable(struct zone *zone)
+static bool can_online_high_movable(int nid)
 {
-	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+	return node_state(nid, N_NORMAL_MEMORY);
 }
 #endif /* CONFIG_MOVABLE_NODE */
 
@@ -1083,7 +1083,7 @@ int __ref online_pages(unsigned long pfn
 
 	if ((zone_idx(zone) > ZONE_NORMAL ||
 	    online_type == MMOP_ONLINE_MOVABLE) &&
-	    !can_online_high_movable(zone))
+	    !can_online_high_movable(pfn_to_nid(pfn)))
 		return -EINVAL;
 
 	if (online_type == MMOP_ONLINE_KERNEL) {
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

