Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BC6C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbiESVww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiESVwv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65353707
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED1E60C23
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A553C385B8;
        Thu, 19 May 2022 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652997169;
        bh=TjAsnz8JRhdNVHSdk1zrZaS9WS8Q6EG58BUdtbv/3W0=;
        h=Date:To:From:Subject:From;
        b=j5570Md9jHaooE9HEIVL85bMfxfkJxiwEb0od1rSnfn3Xas89wgILMFlV/v4zMzD9
         +WVIPDcTaxm9P8yJXOmxfPiXQv2ykbcdWhflwPAGNI6Q53P89Iq38zTdKiGzxd6oku
         IPmWZ3C+ms9BCF78j3WeCM6SMbCWHY4MeH8HfIVQ=
Date:   Thu, 19 May 2022 14:52:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        skhan@linuxfoundation.org, shakeelb@google.com,
        rientjes@google.com, peterx@redhat.com, oleg@redhat.com,
        minchan@kernel.org, mhocko@suse.com, kirill@shutemov.name,
        jhubbard@nvidia.com, jannh@google.com, hch@infradead.org,
        hannes@cmpxchg.org, guro@fb.com, david@redhat.com,
        brauner@kernel.org, aarcange@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-delete-unused-mmf_oom_victim-flag.patch removed from -mm tree
Message-Id: <20220519215249.1A553C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: delete unused MMF_OOM_VICTIM flag
has been removed from the -mm tree.  Its filename was
     mm-delete-unused-mmf_oom_victim-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: delete unused MMF_OOM_VICTIM flag
Date: Mon, 16 May 2022 00:56:19 -0700

With the last usage of MMF_OOM_VICTIM in exit_mmap gone, this flag is now
unused and can be removed.

Link: https://lkml.kernel.org/r/20220516075619.1277152-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h            |    9 ---------
 include/linux/sched/coredump.h |    7 +++----
 mm/oom_kill.c                  |    4 +---
 3 files changed, 4 insertions(+), 16 deletions(-)

--- a/include/linux/oom.h~mm-delete-unused-mmf_oom_victim-flag
+++ a/include/linux/oom.h
@@ -78,15 +78,6 @@ static inline bool tsk_is_oom_victim(str
 }
 
 /*
- * Use this helper if tsk->mm != mm and the victim mm needs a special
- * handling. This is guaranteed to stay true after once set.
- */
-static inline bool mm_is_oom_victim(struct mm_struct *mm)
-{
-	return test_bit(MMF_OOM_VICTIM, &mm->flags);
-}
-
-/*
  * Checks whether a page fault on the given mm is still reliable.
  * This is no longer true if the oom reaper started to reap the
  * address space which is reflected by MMF_UNSTABLE flag set in
--- a/include/linux/sched/coredump.h~mm-delete-unused-mmf_oom_victim-flag
+++ a/include/linux/sched/coredump.h
@@ -71,9 +71,8 @@ static inline int get_dumpable(struct mm
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
 #define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_OOM_VICTIM		25	/* mm is the oom victim */
-#define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
-#define MMF_MULTIPROCESS	27	/* mm is shared between processes */
+#define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
+#define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
  * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
  * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
@@ -81,7 +80,7 @@ static inline int get_dumpable(struct mm
  * pinned pages were unpinned later on, we'll still keep this bit set for the
  * lifecycle of this mm, just for simplicity.
  */
-#define MMF_HAS_PINNED		28	/* FOLL_PIN has run, never cleared */
+#define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
--- a/mm/oom_kill.c~mm-delete-unused-mmf_oom_victim-flag
+++ a/mm/oom_kill.c
@@ -732,10 +732,8 @@ static void mark_oom_victim(struct task_
 		return;
 
 	/* oom_mm is bound to the signal struct life time. */
-	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm)) {
+	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
 		mmgrab(tsk->signal->oom_mm);
-		set_bit(MMF_OOM_VICTIM, &mm->flags);
-	}
 
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
_

Patches currently in -mm which might be from surenb@google.com are

selftests-vm-add-process_mrelease-tests.patch

