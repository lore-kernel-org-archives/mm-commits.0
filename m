Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC342C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiEYRg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245711AbiEYRg2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCE39158D
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04FAA617D6
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539F9C385B8;
        Wed, 25 May 2022 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500186;
        bh=TCyrKE8eoNp5FDQG3la/1jHRbPVa/W3we3U54G34H+g=;
        h=Date:To:From:Subject:From;
        b=l53yNba5dXoQHlHAQK+ZQwWAeJFRR14UOrMc9dlURFlhG+xStmfuwcQ9tR6BZG+wP
         RfR5FdGhQMY/+KC9tncALEqt38gjod4BrZifiuBaQwK7Bi8/XvUvV/R8NPTMZW/nbV
         IIRCMr2zdpY96Zll7+fxMrO0OyC3fq3cQz7rMgzU=
Date:   Wed, 25 May 2022 10:36:25 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
        sfr@canb.auug.org.au, rppt@linux.ibm.com, renzhengeek@gmail.com,
        quic_qiancai@quicinc.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix.patch added to mm-unstable branch
Message-Id: <20220525173626.539F9C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-fix-a-potential-infinite-loop-in-start_isolate_page_range-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

