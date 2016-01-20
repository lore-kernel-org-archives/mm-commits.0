From: akpm@linux-foundation.org
Subject: [folded-merged]
 ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 14:34:33 -0800
Message-ID: <56a00b79.51sRMOI9AWBCSZUq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbcATWee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix
has been removed from the -mm tree.  Its filename was
     ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch

This patch was dropped because it was folded into ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix

teeny cleanup

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix kernel/exit.c
--- a/kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix
+++ a/kernel/exit.c
@@ -1120,8 +1120,7 @@ static int wait_task_zombie(struct wait_
 static int *task_stopped_code(struct task_struct *p, bool ptrace)
 {
 	if (ptrace) {
-		if (task_is_traced(p) &&
-		    !(p->jobctl & JOBCTL_LISTENING))
+		if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
 			return &p->exit_code;
 	} else {
 		if (p->signal->flags & SIGNAL_STOP_STOPPED)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch

