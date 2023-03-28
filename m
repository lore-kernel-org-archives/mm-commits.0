Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3154C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjC1XV4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjC1XVf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115B8E0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358A3619E9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9188BC433EF;
        Tue, 28 Mar 2023 23:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045684;
        bh=YGmupFzmg4Sez0+77bR2u+SMnZ7K/Jn+XhFYXF/dbzQ=;
        h=Date:To:From:Subject:From;
        b=Oa7FJRa8P1SHxb/rfSOzUcMX4UdFeeNbltnZgP1sKQkRQIFiy1gjhurvDhLg5RpFU
         CAY5SMPzHD1r/5Q1FsFofmPmLBKhMCzquWzt2Km/pCXwXCCfBlku5OuKiJ1NrXV49K
         OluFerbqOELIMlyfYmnPMKJleeuNN7X2ljN5fbVI=
Date:   Tue, 28 Mar 2023 16:21:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch removed from -mm tree
Message-Id: <20230328232124.9188BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: use folio_throttle_swaprate() in do_anonymous_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_throttle_swaprate() in do_anonymous_page()
Date: Thu, 2 Mar 2023 19:58:33 +0800

Directly use folio_throttle_swaprate() instead of
cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230302115835.105364-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page
+++ a/mm/memory.c
@@ -4077,7 +4077,7 @@ static vm_fault_t do_anonymous_page(stru
 
 	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
-	cgroup_throttle_swaprate(&folio->page, GFP_KERNEL);
+	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


