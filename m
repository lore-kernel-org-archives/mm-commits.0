Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4838BC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AD5264F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhBYTfL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235039AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A05C264FB7;
        Thu, 25 Feb 2021 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280715;
        bh=1kS58LTuFt6jq1rLYjn3FZkj0uIT6SFYi5rKT1ADfL0=;
        h=Date:From:To:Subject:From;
        b=XfrPkuq711ckDtJinxMV3sCkYcbXUfwrwyGJwiln8zF97M6arIEDqHjFyZPCgr1/f
         1AXtBU4Ujl6g//4DZQxOURWtX4PcqhVZvHuqUnj9GMsoKa8z/gePWUfTjafycHS5zN
         HKdJwGdhoLnPCwz0xijLrQubmzrLtzb/rWSjhKHQ=
Date:   Thu, 25 Feb 2021 11:18:35 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
 removed from -mm tree
Message-ID: <20210225191835.TZUUVNKrr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: simplify the zhdr initialization code in init_z3fold_page()
has been removed from the -mm tree.  Its filename was
     z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: z3fold: simplify the zhdr initialization code in init_z3fold_page()

We can simplify the zhdr initialization by memset() the zhdr first instead
of set struct member to zero one by one.  This would also make code more
compact and clear.

Link: https://lkml.kernel.org/r/20210120085851.16159-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/z3fold.c~z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page
+++ a/mm/z3fold.c
@@ -413,16 +413,10 @@ static struct z3fold_header *init_z3fold
 	if (!slots)
 		return NULL;
 
+	memset(zhdr, 0, sizeof(*zhdr));
 	spin_lock_init(&zhdr->page_lock);
 	kref_init(&zhdr->refcount);
-	zhdr->first_chunks = 0;
-	zhdr->middle_chunks = 0;
-	zhdr->last_chunks = 0;
-	zhdr->first_num = 0;
-	zhdr->start_middle = 0;
 	zhdr->cpu = -1;
-	zhdr->foreign_handles = 0;
-	zhdr->mapped_count = 0;
 	zhdr->slots = slots;
 	zhdr->pool = pool;
 	INIT_LIST_HEAD(&zhdr->buddy);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

