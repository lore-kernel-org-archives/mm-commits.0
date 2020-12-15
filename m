Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1F3C2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D26A22CB8
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgLPAAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgLOX2U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:20 -0500
Date:   Tue, 15 Dec 2020 15:24:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074658;
        bh=Qg4h88TEmOw3XjiNsABHZ4Qwf0NxybA9ldCAF3PUrPA=;
        h=From:To:Subject:From;
        b=ybEtLhDDNFifQl29qJaubC0IfnakyhJU91DmYkRZhPEeIppHcKE0wrexJB/49MWNo
         rcfa3O1C9MBkGzqn5mrugZKBJW/Zjtbc9z3MCvxdqEWd3ufdlMefL0QuW2cix7x37y
         4h/4+Sc8Hm88k0kayV924HeFytLelS003xSVHVDU=
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mm-commits@vger.kernel.org,
        sjenning@redhat.com, vitaly.wool@konsulko.com,
        yuehaibing@huawei.com
Subject:  [merged]
 mm-zswap-fix-passing-zero-to-ptr_err-warning.patch removed from -mm tree
Message-ID: <20201215232418.Mh-16X1R6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix passing zero to 'PTR_ERR' warning
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-passing-zero-to-ptr_err-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yuehaibing@huawei.com are


