From: akpm@linux-foundation.org
Subject: [merged] kmod-split-call-to-call_usermodehelper_fns.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:09 -0700
Message-ID: <20130507174909.8ED545A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41400 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:11 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so85270yho.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: split call to call_usermodehelper_fns()
has been removed from the -mm tree.  Its filename was
     kmod-split-call-to-call_usermodehelper_fns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: kmod: split call to call_usermodehelper_fns()

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns().  In case the latter returns -ENOMEM the
cleanup function may had not been called - in this case we would not free
argv and module_name.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-split-call-to-call_usermodehelper_fns kernel/kmod.c
--- a/kernel/kmod.c~kmod-split-call-to-call_usermodehelper_fns
+++ a/kernel/kmod.c
@@ -77,6 +77,7 @@ static void free_modprobe_argv(struct su
 
 static int call_modprobe(char *module_name, int wait)
 {
+	struct subprocess_info *info;
 	static char *envp[] = {
 		"HOME=/",
 		"TERM=linux",
@@ -98,8 +99,15 @@ static int call_modprobe(char *module_na
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;
 
-	return call_usermodehelper_fns(modprobe_path, argv, envp,
-		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
+					 NULL, free_modprobe_argv, NULL);
+	if (!info)
+		goto free_module_name;
+
+	return call_usermodehelper_exec(info, wait | UMH_KILLABLE);
+
+free_module_name:
+	kfree(module_name);
 free_argv:
 	kfree(argv);
 out:
_

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

origin.patch

