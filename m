From: akpm@linux-foundation.org
Subject: + proc-fix-stack_start-in-compat-mode.patch added to -mm tree
Date: Wed, 28 Oct 2009 12:35:55 -0700
Message-ID: <200910281935.n9SJZt6a019626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbZJ1Tf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 15:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, m.s.tsirkin@gmail.com, rjw@sisk.pl


The patch titled
     proc: fix ->stack_start in compat mode
has been added to the -mm tree.  Its filename is
     proc-fix-stack_start-in-compat-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
loop-fix-null-dereference-if-mount-fails.patch
sysctl-fix-false-positives-when-proc_sysctl=n.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
proc-fix-stack_start-in-compat-mode.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

