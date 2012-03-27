From: akpm@linux-foundation.org
Subject: + kmod-unexport-call_usermodehelper_freeinfo.patch added to -mm tree
Date: Tue, 27 Mar 2012 14:07:17 -0700
Message-ID: <20120327210718.6792BA032F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59909 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2C0VHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 17:07:19 -0400
Received: by qabg24 with SMTP id g24so73962qab.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 14:07:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: kmod: unexport call_usermodehelper_freeinfo()
has been added to the -mm tree.  Its filename is
     kmod-unexport-call_usermodehelper_freeinfo.patch

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
Subject: kmod: unexport call_usermodehelper_freeinfo()

call_usermodehelper_freeinfo() is not used outside of kmod.c.  So unexport
it, and make it static to kmod.c

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    4 ----
 kernel/kmod.c        |    3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/kmod.h~kmod-unexport-call_usermodehelper_freeinfo include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-unexport-call_usermodehelper_freeinfo
+++ a/include/linux/kmod.h
@@ -79,10 +79,6 @@ void call_usermodehelper_setfns(struct s
 /* Actually execute the sub-process */
 int call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
-/* Free the subprocess_info. This is only needed if you're not going
-   to call call_usermodehelper_exec */
-void call_usermodehelper_freeinfo(struct subprocess_info *info);
-
 static inline int
 call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
 			int (*init)(struct subprocess_info *info, struct cred *new),
diff -puN kernel/kmod.c~kmod-unexport-call_usermodehelper_freeinfo kernel/kmod.c
--- a/kernel/kmod.c~kmod-unexport-call_usermodehelper_freeinfo
+++ a/kernel/kmod.c
@@ -221,13 +221,12 @@ fail:
 	return 0;
 }
 
-void call_usermodehelper_freeinfo(struct subprocess_info *info)
+static void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
 		(*info->cleanup)(info);
 	kfree(info);
 }
-EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
 static void umh_complete(struct subprocess_info *sub_info)
 {
_
Subject: Subject: kmod: unexport call_usermodehelper_freeinfo()

Patches currently in -mm which might be from bharrosh@panasas.com are

origin.patch
linux-next.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch

