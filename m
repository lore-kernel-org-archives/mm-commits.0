From: akpm@linux-foundation.org
Subject: + netfilter-use-kvmalloc-xt_alloc_table_info.patch added to -mm
 tree
Date: Wed, 31 May 2017 12:09:10 -0700
Message-ID: <592f14d6.Rn7n8f/ZeRcSIymS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdEaTJL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 15:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, fw@strlen.de, kadlec@blackhole.kfki.hu, pablo@netfilter.org, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()
has been added to the -mm tree.  Its filename is
     netfilter-use-kvmalloc-xt_alloc_table_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/netfilter-use-kvmalloc-xt_alloc_table_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/netfilter-use-kvmalloc-xt_alloc_table_info.patch

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
Subject: net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()

xt_alloc_table_info() basically opencodes kvmalloc() so use the library
function instead.

Link: http://lkml.kernel.org/r/20170531155145.17111-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN net/netfilter/x_tables.c~netfilter-use-kvmalloc-xt_alloc_table_info net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~netfilter-use-kvmalloc-xt_alloc_table_info
+++ a/net/netfilter/x_tables.c
@@ -1003,14 +1003,10 @@ struct xt_table_info *xt_alloc_table_inf
 	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
-	if (sz <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
-		info = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
-	if (!info) {
-		info = __vmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
-				 PAGE_KERNEL);
-		if (!info)
-			return NULL;
-	}
+	info = kvmalloc(sz, GFP_KERNEL);
+	if (!info)
+		return NULL;
+
 	memset(info, 0, sizeof(*info));
 	info->size = size;
 	return info;
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
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
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

