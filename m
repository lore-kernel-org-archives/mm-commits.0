Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0210C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A48661181
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhI1AKs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238255AbhI1AKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 20:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7117D61181;
        Tue, 28 Sep 2021 00:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632787749;
        bh=kRLlKtcZLmpJp+CNffWC7Ee2DCXeE/2MFByTOaafyxc=;
        h=Date:From:To:Subject:From;
        b=Fbhzi0btUPq2Zyypxpuw6h/pQcx+7ekXB3J0/rr3e5/2Sm8vJsX1+cfXo3zBmdyA4
         VHRoIc/1Q1pUSguGIYwLgl4LPKTh2pR4ESXdfQI6SR4htuDacvtImUWmTmJDQF6scO
         67LNbhPvolkzliGigRPMOq+sh9w5U9EQ84bfJ0Sg=
Date:   Mon, 27 Sep 2021 17:09:08 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  + mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
 added to -mm tree
Message-ID: <20210928000908.31Gnc7g__%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary do_exit() from kdamond
has been added to the -mm tree.  Its filename is
     mm-damon-remove-unnecessary-do_exit-from-kdamond.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-unnecessary-do_exit-from-kdamond.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: mm/damon: remove unnecessary do_exit() from kdamond

Just return from the kthread function.

Link: https://lkml.kernel.org/r/20210927232421.17694-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-remove-unnecessary-do_exit-from-kdamond
+++ a/mm/damon/core.c
@@ -714,7 +714,7 @@ static int kdamond_fn(void *data)
 	nr_running_ctxs--;
 	mutex_unlock(&damon_lock);
 
-	do_exit(0);
+	return 0;
 }
 
 #include "core-test.h"
_

Patches currently in -mm which might be from changbin.du@gmail.com are

mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch

