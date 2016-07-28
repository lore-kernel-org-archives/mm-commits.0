From: akpm@linux-foundation.org
Subject: [patch 077/101] kdb: use task_cpu() instead of
 task_thread_info()->cpu
Date: Thu, 28 Jul 2016 15:48:20 -0700
Message-ID: <579a8bb4.tpKVQEPAruwYvO77%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcG1WsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, luto@kernel.org, jason.wessel@windriver.com

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
