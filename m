From: akpm@linux-foundation.org
Subject: [failures]
 mm-memblock-use-memblock_insert_region-for-the-empty-array.patch removed
 from -mm tree
Date: Wed, 09 Dec 2015 14:12:38 -0800
Message-ID: <5668a756.Xv75ZWHROHS9RuHr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbLIWMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 17:12:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, dan.j.williams@intel.com, penberg@kernel.org, tangchen@cn.fujitsu.com, tony.luck@intel.com, tyler.baker@linaro.org, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: use memblock_insert_region() for the empty array
has been removed from the -mm tree.  Its filename was
     mm-memblock-use-memblock_insert_region-for-the-empty-array.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: use memblock_insert_region() for the empty array

We have the special case for an empty array in memblock_add_range().  At
the same time we have almost the same functionality in
memblock_insert_region().  Let's use memblock_insert_region() instead of
direct initialization.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Tyler Baker <tyler.baker@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/memblock.c~mm-memblock-use-memblock_insert_region-for-the-empty-array mm/memblock.c
--- a/mm/memblock.c~mm-memblock-use-memblock_insert_region-for-the-empty-array
+++ a/mm/memblock.c
@@ -493,12 +493,15 @@ static void __init_memblock memblock_ins
 	struct memblock_region *rgn = &type->regions[idx];
 
 	BUG_ON(type->cnt >= type->max);
-	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
+	/* special case for empty array */
+	if (idx) {
+		memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
+		type->cnt++;
+	}
 	rgn->base = base;
 	rgn->size = size;
 	rgn->flags = flags;
 	memblock_set_region_node(rgn, nid);
-	type->cnt++;
 	type->total_size += size;
 }
 
@@ -534,11 +537,7 @@ int __init_memblock memblock_add_range(s
 	/* special case for empty array */
 	if (type->regions[0].size == 0) {
 		WARN_ON(type->cnt != 1 || type->total_size);
-		type->regions[0].base = base;
-		type->regions[0].size = size;
-		type->regions[0].flags = flags;
-		memblock_set_region_node(&type->regions[0], nid);
-		type->total_size = size;
+		memblock_insert_region(type, 0, base, size, nid, flags);
 		return 0;
 	}
 repeat:
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-memblock-remove-rgnbase-and-rgnsize-variables.patch
mm-memblock-introduce-for_each_memblock_type.patch

