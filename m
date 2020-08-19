Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928D8C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716DB207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861907;
	bh=6fDgDOpZwTrVQjUksPvbtxquqt+NUl7iNuDtDyHoXhQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XyXzgdX1fPt69oTzhjvsA3qjcgTg7i5EvP0hgSJzKbTNLHaHDnv8xd+AmZuhfFmtn
	 6lcExDFtIxQjo1MSwhc4ZC8w7YPIP69ZP5NH6UHpx7yh0qqMkHIT9I61JtMFtwuYqQ
	 P8AuSD5ge6jF1SlZ2CRJORjMx1yZ/G6RDlUGPBjM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHSSbr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgHSSbq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:31:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4DB220658;
        Wed, 19 Aug 2020 18:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861905;
        bh=6fDgDOpZwTrVQjUksPvbtxquqt+NUl7iNuDtDyHoXhQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CGU6fzy0TlicoPOwFdMfcOkLkrG9MSkNjFWUGZwyMRyxyBFRqWaBVTZthCoSGzDjK
         +06bsnA4miK4+Vb5xtldyzxhCfr7sYl/Un+nlQNr4BPYpVxn2FwplZ3uDjzCiixgKu
         3RO+f5Tv9h4Hm5jTGYHhacSCshcBhPKjjbg72K2Y=
Date:   Wed, 19 Aug 2020 11:31:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, linmiaohe@huawei.com, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-migrate-avoid-possible-unnecessary-process-right-check-in?=
 =?US-ASCII?Q?-kernel=5Fmove=5Fpages.patch?= added to -mm tree
Message-ID: <20200819183145.LvQ88zWrr%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: avoid possible unnecessary process right check in kernel_move_pages()
has been added to the -mm tree.  Its filename is
     mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

