From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-use-proc_dointvec_bool-where-appropriate.patch removed from -mm tree
Date: Thu, 18 Aug 2011 14:52:31 -0700
Message-ID: <201108182152.p7ILqV6g029857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab1HRVwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: use proc_dointvec_bool() where appropriate
has been removed from the -mm tree.  Its filename was
     sysctl-use-proc_dointvec_bool-where-appropriate.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: use proc_dointvec_bool() where appropriate
From: Dave Young <hidave.darkstar@gmail.com>

Use the new proc_do_intvec_bool() handler for various boolean inputs.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN kernel/sysctl.c~sysctl-use-proc_dointvec_bool-where-appropriate kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-use-proc_dointvec_bool-where-appropriate
+++ a/kernel/sysctl.c
@@ -349,9 +349,7 @@ static struct ctl_table kern_table[] = {
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
@@ -709,9 +707,7 @@ static struct ctl_table kern_table[] = {
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
@@ -754,9 +750,7 @@ static struct ctl_table kern_table[] = {
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
@@ -870,9 +864,7 @@ static struct ctl_table kern_table[] = {
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
@@ -1320,9 +1312,7 @@ static struct ctl_table vm_table[] = {
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
@@ -1338,18 +1328,14 @@ static struct ctl_table vm_table[] = {
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

sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-add-proc_dointvec_unsigned-handler-update.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

