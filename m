From: akpm@linux-foundation.org
Subject: + fix-sysrq-m-oops.patch added to -mm tree
Date: Thu, 07 Jun 2007 18:28:55 -0700
Message-ID: <200706080128.l581Stws014926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933063AbXFHB3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bob.picco@hp.com, acme@redhat.com, ak@suse.de, cebbert@redhat.com


The patch titled
     fix sysrq-m oops
has been added to the -mm tree.  Its filename is
     fix-sysrq-m-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sysrq-m oops
From: "Bob Picco" <bob.picco@hp.com>

We aren't sampling for holes in memory.  Thus we encounter a section hole
with empty section map pointer for SPARSEMEM and OOPs for show_mem.  This
issue has been seen in 2.6.21, current git and current mm.  The patch below
is for mainline and mm.  It was boot tested for SPARSEMEM, current VMEMMAP
of Andy's in mm ml and DISCONTIGMEM.  A slightly different patch will be
posted to stable for 2.6.21.

Previous to commit f0a5a58aa812b31fd9f197c4ba48245942364eae memory_present
was called for node_start_pfn to node_end_pfn.  This would cover the
hole(s) with reserved pages and valid sections.  Most SPARSEMEM supported
arches do a pfn_valid check in show_mem before computing the page structure
address.

This issue was brought to my attention on IRC by Arnaldo Carvalho de Melo. 
Thanks to Arnaldo for testing.

Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/x86_64/mm/init.c~fix-sysrq-m-oops arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~fix-sysrq-m-oops
+++ a/arch/x86_64/mm/init.c
@@ -79,6 +79,8 @@ void show_mem(void)
 			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
 				touch_nmi_watchdog();
 			}
+			if (!pfn_valid(pgdat->node_start_pfn + i))
+				continue;
 			page = pfn_to_page(pgdat->node_start_pfn + i);
 			total++;
 			if (PageReserved(page))
_

Patches currently in -mm which might be from bob.picco@hp.com are

fix-sysrq-m-oops.patch
move-free-pages-between-lists-on-steal.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
lumpy-move-to-using-pfn_valid_within.patch
