Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE501C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 20:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjAZUPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 15:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAZUPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 15:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7063976A8
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 12:15:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF42AB81E0B
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 20:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1D2C433EF;
        Thu, 26 Jan 2023 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674764098;
        bh=KTQLikMHQev1r8KJwpiesxDjJ2UjRTTDPkLuoQD+cI4=;
        h=Date:To:From:Subject:From;
        b=pgaQz7AS2dqIC5qvR/oievC/GeVbPZtnSb8g1gYjkYLK9jNuITLJ25Ognei9obEDy
         2XI3VG9KOhQZLzQqF5qGfRHzJH1a9iHjS7q1tSkv5KvRF20KM8Gg0iuVjXtERodXA7
         1lsM3T2N4DjasXqOo6TNY7VH52eSc+6Y5ZVoy9go=
Date:   Thu, 26 Jan 2023 12:14:57 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-convert-vma-assignment-to-a-memcpy-fix.patch added to mm-unstable branch
Message-Id: <20230126201458.7E1D2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-fork-convert-vma-assignment-to-a-memcpy-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-fork-convert-vma-assignment-to-a-memcpy-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-convert-vma-assignment-to-a-memcpy-fix.patch

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
Subject: kernel-fork-convert-vma-assignment-to-a-memcpy-fix
Date: Thu, 26 Jan 2023 11:52:24 +0000

preserve data_race()

Link: https://lkml.kernel.org/r/20230126115224.3urhskf35eomk7xl@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-fork-convert-vma-assignment-to-a-memcpy-fix
+++ a/kernel/fork.c
@@ -472,7 +472,7 @@ struct vm_area_struct *vm_area_dup(struc
 		 * orig->shared.rb may be modified concurrently, but the clone
 		 * will be reinitialized.
 		 */
-		memcpy(new, orig, sizeof(*new));
+		data_race(memcpy(new, orig, sizeof(*new)));
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		dup_anon_vma_name(orig, new);
 	}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch
kernel-fork-convert-vma-assignment-to-a-memcpy-fix.patch
mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch
mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch
mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch
mm-compaction-finish-pageblocks-on-complete-migration-failure.patch

