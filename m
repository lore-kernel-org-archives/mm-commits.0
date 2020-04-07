From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 066/166] powernv/memtrace: always online added
 memory blocks
Date: Mon, 06 Apr 2020 20:07:28 -0700
Message-ID: <20200407030728.pFk7rxf2Q%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:32 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, torvalds@linux-foundation.org, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com

From: David Hildenbrand <david@redhat.com>
Subject: powernv/memtrace: always online added memory blocks

Let's always try to online the re-added memory blocks.  In case
add_memory() already onlined the added memory blocks, the first
device_online() call will fail and stop processing the remaining memory
blocks.

This avoids manually having to check memhp_auto_online.

Note: PPC always onlines all hotplugged memory directly from the kernel as
well - something that is handled by user space on other architectures.

Link: http://lkml.kernel.org/r/20200317104942.11178-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Yumei Huang <yuhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/memtrace.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/arch/powerpc/platforms/powernv/memtrace.c~powernv-memtrace-always-online-added-memory-blocks
+++ a/arch/powerpc/platforms/powernv/memtrace.c
@@ -231,16 +231,10 @@ static int memtrace_online(void)
 			continue;
 		}
 
-		/*
-		 * If kernel isn't compiled with the auto online option
-		 * we need to online the memory ourselves.
-		 */
-		if (!memhp_auto_online) {
-			lock_device_hotplug();
-			walk_memory_blocks(ent->start, ent->size, NULL,
-					   online_mem_block);
-			unlock_device_hotplug();
-		}
+		lock_device_hotplug();
+		walk_memory_blocks(ent->start, ent->size, NULL,
+				   online_mem_block);
+		unlock_device_hotplug();
 
 		/*
 		 * Memory was added successfully so clean up references to it
_
