From: akpm@linux-foundation.org
Subject: + free-the-reserved-memblock-when-free-cma-pages.patch added to
 -mm tree
Date: Fri, 12 Sep 2014 16:32:45 -0700
Message-ID: <5413829d.uuvQksU9AOwAqXZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaILXcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 19:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, b.zolnierkie@samsung.com, hughd@google.com, m.szyprowski@samsung.com, mhocko@suse.cz, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: free the reserved memblock when free cma pages
has been added to the -mm tree.  Its filename is
     free-the-reserved-memblock-when-free-cma-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/free-the-reserved-memblock-when-free-cma-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/free-the-reserved-memblock-when-free-cma-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: mm/cma.c: free the reserved memblock when free cma pages

Add memblock_free to also free the reserved memblock, so that the cma
pages are not marked as reserved memory in
/sys/kernel/debug/memblock/reserved debug file

Marek said:

: When cma_activate_area() is called noone should use memblock to allocate
: memory, but it is ok to call memblock_free() to update memblock
: statistics, so users won't be confused by cma entries in
: /sys/kernel/debug/memblock/reserved file.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/cma.c~free-the-reserved-memblock-when-free-cma-pages mm/cma.c
--- a/mm/cma.c~free-the-reserved-memblock-when-free-cma-pages
+++ a/mm/cma.c
@@ -115,6 +115,8 @@ static int __init cma_activate_area(stru
 				goto err;
 		}
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
+		memblock_free(__pfn_to_phys(base_pfn),
+				pageblock_nr_pages * PAGE_SIZE);
 	} while (--i);
 
 	mutex_init(&cma->lock);
_

Patches currently in -mm which might be from Yalin.Wang@sonymobile.com are

free-the-reserved-memblock-when-free-cma-pages.patch

