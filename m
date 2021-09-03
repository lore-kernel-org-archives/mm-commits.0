Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B9AC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE74E61153
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349566AbhICVAH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350167AbhICVAG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7191661107;
        Fri,  3 Sep 2021 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702745;
        bh=gGINIPHfxAqxD0QH1EfjDZI3hLpese5UVbWhJ4DXZa0=;
        h=Date:From:To:Subject:From;
        b=F3X2dLkCqaEPmh7XMGVqFKaw/W4vJZ1NlqbM0ekhlK9R322bcM1ALK30xxULVp5r7
         fUr48G59LakXMRwULOY9fXCB7GX7iU74K1ZVsihmB+GVtIBii3SXHiHFa8QkqVTF9N
         +soNkOX5R4xSlQQVQ0lR6C2ImbAplB9xtxUiwUdc=
Date:   Fri, 03 Sep 2021 13:59:05 -0700
From:   akpm@linux-foundation.org
To:     hch@infradead.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 lib-test_vmallocc-add-a-new-nr_pages-parameter.patch removed from -mm tree
Message-ID: <20210903205905.kkd-Daewh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: add a new 'nr_pages' parameter
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-add-a-new-nr_pages-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from urezki@gmail.com are


