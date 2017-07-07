From: akpm@linux-foundation.org
Subject: [merged]
 kernel-extablec-mark-core_kernel_text-notrace.patch removed from -mm tree
Date: Fri, 07 Jul 2017 12:07:06 -0700
Message-ID: <20170707190706.qDMlSUEtk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdGGTHH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@iogearbox.net, marcin.nowakowski@imgtec.com, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, peterz@infradead.org, rostedt@goodmis.org, stable@vger.kernel.org, tglx@linutronix.de, thomas@m3y3r.de


The patch titled
     Subject: kernel/extable.c: mark core_kernel_text notrace
has been removed from the -mm tree.  Its filename was
     kernel-extablec-mark-core_kernel_text-notrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: kernel/extable.c: mark core_kernel_text notrace

core_kernel_text is used by MIPS in its function graph trace processing,
so having this method traced leads to an infinite set of recursive calls
such as:

[    2.972075] Call Trace:
[    2.972111]
[    2.976731] [<80506584>] ftrace_return_to_handler+0x50/0x128
[    2.983379] [<8045478c>] core_kernel_text+0x10/0x1b8
[    2.989146] [<804119b8>] prepare_ftrace_return+0x6c/0x114
[    2.995402] [<80411b2c>] ftrace_graph_caller+0x20/0x44
[    3.001362] [<80411b60>] return_to_handler+0x10/0x30
[    3.007159] [<80411b50>] return_to_handler+0x0/0x30
[    3.012827] [<80411b50>] return_to_handler+0x0/0x30
[    3.018621] [<804e589c>] ftrace_ops_no_ops+0x114/0x1bc
[    3.024602] [<8045478c>] core_kernel_text+0x10/0x1b8
[    3.030377] [<8045478c>] core_kernel_text+0x10/0x1b8
[    3.036140] [<8045478c>] core_kernel_text+0x10/0x1b8
[    3.041915] [<804e589c>] ftrace_ops_no_ops+0x114/0x1bc
[    3.047923] [<8045478c>] core_kernel_text+0x10/0x1b8
[    3.053682] [<804119b8>] prepare_ftrace_return+0x6c/0x114
[    3.059938] [<80411b2c>] ftrace_graph_caller+0x20/0x44
(...)

Mark the function notrace to avoid it being traced.

Link: http://lkml.kernel.org/r/1498028607-6765-1-git-send-email-marcin.nowakowski@imgtec.com
Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Meyer <thomas@m3y3r.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/extable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/extable.c~kernel-extablec-mark-core_kernel_text-notrace kernel/extable.c
--- a/kernel/extable.c~kernel-extablec-mark-core_kernel_text-notrace
+++ a/kernel/extable.c
@@ -69,7 +69,7 @@ static inline int init_kernel_text(unsig
 	return 0;
 }
 
-int core_kernel_text(unsigned long addr)
+int notrace core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
 	    addr < (unsigned long)_etext)
_

Patches currently in -mm which might be from marcin.nowakowski@imgtec.com are


