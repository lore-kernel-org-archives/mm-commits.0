From: akpm@linux-foundation.org
Subject: [merged] proc-add-a-reschedule-point-in-proc_readfd_common.patch
 removed from -mm tree
Date: Mon, 11 Jan 2016 13:21:30 -0800
Message-ID: <56941cda.gevFPukzI1a5157d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbcAKVVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 16:21:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add a reschedule point in proc_readfd_common()
has been removed from the -mm tree.  Its filename was
     proc-add-a-reschedule-point-in-proc_readfd_common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: proc: add a reschedule point in proc_readfd_common()

User can pass an arbitrary large buffer to getdents().

It is typically a 32KB buffer used by libc scandir() implementation.

When scanning /proc/{pid}/fd, we can hold cpu way too long, so add a
cond_resched() to be kind with other tasks.

We've seen latencies of more than 50ms on real workloads.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/fd.c~proc-add-a-reschedule-point-in-proc_readfd_common fs/proc/fd.c
--- a/fs/proc/fd.c~proc-add-a-reschedule-point-in-proc_readfd_common
+++ a/fs/proc/fd.c
@@ -258,6 +258,7 @@ static int proc_readfd_common(struct fil
 				     name, len, instantiate, p,
 				     (void *)(unsigned long)fd))
 			goto out_fd_loop;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from edumazet@google.com are


