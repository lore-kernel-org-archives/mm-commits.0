From: akpm@linux-foundation.org
Subject: [patch 36/94] lib/nmi_backtrace.c: fix kernel text address
 leak
Date: Fri, 17 Nov 2017 15:28:20 -0800
Message-ID: <20171117232820.1qfPAbPU2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55574 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965622AbdKQX2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, changcheng.liu@intel.com, jpoimboe@redhat.com, mm-commits@vger.kernel.org, pmladek@suse.com, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: lib/nmi_backtrace.c: fix kernel text address leak

Don't leak idle function address in NMI backtrace.

Link: http://lkml.kernel.org/r/20171106165648.GA95243@sofia
Signed-off-by: Liu Changcheng <changcheng.liu@intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/nmi_backtrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/nmi_backtrace.c~lib_backtrace-fix-kernel-text-address-leak lib/nmi_backtrace.c
--- a/lib/nmi_backtrace.c~lib_backtrace-fix-kernel-text-address-leak
+++ a/lib/nmi_backtrace.c
@@ -93,8 +93,8 @@ bool nmi_cpu_backtrace(struct pt_regs *r
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		arch_spin_lock(&lock);
 		if (regs && cpu_in_idle(instruction_pointer(regs))) {
-			pr_warn("NMI backtrace for cpu %d skipped: idling at pc %#lx\n",
-				cpu, instruction_pointer(regs));
+			pr_warn("NMI backtrace for cpu %d skipped: idling at %pS\n",
+				cpu, (void *)instruction_pointer(regs));
 		} else {
 			pr_warn("NMI backtrace for cpu %d\n", cpu);
 			if (regs)
_
