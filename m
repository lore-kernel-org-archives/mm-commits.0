From: akpm@linux-foundation.org
Subject: + split-remaining-calls-to-call_usermodehelper_fns.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:32:40 -0700
Message-ID: <20130312203240.DBA7F5A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:62019 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3CLUcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:32:42 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so32022vea.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:32:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: usermodehelper: split remaining calls to call_usermodehelper_fns()
has been added to the -mm tree.  Its filename is
     split-remaining-calls-to-call_usermodehelper_fns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: usermodehelper: split remaining calls to call_usermodehelper_fns()

These are the only users of call_usermodehelper_fns().  This function
suffers from not being able to determine if the cleanup is called.  Even
if in this places the cleanup pointer is NULL, convert them to use the
separate call_usermodehelper_setup() + call_usermodehelper_exec()
functions so we can remove the _fns variant.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c           |   12 +++++++++---
 init/do_mounts_initrd.c |    8 ++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff -puN fs/coredump.c~split-remaining-calls-to-call_usermodehelper_fns fs/coredump.c
--- a/fs/coredump.c~split-remaining-calls-to-call_usermodehelper_fns
+++ a/fs/coredump.c
@@ -525,6 +525,7 @@ void do_coredump(siginfo_t *siginfo)
 	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
+		struct subprocess_info *sub_info;
 
 		if (ispipe < 0) {
 			printk(KERN_WARNING "format_corename failed\n");
@@ -571,9 +572,14 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
-					NULL, UMH_WAIT_EXEC, umh_pipe_setup,
-					NULL, &cprm);
+		retval = -ENOMEM;
+		sub_info = call_usermodehelper_setup(helper_argv[0],
+						helper_argv, NULL, GFP_KERNEL,
+						umh_pipe_setup, NULL, &cprm);
+		if (sub_info)
+			retval = call_usermodehelper_exec(sub_info,
+							  UMH_WAIT_EXEC);
+
 		argv_free(helper_argv);
 		if (retval) {
 			printk(KERN_INFO "Core dump to %s pipe failed\n",
diff -puN init/do_mounts_initrd.c~split-remaining-calls-to-call_usermodehelper_fns init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~split-remaining-calls-to-call_usermodehelper_fns
+++ a/init/do_mounts_initrd.c
@@ -50,6 +50,7 @@ static int init_linuxrc(struct subproces
 
 static void __init handle_initrd(void)
 {
+	struct subprocess_info *info;
 	static char *argv[] = { "linuxrc", NULL, };
 	extern char *envp_init[];
 	int error;
@@ -70,8 +71,11 @@ static void __init handle_initrd(void)
 	 */
 	current->flags |= PF_FREEZER_SKIP;
 
-	call_usermodehelper_fns("/linuxrc", argv, envp_init, UMH_WAIT_PROC,
-			init_linuxrc, NULL, NULL);
+	info = call_usermodehelper_setup("/linuxrc", argv, envp_init,
+					 GFP_KERNEL, init_linuxrc, NULL, NULL);
+	if (!info)
+		return;
+	call_usermodehelper_exec(info, UMH_WAIT_PROC);
 
 	current->flags &= ~PF_FREEZER_SKIP;
 
_

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch

