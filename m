Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC93BC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D43610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347362AbhIBV6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243139AbhIBV6W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E8A160E8B;
        Thu,  2 Sep 2021 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619843;
        bh=EpePhqHT0OhbV/Etf8aWW5ueU5URfLP9xW3TuA8uVfk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iVDQEyhDY9hNR1hJKhaQmZBbViRHmnY6LQ4tn2pnOeoCy0oes0MUUiNeDZvOlxGWJ
         OqLkH9Hthj85smoQtO4bsbZrwxuYOQAWRx2pMbwyxVH/zyCd7jWIE3gGb227IMXiV+
         j+pJQk1ql04cgJb9gQ11NiVdq71y0FrDYKNGkNTg=
Date:   Thu, 02 Sep 2021 14:57:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@infradead.org, hdanton@sina.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 139/212] lib/test_vmalloc.c: add a new 'nr_pages'
 parameter
Message-ID: <20210902215723.BQzLTknp6%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: add a new 'nr_pages' parameter

In order to simulate different fixed sizes for vmalloc allocation
introduce a new parameter that sets number of pages to be allocated for
the "fix_size_alloc_test" test.

By default 1 page is used unless a different number is specified over the
new parameter.

Link: https://lkml.kernel.org/r/20210710194151.21370-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-a-new-nr_pages-parameter
+++ a/lib/test_vmalloc.c
@@ -35,6 +35,9 @@ __param(int, test_repeat_count, 1,
 __param(int, test_loop_count, 1000000,
 	"Set test loop counter");
 
+__param(int, nr_pages, 0,
+	"Set number of pages for fix_size_alloc_test(default: 1)");
+
 __param(int, run_test_mask, INT_MAX,
 	"Set tests specified in the mask.\n\n"
 		"\t\tid: 1,    name: fix_size_alloc_test\n"
@@ -262,7 +265,7 @@ static int fix_size_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		ptr = vmalloc(3 * PAGE_SIZE);
+		ptr = vmalloc((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE);
 
 		if (!ptr)
 			return -1;
_
