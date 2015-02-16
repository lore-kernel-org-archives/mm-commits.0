From: akpm@linux-foundation.org
Subject: [merged] init-remove-config_init_fallback.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 12:18:43 -0800
Message-ID: <54e250a3.CNtGeWokWNwsR0AD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbBPUTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, cebbert.lkml@gmail.com, frowand.list@gmail.com, josh@joshtriplett.org, rdunlap@infradead.org, rob@landley.net, rusty@rustcorp.com.au, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init: remove CONFIG_INIT_FALLBACK
has been removed from the -mm tree.  Its filename was
     init-remove-config_init_fallback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: init: remove CONFIG_INIT_FALLBACK

CONFIG_INIT_FALLBACK adds config bloat without an obvious use case that
makes it worth keeping around.  Delete it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 ----------------
 init/main.c  |    5 -----
 2 files changed, 21 deletions(-)

diff -puN init/Kconfig~init-remove-config_init_fallback init/Kconfig
--- a/init/Kconfig~init-remove-config_init_fallback
+++ a/init/Kconfig
@@ -1287,22 +1287,6 @@ source "usr/Kconfig"
 
 endif
 
-config INIT_FALLBACK
-	bool "Fall back to defaults if init= parameter is bad"
-	default y
-	help
-	  If enabled, the kernel will try the default init binaries if an
-	  explicit request from the init= parameter fails.
-
-	  This can have unexpected effects.  For example, booting
-	  with init=/sbin/kiosk_app will run /sbin/init or even /bin/sh
-	  if /sbin/kiosk_app cannot be executed.
-
-	  The default value of Y is consistent with historical behavior.
-	  Selecting N is likely to be more appropriate for most uses,
-	  especially on kiosks and on kernels that are intended to be
-	  run under the control of a script.
-
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
 	help
diff -puN init/main.c~init-remove-config_init_fallback init/main.c
--- a/init/main.c~init-remove-config_init_fallback
+++ a/init/main.c
@@ -953,13 +953,8 @@ static int __ref kernel_init(void *unuse
 		ret = run_init_process(execute_command);
 		if (!ret)
 			return 0;
-#ifndef CONFIG_INIT_FALLBACK
 		panic("Requested init %s failed (error %d).",
 		      execute_command, ret);
-#else
-		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
-		       execute_command, ret);
-#endif
 	}
 	if (!try_to_run_init_process("/sbin/init") ||
 	    !try_to_run_init_process("/etc/init") ||
_

Patches currently in -mm which might be from luto@amacapital.net are

origin.patch
seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch
linux-next.patch

