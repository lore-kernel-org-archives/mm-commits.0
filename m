From: akpm@linux-foundation.org
Subject: + mm-copy-over-oom_adj-value-at-fork-time.patch added to -mm tree
Date: Wed, 15 Jul 2009 14:29:47 -0700
Message-ID: <200907152129.n6FLTl4j007465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZGOVab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 17:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, manage@google.com, rientjes@google.com


The patch titled
     mm: copy over oom_adj value at fork time
has been added to the -mm tree.  Its filename is
     mm-copy-over-oom_adj-value-at-fork-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: copy over oom_adj value at fork time
From: Rik van Riel <riel@redhat.com>

Fix a post-2.6.31 regression which was introduced by
2ff05b2b4eac2e63d345fc731ea151a060247f53 ("oom: move oom_adj value from
task_struct to mm_struct").

After moving the oom_adj value from the task struct to the mm_struct, the
oom_adj value was no longer properly inherited by child processes.

Copying over the oom_adj value at fork time fixes that bug.

[kosaki.motohiro@jp.fujitsu.com: test for current->mm before dereferencing it]
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Paul Menage <manage@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~mm-copy-over-oom_adj-value-at-fork-time kernel/fork.c
--- a/kernel/fork.c~mm-copy-over-oom_adj-value-at-fork-time
+++ a/kernel/fork.c
@@ -426,6 +426,7 @@ static struct mm_struct * mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
+	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
_

Patches currently in -mm which might be from riel@redhat.com are

mm-copy-over-oom_adj-value-at-fork-time.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch

