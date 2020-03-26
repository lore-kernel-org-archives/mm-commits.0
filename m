From: akpm@linux-foundation.org
Subject: +
 arm64-memory-give-hotplug-memory-a-different-resource-name.patch added to
 -mm tree
Date: Thu, 26 Mar 2020 12:28:09 -0700
Message-ID: <20200326192809.ThpX5QZOK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZT2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 15:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, bhsharma@redhat.com, catalin.marinas@arm.com, david@redhat.com, ebiederm@xmission.com, james.morse@arm.com, mm-commits@vger.kernel.org, will@kernel.org


The patch titled
     Subject: arm64: memory: give hotplug memory a different resource name
has been added to the -mm tree.  Its filename is
     arm64-memory-give-hotplug-memory-a-different-resource-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-memory-give-hotplug-memory-a-different-resource-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-memory-give-hotplug-memory-a-different-resource-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/include/asm/memory.h~arm64-memory-give-hotplug-memory-a-different-resource-name
+++ a/arch/arm64/include/asm/memory.h
@@ -166,6 +166,17 @@
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

kexec-prevent-removal-of-memory-in-use-by-a-loaded-kexec-image.patch
mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch
arm64-memory-give-hotplug-memory-a-different-resource-name.patch
