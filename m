From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 12:38:57 -0700
Message-ID: <20200624193857.Rfe0o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391239AbgFXTi6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.com, dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com, david@redhat.com


The patch titled
     Subject: mm/memory_hotplug: document why shuffle_zone() is relevant
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch

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
Subject: mm/memory_hotplug: document why shuffle_zone() is relevant

It's not completely obvious why we have to shuffle the complete zone -
introduced in commit e900a918b098 ("mm: shuffle initial free memory to
improve memory-side-cache utilization") - because some sort of shuffling
is already performed when onlining pages via __free_one_page(), placing
MAX_ORDER-1 pages either to the head or the tail of the freelist.  Let's
document why we have to shuffle the complete zone when exposing larger,
contiguous physical memory areas to the buddy.

Link: http://lkml.kernel.org/r/20200624094741.9918-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-document-why-shuffle_zone-is-relevant
+++ a/mm/memory_hotplug.c
@@ -831,6 +831,14 @@ int __ref online_pages(unsigned long pfn
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
+	/*
+	 * When exposing larger, physically contiguous memory areas to the
+	 * buddy, shuffling in the buddy (when freeing onlined pages, putting
+	 * them either to the head or the tail of the freelist) is only helpful
+	 * for maintaining the shuffle, but not for creating the initial
+	 * shuffle. Shuffle the whole zone to make sure the just onlined pages
+	 * are properly distributed across the whole freelist.
+	 */
 	shuffle_zone(zone);
 
 	node_states_set_node(nid, &arg);
_

Patches currently in -mm which might be from david@redhat.com are

mm-shuffle-dont-move-pages-between-zones-and-dont-read-garbage-memmaps.patch
mm-drop-vm_total_pages.patch
mm-page_alloc-drop-nr_free_pagecache_pages.patch
mm-memory_hotplug-document-why-shuffle_zone-is-relevant.patch
mm-shuffle-remove-dynamic-reconfiguration.patch
