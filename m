From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 arm64-memory-give-hotplug-memory-a-different-resource-name.patch removed
 from -mm tree
Date: Mon, 11 May 2020 13:31:29 -0700
Message-ID: <20200511203129.vg0jjaJtr%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgEKUba (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 16:31:30 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, bhsharma@redhat.com, catalin.marinas@arm.com, david@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, james.morse@arm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, piliu@redhat.com, will@kernel.org


The patch titled
     Subject: arm64: memory: give hotplug memory a different resource name
has been removed from the -mm tree.  Its filename was
     arm64-memory-give-hotplug-memory-a-different-resource-name.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: arm64: memory: give hotplug memory a different resource name

If kexec chooses to place the kernel in a memory region that was added
after boot, we fail to boot as the kernel is running from a location that
is not described as memory by the UEFI memory map or the original DT.

To prevent unaware user-space kexec from doing this accidentally, give
these regions a different name.

Link: http://lkml.kernel.org/r/20200326180730.4754-4-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
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

 arch/arm64/include/asm/memory.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/include/asm/memory.h~arm64-memory-give-hotplug-memory-a-different-resource-name
+++ a/arch/arm64/include/asm/memory.h
@@ -156,6 +156,17 @@
 #define IOREMAP_MAX_ORDER	(PMD_SHIFT)
 #endif
 
+/*
+ * Memory hotplug allows new regions of 'System RAM' to be added to the system.
+ * These aren't described as memory by the UEFI memory map, or DT memory node.
+ * If we kexec from one of these regions, the new kernel boots from a location
+ * that isn't described as RAM.
+ *
+ * Give these resources a different name, so unaware kexec doesn't do this by
+ * accident.
+ */
+#define MEMORY_HOTPLUG_RES_NAME "System RAM (hotplug)"
+
 #ifndef __ASSEMBLY__
 extern u64			vabits_actual;
 #define PAGE_END		(_PAGE_END(vabits_actual))
_

Patches currently in -mm which might be from james.morse@arm.com are
