From: akpm@linux-foundation.org
Subject: [-]
 mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch removed
 from -mm tree
Date: Wed, 18 Sep 2013 13:36:17 -0700
Message-ID: <523a0ec1.xi+rDfqzXXv9ksIJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3IRUgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com

Subject: [-] mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:36:17 -0700


The patch titled
     Subject: mm/vmalloc: don't warn about vmalloc allocation failure twice
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch

This patch was dropped because of confusion

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: don't warn about vmalloc allocation failure twice

Don't warn twice in __vmalloc_area_node and __vmalloc_node_range if
__vmalloc_area_node allocation fails.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice
+++ a/mm/vmalloc.c
@@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		goto fail;
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

