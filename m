From: akpm@linux-foundation.org
Subject: - memory-unplug-v7-ia64-interface.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:34 -0700
Message-ID: <200710162035.l9GKZY9K015071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934012AbXJPVbg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory unplug: ia64 interface
has been removed from the -mm tree.  Its filename was
     memory-unplug-v7-ia64-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory unplug: ia64 interface
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

IA64 memory unplug interface.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/ia64/mm/init.c~memory-unplug-v7-ia64-interface arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~memory-unplug-v7-ia64-interface
+++ a/arch/ia64/mm/init.c
@@ -721,7 +721,17 @@ int arch_add_memory(int nid, u64 start, 
 
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

origin.patch
git-sh.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
