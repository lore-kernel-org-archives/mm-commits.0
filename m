From: akpm@linux-foundation.org
Subject: + dynamic_debug-only-add-header-when-used.patch added to -mm tree
Date: Wed, 13 Jul 2016 13:34:07 -0700
Message-ID: <5786a5bf.sUEgd8jJV0D9b1z8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbcGMUeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 16:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, bp@suse.de, hidehiro.kawai.ez@hitachi.com, joe@perches.com, linux@rasmusvillemoes.dk, mina86@mina86.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: only add header when used
has been added to the -mm tree.  Its filename is
     dynamic_debug-only-add-header-when-used.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-only-add-header-when-used.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-only-add-header-when-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: dynamic_debug: only add header when used

kernel.h header doesn't directly use dynamic debug, instead we can include
it in module.c (which used it via kernel.h).  printk.h only uses it if
CONFIG_DYNAMIC_DEBUG is on, changing the inclusion to only happen in that
case.

Link: http://lkml.kernel.org/r/1468429793-16917-1-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 -
 include/linux/printk.h |    3 ++-
 kernel/module.c        |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~dynamic_debug-only-add-header-when-used include/linux/kernel.h
--- a/include/linux/kernel.h~dynamic_debug-only-add-header-when-used
+++ a/include/linux/kernel.h
@@ -11,7 +11,6 @@
 #include <linux/log2.h>
 #include <linux/typecheck.h>
 #include <linux/printk.h>
-#include <linux/dynamic_debug.h>
 #include <asm/byteorder.h>
 #include <uapi/linux/kernel.h>
 
diff -puN include/linux/printk.h~dynamic_debug-only-add-header-when-used include/linux/printk.h
--- a/include/linux/printk.h~dynamic_debug-only-add-header-when-used
+++ a/include/linux/printk.h
@@ -286,10 +286,11 @@ extern asmlinkage void dump_stack(void)
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
-#include <linux/dynamic_debug.h>
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG)
+#include <linux/dynamic_debug.h>
+
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
diff -puN kernel/module.c~dynamic_debug-only-add-header-when-used kernel/module.c
--- a/kernel/module.c~dynamic_debug-only-add-header-when-used
+++ a/kernel/module.c
@@ -60,6 +60,7 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
+#include <linux/dynamic_debug.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are

dynamic_debug-only-add-header-when-used.patch
befs-check-return-of-sb_min_blocksize.patch
befs-fix-function-name-in-documentation.patch
befs-remove-unused-functions.patch

