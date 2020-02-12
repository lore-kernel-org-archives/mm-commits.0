From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
 added to -mm tree
Date: Tue, 11 Feb 2020 16:19:55 -0800
Message-ID: <20200212001955.B2WSkW8zE%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgBLAT7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:19:59 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, vbabka@suse.cz, wei.w.wang@intel.com, willy@infradead.org, yang.zhang.wz@gmail.com


The patch titled
     Subject: virtio-balloon: pull page poisoning config out of free page hinting
has been added to the -mm tree.  Its filename is
     virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: virtio-balloon: pull page poisoning config out of free page hinting

Currently the page poisoning setting wasn't being enabled unless free page
hinting was enabled.  However we will need the page poisoning tracking
logic as well for free page reporting.  As such pull it out and make it a
separate bit of config in the probe function.

In addition we need to add support for the more recent init_on_free
feature which expects a behavior similar to page poisoning in that we
expect the page to be pre-zeroed.

Link: http://lkml.kernel.org/r/20200211224646.29318.695.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting
+++ a/drivers/virtio/virtio_balloon.c
@@ -864,7 +864,6 @@ static int virtio_balloon_register_shrin
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -930,11 +929,20 @@ static int virtballoon_probe(struct virt
 						  VIRTIO_BALLOON_CMD_ID_STOP);
 		spin_lock_init(&vb->free_page_list_lock);
 		INIT_LIST_HEAD(&vb->free_page_list);
-		if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
+	}
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
+		/* Start with poison val of 0 representing general init */
+		__u32 poison_val = 0;
+
+		/*
+		 * Let the hypervisor know that we are expecting a
+		 * specific value to be written back in balloon pages.
+		 */
+		if (!want_init_on_free())
 			memset(&poison_val, PAGE_POISON, sizeof(poison_val));
-			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
-				      poison_val, &poison_val);
-		}
+
+		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
+			      poison_val, &poison_val);
 	}
 	/*
 	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
@@ -1045,7 +1053,10 @@ static int virtballoon_restore(struct vi
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Tell the host whether we care about poisoned pages. */
+	if (!want_init_on_free() &&
+	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	     !page_poisoning_enabled()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.com are

mm-adjust-shuffle-code-to-allow-for-future-coalescing.patch
mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
mm-add-function-__putback_isolated_page.patch
mm-introduce-reported-pages.patch
virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
virtio-balloon-add-support-for-providing-free-page-reports-to-host.patch
mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch
mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch
mm-page_reporting-add-free-page-reporting-documentation.patch
