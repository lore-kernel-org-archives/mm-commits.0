From: akpm@linux-foundation.org
Subject: + lib_backtrace-fix-kernel-text-address-leak.patch added to -mm
 tree
Date: Mon, 06 Nov 2017 15:52:58 -0800
Message-ID: <5a00f5da.9c6gBZgyRXr+3YpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdKFXw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2017 18:52:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changcheng.liu@intel.com, jpoimboe@redhat.com, pmladek@suse.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/nmi_backtrace.c: fix kernel text address leak
has been added to the -mm tree.  Its filename is
     lib_backtrace-fix-kernel-text-address-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib_backtrace-fix-kernel-text-address-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib_backtrace-fix-kernel-text-address-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: lib/nmi_backtrace.c: fix kernel text address leak

Don't leak idle function address in NMI backtrace.

Link: http://lkml.kernel.org/r/20171106165648.GA95243@sofia
Signed-off-by: Liu Changcheng <changcheng.liu@intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
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

Patches currently in -mm which might be from changcheng.liu@intel.com are

lib_backtrace-fix-kernel-text-address-leak.patch

