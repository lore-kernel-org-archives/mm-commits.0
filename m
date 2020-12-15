Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C609C352B3
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269CD22CAE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLOX7y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:17:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074270;
        bh=8zdSO9jbwQ29PJuniiPcpdwgRdEtAkipOSNJLRh8fVM=;
        h=From:To:Subject:From;
        b=rRopbS4Dt0MtWNXWb7DmSOrjL6OaRRoOaWgucJrSaFfZDyIl3EejMIa5FqNJzAMsC
         m5N68B0VtNhBMDz9H1hfC7sHqpScU3TQYZANpp9xX5rkdDm3UkgO9lNTkWrGOZ2Rdb
         S9AoezFga9WGcf07wbva9B9BmVOkEeGqcETRsRaA=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-swapfilec-remove-unnecessary-out-label-in-__swap_duplicate.patch removed
 from -mm tree
Message-ID: <20201215231750.OnCuN_Z-C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: remove unnecessary out label in __swap_duplicate()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-remove-unnecessary-out-label-in-__swap_duplicate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: remove unnecessary out label in __swap_duplicate()

When the code went to the out label, it must have p == NULL.  So what out
label really does is redundant if check and return err.  We should Remove
this unnecessary out label because it does not handle resource free and so
on.

Link: https://lkml.kernel.org/r/20201009130337.29698-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-unnecessary-out-label-in-__swap_duplicate
+++ a/mm/swapfile.c
@@ -3445,11 +3445,11 @@ static int __swap_duplicate(swp_entry_t
 	unsigned long offset;
 	unsigned char count;
 	unsigned char has_cache;
-	int err = -EINVAL;
+	int err;
 
 	p = get_swap_device(entry);
 	if (!p)
-		goto out;
+		return -EINVAL;
 
 	offset = swp_offset(entry);
 	ci = lock_cluster_or_swap_info(p, offset);
@@ -3496,7 +3496,6 @@ static int __swap_duplicate(swp_entry_t
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
-out:
 	if (p)
 		put_swap_device(p);
 	return err;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


