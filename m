Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9E1C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9485761C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhGFTVX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhGFTVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8305461C7F;
        Tue,  6 Jul 2021 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599124;
        bh=UrvePiiFeDUs6xhEdSTCcbMBn9UlirkuTocaB0z/wPc=;
        h=Date:From:To:Subject:From;
        b=19WY/AHDGVCSq5btoSs6piboUz+AZuDzN3XMhm0Ky3K0LnpGN+RtNT+6gIfjW5nPQ
         HZoHLDP8ZQvx6DeNeTV8TVJ60FS2LC5PvJ7fGxZtY9nTx8a/XPRjqdAQKVMlfMYvEk
         VhV4u6ua83SCdhB309WOwZhuFyXqer/ByxHNkLys=
Date:   Tue, 06 Jul 2021 12:18:44 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 =?US-ASCII?Q?mm-z3fold-use-release=5Fz3fold=5Fpage=5Flocked-to-release-?=
 =?US-ASCII?Q?locked-z3fold-page.patch?= removed from -mm tree
Message-ID: <20210706191844.t9kSbT580%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page
has been removed from the -mm tree.  Its filename was
     mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page

We should use release_z3fold_page_locked() to release z3fold page when
it's locked, although it looks harmless to use release_z3fold_page() now.

Link: https://lkml.kernel.org/r/20210619093151.1492174-7-linmiaohe@huawei.com
Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page
+++ a/mm/z3fold.c
@@ -1370,7 +1370,7 @@ static int z3fold_reclaim_page(struct z3
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
 				if (kref_put(&zhdr->refcount,
-						release_z3fold_page))
+						release_z3fold_page_locked))
 					atomic64_dec(&pool->pages_nr);
 				else
 					z3fold_page_unlock(zhdr);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

