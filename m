From: akpm@linux-foundation.org
Subject: - make-ptrace_untrace-static.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:51 -0700
Message-ID: <200810202036.m9KKapaR011473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbYJTUrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     make ptrace_untrace() static
has been removed from the -mm tree.  Its filename was
     make-ptrace_untrace-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make ptrace_untrace() static
From: Adrian Bunk <bunk@kernel.org>

ptrace_untrace() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 kernel/ptrace.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/ptrace.h~make-ptrace_untrace-static include/linux/ptrace.h
--- a/include/linux/ptrace.h~make-ptrace_untrace-static
+++ a/include/linux/ptrace.h
@@ -94,7 +94,6 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void ptrace_untrace(struct task_struct *child);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
diff -puN kernel/ptrace.c~make-ptrace_untrace-static kernel/ptrace.c
--- a/kernel/ptrace.c~make-ptrace_untrace-static
+++ a/kernel/ptrace.c
@@ -45,7 +45,7 @@ void __ptrace_link(struct task_struct *c
  * TASK_TRACED, resume it now.
  * Requires that irqs be disabled.
  */
-void ptrace_untrace(struct task_struct *child)
+static void ptrace_untrace(struct task_struct *child)
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch

