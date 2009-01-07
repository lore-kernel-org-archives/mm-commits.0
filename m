From: akpm@linux-foundation.org
Subject: - sysrq-more-explicit-less-terse-help-messages.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:21 -0800
Message-ID: <200901072216.n07MGLQU016059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761029AbZAGWQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, 330403@bugs.debian.org, jidanni@jidanni.org, mm-commits@vger.kernel.org


The patch titled
     sysrq: more explicit, less terse help messages
has been removed from the -mm tree.  Its filename was
     sysrq-more-explicit-less-terse-help-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: more explicit, less terse help messages
From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate sysrq terse help mode; make sysrq help messages more meaningful
(more explicit/verbose).  Make the sysrq action letter clearer by listing
it explicitly in more sysrq help messages (when it is not simple/clear).

The SysRq help message now looks like this:

SysRq : HELP : loglevel(0-9) reBoot terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W)

Addresses http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=330403.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <jidanni@jidanni.org>
Cc: <330403@bugs.debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/char/sysrq.c~sysrq-more-explicit-less-terse-help-messages drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-more-explicit-less-terse-help-messages
+++ a/drivers/char/sysrq.c
@@ -82,7 +82,7 @@ static void sysrq_handle_loglevel(int ke
 }
 static struct sysrq_key_op sysrq_loglevel_op = {
 	.handler	= sysrq_handle_loglevel,
-	.help_msg	= "loglevel0-8",
+	.help_msg	= "loglevel(0-9)",
 	.action_msg	= "Changing Loglevel",
 	.enable_mask	= SYSRQ_ENABLE_LOG,
 };
@@ -233,7 +233,7 @@ static void sysrq_handle_showallcpus(int
 
 static struct sysrq_key_op sysrq_showallcpus_op = {
 	.handler	= sysrq_handle_showallcpus,
-	.help_msg	= "aLlcpus",
+	.help_msg	= "show-backtrace-all-active-cpus(L)",
 	.action_msg	= "Show backtrace of all active CPUs",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -247,7 +247,7 @@ static void sysrq_handle_showregs(int ke
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
-	.help_msg	= "showPc",
+	.help_msg	= "show-registers(P)",
 	.action_msg	= "Show Regs",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -258,7 +258,7 @@ static void sysrq_handle_showstate(int k
 }
 static struct sysrq_key_op sysrq_showstate_op = {
 	.handler	= sysrq_handle_showstate,
-	.help_msg	= "showTasks",
+	.help_msg	= "show-task-states(T)",
 	.action_msg	= "Show State",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -269,7 +269,7 @@ static void sysrq_handle_showstate_block
 }
 static struct sysrq_key_op sysrq_showstate_blocked_op = {
 	.handler	= sysrq_handle_showstate_blocked,
-	.help_msg	= "shoW-blocked-tasks",
+	.help_msg	= "show-blocked-tasks(W)",
 	.action_msg	= "Show Blocked State",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -297,7 +297,7 @@ static void sysrq_handle_showmem(int key
 }
 static struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
-	.help_msg	= "showMem",
+	.help_msg	= "show-memory-usage(M)",
 	.action_msg	= "Show Memory",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
@@ -323,7 +323,7 @@ static void sysrq_handle_term(int key, s
 }
 static struct sysrq_key_op sysrq_term_op = {
 	.handler	= sysrq_handle_term,
-	.help_msg	= "tErm",
+	.help_msg	= "terminate-all-tasks(E)",
 	.action_msg	= "Terminate All Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -341,7 +341,7 @@ static void sysrq_handle_moom(int key, s
 }
 static struct sysrq_key_op sysrq_moom_op = {
 	.handler	= sysrq_handle_moom,
-	.help_msg	= "Full",
+	.help_msg	= "memory-full-oom-kill(F)",
 	.action_msg	= "Manual OOM execution",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -353,7 +353,7 @@ static void sysrq_handle_kill(int key, s
 }
 static struct sysrq_key_op sysrq_kill_op = {
 	.handler	= sysrq_handle_kill,
-	.help_msg	= "kIll",
+	.help_msg	= "kill-all-tasks(I)",
 	.action_msg	= "Kill All Tasks",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
@@ -364,7 +364,7 @@ static void sysrq_handle_unrt(int key, s
 }
 static struct sysrq_key_op sysrq_unrt_op = {
 	.handler	= sysrq_handle_unrt,
-	.help_msg	= "Nice",
+	.help_msg	= "nice-all-RT-tasks(N)",
 	.action_msg	= "Nice All RT Tasks",
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

