From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch added to
 -mm tree
Date: Tue, 13 Feb 2018 15:50:46 -0800
Message-ID: <5a8379d6.a09AF/jD6svsk8CA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966158AbeBMXus (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 18:50:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, akpm@linux-foundation.org, corbet@lwn.net, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: extend kernelcore and movablecore for percent
has been added to the -mm tree.  Its filename is
     mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: extend kernelcore and movablecore for percent

Both kernelcore= and movablecore= can be used to define the amount of
ZONE_NORMAL and ZONE_MOVABLE on a system, respectively.  This requires the
system memory capacity to be known when specifying the command line,
however.

This introduces the ability to define both kernelcore= and movablecore= as
a percentage of total system memory.  This is convenient for systems
software that wants to define the amount of ZONE_MOVABLE, for example, as
a proportion of a system's memory rather than a hardcoded byte value.

To define the percentage, the final character of the parameter should be
a '%'.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1802121622470.179479@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   42 ++++++-------
 mm/page_alloc.c                                 |   43 +++++++++++---
 2 files changed, 56 insertions(+), 29 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~mm-page_alloc-extend-kernelcore-and-movablecore-for-percent Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_alloc-extend-kernelcore-and-movablecore-for-percent
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1825,30 +1825,30 @@
 	keepinitrd	[HW,ARM]
 
 	kernelcore=	[KNL,X86,IA-64,PPC]
-			Format: nn[KMGTPE] | "mirror"
-			This parameter
-			specifies the amount of memory usable by the kernel
-			for non-movable allocations.  The requested amount is
-			spread evenly throughout all nodes in the system. The
-			remaining memory in each node is used for Movable
-			pages. In the event, a node is too small to have both
-			kernelcore and Movable pages, kernelcore pages will
-			take priority and other nodes will have a larger number
-			of Movable pages.  The Movable zone is used for the
-			allocation of pages that may be reclaimed or moved
-			by the page migration subsystem.  This means that
-			HugeTLB pages may not be allocated from this zone.
-			Note that allocations like PTEs-from-HighMem still
-			use the HighMem zone if it exists, and the Normal
-			zone if it does not.
+			Format: nn[KMGTPE] | nn% | "mirror"
+			This parameter specifies the amount of memory usable by
+			the kernel for non-movable allocations.  The requested
+			amount is spread evenly throughout all nodes in the
+			system as ZONE_NORMAL.  The remaining memory is used for
+			movable memory in its own zone, ZONE_MOVABLE.  In the
+			event, a node is too small to have both ZONE_NORMAL and
+			ZONE_MOVABLE, kernelcore memory will take priority and
+			other nodes will have a larger ZONE_MOVABLE.
 
-			Instead of specifying the amount of memory (nn[KMGTPE]),
-			you can specify "mirror" option. In case "mirror"
+			ZONE_MOVABLE is used for the allocation of pages that
+			may be reclaimed or moved by the page migration
+			subsystem.  This means that HugeTLB pages may not be
+			allocated from this zone.  Note that allocations like
+			PTEs-from-HighMem still use the HighMem zone if it
+			exists, and the Normal zone if it does not.
+
+			It is possible to specify the exact amount of memory in
+			the form of "nn[KMGTPE]", a percentage of total system
+			memory in the form of "nn%", or "mirror".  If "mirror"
 			option is specified, mirrored (reliable) memory is used
 			for non-movable allocations and remaining memory is used
-			for Movable pages. nn[KMGTPE] and "mirror" are exclusive,
-			so you can NOT specify nn[KMGTPE] and "mirror" at the same
-			time.
+			for Movable pages.  "nn[KMGTPE]", "nn%", and "mirror"
+			are exclusive, so you cannot specify multiple forms.
 
 	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
diff -puN mm/page_alloc.c~mm-page_alloc-extend-kernelcore-and-movablecore-for-percent mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-extend-kernelcore-and-movablecore-for-percent
+++ a/mm/page_alloc.c
@@ -272,7 +272,9 @@ static unsigned long __meminitdata dma_r
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
+static unsigned long required_kernelcore_percent __initdata;
 static unsigned long __initdata required_movablecore;
+static unsigned long required_movablecore_percent __initdata;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 static bool mirrored_kernelcore;
 
@@ -6566,7 +6568,18 @@ static void __init find_zone_movable_pfn
 	}
 
 	/*
-	 * If movablecore=nn[KMG] was specified, calculate what size of
+	 * If kernelcore=nn% or movablecore=nn% was specified, calculate the
+	 * amount of necessary memory.
+	 */
+	if (required_kernelcore_percent)
+		required_kernelcore = (totalpages * 100 * required_kernelcore_percent) /
+				       10000UL;
+	if (required_movablecore_percent)
+		required_movablecore = (totalpages * 100 * required_movablecore_percent) /
+					10000UL;
+
+	/*
+	 * If movablecore= was specified, calculate what size of
 	 * kernelcore that corresponds so that memory usable for
 	 * any allocation type is evenly spread. If both kernelcore
 	 * and movablecore are specified, then the value of kernelcore
@@ -6806,18 +6819,30 @@ void __init free_area_init_nodes(unsigne
 	zero_resv_unavail();
 }
 
-static int __init cmdline_parse_core(char *p, unsigned long *core)
+static int __init cmdline_parse_core(char *p, unsigned long *core,
+				     unsigned long *percent)
 {
 	unsigned long long coremem;
+	char *endptr;
+
 	if (!p)
 		return -EINVAL;
 
-	coremem = memparse(p, &p);
-	*core = coremem >> PAGE_SHIFT;
+	/* Value may be a percentage of total memory, otherwise bytes */
+	coremem = simple_strtoull(p, &endptr, 0);
+	if (*endptr == '%') {
+		/* Paranoid check for percent values greater than 100 */
+		WARN_ON(coremem > 100);
 
-	/* Paranoid check that UL is enough for the coremem value */
-	WARN_ON((coremem >> PAGE_SHIFT) > ULONG_MAX);
+		*percent = coremem;
+	} else {
+		coremem = memparse(p, &p);
+		/* Paranoid check that UL is enough for the coremem value */
+		WARN_ON((coremem >> PAGE_SHIFT) > ULONG_MAX);
 
+		*core = coremem >> PAGE_SHIFT;
+		*percent = 0UL;
+	}
 	return 0;
 }
 
@@ -6833,7 +6858,8 @@ static int __init cmdline_parse_kernelco
 		return 0;
 	}
 
-	return cmdline_parse_core(p, &required_kernelcore);
+	return cmdline_parse_core(p, &required_kernelcore,
+				  &required_kernelcore_percent);
 }
 
 /*
@@ -6842,7 +6868,8 @@ static int __init cmdline_parse_kernelco
  */
 static int __init cmdline_parse_movablecore(char *p)
 {
-	return cmdline_parse_core(p, &required_movablecore);
+	return cmdline_parse_core(p, &required_movablecore,
+				  &required_movablecore_percent);
 }
 
 early_param("kernelcore", cmdline_parse_kernelcore);
_

Patches currently in -mm which might be from rientjes@google.com are

kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch
mm-page_alloc-extend-kernelcore-and-movablecore-for-percent.patch
mm-page_alloc-move-mirrored_kernelcore-to-__meminitdata.patch

