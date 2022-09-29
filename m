Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20022C07E9D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiI2EDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiI2EDP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:03:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8D7125DBF
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F516200D
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4ADC433B5;
        Thu, 29 Sep 2022 04:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424193;
        bh=ajDrIRF62XNeEy6fSm6Rof33YMexTxjlJyY5Gq0t+/Y=;
        h=Date:To:From:Subject:From;
        b=Xy2TPzTwnkLiSQ5ogGbZmnFo+VvaBhuHfbR78JLqpDXoU9lvWWGPsWxPsy/G/YYDE
         +WJJjPfpOtR+RajqxA3i5ZlEtV5xs14qZOTg5fmyePoD1Sh1noawGnpxI3Me9Hh6tT
         lECIcZubiYjzxVvMr6u9M8+ozvOBPxIhYY9U5nNU=
Date:   Wed, 28 Sep 2022 21:03:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-reduce-size-of-memcg-vmstats-structures-fix.patch removed from -mm tree
Message-Id: <20220929040312.DC4ADC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg-reduce-size-of-memcg-vmstats-structures-fix
has been removed from the -mm tree.  Its filename was
     memcg-reduce-size-of-memcg-vmstats-structures-fix.patch

This patch was dropped because it was folded into memcg-reduce-size-of-memcg-vmstats-structures.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-reduce-size-of-memcg-vmstats-structures-fix
Date: Thu Sep  8 03:35:53 PM PDT 2022

fix memcg_events_local() array index, per Shakeel

Link: https://lkml.kernel.org/r/CALvZod70Mvxr+Nzb6k0yiU2RFYjTD=0NFhKK-Eyp+5ejd1PSFw@mail.gmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-reduce-size-of-memcg-vmstats-structures-fix
+++ a/mm/memcontrol.c
@@ -921,7 +921,7 @@ static unsigned long memcg_events_local(
 		return 0;
 
 	for_each_possible_cpu(cpu)
-		x += per_cpu(memcg->vmstats_percpu->events[event], cpu);
+		x += per_cpu(memcg->vmstats_percpu->events[index], cpu);
 	return x;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-reduce-size-of-memcg-vmstats-structures.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

