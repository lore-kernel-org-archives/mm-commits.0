From: akpm@linux-foundation.org
Subject: + spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch added to -mm tree
Date: Tue, 23 Apr 2013 16:25:04 -0700
Message-ID: <20130423232504.D753331C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34730 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3DWXZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 19:25:05 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so129324ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 16:25:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, davem@davemloft.net


The patch titled
     Subject: sparc/sysrq: fix inconstistent help message of sysrq key
has been added to the -mm tree.  Its filename is
     spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
printk-tracing-rework-console-tracing.patch
relay-remove-unused-function-argument-actor.patch
relay-move-fix_size-macro-into-relayc.patch
relay-use-macro-page_align-instead-of-fix_size.patch
relay-fix-timer-madness.patch
kernel-relayc-move-remove_buf_file-inside-relay_close_buf.patch
init-kconfig-make-expert-as-config-instead-of-menuconfig.patch
kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

