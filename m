From: akpm@linux-foundation.org
Subject: + proc-use-is_err_or_null.patch added to -mm tree
Date: Wed, 11 Apr 2012 17:48:08 -0700
Message-ID: <20120412004808.D695FA03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34566 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2DLAsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 20:48:10 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so64007eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 17:48:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com


The patch titled
     Subject: proc: use IS_ERR_OR_NULL()
has been added to the -mm tree.  Its filename is
     proc-use-is_err_or_null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
@@ -916,7 +916,7 @@ static ssize_t pagemap_read(struct file 
 
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
Subject: Subject: proc: use IS_ERR_OR_NULL()

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

linux-next.patch
cris-select-generic_atomic64.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-task_access_lock-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch

