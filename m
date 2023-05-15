Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D00C7EE24
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245236AbjEOTf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245223AbjEOTfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:35:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316A6E72B
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBFBA631DB
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A22FC433D2;
        Mon, 15 May 2023 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684179348;
        bh=ZVm993mv6dSCkmo8wUQcymm9RJrBblySlXql4u5d1oA=;
        h=Date:To:From:Subject:From;
        b=2DWe23h/RWWAnFZhFLqN1l23wzipE4lD3Ik08zflGUnvJgoOnK6j7ZtfJqU+aLExg
         rG+uFPws0TQuzBTSfPybB+XYqVLKB8WK6guQH2X/QTe8I1c11DBIa18PY54MoX6JV9
         SWoZLXySJVudR6rQYZeF2j+8wT2hfOiB57nG+EuA=
Date:   Mon, 15 May 2023 12:35:47 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch added to mm-unstable branch
Message-Id: <20230515193548.1A22FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "Revert "mm/compaction: fix set skip in fast_find_migrateblock""
has been added to the -mm mm-unstable branch.  Its filename is
     revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: Revert "Revert "mm/compaction: fix set skip in fast_find_migrateblock""
Date: Mon, 15 May 2023 12:33:44 +0100

This reverts commit 95e7a450b819 ("Revert "mm/compaction: fix set skip in
fast_find_migrateblock"").

Commit 7efc3b726103 ("mm/compaction: fix set skip in
fast_find_migrateblock") was reverted due to bug reports about khugepaged
consuming large amounts of CPU without making progress.  The underlying
bug was partially fixed by commit cfccd2e63e7e ("mm, compaction: finish
pageblocks on complete migration failure") but it only mitigated the
problem and Vlastimil Babka pointing out the same issue could
theoretically happen to kcompactd.

As pageblocks containing pages that fail to migrate should now be forcibly
rescanned to set the skip hint if skip hints are used,
fast_find_migrateblock() should no longer loop on a small subset of
pageblocks for prolonged periods of time.  Revert the revert so
fast_find_migrateblock() is effective again.

Using the mmtests config workload-usemem-stress-numa-compact, the number
of unique ranges scanned was analysed for both kcompactd and !kcompactd
activity.

6.4.0-rc1-vanilla
kcompactd
      7 range=(0x10d600~0x10d800)
      7 range=(0x110c00~0x110e00)
      7 range=(0x110e00~0x111000)
      7 range=(0x111800~0x111a00)
      7 range=(0x111a00~0x111c00)
!kcompactd
      1 range=(0x113e00~0x114000)
      1 range=(0x114000~0x114020)
      1 range=(0x114400~0x114489)
      1 range=(0x114489~0x1144aa)
      1 range=(0x1144aa~0x114600)

6.4.0-rc1-mm-revertfastmigrate
kcompactd
     17 range=(0x104200~0x104400)
     17 range=(0x104400~0x104600)
     17 range=(0x104600~0x104800)
     17 range=(0x104800~0x104a00)
     17 range=(0x104a00~0x104c00)
!kcompactd
   1793 range=(0x15c200~0x15c400)
   5436 range=(0x105800~0x105a00)
  19826 range=(0x150a00~0x150c00)
  19833 range=(0x150800~0x150a00)
  19834 range=(0x11ce00~0x11d000)

6.4.0-rc1-mm-follupfastfind
kcompactd
     22 range=(0x107200~0x107400)
     23 range=(0x107400~0x107600)
     23 range=(0x107600~0x107800)
     23 range=(0x107c00~0x107e00)
     23 range=(0x107e00~0x108000)
!kcompactd
      3 range=(0x890240~0x890400)
      5 range=(0x886e00~0x887000)
      5 range=(0x88a400~0x88a600)
      6 range=(0x88f800~0x88fa00)
      9 range=(0x88a400~0x88a420)

Note that the vanilla kernel and the full series had some duplication of
ranges scanned but it was not severe and would be in line with compaction
resets when the skip hints are cleared.  Just a revert of commit
7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
showed excessive rescans of the same ranges so the series should not
reintroduce bug 1206848.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
Link: https://lkml.kernel.org/r/20230515113344.6869-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock
+++ a/mm/compaction.c
@@ -1888,7 +1888,6 @@ static unsigned long fast_find_migratebl
 					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
-				set_pageblock_skip(freepage);
 				break;
 			}
 		}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch
mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch
revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

