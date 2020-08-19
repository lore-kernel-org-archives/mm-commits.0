Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EA8C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 162792076E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597805716;
	bh=MxnHMnoyIusjo6rXTJ7PLTAGgg9+qNo6mXv7q0/Zmx0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GFIEH6qHHeivoOaT1PMTGD1U/kHgx1iRaRcTKhVpbyKSNHY3l8vJcfl/XR1FbE2Ow
	 TXpz7qcN4ecYazs9Ce+9ZJxQFf12dz+dXiz0YPCnsCakoPegr3gKqi4aov0SJF0xAY
	 CTnQc3mQZ6kmKmelRFkOw3GOBovnpgIZCrEatsKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHSCzP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbgHSCzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:55:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA092078B;
        Wed, 19 Aug 2020 02:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805714;
        bh=MxnHMnoyIusjo6rXTJ7PLTAGgg9+qNo6mXv7q0/Zmx0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Gpedxwk1BdIwGupLJIhBOWN3pNAp4MK+oq+2ogNlZgK3H/NiVI9Bvm/xJltk1V+kE
         fy614rhOAf9+jQoaapLujDcUYvKAYEAnVVV1NFkMBTuHsNOMiDbmoRpsQAbwRfAGKk
         Y2e6eSXg8Ip9raURFrsYRo/OW2QhhX6vKeLPdRpA=
Date:   Tue, 18 Aug 2020 19:55:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  + virtio-mem-dont-special-case-zone_movable.patch added
 to -mm tree
Message-ID: <20200819025513.CEEcrclOQ%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: don't special-case ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     virtio-mem-dont-special-case-zone_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/virtio-mem-dont-special-case-zone_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/virtio-mem-dont-special-case-zone_movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: don't special-case ZONE_MOVABLE

When introducing virtio-mem, the semantics of ZONE_MOVABLE were rather
unclear, which is why we special-cased ZONE_MOVABLE such that partially
plugged blocks would never end up in ZONE_MOVABLE.

Now that the semantics are much clearer (and will be documented in a
follow-up patch including the new virtio-mem behavior), let's allow to
online partially plugged memory blocks to ZONE_MOVABLE and also consider
memory blocks that were onlined to ZONE_MOVABLE when unplugging memory. 
While unplugged memory pages are, in general, unmovable, they can be
skipped when offlining memory.

virtio-mem only unplugs fairly big chunks (in the megabyte range) and
rather tries to shrink the memory region than randomly choosing memory. 
In theory, if all other pages in the movable zone would be movable,
virtio-mem would only shrink that zone and not create any kind of
fragmentation.

In the future, we might want to remember the zone again and use the
information when (un)plugging memory.  For now, let's keep it simple.

Note: Support for defragmentation is planned, to deal with fragmentation
after unplug due to memory chunks within memory blocks that could not get
unplugged before (e.g., somebody pinning pages within ZONE_MOVABLE for a
longer time).

Link: http://lkml.kernel.org/r/20200816125333.7434-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |   47 +++++-----------------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-dont-special-case-zone_movable
+++ a/drivers/virtio/virtio_mem.c
@@ -36,18 +36,10 @@ enum virtio_mem_mb_state {
 	VIRTIO_MEM_MB_STATE_OFFLINE,
 	/* Partially plugged, fully added to Linux, offline. */
 	VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL,
-	/* Fully plugged, fully added to Linux, online (!ZONE_MOVABLE). */
+	/* Fully plugged, fully added to Linux, online. */
 	VIRTIO_MEM_MB_STATE_ONLINE,
-	/* Partially plugged, fully added to Linux, online (!ZONE_MOVABLE). */
+	/* Partially plugged, fully added to Linux, online. */
 	VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL,
-	/*
-	 * Fully plugged, fully added to Linux, online (ZONE_MOVABLE).
-	 * We are not allowed to allocate (unplug) parts of this block that
-	 * are not movable (similar to gigantic pages). We will never allow
-	 * to online OFFLINE_PARTIAL to ZONE_MOVABLE (as they would contain
-	 * unmovable parts).
-	 */
-	VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE,
 	VIRTIO_MEM_MB_STATE_COUNT
 };
 
@@ -526,21 +518,10 @@ static bool virtio_mem_owned_mb(struct v
 }
 
 static int virtio_mem_notify_going_online(struct virtio_mem *vm,
-					  unsigned long mb_id,
-					  enum zone_type zone)
+					  unsigned long mb_id)
 {
 	switch (virtio_mem_mb_get_state(vm, mb_id)) {
 	case VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL:
-		/*
-		 * We won't allow to online a partially plugged memory block
-		 * to the MOVABLE zone - it would contain unmovable parts.
-		 */
-		if (zone == ZONE_MOVABLE) {
-			dev_warn_ratelimited(&vm->vdev->dev,
-					     "memory block has holes, MOVABLE not supported\n");
-			return NOTIFY_BAD;
-		}
-		return NOTIFY_OK;
 	case VIRTIO_MEM_MB_STATE_OFFLINE:
 		return NOTIFY_OK;
 	default:
@@ -560,7 +541,6 @@ static void virtio_mem_notify_offline(st
 					VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL);
 		break;
 	case VIRTIO_MEM_MB_STATE_ONLINE:
-	case VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE:
 		virtio_mem_mb_set_state(vm, mb_id,
 					VIRTIO_MEM_MB_STATE_OFFLINE);
 		break;
@@ -579,24 +559,17 @@ static void virtio_mem_notify_offline(st
 	virtio_mem_retry(vm);
 }
 
-static void virtio_mem_notify_online(struct virtio_mem *vm, unsigned long mb_id,
-				     enum zone_type zone)
+static void virtio_mem_notify_online(struct virtio_mem *vm, unsigned long mb_id)
 {
 	unsigned long nb_offline;
 
 	switch (virtio_mem_mb_get_state(vm, mb_id)) {
 	case VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL:
-		BUG_ON(zone == ZONE_MOVABLE);
 		virtio_mem_mb_set_state(vm, mb_id,
 					VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL);
 		break;
 	case VIRTIO_MEM_MB_STATE_OFFLINE:
-		if (zone == ZONE_MOVABLE)
-			virtio_mem_mb_set_state(vm, mb_id,
-					    VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE);
-		else
-			virtio_mem_mb_set_state(vm, mb_id,
-						VIRTIO_MEM_MB_STATE_ONLINE);
+		virtio_mem_mb_set_state(vm, mb_id, VIRTIO_MEM_MB_STATE_ONLINE);
 		break;
 	default:
 		BUG();
@@ -675,7 +648,6 @@ static int virtio_mem_memory_notifier_cb
 	const unsigned long start = PFN_PHYS(mhp->start_pfn);
 	const unsigned long size = PFN_PHYS(mhp->nr_pages);
 	const unsigned long mb_id = virtio_mem_phys_to_mb_id(start);
-	enum zone_type zone;
 	int rc = NOTIFY_OK;
 
 	if (!virtio_mem_overlaps_range(vm, start, size))
@@ -717,8 +689,7 @@ static int virtio_mem_memory_notifier_cb
 			break;
 		}
 		vm->hotplug_active = true;
-		zone = page_zonenum(pfn_to_page(mhp->start_pfn));
-		rc = virtio_mem_notify_going_online(vm, mb_id, zone);
+		rc = virtio_mem_notify_going_online(vm, mb_id);
 		break;
 	case MEM_OFFLINE:
 		virtio_mem_notify_offline(vm, mb_id);
@@ -726,8 +697,7 @@ static int virtio_mem_memory_notifier_cb
 		mutex_unlock(&vm->hotplug_mutex);
 		break;
 	case MEM_ONLINE:
-		zone = page_zonenum(pfn_to_page(mhp->start_pfn));
-		virtio_mem_notify_online(vm, mb_id, zone);
+		virtio_mem_notify_online(vm, mb_id);
 		vm->hotplug_active = false;
 		mutex_unlock(&vm->hotplug_mutex);
 		break;
@@ -1906,8 +1876,7 @@ static void virtio_mem_remove(struct vir
 	if (vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE] ||
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL] ||
 	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE] ||
-	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL] ||
-	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE]) {
+	    vm->nb_mb_state[VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL]) {
 		dev_warn(&vdev->dev, "device still has system memory added\n");
 	} else {
 		virtio_mem_delete_resource(vm);
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch

