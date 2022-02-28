Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B766C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiB1Atd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiB1Ata (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5FE3DA75
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18801B80D64
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD89C340E9;
        Mon, 28 Feb 2022 00:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009323;
        bh=V1scHSVVqDl74uMaR6lKgfccNMR+OeHtdiLgxeubfLM=;
        h=Date:To:From:Subject:From;
        b=MUdb9+BmeXSR1Qc9D3zBSClMZTETqdotId3YfQhTDzONT7KZl1BXvPfO/A1SIcevw
         HaLYsRH4yh5qM212FJ0vY6fTTTz2Q7KvOkzgKa5jFyiO1krHMmjXQQx+MhGHJ8uBHy
         fzLMLv32vGzdgkUWGLwpffRtaTksJHe54pgy5fQs=
Date:   Sun, 27 Feb 2022 16:48:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        timmurray@google.com, shy828301@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, riel@surriel.com,
        oleg@redhat.com, minchan@kernel.org, mhocko@suse.com,
        luto@kernel.org, kirill@shutemov.name, jengelh@inai.de,
        jannh@google.com, hch@infradead.org, hannes@cmpxchg.org,
        fweimer@redhat.com, david@redhat.com, christian.brauner@ubuntu.com,
        brauner@kernel.org, aarcange@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch removed from -mm tree
Message-Id: <20220228004843.AFD89C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix use-after-free bug when mm->mmap is reused after being freed
has been removed from the -mm tree.  Its filename was
     mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix use-after-free bug when mm->mmap is reused after being freed

oom reaping (__oom_reap_task_mm) relies on a 2 way synchronization with
exit_mmap.  First it relies on the mmap_lock to exclude from unlock
path[1], page tables tear down (free_pgtables) and vma destruction. 
This alone is not sufficient because mm->mmap is never reset.  For
historical reasons[2] the lock is taken there is also MMF_OOM_SKIP set
for oom victims before.

The oom reaper only ever looks at oom victims so the whole scheme works
properly but process_mrelease can opearate on any task (with fatal
signals pending) which doesn't really imply oom victims.  That means
that the MMF_OOM_SKIP part of the synchronization doesn't work and it
can see a task after the whole address space has been demolished and
traverse an already released mm->mmap list.  This leads to use after
free as properly caught up by KASAN report.

Fix the issue by reseting mm->mmap so that MMF_OOM_SKIP synchronization
is not needed anymore.  The MMF_OOM_SKIP is not removed from exit_mmap
yet but it acts mostly as an optimization now.

[1] 27ae357fa82b ("mm, oom: fix concurrent munlock and oom reaper unmap, v3")
[2] 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")

[mhocko@suse.com: changelog rewrite]
Link: https://lore.kernel.org/all/00000000000072ef2c05d7f81950@google.com/
Link: https://lkml.kernel.org/r/20220215201922.1908156-1-surenb@google.com
Fixes: 64591e8605d6 ("mm: protect free_pgtables with mmap_lock write lock in exit_mmap")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+2ccf63a4bd07cf39cab0@syzkaller.appspotmail.com
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
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

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed
+++ a/mm/mmap.c
@@ -3186,6 +3186,7 @@ void exit_mmap(struct mm_struct *mm)
 		vma = remove_vma(vma);
 		cond_resched();
 	}
+	mm->mmap = NULL;
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
_

Patches currently in -mm which might be from surenb@google.com are

mm-refactor-vm_area_struct-anon_vma_name-usage-code.patch
mm-refactor-vm_area_struct-anon_vma_name-usage-code-v3.patch
mm-prevent-vm_area_struct-anon_name-refcount-saturation.patch
mm-fix-use-after-free-when-anon-vma-name-is-used-after-vma-is-freed.patch
mm-count-time-in-drain_all_pages-during-direct-reclaim-as-memory-pressure.patch

