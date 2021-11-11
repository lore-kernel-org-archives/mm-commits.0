Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57354C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3975161108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhKKCvh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhKKCvf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B6916103C;
        Thu, 11 Nov 2021 02:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598927;
        bh=33A6oQzrPHVHqdC7QdQmYLU2eBZ8QrXnEfztfAP5/T0=;
        h=Date:From:To:Subject:From;
        b=A8+nrOU3E3EB3ExiWC6EKHyYcQCLPEygqpczA/FQA0NB5Oogo/7TuIRtlPe1XZ1ws
         AgPKxy0Z3ZPUNP6M1OFq6TMCjJBavqIIAXRyWNc1VaDkpuiSS9aL8LWY9s9oE+gVEc
         XPLU/JFJ+KQF856zUZfSB7FG95jMcvoayVNbJ4yw=
Date:   Wed, 10 Nov 2021 18:48:47 -0800
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  [merged]
 mm-damon-remove-unnecessary-do_exit-from-kdamond.patch removed from -mm
 tree
Message-ID: <20211111024847.7HqcR8Uje%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary do_exit() from kdamond
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-unnecessary-do_exit-from-kdamond.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


