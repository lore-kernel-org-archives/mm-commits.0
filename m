Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B973C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiANWGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWGZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A705CC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4331F62012
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA61EC36AE5;
        Fri, 14 Jan 2022 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197983;
        bh=zoZ7pcOfeEEFLoaKWpM6u/ApyYu+Z5ckSOjULxdBdM8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cNaGWYAC1Oq8o71fInJXNwmpIxpLbFJRAaDm4VUpnVoDTLBK9Yh/PhxUqFdAYPWKK
         MYnV75H7YNQl2g6tOyR+k073s3UwTtvlnc9sASezB6N5+kjwhCJG8HDWesQSBDTpDe
         TgUzGsAxN6RaALdWjneVyZ6+4mbkS2T87q2a7Sx4=
Date:   Fri, 14 Jan 2022 14:06:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, christian@brauner.io,
        david@redhat.com, fweimer@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, hch@infradead.org, jannh@google.com,
        jengelh@inai.de, jgg@nvidia.com, kirill@shutemov.name,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        riel@surriel.com, rientjes@google.com, shakeelb@google.com,
        surenb@google.com, timmurray@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 063/146] mm/oom_kill: allow process_mrelease to
 run under mmap_lock protection
Message-ID: <20220114220622.9SK_j2BKF%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
@@ -1170,15 +1170,15 @@ SYSCALL_DEFINE2(process_mrelease, int, p
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
 
@@ -1189,13 +1189,16 @@ SYSCALL_DEFINE2(process_mrelease, int, p
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
