From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 025/131] mm: memmap_init: iterate over memblock
 regions rather that check each PFN
Date: Wed, 03 Jun 2020 15:57:55 -0700
Message-ID: <20200603225755.-QfCeGKZA%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW55 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:57:57 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcain@codeaurora.org, bhe@redhat.com, cai@lca.pw, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.so

From: Baoquan He <bhe@redhat.com>
Subject: mm: memmap_init: iterate over memblock regions rather that check each PFN

When called during boot the memmap_init_zone() function checks if each PFN
is valid and actually belongs to the node being initialized using
early_pfn_valid() and early_pfn_in_nid().

Each such check may cost up to O(log(n)) where n is the number of memory
banks, so for large amount of memory overall time spent in early_pfn*()
becomes substantial.

Since the information is anyway present in memblock, we can iterate over
memblock memory regions in memmap_init() and only call memmap_init_zone()
for PFN ranges that are know to be valid and in the appropriate node.

[cai@lca.pw: fix a compilation warning from Clang]
  Link: http://lkml.kernel.org/r/CF6E407F-17DC-427C-8203-21979FB882EF@lca.pw
[bhe@redhat.com: fix the incorrect hole in fast_isolate_freepages()]
  Link: http://lkml.kernel.org/r/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
  Link: http://lkml.kernel.org/r/20200521014407.29690-1-bhe@redhat.com
Link: http://lkml.kernel.org/r/20200412194859.12663-16-rppt@kernel.org
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Hoan Tran <hoan@os.amperecomputing.com>	[arm64]
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 mm/page_alloc.c |   43 ++++++++++++++++---------------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

--- a/mm/compaction.c~mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn
+++ a/mm/compaction.c
@@ -1409,7 +1409,9 @@ fast_isolate_freepages(struct compact_co
 				cc->free_pfn = highest;
 			} else {
 				if (cc->direct_compaction && pfn_valid(min_pfn)) {
-					page = pfn_to_page(min_pfn);
+					page = pageblock_pfn_to_page(min_pfn,
+						pageblock_end_pfn(min_pfn),
+						cc->zone);
 					cc->free_pfn = min_pfn;
 				}
 			}
--- a/mm/page_alloc.c~mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn
+++ a/mm/page_alloc.c
@@ -5951,23 +5951,6 @@ overlap_memmap_init(unsigned long zone,
 	return false;
 }
 
-#ifdef CONFIG_SPARSEMEM
-/* Skip PFNs that belong to non-present sections */
-static inline __meminit unsigned long next_pfn(unsigned long pfn)
-{
-	const unsigned long section_nr = pfn_to_section_nr(++pfn);
-
-	if (present_section_nr(section_nr))
-		return pfn;
-	return section_nr_to_pfn(next_present_section_nr(section_nr));
-}
-#else
-static inline __meminit unsigned long next_pfn(unsigned long pfn)
-{
-	return pfn++;
-}
-#endif
-
 /*
  * Initially all pages are reserved - free ones are freed
  * up by memblock_free_all() once the early boot process is
@@ -6007,14 +5990,6 @@ void __meminit memmap_init_zone(unsigned
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
-			if (!early_pfn_valid(pfn)) {
-				pfn = next_pfn(pfn);
-				continue;
-			}
-			if (!early_pfn_in_nid(pfn, nid)) {
-				pfn++;
-				continue;
-			}
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
 			if (defer_init(nid, pfn, end_pfn))
@@ -6130,9 +6105,23 @@ static void __meminit zone_init_free_lis
 }
 
 void __meminit __weak memmap_init(unsigned long size, int nid,
-				  unsigned long zone, unsigned long start_pfn)
+				  unsigned long zone,
+				  unsigned long range_start_pfn)
 {
-	memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY, NULL);
+	unsigned long start_pfn, end_pfn;
+	unsigned long range_end_pfn = range_start_pfn + size;
+	int i;
+
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
+		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
+		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+
+		if (end_pfn > start_pfn) {
+			size = end_pfn - start_pfn;
+			memmap_init_zone(size, nid, zone, start_pfn,
+					 MEMMAP_EARLY, NULL);
+		}
+	}
 }
 
 static int zone_batchsize(struct zone *zone)
_
