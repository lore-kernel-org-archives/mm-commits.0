Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9147DC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A6CD206FA
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598900163;
	bh=JLq+tG3Xnjd14DnktCw3WOXixDHVvix7XH/RaUTm5jI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xwGPBWWgQYFcyWxRhgk7923ce/Lm0jh8jD8AgLOpX9zPqwR2Sil7VG4ic90SwZqDs
	 fY7OPIuCjXl4ELqmxgbhLUbjWR/QT1YHwizBwrMTQCnPNgxZPE9mIsj+yrhcWy04Di
	 x0llithCThf16sv0rMOzcCimWeHlcqjbY8DZpMz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgHaS4D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgHaS4C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:56:02 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BDC1206FA;
        Mon, 31 Aug 2020 18:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598900162;
        bh=JLq+tG3Xnjd14DnktCw3WOXixDHVvix7XH/RaUTm5jI=;
        h=Date:From:To:Subject:From;
        b=CDmAoP0lqVCgP1ILxXZaeXM/17i58BoJI5LpHm/GsiZeGoTrq526RgOarLMOVl1fS
         NMW9UTJfhlVqfzPP18xVNz8VF2kdLnuEZWoRS/bACAt+Q3MxiJXaKSCryISmRGH0Fv
         6BdCnUL89JE2JCUjB18BjXxYWFxuFVJ3N1ru4F4A=
Date:   Mon, 31 Aug 2020 11:56:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jgg@nvidia.com
Subject:  + log2-add-missing-around-n-in-roundup_pow_of_two.patch
 added to -mm tree
Message-ID: <20200831185601.224eI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/log2.h: add missing () around n in roundup_pow_of_two()
has been added to the -mm tree.  Its filename is
     log2-add-missing-around-n-in-roundup_pow_of_two.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/log2-add-missing-around-n-in-roundup_pow_of_two.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/log2-add-missing-around-n-in-roundup_pow_of_two.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Otherwise gcc generates warnings if the expression is complicated.

Link: https://lkml.kernel.org/r/0-v1-8a2697e3c003+41165-log_brackets_jgg@nvidia.com
Fixes: 312a0c170945 ("[PATCH] LOG2: Alter roundup_pow_of_two() so that it can use a ilog2() on a constant")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/log2.h~log2-add-missing-around-n-in-roundup_pow_of_two
+++ a/include/linux/log2.h
@@ -173,7 +173,7 @@ unsigned long __rounddown_pow_of_two(uns
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 1 :			\
+		((n) == 1) ? 1 :		\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
_

Patches currently in -mm which might be from jgg@nvidia.com are

log2-add-missing-around-n-in-roundup_pow_of_two.patch

