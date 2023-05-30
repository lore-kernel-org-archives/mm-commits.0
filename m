Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F07AC7EE2F
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 20:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjE3UvV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 16:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjE3UvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 16:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9BC11C
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 13:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7C72602E4
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 20:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C099C433D2;
        Tue, 30 May 2023 20:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685479860;
        bh=UinPx5hKi6QqU2TKEuuSv4etyH1plUVH5uLd3CNtZt4=;
        h=Date:To:From:Subject:From;
        b=oTgQQVm8xzGdwD3gSfQ/gJk9KFqb5aLO34iljUIo/AZAg+EY8DScKzPw+tADhrnAs
         OkNXMRJqG7nQjlUBocvhtKoF04RYOKqkeuFjhQt0Uph85h36XqpZ/xCJuy9EOiBeqe
         6IS/l3JEUH94JVgJvVW8GFJRHvB0kMvFkmgOIpnA=
Date:   Tue, 30 May 2023 13:50:59 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-remove-get-put_swap_device-in-__swap_count.patch added to mm-unstable branch
Message-Id: <20230530205100.3C099C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: remove get/put_swap_device() in __swap_count()
has been added to the -mm mm-unstable branch.  Its filename is
     swap-remove-get-put_swap_device-in-__swap_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-remove-get-put_swap_device-in-__swap_count.patch

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
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Chris Li <chrisl@kernel.org>
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

migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch
swap-remove-get-put_swap_device-in-__swap_count.patch
swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch
swap-remove-__swp_swapcount.patch
swap-remove-get-put_swap_device-in-__swap_duplicate.patch
swap-comments-get_swap_device-with-usage-rule.patch

