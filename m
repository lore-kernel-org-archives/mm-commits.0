From: akpm@linux-foundation.org
Subject: [merged] virtio-do-not-drop-__gfp_high-in-alloc_indirect.patch
 removed from -mm tree
Date: Mon, 07 Dec 2015 11:45:06 -0800
Message-ID: <5665e1c2.BOuLuCM6yEcmn0kh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbbLGTpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2015 14:45:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@techsingularity.net, mst@redhat.com, rusty@rustcorp.com.au, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio: do not drop __GFP_HIGH in alloc_indirect
has been removed from the -mm tree.  Its filename was
     virtio-do-not-drop-__gfp_high-in-alloc_indirect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: virtio: do not drop __GFP_HIGH in alloc_indirect

b92b1b89a33c ("virtio: force vring descriptors to be allocated from
lowmem") tried to exclude highmem pages for descriptors so it cleared
__GFP_HIGHMEM from a given gfp mask.  The patch also cleared __GFP_HIGH
which doesn't make much sense for this fix because __GFP_HIGH only
controls access to memory reserves and it doesn't have any influence on
the zone selection.  Some of the call paths use GFP_ATOMIC and dropping
__GFP_HIGH will reduce their changes for success because the lack of
access to memory reserves.

I have stumbled over this code while looking at other issue [1].  I think
that using __GFP_HIGH simply got there because of its confusing name.  It
doesn't have anything to do with the highmem zone.

I think that clearing __GFP_HIGHMEM is bogus in the current code because
all code paths either use GFP_KERNEL or GFP_ATOMIC and those do not fall
back to the highmem zone but I have kept it because clearing the flag
cannot be harmful.

[1] http://lkml.kernel.org/r/87h9k4kzcv.fsf%40yhuang-dev.intel.com

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/virtio/virtio_ring.c~virtio-do-not-drop-__gfp_high-in-alloc_indirect drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c~virtio-do-not-drop-__gfp_high-in-alloc_indirect
+++ a/drivers/virtio/virtio_ring.c
@@ -109,7 +109,7 @@ static struct vring_desc *alloc_indirect
 	 * otherwise virt_to_phys will give us bogus addresses in the
 	 * virtqueue.
 	 */
-	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
+	gfp &= ~__GFP_HIGHMEM;
 
 	desc = kmalloc(total_sg * sizeof(struct vring_desc), gfp);
 	if (!desc)
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmstat-allow-wq-concurrency-to-discover-memory-reclaim-doesnt-make-any-progress.patch
mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch

