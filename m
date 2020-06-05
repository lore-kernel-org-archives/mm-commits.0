From: akpm@linux-foundation.org
Subject: [merged]
 memory_hotplug-disable-the-functionality-for-32b.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:18:12 -0700
Message-ID: <20200605201812.dseYV6oqx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUSN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, osalvador@suse.de, richardw.yang@linux.intel.com, robin.murphy@arm.com, vamshi.k.sthambamkadi@gmail.com


The patch titled
     Subject: mm/memory_hotplug: disable the functionality for 32b
has been removed from the -mm tree.  Its filename was
     memory_hotplug-disable-the-functionality-for-32b.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm/memory_hotplug: disable the functionality for 32b

Memory hotlug is broken for 32b systems at least since c6f03e2903c9 ("mm,
memory_hotplug: remove zone restrictions") which has considerably reworked
how can be memory associated with movable/kernel zones.  The same is not
really trivial to achieve in 32b where only lowmem is the kernel zone. 
While we can tweak this immediate problem around there are likely other
land mines hidden at other places.

It is also quite dubious that there is a real usecase for the memory
hotplug on 32b in the first place.  Low memory is just too small to be
hotplugable (for hot add) and generally unusable for hotremove.  Adding
more memory to highmem is also dubious because it would increase the low
mem or vmalloc space pressure for memmaps.

Restrict the functionality to 64b systems.  This will help future
development to focus on usecases that have real life application.  We can
remove this restriction in future in presence of a real life usecase of
course but until then make it explicit that hotplug on 32b is broken and
requires a non trivial amount of work to fix.

Robin said:

: 32-bit Arm doesn't support memory hotplug, and as far as I'm aware there's
: little likelihood of it ever wanting to.  FWIW it looks like SuperH is the
: only pure-32-bit architecture to have hotplug support at all.

Link: http://lkml.kernel.org/r/20200218100532.GA4151@dhcp22.suse.cz
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206401
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~memory_hotplug-disable-the-functionality-for-32b
+++ a/mm/Kconfig
@@ -158,6 +158,7 @@ config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on 64BIT || BROKEN
 	select NUMA_KEEP_MEMINFO if NUMA
 
 config MEMORY_HOTPLUG_SPARSE
_

Patches currently in -mm which might be from mhocko@kernel.org are
