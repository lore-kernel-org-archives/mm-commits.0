From: akpm@linux-foundation.org
Subject: - uml-arch-um-include-inith-needs-a-definition-of-__used.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:15 -0800
Message-ID: <200802052234.m15MYuLx012566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762655AbYBEWm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: arch/um/include/init.h needs a definition of __used
has been removed from the -mm tree.  Its filename was
     uml-arch-um-include-inith-needs-a-definition-of-__used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: arch/um/include/init.h needs a definition of __used
From: Jeff Dike <jdike@addtoit.com>

init.h started breaking now for some reason.  It turns out that there wasn't a
definition of __used.  Fixed this by copying the relevant stuff from
compiler.h in the userspace case, and including compiler.h in the kernel case.

[xiyou.wangcong@gmail.com: added definition of __section]
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/init.h |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN arch/um/include/init.h~uml-arch-um-include-inith-needs-a-definition-of-__used arch/um/include/init.h
--- a/arch/um/include/init.h~uml-arch-um-include-inith-needs-a-definition-of-__used
+++ a/arch/um/include/init.h
@@ -40,6 +40,20 @@
 typedef int (*initcall_t)(void);
 typedef void (*exitcall_t)(void);
 
+#ifndef __KERNEL__
+#ifndef __section
+# define __section(S) __attribute__ ((__section__(#S)))
+#endif
+
+#if __GNUC_MINOR__ >= 3
+# define __used			__attribute__((__used__))
+#else
+# define __used			__attribute__((__unused__))
+#endif
+
+#else
+#include <linux/compiler.h>
+#endif
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
 #define __init		__section(.init.text)
@@ -127,14 +141,3 @@ extern struct uml_param __uml_setup_star
 #endif
 
 #endif /* _LINUX_UML_INIT_H */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
