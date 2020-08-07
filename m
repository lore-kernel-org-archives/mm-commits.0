Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B25C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F142177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781207;
	bh=lQafCK3Id4C0kM1ht3TIXdfhV0GFqWjodpCMHx6vd+Q=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LDvFu1u3h3cgeQvGrO22QEyUq3cKDlb4h9O4LsYkHjI7jDSdcgc5R6U8oPFBQqsIN
	 W0rYLOGpL//OBm287P/kHoQp5NhWm2jDnnt+kyPlJNtp+qwjS1s4bu0TskjbuDEQun
	 j180Ge76tG9t7FTMfXSy11zJvUUE8nrQ79Fmklkc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGUG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD061221E5;
        Fri,  7 Aug 2020 06:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781206;
        bh=lQafCK3Id4C0kM1ht3TIXdfhV0GFqWjodpCMHx6vd+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xgxm6Rb+fJdEBodRlEfynP8zaweNw+PEFCMPmClZ8XvOkFqSa3z+Ts38lsb0WEHiZ
         GJMI92mnLmaSbtyEbSVNfX7FEH6kG+wRjnpYHzCBCja5R6v7+iQM7HjZY0VleaG6pM
         KaHC7J5I72f9bTLpRhfXT5nh6/VOlLRCdSDfSss8=
Date:   Thu, 06 Aug 2020 23:20:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org
Subject:  [patch 054/163] mm/swap_slots.c: simplify
 alloc_swap_slot_cache()
Message-ID: <20200807062005.O6oLXIaBo%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/swap_slots.c: simplify alloc_swap_slot_cache()

Patch series "clean up some functions in mm/swap_slots.c".

When I studied the code of mm/swap_slots.c, I found some places can be
improved.


This patch (of 3):

Both "slots" and "slots_ret" are only need to be freed when cache already
allocated.  Make them closer, seems more clear.

No functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-1-thunder.leizhen@huawei.com
Link: http://lkml.kernel.org/r/20200430061143.450-2-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/swap_slots.c~mm-swap-simplify-alloc_swap_slot_cache
+++ a/mm/swap_slots.c
@@ -136,9 +136,16 @@ static int alloc_swap_slot_cache(unsigne
 
 	mutex_lock(&swap_slots_cache_mutex);
 	cache = &per_cpu(swp_slots, cpu);
-	if (cache->slots || cache->slots_ret)
+	if (cache->slots || cache->slots_ret) {
 		/* cache already allocated */
-		goto out;
+		mutex_unlock(&swap_slots_cache_mutex);
+
+		kvfree(slots);
+		kvfree(slots_ret);
+
+		return 0;
+	}
+
 	if (!cache->lock_initialized) {
 		mutex_init(&cache->alloc_lock);
 		spin_lock_init(&cache->free_lock);
@@ -155,15 +162,8 @@ static int alloc_swap_slot_cache(unsigne
 	 */
 	mb();
 	cache->slots = slots;
-	slots = NULL;
 	cache->slots_ret = slots_ret;
-	slots_ret = NULL;
-out:
 	mutex_unlock(&swap_slots_cache_mutex);
-	if (slots)
-		kvfree(slots);
-	if (slots_ret)
-		kvfree(slots_ret);
 	return 0;
 }
 
_
