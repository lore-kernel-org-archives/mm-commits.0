From: akpm@linux-foundation.org
Subject: + mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch added to -mm tree
Date: Mon, 26 Nov 2007 22:13:40 -0800
Message-ID: <200711270613.lAR6Deld030556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXK0GTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 01:19:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, riel@redhat.com, y-goto@jp.fujitsu.com


The patch titled
     mm/sparse.c: Improve the error handling for sparse_add_one_section()
has been added to the -mm tree.  Its filename is
     mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/sparse.c: Improve the error handling for sparse_add_one_section()
From: WANG Cong <xiyou.wangcong@gmail.com>

Improve the error handling for mm/sparse.c::sparse_add_one_section().  And I
see no reason to check 'usemap' until holding the 'pgdat_resize_lock'.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

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
 
@@ -395,10 +403,6 @@ int sparse_add_one_section(struct zone *
 		goto out;
 	}
 
-	if (!usemap) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
@@ -406,7 +410,7 @@ int sparse_add_one_section(struct zone *
 out:
 	pgdat_resize_unlock(pgdat, &flags);
 	if (ret <= 0)
-		__kfree_section_memmap(memmap, nr_pages);
+		kfree(usemap);
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
