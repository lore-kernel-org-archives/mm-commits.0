From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:25 -0700
Message-ID: <51dc9ab9.V+RlhScGwcZDLRx6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3GIXUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com

Subject: [merged] mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:25 -0700


The patch titled
     Subject: mm/memory_hotplug.c: fix a comment typo in register_page_bootmem_info_node()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memory_hotplug.c: fix a comment typo in register_page_bootmem_info_node()

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node
+++ a/mm/memory_hotplug.c
@@ -208,13 +208,13 @@ void register_page_bootmem_info_node(str
 	pfn = pgdat->node_start_pfn;
 	end_pfn = pgdat_end_pfn(pgdat);
 
-	/* register_section info */
+	/* register section info */
 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		/*
 		 * Some platforms can assign the same pfn to multiple nodes - on
 		 * node0 as well as nodeN.  To avoid registering a pfn against
 		 * multiple nodes we check that this pfn does not already
-		 * reside in some other node.
+		 * reside in some other nodes.
 		 */
 		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
 			register_page_bootmem_info_section(pfn);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

