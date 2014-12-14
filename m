From: akpm@linux-foundation.org
Subject: [merged] mm-cma-make-kmemleak-ignore-cma-regions.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:10:25 -0800
Message-ID: <548d0db1.ucfIRpD8iTZcgSYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaLNEKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mina86@mina86.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: make kmemleak ignore CMA regions
has been removed from the -mm tree.  Its filename was
     mm-cma-make-kmemleak-ignore-cma-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: mm/cma: make kmemleak ignore CMA regions

kmemleak will add allocations as objects to a pool.  The memory allocated
for each object in this pool is periodically searched for pointers to
other allocated objects.  This only works for memory that is mapped into
the kernel's virtual address space, which happens not to be the case for
most CMA regions.  

Furthermore, CMA regions are typically used to store data transferred to
or from a device and therefore don't contain pointers to other objects.

Without this, the kernel crashes on the first execution of the
scan_gray_list() because it tries to access highmem.  Perhaps a more
appropriate fix would be to reject any object that can't map to a kernel
virtual address?

[akpm@linux-foundation.org: add comment]
[akpm@linux-foundation.org: fix comment, per Catalin]
[sfr@canb.auug.org.au: include linux/io.h for phys_to_virt()]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions mm/cma.c
--- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions
+++ a/mm/cma.c
@@ -33,6 +33,7 @@
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
+#include <linux/io.h>
 
 struct cma {
 	unsigned long	base_pfn;
@@ -324,6 +325,11 @@ int __init cma_declare_contiguous(phys_a
 			}
 		}
 
+		/*
+		 * kmemleak scans/reads tracked objects for pointers to other
+		 * objects but this address isn't mapped and accessible
+		 */
+		kmemleak_ignore(phys_to_virt(addr));
 		base = addr;
 	}
 
_

Patches currently in -mm which might be from treding@nvidia.com are

origin.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patch
linux-next.patch

