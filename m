Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C7CC2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F30D5224D4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLODGu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgLODGm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:42 -0500
Date:   Mon, 14 Dec 2020 19:06:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001562;
        bh=dH7BAY221BpnZ7KcjbAFIcErXJgPvKKPnTUPW57j1tE=;
        h=From:To:Subject:In-Reply-To:From;
        b=YkCycoahIii5FJnPpj6oUN/R+lL+5SCFscmZaItJq36Y9ozaxPwb2Sk8WzdhY/+Cn
         VRN95oLz6dzENxTMEXvAQ3ZbeqIBI87Qcvun9HleilGVtr1j0pYpgQRsuSvbojEW0t
         F0Uv5Wy5h1a8HoN67Gci1yKEo6hj2fzFcO+oUW28=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 049/200] mm/swap_state: skip meaningless swap
 cache readahead when ra_info.win == 0
Message-ID: <20201215030601.YXwoWTcgy%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
