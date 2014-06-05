From: akpm@linux-foundation.org
Subject: [merged]
 mm-debug-make-bad_range-output-more-usable-and-readable.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:50:01 -0700
Message-ID: <5390c9e9.Th0HZ6UFagFpnz8u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, dave.hansen@linux.intel.com

Subject: [merged] mm-debug-make-bad_range-output-more-usable-and-readable.patch removed from -mm tree
To: dave.hansen@linux.intel.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:01 -0700


The patch titled
     Subject: mm: debug: make bad_range() output more usable and readable
has been removed from the -mm tree.  Its filename was
     mm-debug-make-bad_range-output-more-usable-and-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: debug: make bad_range() output more usable and readable

Nobody outputs memory addresses in decimal.  PFNs are essentially
addresses, and they're gibberish in decimal.  Output them in hex.

Also, add the nid and zone name to give a little more context to the
message.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-debug-make-bad_range-output-more-usable-and-readable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-make-bad_range-output-more-usable-and-readable
+++ a/mm/page_alloc.c
@@ -261,8 +261,9 @@ static int page_outside_zone_boundaries(
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
-		pr_err("page %lu outside zone [ %lu - %lu ]\n",
-			pfn, start_pfn, start_pfn + sp);
+		pr_err("page 0x%lx outside node %d zone %s [ 0x%lx - 0x%lx ]\n",
+			pfn, zone_to_nid(zone), zone->name,
+			start_pfn, start_pfn + sp);
 
 	return ret;
 }
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

