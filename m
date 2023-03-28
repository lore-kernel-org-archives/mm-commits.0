Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CD9C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjC1XVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjC1XVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F00A2D60
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB679B81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F09C433EF;
        Tue, 28 Mar 2023 23:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045681;
        bh=9V4qAmtMh3CwU4m9QJCpzGYRS40MZOedJWcLznRzooY=;
        h=Date:To:From:Subject:From;
        b=YfN2srMwvnO3iuRgM0dYoevbXc8Jh/y5VwOp+RwQm3iQ23mUpkGVh3TWdXZ1ozwnF
         Q/qjzSmArOdS5GUesiv2iDq2/PV9Zz2y/Y5264KN8enPyBFadWHuoVqivzVXEZhrA6
         Ts5QtbOwbWNim3Hmtp17kWfpzeffNFqNFlV7wPU8=
Date:   Tue, 28 Mar 2023 16:21:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch removed from -mm tree
Message-Id: <20230328232121.86F09C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: use folio_throttle_swaprate() in do_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_throttle_swaprate() in do_swap_page()
Date: Thu, 2 Mar 2023 19:58:30 +0800

Directly use folio_throttle_swaprate() instead of
cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230302115835.105364-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-use-folio_throttle_swaprate-in-do_swap_page
+++ a/mm/memory.c
@@ -3860,7 +3860,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			lru_add_drain();
 	}
 
-	cgroup_throttle_swaprate(page, GFP_KERNEL);
+	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


