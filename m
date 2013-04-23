From: akpm@linux-foundation.org
Subject: + power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch added to -mm tree
Date: Tue, 23 Apr 2013 16:24:58 -0700
Message-ID: <20130423232458.D0DC431C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54221 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3DWXZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 19:25:00 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so133032vbb.3
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 16:24:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, benh@kernel.crashing.org


The patch titled
     Subject: power/sysrq: fix inconstistent help message of sysrq key
has been added to the -mm tree.  Its filename is
     power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

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
Subject: power/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix power off sysrq key: "poweroff(o)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/poweroff.c~power-sysrq-fix-inconstistent-help-message-of-sysrq-key kernel/power/poweroff.c
--- a/kernel/power/poweroff.c~power-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/kernel/power/poweroff.c
@@ -32,7 +32,7 @@ static void handle_poweroff(int key)
 
 static struct sysrq_key_op	sysrq_poweroff_op = {
 	.handler        = handle_poweroff,
-	.help_msg       = "powerOff",
+	.help_msg       = "poweroff(o)",
 	.action_msg     = "Power Off",
 	.enable_mask	= SYSRQ_ENABLE_BOOT,
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

