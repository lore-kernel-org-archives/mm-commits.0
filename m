From: akpm@linux-foundation.org
Subject: [merged] asm-sections-add-text-data-checking-functions-for-arches-to-override.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:42 -0700
Message-ID: <200909231953.n8NJrgNt031664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbZIWUDz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     asm/sections: add text/data checking functions for arches to override
has been removed from the -mm tree.  Its filename was
     asm-sections-add-text-data-checking-functions-for-arches-to-override.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm/sections: add text/data checking functions for arches to override
From: Mike Frysinger <vapier@gentoo.org>

Some ports (like the Blackfin arch) have a discontiguous memory map which
means there may be text or data that falls outside of the standard range
of the start/end text/data symbols.  Creating some helper functions allows
these non-standard ports to declare these regions without adversely
affecting anyone else.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/asm-generic/sections.h~asm-sections-add-text-data-checking-functions-for-arches-to-override include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~asm-sections-add-text-data-checking-functions-for-arches-to-override
+++ a/include/asm-generic/sections.h
@@ -23,4 +23,20 @@ extern char __ctors_start[], __ctors_end
 #define dereference_function_descriptor(p) (p)
 #endif
 
+/* random extra sections (if any).  Override
+ * in asm/sections.h */
+#ifndef arch_is_kernel_text
+static inline int arch_is_kernel_text(unsigned long addr)
+{
+	return 0;
+}
+#endif
+
+#ifndef arch_is_kernel_data
+static inline int arch_is_kernel_data(unsigned long addr)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

