Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C559C7618D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjCOTi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjCOTiz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56F25C9F0
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2067761E64
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F7AC433EF;
        Wed, 15 Mar 2023 19:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909132;
        bh=dYpInu1h/BDjZJ0Lm7UMmJyMf22lMe/Ud3JSREu+GH4=;
        h=Date:To:From:Subject:From;
        b=BmFzQLxLrbTOhlyRqJMlTWnX8bd9JwC/hqLQkg8FuKJ7K92k+nYvPRBWbTmokDSBf
         9f+4Trz03U55TRe/48G4nO6Q+8Bl7EubbGQH7x0QDQwCWXdyFhvwfqy4/ZDqgpPZeX
         JYG0Z1+8UI/OR3+rab6Qhp4ny+tAxKkLd10hm8qM=
Date:   Wed, 15 Mar 2023 12:38:52 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, irogers@google.com,
        alexander.shishkin@linux.intel.com, adrian.hunter@intel.com,
        acme@kernel.org, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch added to mm-unstable branch
Message-Id: <20230315193852.78F7AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: perf/core: fix MAX_ORDER usage in rb_alloc_aux_page()
has been added to the -mm mm-unstable branch.  Its filename is
     perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: perf/core: fix MAX_ORDER usage in rb_alloc_aux_page()
Date: Wed, 15 Mar 2023 14:31:29 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in rb_alloc_aux_page().

Link: https://lkml.kernel.org/r/20230315113133.11326-7-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/ring_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/ring_buffer.c~perf-core-fix-max_order-usage-in-rb_alloc_aux_page
+++ a/kernel/events/ring_buffer.c
@@ -609,8 +609,8 @@ static struct page *rb_alloc_aux_page(in
 {
 	struct page *page;
 
-	if (order > MAX_ORDER)
-		order = MAX_ORDER;
+	if (order >= MAX_ORDER)
+		order = MAX_ORDER - 1;
 
 	do {
 		page = alloc_pages_node(node, PERF_AUX_GFP, order);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

sparc-mm-fix-max_order-usage-in-tsb_grow.patch
um-fix-max_order-usage-in-linux_main.patch
floppy-fix-max_order-usage.patch
drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch
genwqe-fix-max_order-usage.patch
perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch
mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch
mm-slub-fix-max_order-usage-in-calculate_order.patch
iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch
mm-treewide-redefine-max_order-sanely.patch

