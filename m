Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3878BC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 22 Jan 2021 00:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5D622527
	for <mm-commits@archiver.kernel.org>; Fri, 22 Jan 2021 00:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAVAln (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 19:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbhAVAll (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 19:41:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419C920769;
        Fri, 22 Jan 2021 00:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611276060;
        bh=fa47UC7UC/jK9Huc1keRekr3HkzzvHyFLtH437yPOCs=;
        h=Date:From:To:Subject:From;
        b=ELe/qFgfg42pzKGGF5txJbiS1VSBV40IfSzfe1VTLtDh1jAp631+jzoSgGybHy9/q
         X2L4VYTGtkxVhiAKYVQPwWVpiuMjZNnIM8DfdriBVl8/s/lTitbnQ56lwdVyOkJ+Mn
         k3EqdQk6DJbEPHGGWQB69OcpAK/GkIhziJRt7LXs=
Date:   Thu, 21 Jan 2021 16:40:59 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  +
 z3fold-remove-unused-attribute-for-release_z3fold_page.patch added to -mm
 tree
Message-ID: <20210122004059.Kk-q7tbfY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: remove unused attribute for release_z3fold_page
has been added to the -mm tree.  Its filename is
     z3fold-remove-unused-attribute-for-release_z3fold_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/z3fold-remove-unused-attribute-for-release_z3fold_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/z3fold-remove-unused-attribute-for-release_z3fold_page.patch

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
Subject: z3fold: remove unused attribute for release_z3fold_page

Since commit dcf5aedb24f8 ("z3fold: stricter locking and more careful
reclaim"), release_z3fold_page() is used again.  So we can drop the unused
attribute safely.

Link: https://lkml.kernel.org/r/20210120084008.58432-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~z3fold-remove-unused-attribute-for-release_z3fold_page
+++ a/mm/z3fold.c
@@ -541,8 +541,7 @@ static void __release_z3fold_page(struct
 	spin_unlock(&pool->stale_lock);
 }
 
-static void __attribute__((__unused__))
-			release_z3fold_page(struct kref *ref)
+static void release_z3fold_page(struct kref *ref)
 {
 	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
 						refcount);
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

