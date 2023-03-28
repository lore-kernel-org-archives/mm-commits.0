Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0614C77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjC1XVL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjC1XVI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF33C26BB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CCC3B81F57
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C72C433D2;
        Tue, 28 Mar 2023 23:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045662;
        bh=DQIP9mopB6O0chVWSC8gSVCwVXPZr2akZZccTW+fF2U=;
        h=Date:To:From:Subject:From;
        b=1oWKDMhc32X4GOxyctYM7qD1pVsBz/xTt5oNmDf7y41XOBK9I8TA7cE/AkXbmVRPF
         mUXN66E3mRtVz2pzupHihxTkQusyV6c3AN3IRS1KU0MXzddIUDpKCgEoKHNAdQahrL
         0653Rxz6/MlaZJf91NxisQPKMsq8MjnJUjx+E72A=
Date:   Tue, 28 Mar 2023 16:21:02 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-improve-design-doc.patch removed from -mm tree
Message-Id: <20230328232102.C3C72C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: improve design doc
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-improve-design-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: improve design doc
Date: Tue, 14 Feb 2023 03:54:45 +0000

This patch improves the design doc. Specifically,
  1. add a section for the per-memcg mm_struct list, and
  2. add a section for the PID controller.

Link: https://lkml.kernel.org/r/20230214035445.1250139-2-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/multigen_lru.rst |   44 ++++++++++++++++++++++++----
 mm/vmscan.c                       |    2 -
 2 files changed, 40 insertions(+), 6 deletions(-)

--- a/Documentation/mm/multigen_lru.rst~mm-multi-gen-lru-improve-design-doc
+++ a/Documentation/mm/multigen_lru.rst
@@ -103,7 +103,8 @@ moving across tiers only involves atomic
 ``folio->flags`` and therefore has a negligible cost. A feedback loop
 modeled after the PID controller monitors refaults over all the tiers
 from anon and file types and decides which tiers from which types to
-evict or protect.
+evict or protect. The desired effect is to balance refault percentages
+between anon and file types proportional to the swappiness level.
 
 There are two conceptually independent procedures: the aging and the
 eviction. They form a closed-loop system, i.e., the page reclaim.
@@ -156,6 +157,27 @@ This time-based approach has the followi
    and memory sizes.
 2. It is more reliable because it is directly wired to the OOM killer.
 
+``mm_struct`` list
+------------------
+An ``mm_struct`` list is maintained for each memcg, and an
+``mm_struct`` follows its owner task to the new memcg when this task
+is migrated.
+
+A page table walker iterates ``lruvec_memcg()->mm_list`` and calls
+``walk_page_range()`` with each ``mm_struct`` on this list to scan
+PTEs. When multiple page table walkers iterate the same list, each of
+them gets a unique ``mm_struct``, and therefore they can run in
+parallel.
+
+Page table walkers ignore any misplaced pages, e.g., if an
+``mm_struct`` was migrated, pages left in the previous memcg will be
+ignored when the current memcg is under reclaim. Similarly, page table
+walkers will ignore pages from nodes other than the one under reclaim.
+
+This infrastructure also tracks the usage of ``mm_struct`` between
+context switches so that page table walkers can skip processes that
+have been sleeping since the last iteration.
+
 Rmap/PT walk feedback
 ---------------------
 Searching the rmap for PTEs mapping each page on an LRU list (to test
@@ -170,7 +192,7 @@ promotes hot pages. If the scan was done
 adds the PMD entry pointing to the PTE table to the Bloom filter. This
 forms a feedback loop between the eviction and the aging.
 
-Bloom Filters
+Bloom filters
 -------------
 Bloom filters are a space and memory efficient data structure for set
 membership test, i.e., test if an element is not in the set or may be
@@ -186,6 +208,18 @@ is false positive, the cost is an additi
 which may yield hot pages anyway. Parameters of the filter itself can
 control the false positive rate in the limit.
 
+PID controller
+--------------
+A feedback loop modeled after the Proportional-Integral-Derivative
+(PID) controller monitors refaults over anon and file types and
+decides which type to evict when both types are available from the
+same generation.
+
+The PID controller uses generations rather than the wall clock as the
+time domain because a CPU can scan pages at different rates under
+varying memory pressure. It calculates a moving average for each new
+generation to avoid being permanently locked in a suboptimal state.
+
 Memcg LRU
 ---------
 An memcg LRU is a per-node LRU of memcgs. It is also an LRU of LRUs,
@@ -223,9 +257,9 @@ parts:
 
 * Generations
 * Rmap walks
-* Page table walks
-* Bloom filters
-* PID controller
+* Page table walks via ``mm_struct`` list
+* Bloom filters for rmap/PT walk feedback
+* PID controller for refault feedback
 
 The aging and the eviction form a producer-consumer model;
 specifically, the latter drives the former by the sliding window over
--- a/mm/vmscan.c~mm-multi-gen-lru-improve-design-doc
+++ a/mm/vmscan.c
@@ -3604,7 +3604,7 @@ static bool iterate_mm_list_nowalk(struc
 }
 
 /******************************************************************************
- *                          refault feedback loop
+ *                          PID controller
  ******************************************************************************/
 
 /*
_

Patches currently in -mm which might be from talumbau@google.com are


