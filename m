From: akpm@linux-foundation.org
Subject: [merged] procfs-fix-proc-pid-stat-stack-pointer-for-kernel-threads.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:21 -0800
Message-ID: <200911201930.nAKJULu6010443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbZKTTb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:31:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     procfs: fix /proc/<pid>/stat stack pointer for kernel threads
has been removed from the -mm tree.  Its filename was
     procfs-fix-proc-pid-stat-stack-pointer-for-kernel-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: fix /proc/<pid>/stat stack pointer for kernel threads
From: Stefani Seibold <stefani@seibold.net>

Fix a small issue for the stack pointer in /proc/<pid>/stat.  In case of a
kernel thread the value of the printed stack pointer should be 0.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~procfs-fix-proc-pid-stat-stack-pointer-for-kernel-threads fs/proc/array.c
--- a/fs/proc/array.c~procfs-fix-proc-pid-stat-stack-pointer-for-kernel-threads
+++ a/fs/proc/array.c
@@ -571,7 +571,7 @@ static int do_task_stat(struct seq_file 
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		(permitted) ? task->stack_start : 0,
+		(permitted && mm) ? task->stack_start : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
_

Patches currently in -mm which might be from stefani@seibold.net are


