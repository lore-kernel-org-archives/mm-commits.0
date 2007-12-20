From: akpm@linux-foundation.org
Subject: - mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:13 -0800
Message-ID: <200712202336.lBKNaDiF018789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbXLTXiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, apw@shadowen.org, clameter@sgi.com, geoffrey.levand@am.sony.com, haveblue@us.ibm.com, riel@redhat.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm/sparse.c: improve the error handling for sparse_add_one_section()
has been removed from the -mm tree.  Its filename was
     mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/sparse.c: improve the error handling for sparse_add_one_section()
From: WANG Cong <xiyou.wangcong@gmail.com>

Improve the error handling for mm/sparse.c::sparse_add_one_section().  And I
see no reason to check 'usemap' until holding the 'pgdat_resize_lock'.

[geoffrey.levand@am.sony.com: sparse_index_init() returns -EEXIST]
Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/sparse.c~mm-sparsec-improve-the-error-handling-for-sparse_add_one_section mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-improve-the-error-handling-for-sparse_add_one_section
+++ a/mm/sparse.c
@@ -391,9 +391,17 @@ int sparse_add_one_section(struct zone *
 	 * no locking for this, because it does its own
 	 * plus, it does a kmalloc
 	 */
-	sparse_index_init(section_nr, pgdat->node_id);
+	ret = sparse_index_init(section_nr, pgdat->node_id);
+	if (ret < 0 && ret != -EEXIST)
+		return ret;
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
+	if (!memmap)
+		return -ENOMEM;
 	usemap = __kmalloc_section_usemap();
+	if (!usemap) {
+		__kfree_section_memmap(memmap, nr_pages);
+		return -ENOMEM;
+	}
 
 	pgdat_resize_lock(pgdat, &flags);
 
@@ -403,18 +411,16 @@ int sparse_add_one_section(struct zone *
 		goto out;
 	}
 
-	if (!usemap) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
-	if (ret <= 0)
+	if (ret <= 0) {
+		kfree(usemap);
 		__kfree_section_memmap(memmap, nr_pages);
+	}
 	return ret;
 }
 #endif
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
