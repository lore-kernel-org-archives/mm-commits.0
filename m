From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 12 Mar 2020 12:17:07 -0700
Message-ID: <20200312191707.tJQQRYiVP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgCLTRJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 15:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup.c |   39 ---------------------------------------
 1 file changed, 39 deletions(-)

--- a/kernel/cgroup/cgroup.c~linux-next-git-rejects
+++ a/kernel/cgroup/cgroup.c
@@ -4412,31 +4412,12 @@ static void css_task_iter_advance_css_se
 			it->cur_tasks_head = &cset->dying_tasks;
 			break;
 		}
-<<<<<<< HEAD
-	} while (!css_set_populated(cset) && list_empty(&cset->dying_tasks));
-
-	if (!list_empty(&cset->tasks)) {
-		it->task_pos = cset->tasks.next;
-		it->cur_tasks_head = &cset->tasks;
-	} else if (!list_empty(&cset->mg_tasks)) {
-		it->task_pos = cset->mg_tasks.next;
-		it->cur_tasks_head = &cset->mg_tasks;
-	} else {
-		it->task_pos = cset->dying_tasks.next;
-		it->cur_tasks_head = &cset->dying_tasks;
-	}
-
-	it->tasks_head = &cset->tasks;
-	it->mg_tasks_head = &cset->mg_tasks;
-	it->dying_tasks_head = &cset->dying_tasks;
-=======
 	}
 	if (!cset) {
 		it->task_pos = NULL;
 		return;
 	}
 	it->task_pos = it->cur_tasks_head->next;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * We don't keep css_sets locked across iteration steps and thus
@@ -4490,17 +4471,6 @@ repeat:
 		else
 			it->task_pos = it->task_pos->next;
 
-<<<<<<< HEAD
-		if (it->task_pos == it->tasks_head) {
-			it->task_pos = it->mg_tasks_head->next;
-			it->cur_tasks_head = it->mg_tasks_head;
-		}
-		if (it->task_pos == it->mg_tasks_head) {
-			it->task_pos = it->dying_tasks_head->next;
-			it->cur_tasks_head = it->dying_tasks_head;
-		}
-		if (it->task_pos == it->dying_tasks_head)
-=======
 		if (it->task_pos == &it->cur_cset->tasks) {
 			it->cur_tasks_head = &it->cur_cset->mg_tasks;
 			it->task_pos = it->cur_tasks_head->next;
@@ -4510,7 +4480,6 @@ repeat:
 			it->task_pos = it->cur_tasks_head->next;
 		}
 		if (it->task_pos == &it->cur_cset->dying_tasks)
->>>>>>> linux-next/akpm-base
 			css_task_iter_advance_css_set(it);
 	} else {
 		/* called from start, proceed to the first cset */
@@ -4528,20 +4497,12 @@ repeat:
 			goto repeat;
 
 		/* and dying leaders w/o live member threads */
-<<<<<<< HEAD
-		if (it->cur_tasks_head == it->dying_tasks_head &&
-=======
 		if (it->cur_tasks_head == &it->cur_cset->dying_tasks &&
->>>>>>> linux-next/akpm-base
 		    !atomic_read(&task->signal->live))
 			goto repeat;
 	} else {
 		/* skip all dying ones */
-<<<<<<< HEAD
-		if (it->cur_tasks_head == it->dying_tasks_head)
-=======
 		if (it->cur_tasks_head == &it->cur_cset->dying_tasks)
->>>>>>> linux-next/akpm-base
 			goto repeat;
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
