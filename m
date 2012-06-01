From: akpm@linux-foundation.org
Subject: [merged] kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:37 -0700
Message-ID: <20120601193337.53137A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52540 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:38 -0400
Received: by mail-ey0-f202.google.com with SMTP id o13so111891eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: convert two call sites to call_usermodehelper_fns()
has been removed from the -mm tree.  Its filename was
     kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -2114,7 +2114,6 @@ int orderly_poweroff(bool force)
 		NULL
 	};
 	int ret = -ENOMEM;
-	struct subprocess_info *info;
 
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
@@ -2122,18 +2121,16 @@ int orderly_poweroff(bool force)
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
