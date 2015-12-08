From: akpm@linux-foundation.org
Subject: +
 mm-memblock-use-memblock_insert_region-for-the-empty-array.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 12:43:37 -0800
Message-ID: <566740f9.oKz2gwI6Y3ycN5k+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbLHUni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 15:43:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, penberg@kernel.org, tangchen@cn.fujitsu.com, tony.luck@intel.com, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: use memblock_insert_region() for the empty array
has been added to the -mm tree.  Its filename is
     mm-memblock-use-memblock_insert_region-for-the-empty-array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-use-memblock_insert_region-for-the-empty-array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-use-memblock_insert_region-for-the-empty-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memblock.c~mm-memblock-use-memblock_insert_region-for-the-empty-array mm/memblock.c
--- a/mm/memblock.c~mm-memblock-use-memblock_insert_region-for-the-empty-array
+++ a/mm/memblock.c
@@ -493,12 +493,16 @@ static void __init_memblock memblock_ins
 	struct memblock_region *rgn = &type->regions[idx];
 
 	BUG_ON(type->cnt >= type->max);
-	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
+	/* special case for empty array */
+	if (idx)
+	{
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
 
@@ -534,11 +538,7 @@ int __init_memblock memblock_add_range(s
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
mm-memblock-use-memblock_insert_region-for-the-empty-array.patch

