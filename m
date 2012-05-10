From: akpm@linux-foundation.org
Subject: [merged] mm-add-missing-kern_cont-to-free_area_init_nodes.patch removed from -mm tree
Date: Thu, 10 May 2012 13:47:41 -0700
Message-ID: <20120510204741.5B645A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51040 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab2EJUrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 May 2012 16:47:42 -0400
Received: by yenl3 with SMTP id l3so227487yen.1
        for <mm-commits@vger.kernel.org>; Thu, 10 May 2012 13:47:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add missing KERN_CONT to free_area_init_nodes
has been removed from the -mm tree.  Its filename was
     mm-add-missing-kern_cont-to-free_area_init_nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: mm: add missing KERN_CONT to free_area_init_nodes

Fix this behaviour:

Zone ranges:
  DMA
[mem 0x00010000-0x00ffffff]
  DMA32
[mem 0x01000000-0xffffffff]
  Normal
empty

Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-add-missing-kern_cont-to-free_area_init_nodes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-missing-kern_cont-to-free_area_init_nodes
+++ a/mm/page_alloc.c
@@ -4819,9 +4819,9 @@ void __init free_area_init_nodes(unsigne
 		printk("  %-8s ", zone_names[i]);
 		if (arch_zone_lowest_possible_pfn[i] ==
 				arch_zone_highest_possible_pfn[i])
-			printk("empty\n");
+			printk(KERN_CONT "empty\n");
 		else
-			printk("[mem %0#10lx-%0#10lx]\n",
+			printk(KERN_CONT "[mem %0#10lx-%0#10lx]\n",
 				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
 				(arch_zone_highest_possible_pfn[i]
 					<< PAGE_SHIFT) - 1);
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
mm-fix-division-by-0-in-percpu_pagelist_fraction.patch
linux-next.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch

