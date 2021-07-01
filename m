Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C6DC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E31661474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbhGABxH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238451AbhGABxG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E346D61241;
        Thu,  1 Jul 2021 01:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104237;
        bh=jjK0vP4z5S8Qw8Nrw75eoUT+YTFBaPnX8il2WKqqGh4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iVzsDawq87TsysRHGA+lzCNFxIKtz0ZJWKzN4ig0vR1G44TlgCRAui2JD0ULWjR4f
         UiGrz6Hh4+CSmTYYug9M9bi+SC8i5qCM2evaWnYVaCkLnfBAGGklS7euKCeY//mPWL
         Ob4spCDwaW5GgMu5r81yXWlusKzL9pU5YBdtGtV0=
Date:   Wed, 30 Jun 2021 18:50:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 064/192] mm/z3fold: fix potential memory leak in
 z3fold_destroy_pool()
Message-ID: <20210701015036.QdGlpLe6T%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix potential memory leak in z3fold_destroy_pool()

There is a memory leak in z3fold_destroy_pool() as it forgets to
free_percpu pool->unbuddied.  Call free_percpu for pool->unbuddied to fix
this issue.

Link: https://lkml.kernel.org/r/20210619093151.1492174-6-linmiaohe@huawei.com
Fixes: d30561c56f41 ("z3fold: use per-cpu unbuddied lists")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/z3fold.c~mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool
+++ a/mm/z3fold.c
@@ -1046,6 +1046,7 @@ static void z3fold_destroy_pool(struct z
 	destroy_workqueue(pool->compact_wq);
 	destroy_workqueue(pool->release_wq);
 	z3fold_unregister_migration(pool);
+	free_percpu(pool->unbuddied);
 	kfree(pool);
 }
 
_
