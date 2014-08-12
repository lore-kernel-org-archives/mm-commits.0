From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 13:21:49 -0700
Message-ID: <53ea775d.GynO79zl1XAupTiZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:45114 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLUVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:21:50 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2687084pdj.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:21:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, mingo@elte.hu, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2
has been removed from the -mm tree.  Its filename was
     x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch

This patch was dropped because it was folded into x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2

Restore Initmem text when reporting the memory range in dmesg [David]

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2
+++ a/mm/page_alloc.c
@@ -4969,7 +4969,7 @@ void __paginginit free_area_init_node(in
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-	printk(KERN_INFO "Node %d memory range %#010Lx-%#010Lx\n", nid,
+	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n", nid,
 			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch

