From: akpm@linux-foundation.org
Subject: - slim-main-patch-fix-bug-with-mm_users-usage.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:45 -0800
Message-ID: <200703060210.l262Ajk6009028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47022 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbXCFCKw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:10:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: fix bug with mm_users usage
has been removed from the -mm tree.  Its filename was
     slim-main-patch-fix-bug-with-mm_users-usage.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: slim: fix bug with mm_users usage
From: Kylene Jo Hall <kjhall@us.ibm.com>

There is a NULL pointer dereference possible that was introduced in the
last round of modifications to the demotion code before merging. 
current->mm should be checked for existence before it is dereferenced to
check the value of the mm_users field.  This patch fixes all instances of
this bug.

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN security/slim/slm_main.c~slim-main-patch-fix-bug-with-mm_users-usage security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-main-patch-fix-bug-with-mm_users-usage
+++ a/security/slim/slm_main.c
@@ -481,7 +481,7 @@ static int enforce_integrity_read(struct
 	spin_lock(&cur_tsec->lock);
 	if (!is_iac_less_than_or_exempt(level, cur_tsec->iac_r)) {
 		rc = has_file_wperm(level);
-		if (atomic_read(&current->mm->mm_users) != 1)
+		if (current->mm && atomic_read(&current->mm->mm_users) != 1)
 			rc = 1;
 		if (rc)
 			spin_unlock(&cur_tsec->lock);
@@ -939,7 +939,7 @@ int slm_socket_create(int family, int ty
 			memset(&level, 0, sizeof(struct slm_file_xattr));
 			level.iac_level = SLM_IAC_UNTRUSTED;
 			rc = has_file_wperm(&level);
-			if (atomic_read(&current->mm->mm_users) != 1)
+			if (current->mm && atomic_read(&current->mm->mm_users) != 1)
 				rc = 1;
 			if (rc) {
 				spin_unlock(&cur_tsec->lock);
@@ -1094,7 +1094,7 @@ static int enforce_integrity_execute(str
 		cur_tsec->iac_r = cur_tsec->iac_wx;
 	else {
 		rc = has_file_wperm(level);
-		if (atomic_read(&current->mm->mm_users) != 1)
+		if (current->mm && atomic_read(&current->mm->mm_users) != 1)
 			rc = 1;
 		if (rc)
 			spin_unlock(&cur_tsec->lock);
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-patch-fix-bug-with-mm_users-usage.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-secfs-patch-slim-correct-use-of-snprintf.patch
slim-secfs-patch-cleanup-use-of-configh.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
