From: akpm@linux-foundation.org
Subject: +
 mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch added to
 -mm tree
Date: Mon, 13 Jul 2015 14:38:32 -0700
Message-ID: <55a42fd8.0E0z3GBQR+mNIrqE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbGMVic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: WARN_ON when flags differs from overlap region
has been added to the -mm tree.  Its filename is
     mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/memblock.c: WARN_ON when flags differs from overlap region

Each memblock_region has flags to indicates the Node ID of this range. 
For the overlap case, memblock_add_range() inserts the lower part and
leave the upper part as indicated in the overlapped region.

If the flags of the new range differs from the overlapped region, the
information recorded is not correct.

This patch adds a WARN_ON when the flags of the new range differs from the
overlapped region.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
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

mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
mm-page-remove-unused-variable-of-free_area_init_core.patch
mm-memblock-warn_on-when-flags-differs-from-overlap-region.patch

