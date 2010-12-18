From: akpm@linux-foundation.org
Subject: + kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:54:22 -0800
Message-ID: <201012180054.oBI0sMMe006350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756582Ab0LRAy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, a.p.zijlstra@chello.nl, davem@davemloft.net, eric.dumazet@gmail.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu, tgraf@infradead.org


The patch titled
     kptr_restrict for hiding kernel pointers from unprivileged users
has been added to the -mm tree.  Its filename is
     kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch

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
Subject: kptr_restrict for hiding kernel pointers from unprivileged users
From: Dan Rosenberg <drosenberg@vsecurity.com>

Add the %pK printk format specifier, the CONFIG_SECURITY_KPTR_RESTRICT
configuration option, and the kptr_restrict sysctl.

The %pK format specifier is designed to hide exposed kernel pointers from
unprivileged users, specifically via /proc interfaces.  Its behavior
depends on the kptr_restrict sysctl, whose default value depends on
CONFIG_SECURITY_KPTR_RESTRICT.

If kptr_restrict is set to 0, no deviation from the standard %p behavior
occurs.  If kptr_restrict is set to 1, if the current user (intended to be
a reader via seq_printf(), etc.) does not have CAP_SYSLOG (which is
currently in the LSM tree), kernel pointers using %pK are printed as 0's. 
This was chosen over the default "(null)", which cannot be parsed by
userland %p, which expects "(nil)".

v2 improves checking for inappropriate context, on suggestion by Peter
Zijlstra.  Thanks to Thomas Graf for suggesting use of a centralized
format specifier.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Graf <tgraf@infradead.org>
Acked-by: Eugene Teo <eugeneteo@kernel.org>
Acked-by: Kees Cook <kees.cook@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   14 ++++++++++++++
 include/linux/kernel.h          |    2 ++
 kernel/sysctl.c                 |    9 +++++++++
 lib/vsprintf.c                  |   18 ++++++++++++++++++
 security/Kconfig                |   12 ++++++++++++
 5 files changed, 55 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users
+++ a/Documentation/sysctl/kernel.txt
@@ -34,6 +34,7 @@ show up in /proc/sys/kernel:
 - hotplug
 - java-appletviewer           [ binfmt_java, obsolete ]
 - java-interpreter            [ binfmt_java, obsolete ]
+- kptr_restrict
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
 - modprobe                    ==> Documentation/debugging-modules.txt
@@ -261,6 +262,19 @@ This flag controls the L2 cache of G3 pr
 
 ==============================================================
 
+kptr_restrict:
+
+This toggle indicates whether unprivileged users are prevented from reading
+kernel addresses via /proc and other interfaces.  When kptr_restrict is set
+to (0), there are no restrictions.  When kptr_restrict is set to (1), kernel
+pointers printed using the %pK format specifier will be replaced with 0's
+unless the user has CAP_SYSLOG.
+
+The kernel config option CONFIG_SECURITY_KPTR_RESTRICT sets the default
+value of kptr_restrict.
+
+==============================================================
+
 kstack_depth_to_print: (X86 only)
 
 Controls the number of words to print when dumping the raw
diff -puN include/linux/kernel.h~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users include/linux/kernel.h
--- a/include/linux/kernel.h~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users
+++ a/include/linux/kernel.h
@@ -216,6 +216,8 @@ extern int sscanf(const char *, const ch
 extern int vsscanf(const char *, const char *, va_list)
 	__attribute__ ((format (scanf, 2, 0)));
 
+extern int kptr_restrict;	/* for sysctl */
+
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
diff -puN kernel/sysctl.c~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users kernel/sysctl.c
--- a/kernel/sysctl.c~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users
+++ a/kernel/sysctl.c
@@ -712,6 +712,15 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
+		.procname	= "kptr_restrict",
+		.data		= &kptr_restrict,
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
diff -puN lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users lib/vsprintf.c
--- a/lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users
+++ a/lib/vsprintf.c
@@ -936,6 +936,8 @@ char *uuid_string(char *buf, char *end, 
 	return string(buf, end, uuid, spec);
 }
 
+int kptr_restrict = CONFIG_SECURITY_KPTR_RESTRICT;
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -979,6 +981,7 @@ char *uuid_string(char *buf, char *end, 
  *       Implements a "recursive vsnprintf".
  *       Do not use this feature without some mechanism to verify the
  *       correctness of the format string and va_list arguments.
+ * - 'K' For a kernel pointer that should be hidden from unprivileged users
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1035,6 +1038,21 @@ char *pointer(const char *fmt, char *buf
 		return buf + vsnprintf(buf, end - buf,
 				       ((struct va_format *)ptr)->fmt,
 				       *(((struct va_format *)ptr)->va));
+	case 'K':
+		if (kptr_restrict) {
+			if (in_irq() || in_serving_softirq() || in_nmi())
+				WARN(1, "%%pK used in interrupt context.\n");
+
+			else if (capable(CAP_SYSLOG))
+				break;
+
+			if (spec.field_width == -1) {
+				spec.field_width = 2 * sizeof(void *);
+				spec.flags |= ZEROPAD;
+			}
+			return number(buf, end, 0, spec);
+		}
+		break;
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
diff -puN security/Kconfig~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users security/Kconfig
--- a/security/Kconfig~kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users
+++ a/security/Kconfig
@@ -82,6 +82,18 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_KPTR_RESTRICT
+	bool "Hide kernel pointers from unprivileged users"
+	default n
+	help
+	  This enforces restrictions on unprivileged users reading kernel
+	  addresses via various interfaces, e.g. /proc.
+
+	  If this option is not selected, no restrictions will be enforced
+	  unless the kptr_restrict sysctl is explicitly set to (1).
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

linux-next.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch

