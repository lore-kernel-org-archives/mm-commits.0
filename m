From: akpm@linux-foundation.org
Subject: - panic-on-slim-selinux.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:15:56 -0800
Message-ID: <200703060215.l262Fu3m009166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965749AbXCFCQv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, chrisw@sous-sol.org, jmorris@namei.org, kjhall@us.ibm.com, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     panic on SLIM + selinux
has been removed from the -mm tree.  Its filename was
     panic-on-slim-selinux.patch

This patch was dropped because it was folded into slim-make-and-config-stuff.patch

------------------------------------------------------
Subject: panic on SLIM + selinux
From: Daniel Walker <dwalker@mvista.com>

If you have both SLIM and selinux compiled into your kernel selinux will
panic if it can't register itself.  The code below,

if (register_security (&selinux_ops))
	panic("SELinux: Unable to register with kernel.\n");

"security/selinux/hooks.c" 5014 lines --95%--                                                                           4811,35       96%

This could be a bug report cause I bet there's a better way to make these
mutually exclusive.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Dave Safford <safford@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <sergeh@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN security/slim/Kconfig~panic-on-slim-selinux security/slim/Kconfig
--- a/security/slim/Kconfig~panic-on-slim-selinux
+++ a/security/slim/Kconfig
@@ -1,6 +1,6 @@
 config SECURITY_SLIM
 	boolean "SLIM support"
-	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
+	depends on SECURITY && SECURITY_NETWORK && INTEGRITY && !SECURITY_SELINUX
 	help
 	  The Simple Linux Integrity Module implements a modified low water-mark
 	  mandatory access control integrity model.
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
slim-make-and-config-stuff.patch
panic-on-slim-selinux.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
profile-likely-unlikely-macros-x86_64-fix.patch
