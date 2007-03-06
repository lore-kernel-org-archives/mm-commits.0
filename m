From: akpm@linux-foundation.org
Subject: - slim-make-and-config-stuff-makefile-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:12:13 -0800
Message-ID: <200703060212.l262CDMB009052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847AbXCFCMT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: makefile fix
has been removed from the -mm tree.  Its filename was
     slim-make-and-config-stuff-makefile-fix.patch

This patch was dropped because it was folded into slim-make-and-config-stuff.patch

------------------------------------------------------
Subject: slim: makefile fix
From: Kylene Jo Hall <kjhall@us.ibm.com>

Thanks to Stephen Smalley for pointing out that slim was added to the wrong
place in the Makefile.  This patch fixes the problem.

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN security/Makefile~slim-make-and-config-stuff-makefile-fix security/Makefile
--- a/security/Makefile~slim-make-and-config-stuff-makefile-fix
+++ a/security/Makefile
@@ -3,7 +3,6 @@
 #
 
 obj-$(CONFIG_KEYS)			+= keys/
-obj-$(CONFIG_SECURITY_SLIM)		+= slim/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 
 # if we don't select a security model, use the default capabilities
@@ -15,6 +14,7 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 obj-$(CONFIG_INTEGRITY)		+= integrity.o integrity_dummy.o
 # Must precede capability.o in order to stack properly.
+obj-$(CONFIG_SECURITY_SLIM)		+= slim/
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
