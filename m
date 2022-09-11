Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597C9ECAAD3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIKXdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIKXdb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:33:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C752656E
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE178B80BFA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AE8C433B5;
        Sun, 11 Sep 2022 23:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662939207;
        bh=Efttj3veJjkb7k0UlZFdpL9uZpdGFnC2EoMCP8cVAPg=;
        h=Date:To:From:Subject:From;
        b=azw772SOH2HQDKItURPwL8ijddHkEskcvRrDT4bQYpZtsfZnsg/Ns2cUmSBBtpUbZ
         LXzBHQpg9NFvBUDn6NdTGIbEWG2NgyHcWF5rMBOQ5g7AcKws+xiR7l8POPtfiZGFNk
         A+PCrmfoUvyb8g9lxk7KSkuXtpwEzu0kT6nnvz9M=
Date:   Sun, 11 Sep 2022 16:33:26 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, ziy@nvidia.com,
        willy@infradead.org, vbabka@suse.cz, tsbogend@alpha.franken.de,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        mhocko@suse.com, mattst88@gmail.com, lkp@intel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, dan.carpenter@oracle.com, ckennelly@google.com,
        chris@zankel.net, axelrasmussen@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, arnd@arndb.de, alex.shi@linux.alibaba.com,
        aarcange@redhat.com, jrdr.linux@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch removed from -mm tree
Message-Id: <20220911233327.57AE8C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: avoid possible memory leak in failure path
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch

------------------------------------------------------
From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Subject: mm/khugepaged: avoid possible memory leak in failure path
Date: Wed, 13 Jul 2022 08:11:09 +0530

smatch warnings:
mm/khugepaged.c:2409 madvise_collapse() warn: possible memory
leak of 'cc'

Avoiding possible memory leak.

Link: https://lkml.kernel.org/r/20220713024109.62810-1-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix
+++ a/mm/khugepaged.c
@@ -2404,12 +2404,6 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-	cc->is_khugepaged = false;
-	cc->last_target_node = NUMA_NO_NODE;
-
 	*prev = vma;
 
 	/* TODO: Support file/shmem */
@@ -2422,6 +2416,12 @@ int madvise_collapse(struct vm_area_stru
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return -EINVAL;
 
+	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+	cc->is_khugepaged = false;
+	cc->last_target_node = NUMA_NO_NODE;
+
 	mmgrab(mm);
 	lru_add_drain_all();
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch

