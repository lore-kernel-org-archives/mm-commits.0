Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47422C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8CEF218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881617;
	bh=uKUNeGRlWi10JZAJkEDll+vBVfyEnz1O7L2p6Udvt00=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tgcut+pCZ02K1uV+Ha4I+3H+T+ob7wYM8NFrZERmNKv/rPTs1R0VJQ1Z5Zhlm9LKc
	 /S8Wp+FHL8gZUjrWTT8kuBtFMQhx1Y9k/WWkO9ArjdgmFAMNwGMsE7GGCD698c2A6/
	 O9jmriXzNzfK+ZhOwSsoIruKE1nZMspBsz1dDT0k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409135AbgJPUxg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27332076C;
        Fri, 16 Oct 2020 20:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881616;
        bh=uKUNeGRlWi10JZAJkEDll+vBVfyEnz1O7L2p6Udvt00=;
        h=Date:From:To:Subject:From;
        b=Dcci073qaXFwdoohY/Q17PLNig0vdvAWuYQ0XBIgn01wkmySNuh4KSRl1m2jn4S52
         SLQzhP/KZuhmzBs4KmljARGlvYayucLPjDKXt9ZQmo7nzpxARWLibU1xRqlyoNdTMQ
         EOWYv0NwoUw1P7XfFpmPftkYkNiBSsTn6sTUfA6A=
Date:   Fri, 16 Oct 2020 13:53:35 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, kernel@cdqe.de, krzk@kernel.org,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch removed from
 -mm tree
Message-ID: <20201016205335.Gtp-EHa1K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/crc32.c: fix trivial typo in preprocessor condition
has been removed from the -mm tree.  Its filename was
     lib-crc32c-fix-trivial-typo-in-preprocessor-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tobias Jordan <kernel@cdqe.de>
Subject: lib/crc32.c: fix trivial typo in preprocessor condition

Whether crc32_be needs a lookup table is chosen based on CRC_LE_BITS. 
Obviously, the _be function should be governed by the _BE_ define.

This probably never pops up as it's hard to come up with a configuration
where CRC_BE_BITS isn't the same as CRC_LE_BITS and as nobody is using
bitwise CRC anyway.

Link: https://lkml.kernel.org/r/20200923182122.GA3338@agrajag.zerfleddert.de
Fixes: 46c5801eaf86 ("crc32: bolt on crc32c")
Signed-off-by: Tobias Jordan <kernel@cdqe.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crc32.c~lib-crc32c-fix-trivial-typo-in-preprocessor-condition
+++ a/lib/crc32.c
@@ -331,7 +331,7 @@ static inline u32 __pure crc32_be_generi
 	return crc;
 }
 
-#if CRC_LE_BITS == 1
+#if CRC_BE_BITS == 1
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len, NULL, CRC32_POLY_BE);
_

Patches currently in -mm which might be from kernel@cdqe.de are


