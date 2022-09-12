Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498B1ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiILDcG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiILDaD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC6F0E
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EBE5B80C74
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D1C433D7;
        Mon, 12 Sep 2022 03:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953368;
        bh=lAWg8rQnJFzgjjMT45YUSEgne43keP716eexLF+8NTg=;
        h=Date:To:From:Subject:From;
        b=oN5tw6hCCux96VlG7PcmPzPybsFAckFNm2pxZBwZgyQFdd1jK9iFk2R8AIWqaC4iv
         Q7HmrB7MCXHwaDP1HBh3hLEkJY6bJorUIkJ25i72zfvuH+YDAJeItrHwvoh+05VFSh
         9o/ic6Pthx1jw6xr5nUhWPA9/FDVYBWcx1QCAak8=
Date:   Sun, 11 Sep 2022 20:29:27 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-kill-procs-if-unmap-fails.patch removed from -mm tree
Message-Id: <20220912032928.337D1C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: kill procs if unmap fails
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-kill-procs-if-unmap-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: kill procs if unmap fails
Date: Thu, 18 Aug 2022 21:00:15 +0800

If try_to_unmap() fails, the hwpoisoned page still resides in the address
space of some processes.  We should kill these processes or the hwpoisoned
page might be consumed later.  collect_procs() is always called to collect
relevant processes now so they can be killed later if unmap fails.

[linmiaohe@huawei.com: v2]
  Link: https://lkml.kernel.org/r/20220823032346.4260-6-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220818130016.45313-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-kill-procs-if-unmap-fails
+++ a/mm/memory-failure.c
@@ -1397,7 +1397,7 @@ static bool hwpoison_user_mappings(struc
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
-	int kill = 1, forcekill;
+	int forcekill;
 	bool mlocked = PageMlocked(hpage);
 
 	/*
@@ -1438,7 +1438,6 @@ static bool hwpoison_user_mappings(struc
 		if (page_mkclean(hpage)) {
 			SetPageDirty(hpage);
 		} else {
-			kill = 0;
 			ttu |= TTU_IGNORE_HWPOISON;
 			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
 				pfn);
@@ -1449,12 +1448,8 @@ static bool hwpoison_user_mappings(struc
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
 	 * because ttu takes the rmap data structures down.
-	 *
-	 * Error handling: We ignore errors here because
-	 * there's nothing that can be done.
 	 */
-	if (kill)
-		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
 	if (PageHuge(hpage) && !PageAnon(hpage)) {
 		/*
@@ -1496,7 +1491,8 @@ static bool hwpoison_user_mappings(struc
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL);
+	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL) ||
+		    !unmap_success;
 	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
 
 	return unmap_success;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

