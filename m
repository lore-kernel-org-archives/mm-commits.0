Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BC4C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjAJX3Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjAJX3P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:29:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50A95F54
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F03D6193C
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDC5C433D2;
        Tue, 10 Jan 2023 23:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673393353;
        bh=kr6XtKh8nhwzEGISoWm8SOyVBZm0CIanBPJSu+Lycmo=;
        h=Date:To:From:Subject:From;
        b=aeE6r+scRuUGfyFIZHYYnQHEEd3CRjMSBvIwuG0xz+libn9ez5K2T+Sa8fIMeOPS/
         aiznxmuQgJmG3Lz1vQmT/3GhPC3duP1erXoshPbWjtgu1+bohUxAUHcnguubqDOCC8
         lZXgMZieQSDij+nNSDfAGfmi7B7M5IHBW7mctTzA=
Date:   Tue, 10 Jan 2023 15:29:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch added to mm-unstable branch
Message-Id: <20230110232913.8FDC5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: remove redundant VM_BUG_ON() in compact_zone()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch

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
Subject: mm: compaction: remove redundant VM_BUG_ON() in compact_zone()
Date: Tue, 10 Jan 2023 21:36:18 +0800

Patch series "Some small improvements for compaction".

When I did some compaction testing, I found some small room for
improvement as well as some code cleanups.


This patch (of 5):

The compaction_suitable() will never return values other than
COMPACT_SUCCESS, COMPACT_SKIPPED and COMPACT_CONTINUE, so after validation
of COMPACT_SUCCESS and COMPACT_SKIPPED, we will never hit other unexpected
case.  Thus remove the redundant VM_BUG_ON() validation for the return
values of compaction_suitable().

Link: https://lkml.kernel.org/r/cover.1673342761.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/740a2396d9b98154dba76e326cba5e798b640ead.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-redundant-vm_bug_on-in-compact_zone
+++ a/mm/compaction.c
@@ -2313,9 +2313,6 @@ compact_zone(struct compact_control *cc,
 	if (ret == COMPACT_SUCCESS || ret == COMPACT_SKIPPED)
 		return ret;
 
-	/* huh, compaction_suitable is returning something unexpected */
-	VM_BUG_ON(ret != COMPACT_CONTINUE);
-
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
 	 * is about to be retried after being deferred.
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch
mm-compaction-move-list-validation-into-compact_zone.patch
mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch
mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch
mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

