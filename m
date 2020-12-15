Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6460C3527E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B389B22D03
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgLOX7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:17:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074265;
        bh=WDnyacr/+cu3NbPj5mU01JFJM/CBYsM+Cp0SMP39fcE=;
        h=From:To:Subject:From;
        b=0SSaZKAL9Db414R9Vsj6t4CQHzaFprbJoome4UD+54LtWOxPTteFCob3EElyoz+PC
         K++Np568A44mt1+RtQg6LAW9PqAcBB9tpz7UGCJhja2uh0x1ZCsMluw39CW/6TCUCp
         ljo++sbCVjykbGY3tZYPOOFyofDERlBdXKQt6N9Y=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-swapfilec-use-helper-function-swap=5Fcount-in-add=5Fs?=
 =?US-ASCII?Q?wap=5Fcount=5Fcontinuation.patch?= removed from -mm tree
Message-ID: <20201215231745.j2g1wR-5t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use helper function swap_count() in add_swap_count_continuation()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-use-helper-function-swap_count-in-add_swap_count_continuation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: use helper function swap_count() in add_swap_count_continuation()

Commit 570a335b8e22 ("swap_info: swap count continuations") introduced the
func add_swap_count_continuation() but forgot to use the helper function
swap_count() introduced by commit 355cfa73ddff ("mm: modify swap_map and
add SWAP_HAS_CACHE flag").

Link: https://lkml.kernel.org/r/20201009134306.18033-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-use-helper-function-swap_count-in-add_swap_count_continuation
+++ a/mm/swapfile.c
@@ -3613,7 +3613,7 @@ int add_swap_count_continuation(swp_entr
 
 	ci = lock_cluster(si, offset);
 
-	count = si->swap_map[offset] & ~SWAP_HAS_CACHE;
+	count = swap_count(si->swap_map[offset]);
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


