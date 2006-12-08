From: akpm@osdl.org
Subject: - generic-bug-implementation-handle-bug=n.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:45:52 -0800
Message-ID: <200612080845.kB88jqh5013803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032528AbWLHIrD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@muc.de, benh@kernel.crashing.org, hugh@veritas.com, jeremy@goop.org, michael@ellerman.id.au, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     handle BUG=n
has been removed from the -mm tree.  Its filename was
     generic-bug-implementation-handle-bug=n.patch

This patch was dropped because it was folded into generic-bug-implementation.patch

------------------------------------------------------
Subject: handle BUG=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Handle BUG=n, GENERIC_BUG=n to prevent build errors:

arch/x86_64/kernel/built-in.o: In function `die':
(.text+0x3b3c): undefined reference to `report_bug'
arch/x86_64/kernel/built-in.o: In function `module_arch_cleanup':
(.text+0x10b60): undefined reference to `module_bug_cleanup'
arch/x86_64/kernel/built-in.o: In function `module_finalize':
(.text+0x10c98): undefined reference to `module_bug_finalize'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Hugh Dickens <hugh@veritas.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/bug.h |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff -puN include/linux/bug.h~generic-bug-implementation-handle-bug=n include/linux/bug.h
--- a/include/linux/bug.h~generic-bug-implementation-handle-bug=n
+++ a/include/linux/bug.h
@@ -3,6 +3,12 @@
 
 #include <asm/bug.h>
 
+enum bug_trap_type {
+	BUG_TRAP_TYPE_NONE = 0,
+	BUG_TRAP_TYPE_WARN = 1,
+	BUG_TRAP_TYPE_BUG = 2,
+};
+
 #ifdef CONFIG_GENERIC_BUG
 #include <linux/module.h>
 #include <asm-generic/bug.h>
@@ -12,12 +18,6 @@ static inline int is_warning_bug(const s
 	return bug->flags & BUGFLAG_WARNING;
 }
 
-enum bug_trap_type {
-	BUG_TRAP_TYPE_NONE = 0,
-	BUG_TRAP_TYPE_WARN = 1,
-	BUG_TRAP_TYPE_BUG = 2,
-};
-
 const struct bug_entry *find_bug(unsigned long bugaddr);
 
 enum bug_trap_type report_bug(unsigned long bug_addr);
@@ -29,5 +29,19 @@ void module_bug_cleanup(struct module *)
 /* These are defined by the architecture */
 int is_valid_bugaddr(unsigned long addr);
 
+#else	/* !CONFIG_GENERIC_BUG */
+
+static inline enum bug_trap_type report_bug(unsigned long bug_addr)
+{
+	return BUG_TRAP_TYPE_BUG;
+}
+static inline int  module_bug_finalize(const Elf_Ehdr *hdr,
+					const Elf_Shdr *sechdrs,
+					struct module *mod)
+{
+	return 0;
+}
+static inline void module_bug_cleanup(struct module *mod) {}
+
 #endif	/* CONFIG_GENERIC_BUG */
 #endif	/* _LINUX_BUG_H */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
ext4-calls-journal_stop.patch
generic-bug-implementation.patch
generic-bug-implementation-handle-bug=n.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch

