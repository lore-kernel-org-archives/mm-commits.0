From: akpm@linux-foundation.org
Subject: + sched-numa-fix-set-cpupid-on-page-migration-twice.patch added
 to -mm tree
Date: Wed, 22 Jan 2014 12:27:45 -0800
Message-ID: <52e029c1.UFUZmck34omjOqgU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAVU1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, peterz@infradead.org, n-horiguchi@ah.jp.nec.com, mingo@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com

Subject: + sched-numa-fix-set-cpupid-on-page-migration-twice.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,mgorman@suse.de,mingo@redhat.com,n-horiguchi@ah.jp.nec.com,peterz@infradead.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:27:45 -0800


The patch titled
     Subject: sched/numa: fix setting of cpupid on page migration twice
has been added to the -mm tree.  Its filename is
     sched-numa-fix-set-cpupid-on-page-migration-twice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-numa-fix-set-cpupid-on-page-migration-twice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-numa-fix-set-cpupid-on-page-migration-twice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: sched/numa: fix setting of cpupid on page migration twice

commit 7851a45cd3 ("mm: numa: Copy cpupid on page migration") copys over
the cpupid at page migration time.  It is unnecessary to set it again in
migrate_misplaced_transhuge_page().

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~sched-numa-fix-set-cpupid-on-page-migration-twice mm/migrate.c
--- a/mm/migrate.c~sched-numa-fix-set-cpupid-on-page-migration-twice
+++ a/mm/migrate.c
@@ -1753,8 +1753,6 @@ int migrate_misplaced_transhuge_page(str
 	if (!new_page)
 		goto out_fail;
 
-	page_cpupid_xchg_last(new_page, page_cpupid_last(page));
