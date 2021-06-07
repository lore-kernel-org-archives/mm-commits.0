Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E6BC47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A343611C0
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFGUnO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFGUnO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DCD8611AD;
        Mon,  7 Jun 2021 20:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098482;
        bh=CRflcXVHIPCsljD+nScRAdzewgWpRYPdPV9EefKeBKw=;
        h=Date:From:To:Subject:From;
        b=D8SwN5mNAAcIePKQcrYm4tzz8qFlkHE0zLKxKz2eBBFD5LR5f6mINccz9mxD3QE+S
         N4ckX4YDCemV995XZ4bYIA6l29eq1CfHdktW6HIWHLJas6Qk7wJaDSqAc7Tsn5NTXj
         SFMRTI5w954RBvoRHFbX5nO6GlwSx3msnGlTKZaw=
Date:   Mon, 07 Jun 2021 13:41:22 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, yi.zhang@huawei.com, yukuai3@huawei.com
Subject:  [merged] kasan-fix-doc-warning-in-initc.patch removed
 from -mm tree
Message-ID: <20210607204122.ql4QXlShh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan/init.c: fix doc warning
has been removed from the -mm tree.  Its filename was
     kasan-fix-doc-warning-in-initc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Kuai <yukuai3@huawei.com>
Subject: mm/kasan/init.c: fix doc warning

Fix gcc W=1 warning:

mm/kasan/init.c:228: warning: Function parameter or member 'shadow_start' not described in 'kasan_populate_early_shadow'
mm/kasan/init.c:228: warning: Function parameter or member 'shadow_end' not described in 'kasan_populate_early_shadow'

Link: https://lkml.kernel.org/r/20210603140700.3045298-1-yukuai3@huawei.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/init.c~kasan-fix-doc-warning-in-initc
+++ a/mm/kasan/init.c
@@ -220,8 +220,8 @@ static int __ref zero_p4d_populate(pgd_t
 /**
  * kasan_populate_early_shadow - populate shadow memory region with
  *                               kasan_early_shadow_page
- * @shadow_start - start of the memory range to populate
- * @shadow_end   - end of the memory range to populate
+ * @shadow_start: start of the memory range to populate
+ * @shadow_end: end of the memory range to populate
  */
 int __ref kasan_populate_early_shadow(const void *shadow_start,
 					const void *shadow_end)
_

Patches currently in -mm which might be from yukuai3@huawei.com are

lib-decompressors-remove-set-but-not-used-variabled-level.patch

