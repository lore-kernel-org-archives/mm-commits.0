From: akpm@linux-foundation.org
Subject: + mm-add-missing-kern_cont-to-free_area_init_nodes.patch added to -mm tree
Date: Tue, 08 May 2012 14:55:24 -0700
Message-ID: <20120508215525.5B30CA0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62603 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab2EHVz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 17:55:28 -0400
Received: by wibhj13 with SMTP id hj13so67336wib.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 14:55:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com


The patch titled
     Subject: mm: add missing KERN_CONT to free_area_init_nodes
has been added to the -mm tree.  Its filename is
     mm-add-missing-kern_cont-to-free_area_init_nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: add missing KERN_CONT to free_area_init_nodes

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-division-by-0-in-percpu_pagelist_fraction.patch
brlocks-lglocks-cleanups.patch
mm-add-missing-kern_cont-to-free_area_init_nodes.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch

