Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B814BC11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25BF61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhF2CiC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231724AbhF2CiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E5961D02;
        Tue, 29 Jun 2021 02:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934135;
        bh=UCLIWC3XE2ZeSsayDWFa9B1L/a5HdwC3IIzLkvkIgQU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2nELvZc4X8mTauqHcTPjBPnCRlaaJbK2eXsbsGCf5c+CqdeEkcYY7DhNxgPPcpimq
         FC4XoxRuSz2iMHhG60Opt3CS3lvD+uuHRTa1x3GpMRv4V90cMrnefDCmCOGNezJhJ4
         gn2v+qrA1dyxmjyTILvG4DGzTypQFMyUyjygvnPI=
Date:   Mon, 28 Jun 2021 19:35:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@fb.com, hcochran@kernelspring.com,
        jack@suse.cz, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, sedat.dilek@gmail.com, tj@kernel.org,
        torvalds@linux-foundation.org, wuchi.zero@gmail.com
Subject:  [patch 044/192] mm/page-writeback: update the comment of
 Dirty position control
Message-ID: <20210629023534.q8-pTS97e%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chi Wu <wuchi.zero@gmail.com>
Subject: mm/page-writeback: update the comment of Dirty position control

As the value of pos_ratio_polynom() clamp between 0 and 2LL <<
RATELIMIT_CALC_SHIFT, the global control line should be consistent with
it.

Link: https://lkml.kernel.org/r/20210511103606.3732-1-wuchi.zero@gmail.com
Signed-off-by: Chi Wu <wuchi.zero@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-update-the-comment-of-dirty-position-control
+++ a/mm/page-writeback.c
@@ -845,7 +845,7 @@ static long long pos_ratio_polynom(unsig
  *     ^ pos_ratio
  *     |
  *     |            |<===== global dirty control scope ======>|
- * 2.0 .............*
+ * 2.0  * * * * * * *
  *     |            .*
  *     |            . *
  *     |            .   *
_
