Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2CDC3526B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C6522D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgLPAAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbgLOX0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:42 -0500
Date:   Tue, 15 Dec 2020 15:17:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074268;
        bh=Ei9tu1dpL0YeI0t0bhYZB4q6gOkRwDwEVYRWTTDh8pg=;
        h=From:To:Subject:From;
        b=wN+y82Kuuw6S42XBkKSp+vTxsEW+jL5MqKXYgJPNe5o2dxZ7RK+Q1zz6NB0HThlwQ
         VQDy9vXa7QIWsa1J3dSbdfjMVm2C3SUCD8R85OFnuDv39drelNyq+YYAVgxGyb6YwD
         C2ug5OLBA7fdKogwlunLiqHd3Eh8EqjFnvfmF/+g=
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-swap=5Fstate-skip-meaningless-swap-cache-readahead-when-r?=
 =?US-ASCII?Q?a=5Finfowin-=3D=3D-0.patch?= removed from -mm tree
Message-ID: <20201215231748.Y1Z855zVw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_state: skip meaningless swap cache readahead when ra_info.win == 0
has been removed from the -mm tree.  Its filename was
     mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap_state: skip meaningless swap cache readahead when ra_info.win == 0

swap_ra_info() may leave ra_info untouched in non_swap_entry() case as
page table lock is not held.  In this case, we have ra_info.nr_pte == 0
and it is meaningless to continue with swap cache readahead.  Skip such
ops by init ra_info.win = 1.

[akpm@linux-foundation.org: clean up struct init]
Link: https://lkml.kernel.org/r/20201009133059.58407-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0
+++ a/mm/swap_state.c
@@ -839,7 +839,9 @@ static struct page *swap_vma_readahead(s
 	swp_entry_t entry;
 	unsigned int i;
 	bool page_allocated;
-	struct vma_swap_readahead ra_info = {0,};
+	struct vma_swap_readahead ra_info = {
+		.win = 1,
+	};
 
 	swap_ra_info(vmf, &ra_info);
 	if (ra_info.win == 1)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


