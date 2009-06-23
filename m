From: akpm@linux-foundation.org
Subject: + asm-sections-add-text-data-checking-functions-for-arches-to-override.patch added to -mm tree
Date: Tue, 23 Jun 2009 15:40:33 -0700
Message-ID: <200906232240.n5NMeX4m008236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758053AbZFWWmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 18:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org


The patch titled
     asm/sections: add text/data checking functions for arches to override
has been added to the -mm tree.  Its filename is
     asm-sections-add-text-data-checking-functions-for-arches-to-override.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch

