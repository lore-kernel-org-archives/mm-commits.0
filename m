Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30B2C56201
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3EA620885
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kuXrdfOU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgKVGRZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Nov 2020 01:17:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgKVGRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Nov 2020 01:17:24 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8DFB21D81;
        Sun, 22 Nov 2020 06:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025843;
        bh=nNBCUnSKcDrkF+Ddihz6zZ5lsSOminmqsaiRjEho7Es=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kuXrdfOU8OXzCvTn62acRPePkNnw84tGQeloRY+6uoWiBBDCIWjIUNp/YOyyDwU3g
         +WVNMZWQ/NFxMO0qxwbPaym/KkVsp11PlrZa2AKYtM+ElS3MyMzgG6rTgqoXSrn+bp
         44knvaupA1uKWmFlrwuQtI2sGztUvcpgFPMKNKvE=
Date:   Sat, 21 Nov 2020 22:17:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, feng.tang@intel.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  [patch 8/8] mm: fix madvise WILLNEED performance problem
Message-ID: <20201122061722.Tef3ViFuW%akpm@linux-foundation.org>
In-Reply-To: <20201121221631.948ae4655e913a319d61700a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix madvise WILLNEED performance problem

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
