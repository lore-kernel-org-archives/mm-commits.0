Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CCDC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiCVTNR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiCVTNQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:13:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D0A8F9B3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BCA0B81D5F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C01DC340EC;
        Tue, 22 Mar 2022 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976306;
        bh=oBE6BkuOjC+gsVX8y8WzWJh75KZbpOBqf6XFDmy/pyE=;
        h=Date:To:From:Subject:From;
        b=PgmiC3aD+WKprtcRDe/qlrdDWgy4fbhGeADXNtwbX9qfbxtGGBtpzLx92dpkIGaqU
         40TN4Hb1i+KpRZig65uv7XZw8mSoLGjHisZQ6IGYW9J1yts//XtBpkz/ahZS9rgZ3W
         QeHC8/icFdxRXGAtIxU8G7bVgxT/KCkaUXFNpqtY=
Date:   Tue, 22 Mar 2022 12:11:45 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch removed from -mm tree
Message-Id: <20220322191146.2C01DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch

This patch was dropped because it was folded into mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix

export is_free_buddy_page() to modules

ERROR: modpost: "is_free_buddy_page" [mm/hwpoison-inject.ko] undefined!

Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
+++ a/mm/page_alloc.c
@@ -9408,6 +9408,7 @@ bool is_free_buddy_page(struct page *pag
 
 	return order < MAX_ORDER;
 }
+EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
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

