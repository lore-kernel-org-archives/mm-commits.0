Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E519C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E714F61A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhCXXCi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhCXXC0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AD461A0E;
        Wed, 24 Mar 2021 23:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616626945;
        bh=+WrhcGTvz7WLR5WVOAzM8y95ODqnCWau1w5S8LROxl8=;
        h=Date:From:To:Subject:From;
        b=q38xfkhNb/H4NZu8jGAhk8MngieTIGUVuLW4AZabndgZTN9fcHnrAGWMIe0Esoya+
         gz9TO8Gqu8BySHuP5C8SBhK4Lpdyj2SfexNsQ8iq9zd/I3FkSDNbuhD9g7WGavyQkG
         Ud9YGSaOomdcIXyYhExtnFdmRNvspuEcguuEgV20=
Date:   Wed, 24 Mar 2021 16:02:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, yanfei.xu@windriver.com
Subject:  +
 khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch
 added to -mm tree
Message-ID: <20210324230225.hJgiZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged.c: replace barrier() with READ_ONCE() for a selective variable
has been added to the -mm tree.  Its filename is
     khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/khugepaged.c: replace barrier() with READ_ONCE() for a selective variable

READ_ONCE() is more selective and lightweight.  It is more appropriate
that using a READ_ONCE() for the certain variable to prevent the compiler
from reordering.

Link: https://lkml.kernel.org/r/20210323092730.247583-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/khugepaged.c~khugepaged-raplace-barrier-with-read_once-for-a-selective-variable
+++ a/mm/khugepaged.c
@@ -2202,11 +2202,9 @@ static void khugepaged_do_scan(void)
 {
 	struct page *hpage = NULL;
 	unsigned int progress = 0, pass_through_head = 0;
-	unsigned int pages = khugepaged_pages_to_scan;
+	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
 	bool wait = true;
 
-	barrier(); /* write khugepaged_pages_to_scan to local stack */
-
 	lru_add_drain_all();
 
 	while (progress < pages) {
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch

