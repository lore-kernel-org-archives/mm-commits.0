Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4CEC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245747AbiEYRp2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245188AbiEYRpY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E489D06A
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1FF3617B1
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1990DC385B8;
        Wed, 25 May 2022 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500723;
        bh=6wN5iXH3VfKC/joDNOU4O/+sJQ9X+8gRNpS/d2AeLh8=;
        h=Date:To:From:Subject:From;
        b=ENdB0SMd1VWL+RBEkLS2J1bvluVUBQtXWAu+oQoXm3fxEfaCCdLKBDVrUyppiYTOd
         xCExntKU9QvG8l6B189h0wBOt6M0tZ1iV07OHmw+VJfmaAFJX3SxXGvFDYTb/peC19
         eFRTerYzpfAN617sY+IMrL6szcF1YlB9vAOiVrj8=
Date:   Wed, 25 May 2022 10:45:22 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
        sfr@canb.auug.org.au, rppt@linux.ibm.com, renzhengeek@gmail.com,
        quic_qiancai@quicinc.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix.patch removed from -mm tree
Message-Id: <20220525174523.1990DC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix.patch

This patch was dropped because it was folded into mm-fix-a-potential-infinite-loop-in-start_isolate_page_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix
Date: Wed May 25 10:34:12 AM PDT 2022

suppressmin() warning

Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix
+++ a/mm/page_alloc.c
@@ -1123,7 +1123,9 @@ void split_free_page(struct page *free_p
 	     pfn < free_page_pfn + (1UL << order);) {
 		int mt = get_pfnblock_migratetype(pfn_to_page(pfn), pfn);
 
-		free_page_order = min(pfn ? __ffs(pfn) : order, __fls(split_pfn_offset));
+		free_page_order = min_t(int,
+					pfn ? __ffs(pfn) : order,
+					__fls(split_pfn_offset));
 		__free_one_page(pfn_to_page(pfn), pfn, zone, free_page_order,
 				mt, FPI_NONE);
 		pfn += 1UL << free_page_order;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-a-potential-infinite-loop-in-start_isolate_page_range.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

