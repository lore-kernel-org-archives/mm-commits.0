Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55344C46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjAJX3U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjAJX3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:29:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7920ABF58
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:29:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A75C61952
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A76C433D2;
        Tue, 10 Jan 2023 23:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673393357;
        bh=2fIkDXmaNSvVpFYNaKH2u+rZ9uCkTh65DvF9q0HAVoM=;
        h=Date:To:From:Subject:From;
        b=Ct33TmjTvsPj+VjTpcD5hgHXNB8wTSYc9ZSOUjXYFEszrSFQCDYM/AcvQ+Z613mt+
         YGcjdeLfM+jf/+q+aKXhXtwHVCkeOgzJfhqPAHF+ijWkMoNuFnlDOVIK1TwhEyHffr
         s0FeiUZ/aLsBPgyFXSl7HIIb9nYKe4XqUdj7TbiU=
Date:   Tue, 10 Jan 2023 15:29:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch added to mm-unstable branch
Message-Id: <20230110232917.60A76C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: count the migration scanned pages events for proactive compaction
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch

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
Subject: mm: compaction: count the migration scanned pages events for proactive compaction
Date: Tue, 10 Jan 2023 21:36:20 +0800

The proactive compaction will reuse per-node kcompactd threads, so we
should also count the KCOMPACTD_MIGRATE_SCANNED and KCOMPACTD_FREE_SCANNED
events for proactive compaction.

Link: https://lkml.kernel.org/r/b7f1ece1adc17defa47e3667b5f9fd61f496517a.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/compaction.c~mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction
+++ a/mm/compaction.c
@@ -2659,6 +2659,11 @@ static void proactive_compact_node(pg_da
 		cc.zone = zone;
 
 		compact_zone(&cc, NULL);
+
+		count_compact_events(KCOMPACTD_MIGRATE_SCANNED,
+				     cc.total_migrate_scanned);
+		count_compact_events(KCOMPACTD_FREE_SCANNED,
+				     cc.total_free_scanned);
 	}
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch
mm-compaction-move-list-validation-into-compact_zone.patch
mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch
mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch
mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

