Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACD0C77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjE3Wai (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjE3Wai (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE9893
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE9D8634AA
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CE7C433D2;
        Tue, 30 May 2023 22:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685485836;
        bh=bNrUG12HItpKzjqg9EfSECAq8W7s2SlR9P6SsyPSL2I=;
        h=Date:To:From:Subject:From;
        b=nZJSygU5vCiiVrkiQ1yJP3r53Q+FlC2/T+PLdSg/VDeoGe3IHM9JFPktccq1Sm924
         KXdSWzlyRIGmE5SOWTJjnVQnBQKsyebQeZUUYN6A9HU/KZQluf8BZqFfr8j/M7buIB
         UPmaldOaVEF7iFOqqPi2bTk+a0YPjSwJaTg2axuo=
Date:   Tue, 30 May 2023 15:30:35 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-do-not-shrink-if-cgroup-may-not-zswap.patch added to mm-unstable branch
Message-Id: <20230530223036.23CE7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: do not shrink if cgroup may not zswap
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-do-not-shrink-if-cgroup-may-not-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-do-not-shrink-if-cgroup-may-not-zswap.patch

This patch will later appear in the mm-unstable branch at
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
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: do not shrink if cgroup may not zswap
Date: Tue, 30 May 2023 15:24:40 -0700

Before storing a page, zswap first checks if the number of stored pages
exceeds the limit specified by memory.zswap.max, for each cgroup in the
hierarchy. If this limit is reached or exceeded, then zswap shrinking is
triggered and short-circuits the store attempt.

However, since the zswap's LRU is not memcg-aware, this can create the
following pathological behavior: the cgroup whose zswap limit is
reached will evict pages from other cgroups continually, without
lowering its own zswap usage. This means the shrinking will continue
until the need for swap ceases or the pool becomes empty.

As a result of this, we observe a disproportionate amount of zswap
writeback and a perpetually small zswap pool in our experiments, even
though the pool limit is never hit.

This patch fixes the issue by rejecting zswap store attempt without
shrinking the pool when obj_cgroup_may_zswap() returns false.

Link: https://lkml.kernel.org/r/20230530222440.2777700-1-nphamcs@gmail.com
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-do-not-shrink-if-cgroup-may-not-zswap
+++ a/mm/zswap.c
@@ -1174,9 +1174,14 @@ static int zswap_frontswap_store(unsigne
 		goto reject;
 	}
 
+	/*
+	 * XXX: zswap reclaim does not work with cgroups yet. Without a
+	 * cgroup-aware entry LRU, we will push out entries system-wide based on
+	 * local cgroup limits.
+	 */
 	objcg = get_obj_cgroup_from_page(page);
 	if (objcg && !obj_cgroup_may_zswap(objcg))
-		goto shrink;
+		goto reject;
 
 	/* reclaim space if needed */
 	if (zswap_is_full()) {
_

Patches currently in -mm which might be from nphamcs@gmail.com are

workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
cachestat-implement-cachestat-syscall.patch
cachestat-implement-cachestat-syscall-fix.patch
cachestat-wire-up-cachestat-for-other-architectures.patch
cachestat-wire-up-cachestat-for-other-architectures-fix.patch
selftests-add-selftests-for-cachestat.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap.patch

