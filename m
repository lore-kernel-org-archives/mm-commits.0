From: akpm@linux-foundation.org
Subject: [merged] mm-speedup-in-__early_pfn_to_nid.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:25 -0700
Message-ID: <20130430184825.9296A5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64612 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Ss1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:27 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so85031ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, hpa@zytor.com, kosaki.motohiro@gmail.com, linfeng@cn.fujitsu.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: speedup in __early_pfn_to_nid
has been removed from the -mm tree.  Its filename was
     mm-speedup-in-__early_pfn_to_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russ Anderson <rja@sgi.com>
Subject: mm: speedup in __early_pfn_to_nid

When booting on a large memory system, the kernel spends considerable time
in memmap_init_zone() setting up memory zones.  Analysis shows significant
time spent in __early_pfn_to_nid().

The routine memmap_init_zone() checks each PFN to verify the nid is valid.
 __early_pfn_to_nid() sequentially scans the list of pfn ranges to find
the right range and returns the nid.  This does not scale well.  On a 4 TB
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

[akpm@linux-foundation.org: make the statics __meminitdata]
[akpm@linux-foundation.org: fix comment formatting]
[akpm@linux-foundation.org: fix ia64, per yinghai]
[akpm@linux-foundation.org: add missing semicolon, per Tony]
Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Tested-by: "Luck, Tony" <tony.luck@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c |   15 ++++++++++++++-
 mm/page_alloc.c     |   15 ++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff -puN arch/ia64/mm/numa.c~mm-speedup-in-__early_pfn_to_nid arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-speedup-in-__early_pfn_to_nid
+++ a/arch/ia64/mm/numa.c
@@ -61,13 +61,26 @@ paddr_to_nid(unsigned long paddr)
 int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
+	/*
+	 * NOTE: The following SMP-unsafe globals are only used early in boot
+	 * when the kernel is running single-threaded.
+	 */
+	static int __meminitdata last_ssec, last_esec;
+	static int __meminitdata last_nid;
+
+	if (section >= last_ssec && section < last_esec)
+		return last_nid;
 
 	for (i = 0; i < num_node_memblks; i++) {
 		ssec = node_memblk[i].start_paddr >> PA_SECTION_SHIFT;
 		esec = (node_memblk[i].start_paddr + node_memblk[i].size +
 			((1L << PA_SECTION_SHIFT) - 1)) >> PA_SECTION_SHIFT;
-		if (section >= ssec && section < esec)
+		if (section >= ssec && section < esec) {
+			last_ssec = ssec;
+			last_esec = esec;
+			last_nid = node_memblk[i].nid;
 			return node_memblk[i].nid;
+		}
 	}
 
 	return -1;
diff -puN mm/page_alloc.c~mm-speedup-in-__early_pfn_to_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-speedup-in-__early_pfn_to_nid
+++ a/mm/page_alloc.c
@@ -4187,10 +4187,23 @@ int __meminit __early_pfn_to_nid(unsigne
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
+	/*
+	 * NOTE: The following SMP-unsafe globals are only used early in boot
+	 * when the kernel is running single-threaded.
+	 */
+	static unsigned long __meminitdata last_start_pfn, last_end_pfn;
+	static int __meminitdata last_nid;
+
+	if (last_start_pfn <= pfn && pfn < last_end_pfn)
+		return last_nid;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		if (start_pfn <= pfn && pfn < end_pfn)
+		if (start_pfn <= pfn && pfn < end_pfn) {
+			last_start_pfn = start_pfn;
+			last_end_pfn = end_pfn;
+			last_nid = nid;
 			return nid;
+		}
 	/* This is a memory hole */
 	return -1;
 }
_

Patches currently in -mm which might be from rja@sgi.com are

origin.patch

