Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1811BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353962AbiCYAgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351430AbiCYAgx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:36:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89186A6E3F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 640B3616AD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1740C340EC;
        Fri, 25 Mar 2022 00:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168518;
        bh=yU7tz2T9NRpSnGvDDpu/skJwEp041uwuG3QZfsDNdDg=;
        h=Date:To:From:Subject:From;
        b=K+FSTfVrgsz8T3PXSmWDRweHi5gWuUlA3UvYDCSN8JRecDp2B8CysT3NjHWm5XL/1
         YC96yJug8wIWcLD/0tu0zn6J7vTd5Xfwo8CuIBfIyi41N4bPStibaSKNtFOHJMJVXt
         xg8wbXSBd+NM+tRJXVsejn1jIZaLls0bBisxLkTQ=
Date:   Thu, 24 Mar 2022 17:35:18 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch removed from -mm tree
Message-Id: <20220325003518.B1740C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slightly-clarify-ksm-logic-in-do_swap_page-fix
has been removed from the -mm tree.  Its filename was
     mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch

This patch was dropped because it was folded into mm-slightly-clarify-ksm-logic-in-do_swap_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slightly-clarify-ksm-logic-in-do_swap_page-fix

fix comment, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-slightly-clarify-ksm-logic-in-do_swap_page-fix
+++ a/mm/memory.c
@@ -3609,11 +3609,11 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	if (swapcache) {
 		/*
-		 * Make sure try_to_free_swap or reuse_swap_page or swapoff did
-		 * not release the swapcache from under us.  The page pin, and
-		 * pte_same test below, are not enough to exclude that.  Even if
-		 * it is still swapcache, we need to check that the page's swap
-		 * has not changed.
+		 * Make sure try_to_free_swap or swapoff did not release the
+		 * swapcache from under us.  The page pin, and pte_same test
+		 * below, are not enough to exclude that.  Even if it is still
+		 * swapcache, we need to check that the page's swap has not
+		 * changed.
 		 */
 		if (unlikely(!PageSwapCache(page) ||
 			     page_private(page) != entry.val))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

