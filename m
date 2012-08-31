From: akpm@linux-foundation.org
Subject: + coredump-make-core-dump-functionality-optional-fix.patch added to -mm tree
Date: Fri, 31 Aug 2012 15:58:49 -0700
Message-ID: <20120831225849.A536D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33500 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2HaW6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 18:58:50 -0400
Received: by yhl10 with SMTP id 10so400863yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 15:58:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, serge.hallyn@canonical.com


The patch titled
     Subject: fs: amended coredump-related sysctl functions
has been added to the -mm tree.  Its filename is
     coredump-make-core-dump-functionality-optional-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Kelly <alex.page.kelly@gmail.com>
Subject: fs: amended coredump-related sysctl functions

This fixes an error introduced in the coredump-header patch in the
coredump removal patch I submitted earlier.  It should be squashed into
that patch series so that the Kconfig option to remove coredump doesn't
cause compile-time errors.

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/sysctl.c~coredump-make-core-dump-functionality-optional-fix kernel/sysctl.c
--- a/kernel/sysctl.c~coredump-make-core-dump-functionality-optional-fix
+++ a/kernel/sysctl.c
@@ -179,8 +179,10 @@ static int proc_dointvec_minmax_sysadmin
 
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
+#ifdef CONFIG_COREDUMP
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
@@ -2040,12 +2042,14 @@ int proc_dointvec_minmax(struct ctl_tabl
 
 static void validate_coredump_safety(void)
 {
+#ifdef CONFIG_COREDUMP
 	if (suid_dumpable == SUID_DUMPABLE_SAFE &&
 	    core_pattern[0] != '/' && core_pattern[0] != '|') {
 		printk(KERN_WARNING "Unsafe core_pattern used with "\
 			"suid_dumpable=2. Pipe handler or fully qualified "\
 			"core dump path required.\n");
 	}
+#endif
 }
 
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
@@ -2057,6 +2061,7 @@ static int proc_dointvec_minmax_coredump
 	return error;
 }
 
+#ifdef CONFIG_COREDUMP
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2065,6 +2070,7 @@ static int proc_dostring_coredump(struct
 		validate_coredump_safety();
 	return error;
 }
+#endif
 
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
_

Patches currently in -mm which might be from alex.page.kelly@gmail.com are

coredump-move-core-dump-functionality-into-its-own-file.patch
coredump-make-core-dump-functionality-optional.patch
coredump-make-core-dump-functionality-optional-fix.patch
coredump-update-coredump-related-headers.patch

