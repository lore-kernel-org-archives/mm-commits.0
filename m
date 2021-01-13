Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0C2C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6D712343B
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbhANB5Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbhAMXnr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 18:43:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A08952339D;
        Wed, 13 Jan 2021 23:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610581386;
        bh=NGRNFXt+eEIeCPAbPgK5dj/xoos2QY/l6OXGmcLJ+fE=;
        h=Date:From:To:Subject:From;
        b=Hy4R+PfeweB6W0Qb1Ejr/0v37jm/wRkTR8QdW4bYt1+V3G2NGND0HW3fslIr41CR6
         FchMNKnbPIFB4PCwX6p4Crfk91hWetR8BKo4+7SFJ4jdwXwOurjR7z4k/lQFJs02v6
         NjJNnWAxZKeDjTO0z76tmSUvcY0xkwYNEfmGEz+k=
Date:   Wed, 13 Jan 2021 15:43:05 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        khalid.aziz@oracle.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, ngupta@nitingupta.dev,
        vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  +
 =?US-ASCII?Q?mm-compaction-return-proper-state-in-should=5Fproactive=5Fco?=
 =?US-ASCII?Q?mpact=5Fnode-fix.patch?= added to -mm tree
Message-ID: <20210113234305.ZKh_i2ZGL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-return-proper-state-in-should_proactive_compact_node-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch

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
Subject: mm-compaction-return-proper-state-in-should_proactive_compact_node-fix

s/max_t/max/

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nitin Gupta <ngupta@nitingupta.dev>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-return-proper-state-in-should_proactive_compact_node-fix
+++ a/mm/compaction.c
@@ -1975,7 +1975,7 @@ static unsigned int fragmentation_score_
 		struct zone *zone;
 
 		zone = &pgdat->node_zones[zoneid];
-		max = max_t(unsigned int, fragmentation_score_zone(zone), max);
+		max = max(fragmentation_score_zone(zone), max);
 	}
 
 	return max;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-process_vm_accessc-include-compath.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

