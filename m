From: akpm@linux-foundation.org
Subject: [folded-dropped] coredump-make-core-dump-functionality-optional-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:01:56 -0700
Message-ID: <20121005000156.78D6D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51821 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2JEAB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:01:57 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so138748qae.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:01:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: amended coredump-related sysctl functions
has been removed from the -mm tree.  Its filename was
     coredump-make-core-dump-functionality-optional-fix.patch

This patch was dropped because it was folded into coredump-make-core-dump-functionality-optional.patch

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

origin.patch
coredump-make-core-dump-functionality-optional.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-update-coredump-related-headers.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch

