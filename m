Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C1DC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiLAAR4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLAARD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4959950B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:14:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9988061978
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8901C433C1;
        Thu,  1 Dec 2022 00:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853643;
        bh=fpGD6JWqPDZuF5zoOnr81vU5UdvdAclI+2ExqUzp4n4=;
        h=Date:To:From:Subject:From;
        b=1+UTCu9ioIold+X4T/jE+e6FJmBJ32M1HiHCEiGjHBDhdqIEPLZ8E+y8aaZbft0pQ
         bFYXbaX6wGzxQ8g0/lpEEth4vkn6WYny5a/SOdDagTVTLQTkuJEsYDTJ0D8twrprwT
         xiPCjtO7u7ORxJ/7b1p5qWoq/3v6ql/waij326zE=
Date:   Wed, 30 Nov 2022 16:14:03 -0800
To:     mm-commits@vger.kernel.org, zhangjinhao2@huawei.com,
        vbabka@suse.cz, rdunlap@infradead.org, guohanjun@huawei.com,
        zhengyejian1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] acct-fix-potential-integer-overflow-in-encode_comp_t.patch removed from -mm tree
Message-Id: <20221201001403.B8901C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: acct: fix potential integer overflow in encode_comp_t()
has been removed from the -mm tree.  Its filename was
     acct-fix-potential-integer-overflow-in-encode_comp_t.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


