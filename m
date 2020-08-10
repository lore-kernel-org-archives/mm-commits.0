Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF95C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2FF206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026968;
	bh=JMpyfV1glrTdr/yqJAQz9Qh3/MhF7soHGb96pZ2YOjQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=x9/pTvfySuY9rpWUPb+uRfeJ6GbDWzebxblu3qr2972jq5wAnRF5BfeOlavCjDjyA
	 idwmL7vT4D7Djv4Zp2Y8U/PspXKKvbprb+O7aZTbKUKi7Tj29qzDl8EaMY7Dz8yGww
	 A/7YnY+9xzqXjoCuUIC1m7cwjNMJ0M7tt+5UlSLw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJCgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85425206C3;
        Mon, 10 Aug 2020 02:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026967;
        bh=JMpyfV1glrTdr/yqJAQz9Qh3/MhF7soHGb96pZ2YOjQ=;
        h=Date:From:To:Subject:From;
        b=m5p7A3rZFvro8zLMX9YZMcilimTVGf8TDM/O01DYmxqtwazo2kZ27fk2/yE+0VaGk
         q6eq/7Y3irc5bg0y+yKOajwXrD7rNWvTewjqhTYnRI1NYp0Pj/4TEQ5bMjhqZjQcS0
         Y+DL+NlrFjQb/+8bch0Cp5tNbKyFgI1X5RgjZ0r4=
Date:   Sun, 09 Aug 2020 19:36:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        tim.c.chen@linux.intel.com
Subject:  [merged] mm-swap-simplify-alloc_swap_slot_cache.patch
 removed from -mm tree
Message-ID: <20200810023607.aOXQHfRFK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: simplify alloc_swap_slot_cache()
has been removed from the -mm tree.  Its filename was
     mm-swap-simplify-alloc_swap_slot_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


