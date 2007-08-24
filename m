From: akpm@linux-foundation.org
Subject: + remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:25:12 -0700
Message-ID: <200708242325.l7ONPCtK020098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765919AbXHXXZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, lethal@linux-sh.org, satyam@infradead.org


The patch titled
     Remove superfluous definition of __setup_null_param() macro and broken (for MODULE) __setup_param()
has been added to the -mm tree.  Its filename is
     remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove superfluous definition of __setup_null_param() macro and broken (for MODULE) __setup_param()
From: Robert P. J. Day <rpjday@mindspring.com>

Remove superfluous definition of __setup_null_param() macro, as nobody uses
it anymore.

Also kill the #ifdef-MODULE-case (empty) definition for __setup_param.  It
is only required for the !MODULE case, as __setup() is empty for the MODULE
case already.  Also, no user outside init.h must use __setup_null_param
directly anyway (and nobody does), so it's not something whose empty
definition we necessarily need to make available to rest of the kernel. 
Moreover, this MODULE case of __setup_param has been broken for more than
two years now -- as far back as git history takes us.  Let's get rid of it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    5 -----
 1 files changed, 5 deletions(-)

diff -puN include/linux/init.h~remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param include/linux/init.h
--- a/include/linux/init.h~remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param
+++ a/include/linux/init.h
@@ -166,9 +166,6 @@ struct obs_kernel_param {
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }
 
-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
-
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)
 
@@ -234,8 +231,6 @@ void __init parse_early_param(void);
 	{ return exitfn; }					\
 	void cleanup_module(void) __attribute__((alias(#exitfn)));
 
-#define __setup_param(str, unique_id, fn)	/* nothing */
-#define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
