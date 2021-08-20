Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252D2C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 01:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E5E60EBC
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 01:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhHTB4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 21:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTB4O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 21:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89CA61042;
        Fri, 20 Aug 2021 01:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629424537;
        bh=ZFZ4DuQiWR5vgBAYyLwppB4xuQ4A98qZTU0nzF9wGO4=;
        h=Date:From:To:Subject:From;
        b=LuUoN1VRHOjy5b9owR1+D9uEM5plorjcpeqKfak4nuCDRIgRJIxAhqtrPySpKMdhW
         r5GjYMr72INgJ8TSBD7RB9rMkdVnycIsnFaQwdUx3oPZEIkb34bCv8exomCjfX9tLJ
         3uXJKiE1i28i3MiLQnbEoUKrNK70rxj7BK6w1GLA=
Date:   Thu, 19 Aug 2021 18:55:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, riel@surriel.com, mhocko@suse.com,
        lnyng@fb.com, hannes@cmpxchg.org, guro@fb.com,
        chris@chrisdown.name, akpm@linux-foundation.org
Subject:  [folded-merged]
 =?us-ascii?Q?mm-memcontrol-fix-occasional-ooms-due-to-proportional-memo?=
 =?us-ascii?Q?rylow-reclaim-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20210820015537.o6ime%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim-checkpatch-fixes

WARNING: Possible repeated word: 'back'
#104: FILE: mm/vmscan.c:107:
+	 * result, then go back back for one more cycle that reclaims

total: 0 errors, 1 warnings, 100 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Leon Yang <lnyng@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -104,8 +104,8 @@ struct scan_control {
 	 * don't threaten to OOM. If any cgroup is reclaimed at
 	 * reduced force or passed over entirely due to its memory.low
 	 * setting (memcg_low_skipped), and nothing is reclaimed as a
-	 * result, then go back back for one more cycle that reclaims
-	 * the protected memory (memcg_low_reclaim) to avert OOM.
+	 * result, then go back for one more cycle that reclaims the protected
+	 * memory (memcg_low_reclaim) to avert OOM.
 	 */
 	unsigned int memcg_low_reclaim:1;
 	unsigned int memcg_low_skipped:1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch
mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

