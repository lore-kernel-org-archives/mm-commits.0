From: akpm@linux-foundation.org
Subject: [-] mm-vmalloc-dont-set-area-caller-twice.patch removed from -mm
 tree
Date: Wed, 18 Sep 2013 13:36:15 -0700
Message-ID: <523a0ebf.n38gwz+m43JGu1vc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3IRUgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com

Subject: [-] mm-vmalloc-dont-set-area-caller-twice.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:36:15 -0700


The patch titled
     Subject: mm/vmalloc: don't set area->caller twice
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dont-set-area-caller-twice.patch

This patch was dropped because of confusion

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: don't set area->caller twice

The caller address has already been set in setup_vmalloc_vm(), there's no
need to set it again in __vmalloc_area_node.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-dont-set-area-caller-twice mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-dont-set-area-caller-twice
+++ a/mm/vmalloc.c
@@ -1566,7 +1566,6 @@ static void *__vmalloc_area_node(struct
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
-	area->caller = caller;
 	if (!area->pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

