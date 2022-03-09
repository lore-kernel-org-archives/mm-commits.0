Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDB3C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 20:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiCIUvx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 15:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbiCIUvv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 15:51:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C274570CDA
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 12:50:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55141B823D3
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 20:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8187C340E8;
        Wed,  9 Mar 2022 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646859049;
        bh=tFqvzDBiyQCSbYw0PfCwFJQa1FbQ+jNgBeevzcY0ON8=;
        h=Date:To:From:Subject:From;
        b=vrNLO/7RPGPmiK+ER8eQ3eam4VhkrHzDUdWmVbgL/XbR7YYiKHX3udlulmASq2HvH
         Eucae0WGe2Hn/7+Jdkt5/xDtNo6X5KJrL6FSCFm91KMJAbcZgz4HKscnt1Kxvf/m47
         wA5P6BZhgxIYya+nueSOti9XR9gpoVznIx/G/Bwo=
Date:   Wed, 09 Mar 2022 12:50:48 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch added to -mm tree
Message-Id: <20220309205048.E8187C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slightly-clarify-ksm-logic-in-do_swap_page-fix
has been added to the -mm tree.  Its filename is
     mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

