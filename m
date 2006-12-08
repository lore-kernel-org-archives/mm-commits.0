From: akpm@osdl.org
Subject: - generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:46:00 -0800
Message-ID: <200612080846.kB88k0HX013808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36982 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425196AbWLHItT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:49:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/bug.h must always #include <linux/module.h>
has been removed from the -mm tree.  Its filename was
     generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch

This patch was dropped because it was folded into generic-bug-implementation.patch

------------------------------------------------------
Subject: include/linux/bug.h must always #include <linux/module.h>
From: Adrian Bunk <bunk@stusta.de>

In file included from
/home/bunk/linux/kernel-2.6/linux-2.6.19-rc6-mm1/arch/i386/kernel/traps.c:32:
/home/bunk/linux/kernel-2.6/linux-2.6.19-rc6-mm1/include/linux/bug.h:38: warning: type defaults to 'int' in declaration of 'Elf_Ehdr'
/home/bunk/linux/kernel-2.6/linux-2.6.19-rc6-mm1/include/linux/bug.h:38: error: expected ';', ',' or ')' before '*' token
...

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/bug.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bug.h~generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh include/linux/bug.h
--- a/include/linux/bug.h~generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh
+++ a/include/linux/bug.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_BUG_H
 #define _LINUX_BUG_H
 
+#include <linux/module.h>
 #include <asm/bug.h>
 
 enum bug_trap_type {
@@ -10,7 +11,6 @@ enum bug_trap_type {
 };
 
 #ifdef CONFIG_GENERIC_BUG
-#include <linux/module.h>
 #include <asm-generic/bug.h>
 
 static inline int is_warning_bug(const struct bug_entry *bug)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
generic-bug-implementation.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
make-drivers-md-dm-snapcksnapd-static.patch

