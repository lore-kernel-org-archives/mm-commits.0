Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636E8C77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjC1XVz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjC1XVf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A872D77
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE610B81F57
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE91C4339B;
        Tue, 28 Mar 2023 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045682;
        bh=xE0lxIBn47SahC9YZx13L/kPL4vq881cIPJrGewP0mQ=;
        h=Date:To:From:Subject:From;
        b=TNwzDKWuWexqi09zGE285jy3RicwE7Ajsu+D7IIUlDndIPgog6SK4Lix9ielyvbKE
         iUHnp7/MF8c3ZazfG8h7r04jep7O+mjK0W7I5l0DJWXcdswQUZONDrm/lRirE2Cjl2
         Dv7j25N4WHBxWB01V0q0INYXfmPyvzQQBdlkd+oQ=
Date:   Tue, 28 Mar 2023 16:21:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch removed from -mm tree
Message-Id: <20230328232122.9DE91C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: use folio_throttle_swaprate() in page_copy_prealloc()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_throttle_swaprate() in page_copy_prealloc()
Date: Thu, 2 Mar 2023 19:58:31 +0800

Directly use folio_throttle_swaprate() instead of
cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230302115835.105364-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc
+++ a/mm/memory.c
@@ -974,7 +974,7 @@ static inline struct folio *page_copy_pr
 		folio_put(new_folio);
 		return NULL;
 	}
-	cgroup_throttle_swaprate(&new_folio->page, GFP_KERNEL);
+	folio_throttle_swaprate(new_folio, GFP_KERNEL);
 
 	return new_folio;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


