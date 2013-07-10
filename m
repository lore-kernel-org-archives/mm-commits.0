From: akpm@linux-foundation.org
Subject: [-] mm-memmap_init_zone-performance-improvement.patch removed
 from -mm tree
Date: Wed, 10 Jul 2013 13:25:01 -0700
Message-ID: <51ddc31d.MX12dHZGxIQKD5ea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GJUZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 16:25:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org, mike.yoknis@hp.com

Subject: [-] mm-memmap_init_zone-performance-improvement.patch removed from -mm tree
To: mike.yoknis@hp.com,hannes@cmpxchg.org,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 13:25:01 -0700


The patch titled
     Subject: mm: memmap_init_zone() performance improvement
has been removed from the -mm tree.  Its filename was
     mm-memmap_init_zone-performance-improvement.patch

This patch was dropped because it has gone stale

------------------------------------------------------
From: Mike Yoknis <mike.yoknis@hp.com>
Subject: mm: memmap_init_zone() performance improvement

We have what we call an "architectural simulator".  It is a computer
program that pretends that it is a computer system.  We use it to test the
firmware before real hardware is available.  We have booted Linux on our
simulator.  As you would expect it takes longer to boot on the simulator
than it does on real hardware.

With my patch - boot time 41 minutes
Without patch - boot time 94 minutes

These numbers do not scale linearly to real hardware.  But indicate to me
a place where Linux can be improved.


memmap_init_zone() loops through every Page Frame Number (pfn), including
pfn values that are within the gaps between existing memory sections.  The
unneeded looping will become a boot performance issue when machines
configure larger memory ranges that will contain larger and more numerous
gaps.

The code will skip across invalid pfn values to reduce the number of loops
executed.

Signed-off-by: Mike Yoknis <mike.yoknis@hp.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-memmap_init_zone-performance-improvement mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memmap_init_zone-performance-improvement
+++ a/mm/page_alloc.c
@@ -3933,8 +3933,11 @@ void __meminit memmap_init_zone(unsigned
 		 * exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
-			if (!early_pfn_valid(pfn))
+			if (!early_pfn_valid(pfn)) {
+				pfn = ALIGN(pfn + MAX_ORDER_NR_PAGES,
+						MAX_ORDER_NR_PAGES) - 1;
 				continue;
+			}
 			if (!early_pfn_in_nid(pfn, nid))
 				continue;
 		}
_

Patches currently in -mm which might be from mike.yoknis@hp.com are


