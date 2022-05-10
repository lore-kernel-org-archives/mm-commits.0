Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AADC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiEJEPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiEJEPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214812E099
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AABEC61736
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B61C385C2;
        Tue, 10 May 2022 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155862;
        bh=paVcZ10PiyXgz/aog7IGvs5GOCLGNG/hXoTS/aIAxQA=;
        h=Date:To:From:Subject:From;
        b=wflMLARPJKgUD0FmpvjjtBRpgzWXfyrRCkKUSS0/AG6pXYLlH8pdtYBKtc2gJeBS7
         BnYMkiq5GJUDJfq3Uccbl70WmGVcbHtu474EphWuEQVHyDmmuvMQFZ7MutEIma0LIA
         p1WDjnYKu6FytgvZTYGqZfmJFlfzCAPjgksgl8tE=
Date:   Mon, 09 May 2022 21:11:01 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        mike.kravetz@oracle.com, h.j.bos@vu.nl, c.giuffrida@vu.nl,
        bjohannesmeyer@gmail.com, jakobkoschel@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-use-of-list-iterator-variable-after-loop.patch removed from -mm tree
Message-Id: <20220510041102.06B61C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove use of list iterator variable after loop
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-use-of-list-iterator-variable-after-loop.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Jakob Koschel <jakobkoschel@gmail.com>
Subject: hugetlb: remove use of list iterator variable after loop

In preparation to limit the scope of the list iterator to the list
traversal loop, use a dedicated pointer to iterate through the list [1].

Before hugetlb_resv_map_add() was expecting a file_region struct, but in
case the list iterator in add_reservation_in_range() did not exit early,
the variable passed in, is not actually a valid structure.

In such a case 'rg' is computed on the head element of the list and
represents an out-of-bounds pointer.  This still remains safe *iff* you
only use the link member (as it is done in hugetlb_resv_map_add()).

To avoid the type-confusion altogether and limit the list iterator to the
loop, only a list_head pointer is kept to pass to hugetlb_resv_map_add().

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20220331224323.903842-1-jakobkoschel@gmail.com
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-use-of-list-iterator-variable-after-loop
+++ a/mm/hugetlb.c
@@ -370,7 +370,7 @@ static void coalesce_file_region(struct
 }
 
 static inline long
-hugetlb_resv_map_add(struct resv_map *map, struct file_region *rg, long from,
+hugetlb_resv_map_add(struct resv_map *map, struct list_head *rg, long from,
 		     long to, struct hstate *h, struct hugetlb_cgroup *cg,
 		     long *regions_needed)
 {
@@ -379,7 +379,7 @@ hugetlb_resv_map_add(struct resv_map *ma
 	if (!regions_needed) {
 		nrg = get_file_region_entry_from_cache(map, from, to);
 		record_hugetlb_cgroup_uncharge_info(cg, h, map, nrg);
-		list_add(&nrg->link, rg->link.prev);
+		list_add(&nrg->link, rg);
 		coalesce_file_region(map, nrg);
 	} else
 		*regions_needed += 1;
@@ -402,47 +402,52 @@ static long add_reservation_in_range(str
 	long add = 0;
 	struct list_head *head = &resv->regions;
 	long last_accounted_offset = f;
-	struct file_region *rg = NULL, *trg = NULL;
+	struct file_region *iter, *trg = NULL;
+	struct list_head *rg = NULL;
 
 	if (regions_needed)
 		*regions_needed = 0;
 
 	/* In this loop, we essentially handle an entry for the range
-	 * [last_accounted_offset, rg->from), at every iteration, with some
+	 * [last_accounted_offset, iter->from), at every iteration, with some
 	 * bounds checking.
 	 */
-	list_for_each_entry_safe(rg, trg, head, link) {
+	list_for_each_entry_safe(iter, trg, head, link) {
 		/* Skip irrelevant regions that start before our range. */
-		if (rg->from < f) {
+		if (iter->from < f) {
 			/* If this region ends after the last accounted offset,
 			 * then we need to update last_accounted_offset.
 			 */
-			if (rg->to > last_accounted_offset)
-				last_accounted_offset = rg->to;
+			if (iter->to > last_accounted_offset)
+				last_accounted_offset = iter->to;
 			continue;
 		}
 
 		/* When we find a region that starts beyond our range, we've
 		 * finished.
 		 */
-		if (rg->from >= t)
+		if (iter->from >= t) {
+			rg = iter->link.prev;
 			break;
+		}
 
-		/* Add an entry for last_accounted_offset -> rg->from, and
+		/* Add an entry for last_accounted_offset -> iter->from, and
 		 * update last_accounted_offset.
 		 */
-		if (rg->from > last_accounted_offset)
-			add += hugetlb_resv_map_add(resv, rg,
+		if (iter->from > last_accounted_offset)
+			add += hugetlb_resv_map_add(resv, iter->link.prev,
 						    last_accounted_offset,
-						    rg->from, h, h_cg,
+						    iter->from, h, h_cg,
 						    regions_needed);
 
-		last_accounted_offset = rg->to;
+		last_accounted_offset = iter->to;
 	}
 
 	/* Handle the case where our range extends beyond
 	 * last_accounted_offset.
 	 */
+	if (!rg)
+		rg = head->prev;
 	if (last_accounted_offset < t)
 		add += hugetlb_resv_map_add(resv, rg, last_accounted_offset,
 					    t, h, h_cg, regions_needed);
_

Patches currently in -mm which might be from jakobkoschel@gmail.com are


