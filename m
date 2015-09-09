From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:43:45 -0700
Message-ID: <55f08bf1.txtfpbBWyfv60hxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbbIITnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: WARN_ON when flags differs from overlap region
has been removed from the -mm tree.  Its filename was
     mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/memblock.c: WARN_ON when flags differs from overlap region

Each memblock_region has flags to indicates the type of this range. For
the overlap case, memblock_add_range() inserts the lower part and leave the
upper part as indicated in the overlapped region.

If the flags of the new range differs from the overlapped region, the
information recorded is not correct.

This patch adds a WARN_ON when the flags of the new range differs from the
overlapped region.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memblock.c~mm-memblock-warn_on-when-flags-differs-from-overlap-region mm/memblock.c
--- a/mm/memblock.c~mm-memblock-warn_on-when-flags-differs-from-overlap-region
+++ a/mm/memblock.c
@@ -569,6 +569,7 @@ repeat:
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 			WARN_ON(nid != memblock_get_region_node(rgn));
 #endif
+			WARN_ON(flags != rgn->flags);
 			nr_new++;
 			if (insert)
 				memblock_insert_region(type, i++, base,
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are


