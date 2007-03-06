From: akpm@linux-foundation.org
Subject: - slim-main-patch-handle-failure-to-register.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:42 -0800
Message-ID: <200703060210.l262AgVZ009025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814AbXCFCK5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:10:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: handle failure to register
has been removed from the -mm tree.  Its filename was
     slim-main-patch-handle-failure-to-register.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: slim: handle failure to register
From: Kylene Jo Hall <kjhall@us.ibm.com>

Thanks to Stephen Smalley for pointing out that we need to securely handle
a failure to register with the LSM security hooks.  This patch adds a panic
in the event that the module is unable to register.

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN security/slim/slm_main.c~slim-main-patch-handle-failure-to-register security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-main-patch-handle-failure-to-register
+++ a/security/slim/slm_main.c
@@ -1362,9 +1362,13 @@ int slim_enabled = 1;
 #endif
 static int __init init_slm(void)
 {
+	int rc;
 	if (!slim_enabled)
 		return 0;
 	slm_task_init_alloc_security(current);
-	return register_security(&slm_security_ops);
+	rc = register_security(&slm_security_ops);
+	if (rc != 0)
+		panic("SLIM: Unable to register with kernel\n");
+	return rc;
 }
 security_initcall(init_slm);
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-patch-handle-failure-to-register.patch
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
