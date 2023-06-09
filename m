Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A430C8300C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjFIXde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjFIXc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5110449C8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E318165CFE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA77C433EF;
        Fri,  9 Jun 2023 23:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353396;
        bh=G2rGXqum6q0f3rbERgyu2X992vl7S4I4HLKioVI4ASk=;
        h=Date:To:From:Subject:From;
        b=X8dA9QpzHLnNDsNO8YtyOLA9OZcIjnWtY+8/jBmNmKmtpd/nnjc/2tbZm6KvwntCj
         G2QTFVe52FXk7lKkyWfmjrKYkX1hea70Xc3vfuVMP/2Rc9DjyOyr7oW6yLLYJJCylH
         ABGJbyk8PnXpeBgTVnc66bx4q9pyJ7rigXj4OIJ8=
Date:   Fri, 09 Jun 2023 16:29:55 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-remove-get-put_swap_device-in-__swap_duplicate.patch removed from -mm tree
Message-Id: <20230609232956.3DA77C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: remove get/put_swap_device() in __swap_duplicate()
has been removed from the -mm tree.  Its filename was
     swap-remove-get-put_swap_device-in-__swap_duplicate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap: remove get/put_swap_device() in __swap_duplicate()
Date: Mon, 29 May 2023 14:13:54 +0800

__swap_duplicate() is called by

- swap_shmem_alloc(): the folio in swap cache is locked.

- copy_nonpresent_pte() -> swap_duplicate() and try_to_unmap_one() ->
  swap_duplicate(): the page table lock is held.

- __read_swap_cache_async() -> swapcache_prepare(): enclosed with
  get/put_swap_device() in __read_swap_cache_async() already.

So, it's safe to remove get/put_swap_device() in __swap_duplicate().

Link: https://lkml.kernel.org/r/20230529061355.125791-5-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

 mm/swapfile.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/swapfile.c~swap-remove-get-put_swap_device-in-__swap_duplicate
+++ a/mm/swapfile.c
@@ -3265,9 +3265,7 @@ static int __swap_duplicate(swp_entry_t
 	unsigned char has_cache;
 	int err;
 
-	p = get_swap_device(entry);
-	if (!p)
-		return -EINVAL;
+	p = swp_swap_info(entry);
 
 	offset = swp_offset(entry);
 	ci = lock_cluster_or_swap_info(p, offset);
@@ -3314,7 +3312,6 @@ static int __swap_duplicate(swp_entry_t
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
-	put_swap_device(p);
 	return err;
 }
 
_

Patches currently in -mm which might be from ying.huang@intel.com are


