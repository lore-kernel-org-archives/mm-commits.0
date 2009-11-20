From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-fix-section-mismatch.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:11 -0800
Message-ID: <200911201930.nAKJUBlc010014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbZKTTbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm/memory_hotplug: fix section mismatch
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memory_hotplug: fix section mismatch
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

With CONFIG_MEMORY_HOTPLUG I got following warning:

WARNING: vmlinux.o(.text+0x1276b0): Section mismatch in reference from
the function hotadd_new_pgdat() to the function
.meminit.text:free_area_init_node()
The function hotadd_new_pgdat() references
the function __meminit free_area_init_node().
This is often because hotadd_new_pgdat lacks a __meminit
annotation or the annotation of free_area_init_node is wrong.

Use __ref to fix this.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-fix-section-mismatch mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-section-mismatch
+++ a/mm/memory_hotplug.c
@@ -447,7 +447,8 @@ int online_pages(unsigned long pfn, unsi
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
-static pg_data_t *hotadd_new_pgdat(int nid, u64 start)
+/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
 	struct pglist_data *pgdat;
 	unsigned long zones_size[MAX_NR_ZONES] = {0};
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

linux-next.patch
checkpatch-trivial-fix-for-trailing-statements-check.patch

