From: akpm@linux-foundation.org
Subject: + restrict-unprivileged-access-to-kernel-syslog.patch added to -mm tree
Date: Wed, 10 Nov 2010 15:50:13 -0800
Message-ID: <201011102350.oAANoD5Z013214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757322Ab0KJXvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 18:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, eugeneteo@kernel.org, kees.cook@canonical.com, mingo@elte.hu, torvalds@linux-foundation.org


The patch titled
     Restrict unprivileged access to kernel syslog
has been added to the -mm tree.  Its filename is
     restrict-unprivileged-access-to-kernel-syslog.patch

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
Subject: Restrict unprivileged access to kernel syslog
From: Dan Rosenberg <drosenberg@vsecurity.com>

The kernel syslog contains debugging information that is often useful
during exploitation of other vulnerabilities, such as kernel heap
addresses.  Rather than futilely attempt to sanitize hundreds (or
thousands) of printk statements and simultaneously cripple useful
debugging functionality, it is far simpler to create an option that
prevents unprivileged users from reading the syslog.

This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
dmesg_restrict sysctl.  When set to "0", the default, no restrictions are
enforced.  When set to "1", only users with CAP_SYS_ADMIN can read the
kernel syslog via dmesg(8) or other mechanisms.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Eugene Teo <eugeneteo@kernel.org>
Acked-by: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   11 +++++++++++
 include/linux/kernel.h          |    1 +
 kernel/printk.c                 |    6 ++++++
 kernel/sysctl.c                 |    9 +++++++++
 security/Kconfig                |   12 ++++++++++++
 security/commoncap.c            |    2 ++
 6 files changed, 41 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog
+++ a/Documentation/sysctl/kernel.txt
@@ -28,6 +28,7 @@ show up in /proc/sys/kernel:
 - core_uses_pid
 - ctrl-alt-del
 - dentry-state
+- dmesg_restrict
 - domainname
 - hostname
 - hotplug
@@ -213,6 +214,16 @@ to decide what to do with it.
 
 ==============================================================
 
+dmesg_restrict:
+
+This toggle indicates whether unprivileged users are prevented
+from using dmesg(8) to view messages from the kernel's log
+buffer.  By default, it is set to (0), resulting in no
+restrictions.  When set to (1), users must have CAP_SYS_ADMIN
+to use dmesg(8).
+
+==============================================================
+
 domainname & hostname:
 
 These files can be used to set the NIS/YP domainname and the
diff -puN include/linux/kernel.h~restrict-unprivileged-access-to-kernel-syslog include/linux/kernel.h
--- a/include/linux/kernel.h~restrict-unprivileged-access-to-kernel-syslog
+++ a/include/linux/kernel.h
@@ -295,6 +295,7 @@ extern bool printk_timed_ratelimit(unsig
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
+extern int dmesg_restrict;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
diff -puN kernel/printk.c~restrict-unprivileged-access-to-kernel-syslog kernel/printk.c
--- a/kernel/printk.c~restrict-unprivileged-access-to-kernel-syslog
+++ a/kernel/printk.c
@@ -261,6 +261,12 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	unsigned i, j, limit, count;
diff -puN kernel/sysctl.c~restrict-unprivileged-access-to-kernel-syslog kernel/sysctl.c
--- a/kernel/sysctl.c~restrict-unprivileged-access-to-kernel-syslog
+++ a/kernel/sysctl.c
@@ -704,6 +704,15 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
+		.procname	= "dmesg_restrict",
+		.data		= &dmesg_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
 		.maxlen		= sizeof (int),
diff -puN security/Kconfig~restrict-unprivileged-access-to-kernel-syslog security/Kconfig
--- a/security/Kconfig~restrict-unprivileged-access-to-kernel-syslog
+++ a/security/Kconfig
@@ -39,6 +39,18 @@ config KEYS_DEBUG_PROC_KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config SECURITY_DMESG_RESTRICT
+	bool "Restrict unprivileged access to the kernel syslog"
+	default n
+	help
+	  This enforces restrictions on unprivileged users reading the kernel
+	  syslog via dmesg(8).
+
+	  If this option is not selected, no restrictions will be enforced
+	  unless the dmesg_restrict sysctl is explicitly set to (1).
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
diff -puN security/commoncap.c~restrict-unprivileged-access-to-kernel-syslog security/commoncap.c
--- a/security/commoncap.c~restrict-unprivileged-access-to-kernel-syslog
+++ a/security/commoncap.c
@@ -895,6 +895,8 @@ int cap_syslog(int type, bool from_file)
 {
 	if (type != SYSLOG_ACTION_OPEN && from_file)
 		return 0;
+	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	if ((type != SYSLOG_ACTION_READ_ALL &&
 	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

restrict-unprivileged-access-to-kernel-syslog.patch
restrict-unprivileged-access-to-kernel-syslog-checkpatch-fixes.patch
restrict-unprivileged-access-to-kernel-syslog-fix.patch

