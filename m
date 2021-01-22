Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB34C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 22 Jan 2021 00:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0BB322D50
	for <mm-commits@archiver.kernel.org>; Fri, 22 Jan 2021 00:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbhAVAlr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 19:41:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbhAVAlo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 19:41:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2667622D50;
        Fri, 22 Jan 2021 00:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611276063;
        bh=Kqxnt7s8hYJoRJpQkvkIw7kn5UCKef831v7N3p/oiEQ=;
        h=Date:From:To:Subject:From;
        b=L6YhZD3dJvMlyCsEXcxbVIqUSJe5SPWSwa+R77DGQLEVaTFe+wLvMrYL/aDcwmnTC
         gIPiw93gg4o46G0tA+xmkW3aCwBaY1beDG+1RBkFOV7WbfUVKWRBmFn/jWVWXoJM8h
         3HzSdRJubWSwOp+fv8lHf08WhtgNOp5idXx9zk1I=
Date:   Thu, 21 Jan 2021 16:41:02 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  +
 z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
 added to -mm tree
Message-ID: <20210122004102.MozgzCu7g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: simplify the zhdr initialization code in init_z3fold_page()
has been added to the -mm tree.  Its filename is
     z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

