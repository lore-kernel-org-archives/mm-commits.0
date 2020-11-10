Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E123EC388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7211320809
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXsRLCVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKJVK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJVK0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 16:10:26 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB7C220781;
        Tue, 10 Nov 2020 21:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605042626;
        bh=0xwSRRnD/7IFMqC2qu2gHVV5iKNPF+/R/TVwN6UAlI0=;
        h=Date:From:To:Subject:From;
        b=AXsRLCVnvM2/QRwvj9L/z0xejy0Tu1f/pO2tIoZf22q78sSoafKasUSqh+mZ2mOS0
         prGxKHQE1nonVieMJhb+DHCQ3gX31WOUeqMBCe7pKFpENeUQxpZFPrGAJmzOekFt/A
         cD8Fz5ALpfSYptEgrfSRQGs9M/vxQO6B600WzMW0=
Date:   Tue, 10 Nov 2020 13:10:25 -0800
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        william.kucharski@oracle.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  + mm-fix-madvise-willneed-performance-problem.patch added
 to -mm tree
Message-ID: <20201110211025.Ds7AusA1Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix madvise WILLNEED performance problem
has been added to the -mm tree.  Its filename is
     mm-fix-madvise-willneed-performance-problem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-madvise-willneed-performance-problem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-madvise-willneed-performance-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: Fix madvise WILLNEED performance problem

The calculation of the end page index was incorrect, leading to a
regression of 70% when running stress-ng.  With this fix, we instead
see a performance improvement of 3%.

Link: https://lkml.kernel.org/r/20201109134851.29692-1-willy@infradead.org
Fixes: e6e88712e43b ("mm: optimise madvise WILLNEED")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Tested-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-fix-madvise-willneed-performance-problem
+++ a/mm/madvise.c
@@ -226,7 +226,7 @@ static void force_shm_swapin_readahead(s
 		struct address_space *mapping)
 {
 	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
-	pgoff_t end_index = end / PAGE_SIZE;
+	pgoff_t end_index = linear_page_index(vma, end + PAGE_SIZE - 1);
 	struct page *page;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch

