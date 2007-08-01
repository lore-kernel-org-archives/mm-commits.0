From: akpm@linux-foundation.org
Subject: - fix-leak-on-proc-lockdep_stats.patch removed from -mm tree
Date: Tue, 31 Jul 2007 18:02:43 -0700
Message-ID: <200708010102.l7112hh4031998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293AbXHABED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 21:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix leak on /proc/lockdep_stats
has been removed from the -mm tree.  Its filename was
     fix-leak-on-proc-lockdep_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix leak on /proc/lockdep_stats
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep_proc.c~fix-leak-on-proc-lockdep_stats kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~fix-leak-on-proc-lockdep_stats
+++ a/kernel/lockdep_proc.c
@@ -160,7 +160,7 @@ static const struct file_operations proc
 	.open		= lockdep_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release,
 };
 
 static void lockdep_stats_debug_show(struct seq_file *m)
@@ -346,7 +346,7 @@ static const struct file_operations proc
 	.open		= lockdep_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 #ifdef CONFIG_LOCK_STAT
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
single_open-seq_release-leak-diagnostics.patch
