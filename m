From: akpm@linux-foundation.org
Subject: +
 mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch added
 to -mm tree
Date: Wed, 17 May 2017 14:51:17 -0700
Message-ID: <591cc5d5.mIzYBgsLFWmf8VuZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbdEQVvS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2017 17:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, chris@chris-wilson.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify why we want kmalloc before falling backto vmallock
has been added to the -mm tree.  Its filename is
     mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch

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
Subject: mm: clarify why we want kmalloc before falling backto vmallock

While converting drm_[cm]alloc* helpers to kvmalloc* variants Chris Wilson
has wondered why we want to try kmalloc before vmalloc fallback even for
larger allocations requests.  Let's clarify that one larger physically
contiguous block is less likely to fragment memory than many scattered
pages which can prevent more large blocks from being created.

Link: http://lkml.kernel.org/r/20170517080932.21423-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock mm/util.c
--- a/mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock
+++ a/mm/util.c
@@ -357,7 +357,10 @@ void *kvmalloc_node(size_t size, gfp_t f
 	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
 
 	/*
-	 * Make sure that larger requests are not too disruptive - no OOM
+	 * We want to attempt a large physically contiguous block first because
+	 * it is less likely to fragment multiple larger blocks and therefore
+	 * contribute to a long term fragmentation less than vmalloc fallback.
+	 * However make sure that larger requests are not too disruptive - no OOM
 	 * killer and no allocation failure warnings as we have a fallback
 	 */
 	if (size > PAGE_SIZE) {
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
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch

