Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032F3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04EF610C8
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhJ1Vip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231418AbhJ1Vim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68C360FE3;
        Thu, 28 Oct 2021 21:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456975;
        bh=9zwswZBiMPrrgKB8qJCiqcB5jYZFrqPCXDpgvEHIAYY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ps2q+6wGwZgSEk1jL+qQ1SJskDOSVNNtK7+QIutis9n6BNexJGM92Mr1KkXpE1Pu7
         //xqI57ki24E1CaYTZ/vXNdwaivfo7vtdhYLPgmRLoPog2dM9CDLRp8XPAy6aPuhaY
         1ey5PZWpFGYpj3aDNp4seaFjonZ5bLwvHIRg5wKE=
Date:   Thu, 28 Oct 2021 14:36:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        christian@brauner.io, david@redhat.com, fweimer@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, hch@infradead.org,
        jannh@google.com, jengelh@inai.de, linux-mm@kvack.org,
        luto@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        rientjes@google.com, shakeelb@google.com, surenb@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 04/11] mm/oom_kill.c: prevent a race between
 process_mrelease and exit_mmap
Message-ID: <20211028213614.GOA2nllUX%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
