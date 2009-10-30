From: akpm@linux-foundation.org
Subject: [merged] sysctl-fix-false-positives-when-proc_sysctl=n.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:51:25 -0700
Message-ID: <200910302051.n9UKpPrh012974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932405AbZJ3UwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, htmldeveloper@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     sysctl: fix false positives when PROC_SYSCTL=n
has been removed from the -mm tree.  Its filename was
     sysctl-fix-false-positives-when-proc_sysctl=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: fix false positives when PROC_SYSCTL=n
From: Alexey Dobriyan <adobriyan@gmail.com>

Having ->procname but not ->proc_handler is valid when PROC_SYSCTL=n,
people use such combination to reduce ifdefs with non-standard handlers.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14408

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Peter Teoh <htmldeveloper@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/sysctl_check.c~sysctl-fix-false-positives-when-proc_sysctl=n kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-fix-false-positives-when-proc_sysctl=n
+++ a/kernel/sysctl_check.c
@@ -1521,7 +1521,7 @@ int sysctl_check_table(struct nsproxy *n
 			if (!table->ctl_name && table->strategy)
 				set_fail(&fail, table, "Strategy without ctl_name");
 #endif
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
proc-fix-stack_start-in-compat-mode.patch
uml-irq-register-race-condition.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

