Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AEBC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 00:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKGACO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Nov 2022 19:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKGACN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Nov 2022 19:02:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAA2BC2D
        for <mm-commits@vger.kernel.org>; Sun,  6 Nov 2022 16:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C3F60E07
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 00:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD844C433C1;
        Mon,  7 Nov 2022 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667779332;
        bh=m2ilq4352UlfjnMQgRrldBOPRwgumvfMxj1N6cm2/9k=;
        h=Date:To:From:Subject:From;
        b=IWfLmaId5opoWCKkYrGmxMUZvTadHippLdDn4qDOzhyHsYT4LsCcZUZGsgfr41vXT
         F3bT6JL5T3iYY2b27JQe/UOz9JOytuiejJMEXQjz4d497BXG29Ot1vT9QEMPxW7+ub
         iABNX+QSYUtRdfo/RdZlP3NdyCilsDy2hSvn1Ww4=
Date:   Sun, 06 Nov 2022 16:02:11 -0800
To:     mm-commits@vger.kernel.org, wuqiang.matt@bytedance.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kprobeslib-kretprobe-scalability-improvement-fix-2.patch removed from -mm tree
Message-Id: <20221107000211.DD844C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kprobeslib-kretprobe-scalability-improvement-fix-2
has been removed from the -mm tree.  Its filename was
     kprobeslib-kretprobe-scalability-improvement-fix-2.patch

This patch was dropped because it was folded into kprobeslib-kretprobe-scalability-improvement.patch

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
kprobeslib-kretprobe-scalability-improvement.patch

