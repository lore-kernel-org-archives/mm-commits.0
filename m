From: akpm@linux-foundation.org
Subject: + cma-make-putback_lru_pages-call-conditional.patch added to -mm tree
Date: Wed, 19 Dec 2012 15:28:18 -0800
Message-ID: <20121219232819.6D7F282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51406 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2LSX2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 18:28:20 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so300947ggn.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 15:28:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivas.pandruvada@linux.intel.com, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com


The patch titled
     Subject: CMA: make putback_lru_pages() call conditional
has been added to the -mm tree.  Its filename is
     cma-make-putback_lru_pages-call-conditional.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: CMA: make putback_lru_pages() call conditional

As per documentation and other places calling putback_lru_pages(),
putback_lru_pages() is called on error only.  Make the CMA code behave
consistently.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~cma-make-putback_lru_pages-call-conditional mm/page_alloc.c
--- a/mm/page_alloc.c~cma-make-putback_lru_pages-call-conditional
+++ a/mm/page_alloc.c
@@ -5817,8 +5817,8 @@ static int __alloc_contig_migrate_range(
 				    0, false, MIGRATE_SYNC,
 				    MR_CMA);
 	}
