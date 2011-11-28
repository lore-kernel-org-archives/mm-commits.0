From: akpm@linux-foundation.org
Subject: + mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:49:45 -0800
Message-ID: <201111282349.pASNnjsl010915@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41224 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1K1Xtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:49:47 -0500
Received: by ghrr18 with SMTP id r18so247186ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:49:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, mgorman@suse.de


The patch titled
     Subject: mm: compaction: push isolate search base of compact control one pfn ahead
has been added to the -mm tree.  Its filename is
     mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: compaction: push isolate search base of compact control one pfn ahead

After isolated the current pfn will no longer be scanned and isolated if
the next round is necessary, so push the isolate_migratepages search base
of the given compact_control one step ahead.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead mm/compaction.c
--- a/mm/compaction.c~mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead
+++ a/mm/compaction.c
@@ -365,8 +365,10 @@ static isolate_migrate_t isolate_migrate
 		nr_isolated++;
 
 		/* Avoid isolating too much */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
+			++low_pfn;
 			break;
+		}
 	}
 
 	acct_isolated(zone, cc);
_
Subject: Subject: mm: compaction: push isolate search base of compact control one pfn ahead

Patches currently in -mm which might be from dhillf@gmail.com are

linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch

