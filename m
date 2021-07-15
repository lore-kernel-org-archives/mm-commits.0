Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706B8C636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567036128D
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhGOWth (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 18:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGOWtg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 18:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DA4611C0;
        Thu, 15 Jul 2021 22:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626389202;
        bh=Lyr7wIMcPmNm+NNJD3vECHsRsogHCUCHeQ8Ifs532KM=;
        h=Date:From:To:Subject:From;
        b=wLDUV5x5WVPIqk9cbRWhlCaeqChPi34aiC5CRLUEwk++frG+ajK8WqQi+fgiRQJz2
         9zdbn0d8o2nkR5MpOj0xCMBbkiMLW69HiyZ5nN9TuI681T7IF9ttqoLmiiRvMuB+DI
         WDDClGehdoQTRHOAXoyOY/hDojStz+m/MnUmwECA=
Date:   Thu, 15 Jul 2021 15:46:41 -0700
From:   akpm@linux-foundation.org
To:     hch@infradead.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  + lib-test_vmallocc-add-a-new-nr_pages-parameter.patch
 added to -mm tree
Message-ID: <20210715224641.2g3br1pxY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: add a new 'nr_pages' parameter
has been added to the -mm tree.  Its filename is
     lib-test_vmallocc-add-a-new-nr_pages-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_vmallocc-add-a-new-nr_pages-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_vmallocc-add-a-new-nr_pages-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-use-batched-page-requests-in-bulk-allocator.patch
mm-vmalloc-remove-gfpflags_allow_blocking-check.patch
lib-test_vmallocc-add-a-new-nr_pages-parameter.patch

