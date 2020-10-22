Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998D0C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5222D223BF
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408172;
	bh=uevV0e24vDruF8CUv2+fGso3KWG0P9RzlKV1vOxPBvo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=w3fps8xxahpEH+upDjG8kQ9jXUvy1VVhSBkMKs/7018wIfuvWbHRKCVV1199eeOpm
	 zeWYhl4ShNjFU1J+ab3TuT2DJBo9wCMxBqnOD9W8S4uXGFvfv0Uv6gHEp9CRUAUfKQ
	 2MdILzvi4QrbJz4bl2dd1WkZYn/nG8/wdhMS6ubg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373243AbgJVXJc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2486207EA;
        Thu, 22 Oct 2020 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408171;
        bh=uevV0e24vDruF8CUv2+fGso3KWG0P9RzlKV1vOxPBvo=;
        h=Date:From:To:Subject:From;
        b=xFf6ODbIzK+YzgJ4bYC/TP4nS1zWH3Gk5NvYMsZd/1oOzsPTIGg8T0QMsblIUeZcK
         S/o6gDouOi/1QrgHKnjEa36xkH/FcvUZEupcTtVKLhi+/fph+YSEdsXWBOEv/ExJtv
         aiPXeorgCLOp0/iPcHtSVri7lZjDGMYsd8MKiCQU=
Date:   Thu, 22 Oct 2020 16:09:30 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, linmiaohe@huawei.com, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-migrate-avoid-possible-unnecessary-process-right-check-in?=
 =?US-ASCII?Q?-kernel=5Fmove=5Fpages.patch?= removed from -mm tree
Message-ID: <20201022230930.US8D5GdSW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: avoid possible unnecessary process right check in kernel_move_pages()
has been removed from the -mm tree.  Its filename was
     mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate: avoid possible unnecessary process right check in kernel_move_pages()

There is no need to check if this process has the right to modify the
specified process when they are same.  And we could also skip the security
hook call if a process is modifying its own pages.  Add helper function to
handle these.

Link: https://lkml.kernel.org/r/20200819083331.19012-1-linmiaohe@huawei.com
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   71 +++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

--- a/mm/migrate.c~mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages
+++ a/mm/migrate.c
@@ -1864,33 +1864,27 @@ static int do_pages_stat(struct mm_struc
 	return nr_pages ? -EFAULT : 0;
 }
 
-/*
- * Move a list of pages in the address space of the currently executing
- * process.
- */
-static int kernel_move_pages(pid_t pid, unsigned long nr_pages,
-			     const void __user * __user *pages,
-			     const int __user *nodes,
-			     int __user *status, int flags)
+static struct mm_struct *find_mm_struct(pid_t pid, nodemask_t *mem_nodes)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	int err;
-	nodemask_t task_nodes;
-
-	/* Check flags */
-	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
-		return -EINVAL;
 
-	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
-		return -EPERM;
+	/*
+	 * There is no need to check if current process has the right to modify
+	 * the specified process when they are same.
+	 */
+	if (!pid) {
+		mmget(current->mm);
+		*mem_nodes = cpuset_mems_allowed(current);
+		return current->mm;
+	}
 
 	/* Find the mm_struct */
 	rcu_read_lock();
-	task = pid ? find_task_by_vpid(pid) : current;
+	task = find_task_by_vpid(pid);
 	if (!task) {
 		rcu_read_unlock();
-		return -ESRCH;
+		return ERR_PTR(-ESRCH);
 	}
 	get_task_struct(task);
 
@@ -1900,22 +1894,47 @@ static int kernel_move_pages(pid_t pid,
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
 		rcu_read_unlock();
-		err = -EPERM;
+		mm = ERR_PTR(-EPERM);
 		goto out;
 	}
 	rcu_read_unlock();
 
- 	err = security_task_movememory(task);
- 	if (err)
+	mm = ERR_PTR(security_task_movememory(task));
+	if (IS_ERR(mm))
 		goto out;
-
-	task_nodes = cpuset_mems_allowed(task);
+	*mem_nodes = cpuset_mems_allowed(task);
 	mm = get_task_mm(task);
+out:
 	put_task_struct(task);
-
 	if (!mm)
+		mm = ERR_PTR(-EINVAL);
+	return mm;
+}
+
+/*
+ * Move a list of pages in the address space of the currently executing
+ * process.
+ */
+static int kernel_move_pages(pid_t pid, unsigned long nr_pages,
+			     const void __user * __user *pages,
+			     const int __user *nodes,
+			     int __user *status, int flags)
+{
+	struct mm_struct *mm;
+	int err;
+	nodemask_t task_nodes;
+
+	/* Check flags */
+	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
 		return -EINVAL;
 
+	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
+		return -EPERM;
+
+	mm = find_mm_struct(pid, &task_nodes);
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+
 	if (nodes)
 		err = do_pages_move(mm, task_nodes, nr_pages, pages,
 				    nodes, status, flags);
@@ -1924,10 +1943,6 @@ static int kernel_move_pages(pid_t pid,
 
 	mmput(mm);
 	return err;
-
-out:
-	put_task_struct(task);
-	return err;
 }
 
 SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


