Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAC0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiCVTNi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCVTNi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:13:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5EB8F9B3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6947B61655
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35D5C340EC;
        Tue, 22 Mar 2022 19:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976329;
        bh=hEy2qQZCAqrxRa7+7gUzKLLm1M69fIUxzCMm6cdiMyo=;
        h=Date:To:From:Subject:From;
        b=o8tv9BzcIze8VPxd7WRuGmwuBHLrcs5M4XKCjMQgNDLj50NVA5334N+QTXgr6u+Bq
         SjtsRFsXC5L5fDIWgkPieO6En4gMp0oxve3EXdOg7oCl2oRt1OmPkB6m9yb4a8/xC0
         oNSpi4fCHlPSuwZvwb/k2QdNNj+o+0VphufWo9Hg=
Date:   Tue, 22 Mar 2022 12:12:09 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com, bp@alien8.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch removed from -mm tree
Message-Id: <20220322191209.C35D5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failurec-fix-race-with-changing-page-compound-again-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch

This patch was dropped because it was folded into mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failurec-fix-race-with-changing-page-compound-again-fix

s@/**@/*@, per Naoya Horiguchi

Cc: Borislav Petkov <bp@alien8.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-compound-again-fix
+++ a/mm/memory-failure.c
@@ -1534,7 +1534,7 @@ static int memory_failure_hugetlb(unsign
 
 	lock_page(head);
 
-	/**
+	/*
 	 * The page could have changed compound pages due to race window.
 	 * If this happens just bail out.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

