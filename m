From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-map-mmop_offline-to-0.patch added
 to -mm tree
Date: Wed, 11 Mar 2020 17:00:29 -0700
Message-ID: <20200312000029.Rr36jpA8p%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgCLAAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:00:31 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, kys@microsoft.com, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, tglx@linutronix.de, wei.liu@kernel.org


The patch titled
     Subject: drivers/base/memory: map MMOP_OFFLINE to 0
has been added to the -mm tree.  Its filename is
     drivers-base-memory-map-mmop_offline-to-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memory-map-mmop_offline-to-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memory-map-mmop_offline-to-0.patch

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
Subject: drivers/base/memory: map MMOP_OFFLINE to 0

I have no idea why we have to start at -1.  Just treat 0 as the special
case.  Clarify a comment (which was wrong, when we come via
device_online() the first time, the online_type would have been 0 /
MEM_ONLINE).  The default is now always MMOP_OFFLINE.

This is a preparation to use the online_type as an array index.

Link: http://lkml.kernel.org/r/20200311123026.16071-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   11 ++++-------
 include/linux/memory_hotplug.h |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-map-mmop_offline-to-0
+++ a/drivers/base/memory.c
@@ -211,17 +211,14 @@ static int memory_subsys_online(struct d
 		return 0;
 
 	/*
-	 * If we are called from state_store(), online_type will be
-	 * set >= 0 Otherwise we were called from the device online
-	 * attribute and need to set the online_type.
+	 * When called via device_online() without configuring the online_type,
+	 * we want to default to MMOP_ONLINE.
 	 */
-	if (mem->online_type < 0)
+	if (mem->online_type == MMOP_OFFLINE)
 		mem->online_type = MMOP_ONLINE;
 
 	ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
-
-	/* clear online_type */
-	mem->online_type = -1;
+	mem->online_type = MMOP_OFFLINE;
 
 	return ret;
 }
--- a/include/linux/memory_hotplug.h~drivers-base-memory-map-mmop_offline-to-0
+++ a/include/linux/memory_hotplug.h
@@ -48,7 +48,7 @@ enum {
 /* Types for control the zone type of onlined and offlined memory */
 enum {
 	/* Offline the memory. */
-	MMOP_OFFLINE = -1,
+	MMOP_OFFLINE = 0,
 	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
 	MMOP_ONLINE,
 	/* Online the memory to ZONE_NORMAL. */
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
virtio-balloon-switch-back-to-oom-handler-for-virtio_balloon_f_deflate_on_oom.patch
drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
drivers-base-memoryc-drop-section_count.patch
drivers-base-memoryc-drop-pages_correctly_probed.patch
mm-page_extc-drop-pfn_present-check-when-onlining.patch
mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch
mm-memory_hotplug-cleanup-__add_pages.patch
drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch
drivers-base-memory-map-mmop_offline-to-0.patch
drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array.patch
mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
mm-memory_hotplug-allow-to-specify-a-default-online_type.patch
