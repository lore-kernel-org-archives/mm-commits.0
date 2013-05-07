From: akpm@linux-foundation.org
Subject: [merged] ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:31 -0700
Message-ID: <20130507175131.825995A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:49748 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:32 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so86423ves.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, cascardo@linux.vnet.ibm.com, davem@davemloft.net, jwboyer@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ethernet/emac/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: ethernet/emac/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlight its upper-case
characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch ethernet emac sysrq key: "emac(c)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/ibm/emac/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ethernet/ibm/emac/debug.c~ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key drivers/net/ethernet/ibm/emac/debug.c
--- a/drivers/net/ethernet/ibm/emac/debug.c~ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/drivers/net/ethernet/ibm/emac/debug.c
@@ -245,7 +245,7 @@ static void emac_sysrq_handler(int key)
 
 static struct sysrq_key_op emac_sysrq_op = {
 	.handler = emac_sysrq_handler,
-	.help_msg = "emaC",
+	.help_msg = "emac(c)",
 	.action_msg = "Show EMAC(s) status",
 };
 
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-fix-timer-madness.patch

