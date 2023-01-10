Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAF9C46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjAJX32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjAJX3X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:29:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C653BF58
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFCBD61861
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B46FC433F0;
        Tue, 10 Jan 2023 23:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673393361;
        bh=VdK54Ro9NotB84xV1kRUVrIeoIgDszhB40E0B4DLymU=;
        h=Date:To:From:Subject:From;
        b=vr4IVtoPlm4sagKfSLjfy98yBu33D24aTlyLBnve3C02sP2fopLEj+cTPvQzVCkOq
         gI7GCD/ZJBenjfy6zy2FLI5XkhDSH1cmPydj0H8SrHl7C2CGj3I06heDsMEYHH2wDp
         9jMVaLK0caTAtUb2PiupToylulC7c3GOCTnzVe+g=
Date:   Tue, 10 Jan 2023 15:29:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch added to mm-unstable branch
Message-Id: <20230110232921.2B46FC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: avoid fragmentation score calculation for empty zones
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: avoid fragmentation score calculation for empty zones
Date: Tue, 10 Jan 2023 21:36:22 +0800

There is no need to calculate the fragmentation score for empty zones.

Link: https://lkml.kernel.org/r/100331ad9d274a9725e687b00d85d75d7e4a17c7.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones
+++ a/mm/compaction.c
@@ -2025,6 +2025,8 @@ static unsigned int fragmentation_score_
 		struct zone *zone;
 
 		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
 		score += fragmentation_score_zone_weighted(zone);
 	}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch
mm-compaction-move-list-validation-into-compact_zone.patch
mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch
mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch
mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

