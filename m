From: akpm@linux-foundation.org
Subject: + cma-make-putback_lru_pages-call-conditional.patch added to -mm tree
Date: Wed, 19 Dec 2012 15:27:51 -0800
Message-ID: <20121219232752.07AE882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:32870 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2LSX1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 18:27:53 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so301046yen.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 15:27:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivas.pandruvada@linux.intel.com, mina86@mina86.com


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
