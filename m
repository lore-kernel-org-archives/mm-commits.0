Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51946C678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 01:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCHBFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 20:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCHBFo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 20:05:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9518FA92CE
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 17:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D210615F8
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 01:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AE4C4339E;
        Wed,  8 Mar 2023 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237538;
        bh=k+dulOpe3OkAmB+7JG0sWpYfMnGelM8QWU0TOiJdSqo=;
        h=Date:To:From:Subject:From;
        b=NtRisQMAKeQ7MsFCTr/ll6nM5osf428tPl9cFwcKxYmsbT/uURNIP2+oFtg80AykC
         FMfyK8RgrBOd5WwhhTwE+BJFKIc4s/4TnJFK9cwVPM9qzKRz4hnxsCm0nlgwcp+9XK
         3voA0vHOqiaEoFjzcUGS8T1SYcr+mPsQHYMjcNuE=
Date:   Tue, 07 Mar 2023 17:05:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch removed from -mm tree
Message-Id: <20230308010538.77AE4C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
Date: Sat, 4 Mar 2023 19:39:49 +0000

damon_pa_mark_accessed_or_deactivate() is accessing a folio via
folio_nr_pages() after folio_put() for the folio has invoked.  Fix it.

Link: https://lkml.kernel.org/r/20230304193949.296391-3-sj@kernel.org
Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate
+++ a/mm/damon/paddr.c
@@ -280,8 +280,8 @@ static inline unsigned long damon_pa_mar
 			folio_mark_accessed(folio);
 		else
 			folio_deactivate(folio);
-		folio_put(folio);
 		applied += folio_nr_pages(folio);
+		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


