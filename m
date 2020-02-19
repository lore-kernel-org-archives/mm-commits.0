From: akpm@linux-foundation.org
Subject: +
 mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 15:46:49 -0800
Message-ID: <20200219234649.eE09s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgBSXqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 18:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, william.kucharski@oracle.com, mingo@kernel.org, mhocko@suse.com, jgross@suse.com, david@redhat.com, bsingharora@gmail.com, bhe@redhat.com


The patch titled
     Subject: mm/memory_hotplug.c: only respect mem= parameter during boot stage
has been added to the -mm tree.  Its filename is
     mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hotplug-only-respect-mem%3D-parameter-during-boot-stage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hotplug-only-respect-mem%3D-parameter-during-boot-stage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2539,13 +2539,22 @@
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

Patches currently in -mm which might be from bhe@redhat.com are

mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch
