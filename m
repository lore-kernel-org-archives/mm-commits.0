Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044D8C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71F3223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgLODdn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgLODGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:20 -0500
Date:   Mon, 14 Dec 2020 19:06:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001565;
        bh=7v+RgTZuyJW/bBR4UK8MH4Xg43pMdhA95ijDeiW7Rgg=;
        h=From:To:Subject:In-Reply-To:From;
        b=XfIYv4P+0nX4LOvyhbhLkqJwG3QRnag8wiBxSkOCwwoRB7vegP03ChK09ZdjaJu1P
         D6sFfdIUnNrduSR81AMLjiFvAvjkQpfN9hZPtHBp2MyefxmxuHa/p2lMGEDTTxgRuj
         L8Sui7+03f9XjGz1Y3F+Zyq8MuiNkIdYlBEX0M60=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 050/200] mm/swapfile.c: remove unnecessary out
 label in __swap_duplicate()
Message-ID: <20201215030604.qIS1-P8T6%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
