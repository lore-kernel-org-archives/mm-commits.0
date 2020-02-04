From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kdb-kdb_current_task-shouldnt-be-exported.patch
 removed from -mm tree
Date: Mon, 03 Feb 2020 17:48:39 -0800
Message-ID: <20200204014839.6xb0DVEj0%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBsk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:48:40 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, daniel.thompson@linaro.org, dianders@chromium.org, ebiederm@xmission.com, f4bug@amsat.org, fancer.lancer@gmail.com, jason.wessel@windriver.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paul.burton@mips.com, qiaochong@loongson.cn, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: kdb: kdb_current_task shouldn't be exported
has been removed from the -mm tree.  Its filename was
     kdb-kdb_current_task-shouldnt-be-exported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: kdb: kdb_current_task shouldn't be exported

The kdb_current_task variable has been declared in
"kernel/debug/kdb/kdb_private.h" since 2010 when kdb was added to the
mainline kernel.  This is not a public header.  There should be no reason
that kdb_current_task should be exported and there are no in-kernel users
that need it.  Remove the export.

Link: http://lkml.kernel.org/r/20191109111623.3.I14b22b5eb15ca8f3812ab33e96621231304dc1f7@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: Chong Qiao <qiaochong@loongson.cn>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Philippe Mathieu-Daud <f4bug@amsat.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/debug/kdb/kdb_main.c~kdb-kdb_current_task-shouldnt-be-exported
+++ a/kernel/debug/kdb/kdb_main.c
@@ -73,7 +73,6 @@ int kdb_nextline = 1;
 int kdb_state;			/* General KDB state */
 
 struct task_struct *kdb_current_task;
-EXPORT_SYMBOL(kdb_current_task);
 struct pt_regs *kdb_current_regs;
 
 const char *kdb_diemsg;
_

Patches currently in -mm which might be from dianders@chromium.org are

kdb-gid-rid-of-implicit-setting-of-the-current-task-regs.patch
kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
