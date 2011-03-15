From: akpm@linux-foundation.org
Subject: + sysctl-restrict-write-access-to-dmesg_restrict.patch added to -mm tree
Date: Tue, 15 Mar 2011 14:50:24 -0700
Message-ID: <201103152150.p2FLoOFt013916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758129Ab1COVuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 17:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, drosenberg@vsecurity.com, eparis@redhat.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.com, serge@hallyn.com


The patch titled
     sysctl: restrict write access to dmesg_restrict
has been added to the -mm tree.  Its filename is
     sysctl-restrict-write-access-to-dmesg_restrict.patch

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
Subject: sysctl: restrict write access to dmesg_restrict
From: Richard Weinberger <richard@nod.at>

When dmesg_restrict is set to 1 CAP_SYS_ADMIN is needed to read the kernel
ring buffer.  But a root user without CAP_SYS_ADMIN is able to reset
dmesg_restrict to 0.

This is an issue when e.g.  LXC (Linux Containers) are used and complete
user space is running without CAP_SYS_ADMIN.  A unprivileged and jailed
root user can bypass the dmesg_restrict protection.

With this patch writing to dmesg_restrict is only allowed when root has
CAP_SYS_ADMIN.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eugene Teo <eugeneteo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-restrict-write-access-to-dmesg_restrict kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-restrict-write-access-to-dmesg_restrict
+++ a/kernel/sysctl.c
@@ -170,6 +170,11 @@ static int proc_taint(struct ctl_table *
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_PRINTK
+static int proc_dmesg_restrict(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
@@ -703,7 +708,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dmesg_restrict,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -2373,6 +2378,17 @@ static int proc_taint(struct ctl_table *
 	return err;
 }
 
+#ifdef CONFIG_PRINTK
+static int proc_dmesg_restrict(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+#endif
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
sysctl-restrict-write-access-to-dmesg_restrict.patch

