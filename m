Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7956C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB4B61182
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhEEBij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBii (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F61E611AB;
        Wed,  5 May 2021 01:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178663;
        bh=VMjMkVfWVJCQLDO7/OG9/DSZfzg72TsQlcsceet94os=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bgheTTYKa1F1adoisbfVT1p4Ww/h3Nl8zY8ilQ4NoNHs4M9QR68mE9xYHSXP/RAVr
         ndYc9GNKKdAWDWxMqHYkvCEIdDTscONpySJcz8f85LJk57KXT+ygULSOEkKa1N/VfN
         elVYj8n5c8EThF6B5Mj+EZ5MXs57PFK9W1DkmvLs=
Date:   Tue, 04 May 2021 18:37:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 093/143] ksm: remove dedicated macro KSM_FLAG_MASK
Message-ID: <20210505013742.Ld7mRpINv%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: ksm: remove dedicated macro KSM_FLAG_MASK

The macro KSM_FLAG_MASK is used in rmap_walk_ksm() only.  So we can
replace ~KSM_FLAG_MASK with PAGE_MASK to remove this dedicated macro and
make code more consistent because PAGE_MASK is used elsewhere in this
file.

Link: https://lkml.kernel.org/r/20210330140228.45635-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/ksm.c~ksm-remove-dedicated-macro-ksm_flag_mask
+++ a/mm/ksm.c
@@ -215,8 +215,6 @@ struct rmap_item {
 #define SEQNR_MASK	0x0ff	/* low bits of unstable tree seqnr */
 #define UNSTABLE_FLAG	0x100	/* is a node of the unstable tree */
 #define STABLE_FLAG	0x200	/* is listed from the stable tree */
-#define KSM_FLAG_MASK	(SEQNR_MASK|UNSTABLE_FLAG|STABLE_FLAG)
-				/* to mask all the flags */
 
 /* The stable and unstable tree heads */
 static struct rb_root one_stable_tree[1] = { RB_ROOT };
@@ -2631,7 +2629,7 @@ again:
 			vma = vmac->vma;
 
 			/* Ignore the stable/unstable/sqnr flags */
-			addr = rmap_item->address & ~KSM_FLAG_MASK;
+			addr = rmap_item->address & PAGE_MASK;
 
 			if (addr < vma->vm_start || addr >= vma->vm_end)
 				continue;
_
