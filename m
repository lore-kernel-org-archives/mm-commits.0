Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D838C32771
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 16:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240596AbiHQQFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 12:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240588AbiHQQEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 12:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70B56355
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 09:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E5CAB81DF9
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 16:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C3CC433D7;
        Wed, 17 Aug 2022 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660752252;
        bh=SKbcfWbSIpFh2kejMza7gD7tkGrvC7DzUJHGAXVXR0s=;
        h=Date:To:From:Subject:From;
        b=EmNovgK1kOXkTYqUMY3bS3M8XrazHP6pA+6kyGFeHVFrNFx1UnR0ae3YYtK15o30M
         EGU68Dxn2DCaVxug8f3ZUv7t7TEth9g0eqMoF1fOqgum4dUn/nvAFnNp7mFvAo0E+c
         5yeLOMuvwvatv/ME++bTloscL6+a5RCllgLX29ck=
Date:   Wed, 17 Aug 2022 09:04:11 -0700
To:     mm-commits@vger.kernel.org, quic_pbrahma@quicinc.com,
        quic_charante@quicinc.com, mhocko@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch added to mm-unstable branch
Message-Id: <20220817160412.22C3CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch

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
Subject: mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix
Date: Wed Aug 17 09:01:08 AM PDT 2022

reduce 80-col overflows

Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Pratyush Brahma <quic_pbrahma@quicinc.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix
+++ a/mm/oom_kill.c
@@ -1259,10 +1259,10 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 		ret = -EAGAIN;
 
 	pr_debug("process_mrelease: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
-						task_pid_nr(task), task->comm,
-						K(get_mm_counter(mm, MM_ANONPAGES)),
-						K(get_mm_counter(mm, MM_FILEPAGES)),
-						K(get_mm_counter(mm, MM_SHMEMPAGES)));
+		 task_pid_nr(task), task->comm,
+		 K(get_mm_counter(mm, MM_ANONPAGES)),
+		 K(get_mm_counter(mm, MM_FILEPAGES)),
+		 K(get_mm_counter(mm, MM_SHMEMPAGES)));
 	trace_finish_task_reaping(task->pid);
 
 read_unlock:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch

