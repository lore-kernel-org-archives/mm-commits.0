Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869C7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 22:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiLPWd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 17:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLPWd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 17:33:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE510063
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 14:33:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952A36215E
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 22:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79AAC433F2;
        Fri, 16 Dec 2022 22:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671230005;
        bh=MtOhdOCxAd06N21iS2WdQmCYSR+suXvrKfZeRZaUoDk=;
        h=Date:To:From:Subject:From;
        b=nV+JxBI+YoGKthAfMHQ2r7aMJFchEW1yBmEUCHYIi480D/gjncyq9EiPqY6WyYr5m
         chrmlG6E4HqdlVow3jsmfUiggbJPzkWkj2TaFth8UxqZzu6EaAk+YSwlmilmUvCQFH
         7i4ljZv22L29oByRiG57gRdQn3YOM7eX5M/EJUYY=
Date:   Fri, 16 Dec 2022 14:33:24 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        panqinglin2020@iscas.ac.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-parameter-huge-for-fix_size_alloc_test.patch added to mm-unstable branch
Message-Id: <20221216223324.E79AAC433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: add parameter use_huge for fix_size_alloc_test
has been added to the -mm mm-unstable branch.  Its filename is
     add-parameter-huge-for-fix_size_alloc_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/add-parameter-huge-for-fix_size_alloc_test.patch

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
From: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Subject: lib/test_vmalloc.c: add parameter use_huge for fix_size_alloc_test
Date: Mon, 12 Dec 2022 13:56:57 +0800

Add a parameter `use_huge' for fix_size_alloc_test(), which can be used to
test allocation vie vmalloc_huge for both functionality and performance.

Link: https://lkml.kernel.org/r/20221212055657.698420-1-panqinglin2020@iscas.ac.cn
Signed-off-by: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~add-parameter-huge-for-fix_size_alloc_test
+++ a/lib/test_vmalloc.c
@@ -38,6 +38,9 @@ __param(int, test_loop_count, 1000000,
 __param(int, nr_pages, 0,
 	"Set number of pages for fix_size_alloc_test(default: 1)");
 
+__param(bool, use_huge, false,
+	"Use vmalloc_huge in fix_size_alloc_test");
+
 __param(int, run_test_mask, INT_MAX,
 	"Set tests specified in the mask.\n\n"
 		"\t\tid: 1,    name: fix_size_alloc_test\n"
@@ -264,7 +267,10 @@ static int fix_size_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		ptr = vmalloc((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE);
+		if (use_huge)
+			ptr = vmalloc_huge((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE, GFP_KERNEL);
+		else
+			ptr = vmalloc((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE);
 
 		if (!ptr)
 			return -1;
_

Patches currently in -mm which might be from panqinglin2020@iscas.ac.cn are

add-parameter-huge-for-fix_size_alloc_test.patch

