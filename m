From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 055/166] mm/memory_hotplug.c: only respect mem=
 parameter during boot stage
Date: Mon, 06 Apr 2020 20:06:50 -0700
Message-ID: <20200407030650.ZaaSb2Cv0%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:06:52 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, bsingharora@gmail.com, david@redhat.com, jgross@suse.com, linux-mm@kvack.org, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, william.kucharski@oracle.com

From: Baoquan He <bhe@redhat.com>
Subject: mm/memory_hotplug.c: only respect mem= parameter during boot stage

In commit 357b4da50a62 ("x86: respect memory size limiting via mem= 
parameter") a global varialbe max_mem_size is added to store the value
parsed from 'mem= ', then checked when memory region is added.  This truly
stops those DIMMs from being added into system memory during boot-time.

However, it also limits the later memory hotplug functionality.  Any DIMM
can't be hotplugged any more if its region is beyond the max_mem_size.  We
will get errors like:

[  216.387164] acpi PNP0C80:02: add_memory failed
[  216.389301] acpi PNP0C80:02: acpi_memory_enable_device() error
[  216.392187] acpi PNP0C80:02: Enumeration failure

This will cause issue in a known use case where 'mem=' is added to the
hypervisor.  The memory that lies after 'mem=' boundary will be assigned
to KVM guests.  After commit 357b4da50a62 merged, memory can't be extended
dynamically if system memory on hypervisor is not sufficient.

So fix it by also checking if it's during boot-time restricting to add
memory.  Otherwise, skip the restriction.

And also add this use case to document of 'mem=' kernel parameter.

Link: http://lkml.kernel.org/r/20200204050643.20925-1-bhe@redhat.com
Fixes: 357b4da50a62 ("x86: respect memory size limiting via mem= parameter")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   13 +++++++++++--
 mm/memory_hotplug.c                             |    8 +++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hotplug-only-respect-mem=-parameter-during-boot-stage
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2573,13 +2573,22 @@
 			For details see: Documentation/admin-guide/hw-vuln/mds.rst
 
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
-			Amount of memory to be used when the kernel is not able
-			to see the whole system memory or for test.
+			Amount of memory to be used in cases as follows:
+
+			1 for test;
+			2 when the kernel is not able to see the whole system memory;
+			3 memory that lies after 'mem=' boundary is excluded from
+			 the hypervisor, then assigned to KVM guests.
+
 			[X86] Work as limiting max address. Use together
 			with memmap= to avoid physical address space collisions.
 			Without memmap= PCI devices could be placed at addresses
 			belonging to unused RAM.
 
+			Note that this only takes effects during boot time since
+			in above case 3, memory may need be hot added after boot
+			if system memory of hypervisor is not sufficient.
+
 	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
 
--- a/mm/memory_hotplug.c~mm-hotplug-only-respect-mem=-parameter-during-boot-stage
+++ a/mm/memory_hotplug.c
@@ -105,7 +105,13 @@ static struct resource *register_memory_
 	unsigned long flags =  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 	char *resource_name = "System RAM";
 
-	if (start + size > max_mem_size)
+	/*
+	 * Make sure value parsed from 'mem=' only restricts memory adding
+	 * while booting, so that memory hotplug won't be impacted. Please
+	 * refer to document of 'mem=' in kernel-parameters.txt for more
+	 * details.
+	 */
+	if (start + size > max_mem_size && system_state < SYSTEM_RUNNING)
 		return ERR_PTR(-E2BIG);
 
 	/*
_
