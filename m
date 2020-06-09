From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 49/93] kernel: use show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:32:26 -0700
Message-ID: <20200609043226.jGvd3mSnt%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEc2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:28 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org, will@kernel.org

From: Dmitry Safonov <dima@arista.com>
Subject: kernel: use show_stack_loglvl()

Align the last users of show_stack() by KERN_DEFAULT as the surrounding
headers/messages.

Link: http://lkml.kernel.org/r/20200418201944.482088-50-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/rtmutex-debug.c |    2 +-
 lib/dump_stack.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/locking/rtmutex-debug.c~kernel-use-show_stack_loglvl
+++ a/kernel/locking/rtmutex-debug.c
@@ -125,7 +125,7 @@ void debug_rt_mutex_print_deadlock(struc
 
 	printk("\n%s/%d's [blocked] stackdump:\n\n",
 		task->comm, task_pid_nr(task));
-	show_stack(task, NULL);
+	show_stack_loglvl(task, NULL, KERN_DEFAULT);
 	printk("\n%s/%d's [current] stackdump:\n\n",
 		current->comm, task_pid_nr(current));
 	dump_stack();
--- a/lib/dump_stack.c~kernel-use-show_stack_loglvl
+++ a/lib/dump_stack.c
@@ -74,7 +74,7 @@ void show_regs_print_info(const char *lo
 static void __dump_stack(void)
 {
 	dump_stack_print_info(KERN_DEFAULT);
-	show_stack(NULL, NULL);
+	show_stack_loglvl(NULL, NULL, KERN_DEFAULT);
 }
 
 /**
_
