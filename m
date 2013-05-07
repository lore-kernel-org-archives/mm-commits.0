From: akpm@linux-foundation.org
Subject: [merged] power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:19 -0700
Message-ID: <20130507175119.7C4C25A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:51450 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:20 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so86399yho.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: power/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
relay-fix-timer-madness.patch

