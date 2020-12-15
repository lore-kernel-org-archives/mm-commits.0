Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DA7C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 692FC223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgLODP4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbgLODO4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:56 -0500
Date:   Mon, 14 Dec 2020 19:14:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002056;
        bh=YJXLSVMPYnwn4044zXgDCUZDwdlEwNg4VJtphHsGZ6Y=;
        h=From:To:Subject:In-Reply-To:From;
        b=01iAsAAIQh+6HWV5uaCvpGjnKkZURU4ZrROcjcRoS1/l6aNA6MTtYt5Rk+ayQ1RaV
         CMJofMvS7D4nT0/T/XMv05n5efdw2Q09XVHkJgMBVj1tn1pUMNOu3TCCK1HW8oKqym
         dNomZ/ndPWz66uNY4kQJgL7FHT/6dRmkrk7CyeM4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sjenning@redhat.com, torvalds@linux-foundation.org,
        vitaly.wool@konsulko.com, yuehaibing@huawei.com
Subject:  [patch 186/200] mm/zswap: fix passing zero to 'PTR_ERR'
 warning
Message-ID: <20201215031415.Wm5L21KrC%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/zswap: fix passing zero to 'PTR_ERR' warning

Fix smatch warning:

mm/zswap.c:425 zswap_cpu_comp_prepare() warn: passing zero to 'PTR_ERR'

crypto_alloc_comp() never return NULL, use IS_ERR instead of
IS_ERR_OR_NULL to fix this.

Link: https://lkml.kernel.org/r/20201031055615.28080-1-yuehaibing@huawei.com
Fixes: f1c54846ee45 ("zswap: dynamic pool creation")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-fix-passing-zero-to-ptr_err-warning
+++ a/mm/zswap.c
@@ -421,7 +421,7 @@ static int zswap_cpu_comp_prepare(unsign
 		return 0;
 
 	tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
-	if (IS_ERR_OR_NULL(tfm)) {
+	if (IS_ERR(tfm)) {
 		pr_err("could not alloc crypto comp %s : %ld\n",
 		       pool->tfm_name, PTR_ERR(tfm));
 		return -ENOMEM;
_
