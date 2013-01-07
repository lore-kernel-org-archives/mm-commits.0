From: akpm@linux-foundation.org
Subject: + fs-execc-make-bprm_mm_init-static.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:24:47 -0800
Message-ID: <20130107212447.F31ED200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:36396 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3AGVYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:24:50 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so1267823fav.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:24:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com


The patch titled
     Subject: fs/exec.c: make bprm_mm_init() static
has been added to the -mm tree.  Its filename is
     fs-execc-make-bprm_mm_init-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: fs/exec.c: make bprm_mm_init() static

There is only one user of bprm_mm_init, and it's inside the same file.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    2 +-
 include/linux/binfmts.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-make-bprm_mm_init-static fs/exec.c
--- a/fs/exec.c~fs-execc-make-bprm_mm_init-static
+++ a/fs/exec.c
@@ -355,7 +355,7 @@ static bool valid_arg_len(struct linux_b
  * flags, permissions, and offset, so we use temporary values.  We'll update
  * them later in setup_arg_pages().
  */
-int bprm_mm_init(struct linux_binprm *bprm)
+static int bprm_mm_init(struct linux_binprm *bprm)
 {
 	int err;
 	struct mm_struct *mm = NULL;
diff -puN include/linux/binfmts.h~fs-execc-make-bprm_mm_init-static include/linux/binfmts.h
--- a/include/linux/binfmts.h~fs-execc-make-bprm_mm_init-static
+++ a/include/linux/binfmts.h
@@ -111,7 +111,6 @@ extern int suid_dumpable;
 extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);
-extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

fs-execc-make-bprm_mm_init-static.patch

