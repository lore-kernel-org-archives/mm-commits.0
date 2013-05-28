From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplugc-fix-printk-format-warnings.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:37:15 -0700
Message-ID: <51a5076b.PKpbxanGPDlcH/yx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3E1ThQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, rdunlap@infradead.org

Subject: [merged] mm-memory_hotplugc-fix-printk-format-warnings.patch removed from -mm tree
To: rdunlap@infradead.org,geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:15 -0700


The patch titled
     Subject: mm/memory_hotplug.c: fix printk format warnings
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-fix-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memory_hotplug.c: fix printk format warnings

Fix printk format warnings in mm/memory_hotplug.c by using "%pa":

mm/memory_hotplug.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'resource_size_t' [-Wformat]
mm/memory_hotplug.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'resource_size_t' [-Wformat]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-fix-printk-format-warnings mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-fix-printk-format-warnings
+++ a/mm/memory_hotplug.c
@@ -720,9 +720,12 @@ int __remove_pages(struct zone *zone, un
 	start = phys_start_pfn << PAGE_SHIFT;
 	size = nr_pages * PAGE_SIZE;
 	ret = release_mem_region_adjustable(&iomem_resource, start, size);
-	if (ret)
-		pr_warn("Unable to release resource <%016llx-%016llx> (%d)\n",
-				start, start + size - 1, ret);
+	if (ret) {
+		resource_size_t endres = start + size - 1;
+
+		pr_warn("Unable to release resource <%pa-%pa> (%d)\n",
+				&start, &endres, ret);
+	}
 
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch

