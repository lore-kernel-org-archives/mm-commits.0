Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADABEC07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941526117A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhGFTMV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTMV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D94461107;
        Tue,  6 Jul 2021 19:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598582;
        bh=KXKD//xJIlZFpMmTBPz3ODgC9Xl0wr2zSzCdU5VzGtc=;
        h=Date:From:To:Subject:From;
        b=AaoXJxZYACCD9tcZoWPNoypCCDmL5+/7Tj4aipkWZj2MZh1c0xUW9tFz7GQ8jQL/i
         0BtT8DRab4NrLKrBoy52SogTJ5g/LIdBV7PL2lo0OmN8RSfAOrlTLW8N8Jl2avNfws
         6A9E2ktc5G6/dN/aUTGpAPf02jh4k+e2lArmKuUI=
Date:   Tue, 06 Jul 2021 12:09:42 -0700
From:   akpm@linux-foundation.org
To:     axboe@fb.com, hcochran@kernelspring.com, jack@suse.cz,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        sedat.dilek@gmail.com, tj@kernel.org, wuchi.zero@gmail.com
Subject:  [merged]
 mm-page-writeback-update-the-comment-of-dirty-position-control.patch
 removed from -mm tree
Message-ID: <20210706190942.WgFV5pPLk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: update the comment of Dirty position control
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-update-the-comment-of-dirty-position-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wuchi.zero@gmail.com are


