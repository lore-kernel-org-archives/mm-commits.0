Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AC1C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 00:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1B06191E
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 00:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhELAFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 20:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhELAFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 20:05:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0F461919;
        Wed, 12 May 2021 00:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620777854;
        bh=QBUy9X3y8T6U0rLCg2HLey0UdHlLOanMYURMnodd300=;
        h=Date:From:To:Subject:From;
        b=SIzZzEIi5eUCTrkd1AGbAjF37Z+EU92CiksWwQjKQ5FszaYNUXwuRcSR+UHBxDJYo
         ZHI0jrZ+0vruN1fnZ2BiZr9TL2Sfu8pw50dJpLUT8BceAvD0YHhgP6XqPaPfa6iPaN
         sev3i9Kacd9T6kjQcfk+izPHUSgd+QsIpTSp7OYk=
Date:   Tue, 11 May 2021 17:04:13 -0700
From:   akpm@linux-foundation.org
To:     axboe@fb.com, hcochran@kernelspring.com, jack@suse.cz,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        sedat.dilek@gmail.com, tj@kernel.org, wuchi.zero@gmail.com
Subject:  +
 mm-page-writeback-update-the-comment-of-dirty-position-control.patch added
 to -mm tree
Message-ID: <20210512000413.SqYP9bmav%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: update the comment of Dirty position control
has been added to the -mm tree.  Its filename is
     mm-page-writeback-update-the-comment-of-dirty-position-control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-update-the-comment-of-dirty-position-control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-update-the-comment-of-dirty-position-control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch
mm-page-writeback-update-the-comment-of-dirty-position-control.patch

