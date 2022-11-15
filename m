Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C35C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 19:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKOTuV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 14:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKOTuU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 14:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01925F8E
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 11:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C08D61784
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 19:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67FCC433C1;
        Tue, 15 Nov 2022 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668541818;
        bh=b0W7fhP2PKgSpW0RuTi0VOscp9C/MS25UGmQO9eYL4E=;
        h=Date:To:From:Subject:From;
        b=VedqYJNQAjdTAZeap+chO3MFhk158KqU9dCKhMFgz+VH+hLgYpOtQONyKGmOlzb9s
         2YfQWPFas/cD5qH5SoR8rkEoFiFI0uQdxQCTQtYjkfQ0xLNCkHB0Q78gc2grDAIizL
         pAlBFhoPiqQOQGctCI5naKfR76/Cy1Dn5virCufM=
Date:   Tue, 15 Nov 2022 11:50:18 -0800
To:     mm-commits@vger.kernel.org, zhangjinhao2@huawei.com,
        vbabka@suse.cz, rdunlap@infradead.org, guohanjun@huawei.com,
        zhengyejian1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acct-fix-potential-integer-overflow-in-encode_comp_t.patch added to mm-nonmm-unstable branch
Message-Id: <20221115195018.C67FCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acct: fix potential integer overflow in encode_comp_t()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     acct-fix-potential-integer-overflow-in-encode_comp_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acct-fix-potential-integer-overflow-in-encode_comp_t.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zheng Yejian <zhengyejian1@huawei.com>
Subject: acct: fix potential integer overflow in encode_comp_t()
Date: Sat, 15 May 2021 22:06:31 +0800

The integer overflow is descripted with following codes:
  > 317 static comp_t encode_comp_t(u64 value)
  > 318 {
  > 319         int exp, rnd;
    ......
  > 341         exp <<= MANTSIZE;
  > 342         exp += value;
  > 343         return exp;
  > 344 }

Currently comp_t is defined as type of '__u16', but the variable 'exp' is
type of 'int', so overflow would happen when variable 'exp' in line 343 is
greater than 65535.

Link: https://lkml.kernel.org/r/20210515140631.369106-3-zhengyejian1@huawei.com
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Jinhao <zhangjinhao2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/acct.c~acct-fix-potential-integer-overflow-in-encode_comp_t
+++ a/kernel/acct.c
@@ -350,6 +350,8 @@ static comp_t encode_comp_t(u64 value)
 		exp++;
 	}
 
+	if (exp > (((comp_t) ~0U) >> MANTSIZE))
+		return (comp_t) ~0U;
 	/*
 	 * Clean it up and polish it off.
 	 */
_

Patches currently in -mm which might be from zhengyejian1@huawei.com are

acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch
acct-fix-potential-integer-overflow-in-encode_comp_t.patch

