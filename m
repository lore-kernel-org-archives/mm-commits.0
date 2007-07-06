From: akpm@linux-foundation.org
Subject: + memory-unplug-v7-ia64-interface.patch added to -mm tree
Date: Fri, 06 Jul 2007 15:31:49 -0700
Message-ID: <200707062231.l66MVnlI024158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758709AbXGFWb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:31:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memory unplug: ia64 interface
has been added to the -mm tree.  Its filename is
     memory-unplug-v7-ia64-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory unplug: ia64 interface
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

IA64 memory unplug interface.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/ia64/mm/init.c~memory-unplug-v7-ia64-interface arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~memory-unplug-v7-ia64-interface
+++ a/arch/ia64/mm/init.c
@@ -724,7 +724,17 @@ int arch_add_memory(int nid, u64 start, 
 
 int remove_memory(u64 start, u64 size)
 {
-	return -EINVAL;
+	unsigned long start_pfn, end_pfn;
+	unsigned long timeout = 120 * HZ;
+	int ret;
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, timeout);
+	if (ret)
+		goto out;
+	/* we can free mem_map at this point */
+out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-v6-zonelist-fix-2.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
