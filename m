Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CBEC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjDRXd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjDRXdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F557EC2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B3596387C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01552C433D2;
        Tue, 18 Apr 2023 23:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860830;
        bh=4Zs7b782poejovYnFLvZje09Ahke48HiiMpoFfCyw88=;
        h=Date:To:From:Subject:From;
        b=vtyiB9M5/SQGrzQsNFBmwhgveHG7aiEkbAFOtBdUw4gcXE19eMuHh72F8sVVEh5Aa
         kaHV1Xm2xA8PvTuiMwXAayYLs8aS4cg4M+ni/agKdhwXBbWziSpC+DCEaBzRLtvYIb
         2H2LptS+jbaH+NsuvRRLr2Ch+JpedcX3ANe6FHhY=
Date:   Tue, 18 Apr 2023 16:33:49 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, thunder.leizhen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags.patch removed from -mm tree
Message-Id: <20230418233350.01552C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: fix a stale comment in kmsan_save_stack_with_flags()
has been removed from the -mm tree.  Its filename was
     kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kmsan: fix a stale comment in kmsan_save_stack_with_flags()
Date: Mon, 27 Mar 2023 11:41:49 +0800

After commit 446ec83805dd ("mm/page_alloc: use might_alloc()") and commit
84172f4bb752 ("mm/page_alloc: combine __alloc_pages and
__alloc_pages_nodemask"), the comment is no longer accurate.  Flag
'__GFP_DIRECT_RECLAIM' is clear enough on its own, so remove the comment
rather than update it.

Link: https://lkml.kernel.org/r/20230327034149.942-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/core.c~kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags
+++ a/mm/kmsan/core.c
@@ -73,7 +73,7 @@ depot_stack_handle_t kmsan_save_stack_wi
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
-	/* Don't sleep (see might_sleep_if() in __alloc_pages_nodemask()). */
+	/* Don't sleep. */
 	flags &= ~__GFP_DIRECT_RECLAIM;
 
 	handle = __stack_depot_save(entries, nr_entries, flags, true);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


