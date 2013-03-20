From: akpm@linux-foundation.org
Subject: + mm-speedup-in-__early_pfn_to_nid.patch added to -mm tree
Date: Wed, 20 Mar 2013 15:32:34 -0700
Message-ID: <20130320223234.83DE15A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:44856 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3CTWcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 18:32:35 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so206990ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 15:32:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rja@sgi.com, hpa@zytor.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: mm: speedup in __early_pfn_to_nid()
has been added to the -mm tree.  Its filename is
     mm-speedup-in-__early_pfn_to_nid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zone_end_pfn-is-too-small.patch
mm-speedup-in-__early_pfn_to_nid.patch

