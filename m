From: akpm@linux-foundation.org
Subject: [merged] spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:28 -0700
Message-ID: <20130507175128.7A0E25A4525@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44514 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:29 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86374ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: sparc/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix spare sysrq key: "global-regs(y)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/process_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/kernel/process_64.c~spare-sysrq-fix-inconstistent-help-message-of-sysrq-key arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~spare-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/arch/sparc/kernel/process_64.c
@@ -294,7 +294,7 @@ static void sysrq_handle_globreg(int key
 
 static struct sysrq_key_op sparc_globalreg_op = {
 	.handler	= sysrq_handle_globreg,
-	.help_msg	= "global-regs(Y)",
+	.help_msg	= "global-regs(y)",
 	.action_msg	= "Show Global CPU Regs",
 };
 
@@ -364,7 +364,7 @@ static void sysrq_handle_globpmu(int key
 
 static struct sysrq_key_op sparc_globalpmu_op = {
 	.handler	= sysrq_handle_globpmu,
-	.help_msg	= "global-pmu(X)",
+	.help_msg	= "global-pmu(x)",
 	.action_msg	= "Show Global PMU Regs",
 };
 
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-fix-timer-madness.patch

