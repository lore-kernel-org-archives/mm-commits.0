Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024DBC7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 20:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjE3UvY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 16:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjE3UvW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 16:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF6133
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 13:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E442602E6
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 20:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6685C433D2;
        Tue, 30 May 2023 20:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685479866;
        bh=p8GNlSJhn21Q7Ixp4ixYQrEnlCn2+tGV4U0JUxLtGWc=;
        h=Date:To:From:Subject:From;
        b=2q4AOh0Olns+9XBTq74Ux+kpl8QpB3fc1PIU4zhWw3+WBn3SCBnqBrD4Ea7ZUvg/V
         2nbGZh4iY8TYRShjd62x+9nOCcepL1m679WnjRjh81tHqA6vR+uLkiUWJD1EpBIp2S
         drifEC4nxc+4rLbCM6jPHXKeArOh/vdN9/Bck6pg=
Date:   Tue, 30 May 2023 13:51:05 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-remove-get-put_swap_device-in-__swap_duplicate.patch added to mm-unstable branch
Message-Id: <20230530205106.B6685C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: remove get/put_swap_device() in __swap_duplicate()
has been added to the -mm mm-unstable branch.  Its filename is
     swap-remove-get-put_swap_device-in-__swap_duplicate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-remove-get-put_swap_device-in-__swap_duplicate.patch

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
Cc: David Hildenbrand <david@redhat.com>
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

migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch
swap-remove-get-put_swap_device-in-__swap_count.patch
swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch
swap-remove-__swp_swapcount.patch
swap-remove-get-put_swap_device-in-__swap_duplicate.patch
swap-comments-get_swap_device-with-usage-rule.patch

