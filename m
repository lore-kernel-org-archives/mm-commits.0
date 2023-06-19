Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3ADEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjFSXXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94433AF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74F3560FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3487C433C0;
        Mon, 19 Jun 2023 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216903;
        bh=SY/epvO+GjIGV9V8kEx17NySkFQuwsKB0PzvC5Ysql4=;
        h=Date:To:From:Subject:From;
        b=X2zlDBrt2K/YWOfKnqU9oswoYfTFORKQ5/nJBx2y1FybZOD7P2YzjCNmhKXfPfMKC
         JJ7J5LlrbVYKJGAZxWZO8w3Dis/qm0Zdp2L5XMOtgv/+wLjJyis7FR3Ww2GIRCTrhP
         Fr2Viq26PWGzqRYy9yB9pjcmh0nO+JmhhYoVxgnQ=
Date:   Mon, 19 Jun 2023 16:21:43 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-retry-if-pte_offset_map-fails.patch removed from -mm tree
Message-Id: <20230619232143.C3487C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: retry if pte_offset_map() fails
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-retry-if-pte_offset_map-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/userfaultfd: retry if pte_offset_map() fails
Date: Thu, 8 Jun 2023 18:24:38 -0700 (PDT)

Instead of worrying whether the pmd is stable, userfaultfd_must_wait()
call pte_offset_map() as before, but go back to try again if that fails.

Risk of endless loop?  It already broke out if pmd_none(), !pmd_present()
or pmd_trans_huge(), and pte_offset_map() would have cleared pmd_bad():
which leaves pmd_devmap().  Presumably pmd_devmap() is inappropriate in a
vma subject to userfaultfd (it would have been mistreated before), but add
a check just to avoid all possibility of endless loop there.

Link: https://lkml.kernel.org/r/54423f-3dff-fd8d-614a-632727cc4cfb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-retry-if-pte_offset_map-fails
+++ a/fs/userfaultfd.c
@@ -349,12 +349,13 @@ static inline bool userfaultfd_must_wait
 	if (!pud_present(*pud))
 		goto out;
 	pmd = pmd_offset(pud, address);
+again:
 	_pmd = pmdp_get_lockless(pmd);
 	if (pmd_none(_pmd))
 		goto out;
 
 	ret = false;
-	if (!pmd_present(_pmd))
+	if (!pmd_present(_pmd) || pmd_devmap(_pmd))
 		goto out;
 
 	if (pmd_trans_huge(_pmd)) {
@@ -363,11 +364,11 @@ static inline bool userfaultfd_must_wait
 		goto out;
 	}
 
-	/*
-	 * the pmd is stable (as in !pmd_trans_unstable) so we can re-read it
-	 * and use the standard pte_offset_map() instead of parsing _pmd.
-	 */
 	pte = pte_offset_map(pmd, address);
+	if (!pte) {
+		ret = true;
+		goto again;
+	}
 	/*
 	 * Lockless access: we're in a wait_event so it's ok if it
 	 * changes under us.  PTE markers should be handled the same as none
_

Patches currently in -mm which might be from hughd@google.com are


