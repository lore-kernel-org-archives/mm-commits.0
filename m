From: akpm@linux-foundation.org
Subject: + sysctl-fix-write-access-to-dmesg_restrict-kptr_restrict.patch added to -mm tree
Date: Fri, 06 Apr 2012 15:34:57 -0700
Message-ID: <20120406223457.C5F9BA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55084 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2DFWe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 18:34:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, plougher@redhat.com, richard@nod.at, serge.hallyn@canonical.com, stable@vger.kernel.org


The patch titled
     Subject: sysctl: fix write access to dmesg_restrict/kptr_restrict
has been added to the -mm tree.  Its filename is
     sysctl-fix-write-access-to-dmesg_restrict-kptr_restrict.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: fix write access to dmesg_restrict/kptr_restrict

Commit bfdc0b4 ("sysctl: restrict write access to dmesg_restrict") adds
code to restrict access to dmesg_restrict, however, it incorrectly alters
kptr_restrict rather than dmesg_restrict.

The original patch from Richard Weinberger
(https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as expected,
and so the patch seems to have been misapplied.

This adds the CAP_SYS_ADMIN check to both dmesg_restrict and
kptr_restrict, since both are sensitive.

Reported-by: Phillip Lougher <plougher@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Acked-by: Richard Weinberger <richard@nod.at>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~sysctl-fix-write-access-to-dmesg_restrict-kptr_restrict kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-write-access-to-dmesg_restrict-kptr_restrict
+++ a/kernel/sysctl.c
@@ -170,7 +170,7 @@ static int proc_taint(struct ctl_table *
 #endif
 
 #ifdef CONFIG_PRINTK
-static int proc_dmesg_restrict(struct ctl_table *table, int write,
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -703,7 +703,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -712,7 +712,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dmesg_restrict,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -1943,7 +1943,7 @@ static int proc_taint(struct ctl_table *
 }
 
 #ifdef CONFIG_PRINTK
-static int proc_dmesg_restrict(struct ctl_table *table, int write,
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (write && !capable(CAP_SYS_ADMIN))
_
Subject: Subject: sysctl: fix write access to dmesg_restrict/kptr_restrict

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
sysctl-fix-write-access-to-dmesg_restrict-kptr_restrict.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch

