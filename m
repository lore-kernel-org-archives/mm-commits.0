Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EC7C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379711AbiFQCMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379708AbiFQCMa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8209664BF5
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB4C61C61
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A938C34114;
        Fri, 17 Jun 2022 02:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431945;
        bh=tCF6gyhVHNK2/nEZG2ajjmLKuk87EETspXHS6VyuFGw=;
        h=Date:To:From:Subject:From;
        b=Y3UIQSLh/LoDN8WFIqmwdL4aECqbg0kAJFjEgEixUIToctBtZvkeWdY1V9fzRpBgL
         0UUMjFqU2vYI626g4Gzbt35mBja9KMtW96/qyD/aCmJoV0ubeZExP/ClprEKPlANh4
         VPlRaFcgnnYRKbKy42bH74FeOT9TBIiLGSCpuOSw=
Date:   Thu, 16 Jun 2022 19:12:24 -0700
To:     mm-commits@vger.kernel.org, zhangfei.gao@linaro.org,
        yishaih@nvidia.com, yi.l.liu@intel.com, willy@infradead.org,
        paulmck@kernel.org, minchan@kernel.org, joao.m.martins@oracle.com,
        joaodias@google.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        david@redhat.com, alex.williamson@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-re-allow-pinning-of-zero-pfns.patch removed from -mm tree
Message-Id: <20220617021225.6A938C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: re-allow pinning of zero pfns
has been removed from the -mm tree.  Its filename was
     mm-re-allow-pinning-of-zero-pfns.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Williamson <alex.williamson@redhat.com>
Subject: mm: re-allow pinning of zero pfns
Date: Fri, 10 Jun 2022 16:35:13 -0600

The commit referenced below subtly and inadvertently changed the logic to
disallow pinning of zero pfns.  This breaks device assignment with vfio
and potentially various other users of gup.  Exclude the zero page test
from the negation.

Link: https://lkml.kernel.org/r/165490039431.944052.12458624139225785964.stgit@omen
Fixes: 1c563432588d ("mm: fix is_pinnable_page against a cma page")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reported-by: Yishai Hadas <yishaih@nvidia.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Dias <joaodias@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns
+++ a/include/linux/mm.h
@@ -1600,7 +1600,7 @@ static inline bool is_pinnable_page(stru
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
+	return !is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from alex.williamson@redhat.com are


