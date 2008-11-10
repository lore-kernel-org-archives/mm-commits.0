From: akpm@linux-foundation.org
Subject: - vmemmap-warn-about-page_structs-with-remote-distance.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:33 -0800
Message-ID: <200811102032.mAAKWXdV024004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965AbYKJUf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     vmemmap: warn about page_structs with remote distance
has been removed from the -mm tree.  Its filename was
     vmemmap-warn-about-page_structs-with-remote-distance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmemmap: warn about page_structs with remote distance
From: David Rientjes <rientjes@google.com>

It's insufficient to simply compare node ids when warning about offnode
page_structs since it's possible to still have local affinity.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse-vmemmap.c~vmemmap-warn-about-page_structs-with-remote-distance mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~vmemmap-warn-about-page_structs-with-remote-distance
+++ a/mm/sparse-vmemmap.c
@@ -64,7 +64,7 @@ void __meminit vmemmap_verify(pte_t *pte
 	unsigned long pfn = pte_pfn(*pte);
 	int actual_node = early_pfn_to_nid(pfn);
 
-	if (actual_node != node)
+	if (node_distance(actual_node, node) > LOCAL_DISTANCE)
 		printk(KERN_WARNING "[%lx-%lx] potential offnode "
 			"page_structs\n", start, end - 1);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

cpusets-update-mems-allowed-in-page-allocator.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

