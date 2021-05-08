Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEB0C43461
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62789613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhEHWuh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675A66100C;
        Sat,  8 May 2021 22:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514175;
        bh=f1fJaffhxsjriEGGNqu92KKsf5CPtfNg751GcngFf38=;
        h=Date:From:To:Subject:From;
        b=xgFBRfx81AFIaEmNhuJnroXqC38CyaxP39hrptFmAC/9R2fdSgy2/yz1jJrkKvzLT
         +0anBCEypt5H0ae4bYN6CWAD+a5XXzTscu8PZBL0Ef58ZvNAegFXsa865LLaSgPZwd
         zKfGgKwLhVYQ7zKa3Jz8Lnn5c8HSXPPia3W3PTVA=
Date:   Sat, 08 May 2021 15:49:35 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] ksm-remove-dedicated-macro-ksm_flag_mask.patch
 removed from -mm tree
Message-ID: <20210508224935.ZHtumX9uE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: remove dedicated macro KSM_FLAG_MASK
has been removed from the -mm tree.  Its filename was
     ksm-remove-dedicated-macro-ksm_flag_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


