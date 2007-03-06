From: akpm@linux-foundation.org
Subject: - slim-secfs-patch-cleanup-use-of-configh.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:11:55 -0800
Message-ID: <200703060211.l262BtaL009049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47111 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848AbXCFCMZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:12:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: cleanup use of config.h
has been removed from the -mm tree.  Its filename was
     slim-secfs-patch-cleanup-use-of-configh.patch

This patch was dropped because it was folded into slim-secfs-patch.patch

------------------------------------------------------
Subject: slim: cleanup use of config.h
From: Kylene Jo Hall <kjhall@us.ibm.com>

The following patch addresses this comment to clean up the use of
config.h in the slim .c files.

On Mon, 2006-09-18 at 16:54 -0400, Dave Jones wrote:
>  > > > +
>  > > > +#include <asm/uaccess.h>
>  > > > +#include <linux/config.h>
>
> You don't need to include config.h any more, kbuild does it for you.
> (Might want to check the other files for the same thing).
>
> 	Dave

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c  |    1 -
 security/slim/slm_secfs.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN security/slim/slm_main.c~slim-secfs-patch-cleanup-use-of-configh security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-secfs-patch-cleanup-use-of-configh
+++ a/security/slim/slm_main.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/mman.h>
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/integrity.h>
diff -puN security/slim/slm_secfs.c~slim-secfs-patch-cleanup-use-of-configh security/slim/slm_secfs.c
--- a/security/slim/slm_secfs.c~slim-secfs-patch-cleanup-use-of-configh
+++ a/security/slim/slm_secfs.c
@@ -11,7 +11,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-secfs-patch-cleanup-use-of-configh.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
