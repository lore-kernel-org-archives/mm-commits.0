Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FE6C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiIZUcM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIZUcL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:32:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B175E6CD11
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63B51B8110B
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F6C433D7;
        Mon, 26 Sep 2022 20:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664224325;
        bh=ZgkF6Ut/v+DqtlXKe/S1LI0Ro69QJkbeRqV62+ejlhQ=;
        h=Date:To:From:Subject:From;
        b=fzFjMeDnwdJ9QEEj7iI7o/jAdKZhZIxZtnrQoJ0jYRRn8w3s9MsjFknRHeHtP8Y1F
         OFgyWpVAXQpw3uYLO3L9cYJY38eJ6r1vqicHffpGdzujxK/hdA1Iq3Rdp9gqHg/S8D
         A8Oxi4NGkeoThjcfXKhgRQrsu7JYBE6z/SCauwVY=
Date:   Mon, 26 Sep 2022 13:32:04 -0700
To:     mm-commits@vger.kernel.org, quic_pbrahma@quicinc.com,
        mhocko@kernel.org, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch removed from -mm tree
Message-Id: <20220926203205.000F6C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: oom_kill: add trace logs in process_mrelease() system call
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

This patch was dropped because it was nacked

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

[akpm@linux-foundation.org: reduce 80-col overflows]
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
+		 task_pid_nr(task), task->comm,
+		 K(get_mm_counter(mm, MM_ANONPAGES)),
+		 K(get_mm_counter(mm, MM_FILEPAGES)),
+		 K(get_mm_counter(mm, MM_SHMEMPAGES)));
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


