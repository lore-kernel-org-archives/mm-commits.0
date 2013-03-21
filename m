From: akpm@linux-foundation.org
Subject: + mm-try-harder-to-allocate-vmemmap-blocks.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:58:55 -0700
Message-ID: <20130321195855.EC50231C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:48623 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3CUT65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:58:57 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so297086yen.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:58:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, Bernhard.Schmidt@lrz.de, benh@kernel.crashing.org, davem@davemloft.net, hannes@cmpxchg.org, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: mm: try harder to allocate vmemmap blocks
has been added to the -mm tree.  Its filename is
     mm-try-harder-to-allocate-vmemmap-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: mm: try harder to allocate vmemmap blocks

Hot-adding memory on x86_64 normally requires huge page allocation.  When
this is done to a VM guest, it's usually because the system is already
tight on memory, so the request tends to fail.  Try to avoid this by
adding __GFP_REPEAT to the allocation flags.

Addresses http://bugs.debian.org/699913

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Tested-by: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/sparse-vmemmap.c~mm-try-harder-to-allocate-vmemmap-blocks mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-try-harder-to-allocate-vmemmap-blocks
+++ a/mm/sparse-vmemmap.c
@@ -53,10 +53,12 @@ void * __meminit vmemmap_alloc_block(uns
 		struct page *page;
 
 		if (node_state(node, N_HIGH_MEMORY))
-			page = alloc_pages_node(node,
-				GFP_KERNEL | __GFP_ZERO, get_order(size));
+			page = alloc_pages_node(
+				node, GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
+				get_order(size));
 		else
-			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+			page = alloc_pages(
+				GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
 				get_order(size));
 		if (page)
 			return page_address(page);
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mm-try-harder-to-allocate-vmemmap-blocks.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch
dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present-fix.patch

