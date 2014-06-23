From: akpm@linux-foundation.org
Subject: [folded-merged]
 nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch removed from -mm tree
Date: Mon, 23 Jun 2014 13:09:52 -0700
Message-ID: <53a88990.wBDlAwjDn5IzrIPj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, mguzik@redhat.com, dzickus@redhat.com, davem@davemloft.net, atomlin@redhat.com, sfr@canb.auug.org.au


The patch titled
     Subject: nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix
has been removed from the -mm tree.  Its filename was
     nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

This patch was dropped because it was folded into nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix

undo C99ism

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/process_64.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/sparc/kernel/process_64.c~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix
+++ a/arch/sparc/kernel/process_64.c
@@ -261,10 +261,12 @@ void arch_trigger_all_cpu_backtrace(bool
 	smp_fetch_global_regs();
 
 	for_each_online_cpu(cpu) {
+		struct global_reg_snapshot *gp;
+
 		if (!include_self && cpu == this_cpu)
 			continue;
 
-		struct global_reg_snapshot *gp = &global_cpu_snapshot[cpu].reg;
+		gp = &global_cpu_snapshot[cpu].reg;
 
 		__global_reg_poll(gp);
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

