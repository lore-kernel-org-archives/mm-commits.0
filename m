Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E96C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbjFIXde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjFIXcf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4D349CC
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 101E261782
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E5EC433D2;
        Fri,  9 Jun 2023 23:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353397;
        bh=zEDbwuFHuO0WDf2ZDdgO5ozAI3Ur/NKhuH3ZZBpgMuo=;
        h=Date:To:From:Subject:From;
        b=tmBVfsu59/GX94ZPNaSno7L2zXz/B/VPjkB8Ys8E7OLaaDoGCpXomHR8LgSL/p3Eu
         yNJ8O7YHAQ14NCJxPnUPhfAjOUnwXwS8dHEQN5EtGSmuiOM4Xft7J63ZZxQ24hsnRT
         +rXbLolUKBuKuRE7To5OgIu0N28hAIn6YzMxYhvA=
Date:   Fri, 09 Jun 2023 16:29:56 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-comments-get_swap_device-with-usage-rule.patch removed from -mm tree
Message-Id: <20230609232957.64E5EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: comments get_swap_device() with usage rule
has been removed from the -mm tree.  Its filename was
     swap-comments-get_swap_device-with-usage-rule.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap: comments get_swap_device() with usage rule
Date: Mon, 29 May 2023 14:13:55 +0800

The general rule to use a swap entry is as follows.

When we get a swap entry, if there aren't some other ways to prevent
swapoff, such as the folio in swap cache is locked, page table lock is
held, etc., the swap entry may become invalid because of swapoff.
Then, we need to enclose all swap related functions with
get_swap_device() and put_swap_device(), unless the swap functions
call get/put_swap_device() by themselves.

Add the rule as comments of get_swap_device().

Link: https://lkml.kernel.org/r/20230529061355.125791-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chris Li (Google) <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~swap-comments-get_swap_device-with-usage-rule
+++ a/mm/swapfile.c
@@ -1220,6 +1220,13 @@ static unsigned char __swap_entry_free_l
 }
 
 /*
+ * When we get a swap entry, if there aren't some other ways to
+ * prevent swapoff, such as the folio in swap cache is locked, page
+ * table lock is held, etc., the swap entry may become invalid because
+ * of swapoff.  Then, we need to enclose all swap related functions
+ * with get_swap_device() and put_swap_device(), unless the swap
+ * functions call get/put_swap_device() by themselves.
+ *
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
@@ -1228,9 +1235,8 @@ static unsigned char __swap_entry_free_l
  * Notice that swapoff or swapoff+swapon can still happen before the
  * percpu_ref_tryget_live() in get_swap_device() or after the
  * percpu_ref_put() in put_swap_device() if there isn't any other way
- * to prevent swapoff, such as page lock, page table lock, etc.  The
- * caller must be prepared for that.  For example, the following
- * situation is possible.
+ * to prevent swapoff.  The caller must be prepared for that.  For
+ * example, the following situation is possible.
  *
  *   CPU1				CPU2
  *   do_swap_page()
_

Patches currently in -mm which might be from ying.huang@intel.com are


