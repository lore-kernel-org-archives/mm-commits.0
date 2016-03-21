From: akpm@linux-foundation.org
Subject: [merged] mm-zone_device-depends-on-sparsemem_vmemmap.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:01 -0700
Message-ID: <56f04001.8jTs4+5shi0gSwZo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbcCUT4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ZONE_DEVICE depends on SPARSEMEM_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-zone_device-depends-on-sparsemem_vmemmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: ZONE_DEVICE depends on SPARSEMEM_VMEMMAP

The primary use case for devm_memremap_pages() is to allocate an memmap
array from persistent memory.  That capabilty requires vmem_altmap which
requires SPARSEMEM_VMEMMAP.

Also, without SPARSEMEM_VMEMMAP the addition of ZONE_DEVICE expands
ZONES_WIDTH and triggers the:

"Unfortunate NUMA and NUMA Balancing config, growing page-frame for
last_cpupid."

...warning in mm/memory.c.  SPARSEMEM_VMEMMAP=n && ZONE_DEVICE=y is not
a configuration we should worry about supporting.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~mm-zone_device-depends-on-sparsemem_vmemmap mm/Kconfig
--- a/mm/Kconfig~mm-zone_device-depends-on-sparsemem_vmemmap
+++ a/mm/Kconfig
@@ -653,6 +653,7 @@ config ZONE_DEVICE
 	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
+	depends on SPARSEMEM_VMEMMAP
 	depends on X86_64 #arch_add_memory() comprehends device memory
 
 	help
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


