Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA59BC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Mar 2022 23:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiCNXsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Mar 2022 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiCNXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2022 19:48:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E1D3DDF8
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 16:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31D87B81094
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 23:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA57C340E9;
        Mon, 14 Mar 2022 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647301653;
        bh=9ZKTFhdRpNJ7pIzYqqf+maioE3VBUydL4QpjTl6rjes=;
        h=Date:To:From:Subject:From;
        b=v6SnwpKDHuAV9fVI5rqehO8oxci+WrDOYSnFhsr/Kv2vAz1NwJlpMKKut6kNPw2UW
         ENSLn+377Xm5YMBOkmss/JKlOYyWE+6QiltOosb/QzUXDKgNvkXYx9GGeDdwYR4nnY
         n8ytBe00DJkno9ruzAsLcvvA5zxLoDJ7WSaZ5L5s=
Date:   Mon, 14 Mar 2022 16:47:33 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com, bp@alien8.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch added to -mm tree
Message-Id: <20220314234733.DEA57C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failurec-fix-race-with-changing-page-compound-again-fix
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch

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

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
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

