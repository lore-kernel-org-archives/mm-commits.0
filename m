Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CC6C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAEEE61058
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhKAS0o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhKAS0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Nov 2021 14:26:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65E860F45;
        Mon,  1 Nov 2021 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791048;
        bh=MJ7elyrZaRtE6DNqjqkeW+62pRRohQL7pYAqmMGhk6s=;
        h=Date:From:To:Subject:From;
        b=pkUOnXO+6Png9wfvQi6VZJyWvvdU/Wtd34ONM3ZY7XsXRvkc04O9rhAca84I54CKn
         d8ygtLYoGMKkzWN1u6bIIzZCjogdNqugop4yCRuDx7PudOlYr+/D5yabV94kZ4xKSD
         VilZo+dOLNy81X8gvoC8YXk/JW9FN4OAF28vANEk=
Date:   Mon, 01 Nov 2021 11:24:07 -0700
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, christian@brauner.io,
        david@redhat.com, fweimer@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, hch@infradead.org, jannh@google.com,
        jengelh@inai.de, luto@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        riel@surriel.com, rientjes@google.com, shakeelb@google.com,
        surenb@google.com, willy@infradead.org
Subject:  [merged]
 mm-prevent-a-race-between-process_mrelease-and-exit_mmap.patch removed from
 -mm tree
Message-ID: <20211101182407.MuKIs0i14%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: prevent a race between process_mrelease and exit_mmap
has been removed from the -mm tree.  Its filename was
     mm-prevent-a-race-between-process_mrelease-and-exit_mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/oom_kill.c: prevent a race between process_mrelease and exit_mmap

Race between process_mrelease and exit_mmap, where free_pgtables is called
while __oom_reap_task_mm is in progress, leads to kernel crash during
pte_offset_map_lock call.  oom-reaper avoids this race by setting
MMF_OOM_VICTIM flag and causing exit_mmap to take and release
mmap_write_lock, blocking it until oom-reaper releases mmap_read_lock.

Reusing MMF_OOM_VICTIM for process_mrelease would be the simplest way to
fix this race, however that would be considered a hack.  Fix this race by
elevating mm->mm_users and preventing exit_mmap from executing until
process_mrelease is finished.  Patch slightly refactors the code to adapt
for a possible mmget_not_zero failure.

This fix has considerable negative impact on process_mrelease performance
and will likely need later optimization.

Link: https://lkml.kernel.org/r/20211022014658.263508-1-surenb@google.com
Fixes: 884a7e5964e0 ("mm: introduce process_mrelease system call")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/oom_kill.c~mm-prevent-a-race-between-process_mrelease-and-exit_mmap
+++ a/mm/oom_kill.c
@@ -1150,7 +1150,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	struct task_struct *task;
 	struct task_struct *p;
 	unsigned int f_flags;
-	bool reap = true;
+	bool reap = false;
 	struct pid *pid;
 	long ret = 0;
 
@@ -1177,15 +1177,15 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 		goto put_task;
 	}
 
-	mm = p->mm;
-	mmgrab(mm);
-
-	/* If the work has been done already, just exit with success */
-	if (test_bit(MMF_OOM_SKIP, &mm->flags))
-		reap = false;
-	else if (!task_will_free_mem(p)) {
-		reap = false;
-		ret = -EINVAL;
+	if (mmget_not_zero(p->mm)) {
+		mm = p->mm;
+		if (task_will_free_mem(p))
+			reap = true;
+		else {
+			/* Error only if the work has not been done already */
+			if (!test_bit(MMF_OOM_SKIP, &mm->flags))
+				ret = -EINVAL;
+		}
 	}
 	task_unlock(p);
 
@@ -1201,7 +1201,8 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	mmap_read_unlock(mm);
 
 drop_mm:
-	mmdrop(mm);
+	if (mm)
+		mmput(mm);
 put_task:
 	put_task_struct(task);
 put_pid:
_

Patches currently in -mm which might be from surenb@google.com are


