Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACADC4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 20:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjLEUFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 15:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjLEUFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 15:05:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013631A4
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 12:05:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5C3C433C8;
        Tue,  5 Dec 2023 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701806754;
        bh=WkDlGQDvKKK9OFPZA3UdqbDCEF/DNmeYY2OsgG+/tf0=;
        h=Date:To:From:Subject:From;
        b=oT1Apw3yFabBtp/fH5/EI4nk3UWIzRv1Y8kAfGliXB/zvkqsQ1cAWJnUBNJdK4BpC
         DkF5zewIWnCWdwqCRZNPeBtP7xE7JsnJAmqK9qMLlfgskVTfPonut5hc3aUaZAsojE
         ifMq656xFaYC+APxL1B9S6DCxPuHwAm6tz/GGwNY=
Date:   Tue, 05 Dec 2023 12:05:53 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        bagasdotme@gmail.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-shrinking-memcg-aware-fix.patch added to mm-unstable branch
Message-Id: <20231205200554.7B5C3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: make shrinking memcg-aware (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-shrinking-memcg-aware-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-shrinking-memcg-aware-fix.patch

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
Subject: zswap: make shrinking memcg-aware (fix)
Date: Tue, 5 Dec 2023 11:54:19 -0800

Use the correct function for the onlineness check for the memcg selection,
and use mem_cgroup_iter_break() to break the iteration.

Link: https://lkml.kernel.org/r/20231205195419.2563217-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~zswap-make-shrinking-memcg-aware-fix
+++ a/mm/zswap.c
@@ -834,9 +834,9 @@ static void shrink_worker(struct work_st
 			goto resched;
 		}
 
-		if (!mem_cgroup_online(memcg)) {
+		if (!mem_cgroup_tryget_online(memcg)) {
 			/* drop the reference from mem_cgroup_iter() */
-			mem_cgroup_put(memcg);
+			mem_cgroup_iter_break(NULL, memcg);
 			pool->next_shrink = NULL;
 			spin_unlock(&zswap_pools_lock);
 
@@ -985,7 +985,7 @@ static void zswap_pool_destroy(struct zs
 	list_lru_destroy(&pool->list_lru);
 
 	spin_lock(&zswap_pools_lock);
-	mem_cgroup_put(pool->next_shrink);
+	mem_cgroup_iter_break(NULL, pool->next_shrink);
 	pool->next_shrink = NULL;
 	spin_unlock(&zswap_pools_lock);
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
zswap-make-shrinking-memcg-aware-fix.patch
mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

