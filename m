From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
 removed from -mm tree
Date: Mon, 03 Feb 2020 17:48:45 -0800
Message-ID: <20200204014845.oZoLstrLM%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBss (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:48:48 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, daniel.thompson@linaro.org, dianders@chromium.org, ebiederm@xmission.com, f4bug@amsat.org, fancer.lancer@gmail.com, jason.wessel@windriver.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paul.burton@mips.com, qiaochong@loongson.cn, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: kdb: get rid of confusing diag msg from "rd" if current task has no regs
has been removed from the -mm tree.  Its filename was
     kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: kdb: get rid of confusing diag msg from "rd" if current task has no regs

If you switch to a sleeping task with the "pid" command and then type
"rd", kdb tells you this:

  No current kdb registers.  You may need to select another task
  diag: -17: Invalid register name

The first message makes sense, but not the second.  Fix it by just
returning 0 after commands accessing the current registers finish if we've
already printed the "No current kdb registers" error.

While fixing kdb_rd(), change the function to use "if" rather than
"ifdef".  It cleans the function up a bit and any modern compiler will
have no trouble handling still producing good code.

Link: http://lkml.kernel.org/r/20191109111624.5.I121f4c6f0c19266200bf6ef003de78841e5bfc3d@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Chong Qiao <qiaochong@loongson.cn>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: James Hogan <jhogan@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Philippe Mathieu-Daud <f4bug@amsat.org>
Cc: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_main.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/kernel/debug/kdb/kdb_main.c~kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs
+++ a/kernel/debug/kdb/kdb_main.c
@@ -543,9 +543,8 @@ int kdbgetaddrarg(int argc, const char *
 		if (diag)
 			return diag;
 	} else if (symname[0] == '%') {
-		diag = kdb_check_regs();
-		if (diag)
-			return diag;
+		if (kdb_check_regs())
+			return 0;
 		/* Implement register values with % at a later time as it is
 		 * arch optional.
 		 */
@@ -1836,8 +1835,7 @@ static int kdb_go(int argc, const char *
  */
 static int kdb_rd(int argc, const char **argv)
 {
-	int len = kdb_check_regs();
-#if DBG_MAX_REG_NUM > 0
+	int len = 0;
 	int i;
 	char *rname;
 	int rsize;
@@ -1846,8 +1844,14 @@ static int kdb_rd(int argc, const char *
 	u16 reg16;
 	u8 reg8;
 
-	if (len)
-		return len;
+	if (kdb_check_regs())
+		return 0;
+
+	/* Fallback to Linux showregs() if we don't have DBG_MAX_REG_NUM */
+	if (DBG_MAX_REG_NUM <= 0) {
+		kdb_dumpregs(kdb_current_regs);
+		return 0;
+	}
 
 	for (i = 0; i < DBG_MAX_REG_NUM; i++) {
 		rsize = dbg_reg_def[i].size * 2;
@@ -1889,12 +1893,7 @@ static int kdb_rd(int argc, const char *
 		}
 	}
 	kdb_printf("\n");
-#else
-	if (len)
-		return len;
 
-	kdb_dumpregs(kdb_current_regs);
-#endif
 	return 0;
 }
 
@@ -1928,9 +1927,8 @@ static int kdb_rm(int argc, const char *
 	if (diag)
 		return diag;
 
-	diag = kdb_check_regs();
-	if (diag)
-		return diag;
+	if (kdb_check_regs())
+		return 0;
 
 	diag = KDB_BADREG;
 	for (i = 0; i < DBG_MAX_REG_NUM; i++) {
_

Patches currently in -mm which might be from dianders@chromium.org are
