Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A357C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E58221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781213;
	bh=/i2Y/Aazfea7Zv50E/etBC9vl3UoPf9bBDuPixAtoDw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0LfefG+GwcsbbiX+6w0sberD6AtQthAShgMBL52umkjh4Tym5gAJk+m1R0VqzdacX
	 1UGMWqNtqZkQbK8XNHP9ehHCR/wsOFBgXbJEhvzDtd3RiXc80jOBlEWjjsiCYXPAFY
	 M2ohYJi4zaVXTgHey7kEEH81VmH2/bFC0xuUlZpg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGUM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6D42177B;
        Fri,  7 Aug 2020 06:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781212;
        bh=/i2Y/Aazfea7Zv50E/etBC9vl3UoPf9bBDuPixAtoDw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z6qwmgWIYnx228fShuZVxw7Zc0/tFJac8S1xQO34ZVNm5AwtrufE6koG5UumHSC05
         FZUE4TtCQrbcmVvE6F82OIbO/JxFDQg3QATwMb8WjILtnxMRTQOxE2lmnj//5X2ytp
         LKA23tv9lQZJTXlt3LKgb355YZlL2/gcttF4XCak=
Date:   Thu, 06 Aug 2020 23:20:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org
Subject:  [patch 056/163] mm/swap_slots.c: remove redundant check
 for swap_slot_cache_initialized
Message-ID: <20200807062011.jX4N4N-JP%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/swap_slots.c: remove redundant check for swap_slot_cache_initialized

Because enable_swap_slots_cache can only become true in
enable_swap_slots_cache(), and depends on swap_slot_cache_initialized is
true before.  That means, when enable_swap_slots_cache is true,
swap_slot_cache_initialized is true also.

So the condition:
"swap_slot_cache_enabled && swap_slot_cache_initialized"
can be reduced to "swap_slot_cache_enabled"

And in mathematics:
"!swap_slot_cache_enabled || !swap_slot_cache_initialized"
is equal to "!(swap_slot_cache_enabled && swap_slot_cache_initialized)"

So no functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-4-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swap_slots.c~mm-swap-remove-redundant-check-for-swap_slot_cache_initialized
+++ a/mm/swap_slots.c
@@ -46,8 +46,7 @@ static void __drain_swap_slots_cache(uns
 static void deactivate_swap_slots_cache(void);
 static void reactivate_swap_slots_cache(void);
 
-#define use_swap_slot_cache (swap_slot_cache_active && \
-		swap_slot_cache_enabled && swap_slot_cache_initialized)
+#define use_swap_slot_cache (swap_slot_cache_active && swap_slot_cache_enabled)
 #define SLOTS_CACHE 0x1
 #define SLOTS_CACHE_RET 0x2
 
@@ -94,7 +93,7 @@ static bool check_cache_active(void)
 {
 	long pages;
 
-	if (!swap_slot_cache_enabled || !swap_slot_cache_initialized)
+	if (!swap_slot_cache_enabled)
 		return false;
 
 	pages = get_nr_swap_pages();
_
