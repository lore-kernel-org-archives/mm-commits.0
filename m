From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 =?US-ASCII?Q?mm-memory=5Fhotplug-allow-arch-override-of-non-boot-memory-?=
 =?US-ASCII?Q?resource-names.patch?= removed from -mm tree
Date: Mon, 11 May 2020 13:31:23 -0700
Message-ID: <20200511203123.Ndb2w3lNk%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgEKUbY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 16:31:24 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, bhsharma@redhat.com, catalin.marinas@arm.com, david@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, james.morse@arm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, piliu@redhat.com, will@kernel.org


The patch titled
     Subject: mm/memory_hotplug: allow arch override of non boot memory resource names
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: mm/memory_hotplug: allow arch override of non boot memory resource names

Memory added to the system by hotplug has a 'System RAM' resource created
for it.  This is exposed to user-space via /proc/iomem.

This poses problems for kexec on arm64.  If kexec decides to place the
kernel in one of these newly onlined regions, the new kernel will find
itself booting from a region not described as memory in the firmware
tables.

Arm64 doesn't have a structure like the e820 memory map that can be
re-written when memory is brought online.  Instead arm64 uses the UEFI
memory map, or the memory node from the DT, sometimes both.  We never
rewrite these.

Allow an architecture to specify a different name for these hotplug
regions.

Link: http://lkml.kernel.org/r/20200326180730.4754-3-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: piliu <piliu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names
+++ a/mm/memory_hotplug.c
@@ -42,6 +42,10 @@
 #include "internal.h"
 #include "shuffle.h"
 
+#ifndef MEMORY_HOTPLUG_RES_NAME
+#define MEMORY_HOTPLUG_RES_NAME "System RAM"
+#endif
+
 /*
  * online_page_callback contains pointer to current page onlining function.
  * Initially it is generic_online_page(). If it is required it could be
@@ -104,7 +108,7 @@ static struct resource *register_memory_
 	struct resource *res;
 	unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-	if (strcmp(resource_name, "System RAM"))
+	if (strcmp(resource_name, MEMORY_HOTPLUG_RES_NAME))
 		flags |= IORESOURCE_MEM_DRIVER_MANAGED;
 
 	/*
_

Patches currently in -mm which might be from james.morse@arm.com are

arm64-memory-give-hotplug-memory-a-different-resource-name.patch
