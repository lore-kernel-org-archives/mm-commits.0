From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:06:05 -0700
Message-ID: <20120404210605.DD159A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51146 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2DDVGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:06:08 -0400
Received: by yhgm50 with SMTP id m50so92493yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:06:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shhuiw@gmail.com, dhillf@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/hugetlb.c: use long vars instead of int in region_count()
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/hugetlb.c: use long vars instead of int in region_count()

args f & t and fields from & to of struct file_region are defined as long.
 Use long instead of int to type the temp vars.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count
+++ a/mm/hugetlb.c
@@ -273,8 +273,8 @@ static long region_count(struct list_hea
 
 	/* Locate each segment we overlap with, and count that overlap. */
 	list_for_each_entry(rg, head, link) {
-		int seg_from;
-		int seg_to;
+		long seg_from;
+		long seg_to;
 
 		if (rg->to <= f)
 			continue;
_
Subject: Subject: mm/hugetlb.c: use long vars instead of int in region_count()

Patches currently in -mm which might be from shhuiw@gmail.com are

mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch

