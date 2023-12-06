Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7FEC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 16:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442787AbjLFQF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 11:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442821AbjLFQFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 11:05:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B4410E9
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 08:05:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4683BC433C8;
        Wed,  6 Dec 2023 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701878738;
        bh=QJqU+Es9afdYCt6xOdEMzR8qTeBZ+JX/dGrAP5hzjSs=;
        h=Date:To:From:Subject:From;
        b=fEsWejF7nCSh3Is0bcroa2tARxJ7cq4jhipLF8B6TWakPkpGQ2YMmwA9Uex2aoid+
         sTrs17ewXjtUaUVo8FCtLyrUZGKP8MrEHfhTgkizRJhfVorAVdysfgjTYGUcxY9P/J
         CL2xETAJ+JkkNSZQ5ZMw5XqOPrY5yPZLx4gymP84=
Date:   Wed, 06 Dec 2023 08:05:37 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        bagasdotme@gmail.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-shrinking-memcg-aware-fix-2.patch added to mm-unstable branch
Message-Id: <20231206160538.4683BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: make shrinking memcg-aware (fix 2)
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-shrinking-memcg-aware-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-shrinking-memcg-aware-fix-2.patch

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
Subject: zswap: make shrinking memcg-aware (fix 2)
Date: Tue, 5 Dec 2023 19:06:27 -0800

Drop the pool's reference at the end of the writeback step.  Apply on top
of the first fixlet:

https://lore.kernel.org/linux-mm/20231130203522.GC543908@cmpxchg.org/T/#m6ba8efd2205486b1b333a29f5a890563b45c7a7e

Link: https://lkml.kernel.org/r/20231206030627.4155634-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
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
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~zswap-make-shrinking-memcg-aware-fix-2
+++ a/mm/zswap.c
@@ -859,6 +859,7 @@ static void shrink_worker(struct work_st
 resched:
 		cond_resched();
 	} while (!zswap_can_accept());
+	zswap_pool_put(pool);
 }
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
zswap-make-shrinking-memcg-aware-fix.patch
zswap-make-shrinking-memcg-aware-fix-2.patch
mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

