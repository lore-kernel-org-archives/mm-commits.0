Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8A1CD8CAC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjJJSVj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbjJJSVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:21:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811B19E
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:21:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AEBC433C8;
        Tue, 10 Oct 2023 18:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696962095;
        bh=Z6CYeIhzSUeZUhUxZ4icaUEFUolPKPu7YEkG7Zq7++4=;
        h=Date:To:From:Subject:From;
        b=cuJB6v4qhbNHNE0wYO9sfdOGh3lco2JgqpK338iVyJ+Y+loPS30PyGFKHBa8hExSo
         oXxcJPv2XyUXZHWkOcXIWOvI6MebEK02Dd6x797Ze2AwtTXagJdK8D9JW1g7vyrU7+
         hhPKYEq7zrZhmdlC7IvbpiovcXt3Tl2Bz65gL3oc=
Date:   Tue, 10 Oct 2023 11:21:23 -0700
To:     mm-commits@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, fvdl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-hugetlb_cgroup_min_order.patch added to mm-unstable branch
Message-Id: <20231010182132.32AEBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: remove HUGETLB_CGROUP_MIN_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-hugetlb_cgroup_min_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-hugetlb_cgroup_min_order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm, hugetlb: remove HUGETLB_CGROUP_MIN_ORDER
Date: Wed, 4 Oct 2023 15:32:48 +0000

Originally, hugetlb_cgroup was the only hugetlb user of tail page
structure fields.  So, the code defined and checked against
HUGETLB_CGROUP_MIN_ORDER to make sure pages weren't too small to use.

However, by now, tail page #2 is used to store hugetlb hwpoison and
subpool information as well.  In other words, without that tail page
hugetlb doesn't work.

Acknowledge this fact by getting rid of HUGETLB_CGROUP_MIN_ORDER and
checks against it.  Instead, just check for the minimum viable page order
at hstate creation time.

Link: https://lkml.kernel.org/r/20231004153248.3842997-1-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   11 -----------
 mm/hugetlb.c                   |    2 +-
 mm/hugetlb_cgroup.c            |   20 ++------------------
 3 files changed, 3 insertions(+), 30 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-remove-hugetlb_cgroup_min_order
+++ a/include/linux/hugetlb_cgroup.h
@@ -22,13 +22,6 @@ struct resv_map;
 struct file_region;
 
 #ifdef CONFIG_CGROUP_HUGETLB
-/*
- * Minimum page order trackable by hugetlb cgroup.
- * At least 3 pages are necessary for all the tracking information.
- * The second tail page contains all of the hugetlb-specific fields.
- */
-#define HUGETLB_CGROUP_MIN_ORDER order_base_2(__NR_USED_SUBPAGE)
-
 enum hugetlb_memory_event {
 	HUGETLB_MAX,
 	HUGETLB_NR_MEMORY_EVENTS,
@@ -68,8 +61,6 @@ static inline struct hugetlb_cgroup *
 __hugetlb_cgroup_from_folio(struct folio *folio, bool rsvd)
 {
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
-	if (folio_order(folio) < HUGETLB_CGROUP_MIN_ORDER)
-		return NULL;
 	if (rsvd)
 		return folio->_hugetlb_cgroup_rsvd;
 	else
@@ -91,8 +82,6 @@ static inline void __set_hugetlb_cgroup(
 				       struct hugetlb_cgroup *h_cg, bool rsvd)
 {
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
-	if (folio_order(folio) < HUGETLB_CGROUP_MIN_ORDER)
-		return;
 	if (rsvd)
 		folio->_hugetlb_cgroup_rsvd = h_cg;
 	else
--- a/mm/hugetlb.c~mm-hugetlb-remove-hugetlb_cgroup_min_order
+++ a/mm/hugetlb.c
@@ -4403,7 +4403,7 @@ void __init hugetlb_add_hstate(unsigned
 		return;
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
-	BUG_ON(order == 0);
+	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
 	h = &hstates[hugetlb_max_hstate++];
 	mutex_init(&h->resize_lock);
 	h->order = order;
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-remove-hugetlb_cgroup_min_order
+++ a/mm/hugetlb_cgroup.c
@@ -262,12 +262,6 @@ static int __hugetlb_cgroup_charge_cgrou
 
 	if (hugetlb_cgroup_disabled())
 		goto done;
-	/*
-	 * We don't charge any cgroup if the compound page have less
-	 * than 3 pages.
-	 */
-	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
-		goto done;
 again:
 	rcu_read_lock();
 	h_cg = hugetlb_cgroup_from_task(current);
@@ -397,9 +391,6 @@ static void __hugetlb_cgroup_uncharge_cg
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
-		return;
-
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
 			      nr_pages);
@@ -869,15 +860,8 @@ void __init hugetlb_cgroup_file_init(voi
 {
 	struct hstate *h;
 
-	for_each_hstate(h) {
-		/*
-		 * Add cgroup control files only if the huge page consists
-		 * of more than two normal pages. This is because we use
-		 * page[2].private for storing cgroup details.
-		 */
-		if (huge_page_order(h) >= HUGETLB_CGROUP_MIN_ORDER)
-			__hugetlb_cgroup_file_init(hstate_index(h));
-	}
+	for_each_hstate(h)
+		__hugetlb_cgroup_file_init(hstate_index(h));
 }
 
 /*
_

Patches currently in -mm which might be from fvdl@google.com are

mm-hugetlb-remove-hugetlb_cgroup_min_order.patch

