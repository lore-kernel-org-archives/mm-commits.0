Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3BAC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhLIUWn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:22:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54772 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhLIUWm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:22:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2794DB82672
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33152C004DD;
        Thu,  9 Dec 2021 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081146;
        bh=sQh1ffe9YL/FVUK3WxfU7daR10mXp23eE+ZI3exFfjk=;
        h=Date:From:To:Subject:From;
        b=LDYFTkzqwR8+YheCtM0nnfDT8g56wQevA7zyLt3tiZRcuMNr3FPF9/bopxBdG9XW2
         38r0HI2d/47Xwcrwnc1M75rUqC7kJwmdzMNBqf3ZsrD6J6jWF3+8WQYMKz7rKr7Tij
         LuWAz+CZ+ygPMAG3N2DIwXRtAYi5aeHc46UOw2pM=
Date:   Thu, 09 Dec 2021 12:19:04 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, christian.brauner@ubuntu.com,
        christian@brauner.io, david@redhat.com, fweimer@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, hch@infradead.org,
        jannh@google.com, jengelh@inai.de, kirill@shutemov.name,
        luto@kernel.org, mchehab@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        riel@surriel.com, rientjes@google.com, shakeelb@google.com,
        surenb@google.com, timmurray@google.com, willy@infradead.org
Subject:  +
 mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
 added to -mm tree
Message-ID: <20211209201904.EZBGguPHr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: allow process_mrelease to run under mmap_lock protection
has been added to the -mm tree.  Its filename is
     mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/oom_kill: allow process_mrelease to run under mmap_lock protection

With exit_mmap holding mmap_write_lock during free_pgtables call,
process_mrelease does not need to elevate mm->mm_users in order to prevent
exit_mmap from destrying pagetables while __oom_reap_task_mm is walking
the VMA tree.  The change prevents process_mrelease from calling the last
mmput, which can lead to waiting for IO completion in exit_aio.

Link: https://lkml.kernel.org/r/20211209191325.3069345-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection
+++ a/mm/oom_kill.c
@@ -1182,15 +1182,15 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 		goto put_task;
 	}
 
-	if (mmget_not_zero(p->mm)) {
-		mm = p->mm;
-		if (task_will_free_mem(p))
-			reap = true;
-		else {
-			/* Error only if the work has not been done already */
-			if (!test_bit(MMF_OOM_SKIP, &mm->flags))
-				ret = -EINVAL;
-		}
+	mm = p->mm;
+	mmgrab(mm);
+
+	if (task_will_free_mem(p))
+		reap = true;
+	else {
+		/* Error only if the work has not been done already */
+		if (!test_bit(MMF_OOM_SKIP, &mm->flags))
+			ret = -EINVAL;
 	}
 	task_unlock(p);
 
@@ -1201,13 +1201,16 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 		ret = -EINTR;
 		goto drop_mm;
 	}
-	if (!__oom_reap_task_mm(mm))
+	/*
+	 * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensure
+	 * possible change in exit_mmap is seen
+	 */
+	if (!test_bit(MMF_OOM_SKIP, &mm->flags) && !__oom_reap_task_mm(mm))
 		ret = -EAGAIN;
 	mmap_read_unlock(mm);
 
 drop_mm:
-	if (mm)
-		mmput(mm);
+	mmdrop(mm);
 put_task:
 	put_task_struct(task);
 	return ret;
_

Patches currently in -mm which might be from surenb@google.com are

mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-anonymous-vma-name-refcounting.patch
mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch
mm-document-locking-restrictions-for-vm_operations_struct-close.patch
mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

