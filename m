From: akpm@linux-foundation.org
Subject: + mm-initialize-pages-on-demand-during-boot-fix-3.patch added to
 -mm tree
Date: Wed, 14 Feb 2018 16:19:32 -0800
Message-ID: <5a84d214.6wPN0hMsF2cgrK61%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032127AbeBOATd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-initialize-pages-on-demand-during-boot-fix-3
has been added to the -mm tree.  Its filename is
     mm-initialize-pages-on-demand-during-boot-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-pages-on-demand-during-boot-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-pages-on-demand-during-boot-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm-initialize-pages-on-demand-during-boot-fix-3

use zone_to_nid() in deferred_grow_zone()

Link: http://lkml.kernel.org/r/20180214163343.21234-2-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix-3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix-3
+++ a/mm/page_alloc.c
@@ -1595,7 +1595,7 @@ static noinline bool __init
 deferred_grow_zone(struct zone *zone, unsigned int order)
 {
 	int zid = zone_idx(zone);
-	int nid = zone->node;
+	int nid = zone_to_nid(zone);
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
 	unsigned long nr_pages = 0;
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

