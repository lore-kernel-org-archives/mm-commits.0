From: akpm@linux-foundation.org
Subject: [merged] kmod-unexport-call_usermodehelper_freeinfo.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:35 -0700
Message-ID: <20120601193335.4C031A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36653 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:36 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so140668eei.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: unexport call_usermodehelper_freeinfo()
has been removed from the -mm tree.  Its filename was
     kmod-unexport-call_usermodehelper_freeinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from bharrosh@panasas.com are

origin.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch

