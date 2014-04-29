From: akpm@linux-foundation.org
Subject: +
 nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch added to -mm tree
Date: Tue, 29 Apr 2014 15:04:32 -0700
Message-ID: <536021f0.GELvsQmErqJIh2WJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881AbaD2WEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 18:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, mguzik@redhat.com, dzickus@redhat.com, davem@davemloft.net, atomlin@redhat.com, sfr@canb.auug.org.au

Subject: + nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch added to -mm tree
To: sfr@canb.auug.org.au,atomlin@redhat.com,davem@davemloft.net,dzickus@redhat.com,mguzik@redhat.com,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 15:04:32 -0700


The patch titled
     Subject: nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix
has been added to the -mm tree.  Its filename is
     nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

