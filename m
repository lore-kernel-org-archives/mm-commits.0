From: akpm@linux-foundation.org
Subject: [merged] fs-execc-make-bprm_mm_init-static.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:51:14 -0800
Message-ID: <20130227205114.BB1675A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:59789 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab3B0UvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:51:15 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so111372vch.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:51:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec.c: make bprm_mm_init() static
has been removed from the -mm tree.  Its filename was
     fs-execc-make-bprm_mm_init-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

