From: akpm@linux-foundation.org
Subject: - selinux-always-initialize-arguments-to-security_sid_to_context.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:51:31 -0800
Message-ID: <200702282351.l1SNpV4P030928@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48138 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbXB1Xvh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     selinux:  always initialize arguments to security_sid_to_context
has been removed from the -mm tree.  Its filename was
     selinux-always-initialize-arguments-to-security_sid_to_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: selinux:  always initialize arguments to security_sid_to_context
From: Stephen Smalley <sds@tycho.nsa.gov>

Always initialize *scontext and *scontext_len in security_sid_to_context.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/ss/services.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN security/selinux/ss/services.c~selinux-always-initialize-arguments-to-security_sid_to_context security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~selinux-always-initialize-arguments-to-security_sid_to_context
+++ a/security/selinux/ss/services.c
@@ -609,6 +609,9 @@ int security_sid_to_context(u32 sid, cha
 	struct context *context;
 	int rc = 0;
 
+	*scontext = NULL;
+	*scontext_len  = 0;
+
 	if (!ss_initialized) {
 		if (sid <= SECINITSID_NUM) {
 			char *scontextp;
_

Patches currently in -mm which might be from sds@tycho.nsa.gov are

git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-documentation.patch
panic-on-slim-selinux.patch
