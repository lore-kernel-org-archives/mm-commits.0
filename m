From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:40 -0700
Message-ID: <20120531191340.595B0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53929 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2EaTNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:43 -0400
Received: by ggeh3 with SMTP id h3so135352gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, dhillf@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: use long vars instead of int in region_count()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch

