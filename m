Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF18C77B7F
	for <mm-commits@archiver.kernel.org>; Sat, 13 May 2023 00:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbjEMANS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 20:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjEMANR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 20:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A0B46A0
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 17:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92A2364BA7
        for <mm-commits@vger.kernel.org>; Sat, 13 May 2023 00:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E7BC433D2;
        Sat, 13 May 2023 00:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683936796;
        bh=QexgFKnosFbc+VjEFmUtK7iggL1zsjTht/ICJdbpcqM=;
        h=Date:To:From:Subject:From;
        b=04TaMQtEXWJl4PB5ufSgBO8a8P4kk5U/WP7Sa6YW5curqZN8mU6xKAn+0jxb8/ngJ
         p1QEvy1ongkrFIufDdEqXT63NIn/IUum1Jg7Y62KCJXHEOS1rSn6e/qhNllJUGrr5V
         53s9k0rdgS5xJFpjoq5LjU7EC6lltDLpdSVAeU4Q=
Date:   Fri, 12 May 2023 17:13:15 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom-do-not-check-0-mask-in-out_of_memory.patch added to mm-unstable branch
Message-Id: <20230513001315.E2E7BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not check 0 mask in out_of_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom-do-not-check-0-mask-in-out_of_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom-do-not-check-0-mask-in-out_of_memory.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm, oom: do not check 0 mask in out_of_memory()
Date: Mon, 8 May 2023 07:35:38 +0000

Since commit 60e2793d440a ("mm, oom: do not trigger out_of_memory from the
#PF"), no user sets gfp_mask to 0.  Remove the 0 mask check and update the
comments.

Link: https://lkml.kernel.org/r/20230508073538.1168-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/oom_kill.c~mm-oom-do-not-check-0-mask-in-out_of_memory
+++ a/mm/oom_kill.c
@@ -1130,12 +1130,10 @@ bool out_of_memory(struct oom_control *o
 
 	/*
 	 * The OOM killer does not compensate for IO-less reclaim.
-	 * pagefault_out_of_memory lost its gfp context so we have to
-	 * make sure exclude 0 mask - all other users should have at least
-	 * ___GFP_DIRECT_RECLAIM to get here. But mem_cgroup_oom() has to
-	 * invoke the OOM killer even if it is a GFP_NOFS allocation.
+	 * But mem_cgroup_oom() has to invoke the OOM killer even
+	 * if it is a GFP_NOFS allocation.
 	 */
-	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
+	if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
 		return true;
 
 	/*
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch
mm-oom-do-not-check-0-mask-in-out_of_memory.patch

