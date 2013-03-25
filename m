From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-speedup-in-__early_pfn_to_nid.patch removed from -mm tree
Date: Mon, 25 Mar 2013 14:28:06 -0700
Message-ID: <20130325212806.694685A41C6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38039 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3CYV2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:28:07 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so372570qeb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:28:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, hpa@zytor.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: speedup in __early_pfn_to_nid()
has been removed from the -mm tree.  Its filename was
     mm-speedup-in-__early_pfn_to_nid.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Russ Anderson <rja@sgi.com>
Subject: mm: speedup in __early_pfn_to_nid()

When booting on a large memory system, the kernel spends considerable time
in memmap_init_zone() setting up memory zones.  Analysis shows significant
time spent in __early_pfn_to_nid().

memmap_init_zone() checks each PFN to verify the nid is valid. 
__early_pfn_to_nid() sequentially scans the list of pfn ranges to find the
right range and returns the nid.  This does not scale well.  On a 4 TB
(single rack) system there are 308 memory ranges to scan.  The higher the
PFN the more time spent sequentially spinning through memory ranges.

Since memmap_init_zone() increments pfn, it will almost always be looking
for the same range as the previous pfn, so check that range first.  If it
is in the same range, return that nid.  If not, scan the list as before.

A 4 TB (single rack) UV1 system takes 512 seconds to get through the zone
code.  This performance optimization reduces the time by 189 seconds, a
36% improvement.

A 2 TB (single rack) UV2 system goes from 212.7 seconds to 99.8 seconds, a
112.9 second (53%) reduction.

Signed-off-by: Russ Anderson <rja@sgi.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-speedup-in-__early_pfn_to_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-speedup-in-__early_pfn_to_nid
+++ a/mm/page_alloc.c
@@ -4168,10 +4168,19 @@ int __meminit __early_pfn_to_nid(unsigne
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
+	static unsigned long last_start_pfn, last_end_pfn;
+	static int last_nid;
+
+	if (last_start_pfn <= pfn && pfn < last_end_pfn)
+		return last_nid;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		if (start_pfn <= pfn && pfn < end_pfn)
+		if (start_pfn <= pfn && pfn < end_pfn) {
+			last_nid = nid;
+			last_start_pfn = start_pfn;
+			last_end_pfn = end_pfn;
 			return nid;
+		}
 	/* This is a memory hole */
 	return -1;
 }
_

Patches currently in -mm which might be from rja@sgi.com are


