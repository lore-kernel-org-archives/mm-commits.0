From: akpm@linux-foundation.org
Subject: + selinux-always-initialize-arguments-to-security_sid_to_context.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:33:00 -0800
Message-ID: <200702272033.l1RKX4T8027490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbXB0UdM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:33:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sds@tycho.nsa.gov


The patch titled
     selinux:  always initialize arguments to security_sid_to_context
has been added to the -mm tree.  Its filename is
     selinux-always-initialize-arguments-to-security_sid_to_context.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

selinux-always-initialize-arguments-to-security_sid_to_context.patch
git-mips.patch
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
