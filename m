Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1661FC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E811C60F9C
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhISXZu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXZt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EEA61028;
        Sun, 19 Sep 2021 23:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632093864;
        bh=kFtAT6XCYp4qtEMbZZrWb4CUKWP9e3KeesRDnF+MYw8=;
        h=Date:From:To:Subject:From;
        b=kMjg7zv/HqKryVK3S3nkw3GnzBI0KiiCpQtLcFtnH01g8Z+2+IYb5gmAL9crVECv+
         RgYw+lFaAigJ8cml6EX+fd8KmzHs/OfWEZIjX41aokKj7pPc4PSiPLNUEpI9HxlA2y
         JGyw7i0cFM11S9rAYjbIYDkx3axIuyjjA6q8awr8=
Date:   Sun, 19 Sep 2021 16:24:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vulab@iscas.ac.cn
Subject:  +
 mm-swapfile-remove-needless-request_queue-null-pointer-check.patch added to
 -mm tree
Message-ID: <20210919232423.5PUbI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: remove needless request_queue NULL pointer check
has been added to the -mm tree.  Its filename is
     mm-swapfile-remove-needless-request_queue-null-pointer-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-remove-needless-request_queue-null-pointer-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-remove-needless-request_queue-null-pointer-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xu Wang <vulab@iscas.ac.cn>
Subject: mm/swapfile: remove needless request_queue NULL pointer check

The request_queue pointer returned from bdev_get_queue() shall never be
NULL, so the null check is unnecessary, just remove it.

Link: https://lkml.kernel.org/r/20210917082111.33923-1-vulab@iscas.ac.cn
Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-remove-needless-request_queue-null-pointer-check
+++ a/mm/swapfile.c
@@ -3118,7 +3118,7 @@ static bool swap_discardable(struct swap
 {
 	struct request_queue *q = bdev_get_queue(si->bdev);
 
-	if (!q || !blk_queue_discard(q))
+	if (!blk_queue_discard(q))
 		return false;
 
 	return true;
_

Patches currently in -mm which might be from vulab@iscas.ac.cn are

mm-swapfile-remove-needless-request_queue-null-pointer-check.patch

