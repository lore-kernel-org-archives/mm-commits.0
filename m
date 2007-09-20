From: akpm@linux-foundation.org
Subject: + remove-superfluous-definition-of-__setup_null_param-macro.patch added to -mm tree
Date: Thu, 20 Sep 2007 16:26:14 -0700
Message-ID: <200709202326.l8KNQEUP008059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbXITX0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 19:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove superfluous definition of __setup_null_param macro  and associated content
has been added to the -mm tree.  Its filename is
     remove-superfluous-definition-of-__setup_null_param-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove superfluous definition of __setup_null_param macro  and associated content
From: "Robert P. J. Day" <rpjday@mindspring.com>

Given that there are no references to the __setup_null_param() macro
anymore, we can do the following cleanups in include/linux/init.h:

* Remove the definition of that macro.
* Remove the #ifdef-MODULE-case (empty) definition for __setup_param,
  since it's no longer required, either.
* Combine the 2nd and 3rd arguments for __setup and early_param since
  they only ever needed to be separate to support __setup_null_param
  and there's no need for that anymore.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff -puN include/linux/init.h~remove-superfluous-definition-of-__setup_null_param-macro include/linux/init.h
--- a/include/linux/init.h~remove-superfluous-definition-of-__setup_null_param-macro
+++ a/include/linux/init.h
@@ -158,24 +158,21 @@ struct obs_kernel_param {
  * Force the alignment so the compiler doesn't space elements of the
  * obs_kernel_param "array" too far apart in .init.setup.
  */
-#define __setup_param(str, unique_id, fn, early)			\
-	static char __setup_str_##unique_id[] __initdata = str;	\
-	static struct obs_kernel_param __setup_##unique_id	\
+#define __setup_param(str, fn, early)				\
+	static char __setup_str_##fn[] __initdata = str;	\
+	static struct obs_kernel_param __setup_##fn		\
 		__attribute_used__				\
 		__attribute__((__section__(".init.setup")))	\
 		__attribute__((aligned((sizeof(long)))))	\
-		= { __setup_str_##unique_id, fn, early }
-
-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
+		= { __setup_str_##fn, fn, early }
 
 #define __setup(str, fn)					\
-	__setup_param(str, fn, fn, 0)
+	__setup_param(str, fn, 0)
 
 /* NOTE: fn is as per module_param, not __setup!  Emits warning if fn
  * returns non-zero. */
 #define early_param(str, fn)					\
-	__setup_param(str, fn, fn, 1)
+	__setup_param(str, fn, 1)
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
@@ -234,8 +231,6 @@ void __init parse_early_param(void);
 	{ return exitfn; }					\
 	void cleanup_module(void) __attribute__((alias(#exitfn)));
 
-#define __setup_param(str, unique_id, fn)	/* nothing */
-#define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
m32r-serial-remove-m32r_sio_share_irqs.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-superfluous-definition-of-__setup_null_param-macro.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
documentation-delete-unreferenced-xterm-linuxxpm-file.patch
