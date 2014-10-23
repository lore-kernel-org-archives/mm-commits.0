From: akpm@linux-foundation.org
Subject: + mm-cma-make-kmemleak-ignore-cma-regions.patch added to -mm tree
Date: Thu, 23 Oct 2014 13:22:43 -0700
Message-ID: <54496393.W95B5KIq1FuV+G1f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaJWUWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: ake kmemleak ignore CMA regions
has been added to the -mm tree.  Its filename is
     mm-cma-make-kmemleak-ignore-cma-regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-make-kmemleak-ignore-cma-regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-make-kmemleak-ignore-cma-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: mm/cma: ake kmemleak ignore CMA regions

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

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions mm/cma.c
--- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions
+++ a/mm/cma.c
@@ -280,6 +280,7 @@ int __init cma_declare_contiguous(phys_a
 			ret = -ENOMEM;
 			goto err;
 		} else {
+			kmemleak_ignore(phys_to_virt(addr));
 			base = addr;
 		}
 	}
_

Patches currently in -mm which might be from treding@nvidia.com are

mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-make-kmemleak-ignore-cma-regions-fix.patch
linux-next.patch

