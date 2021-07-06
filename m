Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD0CC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2446561C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGFTVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGFTVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675D761C7C;
        Tue,  6 Jul 2021 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599122;
        bh=qrQ+IJEYlKu3+ST+4/357/8hN1bElkN2L1d2lLt62YI=;
        h=Date:From:To:Subject:From;
        b=kQ3jBQ7vVRyeJQVMe3LFutCHyZ5Kpym1aaI3zkecNlp7YYIp75NzBJlXhQiVpXeST
         ViDHP7J8Un9BqlQy03fSV0ka0KFhgn2gb2qMeLJfFpPqq9WupF0nx8t7vAHdncekgO
         nbcSw3RLtytg8zX97q61gmvfJZoIkGdMJvdMclNo=
Date:   Tue, 06 Jul 2021 12:18:42 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch removed
 from -mm tree
Message-ID: <20210706191842.Z-dSnmhTM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

