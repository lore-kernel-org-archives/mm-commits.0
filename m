From: akpm@linux-foundation.org
Subject: + kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch added to -mm tree
Date: Thu, 14 Jul 2016 13:54:36 -0700
Message-ID: <5787fc0c.DGEEenIFS9omVJwm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbcGNUyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 16:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: use task_cpu() instead of task_thread_info()->cpu
has been added to the -mm tree.  Its filename is
     kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks.patch
mm-fix-memcg-stack-accounting-for-sub-page-stacks.patch
kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch
printk-when-dumping-regs-show-the-stack-not-thread_info.patch

