Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45075C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 228F160240
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhKICew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICev (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1814E611CC;
        Tue,  9 Nov 2021 02:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425126;
        bh=UK3OGc5mau6OiUf23OEnTOn4nwyULUSdn0OC1rEihng=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XBL81fVNGI8/5AywU6AvNvUPjTuo6GwXBAjIx7KSCRIzjzrYFG+wWVyKR9fQ59raV
         +YoIcKMBwS0c3+PMLMiOfcCDtIlKlX0mkf4DOetGWJgb/a+4FvIbYM/XIe8XnaMH4e
         oNiEy7GoGjPZi0W7nrtZ0i71Xc9j1BV4DafuZiYY=
Date:   Mon, 08 Nov 2021 18:32:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stephen.s.brennan@oracle.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 13/87] proc: allow pid_revalidate() during
 LOOKUP_RCU
Message-ID: <20211109023205.T0hV91JFt%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: proc: allow pid_revalidate() during LOOKUP_RCU

Problem Description:

When running running ~128 parallel instances of "TZ=/etc/localtime ps -fe
>/dev/null" on a 128CPU machine, the %sys utilization reaches 97%, and
perf shows the following code path as being responsible for heavy
contention on the d_lockref spinlock:

      walk_component()
        lookup_fast()
          d_revalidate()
            pid_revalidate() // returns -ECHILD
          unlazy_child()
            lockref_get_not_dead(&nd->path.dentry->d_lockref) <-- contention

The reason is that pid_revalidate() is triggering a drop from RCU to ref
path walk mode.  All concurrent path lookups thus try to grab a reference
to the dentry for /proc/, before re-executing pid_revalidate() and then
stepping into the /proc/$pid directory.  Thus there is huge spinlock
contention.  This patch allows pid_revalidate() to execute in RCU mode,
meaning that the path lookup can successfully enter the /proc/$pid
directory while still in RCU mode.  Later on, the path lookup may still
drop into ref mode, but the contention will be much reduced at this point.

By applying this patch, %sys utilization falls to around 85% under the
same workload, and the number of ps processes executed per unit time
increases by 3x-4x.  Although this particular workload is a bit contrived,
we have seen some large collections of eager monitoring scripts which
produced similarly high %sys time due to contention in the /proc
directory.

As a result this patch, Al noted that several procfs methods which were
only called in ref-walk mode could now be called from RCU mode.  To ensure
that this patch is safe, I audited all the inode get_link and permission()
implementations, as well as dentry d_revalidate() implementations, in
fs/proc.  The purpose here is to ensure that they either are safe to call
in RCU (i.e.  don't sleep) or correctly bail out of RCU mode if they don't
support it.  My analysis shows that all at-risk procfs methods are safe to
call under RCU, and thus this patch is safe.

Procfs RCU-walk Analysis:

This analysis is up-to-date with 5.15-rc3.  When called under RCU mode,
these functions have arguments as follows:

* get_link() receives a NULL dentry pointer when called in RCU mode.
* permission() receives MAY_NOT_BLOCK in the mode parameter when called
  from RCU.
* d_revalidate() receives LOOKUP_RCU in flags.

For the following functions, either they are trivially RCU safe, or they
explicitly bail at the beginning of the function when they run:

proc_ns_get_link       (bails out)
proc_get_link          (RCU safe)
proc_pid_get_link      (bails out)
map_files_d_revalidate (bails out)
map_misc_d_revalidate  (bails out)
proc_net_d_revalidate  (RCU safe)
proc_sys_revalidate    (bails out, also not under /proc/$pid)
tid_fd_revalidate      (bails out)
proc_sys_permission    (not under /proc/$pid)

The remainder of the functions require a bit more detail:

* proc_fd_permission: RCU safe. All of the body of this function is
  under rcu_read_lock(), except generic_permission() which declares
  itself RCU safe in its documentation string.
* proc_self_get_link uses GFP_ATOMIC in the RCU case, so it is RCU aware
  and otherwise looks safe. The same is true of proc_thread_self_get_link.
* proc_map_files_get_link: calls ns_capable, which calls capable(), and
  thus calls into the audit code (see note #1 below). The remainder is
  just a call to the trivially safe proc_pid_get_link().
* proc_pid_permission: calls ptrace_may_access(), which appears RCU
  safe, although it does call into the "security_ptrace_access_check()"
  hook, which looks safe under smack and selinux. Just the audit code is
  of concern. Also uses get_task_struct() and put_task_struct(), see
  note #2 below.
* proc_tid_comm_permission: Appears safe, though calls put_task_struct
  (see note #2 below).

Note #1:
  Most of the concern of RCU safety has centered around the audit code.
  However, since b17ec22fb339 ("selinux: slow_avc_audit has become
  non-blocking"), it's safe to call this code under RCU. So all of the
  above are safe by my estimation.

Note #2: get_task_struct() and put_task_struct():
  The majority of get_task_struct() is under RCU read lock, and in any
  case it is a simple increment. But put_task_struct() is complex, given
  that it could at some point free the task struct, and this process has
  many steps which I couldn't manually verify. However, several other
  places call put_task_struct() under RCU, so it appears safe to use
  here too (see kernel/hung_task.c:165 or rcu/tree-stall.h:296)

Patch description:

pid_revalidate() drops from RCU into REF lookup mode.  When many threads
are resolving paths within /proc in parallel, this can result in heavy
spinlock contention on d_lockref as each thread tries to grab a reference
to the /proc dentry (and drop it shortly thereafter).

Investigation indicates that it is not necessary to drop RCU in
pid_revalidate(), as no RCU data is modified and the function never
sleeps.  So, remove the LOOKUP_RCU check.

Link: https://lkml.kernel.org/r/20211004175629.292270-2-stephen.s.brennan@oracle.com
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/proc/base.c~proc-allow-pid_revalidate-during-lookup_rcu
+++ a/fs/proc/base.c
@@ -1979,19 +1979,21 @@ static int pid_revalidate(struct dentry
 {
 	struct inode *inode;
 	struct task_struct *task;
+	int ret = 0;
 
-	if (flags & LOOKUP_RCU)
-		return -ECHILD;
-
-	inode = d_inode(dentry);
-	task = get_proc_task(inode);
+	rcu_read_lock();
+	inode = d_inode_rcu(dentry);
+	if (!inode)
+		goto out;
+	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 
 	if (task) {
 		pid_update_inode(task, inode);
-		put_task_struct(task);
-		return 1;
+		ret = 1;
 	}
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static inline bool proc_inode_is_dead(struct inode *inode)
_
