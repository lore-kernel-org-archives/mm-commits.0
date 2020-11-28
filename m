Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9300BC3E8C5
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7542075E
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jDJz5uE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbgK1CIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbgK1CIY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 21:08:24 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 816AC206D8;
        Sat, 28 Nov 2020 02:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529303;
        bh=RujZv6VSFEgyh+70tfrdQNRteefhY90jtbm94uq6KGI=;
        h=Date:From:To:Subject:From;
        b=jDJz5uE0dp6TJixMZvVuU0l/7fbcmM9a4+kdq2JlpuujW96QHTQ44L2RRFbM1alCP
         8g34rNJ3pyNJIZpNPs6T5qn93Blj2PwaxOXC1LL8lSK3/Gg+E6xfSlmQhmlekETJY3
         NSEvp0c16udjqN+g1Kw6DddXycXnQUpVdQn2KGEE=
Date:   Fri, 27 Nov 2020 18:08:22 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-madvise-fix-memory-leak-from-process_madvise.patch removed from -mm tree
Message-ID: <20201128020822.4XswYJcMx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: fix memory leak from process_madvise
has been removed from the -mm tree.  Its filename was
     mm-madvise-fix-memory-leak-from-process_madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/madvise: fix memory leak from process_madvise

The early return in process_madvise() will produce a memory leak.  Fix it.

Link: https://lkml.kernel.org/r/20201116155132.GA3805951@google.com
Fixes: ecb8ac8b1f14 ("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-memory-leak-from-process_madvise
+++ a/mm/madvise.c
@@ -1231,8 +1231,6 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		ret = total_len - iov_iter_count(&iter);
 
 	mmput(mm);
-	return ret;
-
 release_task:
 	put_task_struct(task);
 put_pid:
_

Patches currently in -mm which might be from edumazet@google.com are


