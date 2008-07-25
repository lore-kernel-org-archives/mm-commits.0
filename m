From: akpm@linux-foundation.org
Subject: - kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:36 -0700
Message-ID: <200807252259.m6PMxajx003403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYGYXAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@las.ic.unicamp.br, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kernel/signal.c: change vars pid and tgid types to pid_t
has been removed from the -mm tree.  Its filename was
     kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/signal.c: change vars pid and tgid types to pid_t
From: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>

Change the type of pid and tgid variables from int to the POSIX type
pid_t.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t
+++ a/kernel/signal.c
@@ -1116,7 +1116,7 @@ EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
  * is probably wrong.  Should make it like BSD or SYSV.
  */
 
-static int kill_something_info(int sig, struct siginfo *info, int pid)
+static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 {
 	int ret;
 
@@ -2184,7 +2184,7 @@ sys_rt_sigtimedwait(const sigset_t __use
 }
 
 asmlinkage long
-sys_kill(int pid, int sig)
+sys_kill(pid_t pid, int sig)
 {
 	struct siginfo info;
 
@@ -2197,7 +2197,7 @@ sys_kill(int pid, int sig)
 	return kill_something_info(sig, &info, pid);
 }
 
-static int do_tkill(int tgid, int pid, int sig)
+static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
 	int error;
 	struct siginfo info;
@@ -2243,7 +2243,7 @@ static int do_tkill(int tgid, int pid, i
  *  exists but it's not belonging to the target process anymore. This
  *  method solves the problem of threads exiting and PIDs getting reused.
  */
-asmlinkage long sys_tgkill(int tgid, int pid, int sig)
+asmlinkage long sys_tgkill(pid_t tgid, pid_t pid, int sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0 || tgid <= 0)
@@ -2256,7 +2256,7 @@ asmlinkage long sys_tgkill(int tgid, int
  *  Send a signal to only one task, even if it's a CLONE_THREAD task.
  */
 asmlinkage long
-sys_tkill(int pid, int sig)
+sys_tkill(pid_t pid, int sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0)
@@ -2266,7 +2266,7 @@ sys_tkill(int pid, int sig)
 }
 
 asmlinkage long
-sys_rt_sigqueueinfo(int pid, int sig, siginfo_t __user *uinfo)
+sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
 {
 	siginfo_t info;
 
_

Patches currently in -mm which might be from gustavo@las.ic.unicamp.br are

origin.patch

