Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F567C41535
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39509633F7
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhKOSRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240810AbhKOSNs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCDBF633CC;
        Mon, 15 Nov 2021 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998516;
        bh=PP+A6dJeMtRGkjinhrhHoDub0kq3x8GCKMWqNx9BzNU=;
        h=Date:From:To:Subject:From;
        b=SnHHP5aJ4m9bCU/rJ/ex7HO4WzOL8Rv206GPXP26drx1OYWKy6SoAFiAx2INWD2zO
         0nQDPXlhqjw7842PULBiomq/rsXIEXTl2nfoESPC2jwEX3myQnJDFy4iIuQ12fF+0I
         DW2Ot3H0jHHBAfcZtHj62STIGJRzjdGfzroierbY=
Date:   Mon, 15 Nov 2021 09:48:35 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  +
 mm-damon-core-using-function-abs-instead-of-diff_of.patch added to -mm tree
Message-ID: <20211115174835.U-MARVNZs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use abs() instead of diff_of()
has been added to the -mm tree.  Its filename is
     mm-damon-core-using-function-abs-instead-of-diff_of.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-using-function-abs-instead-of-diff_of.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-using-function-abs-instead-of-diff_of.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/core: use abs() instead of diff_of()

In kernel, we can use abs(a - b) to get the absolute value, So there is no
need to redefine a new one.

Link: https://lkml.kernel.org/r/b24e7b82d9efa90daf150d62dea171e19390ad0b.1636989871.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-using-function-abs-instead-of-diff_of
+++ a/mm/damon/core.c
@@ -757,8 +757,6 @@ static void damon_merge_two_regions(stru
 	damon_destroy_region(r, t);
 }
 
-#define diff_of(a, b) (a > b ? a - b : b - a)
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -772,13 +770,13 @@ static void damon_merge_regions_of(struc
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		if (diff_of(r->nr_accesses, r->last_nr_accesses) > thres)
+		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else
 			r->age++;
 
 		if (prev && prev->ar.end == r->ar.start &&
-		    diff_of(prev->nr_accesses, r->nr_accesses) <= thres &&
+		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
 		    sz_damon_region(prev) + sz_damon_region(r) <= sz_limit)
 			damon_merge_two_regions(t, prev, r);
 		else
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

