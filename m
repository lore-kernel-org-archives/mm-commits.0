From: akpm@linux-foundation.org
Subject: + mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:29:36 -0800
Message-ID: <200711292129.lATLTab1008254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbXK2VgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, riel@redhat.com, y-goto@jp.fujitsu.com


The patch titled
     mm/sparse.c: improve the error handling for sparse_add_one_section()
has been added to the -mm tree.  Its filename is
     mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/sparse.c: improve the error handling for sparse_add_one_section()
From: WANG Cong <xiyou.wangcong@gmail.com>

Improve the error handling for mm/sparse.c::sparse_add_one_section().  And I
see no reason to check 'usemap' until holding the 'pgdat_resize_lock'.

Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/sparse.c~mm-sparsec-improve-the-error-handling-for-sparse_add_one_section mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-improve-the-error-handling-for-sparse_add_one_section
+++ a/mm/sparse.c
@@ -383,9 +383,17 @@ int sparse_add_one_section(struct zone *
 	 * no locking for this, because it does its own
 	 * plus, it does a kmalloc
 	 */
-	sparse_index_init(section_nr, pgdat->node_id);
+	ret = sparse_index_init(section_nr, pgdat->node_id);
+	if (ret < 0)
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
 
@@ -395,18 +403,16 @@ int sparse_add_one_section(struct zone *
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

uml-build-fix.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
