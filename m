Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DA0C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 178AB206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026971;
	bh=tQL53iN9IxAd/kvujLgXuTjzpUF5sHzfM8d6IYlasaw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fJ6z6+3gAUEv9r41CXBfRdfgVUMsZh7Uk6HKZUCC2nc+W1ttBPI01Yuk2rCFmafWa
	 0hOIzA8AjYEIrn6K30E1gvDqLRtZR2TbLdgJfojhQCJkSK4YKK1r+XvVBGLYsD4okM
	 gwsYt5Kvtn2GaPKjh6b4LUOf8wFDPNKJvElz0cYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHJCgK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8832065D;
        Mon, 10 Aug 2020 02:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026969;
        bh=tQL53iN9IxAd/kvujLgXuTjzpUF5sHzfM8d6IYlasaw=;
        h=Date:From:To:Subject:From;
        b=ftwES5ItVIlB70uOqD3yNBhma+czlbfYOvUBkUkjwrZoSWtKEOtTPjVGdhEidFYZN
         tEfZgkOHK+sbyyJPz7LVW/WIivNoitTRK+KBu+bA8QTnl8mSVPXHcY7Kj8njcGpy7G
         MUyE8qUwknpOw9F6+r8S3SwGDLW9kb/wVggBSVM0=
Date:   Sun, 09 Aug 2020 19:36:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        tim.c.chen@linux.intel.com
Subject:  [merged] mm-swap-simplify-enable_swap_slots_cache.patch
 removed from -mm tree
Message-ID: <20200810023609.mrXAo9Mkr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: simplify enable_swap_slots_cache()
has been removed from the -mm tree.  Its filename was
     mm-swap-simplify-enable_swap_slots_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/swap_slots.c: simplify enable_swap_slots_cache()

Whether swap_slot_cache_initialized is true or false,
__reenable_swap_slots_cache() is always called.  To make this meaning
clear, leave only one call to __reenable_swap_slots_cache().  This also
make it clearer what extra needs be done when swap_slot_cache_initialized
is false.

No functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-3-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/swap_slots.c~mm-swap-simplify-enable_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -240,21 +240,19 @@ static int free_slot_cache(unsigned int
 
 int enable_swap_slots_cache(void)
 {
-	int ret = 0;
-
 	mutex_lock(&swap_slots_cache_enable_mutex);
-	if (swap_slot_cache_initialized) {
-		__reenable_swap_slots_cache();
-		goto out_unlock;
-	}
+	if (!swap_slot_cache_initialized) {
+		int ret;
 
-	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
-				alloc_swap_slot_cache, free_slot_cache);
-	if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
-			       "without swap slots cache.\n", __func__))
-		goto out_unlock;
+		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
+					alloc_swap_slot_cache, free_slot_cache);
+		if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
+				       "without swap slots cache.\n", __func__))
+			goto out_unlock;
+
+		swap_slot_cache_initialized = true;
+	}
 
-	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
 	mutex_unlock(&swap_slots_cache_enable_mutex);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


