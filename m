Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC782C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhK1BBq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344682AbhK1A7q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:59:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1085C061574
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 16:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D8260F55
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FC2C53FBF;
        Sun, 28 Nov 2021 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638060989;
        bh=uSixdTyfGhv+9AaT2VvL2t6oNJqYvdKJM2O0j+1SMdE=;
        h=Date:From:To:Subject:From;
        b=RxlBgWDCskPwbZoMcqh/6bPB3UIXic/E6G+QeUFjL1WX2SyyLMzu0ALGyv5FAXgrN
         sN2vAQeFhecGzeVIoLBQAT0V7p/gixTqGAo4gv2W/T+3NQCZ3UlJbac5GNyFaWKVOz
         9fSa1qzkH98aA081yF72pqqyUkMXJfUp9hs6qdxU=
Date:   Sat, 27 Nov 2021 16:56:28 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, christian.brauner@ubuntu.com,
        christian@brauner.io, david@redhat.com, fweimer@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, hch@infradead.org,
        jannh@google.com, jengelh@inai.de, kirill@shutemov.name,
        luto@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        rientjes@google.com, shakeelb@google.com, surenb@google.com,
        timmurray@google.com, willy@infradead.org
Subject:  +
 mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
 added to -mm tree
Message-ID: <20211128005628.sYulOdY4w%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20211124235906.14437-2-surenb@google.com
Fixes: 337546e83fc7 ("mm/oom_kill.c: prevent a race between process_mrelease and exit_mmap")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection
+++ a/mm/oom_kill.c
@@ -1169,15 +1169,15 @@ SYSCALL_DEFINE2(process_mrelease, int, p
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
 
@@ -1188,13 +1188,16 @@ SYSCALL_DEFINE2(process_mrelease, int, p
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
mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

