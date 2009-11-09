From: akpm@linux-foundation.org
Subject: [merged] proc-fix-stack_start-in-compat-mode.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:27 -0800
Message-ID: <200911091954.nA9JsRBw021559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZKITyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:54:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, m.s.tsirkin@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     proc: fix ->stack_start in compat mode
has been removed from the -mm tree.  Its filename was
     proc-fix-stack_start-in-compat-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix ->stack_start in compat mode
From: Alexey Dobriyan <adobriyan@gmail.com>

Assign tsk->stack_start even when doing compat execve(2).

As side effect, fix segfault inside boehm-gc library.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14478

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/compat.c~proc-fix-stack_start-in-compat-mode fs/compat.c
--- a/fs/compat.c~proc-fix-stack_start-in-compat-mode
+++ a/fs/compat.c
@@ -1531,6 +1531,8 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
uml-irq-register-race-condition.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

