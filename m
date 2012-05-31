From: akpm@linux-foundation.org
Subject: [nacked] proc-use-is_err_or_null.patch removed from -mm tree
Date: Thu, 31 May 2012 13:13:30 -0700
Message-ID: <20120531201330.D2088A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40261 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab2EaUNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 16:13:31 -0400
Received: by qcsp5 with SMTP id p5so143030qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 13:13:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use IS_ERR_OR_NULL()
has been removed from the -mm tree.  Its filename was
     proc-use-is_err_or_null.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: proc: use IS_ERR_OR_NULL()

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c       |    2 +-
 fs/proc/task_mmu.c   |    4 ++--
 fs/proc/task_nommu.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-use-is_err_or_null fs/proc/base.c
--- a/fs/proc/base.c~proc-use-is_err_or_null
+++ a/fs/proc/base.c
@@ -239,7 +239,7 @@ static int proc_pid_auxv(struct task_str
 {
 	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
 	int res = PTR_ERR(mm);
-	if (mm && !IS_ERR(mm)) {
+	if (!IS_ERR_OR_NULL(mm)) {
 		unsigned int nwords = 0;
 		do {
 			nwords += 2;
diff -puN fs/proc/task_mmu.c~proc-use-is_err_or_null fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-use-is_err_or_null
+++ a/fs/proc/task_mmu.c
@@ -126,7 +126,7 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm))
+	if (IS_ERR_OR_NULL(mm))
 		return mm;
 	down_read(&mm->mmap_sem);
 
@@ -957,7 +957,7 @@ static ssize_t pagemap_read(struct file 
 
 	mm = mm_access(task, PTRACE_MODE_READ);
 	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
+	if (IS_ERR_OR_NULL(mm))
 		goto out_free;
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
diff -puN fs/proc/task_nommu.c~proc-use-is_err_or_null fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-use-is_err_or_null
+++ a/fs/proc/task_nommu.c
@@ -224,7 +224,7 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm)) {
+	if (IS_ERR_OR_NULL(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
 		return mm;
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch

