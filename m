Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5DBC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  8 Mar 2022 00:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbiCHAw3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiCHAw3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 19:52:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32262AC4A
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 16:51:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BDF3B8172A
        for <mm-commits@vger.kernel.org>; Tue,  8 Mar 2022 00:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6FDC340E9;
        Tue,  8 Mar 2022 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646700691;
        bh=vNdjB5pD9ZSG/WnOzmVD2yleCuy8tp3zo/cShj45itw=;
        h=Date:To:From:Subject:From;
        b=k+apGDG04Vun+r1RLXTeJZxRQNqgrES25t630bw7frI76sNSZVepofpbfpGrQySly
         3ieU0/dkyhuQJyx/UC9Xrg+ngrG6gvqJPtNgokqyOIgM1n/2k7ZFcmO+e/7MypDHrE
         aTcK+1yWA7Ilpi5CWVqsXPe/gKMDWCMzRKiB5DZU=
Date:   Mon, 07 Mar 2022 16:51:30 -0800
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, roman.gushchin@linux.dev,
        rientjes@google.com, riel@surriel.com, peterx@redhat.com,
        oleg@redhat.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        mhocko@kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, ddutile@redhat.com,
        david@redhat.com, aarcange@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch added to -mm tree
Message-Id: <20220308005131.2B6FDC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix
has been added to the -mm tree.  Its filename is
     mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch

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
Subject: mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix

simplificatoin, per Yang Shi

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix
+++ a/mm/huge_memory.c
@@ -2151,12 +2151,10 @@ void __split_huge_pmd(struct vm_area_str
 			goto out;
 	}
 
-	if (pmd_trans_huge(*pmd)) {
-		if (!folio)
-			folio = page_folio(pmd_page(*pmd));
-	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
-		goto out;
-	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
+	    is_pmd_migration_entry(*pmd))
+		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
+
 out:
 	spin_unlock(ptl);
 	/*
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
linux-next-git-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

