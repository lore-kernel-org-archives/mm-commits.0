From: akpm@linux-foundation.org
Subject: - mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs-v3.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:15:10 -0800
Message-ID: <200901062015.n06KFA56012469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbZAFUP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garyhade@us.ibm.com, mingo@elte.hu, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: show node to memory section relationship with symlinks in sysfs v3
has been removed from the -mm tree.  Its filename was
     mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs-v3.patch

This patch was dropped because it was folded into mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: show node to memory section relationship with symlinks in sysfs v3
From: Gary Hade <garyhade@us.ibm.com>

Supercedes "[REPOST #2] mm: show node to memory section relationship
with symlinks in sysfs" patch posted on 03 Nov 2008 to correct a
memory section directory removal issue reported by Badari Pulavarty
and correct 'for' loop in unregister_mem_sect_under_nodes() to visit
the last section pfn.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs-v3 drivers/base/node.c
--- a/drivers/base/node.c~mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs-v3
+++ a/drivers/base/node.c
@@ -302,7 +302,7 @@ int unregister_mem_sect_under_nodes(stru
 	nodes_clear(unlinked_nodes);
 	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
-	for (pfn = sect_start_pfn; pfn < sect_end_pfn; pfn++) {
+	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		unsigned int nid;
 
 		nid = get_nid_for_pfn(pfn);
@@ -338,6 +338,9 @@ static int link_mem_sections(int nid)
 		ret = register_mem_sect_under_node(mem_blk, nid);
 		if (!err)
 			err = ret;
+
+		/* discard ref obtained in find_memory_block() */
+		kobject_put(&mem_blk->sysdev.kobj);
 	}
 	return err;
 }
_

Patches currently in -mm which might be from garyhade@us.ibm.com are

origin.patch
mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs.patch
mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs-v3.patch

