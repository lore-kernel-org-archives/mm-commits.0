From: akpm@linux-foundation.org
Subject: - slim-main-patch-socket_post_create-hook-return-code.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:35 -0800
Message-ID: <200703060210.l262AZt6009019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47011 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbXCFCKk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:10:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: socket_post_create hook return code
has been removed from the -mm tree.  Its filename was
     slim-main-patch-socket_post_create-hook-return-code.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: slim: socket_post_create hook return code
From: Kylene Jo Hall <kjhall@us.ibm.com>

The socket_post_create LSM hook has gone from a void return to an int. 
This patch properly updates the SLIM hook definition and return to reflect
this change.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-of-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN security/slim/slm_main.c~slim-main-patch-socket_post_create-hook-return-code security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-main-patch-socket_post_create-hook-return-code
+++ a/security/slim/slm_main.c
@@ -970,7 +970,7 @@ int slm_socket_create(int family, int ty
 /*
  * Didn't have the family type previously, so update the inode security now.
  */
-static void slm_socket_post_create(struct socket *sock, int family,
+static int slm_socket_post_create(struct socket *sock, int family,
 				   int type, int protocol, int kern)
 {
 	struct slm_tsec_data *cur_tsec = current->security;
@@ -986,6 +986,7 @@ static void slm_socket_post_create(struc
 	} else
 		set_level_untrusted(&slm_isec->level);
 	spin_unlock(&slm_isec->lock);
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-patch-socket_post_create-hook-return-code.patch
slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch
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
