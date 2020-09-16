Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B566C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 00:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC7720770
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 00:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600217027;
	bh=1Scq/kfXwRwJjp/S3R0Qp/u3cjY63dlKvpyYJHZ3MMc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cccsqv+rI6MZHNX+KGeK3M1Ua4KrniA+WH5AGkdQ/qaopNdDfPRTWqXR1ubrXeMEV
	 +brEB1YOvuYKcmGZQ5YtAQZnYziEk4h8gF2l5SXI0kq4xqheIQaFc116S4dUP582Me
	 68UkjYDm5c6PHD8eQJvH33S5KHfD3ySuwP7RF26o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgIPAnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgIPAnk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 20:43:40 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E75952076B;
        Wed, 16 Sep 2020 00:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600217020;
        bh=1Scq/kfXwRwJjp/S3R0Qp/u3cjY63dlKvpyYJHZ3MMc=;
        h=Date:From:To:Subject:From;
        b=croxxG8SniKGwEiXMm4EeiQZdoeAObk0ZEGsybhCuQvHaWic8GYdP9kNyjaXq5Sn/
         tabnxzz6kppGN/ZH10oE237zvXJxAYEINbKLzlKkpAQIbmgt7o2f6IvCcpI9pJxcRg
         NpEdTT/4mezOybHJ0NiHYyKfAjqY9aQpwGfm4wlM=
Date:   Tue, 15 Sep 2020 17:43:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        yuehaibing@huawei.com
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix.patch?= added to
 -mm tree
Message-ID: <20200916004339.PFJjF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: remove duplicate include
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/madvise: remove duplicate include

Remove duplicate header which is included twice.

Link: https://lkml.kernel.org/r/20200915121550.30584-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -30,7 +30,6 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
-#include <linux/sched/mm.h>
 
 #include <asm/tlb.h>
 
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-slab-remove-duplicate-include.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix.patch

