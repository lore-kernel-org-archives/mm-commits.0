From: akpm@linux-foundation.org
Subject: [merged] arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:22 -0700
Message-ID: <20130507175122.8126031C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55657 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:23 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so86509qcz.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, linux@arm.linux.org.uk, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM/etm/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: ARM/etm/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlights its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix arm etm sysrq key: "etm-buffer-dump(v)"
(This patch also add "-" to separate each sysrq key help word,
instead of spaces)

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/etm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/kernel/etm.c~arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key arch/arm/kernel/etm.c
--- a/arch/arm/kernel/etm.c~arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/arch/arm/kernel/etm.c
@@ -254,7 +254,7 @@ static void sysrq_etm_dump(int key)
 
 static struct sysrq_key_op sysrq_etm_op = {
 	.handler = sysrq_etm_dump,
-	.help_msg = "ETM buffer dump",
+	.help_msg = "etm-buffer-dump(v)",
 	.action_msg = "etm",
 };
 
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-fix-timer-madness.patch

