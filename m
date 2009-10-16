From: akpm@linux-foundation.org
Subject: + sysctl-fix-false-positives-when-proc_sysctl=n.patch added to -mm tree
Date: Thu, 15 Oct 2009 18:02:41 -0700
Message-ID: <200910160102.n9G12fZu008481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244AbZJPBDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 21:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com, htmldeveloper@gmail.com, rjw@sisk.pl


The patch titled
     sysctl: fix false positives when PROC_SYSCTL=n
has been added to the -mm tree.  Its filename is
     sysctl-fix-false-positives-when-proc_sysctl=n.patch

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

 kernel/sysctl_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
loop-fix-null-dereference-if-mount-fails.patch
sysctl-fix-false-positives-when-proc_sysctl=n.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

