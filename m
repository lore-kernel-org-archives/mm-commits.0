From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-memory=5Fhotplug-allow-arch-override-of-non-boot-memory-?=
 =?US-ASCII?Q?resource-names.patch?= added to -mm tree
Date: Thu, 26 Mar 2020 12:28:06 -0700
Message-ID: <20200326192806.jJRzNUYSH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbgCZT2J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 15:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, bhsharma@redhat.com, catalin.marinas@arm.com, david@redhat.com, ebiederm@xmission.com, james.morse@arm.com, mm-commits@vger.kernel.org, will@kernel.org


The patch titled
     Subject: mm/memory_hotplug: allow arch override of non boot memory resource names
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch

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
@@ -102,7 +106,7 @@ static struct resource *register_memory_
 {
 	struct resource *res;
 	unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-	char *resource_name = "System RAM";
+	char *resource_name = MEMORY_HOTPLUG_RES_NAME;
 
 	/*
 	 * Make sure value parsed from 'mem=' only restricts memory adding
_

Patches currently in -mm which might be from james.morse@arm.com are

kexec-prevent-removal-of-memory-in-use-by-a-loaded-kexec-image.patch
mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch
arm64-memory-give-hotplug-memory-a-different-resource-name.patch
