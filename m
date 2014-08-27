From: akpm@linux-foundation.org
Subject: + mm-use-memblock_alloc_range.patch added to -mm tree
Date: Wed, 27 Aug 2014 13:54:00 -0700
Message-ID: <53fe4568.etLJjLdGV7JyLnFK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:58445 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935791AbaH0UyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 16:54:02 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so141592ieb.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 13:54:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use memblock_alloc_range()
has been added to the -mm tree.  Its filename is
     mm-use-memblock_alloc_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-memblock_alloc_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-memblock_alloc_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm: use memblock_alloc_range()

Replace memblock_find_in_range() and memblock_reserve() with
the equivalent memblock_alloc_range().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/memblock.c~mm-use-memblock_alloc_range mm/memblock.c
--- a/mm/memblock.c~mm-use-memblock_alloc_range
+++ a/mm/memblock.c
@@ -1154,21 +1154,16 @@ static void * __init memblock_virt_alloc
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, nid);
 
-	if (!align)
-		align = SMP_CACHE_BYTES;
-
 	if (max_addr > memblock.current_limit)
 		max_addr = memblock.current_limit;
 
 again:
-	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
-					    nid);
+	alloc = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid);
 	if (alloc)
 		goto done;
 
 	if (nid != NUMA_NO_NODE) {
-		alloc = memblock_find_in_range_node(size, align, min_addr,
-						    max_addr,  NUMA_NO_NODE);
+		alloc = memblock_alloc_range(size, align, min_addr, max_addr);
 		if (alloc)
 			goto done;
 	}
@@ -1181,7 +1176,6 @@ again:
 	}
 
 done:
-	memblock_reserve(alloc, size);
 	ptr = phys_to_virt(alloc);
 	memset(ptr, 0, size);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

vfs-make-guard_bh_eod-more-generic.patch
vfs-guard-end-of-device-for-mpage-interface.patch
block_dev-implement-readpages-to-optimize-sequential-read.patch
x86-use-memblock_alloc_range-or-memblock_alloc_base.patch
mm-use-memblock_alloc_range.patch
linux-next.patch

