Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C447C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiCVTPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiCVTPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:15:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54EEB87D
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7032E61655
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FAAC340EC;
        Tue, 22 Mar 2022 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976418;
        bh=TwEuBa+Cg8ufRQbIJU01I4O4rK8ovsoDAu2g1CA5UxA=;
        h=Date:To:From:Subject:From;
        b=C4cK1nBTYrsbKCakYxbjkqzgMCDFPMAz347UFvrxMzge6uEg/xCk0O/86Ysf3Sme3
         /UzvQxJmxNi0U+kCPuIjiwkEOCxO/PB8XYmCr6vZOUWdC7b5hbU/Ei9E6MA1s1iOgj
         ji2hyK8Ef4L4YPsjhMkGNY7Y89o7M6BVXyNT2tZY=
Date:   Tue, 22 Mar 2022 12:13:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, kirill@shutemov.name, hch@infradead.org,
        dhowells@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-export-pageheadhuge-fix.patch removed from -mm tree
Message-Id: <20220322191338.C6FAAC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-export-pageheadhuge-fix
has been removed from the -mm tree.  Its filename was
     mm-export-pageheadhuge-fix.patch

This patch was dropped because it was folded into mm-export-pageheadhuge.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-export-pageheadhuge-fix

s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/, per Christoph

Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-export-pageheadhuge-fix
+++ a/mm/hugetlb.c
@@ -1855,7 +1855,7 @@ int PageHeadHuge(struct page *page_head)
 
 	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
-EXPORT_SYMBOL(PageHeadHuge);
+EXPORT_SYMBOL_GPL(PageHeadHuge);
 
 /*
  * Find and lock address space (mapping) in write mode.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-export-pageheadhuge.patch
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

