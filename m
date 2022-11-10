Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4686EC43217
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiKJAJb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiKJAJ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:09:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4305BFAF0
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D283361D1E
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3398DC433C1;
        Thu, 10 Nov 2022 00:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668038966;
        bh=7J+YOz4akC1960hAPEdT3YLLiuh3OOtTmtkdb3k2w+I=;
        h=Date:To:From:Subject:From;
        b=B+CfMCkZJAiXVD0Lu9bBuZFWZyW7VW3EFLoiIeH9D6fv3F63EOUqYys4IzQE5PDmE
         XXzV7LGx8pMrZlSNoUYaA5CaUwZ6iG3CERzV0GKUuNzxOtyc6EuFo7uPlaN0pvKn58
         eSDJFslKE3kl/BHM53WVYTudcQV3t6UhVUuiRLGQ=
Date:   Wed, 09 Nov 2022 16:09:25 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        nadav.amit@gmail.com, hughd@google.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch added to mm-unstable branch
Message-Id: <20221110000926.3398DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch

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
Subject: mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix
Date: Wed Nov  9 04:07:36 PM PST 2022

Fix UP build, per Linus
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mmu_gather.c~mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix
+++ a/mm/mmu_gather.c
@@ -48,6 +48,7 @@ static bool tlb_next_batch(struct mmu_ga
 	return true;
 }
 
+#ifdef CONFIG_SMP
 /**
  * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
  * @tlb: the current mmu_gather
@@ -72,6 +73,7 @@ void tlb_flush_rmaps(struct mmu_gather *
 
 	tlb->delayed_rmap = 0;
 }
+#endif
 
 static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

