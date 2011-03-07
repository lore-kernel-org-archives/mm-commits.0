From: akpm@linux-foundation.org
Subject: + sysctl-use-proc_dointvec_bool-where-appropriate.patch added to -mm tree
Date: Mon, 07 Mar 2011 15:05:41 -0800
Message-ID: <201103072305.p27N5fiQ000471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385Ab1CGXOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysctl: use proc_dointvec_bool() where appropriate
has been added to the -mm tree.  Its filename is
     sysctl-use-proc_dointvec_bool-where-appropriate.patch

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
Subject: sysctl: use proc_dointvec_bool() where appropriate
From: Dave Young <hidave.darkstar@gmail.com>

Use the new proc_do_intvec_bool() handler for various boolean inputs.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN kernel/sysctl.c~sysctl-use-proc_dointvec_bool-where-appropriate kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-use-proc_dointvec_bool-where-appropriate
+++ a/kernel/sysctl.c
@@ -342,9 +342,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 	{
@@ -697,9 +695,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname	= "kptr_restrict",
@@ -740,9 +736,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname       = "nmi_watchdog",
@@ -854,9 +848,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname	= "hung_task_check_count",
@@ -1290,9 +1282,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_highmem_is_dirtyable,
 		.maxlen		= sizeof(vm_highmem_is_dirtyable),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 	{
@@ -1308,18 +1298,14 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_memory_failure_early_kill,
 		.maxlen		= sizeof(sysctl_memory_failure_early_kill),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname	= "memory_failure_recovery",
 		.data		= &sysctl_memory_failure_recovery,
 		.maxlen		= sizeof(sysctl_memory_failure_recovery),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 	{ }
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

