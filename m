Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598FCC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbjDFCpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbjDFCom (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1239039
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA116429D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8EFC433EF;
        Thu,  6 Apr 2023 02:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749075;
        bh=40tWfZ4WbiKDJe1xk5h0z8TXVVZ+Lp4xQ57RpWMTFyg=;
        h=Date:To:From:Subject:From;
        b=r/sqOKQChPEQB+4E9esaxhE+TuuV0OLNJZvp3x5HdhYdg0Lm2DhNomV+sOZmx1cBc
         zahpiFseGn5V+23XfPIdgghBCohTv7dvR/H5hZOI2E6pdsDogj1+CeEsvcT7/ZbyRG
         rdq8Gjn4URsPKDxphIRnpL8p0EtueZhLN7l3q5LA=
Date:   Wed, 05 Apr 2023 19:44:34 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, irogers@google.com,
        alexander.shishkin@linux.intel.com, adrian.hunter@intel.com,
        acme@kernel.org, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch removed from -mm tree
Message-Id: <20230406024435.4F8EFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: perf/core: fix MAX_ORDER usage in rb_alloc_aux_page()
has been removed from the -mm tree.  Its filename was
     perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


