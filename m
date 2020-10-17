Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9292DC43467
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A15208E4
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976445;
	bh=kFSoIWWs4XOxOsX9f43QcJB4KhMzRi51ggBuKQyD7mk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CPefpS6GjZ4u7x1XLhge46PUE1RSZ2Wv7uytNJ6MFIZuuY5JlX771WRhuceBmAZJi
	 ZDpDKGOv9BCVODHJpd2UBeODYDp22rGJ58ZE0k4ZS3gPds4qUBvy2CRhdtmESATmiZ
	 OnE6Os9KVV/zcaKmr7UrrMUVNrlSj+tKBpVupBlc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439888AbgJQXOF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E6D208B6;
        Sat, 17 Oct 2020 23:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976444;
        bh=kFSoIWWs4XOxOsX9f43QcJB4KhMzRi51ggBuKQyD7mk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IjRvNDF3tpyxDdGpYlb62tyEelqo362Mbr0ug/dw0rvceJazuUCjK2gP6JpXttIr5
         fiMPQKTtnwcFsshAp1kEKpb24THVKPfns0cF7vKWHclUZ2G5u7/8M6GKa9OccRrObz
         ui5OejwMCn0u0PI1kKub5314tsiFUleS57H7uMNU=
Date:   Sat, 17 Oct 2020 16:14:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 09/40] mm/migrate: avoid possible unnecessary
 process right check in kernel_move_pages()
Message-ID: <20201017231403.WBGUY4nLK%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
