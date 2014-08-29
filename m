From: akpm@linux-foundation.org
Subject: + x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 13:18:51 -0700
Message-ID: <5400e02b.vafP6nx+qI4YVOe4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaH2USw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 16:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, athorlton@sgi.com, cpw@sgi.com, dyoung@redhat.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, msalter@redhat.com, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use optimized ioresource lookup in ioremap function
has been added to the -mm tree.  Its filename is
     x86-use-optimized-ioresource-lookup-in-ioremap-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-optimized-ioresource-lookup-in-ioremap-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Travis <travis@sgi.com>
Subject: x86: use optimized ioresource lookup in ioremap function

Use the optimized ioresource lookup, "region_is_ram", for the ioremap
function.  If the region is not found, it falls back to the "page_is_ram"
function.  If it is found and it is RAM, then the usual warning message is
issued, and the ioremap operation is aborted.  Otherwise, the ioremap
operation continues.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Cliff Wickman <cpw@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/ioremap.c~x86-use-optimized-ioresource-lookup-in-ioremap-function arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-use-optimized-ioresource-lookup-in-ioremap-function
+++ a/arch/x86/mm/ioremap.c
@@ -86,6 +86,7 @@ static void __iomem *__ioremap_caller(re
 	pgprot_t prot;
 	int retval;
 	void __iomem *ret_addr;
+	int ram_region;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -108,12 +109,23 @@ static void __iomem *__ioremap_caller(re
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	pfn      = phys_addr >> PAGE_SHIFT;
-	last_pfn = last_addr >> PAGE_SHIFT;
-	if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
-				  __ioremap_check_ram) == 1)
+	/* First check if whole region can be identified as RAM or not */
+	ram_region = region_is_ram(phys_addr, size);
+	if (ram_region > 0) {
+		WARN_ONCE(1, "ioremap on RAM at 0x%lx - 0x%lx\n",
+				(unsigned long int)phys_addr,
+				(unsigned long int)last_addr);
 		return NULL;
+	}
 
+	/* If could not be identified(-1), check page by page */
+	if (ram_region < 0) {
+		pfn      = phys_addr >> PAGE_SHIFT;
+		last_pfn = last_addr >> PAGE_SHIFT;
+		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
+					  __ioremap_check_ram) == 1)
+			return NULL;
+	}
 	/*
 	 * Mappings have to be page-aligned
 	 */
_

Patches currently in -mm which might be from travis@sgi.com are

x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

