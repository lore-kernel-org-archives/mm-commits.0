From: akpm@linux-foundation.org
Subject: [merged] kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:16 -0700
Message-ID: <20130507175116.7A46231C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47646 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:17 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so86409yen.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
relay-fix-timer-madness.patch

