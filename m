From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-memmap=5Finit-iterate-over-memblock-regions-rather-that-?=
 =?US-ASCII?Q?check-each-pfn.patch?= added to -mm tree
Date: Mon, 13 Apr 2020 17:26:38 -0700
Message-ID: <20200414002638.gxgEjQ5PW%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390430AbgDNA0l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:26:41 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: memmap_init: iterate over memblock regions rather that check each PFN
has been added to the -mm tree.  Its filename is
     mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20200412194859.12663-16-rppt@kernel.org
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
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
Cc: Hoan Tran <Hoan@os.amperecomputing.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn
+++ a/mm/page_alloc.c
@@ -5995,14 +5995,6 @@ void __meminit memmap_init_zone(unsigned
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
@@ -6118,9 +6110,23 @@ static void __meminit zone_init_free_lis
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

Patches currently in -mm which might be from bhe@redhat.com are

mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
