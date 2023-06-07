Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE41C8300C
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjFGUA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjFGUAX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C7211C;
        Wed,  7 Jun 2023 13:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67E7064159;
        Wed,  7 Jun 2023 20:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92FEC433EF;
        Wed,  7 Jun 2023 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168020;
        bh=G2s+ySQINXD/tVBbILXafZRUijme584C+/D59MZJR/A=;
        h=Date:To:From:Subject:From;
        b=trH6YAScSSAXVl5RbSlkag3RRObHIM5uRM4t539+K8DWMjN3c6yP7+Vz/dd7uIkH1
         X8b0xrmwswyVGXHtmZJajSGzwwk9ooy7qJUkpbpvqjaCLeao+TkBy/Ex/aFtwvt1Oo
         CSb/m9ZQ2Ts6eKxXxUeqCU30F2DzKXRtnj4UcKas=
Date:   Wed, 07 Jun 2023 13:00:20 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, stable@vger.kernel.org,
        sjenning@redhat.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zswap-do-not-shrink-if-cgroup-may-not-zswap.patch removed from -mm tree
Message-Id: <20230607200020.B92FEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap: do not shrink if cgroup may not zswap
has been removed from the -mm tree.  Its filename was
     zswap-do-not-shrink-if-cgroup-may-not-zswap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: do not shrink if cgroup may not zswap
Date: Tue, 30 May 2023 15:24:40 -0700

Before storing a page, zswap first checks if the number of stored pages
exceeds the limit specified by memory.zswap.max, for each cgroup in the
hierarchy.  If this limit is reached or exceeded, then zswap shrinking is
triggered and short-circuits the store attempt.

However, since the zswap's LRU is not memcg-aware, this can create the
following pathological behavior: the cgroup whose zswap limit is 0 will
evict pages from other cgroups continually, without lowering its own zswap
usage.  This means the shrinking will continue until the need for swap
ceases or the pool becomes empty.

As a result of this, we observe a disproportionate amount of zswap
writeback and a perpetually small zswap pool in our experiments, even
though the pool limit is never hit.

More generally, a cgroup might unnecessarily evict pages from other
cgroups before we drive the memcg back below its limit.

This patch fixes the issue by rejecting zswap store attempt without
shrinking the pool when obj_cgroup_may_zswap() returns false.

[akpm@linux-foundation.org: fix return of unintialized value]
[akpm@linux-foundation.org: s/ENOSPC/ENOMEM/]
Link: https://lkml.kernel.org/r/20230530222440.2777700-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20230530232435.3097106-1-nphamcs@gmail.com
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~zswap-do-not-shrink-if-cgroup-may-not-zswap
+++ a/mm/zswap.c
@@ -1174,9 +1174,16 @@ static int zswap_frontswap_store(unsigne
 		goto reject;
 	}
 
+	/*
+	 * XXX: zswap reclaim does not work with cgroups yet. Without a
+	 * cgroup-aware entry LRU, we will push out entries system-wide based on
+	 * local cgroup limits.
+	 */
 	objcg = get_obj_cgroup_from_page(page);
-	if (objcg && !obj_cgroup_may_zswap(objcg))
-		goto shrink;
+	if (objcg && !obj_cgroup_may_zswap(objcg)) {
+		ret = -ENOMEM;
+		goto reject;
+	}
 
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

