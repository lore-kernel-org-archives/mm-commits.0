Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889E0C388F9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1E3206DC
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604173168;
	bh=j01YIpwr0Lsfhhb0TKIHFyYHdEOxKWyanKf1nd/YrPA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yS4CQ9lpZnQCo8510gb7x6iNo811WeT3g7gVc6keg8osp47KD8npeLmdGqH5KanpA
	 ZpPzMuuUFqSJfwmKUfjeIZQNhkOq4afjheok7AiKM1nkv4ygT10uqLfgS8PAvyJMEj
	 vImFidO8C2z/ubaDwdkuCE4QI/ztEpprC5Y4V+6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgJaTj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJaTj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 15:39:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB05F206DB;
        Sat, 31 Oct 2020 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173166;
        bh=j01YIpwr0Lsfhhb0TKIHFyYHdEOxKWyanKf1nd/YrPA=;
        h=Date:From:To:Subject:From;
        b=jRnjc2luEs+hi6rwBf1eQSG1MkYpP4a7gezjbe01NuN3763tn3rRKeezVroW3rqby
         Yvg2PdXbErSTYN8m6xDRoGRmvyHd+DTtWgCO9M1XbUpGLUORHIt4e3U0HCsTxiqaof
         iLfcr2fdsx9Y4la1V5kH1bKXh2biSlbn2RmyMHyI=
Date:   Sat, 31 Oct 2020 12:39:26 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com, yuehaibing@huawei.com
Subject:  + mm-zswap-fix-passing-zero-to-ptr_err-warning.patch
 added to -mm tree
Message-ID: <20201031193926.lhqpmwLT-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix passing zero to 'PTR_ERR' warning
has been added to the -mm tree.  Its filename is
     mm-zswap-fix-passing-zero-to-ptr_err-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-fix-passing-zero-to-ptr_err-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-fix-passing-zero-to-ptr_err-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zswap-fix-passing-zero-to-ptr_err-warning.patch

