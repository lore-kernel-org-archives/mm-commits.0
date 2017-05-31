From: akpm@linux-foundation.org
Subject: +
 lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
 added to -mm tree
Date: Wed, 31 May 2017 12:09:08 -0700
Message-ID: <592f14d4.r5AcLXj4U9AfJ70H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdEaTJJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 15:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, herbert@gondor.apana.org.au, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rhashtable.c: use kvzalloc() in bucket_table_alloc() when possible
has been added to the -mm tree.  Its filename is
     lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch

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
Subject: lib/rhashtable.c: use kvzalloc() in bucket_table_alloc() when possible

bucket_table_alloc() can be currently called with GFP_KERNEL or
GFP_ATOMIC.  For the former we basically have an open coded kvzalloc()
while the later only uses kzalloc().  Let's simplify the code a bit by the
dropping the open coded path and replace it with kvzalloc().

Link: http://lkml.kernel.org/r/20170531155145.17111-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/rhashtable.c~lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible lib/rhashtable.c
--- a/lib/rhashtable.c~lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible
+++ a/lib/rhashtable.c
@@ -211,11 +211,10 @@ static struct bucket_table *bucket_table
 	int i;
 
 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) ||
-	    gfp != GFP_KERNEL)
+	if (gfp != GFP_KERNEL)
 		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
-	if (tbl == NULL && gfp == GFP_KERNEL)
-		tbl = vzalloc(size);
+	else
+		tbl = kvzalloc(size, gfp);
 
 	size = nbuckets;
 
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

