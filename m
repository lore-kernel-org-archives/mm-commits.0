Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC4DC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 16:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240515AbiHQQFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 12:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbiHQQEo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 12:04:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AB245F74
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 09:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C12CD6158C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 16:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B68DC433D6;
        Wed, 17 Aug 2022 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660752250;
        bh=LbtRPQQuEdLOODYnKG3BDTrYCwBTz2VfGupEw+rU20o=;
        h=Date:To:From:Subject:From;
        b=uZbw9WOhB3P2zEuyE8MEyHVgHnWp+7PacRvoYmVpdfXtaT4Z2GcipuaLW46bf/rbj
         1Nt3L65VWAwkwtSdTWYk6GoEoMFPnv/SN40aH8wBV33JgZNmPbOKZ2pvW6tPiHhvEP
         DAg5jNeQiCFjhOpdfuhG5kCdXcFo3MtzDlxAAaMc=
Date:   Wed, 17 Aug 2022 09:04:09 -0700
To:     mm-commits@vger.kernel.org, quic_pbrahma@quicinc.com,
        mhocko@kernel.org, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch added to mm-unstable branch
Message-Id: <20220817160410.1B68DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_kill: add trace logs in process_mrelease() system call
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

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
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: oom_kill: add trace logs in process_mrelease() system call
Date: Tue, 16 Aug 2022 11:30:17 +0530

The process_mrelease() system call is used to release the memory of a
dying process from the context of the caller, which is similar to and uses
the functions of the oom reaper logic.  There exist trace logs for a
process when reaped by the oom reaper.  Just extend the same to when done
by the process_mrelease() system call.

This patch provides information on how much memory is freed from a process
which is being reaped.  Adding trace events in the process_mrelease() path
when process is being reaped would enable more holistic debug as it
happens in oom_reap_task_mm() currently.

This extends the debug functionality for the events as described in [1] to
the process_mrelease() system call.  Now the coverage of trace events is
complete.

[1] https://lore.kernel.org/all/20170530185231.GA13412@castle/T/#u

Link: https://lkml.kernel.org/r/20220816060017.17996-1-pbrahma@qti.qualcomm.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Pratyush Brahma <quic_pbrahma@quicinc.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-add-trace-logs-in-process_mrelease-system-call
+++ a/mm/oom_kill.c
@@ -995,7 +995,6 @@ static void __oom_kill_process(struct ta
 	mmdrop(mm);
 	put_task_struct(victim);
 }
-#undef K
 
 /*
  * Kill provided task unless it's secured by setting
@@ -1241,17 +1240,33 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 		goto drop_mm;
 
 	if (mmap_read_lock_killable(mm)) {
+		trace_skip_task_reaping(task->pid);
 		ret = -EINTR;
-		goto drop_mm;
+		goto read_unlock;
 	}
 	/*
 	 * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensure
 	 * possible change in exit_mmap is seen
 	 */
-	if (!test_bit(MMF_OOM_SKIP, &mm->flags) && !__oom_reap_task_mm(mm))
+	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
+		trace_skip_task_reaping(task->pid);
+		goto read_unlock;
+	}
+
+	trace_start_task_reaping(task->pid);
+
+	if (!__oom_reap_task_mm(mm))
 		ret = -EAGAIN;
-	mmap_read_unlock(mm);
 
+	pr_debug("process_mrelease: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
+						task_pid_nr(task), task->comm,
+						K(get_mm_counter(mm, MM_ANONPAGES)),
+						K(get_mm_counter(mm, MM_FILEPAGES)),
+						K(get_mm_counter(mm, MM_SHMEMPAGES)));
+	trace_finish_task_reaping(task->pid);
+
+read_unlock:
+	mmap_read_unlock(mm);
 drop_mm:
 	mmdrop(mm);
 put_task:
@@ -1261,3 +1276,4 @@ put_task:
 	return -ENOSYS;
 #endif /* CONFIG_MMU */
 }
+#undef K
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-page_ext-remove-unused-variable-in-offline_page_ext.patch
mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline.patch
mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

