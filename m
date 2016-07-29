From: akpm@linux-foundation.org
Subject: [merged] kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:42 -0700
Message-ID: <579ba6ea.ebfgnYxVdR6hEu+8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcG2S4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: use task_cpu() instead of task_thread_info()->cpu
has been removed from the -mm tree.  Its filename was
     kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: kdb: use task_cpu() instead of task_thread_info()->cpu

We'll need this cleanup to make the cpu field in thread_info be
optional.

Link: http://lkml.kernel.org/r/da298328dc77ea494576c2f20a934218e758a6fa.1468523549.git.luto@kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kdb.h~kdb-use-task_cpu-instead-of-task_thread_info-cpu include/linux/kdb.h
--- a/include/linux/kdb.h~kdb-use-task_cpu-instead-of-task_thread_info-cpu
+++ a/include/linux/kdb.h
@@ -177,7 +177,7 @@ extern int kdb_get_kbd_char(void);
 static inline
 int kdb_process_cpu(const struct task_struct *p)
 {
-	unsigned int cpu = task_thread_info(p)->cpu;
+	unsigned int cpu = task_cpu(p);
 	if (cpu > num_possible_cpus())
 		cpu = 0;
 	return cpu;
_

Patches currently in -mm which might be from luto@kernel.org are

signal-consolidate-tstlf_restore_sigmask-code.patch

