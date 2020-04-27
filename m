From: akpm@linux-foundation.org
Subject: +
 kernel-sysctl-support-handling-command-line-aliases.patch added to -mm tree
Date: Mon, 27 Apr 2020 11:33:52 -0700
Message-ID: <20200427183352.5U6IW36Bq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0Sdy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 14:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, christian.brauner@ubuntu.com, ebiederm@xmission.com, gpiccoli@canonical.com, gregkh@linuxfoundation.org, ivan.teterevkov@nutanix.com, keescook@chromium.org, mcgrof@kernel.org, mhiramat@kernel.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com


The patch titled
     Subject: kernel/sysctl: support handling command line aliases
has been added to the -mm tree.  Its filename is
     kernel-sysctl-support-handling-command-line-aliases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctl-support-handling-command-line-aliases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctl-support-handling-command-line-aliases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: kernel/sysctl: support handling command line aliases

We can now handle sysctl parameters on kernel command line, but
historically some parameters introduced their own command line equivalent,
which we don't want to remove for compatibility reasons.  We can however
convert them to the generic infrastructure with a table translating the
legacy command line parameters to their sysctl names, and removing the
one-off param handlers.

This patch adds the support and makes the first conversion to demonstrate
it, on the (deprecated) numa_zonelist_order parameter.

Link: http://lkml.kernel.org/r/20200427180433.7029-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Guilherme G . Piccoli" <gpiccoli@canonical.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |   48 ++++++++++++++++++++++++++++++++++------
 mm/page_alloc.c       |    9 -------
 2 files changed, 41 insertions(+), 16 deletions(-)

--- a/fs/proc/proc_sysctl.c~kernel-sysctl-support-handling-command-line-aliases
+++ a/fs/proc/proc_sysctl.c
@@ -1694,6 +1694,37 @@ int __init proc_sys_init(void)
 	return sysctl_init();
 }
 
+struct sysctl_alias {
+	const char *kernel_param;
+	const char *sysctl_param;
+};
+
+/*
+ * Historically some settings had both sysctl and a command line parameter.
+ * With the generic sysctl. parameter support, we can handle them at a single
+ * place and only keep the historical name for compatibility. This is not meant
+ * to add brand new aliases. When adding existing aliases, consider whether
+ * the possibly different moment of changing the value (e.g. from early_param
+ * to the moment do_sysctl_args() is called) is an issue for the specific
+ * parameter.
+ */
+static const struct sysctl_alias sysctl_aliases[] = {
+	{"numa_zonelist_order",		"vm.numa_zonelist_order" },
+	{ }
+};
+
+static const char *sysctl_find_alias(char *param)
+{
+	const struct sysctl_alias *alias;
+
+	for (alias = &sysctl_aliases[0]; alias->kernel_param != NULL; alias++) {
+		if (strcmp(alias->kernel_param, param) == 0)
+			return alias->sysctl_param;
+	}
+
+	return NULL;
+}
+
 /* Set sysctl value passed on kernel command line. */
 static int process_sysctl_arg(char *param, char *val,
 			       const char *unused, void *arg)
@@ -1707,15 +1738,18 @@ static int process_sysctl_arg(char *para
 	loff_t pos = 0;
 	ssize_t wret;
 
-	if (strncmp(param, "sysctl", sizeof("sysctl") - 1))
-		return 0;
-
-	param += sizeof("sysctl") - 1;
+	if (strncmp(param, "sysctl", sizeof("sysctl") - 1) == 0) {
+		param += sizeof("sysctl") - 1;
 
-	if (param[0] != '/' && param[0] != '.')
-		return 0;
+		if (param[0] != '/' && param[0] != '.')
+			return 0;
 
-	param++;
+		param++;
+	} else {
+		param = (char *) sysctl_find_alias(param);
+		if (!param)
+			return 0;
+	}
 
 	/*
 	 * To set sysctl options, we use a temporary mount of proc, look up the
--- a/mm/page_alloc.c~kernel-sysctl-support-handling-command-line-aliases
+++ a/mm/page_alloc.c
@@ -5527,15 +5527,6 @@ static int __parse_numa_zonelist_order(c
 	return 0;
 }
 
-static __init int setup_numa_zonelist_order(char *s)
-{
-	if (!s)
-		return 0;
-
-	return __parse_numa_zonelist_order(s);
-}
-early_param("numa_zonelist_order", setup_numa_zonelist_order);
