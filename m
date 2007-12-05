From: akpm@linux-foundation.org
Subject: + sparsemem-sparse_add_one_section-may-fail-to-allocate-memory.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:01:24 -0800
Message-ID: <200712052301.lB5N1OoC029509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbXLEXCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:02:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, apw@shadowen.org, clameter@sgi.com, geoffrey.levand@am.sony.com, haveblue@us.ibm.com, miltonm@bga.com, y-goto@jp.fujitsu.com


The patch titled
     sparsemem: sparse_add_one_section() may fail to allocate memory
has been added to the -mm tree.  Its filename is
     sparsemem-sparse_add_one_section-may-fail-to-allocate-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparsemem: sparse_add_one_section() may fail to allocate memory
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

FIXME There are still some possible memory leaks in sparse_add_one_section():
  - usemap is never deallocated
  - __kfree_section_memmap() is a not yet implemented dummy

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/sparse.c~sparsemem-sparse_add_one_section-may-fail-to-allocate-memory mm/sparse.c
--- a/mm/sparse.c~sparsemem-sparse_add_one_section-may-fail-to-allocate-memory
+++ a/mm/sparse.c
@@ -391,6 +391,9 @@ int sparse_add_one_section(struct zone *
 	 */
 	sparse_index_init(section_nr, pgdat->node_id);
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
+	if (!memmap)
+		return -ENOMEM;
+
 	usemap = __kmalloc_section_usemap();
 
 	pgdat_resize_lock(pgdat, &flags);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

sparsemem-sparse_add_one_section-may-fail-to-allocate-memory.patch
git-kbuild.patch
time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
