Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36758C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Nov 2022 19:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiKCTPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Nov 2022 15:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiKCTPg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2022 15:15:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E661F9F5
        for <mm-commits@vger.kernel.org>; Thu,  3 Nov 2022 12:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E0F4B829A8
        for <mm-commits@vger.kernel.org>; Thu,  3 Nov 2022 19:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD7BC433D6;
        Thu,  3 Nov 2022 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667502932;
        bh=gHgxm8GjUGGu96phhgAi6EAEnJNa4I9qVBmcjzlSrA8=;
        h=Date:To:From:Subject:From;
        b=jlmHlkEu5JBEZM604ZudUG5pyzQeTkIjzAoADmunFwJ7vElsurFrEEjc4xSw6+YGN
         x5X6EHMjFUc2+pcRes0IAqUM/9++Q7yfYr/d5ha1Gofo0QvLJnAPBfHgq/26tSrdY3
         ab0FpGysQlT8aPTDKoaeghiZRFbH1xVRMcxtxOgA=
Date:   Thu, 03 Nov 2022 12:15:31 -0700
To:     mm-commits@vger.kernel.org, wuqiang.matt@bytedance.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kprobeslib-kretprobe-scalability-improvement-fix-2.patch added to mm-nonmm-unstable branch
Message-Id: <20221103191532.ABD7BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kprobeslib-kretprobe-scalability-improvement-fix-2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kprobeslib-kretprobe-scalability-improvement-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kprobeslib-kretprobe-scalability-improvement-fix-2.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kprobeslib-kretprobe-scalability-improvement-fix-2
Date: Thu Nov  3 12:13:26 PM PDT 2022

include prefetch.h

Cc: wuqiang <wuqiang.matt@bytedance.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objpool.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/objpool.c~kprobeslib-kretprobe-scalability-improvement-fix-2
+++ a/lib/objpool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/objpool.h>
+#include <linux/prefetch.h>
 
 /*
  * objpool: ring-array based lockless MPMC/FIFO queues
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing-fix.patch
maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch
kprobeslib-kretprobe-scalability-improvement-fix.patch
kprobeslib-kretprobe-scalability-improvement-fix-2.patch

