From: akpm@linux-foundation.org
Subject: + kmod-split-call-to-call_usermodehelper_fns.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:32:34 -0700
Message-ID: <20130312203234.D94575A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:64941 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3CLUcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:32:36 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so32202qea.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:32:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: kmod: split call to call_usermodehelper_fns()
has been added to the -mm tree.  Its filename is
     kmod-split-call-to-call_usermodehelper_fns.patch

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

kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch

