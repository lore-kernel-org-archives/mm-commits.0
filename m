From: akpm@linux-foundation.org
Subject: +
 kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
 added to -mm tree
Date: Tue, 28 Jan 2020 17:43:30 -0800
Message-ID: <20200129014330.hPbNbfOEV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgA2Bnc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jan 2020 20:43:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, daniel.thompson@linaro.org, dianders@chromium.org, ebiederm@xmission.com, f4bug@amsat.org, fancer.lancer@gmail.com, jason.wessel@windriver.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paul.burton@mips.com, qiaochong@loongson.cn, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: kdb: get rid of confusing diag msg from "rd" if current task has no regs
has been added to the -mm tree.  Its filename is
     kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus.patch
kdb-kdb_current_regs-should-be-private.patch
kdb-kdb_current_task-shouldnt-be-exported.patch
kdb-gid-rid-of-implicit-setting-of-the-current-task-regs.patch
kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
