Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F029C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576DD61D02
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2CgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2Cf7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C231E61CEF;
        Tue, 29 Jun 2021 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934013;
        bh=8Zk34LB12Dtzs7yLTnezAzVRYZgbjeJvd4f18xv17pQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UK/6JYV545gFcbDT0/poOatyIGPgtRj6Iv4ETC3yu/lwfCHZauGjls/bCnUf6Y4Bs
         Lq5TiqjdZ+xQHpfD5224g8jSTkaWKJ1777N/PwMwIZr8l8ZBys+KZXrLKRO1Wetr+C
         oUtD9rHlUXI8manDD4l118JWZhHrj69vsUZ/JjH8=
Date:   Mon, 28 Jun 2021 19:33:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, Felix.Kuehling@amd.com,
        j.neuschaefer@gmx.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, valentin.schneider@arm.com
Subject:  [patch 004/192] kthread: switch to new kerneldoc syntax
 for named variable macro argument
Message-ID: <20210629023332.8k5B3vX2d%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Subject: kthread: switch to new kerneldoc syntax for named variable macro a=
rgument

The syntax without dots is available since commit 43756e347f21
("scripts/kernel-doc: Add support for named variable macro arguments").

The same HTML output is produced with and without this patch.

Link: https://lkml.kernel.org/r/20210513161702.1721039-1-j.neuschaefer@gmx.=
net
Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kthread.h~kthread-switch-to-new-kerneldoc-syntax-for-na=
med-variable-macro-argument
+++ a/include/linux/kthread.h
@@ -18,7 +18,7 @@ struct task_struct *kthread_create_on_no
  * @threadfn: the function to run in the thread
  * @data: data pointer for @threadfn()
  * @namefmt: printf-style format string for the thread name
- * @arg...: arguments for @namefmt.
+ * @arg: arguments for @namefmt.
  *
  * This macro will create a kthread on the current node, leaving it in
  * the stopped state.  This is just a helper for kthread_create_on_node();
_
