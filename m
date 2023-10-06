Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB7CE94108
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjJFTRz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjJFTRy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:17:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EB795;
        Fri,  6 Oct 2023 12:17:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0ACC433C8;
        Fri,  6 Oct 2023 19:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619870;
        bh=2zqtTTDisbdsknt0y+ts4M2OS+ihKcqhacDujCWu5bk=;
        h=Date:To:From:Subject:From;
        b=BAOVxzsxXOi48nGQ5bCaSN2ODbRB1J2YRwMYzXCT64JptM+A03UhDrcZPeQpEjiY3
         iRkIukZMKXmslXb+/KGqjOqRfDP3TpzSau/wahoHcfRr0CdWv9/MjqgDKm1qrrW7Y0
         Vjl3SGWmSOVnmtZKjtV436czPCJb+Fs8zoDTKOkA=
Date:   Fri, 06 Oct 2023 12:17:47 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        stable@vger.kernel.org, nphamcs@gmail.com, clm@fb.com,
        cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-pool-refcount-bug-around-shrink_worker.patch added to mm-hotfixes-unstable branch
Message-Id: <20231006191750.5C0ACC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: fix pool refcount bug around shrink_worker()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-pool-refcount-bug-around-shrink_worker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-pool-refcount-bug-around-shrink_worker.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: fix pool refcount bug around shrink_worker()
Date: Fri, 6 Oct 2023 12:00:24 -0400

When a zswap store fails due to the limit, it acquires a pool reference
and queues the shrinker.  When the shrinker runs, it drops the reference. 
However, there can be multiple store attempts before the shrinker wakes up
and runs once.  This results in reference leaks and eventual saturation
warnings for the pool refcount.

Fix this by dropping the reference again when the shrinker is already
queued.  This ensures one reference per shrinker run.

Link: https://lkml.kernel.org/r/20231006160024.170748-1-hannes@cmpxchg.org
Fixes: 45190f01dd40 ("mm/zswap.c: add allocation hysteresis if pool limit is hit")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Chris Mason <clm@fb.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>	[5.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-pool-refcount-bug-around-shrink_worker
+++ a/mm/zswap.c
@@ -1383,8 +1383,8 @@ reject:
 
 shrink:
 	pool = zswap_pool_last_get();
-	if (pool)
-		queue_work(shrink_wq, &pool->shrink_work);
+	if (pool && !queue_work(shrink_wq, &pool->shrink_work))
+		zswap_pool_put(pool);
 	goto reject;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-pool-refcount-bug-around-shrink_worker.patch

