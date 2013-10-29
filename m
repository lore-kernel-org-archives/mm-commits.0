From: akpm@linux-foundation.org
Subject: + mm-fix-page_group_by_mobility_disabled-breakage.patch added to
 -mm tree
Date: Tue, 29 Oct 2013 14:08:06 -0700
Message-ID: <527023b6.AuEgsSPD/D/r3shb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3J2VIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Oct 2013 17:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com

Subject: + mm-fix-page_group_by_mobility_disabled-breakage.patch added to -mm tree
To: kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 29 Oct 2013 14:08:06 -0700


The patch titled
     Subject: mm: fix page_group_by_mobility_disabled breakage
has been added to the -mm tree.  Its filename is
     mm-fix-page_group_by_mobility_disabled-breakage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-page_group_by_mobility_disabled-breakage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-page_group_by_mobility_disabled-breakage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: fix page_group_by_mobility_disabled breakage

Currently, set_pageblock_migratetype() screws up MIGRATE_CMA and
MIGRATE_ISOLATE if page_group_by_mobility_disabled is true.  It rewrites
the argument to MIGRATE_UNMOVABLE and we lost these attribute.

The problem was introduced by 49255c619f ("page allocator: move check for
disabled anti-fragmentation out of fastpath").  So a 4 year old issue may
mean that nobody uses page_group_by_mobility_disabled.

But anyway, this patch fixes the problem.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-page_group_by_mobility_disabled-breakage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-page_group_by_mobility_disabled-breakage
+++ a/mm/page_alloc.c
@@ -234,8 +234,8 @@ int page_group_by_mobility_disabled __re
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
