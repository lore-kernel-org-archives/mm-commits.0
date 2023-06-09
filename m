Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB93CC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjFIXdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjFIXc1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F1249C5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72E2C65CD2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A38C433EF;
        Fri,  9 Jun 2023 23:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353392;
        bh=Ue3O5o0WQ8EmAFhrg90V4Yriqx09anwf9iDRmrVy3EE=;
        h=Date:To:From:Subject:From;
        b=GNlz8fdqUUn7jc9acdl3c0AlRLqQHM7kdWHocM2hoZTfDGvCJeY8RWrXA/topkmgO
         ZWlZVhuqOcvkUKfGJu9Y/sx2Opl604HWvOi9ks56JJA0cxVbpsSg60XDXBNye2s+G4
         iltG6wz7ktFu9A2Jr/kPMXt4CtRnhjxomRL2VblI=
Date:   Fri, 09 Jun 2023 16:29:52 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-remove-get-put_swap_device-in-__swap_count.patch removed from -mm tree
Message-Id: <20230609232952.C6A38C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: remove get/put_swap_device() in __swap_count()
has been removed from the -mm tree.  Its filename was
     swap-remove-get-put_swap_device-in-__swap_count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap: remove get/put_swap_device() in __swap_count()
Date: Mon, 29 May 2023 14:13:51 +0800

Patch series "swap: cleanup get/put_swap_device() usage", v3.

The general rule to use a swap entry is as follows.

When we get a swap entry, if there aren't some other ways to prevent
swapoff, such as the folio in swap cache is locked, page table lock is
held, etc., the swap entry may become invalid because of swapoff.  Then,
we need to enclose all swap related functions with get_swap_device() and
put_swap_device(), unless the swap functions call get/put_swap_device() by
themselves.

Based on the above rule, all get/put_swap_device() usage are checked and
cleaned up if necessary.


This patch (of 5):

get/put_swap_device() are added to __swap_count() in commit
eb085574a752 ("mm, swap: fix race between swapoff and some swap
operations").  Later, in commit 2799e77529c2 ("swap: fix
do_swap_page() race with swapoff"), get/put_swap_device() are added to
do_swap_page().  And they enclose the only call site of
__swap_count().  So, it's safe to remove get/put_swap_device() in
__swap_count() now.

Link: https://lkml.kernel.org/r/20230529061355.125791-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20230529061355.125791-2-ying.huang@intel.com
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

 mm/swapfile.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/swapfile.c~swap-remove-get-put_swap_device-in-__swap_count
+++ a/mm/swapfile.c
@@ -1433,16 +1433,10 @@ void swapcache_free_entries(swp_entry_t
 
 int __swap_count(swp_entry_t entry)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = swp_swap_info(entry);
 	pgoff_t offset = swp_offset(entry);
-	int count = 0;
 
-	si = get_swap_device(entry);
-	if (si) {
-		count = swap_count(si->swap_map[offset]);
-		put_swap_device(si);
-	}
-	return count;
+	return swap_count(si->swap_map[offset]);
 }
 
 /*
_

Patches currently in -mm which might be from ying.huang@intel.com are


