From: akpm@linux-foundation.org
Subject: + mm-memmap_init_zone-performance-improvement.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:32:04 -0700
Message-ID: <20121030223204.A82361E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43615 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934787Ab2J3WcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:32:05 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so92463yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:32:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.yoknis@hp.com, hannes@cmpxchg.org, mgorman@suse.de


The patch titled
     Subject: mm: memmap_init_zone() performance improvement
has been added to the -mm tree.  Its filename is
     mm-memmap_init_zone-performance-improvement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3857,8 +3857,11 @@ void __meminit memmap_init_zone(unsigned
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

mm-memmap_init_zone-performance-improvement.patch

