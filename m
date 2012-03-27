From: akpm@linux-foundation.org
Subject: + kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch added to -mm tree
Date: Tue, 27 Mar 2012 14:07:20 -0700
Message-ID: <20120327210720.1F077A032F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:64401 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab2C0VHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 17:07:21 -0400
Received: by yenq2 with SMTP id q2so53054yen.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 14:07:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: kmod: convert two call sites to call_usermodehelper_fns()
has been added to the -mm tree.  Its filename is
     kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: kmod: convert two call sites to call_usermodehelper_fns()

Both kernel/sys.c && security/keys/request_key.c where inlining the exact
same code as call_usermodehelper_fns(); So simply convert these sites to
directly use call_usermodehelper_fns().

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c                |   19 ++++++++-----------
 security/keys/request_key.c |   13 +++----------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff -puN kernel/sys.c~kmod-convert-two-call-sites-to-call_usermodehelper_fns kernel/sys.c
--- a/kernel/sys.c~kmod-convert-two-call-sites-to-call_usermodehelper_fns
+++ a/kernel/sys.c
@@ -2022,7 +2022,6 @@ int orderly_poweroff(bool force)
 		NULL
 	};
 	int ret = -ENOMEM;
-	struct subprocess_info *info;
 
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
@@ -2030,18 +2029,16 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
-	if (info == NULL) {
-		argv_free(argv);
-		goto out;
-	}
+	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
+				      NULL, argv_cleanup, NULL);
+out:
+	if (likely(!ret))
+		return 0;
 
-	call_usermodehelper_setfns(info, NULL, argv_cleanup, NULL);
-
-	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
+	if (ret == -ENOMEM)
+		argv_free(argv);
 
-  out:
-	if (ret && force) {
+	if (force) {
 		printk(KERN_WARNING "Failed to start orderly shutdown: "
 		       "forcing the issue\n");
 
diff -puN security/keys/request_key.c~kmod-convert-two-call-sites-to-call_usermodehelper_fns security/keys/request_key.c
--- a/security/keys/request_key.c~kmod-convert-two-call-sites-to-call_usermodehelper_fns
+++ a/security/keys/request_key.c
@@ -93,16 +93,9 @@ static void umh_keys_cleanup(struct subp
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 					struct key *session_keyring, int wait)
 {
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-	struct subprocess_info *info =
-		call_usermodehelper_setup(path, argv, envp, gfp_mask);
-
-	if (!info)
-		return -ENOMEM;
