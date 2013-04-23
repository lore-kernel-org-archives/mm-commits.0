From: akpm@linux-foundation.org
Subject: + kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch added to -mm tree
Date: Tue, 23 Apr 2013 16:24:56 -0700
Message-ID: <20130423232456.CEBF731C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:37606 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3DWXY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 19:24:59 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so52565veb.5
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 16:24:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, jason.wessel@windriver.com


The patch titled
     Subject: kgdb/sysrq: fix inconstistent help message of sysrq key
has been added to the -mm tree.  Its filename is
     kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

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
Subject: kgdb/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlight its upper-case
characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix kgdb sysrq key: "debug(g)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/debug/debug_core.c~kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/kernel/debug/debug_core.c
@@ -775,7 +775,7 @@ static void sysrq_handle_dbg(int key)
 
 static struct sysrq_key_op sysrq_dbg_op = {
 	.handler	= sysrq_handle_dbg,
-	.help_msg	= "debug(G)",
+	.help_msg	= "debug(g)",
 	.action_msg	= "DEBUG",
 };
 #endif
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

