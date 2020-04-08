From: akpm@linux-foundation.org
Subject: [merged] drivers-base-memory-map-mmop_offline-to-0.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:06 -0700
Message-ID: <20200408015906.72NQxFPgQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: drivers/base/memory: map MMOP_OFFLINE to 0
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-map-mmop_offline-to-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: map MMOP_OFFLINE to 0

Historically, we used the value -1.  Just treat 0 as the special case now.
Clarify a comment (which was wrong, when we come via device_online() the
first time, the online_type would have been 0 / MEM_ONLINE).  The default
is now always MMOP_OFFLINE.  This removes the last user of the manual
"-1", which didn't use the enum value.

This is a preparation to use the online_type as an array index.

Link: http://lkml.kernel.org/r/20200317104942.11178-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Yumei Huang <yuhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   11 ++++-------
 include/linux/memory_hotplug.h |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-map-mmop_offline-to-0
+++ a/drivers/base/memory.c
@@ -203,17 +203,14 @@ static int memory_subsys_online(struct d
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
