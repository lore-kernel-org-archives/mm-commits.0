From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-fix-ordering-of-flags-argument-in-comments.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:00:13 -0800
Message-ID: <569e95cd.7eTZ8It/sDoj4yCd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbcASUAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: f.fainelli@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memblock.h: fix ordering of 'flags' argument in comments
has been removed from the -mm tree.  Its filename was
     mm-memblock-fix-ordering-of-flags-argument-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: include/linux/memblock.h: fix ordering of 'flags' argument in comments

for_each_free_mem_range() and for_each_free_mem_range_reverse() both
accept a 'flags' argument, the comment surrounding the macro placed the
'flags' documentation at the very end, while 'flags' is in fact the 3rd
argument to the macro, so let's preserve natural ordering here.

Fixes: fc6daaf931518 ("mm/memblock: add extra "flags" to memblock to allow selection of memory based on attribute")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-fix-ordering-of-flags-argument-in-comments include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-fix-ordering-of-flags-argument-in-comments
+++ a/include/linux/memblock.h
@@ -216,10 +216,10 @@ void __next_mem_pfn_range(int *idx, int
  * for_each_free_mem_range - iterate through free memblock areas
  * @i: u64 used as loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
- * @flags: pick from blocks based on memory attributes
  *
  * Walks over free (memory && !reserved) areas of memblock.  Available as
  * soon as memblock is initialized.
@@ -232,10 +232,10 @@ void __next_mem_pfn_range(int *idx, int
  * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
  * @i: u64 used as loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
- * @flags: pick from blocks based on memory attributes
  *
  * Walks over free (memory && !reserved) areas of memblock in reverse
  * order.  Available as soon as memblock is initialized.
_

Patches currently in -mm which might be from f.fainelli@gmail.com are


