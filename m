Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26099C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134D86135A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhKEUs4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhKEUsu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ECFF6135A;
        Fri,  5 Nov 2021 20:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145170;
        bh=2YHM+jk7eYYqSgWjZAtGj9Hr2ACNlZNXejG7tpC+Ucg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nJJKS9kfjnHhin/PzuOP2TVtHPWsNiY4aiwoJQsC1v5uuxO/Bf9LGoftRUXlaD3vx
         MtzLOZqXSx0vtB1crzjHi728VnG+Xkluh7zq4b92ExGnfUrpPpP0pWKMKWWPqgJi4X
         L8dZhAwxOSYc6qIFIse4IJyxhCopPzRd43jxQz2U=
Date:   Fri, 05 Nov 2021 13:46:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 220/262] mm/damon: remove unnecessary do_exit()
 from kdamond
Message-ID: <20211105204609.O_S_2ZhvC%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
