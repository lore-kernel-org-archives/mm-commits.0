From: akpm@linux-foundation.org
Subject: + kptr_restrict-for-hiding-kernel-pointers-v4.patch added to -mm tree
Date: Mon, 20 Dec 2010 21:37:41 -0800
Message-ID: <201012210541.oBL5f7Bu021050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0LUFlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 00:41:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl, davem@davemloft.net, eparis@parisplace.org, eric.dumazet@gmail.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu, tgraf@infradead.org


The patch titled
     Subject: [PATCH v4] kptr_restrict for hiding kernel pointers
has been added to the -mm tree.  Its filename is
     kptr_restrict-for-hiding-kernel-pointers-v4.patch

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
Subject: Subject: [PATCH v4] kptr_restrict for hiding kernel pointers
From: Dan Rosenberg <drosenberg@vsecurity.com>

Add the %pK printk format specifier and
the /proc/sys/kernel/kptr_restrict sysctl.

The %pK format specifier is designed to hide exposed kernel pointers,
specifically via /proc interfaces.  Exposing these pointers provides an
easy target for kernel write vulnerabilities, since they reveal the
locations of writable structures containing easily triggerable function
pointers.  The behavior of %pK depends on the kptr_restrict sysctl.

If kptr_restrict is set to 0, no deviation from the standard %p behavior
occurs.  If kptr_restrict is set to 1, if the current user (intended to
be a reader via seq_printf(), etc.) does not have CAP_SYSLOG (which is
currently in the LSM tree), kernel pointers using %pK are printed as
0's.  If kptr_restrict is set to 2, kernel pointers using %pK are
printed as 0's regardless of privileges.  Replacing with 0's was chosen
over the default "(null)", which cannot be parsed by userland %p, which
expects "(nil)".

v4 incorporates Eric Paris' suggestion of using
has_capability_noaudit(), since failing this capability check is not a
policy violation but rather a code path choice and shouldn't generate
potentially excessive log noise.  Adjusted IRQ comment for clarity.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Graf <tgraf@infradead.org>
Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   16 ++++++++--------
 kernel/sysctl.c                 |    2 +-
 lib/vsprintf.c                  |   12 +++++++-----
 security/Kconfig                |   12 ------------
 4 files changed, 16 insertions(+), 26 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~kptr_restrict-for-hiding-kernel-pointers-v4 Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kptr_restrict-for-hiding-kernel-pointers-v4
+++ a/Documentation/sysctl/kernel.txt
@@ -264,14 +264,14 @@ This flag controls the L2 cache of G3 pr
 
 kptr_restrict:
 
-This toggle indicates whether unprivileged users are prevented from reading
-kernel addresses via /proc and other interfaces.  When kptr_restrict is set
-to (0), there are no restrictions.  When kptr_restrict is set to (1), kernel
-pointers printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.
-
-The kernel config option CONFIG_SECURITY_KPTR_RESTRICT sets the default
-value of kptr_restrict.
+This toggle indicates whether restrictions are placed on
+exposing kernel addresses via /proc and other interfaces.  When
+kptr_restrict is set to (0), the default, there are no
+restrictions.  When kptr_restrict is set to (1), kernel pointers
+printed using the %pK format specifier will be replaced with 0's
+unless the user has CAP_SYSLOG.  When kptr_restrict is set to
+(2), kernel pointers printed using %pK will be replaced with 0's
+regardless of privileges.
 
 ==============================================================
 
diff -puN kernel/sysctl.c~kptr_restrict-for-hiding-kernel-pointers-v4 kernel/sysctl.c
--- a/kernel/sysctl.c~kptr_restrict-for-hiding-kernel-pointers-v4
+++ a/kernel/sysctl.c
@@ -718,7 +718,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
-		.extra2		= &one,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "ngroups_max",
diff -puN lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v4 lib/vsprintf.c
--- a/lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v4
+++ a/lib/vsprintf.c
@@ -936,7 +936,7 @@ char *uuid_string(char *buf, char *end, 
 	return string(buf, end, uuid, spec);
 }
 
-int kptr_restrict = CONFIG_SECURITY_KPTR_RESTRICT;
+int kptr_restrict;
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
@@ -1040,8 +1040,8 @@ char *pointer(const char *fmt, char *buf
 				       *(((struct va_format *)ptr)->va));
 	case 'K':
 		/*
-		 * %pK cannot be used in IRQ context because it tests
-		 * CAP_SYSLOG.
+		 * %pK cannot be used in IRQ context because its test
+		 * for CAP_SYSLOG would be meaningless.
 		 */
 		if (in_irq() || in_serving_softirq() || in_nmi())
 			WARN_ONCE(1, "%%pK used in interrupt context.\n");
@@ -1049,8 +1049,10 @@ char *pointer(const char *fmt, char *buf
 		if (!kptr_restrict)
 			break;		/* %pK does not obscure pointers */
 
-		if (capable(CAP_SYSLOG))
-			break;		/* privileged apps expose pointers */
+		if ((kptr_restrict != 2) &&
+		    has_capability_noaudit(current, CAP_SYSLOG))
+			break;		/* privileged apps expose pointers,
+					   unless kptr_restrict is 2 */
 
 		if (spec.field_width == -1) {
 			spec.field_width = 2 * sizeof(void *);
diff -puN security/Kconfig~kptr_restrict-for-hiding-kernel-pointers-v4 security/Kconfig
--- a/security/Kconfig~kptr_restrict-for-hiding-kernel-pointers-v4
+++ a/security/Kconfig
@@ -82,18 +82,6 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
-config SECURITY_KPTR_RESTRICT
-	bool "Hide kernel pointers from unprivileged users"
-	default n
-	help
-	  This enforces restrictions on unprivileged users reading kernel
-	  addresses via various interfaces, e.g. /proc.
-
-	  If this option is not selected, no restrictions will be enforced
-	  unless the kptr_restrict sysctl is explicitly set to (1).
-
-	  If you are unsure how to answer this question, answer N.
