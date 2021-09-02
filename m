Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0B7C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD59B6108E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346729AbhIBVXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245379AbhIBVXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601D561074;
        Thu,  2 Sep 2021 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617738;
        bh=0kXKI/Cn24dGXaVtR5j+8HFgPR9zyIPR8uDxjySiwa8=;
        h=Date:From:To:Subject:From;
        b=QUVBVneQ+EzLiZ4L24ch1//XotiLTvQe0KGBRPQTPuzZNWKs1Ml2aKWpY1YlF2V6P
         T12NeAoHHyk703vZCTsUCZv/nk0+9sMHVPmO06vkhQgOviCg+e1ClOf5Y5TXkmWt5S
         pQgI8ecHM+7MUNET5K1ERLYNQ7fo/ZAqK/83uGn4=
Date:   Thu, 02 Sep 2021 14:22:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        khalid.aziz@oracle.com, mm-commits@vger.kernel.org,
        nigupta@nvidia.com, rientjes@google.com, vbabka@suse.cz,
        vinmenon@codeaurora.org
Subject:  [folded-merged]
 mm-compaction-optimize-proactive-compaction-deferrals-fix.patch removed
 from -mm tree
Message-ID: <20210902212217.rPrlhK6zk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-optimize-proactive-compaction-deferrals-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-optimize-proactive-compaction-deferrals-fix.patch

This patch was dropped because it was folded into mm-compaction-optimize-proactive-compaction-deferrals.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-optimize-proactive-compaction-deferrals-fix

tweak comment

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-optimize-proactive-compaction-deferrals-fix
+++ a/mm/compaction.c
@@ -2909,11 +2909,11 @@ static int kcompactd(void *p)
 			kcompactd_do_work(pgdat);
 			psi_memstall_leave(&pflags);
 			/*
-			 * Reset the timeout value. The defer timeout by
-			 * proactive compaction can effectively lost
-			 * here but that is fine as the condition of the
-			 * zone changed substantionally and carrying on
-			 * with the previous defer is not useful.
+			 * Reset the timeout value. The defer timeout from
+			 * proactive compaction is lost here but that is fine
+			 * as the condition of the zone changing substantionally
+			 * then carrying on with the previous defer interval is
+			 * not useful.
 			 */
 			timeout = default_timeout;
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-proactive-compaction-deferrals.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

