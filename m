From: akpm@linux-foundation.org
Subject: [merged] powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:25 -0700
Message-ID: <20130507175125.79C8E5A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61858 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:26 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so86464vbe.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/xmon/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: powerpc/xmon/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix powerpc xmon sysrq key: "xmon(x)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/xmon/xmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/xmon/xmon.c~powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key arch/powerpc/xmon/xmon.c
--- a/arch/powerpc/xmon/xmon.c~powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/arch/powerpc/xmon/xmon.c
@@ -2947,7 +2947,7 @@ static void sysrq_handle_xmon(int key)
 
 static struct sysrq_key_op sysrq_xmon_op = {
 	.handler =	sysrq_handle_xmon,
-	.help_msg =	"Xmon",
+	.help_msg =	"xmon(x)",
 	.action_msg =	"Entering xmon",
 };
 
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-fix-timer-madness.patch

