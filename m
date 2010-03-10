From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:30:03 -0800
Message-ID: <201003102030.o2AKU3uM001946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050Ab0CJUao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, Joel.Becker@oracle.com, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-comm


The patch titled
     sysctl: use RCU protected sysctl for ocfs group add helper
has been removed from the -mm tree.  Its filename was
     sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: use RCU protected sysctl for ocfs group add helper
From: Andi Kleen <andi@firstfloor.org>

This avoids races with unlocked sysctl()

Also saves ~220 bytes in the data segment.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/stackglue.c~sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper
+++ a/fs/ocfs2/stackglue.c
@@ -27,6 +27,7 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/sysctl.h>
+#include <linux/rcustring.h>
 
 #include "ocfs2_fs.h"
 
@@ -40,7 +41,7 @@ static struct ocfs2_protocol_version loc
 static DEFINE_SPINLOCK(ocfs2_stack_lock);
 static LIST_HEAD(ocfs2_stack_list);
 static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
-static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
+static char *ocfs2_hb_ctl_path = "/sbin/ocfs2_hb_ctl";
 
 /*
  * The stack currently in use.  If not null, active_stack->sp_count > 0,
@@ -420,8 +421,15 @@ static void ocfs2_leave_group(const char
 {
 	int ret;
 	char *argv[5], *envp[3];
+	char *helper;
 
-	argv[0] = ocfs2_hb_ctl_path;
+	helper = access_rcu_string(&ocfs2_hb_ctl_path, OCFS2_MAX_HB_CTL_PATH, GFP_KERNEL);
+	if (!helper) {
+		printk(KERN_ERR "ocfs2_leave_group: no memory\n");
+		return;
+	}
+
+	argv[0] = helper;
 	argv[1] = "-K";
 	argv[2] = "-u";
 	argv[3] = (char *)group;
@@ -439,6 +447,7 @@ static void ocfs2_leave_group(const char
 		       "\"%s %s %s %s\"\n",
 		       ret, argv[0], argv[1], argv[2], argv[3]);
 	}
+	kfree(helper);
 }
 
 /*
@@ -646,10 +655,10 @@ error:
 static ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
-		.data		= ocfs2_hb_ctl_path,
+		.data		= &ocfs2_hb_ctl_path,
 		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 	{ }
 };
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
modpost-support-objects-with-more-than-64k-sections.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

