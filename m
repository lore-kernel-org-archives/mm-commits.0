From: akpm@linux-foundation.org
Subject: [merged]
 fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch removed from -mm tree
Date: Mon, 15 Jul 2013 13:49:33 -0700
Message-ID: <51e4605d.Kq+ir6VY/Dj3JUjw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3GOUte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 16:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com, ebiederm@xmission.com, dhowells@redhat.com, avagin@openvz.org, akpm@linux-foundation.org

Subject: [merged] fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,avagin@openvz.org,dhowells@redhat.com,ebiederm@xmission.com,oleg@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 13:49:33 -0700


The patch titled
     Subject: fs/file_table.c:fput(): add comment
has been removed from the -mm tree.  Its filename was
     fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/file_table.c:fput(): add comment

A missed update to "fput: task_work_add() can fail if the caller has
passed exit_task_work()".

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/file_table.c~fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix fs/file_table.c
--- a/fs/file_table.c~fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix
+++ a/fs/file_table.c
@@ -313,6 +313,12 @@ void fput(struct file *file)
 			init_task_work(&file->f_u.fu_rcuhead, ____fput);
 			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
 				return;
+			/*
+			 * After this task has run exit_task_work(),
+			 * task_work_add() will fail.  free_ipc_ns()->
+			 * shm_destroy() can do this.  Fall through to delayed
+			 * fput to avoid leaking *file.
+			 */
 		}
 		spin_lock_irqsave(&delayed_fput_lock, flags);
 		list_add(&file->f_u.fu_list, &delayed_fput_list);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

