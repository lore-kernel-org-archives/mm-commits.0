Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9060AC4332E
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B8C264FC0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhCMFHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhCMFHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1597164F8D;
        Sat, 13 Mar 2021 05:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612039;
        bh=gBB+xcB3zBsxCfD2SJssRokGTXmaRmnyXZwRBYTl1Ts=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bRd+WcYOJLAQgkh40ti93zsZvX8PoophWh+04F83BhQOuX79HCZl5bjdDDuY/eKMr
         ksRwXTr5vQrZD505QCYcrWXNLrC6hccGGpgOtyjWtm43paSVoMK5Y9iOl3NI7hKR71
         emY9SqMWiRVsPRb1a8pUKtHmjzHV8M9lAic3Dbo0=
Date:   Fri, 12 Mar 2021 21:07:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com, airlied@linux.ie,
        akpm@linux-foundation.org, daniel@ffwll.ch,
        david@gibson.dropbear.id.au, galpress@amazon.com, hch@lst.de,
        jack@suse.cz, jannh@google.com, jgg@ziepe.ca, kirill@shutemov.name,
        ktkhai@virtuozzo.com, linmiaohe@huawei.com,
        linux-graphics-maintainer@vmware.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, sroland@vmware.com,
        torvalds@linux-foundation.org, willy@infradead.org, wzam@amazon.com
Subject:  [patch 06/29] hugetlb: dedup the code to add a new
 file_region
Message-ID: <20210313050718._SlhLGb-9%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: hugetlb: dedup the code to add a new file_region

Patch series "mm/hugetlb: Early cow on fork, and a few cleanups", v5.

As reported by Gal [1], we still miss the code clip to handle early cow
for hugetlb case, which is true.  Again, it still feels odd to fork()
after using a few huge pages, especially if they're privately mapped to
me..  However I do agree with Gal and Jason in that we should still have
that since that'll complete the early cow on fork effort at least, and
it'll still fix issues where buffers are not well under control and not
easy to apply MADV_DONTFORK.

The first two patches (1-2) are some cleanups I noticed when reading into
the hugetlb reserve map code.  I think it's good to have but they're not
necessary for fixing the fork issue.

The last two patches (3-4) are the real fix.

I tested this with a fork() after some vfio-pci assignment, so I'm pretty
sure the page copy path could trigger well (page will be accounted right
after the fork()), but I didn't do data check since the card I assigned is
some random nic.

  https://github.com/xzpeter/linux/tree/fork-cow-pin-huge

[1] https://lore.kernel.org/lkml/27564187-4a08-f187-5a84-3df50009f6ca@amazon.com/

Introduce hugetlb_resv_map_add() helper to add a new file_region rather
than duplication the similar code twice in add_reservation_in_range().

Link: https://lkml.kernel.org/r/20210217233547.93892-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210217233547.93892-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Gal Pressman <galpress@amazon.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Wei Zhang <wzam@amazon.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   51 +++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

--- a/mm/hugetlb.c~hugetlb-dedup-the-code-to-add-a-new-file_region
+++ a/mm/hugetlb.c
@@ -331,6 +331,24 @@ static void coalesce_file_region(struct
 	}
 }
 
+static inline long
+hugetlb_resv_map_add(struct resv_map *map, struct file_region *rg, long from,
+		     long to, struct hstate *h, struct hugetlb_cgroup *cg,
+		     long *regions_needed)
+{
+	struct file_region *nrg;
+
+	if (!regions_needed) {
+		nrg = get_file_region_entry_from_cache(map, from, to);
+		record_hugetlb_cgroup_uncharge_info(cg, h, map, nrg);
+		list_add(&nrg->link, rg->link.prev);
+		coalesce_file_region(map, nrg);
+	} else
+		*regions_needed += 1;
+
+	return to - from;
+}
+
 /*
  * Must be called with resv->lock held.
  *
@@ -346,7 +364,7 @@ static long add_reservation_in_range(str
 	long add = 0;
 	struct list_head *head = &resv->regions;
 	long last_accounted_offset = f;
-	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
+	struct file_region *rg = NULL, *trg = NULL;
 
 	if (regions_needed)
 		*regions_needed = 0;
@@ -375,18 +393,11 @@ static long add_reservation_in_range(str
 		/* Add an entry for last_accounted_offset -> rg->from, and
 		 * update last_accounted_offset.
 		 */
-		if (rg->from > last_accounted_offset) {
-			add += rg->from - last_accounted_offset;
-			if (!regions_needed) {
-				nrg = get_file_region_entry_from_cache(
-					resv, last_accounted_offset, rg->from);
-				record_hugetlb_cgroup_uncharge_info(h_cg, h,
-								    resv, nrg);
-				list_add(&nrg->link, rg->link.prev);
-				coalesce_file_region(resv, nrg);
-			} else
-				*regions_needed += 1;
-		}
+		if (rg->from > last_accounted_offset)
+			add += hugetlb_resv_map_add(resv, rg,
+						    last_accounted_offset,
+						    rg->from, h, h_cg,
+						    regions_needed);
 
 		last_accounted_offset = rg->to;
 	}
@@ -394,17 +405,9 @@ static long add_reservation_in_range(str
 	/* Handle the case where our range extends beyond
 	 * last_accounted_offset.
 	 */
-	if (last_accounted_offset < t) {
-		add += t - last_accounted_offset;
-		if (!regions_needed) {
-			nrg = get_file_region_entry_from_cache(
-				resv, last_accounted_offset, t);
-			record_hugetlb_cgroup_uncharge_info(h_cg, h, resv, nrg);
-			list_add(&nrg->link, rg->link.prev);
-			coalesce_file_region(resv, nrg);
-		} else
-			*regions_needed += 1;
-	}
+	if (last_accounted_offset < t)
+		add += hugetlb_resv_map_add(resv, rg, last_accounted_offset,
+					    t, h, h_cg, regions_needed);
 
 	VM_BUG_ON(add < 0);
 	return add;
_
