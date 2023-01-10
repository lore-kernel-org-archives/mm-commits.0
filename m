Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7580EC61DB3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjAJX32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbjAJX3X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:29:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8B4DF53
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3E714CE19C2
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E8C433D2;
        Tue, 10 Jan 2023 23:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673393359;
        bh=vRPxLsMYaoXYMx9QjBWano+xqgvKZ4OwXj1Npe9X3cE=;
        h=Date:To:From:Subject:From;
        b=lBm7annD7B/4bovLGg1v1w8HeINzgv/+VjCYW+sD+ri970WgdmMEB1vBfCF0BvwOk
         J/EJTX7cwToh8hmSPBBZ3EauPDNrWGy9QPjt3KSekjy40mjfP9KiWKCKQmqinyPo7v
         wqwHHGGgKJuhczJLYOpG4YuwCl8+CKLLSMipP+FE=
Date:   Tue, 10 Jan 2023 15:29:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch added to mm-unstable branch
Message-Id: <20230110232919.443E8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: add missing kcompactd wakeup trace event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch

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
Subject: mm: compaction: add missing kcompactd wakeup trace event
Date: Tue, 10 Jan 2023 21:36:21 +0800

Add missing kcompactd wakeup trace event for proactive compaction,
meanwhile use order = -1 and the highest zone index of the pgdat for the
kcompactd wakeup trace event by proactive compaction.

Link: https://lkml.kernel.org/r/cbf8097a2d8a1b6800991f2a21575550d3613ce6.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-add-missing-kcompactd-wakeup-trace-event
+++ a/mm/compaction.c
@@ -2730,6 +2730,8 @@ int compaction_proactiveness_sysctl_hand
 				continue;
 
 			pgdat->proactive_compact_trigger = true;
+			trace_mm_compaction_wakeup_kcompactd(pgdat->node_id, -1,
+							     pgdat->nr_zones - 1);
 			wake_up_interruptible(&pgdat->kcompactd_wait);
 		}
 	}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch
mm-compaction-move-list-validation-into-compact_zone.patch
mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch
mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch
mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

