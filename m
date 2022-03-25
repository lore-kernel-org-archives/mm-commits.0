Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67697C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351430AbiCYAhQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354311AbiCYAhQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62438BB0B4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21C1AB826E8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE75C340EC;
        Fri, 25 Mar 2022 00:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168540;
        bh=1yawJDy+PBrkP4bscv+4AH83qT2S0sHM01TA9rgRyek=;
        h=Date:To:From:Subject:From;
        b=DhCRNgPYXo+LIvBlpB7SsBK9FfCaGiqrrfJOPxka2oHU+TtfAt1VIlWCI0K2IsAYx
         No/SluMus0I0jAmRQXf/nNbArPLdSW1+i9nd0PuGfSZYJYCBBxoC8e6uiV4opbLFlR
         0lKPlQ9pqGk94yhsPzZ52g7YzIfCm7YwgRN9IE4I=
Date:   Thu, 24 Mar 2022 17:35:40 -0700
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
Subject: [folded-merged] mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch removed from -mm tree
Message-Id: <20220325003540.CCE75C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch

This patch was dropped because it was folded into mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch

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

mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

